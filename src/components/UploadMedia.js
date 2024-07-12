import React, { useState } from "react";
import { FaCloudUploadAlt, FaTimes } from "react-icons/fa";
import { v4 as uuid } from 'uuid'

export default function UploadMedia({ user,setShowMessage,setNotificationMessage}) {
  const [file, setFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [uploading, setUploading] = useState(false);

  const handleFileChange = (e) => {
    var selectedFile = e.target.files[0];
    
    const randomId = uuid();
    console.log("Random id ---->",randomId);

    const renamedFile = new File([selectedFile], randomId + '.' + selectedFile.name.split('.').pop(),{
      type: selectedFile.type,
      size: selectedFile.size,
      lastModified: selectedFile.lastModified,
    });

    setFile(renamedFile);

    console.log("Selected file:", renamedFile);

    const fileReader = new FileReader();
    fileReader.onloadend = () => {
      setPreview(fileReader.result);
    };
    if (renamedFile) {
      fileReader.readAsDataURL(renamedFile);
    }
  };

  const handleUpload = async () => {
    try {
      setUploading(true);
      const payload = {
        bucketName: process.env.REACT_APP_S3_BUCKET_INPUT,
        key: file.name,
        contentType: file.type,
        uid: user.uid,
        useremail: user.email,
      };
  
      const response = await fetch(process.env.REACT_APP_PRESIGNED_LAMBDA_URL, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(payload),
      });
  
      if (!response.ok) {
        console.log(`Error! status: ${response.status}`);
      }
  
      const responseObj = await response.json();
      const presignedUrl = responseObj.presignedUrl;
      console.log("Pre signed Url ----> ", presignedUrl);
  
      if (presignedUrl) {
        const response = await fetch(presignedUrl, {
          method: "PUT",
          body: file,
          headers: {
            "Content-Type": file.type,
          },
        });
  
        if (!response.ok) {
          console.error(`Error uploading to s3 ${response.error}`);
        }
        
        setUploading(false);
        setNotificationMessage("File Uploaded. Email notification will be sent after processing!!!");
        setShowMessage(true);
        setFile(null);
        setPreview(null);
      }
    } catch (error) {
      setUploading(false);
    }
    
  };

  const handleRemoveFile = () => {
    setFile(null);
    setPreview(null);
  };

  return (
    <div className="bg-white rounded-3xl shadow-2xl p-6 max-w-2xl mx-auto my-[-40px] md:my-auto max-h-xl border-2 hover:border-indigo-300 w-full">
      <h2 className="text-2xl font-semibold text-gray-800">
        Upload Media
      </h2>
      <div className="mt-4">
        <label
          htmlFor="file-upload"
          className={`flex flex-col items-center h-auto px-4 py-8 sm:py-16 md:py-16 bg-gray-100 rounded-2xl border border-dashed border-gray-300 cursor-pointer hover:bg-gray-200 transition ${
            preview ? "hidden" : "block"
          }`}
        >
          <FaCloudUploadAlt className="text-6xl text-gray-400 mb-2" />
          <span className="text-gray-600 font-medium">
            Click to Upload
          </span>
          <input
            id="file-upload"
            type="file"
            accept="image/*,video/*"
            onChange={handleFileChange}
            className="hidden"
          />
        </label>
        {preview && (
          <div className="relative mt-4">
            <button
              onClick={handleRemoveFile}
              className="absolute top-2 right-2 text-gray-600 bg-white rounded-full p-1 shadow-md hover:bg-gray-200 transition z-10"
              style={{ zIndex: 10 }}
            >
              <FaTimes />
            </button>
            {file && file.type.startsWith("image/") ? (
              <img
                src={preview}
                alt="Preview"
                className="rounded-2xl max-w-full h-auto shadow-md"
                style={{ position: "relative", zIndex: 1 }}
              />
            ) : (
              <video
                controls
                src={preview}
                className="rounded-2xl max-w-full h-auto shadow-md"
                style={{ position: "relative", zIndex: 1 }}
              />
            )}
          </div>
        )}
        <button
          onClick={handleUpload}
          disabled={!file || uploading}
          className="mt-4 w-full h-8 sm:h-auto md:h-auto inline-flex items-center justify-center px-6 py-3 border border-transparent rounded-lg text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {uploading ? 'Uploading...' : 'Upload'}
        </button>
      </div>
    </div>
  );
}
