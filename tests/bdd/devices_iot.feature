Feature: Gestión de dispositivos IoT vinculados a cultivos
  Como productor agrícola
  Quiero conectar y desconectar sensores IoT
  Para monitorear mis cultivos

  Background:
    Given estoy autenticado
    And existe cropId="crop-10"

  # US-13: Conectar
  Scenario: S1 Conectar un dispositivo IoT
    When envío POST "/api/devices/connect" con JSON:
      """
      { "device_id":"sensor-abc", "crop_id":"crop-10", "type":"soil-ph" }
      """
    Then 200
    And el cuerpo incluye "linked":true and "device_id":"sensor-abc"

  Scenario: S2 Rechazar dispositivo duplicado o ajeno
    Given "sensor-xyz" ya está vinculado a otro usuario
    When envío POST "/api/devices/connect" con JSON:
      """
      { "device_id":"sensor-xyz", "crop_id":"crop-10" }
      """
    Then 403

  Scenario: S3 Confirmación de conexión
    When envío GET "/api/devices?crop_id=crop-10"
    Then 200
    And la lista incluye "sensor-abc"

  # US-14: Desconectar
  Scenario: S4 Desconectar un dispositivo IoT
    Given "sensor-abc" está vinculado a "crop-10"
    When envío POST "/api/devices/disconnect" con JSON:
      """
      { "device_id":"sensor-abc", "crop_id":"crop-10" }
      """
    Then 200
    And GET "/api/devices?crop_id=crop-10" no incluye "sensor-abc"

  Scenario: S5 Desconexión idempotente (ya estaba desconectado)
    When envío POST "/api/devices/disconnect" con JSON:
      """
      { "device_id":"sensor-abc", "crop_id":"crop-10" }
      """
    Then 200
    And el cuerpo indica "linked":false
