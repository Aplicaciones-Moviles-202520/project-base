// src/lib/pictures_apiclient.js
const API_BASE = "/api/v1/pictures";

export async function listPictures() {
  const res = await fetch(API_BASE, {
    credentials: "include",
  });
  if (!res.ok) throw new Error("Failed to fetch pictures");
  return res.json();
}

export async function createPicture({ postId, file }) {
  const formData = new FormData();
  formData.append("picture[post_id]", postId);
  formData.append("picture[image]", file);

  const res = await fetch(API_BASE, {
    method: "POST",
    body: formData,
    credentials: "include",
  });
  if (!res.ok) throw new Error("Failed to create picture");
  return res.json();
}
