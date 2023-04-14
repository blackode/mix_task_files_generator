
defmodule Sms.DelhiSchool.Administration do
  @moduledoc false
  
  @spec list_teachers(keyword()) :: [map()]
  def list_teachers(_opts) do
    #TODO listing of teachers
    [%{}]
  end

  @spec list_students(String.t()) :: [map()]
  def list_students(_class) do
    #TODO listing of students by class
    [%{}]
  end
end
