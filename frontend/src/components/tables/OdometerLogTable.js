import React from "react";
import { Link } from "react-router-dom";
import { Button, ButtonGroup } from "reactstrap";

function OdometerLogTable(probs) {
    function remove(id) {
        fetch(`/odometerLog/${id}`, {
          method: 'DELETE',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        }).then(() => {
          const updatedOdometerLogs = [...probs.odometerLogs].filter(i => i.id !== id);
          probs.setOdometerLogs(updatedOdometerLogs);
        });
    }

    return (
        <table className="styled-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Odometer Reading</th>
                    <th>Record Date</th>
                    <th>Vehicle</th>
                    <th>Owner</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                {probs.odometerLogs.map((odometerLog) => {
                    return (
                        <tr key={odometerLog.id}>
                            <th>{odometerLog.id}</th>
                            <th>{odometerLog.odometerReading} {odometerLog.unit}</th>
                            <th>{odometerLog.recordDate}</th>
                            <th>{odometerLog.vehicle.brand} {odometerLog.vehicle.model}</th>
                            <th>{odometerLog.vehicle.user.name} {odometerLog.vehicle.user.surname}</th>
                            <th>
                                <ButtonGroup>
                                    <Button size="sm" color="primary" tag={Link} to={"/odometerLog/" + odometerLog.id}>Edit</Button>
                                    <Button size="sm" color="primary" onClick={() => remove(odometerLog.id)}>Delete</Button>
                                </ButtonGroup>
                            </th>
                        </tr>
                    );
                })}
            </tbody>
        </table>
    );
}

export default OdometerLogTable;