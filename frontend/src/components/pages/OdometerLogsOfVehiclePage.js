import '../../App.css';
import React, { useEffect, useState } from "react";
import VehicleTable from '../tables/VehicleTable';
import { Button } from 'reactstrap';
import { Link, useParams } from 'react-router-dom';
import AppNavbar from '../../AppNavbar';
import OdometerLogTable from '../tables/OdometerLogTable';


function OdometerLogsOfVehiclePage() {
  const [odometerLogs, setOdometerLogs] = useState([]);
  const { id } = useParams();
  const [vehicle, setVehicles] = useState([]);

  useEffect(() => {
    fetch(`/odometerLog/vehicleId/${id}`).then(response => response.json()).then(data => {
      setOdometerLogs(data);
    })
  }, []);

  useEffect(() => {
    fetch(`/vehicle/${id}`).then(response => response.json()).then(data => {
      setVehicles(data);
    })
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <div className="App-intro">
          <AppNavbar/>
          <h2>Odometer Logs For Vehicle: <br/> {vehicle.brand} {vehicle.model}</h2>
          <OdometerLogTable odometerLogs={odometerLogs} setOdometerLogs={setOdometerLogs}/>
          <Button tag={Link} to={"/vehicle/create"}>Add Vehicle</Button>
        </div>
      </header>
      <footer>Copyright © 2023 Rock of MAM</footer>
    </div>
  );
}

export default OdometerLogsOfVehiclePage;