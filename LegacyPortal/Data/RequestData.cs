using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace LegacyPortal.Data
{
    public enum DecisionResult
    {
        Updated,
        Missing,
        AlreadyProcessed
    }

    public static class RequestData
    {
        private static SqlConnection OpenConnection()
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["PortalDatabase"];
            if (settings == null)
                throw new ConfigurationErrorsException("PortalDatabase connection string is required.");
            SqlConnection connection = new SqlConnection(settings.ConnectionString);
            try
            {
                connection.Open();
                return connection;
            }
            catch
            {
                connection.Dispose();
                throw;
            }
        }

        public static DataTable GetRequests()
        {
            using (SqlConnection connection = OpenConnection())
            using (SqlCommand command = new SqlCommand(
                "SELECT id, title, applicant, department, kind, status, created_at "
                + "FROM dbo.Requests ORDER BY created_at DESC, id DESC", connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                DataTable table = new DataTable();
                adapter.Fill(table);
                return table;
            }
        }

        public static DataRow GetRequest(int id)
        {
            using (SqlConnection connection = OpenConnection())
            using (SqlCommand command = new SqlCommand(
                "SELECT id, title, applicant, department, kind, details, status, created_at "
                + "FROM dbo.Requests WHERE id = @id", connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.Parameters.Add("@id", SqlDbType.Int).Value = id;
                DataTable table = new DataTable();
                adapter.Fill(table);
                return table.Rows.Count == 0 ? null : table.Rows[0];
            }
        }

        public static int CreateRequest(string title, string applicant, string department, string kind, string details)
        {
            using (SqlConnection connection = OpenConnection())
            using (SqlCommand command = new SqlCommand(
                "INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at) "
                + "VALUES (@title, @applicant, @department, @kind, @details, 'pending', @created_at); "
                + "SELECT CAST(SCOPE_IDENTITY() AS int);", connection))
            {
                command.Parameters.Add("@title", SqlDbType.NVarChar, 80).Value = title;
                command.Parameters.Add("@applicant", SqlDbType.NVarChar, 40).Value = applicant;
                command.Parameters.Add("@department", SqlDbType.VarChar, 16).Value = department;
                command.Parameters.Add("@kind", SqlDbType.VarChar, 16).Value = kind;
                command.Parameters.Add("@details", SqlDbType.NVarChar, 1000).Value = details;
                command.Parameters.Add("@created_at", SqlDbType.DateTime).Value = DateTime.UtcNow;
                return (int)command.ExecuteScalar();
            }
        }

        public static DecisionResult Decide(int id, string status)
        {
            if (status != "approved" && status != "rejected")
                throw new ArgumentException("A decision must be approved or rejected.", "status");
            using (SqlConnection connection = OpenConnection())
            using (SqlCommand command = new SqlCommand(
                "UPDATE dbo.Requests SET status = @status WHERE id = @id AND status = 'pending'", connection))
            {
                command.Parameters.Add("@status", SqlDbType.VarChar, 16).Value = status;
                command.Parameters.Add("@id", SqlDbType.Int).Value = id;
                if (command.ExecuteNonQuery() == 1)
                    return DecisionResult.Updated;
                using (SqlCommand exists = new SqlCommand("SELECT COUNT(*) FROM dbo.Requests WHERE id = @id", connection))
                {
                    exists.Parameters.Add("@id", SqlDbType.Int).Value = id;
                    return (int)exists.ExecuteScalar() == 0 ? DecisionResult.Missing : DecisionResult.AlreadyProcessed;
                }
            }
        }
    }
}
