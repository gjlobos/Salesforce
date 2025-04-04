import './index.css'

const CLIENT_ID = 'TU_CONSUMER_KEY'; // <-- reemplazá con tu Client ID real
const REDIRECT_URI = 'http://localhost:5173/callback';

const LOGIN_URL = `https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${encodeURIComponent(REDIRECT_URI)}`;

function handleLogin() {
  window.location.href = LOGIN_URL;
}

function App() {
  return (
    <div className="min-h-screen bg-[#0B9DDA] text-white flex flex-col items-center justify-center px-4">
      <h1 className="text-5xl font-bold mb-4 text-center">DocuMetaX</h1>
      <p className="text-xl text-center mb-6 max-w-xl">
        Generate professional Salesforce documentation in seconds. Flows, Apex, Metadata, Validation Rules and more — all in one place.
      </p>
      <button
        onClick={handleLogin}
        className="bg-white text-[#0B9DDA] px-6 py-3 rounded-full font-semibold shadow hover:bg-gray-100 transition"
      >
        Login with Salesforce
      </button>
    </div>
  )
}

export default App
