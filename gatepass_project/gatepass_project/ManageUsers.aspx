<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="gatepass_project.ManageUsers" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Manage Users | Gate Pass System</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            background: #f0f2f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container-fluid {
            width: 95%;
            max-width: 1400px;
            margin: 20px auto;
            padding: 20px;
        }

        .admin-panel {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .panel-header {
            background: linear-gradient(135deg, #60a5fa, #93c5fd);
            color: #1e3a8a;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .panel-header h2 {
            font-size: 1.75rem;
            font-weight: 700;
            margin: 0;
        }

        .panel-content {
            padding: 30px;
            background: #fafafa;
        }

        h2.document-title {
            font-size: 2rem;
            color: #1e3a8a;
            text-align: center;
            margin-bottom: 30px;
            font-weight: 600;
        }

        .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .table thead {
            background: #1e3a8a;
            color: white;
        }

        .table th, .table td {
            padding: 15px;
            vertical-align: middle;
            border: none;
        }

        .table tbody tr:hover {
            background: #f1f5f9;
        }

        .btn-action {
            padding: 6px 12px;
            font-size: 14px;
        }

        .modal-content {
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        .form-group {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }

        .control-label {
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-control {
            display: block;
            width: 100%;
            padding: 0.375rem 0.75rem;
            font-size: 1rem;
            line-height: 1.5;
            color: #495057;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        .dropdown-large {
            font-size: 1.1rem;
            padding: 0.5rem 1rem;
            width: 100%;
        }

        .dropdown-large:focus {
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        .btn-save {
            border-radius: 25px;
            padding: 10px 20px;
        }

        .btn-back {
            border-radius: 25px;
            padding: 10px 20px;
            background-color: lawngreen;
            border-color: #6c757d;
        }

        .btn-back:hover {
            background-color: #5a6268;
            border-color: #5a6268;
        }

        .create-user-btn {
            background: linear-gradient(135deg, #ff6a00, #93c5fd);
            color: #fff;
            border: none;
            border-radius: 25px;
            padding: 10px 20px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-left: 10px;
        }

        .create-user-btn:hover {
            background: linear-gradient(135deg, #80bdff, #60a5fa);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        <div class="container-fluid">
            <div class="admin-panel">
                <div class="panel-header">
                    <h2>Gate Pass System</h2>
                    <asp:LinkButton ID="btnLogout" runat="server" CssClass="text-danger font-weight-bold" OnClientClick="return logoutUser();" Text="Logout" />
                </div>
                <div class="panel-content">
                    <h2 class="document-title"><i class="fas fa-users mr-2"></i> Manage Users</h2>

                   <div class="text-center mb-5">
    <asp:Button ID="btnBack" runat="server" Text="🔙 Back to Documents" CssClass="btn btn-back" OnClick="btnBack_Click" />
    <asp:Button ID="btnCreateUser" runat="server" CssClass="create-user-btn" Text="➕ Create User" OnClick="lnkCreateUser_Click" />
</div>
                       
       
                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover"
                        OnRowCommand="gvUsers_RowCommand">
                        <HeaderStyle CssClass="bg-dark text-white" />
                        <Columns>
                            <asp:BoundField DataField="username" HeaderText="Username" />
                            <asp:BoundField DataField="role" HeaderText="Role" />

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnEdit" runat="server" Text="🖊️ Edit" CssClass="btn btn-warning btn-action" 
                                        CommandName="EditUser" CommandArgument='<%# Eval("username") %>' />
                                    <asp:Button ID="btnDelete" runat="server" Text="🗑️ Delete" CssClass="btn btn-danger btn-action" 
                                        CommandName="DeleteUser" CommandArgument='<%# Eval("username") %>' 
                                        data-username='<%# Eval("username") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    

                    <!-- Edit User Modal -->
                    <div class="modal fade" id="editUserModal" tabindex="-1" role="dialog" aria-labelledby="editUserModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">×</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <asp:HiddenField ID="hfUsername" runat="server" />
                                    <div class="form-group">
                                        <label for="txtEditUsername">Username</label>
                                        <asp:TextBox ID="txtEditUsername" runat="server" CssClass="form-control" Enabled="False" />
                                    </div>
                                    
                                    
                                    <div class="form-group">
                                        <label for="ddlEditRole" class="control-label">Role:</label>
                                        <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-control dropdown-large">
                                            <asp:ListItem Text="Admin" Value="admin" />
                                            <asp:ListItem Text="Manager" Value="manager" />
                                            <asp:ListItem Text="Creator" Value="creator" />
                                        </asp:DropDownList>
                                    </div>
                                  
                    </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn btn-primary btn-save" OnClick="btnSave_Click" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Create Department Modal -->
         
                </div>
            </div>
        </div>
    </form>

    <script>
        function logoutUser() {
            Swal.fire({
                title: "Are you sure?",
                text: "You will be logged out!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#d33",
                cancelButtonColor: "#3085d6",
                confirmButtonText: "Yes, logout"
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "Login.aspx";
                }
            });
            return false;
        }

        $(document).ready(function () {
            // User delete confirmation
            $('.btn-danger[data-username]').click(function (e) {
                e.preventDefault();
                var btn = $(this);
                var username = btn.data('username');

                Swal.fire({
                    title: 'Are you sure?',
                    text: "You are about to delete the user: " + username + "? This action cannot be undone!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Yes, delete it!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        __doPostBack(btn.attr('name'), '');
                    }
                });
            });

            // Department delete confirmation
            $('.btn-danger[data-deptname]').click(function (e) {
                e.preventDefault();
                var btn = $(this);
                var deptName = btn.data('deptname');

                Swal.fire({
                    title: 'Are you sure?',
                    text: "You are about to delete the department: " + deptName + "? This action cannot be undone!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Yes, delete it!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        __doPostBack(btn.attr('name'), '');
                    }
                });
            });
        });
    </script>
</body>
</html>