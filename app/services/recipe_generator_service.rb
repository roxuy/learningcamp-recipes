# frozen_string_literal: true

class RecipeGeneratorService
  attr_reader :message, :user

  OPENAI_TEMPERATURE = ENV.fetch('OPENAI_TEMPERATURE', 0).to_f
  OPENAI_MODEL = ENV.fetch('OPENAI_MODEL', 'gpt-4')

  def initialize(message, user_id)
    @message = message
    @user = User.find(user_id)
  end

  def call
    check_valid_message_length
    response = message_to_chat_api
    create_recipe(response)
  end

  private

  def check_valid_message_length
    error_msg = I18n.t('api.errors.invalid_message_length')
    raise RecipeGeneratorServiceError, error_msg unless !!(message =~ /\b\w+\b/)
  end

  def message_to_chat_api
    openai_client.chat(parameters: {
                         model: OPENAI_MODEL,
                         messages: request_messages,
                         temperature: OPENAI_TEMPERATURE
                       })
  end

  def request_messages
    system_message + new_message
  end

  def system_message
    [{ role: 'system', content: prompt }]
  end

  def prompt
    <<~CONTENT
      Write a recipe following these rules:
      1) The recipe MUST include only the ingredients provided.
      2) Every preference MUST be incorporated into the recipe.
      3) The recipe MUST exclude any ingredients listed as restrictions.
      4) Your response MUST be in JSON format, as this example:
      { "name": "Dish Name",
        "content": "Recipe instructions" }
    CONTENT
  end

  def new_message
    [
      { role: 'user', content: "Ingredients: #{message}, Preferences: #{preferences}, Restrictions: #{restrictions}" }
    ]
  end

  def user_preferences(restriction)
    @user_preferences ||= @user.preferences.where(restriction:).map(&:description).join(', ')
  end

  def restrictions
    user_preferences(true)
  end

  def preferences
    user_preferences(false)
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def create_recipe(response)
    parsed_response = response.is_a?(String) ? JSON.parse(response) : response
    content = JSON.parse(parsed_response.dig('choices', 0, 'message', 'content'))
    recipe = @user.recipes.build(name: content['name'], description: content['content'], ingredients: @message)
  rescue JSON::ParserError => exception
    raise RecipeGeneratorServiceError, exception.message
  end
end
