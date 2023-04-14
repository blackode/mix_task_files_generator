defmodule Mix.Tasks.Sms.Gen.Integration.School do
  @moduledoc """
  Generates a school integration.

  ## Examples
      mix sms.gen.integration.school school_name
      mix sms.gen.integration.school school_name -p my_schools
      mix sms.gen.integration.school school_name --schools_path my_schools
      mix sms.gen.integration.school delhi_public -m DelhiSchool
      mix sms.gen.integration.school delhi_public --module_name DelhiSchool

  By default, the schools will be generated to the
  "lib/schools" directory of the current application
  but it can be modified to be any subdirectory of `lib` by
  specifying the `--schools_path` option.

  ## Command line options
    * `-m`, `--module_name` - the module name to be used for school by default it uses school name
    * `-p`, `--schools_path` - the schools path to be used by default it uses "lib/schools"

  """

  use Mix.Task

  import Macro, only: [camelize: 1, underscore: 1]
  import Mix.Generator

  @shortdoc "Generates a new school integration"
  @aliases [
    p: :schools_path,
    m: :module_name
  ]

  @switches [
    schools_path: :string,
    module_name: [:string, :keep]
  ]

  @files ~w[administration.ex teachers.ex students.ex]

  @impl true
  def run(args) do
    case OptionParser.parse!(args, strict: @switches, aliases: @aliases) do
      {opts, [school_name]} ->
        schools_path = opts[:schools_path] || "schools"
        name = underscore(school_name)
        dir = Path.join(["lib", schools_path, name])
        unless File.dir?(dir), do: create_directory(dir)

        module = opts[:module_name] || "#{camelize(schools_path)}.#{camelize(school_name)}"
        module_name = "Sms.#{module}"

        files = generate_files(dir, module_name)
        display_shell_info(files)

      {_, _} ->
        message =
          "Expected sms.gen.integration.school to receive the school name, got: #{inspect(Enum.join(args, ""))}"

        Mix.raise(message)
    end
  end

  defp generate_files(dir, module_name) do
    Enum.map(@files, &generate_file(dir, &1, module_name))
  end

  defp generate_file(dir, file_name, module_name) do
    file_path = Path.join(dir, file_name)

    if Path.wildcard(file_path) != [] do
      Mix.raise(
        "File #{file_path} can't be created, there is already a file with name #{file_name}."
      )
    end

    file_template = get_file_template(file_name, module_name)
    create_file(file_path, file_template)
    file_path
  end

  defp get_file_template(file_name, module_name) do
    case file_name do
      "administration.ex" -> administration_template(mod_name: "#{module_name}.Administration")
      "students.ex" -> students_template(mod_name: "#{module_name}.Students")
      "teachers.ex" -> teachers_template(mod_name: "#{module_name}.Teachers")
    end
  end

  defp display_shell_info(files) do
    files_info =
      files
      |> Enum.with_index(1)
      |> Enum.map(fn {file, index} ->
        "#{index}. #{file}"
      end)
      |> Enum.join("\n")

    info = """
      
    ------------* FILES GENERATED *----------
    The following files has been generated :)
      
    #{files_info}
    --------------------*---------------------
      
    """

    Mix.shell().info(info)
  end

  # Code Modules 
  embed_template(:administration, """

  defmodule <%= @mod_name %> do
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
  """)

  embed_template(:teachers, """
  defmodule <%= @mod_name %> do
    @moduledoc false

    @spec get(id :: String.t()) :: map()
    def get(_teacher_id) do 
      #TODO Get Teacher Details
      %{}
    end
  end
  """)

  embed_template(:students, """
  defmodule <%= @mod_name %> do
    @moduledoc false

    @spec get(id :: String.t()) :: map()
    def get(student_id) do 
      #TODO Get Student Details
      %{}
    end

  end
  """)
end
