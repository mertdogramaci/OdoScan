import '../../App.css';
import React, { useEffect, useState } from "react";
import UserTable from '../tables/UserTable';
import { Button } from 'reactstrap';
import { Link } from 'react-router-dom';
import AppNavbar from '../../AppNavbar';


function UsersPage() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetch('/user').then(response => response.json()).then(data => {
      setUsers(data);
    })
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <div className="App-intro">
          <AppNavbar/>
          <h2>User List</h2>
          <UserTable users={users} setUsers={setUsers}/>
          <Button tag={Link} to={"/user/create"}>Add User</Button>
        </div>
      </header>
    </div>
  );
}

export default UsersPage;