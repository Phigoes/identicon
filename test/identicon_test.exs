defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  test "hash_input makes 16 index position" do
    hex_length = length(Identicon.hash_input("Philipp").hex)
    assert hex_length == 16
  end
end
