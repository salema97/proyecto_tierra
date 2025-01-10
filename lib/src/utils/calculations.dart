String getSoilMoistureDescription(String humedadRelativa) {
  final humedad = double.parse(humedadRelativa);
  if (humedad < 20) {
    return "Seco";
  } else if (humedad < 40) {
    return "Ligeramente Seco";
  } else if (humedad < 60) {
    return "Moderadamente Húmedo";
  } else if (humedad < 80) {
    return "Húmedo";
  } else {
    return "Muy Húmedo";
  }
}

String getWeatherDescription(bool esDia, String temperaturaMAX6675) {
  final temperatura = double.parse(temperaturaMAX6675);
  if (esDia) {
    if (temperatura > 30) {
      return "Soleado";
    } else if (temperatura > 20) {
      return "Parcialmente Nublado";
    } else {
      return "Nublado";
    }
  } else {
    if (temperatura > 20) {
      return "Despejado";
    } else if (temperatura > 10) {
      return "Parcialmente Nublado";
    } else {
      return "Nublado";
    }
  }
}

String getVelocityDescription(double velocity) {
  if (velocity < 4.38356e-5) {
    return 'Extremadamente lento';
  } else if (velocity < 0.00274) {
    return 'Muy lento';
  } else if (velocity < 0.43) {
    return 'Lento';
  } else if (velocity < 43.2) {
    return 'Moderado';
  } else if (velocity < 4320) {
    return 'Rápido';
  } else if (velocity < 432000) {
    return 'Muy rápido';
  } else {
    return 'Extremadamente rápido';
  }
}

String getVelocityLimit(double velocity) {
  if (velocity < 4.38356e-5) {
    return '0.0000438 [m/dia]';
  } else if (velocity < 0.00274) {
    return '0.00274 [m/dia]';
  } else if (velocity < 0.43) {
    return '0.43 [m/dia]';
  } else if (velocity < 43.2) {
    return '43.2 [m/dia]';
  } else if (velocity < 4320) {
    return '4320 [m/dia]';
  } else if (velocity < 432000) {
    return '432000 [m/dia]';
  } else {
    return '> 432000 [m/dia]';
  }
}
