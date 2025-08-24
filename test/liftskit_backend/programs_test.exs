defmodule LiftskitBackend.ProgramsTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.Programs

  describe "programs" do
    alias LiftskitBackend.Programs.Program

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.ProgramsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_programs/1 returns all scoped programs" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      program = program_fixture(scope)
      other_program = program_fixture(other_scope)
      assert Programs.list_programs(scope) == [program]
      assert Programs.list_programs(other_scope) == [other_program]
    end

    test "get_program!/2 returns the program with given id" do
      scope = user_scope_fixture()
      program = program_fixture(scope)
      other_scope = user_scope_fixture()
      assert Programs.get_program!(scope, program.id) == program
      assert_raise Ecto.NoResultsError, fn -> Programs.get_program!(other_scope, program.id) end
    end

    test "create_program/2 with valid data creates a program" do
      valid_attrs = %{name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %Program{} = program} = Programs.create_program(scope, valid_attrs)
      assert program.name == "some name"
      assert program.description == "some description"
      assert program.user_id == scope.user.id
    end

    test "create_program/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Programs.create_program(scope, @invalid_attrs)
    end

    test "update_program/3 with valid data updates the program" do
      scope = user_scope_fixture()
      program = program_fixture(scope)
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Program{} = program} = Programs.update_program(scope, program, update_attrs)
      assert program.name == "some updated name"
      assert program.description == "some updated description"
    end

    test "update_program/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      program = program_fixture(scope)

      assert_raise MatchError, fn ->
        Programs.update_program(other_scope, program, %{})
      end
    end

    test "update_program/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      program = program_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Programs.update_program(scope, program, @invalid_attrs)
      assert program == Programs.get_program!(scope, program.id)
    end

    test "delete_program/2 deletes the program" do
      scope = user_scope_fixture()
      program = program_fixture(scope)
      assert {:ok, %Program{}} = Programs.delete_program(scope, program)
      assert_raise Ecto.NoResultsError, fn -> Programs.get_program!(scope, program.id) end
    end

    test "delete_program/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      program = program_fixture(scope)
      assert_raise MatchError, fn -> Programs.delete_program(other_scope, program) end
    end

    test "change_program/2 returns a program changeset" do
      scope = user_scope_fixture()
      program = program_fixture(scope)
      assert %Ecto.Changeset{} = Programs.change_program(scope, program)
    end
  end
end
