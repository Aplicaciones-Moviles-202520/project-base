// src/App.jsx
import { BrowserRouter, Routes, Route, useNavigate } from "react-router-dom";
import LoginForm from "./components/LoginForm";
import PicturesManager from "./components/PicturesManager";

function LoginPage() {
  const navigate = useNavigate();

  const handleLoginSuccess = () => {
    // Redirige a /pictures después de login exitoso
    navigate("/pictures");
  };

  return <LoginForm onSuccess={handleLoginSuccess} />;
}

export default function App() {
  return (
    <BrowserRouter>
      <h1>TravelLog</h1>
      <Routes>
        <Route path="/" element={<LoginPage />} />
        <Route path="/pictures" element={<PicturesManager />} />
      </Routes>
    </BrowserRouter>
  );
}
