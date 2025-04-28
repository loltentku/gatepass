using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
namespace gatepass_project
{
    /// <summary>
    /// Summary description for UploadHandler
    /// </summary>

    public class UploadHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            if (context.Request.Files.Count > 0)
            {
                HttpPostedFile file = context.Request.Files[0];
                string fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
                string savePath = Path.Combine(context.Server.MapPath("~/Uploads"), fileName);
                file.SaveAs(savePath);
                context.Response.Write("/Uploads/" + fileName);
            }
        }
        public bool IsReusable { get { return false; } }
    }
}
