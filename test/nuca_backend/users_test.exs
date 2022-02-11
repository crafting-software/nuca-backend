defmodule NucaBackend.UsersTest do
  use NucaBackend.DataCase

  alias NucaBackend.Users

  describe "user" do
    alias NucaBackend.Users.User

    import NucaBackend.UsersFixtures

    @invalid_attrs %{
      email: nil,
      full_name: nil,
      inactive_since: nil,
      password_hash: nil,
      phone: nil,
      role: nil,
      username: nil
    }

    test "list_user/0 returns all user" do
      user = user_fixture()
      assert Users.list_user() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "some email",
        full_name: "some full_name",
        inactive_since: ~N[2022-02-10 10:02:00],
        password_hash: "some password_hash",
        phone: "some phone",
        role: "some role",
        username: "some username"
      }

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.full_name == "some full_name"
      assert user.inactive_since == ~N[2022-02-10 10:02:00]
      assert user.password_hash == "some password_hash"
      assert user.phone == "some phone"
      assert user.role == "some role"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        email: "some updated email",
        full_name: "some updated full_name",
        inactive_since: ~N[2022-02-11 10:02:00],
        password_hash: "some updated password_hash",
        phone: "some updated phone",
        role: "some updated role",
        username: "some updated username"
      }

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.full_name == "some updated full_name"
      assert user.inactive_since == ~N[2022-02-11 10:02:00]
      assert user.password_hash == "some updated password_hash"
      assert user.phone == "some updated phone"
      assert user.role == "some updated role"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
