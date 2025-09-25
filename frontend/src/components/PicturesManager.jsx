import { useEffect, useState } from "react";
import { listPictures, createPicture } from "../lib/pictures_apiclient";

export default function PicturesManager() {
  const [pictures, setPictures] = useState([]);
  const [file, setFile] = useState(null);
  const [postId, setPostId] = useState("");
  const [loading, setLoading] = useState(false);

  // Load pictures on mount
  useEffect(() => {
    (async () => {
      try {
        const data = await listPictures();
        setPictures(data);
      } catch (err) {
        console.error(err);
      }
    })();
  }, []);

  async function handleSubmit(e) {
    e.preventDefault();
    if (!file || !postId) return;

    setLoading(true);
    try {
      const newPic = await createPicture({ postId, file });
      setPictures((prev) => [...prev, newPic]);
      setFile(null);
      setPostId("");
    } catch (err) {
      console.error("Upload failed:", err);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div>
      <h2>Pictures</h2>

      <form onSubmit={handleSubmit}>
        <input
          type="number"
          placeholder="Post ID"
          value={postId}
          onChange={(e) => setPostId(e.target.value)}
        />
        <input
          type="file"
          onChange={(e) => setFile(e.target.files[0])}
          accept="image/*"
        />
        <button type="submit" disabled={loading}>
          {loading ? "Uploading..." : "Upload Picture"}
        </button>
      </form>

      <ul>
        {pictures.map((pic) => (
          <li key={pic.id}>
            <p>Picture #{pic.id} (Post {pic.post_id})</p>
            {pic.image_url && (
              <img
                src={pic.image_url}
                alt={`picture-${pic.id}`}
                style={{ maxWidth: "200px" }}
              />
            )}
          </li>
        ))}
      </ul>
    </div>
  );
}
