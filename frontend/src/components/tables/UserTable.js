import React from "react";
import { Link } from "react-router-dom";
import { Button, ButtonGroup } from "reactstrap";

function UserTable(probs) {
    function remove(id) {
        fetch(`/user/${id}`, {
          method: 'DELETE',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        }).then(() => {
          const updatedUsers = [...probs.users].filter(i => i.id !== id);
          probs.setUsers(updatedUsers);
        });
    }

    return (
        <table className="styled-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Surname</th>
                    <th>Phone Number</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th>Device ID</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                {probs.users.map((user) => {
                    return (
                        <tr key={user.id}>
                            <th>{user.id}</th>
                            <th>{user.name}</th>
                            <th>{user.surname}</th>
                            <th>{user.phone}</th>
                            <th>{user.mail}</th>
                            <th>{user.address}</th>
                            <th>{user.deviceId}</th>
                            <th>
                                <ButtonGroup>
                                    <Button size="sm" color="primary" tag={Link} to={"/vehicle/userId/" + user.id}>Show Vehicles</Button>
                                    <Button size="sm" color="primary" tag={Link} to={"/odometerLog/mobile/" + user.deviceId}>Show Odometer Logs</Button>
                                    <Button size="sm" color="primary" tag={Link} to={"/user/" + user.id}>Edit</Button>
                                    <Button size="sm" color="primary" onClick={() => remove(user.id)}>Delete</Button>
                                </ButtonGroup>
                            </th>
                        </tr>
                    );
                })}
            </tbody>
        </table>
    );
}

export default UserTable;