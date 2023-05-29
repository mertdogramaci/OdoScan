import '../../App.css';
import React, { useEffect, useState } from "react";
import { Button } from 'reactstrap';
import { Link, useParams } from 'react-router-dom';
import AppNavbar from '../../AppNavbar';
import OdometerLogTable from '../tables/OdometerLogTable';


function OdometerLogsOfUserPage() {
  const [odometerLogs, setOdometerLogs] = useState([]);
  const { id } = useParams();
  const [user, setUser] = useState([]);

  useEffect(() => {
    fetch(`/odometerLog/mobile/${id}`).then(response => response.json()).then(data => {
      setOdometerLogs(data);
    })
  }, []);

  useEffect(() => {
    fetch(`/user/mobile/${id}`).then(response => response.json()).then(data => {
      setUser(data);
    })
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <div className="App-intro">
          <AppNavbar/>
          <h2>Odometer Logs For User: <br/> {user.name} {user.surname}</h2>
          <OdometerLogTable odometerLogs={odometerLogs} setOdometerLogs={setOdometerLogs}/>
          <Button tag={Link} to={"/odometerLog/create"}>Add Odometer Log</Button>
        </div>
      </header>
    </div>
  );
}

export default OdometerLogsOfUserPage;