<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="gatepass_project.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Login Page</title>
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

        .login-container {
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1), 0 6px 20px rgba(0,0,0,0.1);
            text-align: center;
            width: 100%;
            max-width: 500px;
        }

        h2 {
            color: #0026ff;
            font-weight: 700;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-control {
            border-radius: 25px;
            padding: 12px 20px;
            border: 1px solid #ced4da;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        .form-control:focus {
            border-color: #0026ff;
            box-shadow: 0 0 0 0.2rem rgba(0, 38, 255, 0.25);
        }

        .btn-primary {
            background: #0026ff;
            border: none;
            padding: 12px 20px;
            font-size: 18px;
            border-radius: 25px;
            width: 100%;
            transition: background-color 0.3s ease;
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
        .create-user-link {
            display: block;
            margin-top: 15px;
            color: #17a2b8;
            font-size: 16px;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .alert {
            text-align: center;
            padding: 15px;
            border-radius: 25px;
            margin-top: 20px;
            display: none;
            animation: fadeIn 0.5s;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <form id="form1" runat="server">
            <!-- Header -->
            <h2 class="text-primary font-weight-bold">🔐 User login</h2>

            <!-- Login Form -->
            <div class="form-group">
                <label for="txtUsername" class="sr-only">👤 Username:</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Placeholder="Enter Username" ></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtPassword" class="sr-only">🔑 Password:</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" Placeholder="Enter Password" ></asp:TextBox>
            </div>
        
            <!-- Error Message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-danger" Visible="False">
                ❌ Invalid Username or Password.
            </asp:Label>

            <!-- Login Button -->
            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" OnClick="btnLogin_Click" />



    
        </form>
    </div>

    <script>
        $(document).ready(function () {
            // Show error message with fade-in effect
            if ($("#<%= lblMessage.ClientID %>").is(':visible')) {
                $("#<%= lblMessage.ClientID %>").css("display", "block");
            }
        });
    </script>
</body>
</html>