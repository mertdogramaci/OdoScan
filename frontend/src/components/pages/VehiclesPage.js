import '../../App.css';
import React, { useEffect, useState } from "react";
import VehicleTable from '../tables/VehicleTable';
import { Button } from 'reactstrap';
import { Link } from 'react-router-dom';
import AppNavbar from '../../AppNavbar';


function VehiclesPage() {
  const [vehicles, setVehicles] = useState([]);

  useEffect(() => {
    fetch('/vehicle').then(response => response.json()).then(data => {
      setVehicles(data);
    })
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <div className="App-intro">
          <AppNavbar/>
          <h2>Vehicle List</h2>
          <VehicleTable vehicles={vehicles} setVehicles={setVehicles}/>
          <Button tag={Link} to={"/vehicle/create"}>Add Vehicle</Button>
        </div>
      </header>
      <footer>Copyright © 2023 Rock of MAM</footer>
    </div>
  );
}

export default VehiclesPage;