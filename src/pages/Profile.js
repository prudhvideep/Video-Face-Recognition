import { useEffect, useState } from "react";
import { auth } from "../firebase/firebase";
import { useNavigate } from "react-router-dom";

function Profile() {
  const navigate = useNavigate();
  const [user, setUser] = useState();

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((userInfo) => {
      if (userInfo) {
        console.log("User Info ----> ", userInfo);
        setUser(userInfo);
      } else {
        navigate("/");
      }
    });

    return unsubscribe;
  }, [navigate]);

  const handleBack = () => {
    navigate(-1);
  }

  return (
    <>
      <div className="p-6 flex items-center w-full max-w-2xl mx-auto">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          strokeWidth={1.5}
          stroke="currentColor"
          className="w-6 h-6 hover:scale-110 hover:text-indigo-400"
          onClick={handleBack}
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M15.75 19.5L8.25 12l7.5-7.5"
          />
        </svg>
        <div className="mx-64">
          <p className="font-medium text-base text-slate-400">My Profile</p>
        </div>
      </div>

      <div className="flex justify-center">
        {user && (
          <div className="p-12 w-full max-w-2xl rounded">
            <div className="flex flex-col justify-center space-y-6 items-center">
              <div className="">
                <img
                  src={user.photoURL}
                  alt=""
                  className="w-full rounded-full border-2 border-gray-400 hover:scale-110 hover:border-indigo-500"
                />
              </div>
              <div>
                <p className="font-bold text-slate-400 text-2xl">
                  {user.displayName}
                </p>
              </div>
            </div>
            <div className="mt-14 flex-col w-full justify-start">
              <div>
                <p className="font-medium text-base text-slate-400">
                  Email Address
                </p>
                <input
                  className="mt-1 w-full font-semibold text-xl bg-transparent outline-none border-b border-gray-300 hover:border-indigo-400 pb-1"
                  value={user.email}
                  readOnly
                />
              </div>
            </div>
          </div>
        )}
      </div>
    </>
  );
}

export default Profile;
