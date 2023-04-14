# Sms.Gen.Integration.School
![image](https://user-images.githubusercontent.com/9107477/232107760-40874dbb-853c-483c-9096-f0bf686ac70f.png)

## Usage
```elixir
      mix sms.gen.integration.school school_name
      mix sms.gen.integration.school school_name -p my_schools
      mix sms.gen.integration.school school_name --schools_path my_schools
      mix sms.gen.integration.school delhi_public -m DelhiSchool
      mix sms.gen.integration.school delhi_public --module_name DelhiSchool

```
## Command line options

* `-m`, `--module_name` - the module name to be used for school by default it uses school name
* `-p`, `--schools_path` - the schools path to be used by default it uses "lib/schools"
