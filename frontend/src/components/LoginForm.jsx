import { useState } from 'react';
import { signIn } from '../lib/api';

export default function LoginForm({ onSuccess }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const [submitting, setSubmitting] = useState(false);
  const [msg, setMsg] = useState(null);     // "login exitoso" / "login error"
  const [error, setError] = useState(null); // network/validation message

  async function handleSubmit(e) {
    e.preventDefault();
    setSubmitting(true);
    setMsg(null);
    setError(null);

    try {
      await signIn({ email, password });
      setMsg('login exitoso');
      onSuccess?.();
    } catch (err) {
      setMsg('login error');
      setError(err.message || 'Error de autenticación');
    } finally {
      setSubmitting(false);
    }
  }

  const disabled = submitting || !email.trim() || !password;

  return (
    <div className="login-card">
      <h2>Iniciar sesión</h2>
      <form onSubmit={handleSubmit} noValidate>
        <label>
          Email
          <input
            type="email"
            autoComplete="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            placeholder="usuario@ejemplo.com"
          />
        </label>

        <label>
          Contraseña
          <input
            type="password"
            autoComplete="current-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            placeholder="********"
          />
        </label>

        <button type="submit" disabled={disabled}>
          {submitting ? 'Ingresando…' : 'Ingresar'}
        </button>
      </form>

      {msg && <p className={msg.includes('exitoso') ? 'ok' : 'warn'}>{msg}</p>}
      {error && <p className="error">{error}</p>}

      <style>{`
        .login-card { max-width: 360px; margin: 2rem auto; padding: 1.5rem; border: 1px solid #eee; border-radius: 12px; }
        form { display: grid; gap: .75rem; }
        label { display: grid; gap: .35rem; font-size: .95rem; }
        input { padding: .6rem .7rem; border: 1px solid #ccc; border-radius: 8px; }
        button { margin-top: .5rem; padding: .6rem .9rem; border: 0; border-radius: 8px; cursor: pointer; }
        button[disabled] { opacity: .6; cursor: not-allowed; }
        .ok { color: #137333; }
        .warn { color: #b06000; }
        .error { color: #b00020; }
      `}</style>
    </div>
  );
}
