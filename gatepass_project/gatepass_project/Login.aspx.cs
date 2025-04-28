using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Net;
using System.IO;

namespace gatepass_project
{
    public partial class Login : System.Web.UI.Page
    {
        private string host = "http://10.231.2.34/nidec/login/API/authenticate_flowlites.php"; // Same API endpoint
        private gatepassEntities db = new gatepassEntities(); // Assuming you have this context

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // Only run this on initial load
            {
                lblMessage.Visible = false; // Hide error message initially
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                // Show SweetAlert error message
                ScriptManager.RegisterStartupScript(this, GetType(), "errorAlert",
                    "Swal.fire({ icon: 'error', title: 'Login Failed', text: '❌ Please enter both username and password!' });", true);
                return;
            }

            try
            {
                // Authenticate user via API
                UserDetails userDetails = AuthenticateUser(username, password);

                if (userDetails != null)
                {
                    // Store user details in session
                    Session["AdminUser"] = userDetails.idmName?.Trim();
                    Session["UserFactory"] = userDetails.idmFatory?.Trim();
                    Session["UserDepartment"] = userDetails.idmDepartment?.Trim();
                    Session["UserEmail"] = userDetails.idmEmail?.Trim();

                    // Check if username exists in dbo.login table and set UserRole
                    string userRole = GetUserRoleFromDatabase(username); // Use username instead of idmID
                    Session["UserRole"] = userRole ?? "admin"; // If no role found, default to "admin"

                    // Redirect to ViewDocuments.aspx after successful login
                    Response.Redirect("ViewDocuments.aspx", false);
                }
                else
                {
                    // Show SweetAlert error message
                    ScriptManager.RegisterStartupScript(this, GetType(), "errorAlert",
                        "Swal.fire({ icon: 'error', title: 'Login Failed', text: '❌ Invalid Username or Password!' });", true);
                }
            }
            catch (Exception ex)
            {
                // Show SweetAlert error message for exception
                ScriptManager.RegisterStartupScript(this, GetType(), "errorAlert",
                    $"Swal.fire({{ icon: 'error', title: 'Error', text: 'An error occurred during login: {ex.Message}' }});", true);
            }
        }

        private UserDetails AuthenticateUser(string username, string password)
        {
            try
            {
                string url = host;
                var request = (HttpWebRequest)WebRequest.Create(url);
                var postData = "user_login=" + username + "&password=" + password;
                var data = Encoding.ASCII.GetBytes(postData);

                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = data.Length;
                request.KeepAlive = true;
                request.Timeout = 5000;
                request.Headers.Add("cache-control: no-cache");

                using (var stream = request.GetRequestStream())
                {
                    stream.Write(data, 0, data.Length);
                    stream.Close();
                }

                var response = (HttpWebResponse)request.GetResponse();
                var responseString = new StreamReader(response.GetResponseStream()).ReadToEnd().Replace("\"", " ");
                response.Close();

                string[] wordsSplit = responseString.Split(new char[] { ',' });

                if (wordsSplit.Length > 0 && wordsSplit[0] != "")
                {
                    return new UserDetails
                    {
                        idmID = wordsSplit[0].Substring(6), // Extract ID
                        idmName = wordsSplit[2].Substring(4) + " " + wordsSplit[1].Substring(4), // Full name
                        idmEmail = wordsSplit[3].Substring(4), // Email
                        idmFatory = wordsSplit[4].Substring(4), // Factory
                        idmDepartment = wordsSplit[5].Substring(5).Substring(0, 3) // Department
                    };
                }

                return null;
            }
            catch (Exception ex)
            {
                // Log error if needed
                return null;
            }
        }

        private string GetUserRoleFromDatabase(string username)
        {
            try
            {
                // Query dbo.login table using the username column
                var user = db.logins.FirstOrDefault(u => u.username == username);

                if (user != null)
                {
                    return user.role; // Return the role if found
                }

                return null; // Return null if user not found
            }
            catch (Exception ex)
            {
                // Log the error if needed
                return null; // In case of error, return null so Session["UserRole"] defaults to "admin"
            }
        }
    }
}