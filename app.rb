require 'sinatra'
require 'json'
require 'time'

# Hardcoded realistic data for a funding platform

# 1. Grants (Funding Opportunities)
GRANTS = [
  {
    id: "g_101",
    title: "Global Community Impact Fund 2026",
    funder: "Global Philanthropy Foundation",
    amount: 150000,
    deadline: "2026-12-31",
    status: "open",
    focus_area: "Education & Literacy",
    description: "Funding for local community programs aimed at improving literacy rates through AI-assisted educational tools."
  },
  {
    id: "g_102",
    title: "Clean Water & Sanitation Initiative",
    funder: "Global Health Alliance",
    amount: 500000,
    deadline: "2026-08-15",
    status: "open",
    focus_area: "Public Health",
    description: "Providing capital grants to build sustainable clean water infrastructure in developing regions."
  },
  {
    id: "g_103",
    title: "Urban Renewal & Sustainability Grant",
    funder: "City Development Corp",
    amount: 75000,
    deadline: "2026-06-30",
    status: "closed",
    focus_area: "Environmental Conservation",
    description: "Support for urban renewal, green space development, and park revitalization projects."
  }
]

# 2. Grant Applications
APPLICATIONS = [
  {
    id: "app_501",
    grant_id: "g_101",
    applicant_name: "Tech for Kids Non-profit",
    requested_amount: 120000,
    status: "under_review",
    project_title: "AI Tutors for Underserved Schools",
    submitted_at: "2026-05-20T10:30:00Z"
  },
  {
    id: "app_502",
    grant_id: "g_102",
    applicant_name: "Water is Life Organization",
    requested_amount: 450000,
    status: "approved",
    project_title: "Solar-Powered Water Purification",
    submitted_at: "2026-04-10T09:15:00Z"
  }
]

# Configure Sinatra to parse JSON requests and return JSON
before do
  content_type :json
end

# Add CORS headers if you want to test from a frontend
options '*' do
  response.headers["Allow"] = "GET, POST, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end

before do
  response.headers["Access-Control-Allow-Origin"] = "*"
end

# Root endpoint with some documentation
get '/' do
  content_type :html
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>Funding MVP API</title>
      <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; padding: 2rem; max-width: 800px; margin: 0 auto; line-height: 1.6; }
        code { background: #f4f4f4; padding: 0.2rem 0.4rem; border-radius: 4px; color: #d63384; }
        ul { list-style-type: none; padding-left: 0; }
        li { background: #f9f9f9; margin-bottom: 0.5rem; padding: 1rem; border-left: 4px solid #0056b3; }
      </style>
    </head>
    <body>
      <h1>Funding MVP API</h1>
      <p>Welcome to the MVP backend for the funding platform. Here are the available endpoints:</p>
      <ul>
        <li><code>GET /api/v1/grants</code> - List all available grants</li>
        <li><code>GET /api/v1/grants/:id</code> - Get detailed information for a specific grant</li>
        <li><code>GET /api/v1/applications</code> - List all submitted grant applications</li>
        <li><code>GET /api/v1/applications/:id</code> - Get details and status of a specific application</li>
        <li><code>POST /api/v1/applications</code> - Submit a new grant application (requires JSON payload)</li>
        <li><code>PUT /api/v1/applications/:id/status</code> - Update the status of an application</li>
        <li><code>DELETE /api/v1/applications/:id</code> - Withdraw/delete an application</li>
        <li><code>GET /api/v1/grants/:id/applications</code> - Get all applications for a specific grant</li>
    </body>
    </html>
  HTML
end

# --- RESTful Endpoints ---

# 1. GET /api/v1/grants - List all grants
get '/api/v1/grants' do
  status 200
  {
    success: true,
    count: GRANTS.length,
    data: GRANTS
  }.to_json
end

# 2. GET /api/v1/grants/:id - Get details of a specific grant
get '/api/v1/grants/:id' do
  grant = GRANTS.find { |g| g[:id] == params[:id] }
  
  if grant
    status 200
    { success: true, data: grant }.to_json
  else
    status 404
    { success: false, error: "Grant not found" }.to_json
  end
end

# 3. GET /api/v1/applications - List all applications
get '/api/v1/applications' do
  status 200
  {
    success: true,
    count: APPLICATIONS.length,
    data: APPLICATIONS
  }.to_json
end

# 4. GET /api/v1/applications/:id - Get details of a specific application
get '/api/v1/applications/:id' do
  application = APPLICATIONS.find { |a| a[:id] == params[:id] }
  
  if application
    status 200
    { success: true, data: application }.to_json
  else
    status 404
    { success: false, error: "Application not found" }.to_json
  end
end

# 5. POST /api/v1/applications - Submit a new grant application
post '/api/v1/applications' do
  begin
    request.body.rewind
    payload = JSON.parse(request.body.read)
    
    # Generate a fake ID for the new application
    new_id = "app_#{rand(1000..9999)}"
    
    new_application = {
      id: new_id,
      grant_id: payload['grant_id'] || "g_unknown",
      applicant_name: payload['applicant_name'] || "Unknown Applicant",
      project_title: payload['project_title'] || "Untitled Project",
      requested_amount: payload['requested_amount'] || 0,
      status: "submitted",
      submitted_at: Time.now.utc.iso8601
    }
    
    # In a real app we would persist this to a database,
    # but for this MVP, we just return the "created" object.
    status 201
    {
      success: true,
      message: "Application submitted successfully",
      data: new_application
    }.to_json
  rescue JSON::ParserError
    status 400
    { success: false, error: "Invalid JSON payload" }.to_json
  end
end

# 6. PUT /api/v1/applications/:id/status - Update the status of an application
put '/api/v1/applications/:id/status' do
  begin
    request.body.rewind
    payload = JSON.parse(request.body.read)
    
    application = APPLICATIONS.find { |a| a[:id] == params[:id] }
    
    if application
      new_status = payload['status']
      
      if new_status
        # In a real app we'd update the database. Here we just return the updated object representation.
        updated_application = application.dup
        updated_application[:status] = new_status
        
        status 200
        {
          success: true,
          message: "Application status updated",
          data: updated_application
        }.to_json
      else
        status 400
        { success: false, error: "Missing 'status' in payload" }.to_json
      end
    else
      status 404
      { success: false, error: "Application not found" }.to_json
    end
  rescue JSON::ParserError
    status 400
    { success: false, error: "Invalid JSON payload" }.to_json
  end
end

# 7. DELETE /api/v1/applications/:id - Withdraw an application
delete '/api/v1/applications/:id' do
  application = APPLICATIONS.find { |a| a[:id] == params[:id] }
  
  if application
    # In a real app, this would delete the record from the database.
    status 200
    { success: true, message: "Application withdrawn successfully" }.to_json
  else
    status 404
    { success: false, error: "Application not found" }.to_json
  end
end

# 8. GET /api/v1/grants/:id/applications - Get all applications for a specific grant
get '/api/v1/grants/:id/applications' do
  grant_applications = APPLICATIONS.select { |a| a[:grant_id] == params[:id] }
  
  status 200
  {
    success: true,
    count: grant_applications.length,
    data: grant_applications
  }.to_json
end
