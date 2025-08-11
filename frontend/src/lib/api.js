const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3001';

export async function signIn({ email, password }) {
  const res = await fetch(`${API_BASE}/users/sign_in`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    // Important: include credentials so the HTTP-only cookie is set
    credentials: 'include',
    body: JSON.stringify({ user: { email, password } }),
  });

  // Devise-JWT sign_in usually returns 200 with a small body (e.g., {status:"ok"})
  // and, crucially, sets the cookie. We only care about res.ok here.
  let data = null;
  try { data = await res.json(); } catch { /* some setups return empty body */ }

  if (!res.ok) {
    const message = (data && (data.error || data.message)) || 'Login error';
    throw new Error(message);
  }

  return data || { status: 'ok' };
}
