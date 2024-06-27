import { useEffect, useState, Fragment } from "react";
import { Disclosure, Menu, Transition } from "@headlessui/react";
import { Bars3Icon, XMarkIcon } from "@heroicons/react/24/outline";
import { onAuthStateChanged, signOut } from "firebase/auth";
import { auth } from "../firebase/firebase";
import UploadMedia from "../components/UploadMedia";
import { useNavigate } from "react-router-dom";

const userNavigation = [
  { name: "Your Profile"},
  { name: "Settings" },
  { name: "Sign out"},
];

function classNames(...classes) {
  return classes.filter(Boolean).join(" ");
}

export default function Dashboard() {
  const navigate = useNavigate();
  const [user, setUser] = useState({
    displayName: "",
    email: "",
    imageUrl: "",
    uid: "",
  });
  const [results, setResults] = useState([]);
  const [fetching, setFetching] = useState(false);
  const [showMessage,setShowMessage] = useState(false);
  const [notificationMessage,setNotificationMessage] = useState(null);

  const handleProfileNavigation = () => {
    navigate("/profile");
  }

  const handleSignOut = async () => {
    try {
      await signOut(auth);
      navigate("/");
    } catch (error) {
      console.error("Error signing out: ", error);
    }
  };

  const deleteRecords = async (payload) => {
    try {
      const response = await fetch(process.env.REACT_APP_DELETE_LAMBDA_URL, {
        method: "POST",
        body: JSON.stringify(payload),
      });
  
      if (!response.ok) {
        console.error("Error deleting the Records");
      }
  
      console.log("Delete response ---->", response);
      setNotificationMessage("Successfully Deleted !!!")
      setShowMessage(true)
    } catch (error) {
      setNotificationMessage(`Error deleting the records - ${error}`)
      setShowMessage(true)
      console.error("Error deleting the records",error);
    }
  };

  const handleDelete = async (index) => {
    console.log("Delete ------>");
    console.log("index ------->", index);
    let key = results[index].key;
    console.log("Key ---->", key);

    let updatedResults = results.filter((_, idx) => idx !== index);
    setResults(updatedResults);

    const payload = {
      bucketname: process.env.REACT_APP_S3_BUCKET_OUTPUT,
      key: key,
    };

    deleteRecords(payload);
  };

  const handleFetchValue = async () => {
    setFetching(true);
    try {
      if (!user.uid) return;

      const payload = {
        bucketname: process.env.REACT_APP_S3_BUCKET_OUTPUT,
        firebaseuid: user.uid,
      };

      console.log("Payload ----> ", payload);

      const response = await fetch(process.env.REACT_APP_OUTPUT_LAMBDA_URL, {
        method: "POST",
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        console.error(`Error fetching the data, ${response.status}`);
      }

      const responseObj = await response.json();
      console.log(responseObj);

      setResults(responseObj);
    } catch (error) {
      console.error("Error fetching the data: ", error);
    } finally {
      setFetching(false);
    }
  };

  const handleRefresh = async () => {
    await handleFetchValue();
  };

  const handleClose = () => {
    setShowMessage(false);
    setNotificationMessage(null);
  }

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      if (user) {
        setUser({
          displayName: user.displayName || "",
          email: user.email || "",
          imageUrl: user.photoURL || "",
          uid: user.uid || "",
        });
      } else {
        navigate("/");
      }
    });

    return () => unsubscribe();
  }, []);

  useEffect(() => {
    handleRefresh();
  }, [user]);

  return (
    <>
      <div className="min-h-full">
        <Disclosure as="nav" className="bg-gray-800">
          {({ open }) => (
            <>
              <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                <div className="flex h-16 items-center justify-between">
                  <div className="flex items-center">
                    <div className="hidden md:block">
                      <div className="text-white text-xl font-semibold">
                        {user.displayName && `Welcome, ${user.displayName}`}
                      </div>
                    </div>
                  </div>
                  <div className="hidden md:block">
                    <div className="ml-4 flex items-center md:ml-6">
                      <button
                        type="button"
                        className="relative rounded-full bg-gray-800 p-1 text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800"
                      ></button>

                      <Menu as="div" className="relative ml-3">
                        <div>
                          <Menu.Button className="relative flex max-w-xs items-center rounded-full bg-gray-800 text-sm focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
                            <span className="absolute -inset-1.5" />
                            <span className="sr-only">Open user menu</span>
                            <img
                              className="h-8 w-8 rounded-full"
                              src={user.imageUrl}
                              alt=""
                            />
                          </Menu.Button>
                        </div>
                        <Transition
                          as={Fragment}
                          enter="transition ease-out duration-100"
                          enterFrom="transform opacity-0 scale-95"
                          enterTo="transform opacity-100 scale-100"
                          leave="transition ease-in duration-75"
                          leaveFrom="transform opacity-100 scale-100"
                          leaveTo="transform opacity-0 scale-95"
                        >
                          <Menu.Items className="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                            {userNavigation.map((item) => (
                              <Menu.Item key={item.name}>
                                {({ active }) => (
                                  <button
                                    onClick={() => {
                                      if (item.name === "Sign out") {
                                        handleSignOut();
                                      }else if (item.name === "Your Profile"){
                                        handleProfileNavigation();
                                      }
                                    }}
                                    className={classNames(
                                      active ? "bg-gray-100" : "",
                                      "block w-full px-4 py-2 text-sm text-gray-700"
                                    )}
                                  >
                                    {item.name}
                                  </button>
                                )}
                              </Menu.Item>
                            ))}
                          </Menu.Items>
                        </Transition>
                      </Menu>
                    </div>
                  </div>
                  <div className="-mr-2 flex md:hidden">
                    <Disclosure.Button className="relative inline-flex items-center justify-center rounded-md bg-gray-800 p-2 text-gray-400 hover:bg-gray-700 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
                      <span className="absolute -inset-0.5" />
                      <span className="sr-only">Open main menu</span>
                      {open ? (
                        <XMarkIcon
                          className="block h-6 w-6"
                          aria-hidden="true"
                        />
                      ) : (
                        <Bars3Icon
                          className="block h-6 w-6"
                          aria-hidden="true"
                        />
                      )}
                    </Disclosure.Button>
                  </div>
                </div>
              </div>

              <Disclosure.Panel className="md:hidden">
                <div className="border-t border-gray-700 pb-3 pt-4">
                  <div className="flex items-center px-5">
                    <div className="flex-shrink-0">
                      <img
                        className="h-10 w-10 rounded-full"
                        src={user.imageUrl}
                        alt=""
                      />
                    </div>
                    <div className="ml-3">
                      <div className="text-base font-medium leading-none text-white">
                        {user.displayName}
                      </div>
                      <div className="text-sm font-medium leading-none text-gray-400">
                        {user.email}
                      </div>
                    </div>
                    <button
                      type="button"
                      className="relative ml-auto flex-shrink-0 rounded-full bg-gray-800 p-1 text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800"
                    ></button>
                  </div>
                  <div className="mt-3 space-y-1 px-2">
                    {userNavigation.map((item) => (
                      <button
                        key={item.name}
                        as="a"
                        onClick={() => {
                          if (item.name === "Sign out") {
                            handleSignOut();
                          }else if (item.name === "Your Profile"){
                            handleProfileNavigation();
                          }
                        }}
                        className="w-full block rounded-md px-3 py-2 text-base font-medium text-gray-400 hover:bg-gray-700 hover:text-white"
                      >
                        {item.name}
                      </button>
                    ))}
                  </div>
                </div>
              </Disclosure.Panel>
            </>
          )}
        </Disclosure>

        <div className="flex-box justify-center items-center mt-6 md:mt-2 rounded-lm">
          {showMessage && <div className="flex justify-center p-2 mb-8 md:mb-[-5px] mt-[-8px] mx-[24px] sm:mx-[42px] md:mt-4 md:mx-auto md:w-full md:max-w-2xl bg-indigo-100 text-indigo-700 border-2 border-indigo-300/50 hover:bg-indigo-150 rounded-2xl">
            <p className="text-center font-semibold flex-grow">{notificationMessage}</p>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth={1.5}
              stroke="currentColor"
              onClick={handleClose}
              className="size-5 mt-auto hover:text-violet-900 hover:scale-110"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M6 18 18 6M6 6l12 12"
              />
            </svg>
          </div>}
          <div className="w-full rounded-lm p-6 ">
            <UploadMedia 
            user={user} 
            setShowMessage={setShowMessage}
            setNotificationMessage={setNotificationMessage}
            />
          </div>
          <div className="relative bg-white mt-8 md:mt-auto mx-6 sm:mx-auto md:mx-auto p-6 py-auto rounded-2xl shadow-2xl border-2 hover:border-indigo-300 max-w-2xl">
            <div className="flex font-medium text-2xl space-x-2 items-center ">
              <h2>Results</h2>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="currentColor"
                onClick={handleRefresh}
                className={`mt-1 size-6 text-gray-500 hover:scale-110 hover:text-gray-900 ${
                  fetching ? "animate-spin" : ""
                }`}
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99"
                />
              </svg>
            </div>
            <table className="mt-4 table-auto w-full divide-y divide-gray-200">
              <thead>
                <tr className="bg-gray-100 divide-y h-10">
                  <th className="font-normal w-1/3">Request</th>
                  <th className="font-normal w-1/3">Result</th>
                  <th className="font-normal w-1/3"></th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {results &&
                  results.map((item, index) => (
                    <tr
                      className="justify-items-center min-h-[5rem]"
                      key={index}
                    >
                      <th className="flex items-center justify-center py-2">
                        <img
                          className="h-15 sm:h-15 md:h-20 rounded-xl"
                          src={item.file_url}
                          alt={item.faceresult}
                        />
                      </th>
                      <th className="items-center text-slate-500 font-semibold">
                        {item.faceresult}
                      </th>
                      <th className="flex justify-center items-start">
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          fill="none"
                          viewBox="0 0 24 24"
                          strokeWidth={1.5}
                          stroke="currentColor"
                          onClick={() => {
                            handleDelete(index);
                          }}
                          className="size-5 md:size-6 h-14 md:h-20 text-gray-400 hover:text-blue-900 transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-110"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"
                          />
                        </svg>
                      </th>
                    </tr>
                  ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </>
  );
}
