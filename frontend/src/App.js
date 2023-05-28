import './App.css';
import React from "react";
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import UsersPage from './components/pages/UsersPage';
import HomePage from './components/pages/HomePage';
import VehiclesPage from './components/pages/VehiclesPage';
import VehiclesOfUserPage from './components/pages/VehiclesOfUserPage';
import OdometerLogsPage from './components/pages/OdometerLogsPage';
import OdometerLogsOfVehiclePage from './components/pages/OdometerLogsOfVehiclePage';


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
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
