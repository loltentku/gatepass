using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace gatepass_project
{
    public partial class CreateUser : System.Web.UI.Page
    {
        private gatepassEntities db = new gatepassEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            
            }
        }

    

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
          
            string role = ddlRole.SelectedValue;
         

            // Validation
            if (string.IsNullOrEmpty(username) || 
             string.IsNullOrEmpty(role) 
               )
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "errorAlert",
                    "Swal.fire({ icon: 'error', title: 'Validation Error', text: '❌ Please fill in all required fields.' });", true);
                return;
            }

            // Check if username already exists
            if (db.logins.Any(u => u.username == username))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "errorAlert",
                    "Swal.fire({ icon: 'error', title: 'Username Taken', text: '❌ Username already exists. Please choose a different username.' });", true);
                return;
            }

            try
            {
                // Create new user
                var newUser = new login
                {
                    username = username,                 
                    role = role,
 
                };

                db.logins.Add(newUser);
                db.SaveChanges();

                // Show success message with redirect
                ScriptManager.RegisterStartupScript(this, GetType(), "successAlert",
                    "Swal.fire({ icon: 'success', title: 'User Created', text: '✅ User has been successfully created!' }).then(() => { window.location = 'ManageUsers.aspx'; });", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "errorAlert",
                    $"Swal.fire({{ icon: 'error', title: 'Error', text: '❌ Error creating user: {ex.Message}' }});", true);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageUsers.aspx");
        }
    }
}