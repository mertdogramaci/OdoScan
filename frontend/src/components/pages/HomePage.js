import AppNavbar from "../../AppNavbar";
import img from "../../images/speedometer-clipart-design-illustration-free-png.webp"

function HomePage() {
    return (
        <div>
            <AppNavbar/>
            <br/>
            <br/>
            <img src={img} alt="Logo" style={{ width: 400 }}/>
            <br/>
            <br/>
            <h1 style={{fontSize: 100}}>OdoScan</h1>
            <h3 style={{fontWeight: "normal"}}>Extracting Miles and Kilometers From Odometer Pictures</h3>
            <footer>
                <b>Developed by:</b> Rock of MAM
                <br/>
                <p style={{fontSize: 14}}>Melih AKSOY, Ali Aykut ARIK, Mert DOĞRAMACI</p>
            </footer>
        </div>
    );
}

export default HomePage;