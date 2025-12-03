Feature: Visualización de datos IoT en tiempo real
  Como agricultor
  Quiero visualizar los datos de mis sensores en tiempo real
  Para monitorear el estado actual de mis cultivos sin retrasos

  Background:
    Given existe un dispositivo IoT registrado con id "sensor-100"

  Scenario: Lectura correcta de datos en tiempo real
    When consulto GET "/api/sensors/realtime?sensor_id=sensor-100"
    Then la respuesta debe tener código 200
    And el cuerpo debe incluir "temperature" y "soil_moisture"
    And cada valor debe contener un "timestamp"

  Scenario: Sensor desconectado o sin señal
    When consulto GET "/api/sensors/realtime?sensor_id=sensor-desconectado"
    Then la respuesta debe tener código 503
    And el cuerpo debe incluir "sensor_offline"

  Scenario: Actualización rápida de valores
    Given el sensor "sensor-100" envía nuevos valores al gateway IoT
    When consulto el endpoint de tiempo real
    Then los valores deben actualizarse en menos de 2 segundos

  Scenario: Sensor inexistente
    When consulto GET "/api/sensors/realtime?sensor_id=desconocido"
    Then la respuesta debe tener código 404
    And el cuerpo debe incluir "sensor_not_found"
