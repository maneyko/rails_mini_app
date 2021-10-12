
return unless defined?(Hirb)

Hirb.enable

# Hirber conditionally adds support for different consoles via +elsif+ blocks.
# https://github.com/hirber/hirber/issues/6
if defined?(Pry) && !Rails.env.production? && ENV["ENABLE_HIRB_PATCH"]
  TempPry = Pry
  Object.__send__(:remove_const, :Pry)
  Hirb.enable
  Pry = TempPry
  Object.__send__(:remove_const, :TempPry)
end
