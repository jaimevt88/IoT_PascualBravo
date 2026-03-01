let partes = msg.topic.split("/");
if (partes.length < 3) return null;

let ubicacion = partes[0];
let sensor = partes[1];
let variable = partes[2];
let valor = Number(msg.payload.valor);

/* -------- SALIDA 1 : nodo Influx (plugin) -------- */
let msgInflux = {
    measurement: "temperatura_plugin",
    payload: { valor: valor },
    tags: {
        sensor: sensor,
        ubicacion: ubicacion
    }
};

/* -------- SALIDA 2 : HTTP API (line protocol) -------- */
let msgHTTP = {
    payload: `temperatura_http,sensor=${sensor},ubicacion=${ubicacion} valor=${valor}`
};

return [msgInflux, msgHTTP];
