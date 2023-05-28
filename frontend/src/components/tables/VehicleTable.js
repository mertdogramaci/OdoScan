import React from "react";
import { Link } from "react-router-dom";
import { Button, ButtonGroup } from "reactstrap";

function VehicleTable(probs) {
    function remove(id) {
        fetch(`/vehicle/${id}`, {
          method: 'DELETE',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        }).then(() => {
          const updatedVehicles = [...probs.vehicles].filter(i => i.id !== id);
          probs.setVehicles(updatedVehicles);
        });
    }

    return (
        <table className="styled-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Vehicle Type</th>
                    <th>Brand</th>
                    <th>Model</th>
                    <th>Purchase Year</th>
                    <th>Owner</th>
                    <th>Odometer Logs</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                {probs.vehicles.map((vehicle) => {
                    return (
                        <tr key={vehicle.id}>
                            <th>{vehicle.id}</th>
                            <th>{vehicle.vehicleType}</th>
                            <th>{vehicle.brand}</th>
                            <th>{vehicle.model}</th>
                            <th>{vehicle.purchaseYear}</th>
                            <th>{vehicle.user.name} {vehicle.user.surname}</th>
                            <th>
                                <Button size="sm" color="primary" tag={Link} to={"/odometerLog/vehicleId/" + vehicle.id}>Show Odometer Logs</Button>
                            </th>
                            <th>
                                <ButtonGroup>
                                    <Button size="sm" color="primary" tag={Link} to={"/vehicle/" + vehicle.id}>Edit</Button>
                                    <Button size="sm" color="primary" onClick={() => remove(vehicle.id)}>Delete</Button>
                                </ButtonGroup>
                            </th>
                        </tr>
                    );
                })}
            </tbody>
        </table>
    );
}

export default VehicleTable;