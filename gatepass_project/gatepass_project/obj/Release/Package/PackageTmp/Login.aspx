<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="gatepass_project.Login" %>


<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Login page</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            border: 2px solid black; /* Black Border */
        }
        .form-group {
            margin-bottom: 15px;
        }
        .btn-primary {
            background: #0026ff;
            border: none;
            padding: 10px 20px;
            font-size: 18px;
            border-radius: 5px;
            width: 100%;
        }
        .alert {
            display: none; /* Initially hidden */
        }
    </style>
</head>
<body>

    <div class="container mt-5 shadow-lg">
        <form id="form1" runat="server">
            <!-- Header -->
            <div class="text-center mb-4">
                <h2 class="text-primary font-weight-bold">🔐 Login page</h2>
            </div>

            <!-- Login Form -->
            <div class="form-group">
                <label for="txtUsername">👤 Username:</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Placeholder="Enter Username"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtPassword">🔑 Password:</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" Placeholder="Enter Password"></asp:TextBox>
            </div>

            <!-- Error Message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-danger text-center w-100" Visible="False">
                ❌ Invalid Username or Password.
            </asp:Label>

            <!-- Login Button -->
            <div class="text-center mt-3">
                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
            </div>

            <!-- Login as Guest Button -->
                <div class="text-center mt-3">
                    <asp:Button ID="btnGuestLogin" runat="server" Text="👤 Login as Guest" CssClass="btn btn-secondary" OnClick="btnGuestLogin_Click" />
                </div>

           
        </form>
    </div>

</body>
</html>
