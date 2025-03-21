import React, { useState, useRef } from "react";
import { FaCloudUploadAlt, FaTimes } from "react-icons/fa";
import { v4 as uuid } from "uuid";

export default function UploadMedia({
  user,
  setShowMessage,
  setNotificationMessage,
}) {
  const [file, setFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [isDragActive, setIsDragActive] = useState(false);
  const fileInputRef = useRef(null);
  const MAX_FILE_SIZE_MB = 5;

  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    if (selectedFile) {
      processFile(selectedFile);
    }
  };

  const validateAndProcessFile = (selectedFile) => {
    if (selectedFile.size > MAX_FILE_SIZE_MB * 1024 * 1024) {
      setNotificationMessage(`File size exceeds ${MAX_FILE_SIZE_MB}MB limit.`);
      setShowMessage(true);
      return;
    }
    processFile(selectedFile);
  };

  const processFile = (selectedFile) => {
    const randomId = uuid();
    const renamedFile = new File(
      [selectedFile],
      randomId + "." + selectedFile.name.split(".").pop(),
      {
        type: selectedFile.type,
        size: selectedFile.size,
        lastModified: selectedFile.lastModified,
      }
    );

    setFile(renamedFile);

    const fileReader = new FileReader();
    fileReader.onloadend = () => {
      setPreview(fileReader.result);
    };
    fileReader.readAsDataURL(renamedFile);
  };

  const handleDragEnter = (e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragActive(true);
  };

  const handleDragLeave = (e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragActive(false);
  };

  const handleDragOver = (e) => {
    e.preventDefault();
    e.stopPropagation();
  };

  const handleDrop = (e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragActive(false);

    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      validateAndProcessFile(e.dataTransfer.files[0]);
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
        throw new Error(`Error! status: ${response.status}`);
      }

      const { presignedUrl } = await response.json();

      if (presignedUrl) {
        const uploadResponse = await fetch(presignedUrl, {
          method: "PUT",
          body: file,
          headers: {
            "Content-Type": file.type,
          },
        });

        if (!uploadResponse.ok) {
          throw new Error(`Error uploading to s3 ${uploadResponse.statusText}`);
        }

        setNotificationMessage(
          "File Uploaded. Email notification will be sent after processing!"
        );
        setShowMessage(true);
        setFile(null);
        setPreview(null);
      }
    } catch (error) {
      setNotificationMessage(`Upload failed: ${error.message}`);
      setShowMessage(true);
    } finally {
      setUploading(false);
    }
  };

  const handleRemoveFile = () => {
    setFile(null);
    setPreview(null);
  };

  return (
    <div className="bg-white rounded-3xl shadow-lg p-8 border border-gray-200 hover:border-indigo-300 transition-all duration-300">
      <h2 className="text-2xl font-bold text-gray-800 mb-6">Upload Media</h2>
      <div className="space-y-6">
        <div
          onClick={() => fileInputRef.current.click()}
          onDragEnter={handleDragEnter}
          onDragLeave={handleDragLeave}
          onDragOver={handleDragOver}
          onDrop={handleDrop}
          className={`flex flex-col items-center justify-center h-64 border-2 border-dashed rounded-xl transition-all duration-300 cursor-pointer ${
            isDragActive
              ? "border-indigo-400 bg-indigo-50"
              : "border-gray-300 bg-gray-50 hover:bg-gray-100"
          } ${preview ? "hidden" : "block"}`}
        >
          <input
            ref={fileInputRef}
            type="file"
            onChange={handleFileChange}
            accept="video/*"
            className="hidden"
          />
          <FaCloudUploadAlt className="text-5xl text-gray-400 mb-4" />
          <p className="text-gray-600 text-center">
            {isDragActive
              ? "Drop the file here"
              : "Drag & drop a file here, or click to select"}
          </p>
        </div>
        {preview && (
          <div className="relative rounded-xl overflow-hidden shadow-md">
            <button
              onClick={handleRemoveFile}
              className="absolute top-2 right-2 p-2 bg-white rounded-full shadow-md hover:bg-gray-100 transition-colors duration-200 z-10"
            >
              <FaTimes className="text-gray-600" />
            </button>
            {file && file.type.startsWith("image/") ? (
              <img
                src={preview}
                alt="Preview"
                className="w-full h-auto object-cover"
              />
            ) : (
              <video controls src={preview} className="w-full h-auto" />
            )}
          </div>
        )}
        <div className="flex flex-row w-full justify-end">
          <button
            onClick={handleUpload}
            disabled={!file || uploading}
            className="w-full md:w-1/3 md:items-center md:justify-center py-3 px-4 bg-indigo-600 text-white font-medium rounded-lg shadow-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-opacity-50 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {uploading ? (
              <div className="flex items-center justify-center">
                <svg
                  className="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle
                    className="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    strokeWidth="4"
                  ></circle>
                  <path
                    className="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                  ></path>
                </svg>
                Uploading...
              </div>
            ) : (
              "Upload"
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
