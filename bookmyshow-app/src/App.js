import "./App.css";
import Footer from "./Routes/Footer";
import Navbar from "./Routes/Navbar";
import Router from "./Routes/Router";

function App() {
  return (
    <div className="App">
      <Navbar />
      <h1>Book My Show App</h1>
      <button>Login</button>
      <Router />
      <Footer />
    </div>
  );
}

export default App;
