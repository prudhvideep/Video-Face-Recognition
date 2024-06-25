import SignIn from "./pages/SignIn";
import SignUp from "./pages/SignUp";
import SignOut from "./pages/SignOut";
import Dashboard from "./pages/Dashboard";
import { BrowserRouter as Router} from 'react-router-dom';
import {Routes, Route} from 'react-router-dom';
import PasswordReset from "./pages/PasswordReset";

function App() {
  return (
     <Router>
       <div>
         <section>
           <Routes>
             <Route index element={<SignIn/>}></Route>
             <Route path="/dashboard" element={<Dashboard />}></Route>
             <Route path="/signup" element={<SignUp/>}></Route>
             <Route path="/signout" element={<SignOut/>}></Route>
             <Route path="/passwordreset" element={<PasswordReset />}></Route>
           </Routes>
         </section>
       </div>
     </Router>
  );
}

export default App;
