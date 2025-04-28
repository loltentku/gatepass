<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateUser.aspx.cs" Inherits="gatepass_project.CreateUser" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Create User</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .create-user-container {
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1), 0 6px 20px rgba(0,0,0,0.1);
            text-align: center;
            width: 100%;
            max-width: 600px;
        }

        h2 {
            color: #0026ff;
            font-weight: 700;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-control:focus {
            border-color: #0026ff;
            box-shadow: 0 0 0 0.2rem rgba(0, 38, 255, 0.25);
        }

        .form-control {
            border-radius: 25px;
            padding: 12px 20px;
            border: 1px solid #ced4da;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        .form-control.dropdown-large {
            padding: 14px 20px;
            font-size: 15px;
            height: 50px; /* Adjusted for consistency */
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        .btn-primary {
            background: #0026ff;
            border: none;
            padding: 12px 20px;
            font-size: 18px;
            border-radius: 25px;
            width: 100%;
            transition: background-color 0.3s ease;
            margin-bottom: 20px;
        }

        .btn-primary:hover {
            background-color: #001aff;
        }

        .btn-secondary {
            background: #6c757d;
            border: none;
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 25px;
            width: 100%;
            margin-top: 10px;
            transition: background-color 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="create-user-container">
        <form id="form1" runat="server">
            <!-- Header -->
            <h2 class="text-primary font-weight-bold">➕ Create New User</h2>

            <!-- Create User Form -->
            <div class="form-group">
                <label for="txtUsername">Username:</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Placeholder="Enter Username" ></asp:TextBox>
            </div>

            

          

            <div class="form-group">
                <label for="ddlRole">Role:</label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control dropdown-large">
                    <asp:ListItem Text="Admin" Value="admin" />                   
                    <asp:ListItem Text="Manager" Value="manager" />
                    <asp:ListItem Text="Creator" Value="creator" />
                </asp:DropDownList>
            </div>


            

            <!-- Create User Button -->
            <asp:Button ID="btnCreate" runat="server" Text="Create User" CssClass="btn btn-primary" OnClick="btnCreate_Click" />

            <!-- Back to ManageUsers Button -->
            <asp:Button ID="btnBack" runat="server" Text="🔙 Back" CssClass="btn btn-warning" OnClick="btnBack_Click" />
        </form>
    </div>
</body>
</html>