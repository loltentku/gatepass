using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace gatepass_project
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        private gatepassEntities db = new gatepassEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null || Session["UserRole"] == null || Session["UserRole"].ToString().ToLower() != "creator")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUsers();
           
            }
        }

        private void LoadUsers()
        {
            var users = db.logins.ToList();
            gvUsers.DataSource = users;
            gvUsers.DataBind();
        }


        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditUser")
            {
                // Your existing code for editing
                string username = e.CommandArgument.ToString();
                var user = db.logins.FirstOrDefault(u => u.username == username);
                if (user != null)
                {
                    hfUsername.Value = user.username;
                    txtEditUsername.Text = user.username;
                    ddlEditRole.SelectedValue = user.role.ToLower();
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowModal", "$('#editUserModal').modal('show');", true);
                }
            }
            else if (e.CommandName == "DeleteUser")
            {
                string username = e.CommandArgument.ToString();
                var user = db.logins.FirstOrDefault(u => u.username == username);
                if (user != null)
                {
                    db.logins.Remove(user);
                    db.SaveChanges();
                    LoadUsers();
                    ScriptManager.RegisterStartupScript(this, GetType(), "DeleteNotify",
                        "Swal.fire('Deleted!', 'User has been deleted.', 'success');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "ErrorNotify",
                        "Swal.fire('Error', 'User not found.', 'error');", true);
                }
            }
        }



        protected void btnSave_Click(object sender, EventArgs e)
        {
            string username = hfUsername.Value;
            var user = db.logins.FirstOrDefault(u => u.username == username);
            if (user != null)
            {
           
                user.role = ddlEditRole.SelectedValue;
               
             

                db.SaveChanges();

                LoadUsers();
                ScriptManager.RegisterStartupScript(this, GetType(), "HideModalAndNotify",
                    "$('#editUserModal').modal('hide'); Swal.fire('Success', 'User updated successfully!', 'success');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ErrorNotify",
                    "Swal.fire('Error', 'User not found.', 'error');", true);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewDocuments.aspx");
        }

        protected void lnkCreateUser_Click(object sender, EventArgs e)
        {
            Response.Redirect("CreateUser.aspx");
        }

       

        
    }
}