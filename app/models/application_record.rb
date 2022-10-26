class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def log(str)
    puts("*******************************************")
    puts(str)
    puts("*******************************************")
  end
end
