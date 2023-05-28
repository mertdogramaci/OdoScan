import '../../App.css';
import React, { useEffect, useState } from "react";
import VehicleTable from '../tables/VehicleTable';
import { Button } from 'reactstrap';
import { Link, useParams } from 'react-router-dom';
import AppNavbar from '../../AppNavbar';


function VehiclesOfUserPage() {
  const [vehicles, setVehicles] = useState([]);
  const { id } = useParams();
  const [user, setUser] = useState([]);

  useEffect(() => {
    fetch(`/vehicle/userId/${id}`).then(response => response.json()).then(data => {
      setVehicles(data);
    })
  }, []);

  useEffect(() => {
    fetch(`/user/${id}`).then(response => response.json()).then(data => {
      setUser(data);
    })
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <div className="App-intro">
          <AppNavbar/>
          <h2>{user.name} {user.surname}'s Vehicle List</h2>
          <VehicleTable vehicles={vehicles} setVehicles={setVehicles}/>
          <Button tag={Link} to={"/vehicle/create"}>Add Vehicle</Button>
        </div>
      </header>
    </div>
  );
}

export default VehiclesOfUserPage;