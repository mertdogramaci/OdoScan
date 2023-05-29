import './App.css';
import React from "react";
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import UsersPage from './components/pages/UsersPage';
import HomePage from './components/pages/HomePage';
import VehiclesPage from './components/pages/VehiclesPage';
import VehiclesOfUserPage from './components/pages/VehiclesOfUserPage';
import OdometerLogsPage from './components/pages/OdometerLogsPage';
import OdometerLogsOfVehiclePage from './components/pages/OdometerLogsOfVehiclePage';
import EditUser from './components/pages/EditUser';
import EditVehicle from './components/pages/EditVehicle';
import OdometerLogsOfUserPage from './components/pages/OdometerLogsOfUserPage';


function App() {
  return (
    <div className='App'>
      <BrowserRouter>
        <Routes>
          <Route exact element={<HomePage />} path={"/"} />
          <Route exact element={<UsersPage />} path={"/user"} />
          <Route exact element={<VehiclesPage />} path={"/vehicle"}/>
          <Route exact element={<VehiclesOfUserPage />} path={"/vehicle/userId/:id"}/>
          <Route exact element={<OdometerLogsPage />} path={"/odometerLog"}/>
          <Route exact element={<OdometerLogsOfVehiclePage />} path={"/odometerLog/vehicleId/:id"}/>
          <Route exact element={<EditUser />} path={'/user/:id'} />
          <Route exact element={<EditUser />} path={"/user/create"} />
          <Route exact element={<EditVehicle/>} path={"/vehicle/create"}/>
          <Route exact element={<EditVehicle/>} path={"/vehicle/:id"}/>
          <Route exact element={<OdometerLogsOfUserPage/>} path={"/odometerLog/mobile/:id"}/>
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
