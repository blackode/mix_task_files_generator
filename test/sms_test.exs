defmodule SmsTest do
  use ExUnit.Case
  doctest Sms

  test "greets the world" do
    assert Sms.hello() == :world
  end
end
