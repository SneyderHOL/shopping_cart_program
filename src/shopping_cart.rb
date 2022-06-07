require_relative 'model/product'
require_relative 'model/order'
require_relative 'view/prompt'
require_relative 'action/actions'
require_relative 'model/cart'

class ShoppingCart
  def start
    Action::Actions.login
    until main_menu; end
  end

  private

  def main_menu
    View::Prompt.main_menu
    input = gets.chomp.downcase
    exit_program if input == 'q'

    Action::Actions.main_menu(input)
  end

  def exit_program
    View::Prompt.exit_program
    exit
  end
end

app = ShoppingCart.new
loop do
  app.start
end
