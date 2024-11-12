// import express from "express";
// import cors from "cors";
// import { MercadoPagoConfig, Preference } from "mercadopago";
// import fetch from "node-fetch"; // Si usas un entorno donde fetch no está nativo, asegúrate de tenerlo instalado

// const client = new MercadoPagoConfig({ accessToken: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXx" });

// const app = express();
// const port = 3000;

// app.use(cors());
// app.use(express.json());

// app.get("/", (req, res) => {
//     res.send("Soy el server :)");
// });

// app.post("/create_preferences", async (req, res) => {
//     try {
//         const { items, back_urls } = req.body; // Se pueden recibir items y back_urls desde el frontend

//         const body = {
//             items: [
//                 {   //TODO:EJEMPLO
//                     // title: req.body.title,
//                     // quantity: Number(req.body.quantity),
//                     // unit_price: Number(req.body.price),
//                     // currency_id: "CLP"

//                     title: "Zapatillas",
//                     quantity: Number(2),
//                     unit_price: Number(100),
//                     currency_id: "ARS"
//                 }
//             ],
//             back_urls: back_urls || {
//                 success: "miapp://success",
//                 failure: "miapp://failure",
//                 pending: "miapp://pending"
//             },
//             auto_return: "approved"
//         };

//         const preferences = new Preference(client);
//         const result = await preferences.create({ body });

//         res.status(201).json({
//             init_point: result.init_point,
//             sandbox_init_point: result.sandbox_init_point,
//             id: result.id,
//             status: result.api_response.status
//         });
//     } catch (error) {
//         console.error("Error al crear la preferencia:", error);
//         res.status(500).json({
//             error: "Error al crear la preferencia"
//         });
//     }
// });

// // Nuevo endpoint para verificar el estado de un pago por ID
// app.get("/verificar_estado_pago/:id", async (req, res) => {
//     const paymentId = req.params.id;

//     try {
//         const response = await fetch(`https://api.mercadopago.com/v1/payments/${paymentId}`, {
//             method: "GET",
//             headers: {
//                 "Authorization": `Bearer ${client.accessToken}`
//             }
//         });

//         if (!response.ok) {
//             return res.status(response.status).json({
//                 error: `Error al obtener el estado del pago: ${response.statusText}`
//             });
//         }

//         const data = await response.json();

//         // Verifica el estado del pago
//         const status = data.status; // Ejemplo de valores: 'approved', 'pending', 'rejected', etc.

//         res.json({
//             id: paymentId,
//             status,
//             status_detail: data.status_detail,
//             transaction_amount: data.transaction_amount,
//             payment_method_id: data.payment_method_id,
//             date_approved: data.date_approved,
//             payer_email: data.payer?.email || '',
//             message: status === 'approved' ? 'Pago aprobado' : 'Pago no aprobado'
//         });
//     } catch (error) {
//         console.error("Error al verificar el estado del pago:", error);
//         res.status(500).json({
//             error: "Error interno al verificar el estado del pago"
//         });
//     }
// });

// app.listen(port, () => {
//     console.log(`Escuchando en el puerto ${port}`);
// });



//--------------------------------------------------------------------------------

import express from "express";
import cors from "cors";
import { MercadoPagoConfig, Preference} from "mercadopago";


const client = new MercadoPagoConfig({accessToken: "APP_USR-2895292226517850-110717-f814a027703fac30e6e1888c13963103-256622141"})


const app = express();
const port = 3000;

app.use(cors());

app.use(express.json());

app.get("/", (req, res) =>{
    res.send(" Soy el server :) ");
});

app.listen(port,()=>{
    console.log(`Escuchando en el puerto${port}`);
});

app.post("/create_preferences", async (req,res)=>{
    try {
        const body ={
            items:[
                {
                    //TODO:EJEMPLO
                    // title: req.body.title,
                    // quantity: Number(req.body.quantity),
                    // unit_price: Number(req.body.price),
                    // currency_id: "CLP"

                    title: "Zapatillas",
                    quantity: Number(2),
                    unit_price: Number(100),
                    currency_id: "ARS"
                }
            ],
            back_urls: {
                success: "miapp://success",
                failure: "miapp://failure",
                pending: "miapp://pending"
              },
            auto_return:"approved"
        };


        const preferences = new Preference(client);
        const result = await preferences.create({body});
        console.log(result);
        res.json({
            url:result.sandbox_init_point,
            id:result.id,
        });
    } catch (error) {
        console.log(error);
        res.status(500).json({
            error:"Error al crear la preferencia"
        });
    }

});