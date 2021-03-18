#define BITMASK_COMMAND B11100000
#define BITMASK_PAYLOAD B00011111
#define BITMASK_ACK B00000001
#define BITMASK_NACK B00000010
#define ACK_INVALID_COMMAND_RECEIVED B00000001
#define PAIR_COMMAND B00000000
#define START_COMMAND B00000000
#define STOP_COMMAND B00000000
#define RESET_COMMAND B00000000
#define GET_DATA_COMMAND B00000000
#define STATUS_NO_BEAT B00000000
#define STATUS_BEAT B10000000
#define STATUS_SENSOR_ERROR B01000000

#define testPin 13
#define buzzerPin 7
#define sensorPinHR 2
#define beatPin 5

byte inByte, cmdByte, payloadByte; // Holds received data from serial connection
bool flag_isReadyToReceive, flag_isPaired;

unsigned int ibi;

volatile bool flag_isBeat = false, flag_isSensorError = false;
volatile unsigned long sensorPinHR_CurrentTime = 0;
volatile unsigned long sensorPinHR_LastTime = 0;
volatile unsigned long deltaTime = 0;
volatile unsigned int TL = 400;

void setup()
{
  flag_isReadyToReceive = true;
  flag_isPaired = false;

  attachInterrupt(digitalPinToInterrupt(sensorPinHR), sensorPinHR_ISR, RISING); // Attach an interrupt to the ISR vector
  Serial.begin(115200);

  pinMode(testPin, OUTPUT);
  digitalWrite(testPin, LOW);

  pinMode(buzzerPin, OUTPUT);
  pinMode(beatPin, OUTPUT);

  digitalWrite(buzzerPin, 255);
  digitalWrite(testPin, HIGH);
  delay(10);
  digitalWrite(buzzerPin, 0);
  digitalWrite(testPin, LOW);
}

void loop()
{
  ReceiveParseCommand();
  digitalWrite(beatPin, LOW);
}

void ReceiveParseCommand()
{
  if (Serial.available() > 0 && flag_isReadyToReceive)
  {
    inByte = Serial.read();
    cmdByte = inByte & BITMASK_COMMAND;
    payloadByte = inByte & BITMASK_PAYLOAD;
    // Recognizing Commands
    switch (cmdByte)
    {
    case 0x20: // Pairing
      Pairing();
      break;
    case 0xA0: // Get Data
      GetData();
      break;
    default: // Invalid command
      Serial.write(ACK_INVALID_COMMAND_RECEIVED);
      break;
    }
  }
}

void Pairing()
{
  if (!flag_isPaired)
  {
    flag_isPaired = true;
    Serial.write(cmdByte | BITMASK_ACK);
  }
  else if (flag_isPaired)
  {
    Serial.write(cmdByte | BITMASK_NACK);
  }
}


void GetData()
{
  flag_isReadyToReceive = false;
  // -> send data payload
  //  Serial.write(cmdByte | BITMASK_ACK);
  if (flag_isBeat)
  {
    Serial.write((ibi >> 8) | STATUS_BEAT); // MSB
    Serial.write(ibi);                      // LSB
    flag_isBeat = false;
  }
  else
  {
    Serial.write((ibi >> 8) | STATUS_NO_BEAT); // MSB
    Serial.write(ibi);                         // LSB
  }

  flag_isReadyToReceive = true;
}


//------------------------------------------ ISR for HR sensor ------------------------------------------------
void sensorPinHR_ISR()
{
  sensorPinHR_CurrentTime = millis();
  deltaTime = sensorPinHR_CurrentTime - sensorPinHR_LastTime;
  if (deltaTime >= TL)
  {
    flag_isBeat = true;
    ibi = deltaTime;
    sensorPinHR_LastTime = sensorPinHR_CurrentTime;
    digitalWrite(beatPin, HIGH);
  }
}
