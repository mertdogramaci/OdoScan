import '../../App.css';
import React, { useEffect, useState } from "react";
import { Button } from 'reactstrap';
import { Link } from 'react-router-dom';
import AppNavbar from '../../AppNavbar';
import OdometerLogTable from '../tables/OdometerLogTable';


function OdometerLogsPage() {
  const [odometerLogs, setOdometerLogs] = useState([]);

  useEffect(() => {
    fetch('/odometerLog').then(response => response.json()).then(data => {
        setOdometerLogs(data);
    })
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <div className="App-intro">
          <AppNavbar/>
          <h2>Odometer Logs List</h2>
          <OdometerLogTable odometerLogs={odometerLogs} setOdometerLogs={setOdometerLogs}/>
          <Button tag={Link} to={"/vehicle/create"}>Add Vehicle</Button>
        </div>
      </header>
    </div>
  );
}

export default OdometerLogsPage;