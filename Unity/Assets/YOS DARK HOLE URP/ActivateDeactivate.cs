using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Text.RegularExpressions; 

public class ActivateDeactivate : MonoBehaviour
{
    // Creamos esta referencia, para almacenar nuestro GameObject (la imagen) 
    public GameObject objectToActivateDeactivate;
    Thread receiveThread;
    private string strData;
    int contador = 0;    
    int numberData; 

    // Start is called before the first frame update
    void Start()
    {
        //infinito();
        InitUDP();
        Debug.Log("Hola");
    }

    private void infinito()
    {
        while(true)
        {
            contador = contador+1;
            Debug.Log("Primer");
        }
    }
    private void InitUDP()
    {
        print("UDP Initialized");

        receiveThread = new Thread(new ThreadStart(ReceiveData));
        receiveThread.IsBackground = true;
        receiveThread.Start();

    }

    private void ReceiveData()
    {
        Debug.Log("Inicio de la funcion");   
        byte[] serverData = new byte[1024];
        Debug.Log("Primer Paso");
        IPEndPoint endpoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 65535);

        Socket newSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
        newSocket.Bind(endpoint);

        Console.WriteLine("Waiting for the client...");
        
        Debug.Log("SALIO DEL WHILE");
        while (true)
        {
            try
            {
                byte[] data = new byte[1024]; 
                IPEndPoint client = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 65535);
                EndPoint addressClient = (EndPoint)client;
                Debug.Log("Esperando por la data");
                newSocket.ReceiveFrom(data, ref addressClient);
                    
                string strData = Encoding.Default.GetString(data);
                numberData = int.Parse(strData);
                //Console.WriteLine("Data: " + strData);
                //Debug.Log(strData.GetType());
                //strData = "hide";
                //Debug.Log(strData.GetType());
                if(numberData == 1)
                {
                    //objectToActivateDeactivate.SetActive(false);
                    Debug.Log("Acabo de entrar al hide");
                }
                else if(numberData == 0)
                {
                    objectToActivateDeactivate.SetActive(true);
                    Debug.Log("Acabo de entrar al show");
                }

                string message = "The server receive the data";
                serverData = Encoding.ASCII.GetBytes(message);
                newSocket.SendTo(serverData, addressClient);
            }
            catch(Exception e)
            {
                print(e.ToString());
            }
            
        }
    }
    // Update is called once per frame
    void Update()
    {
        Debug.Log(numberData);
        if(numberData == 1)
        {
            objectToActivateDeactivate.SetActive(false);
        }
        if(numberData == 2)
        {
            objectToActivateDeactivate.SetActive(true);
        }
    }
}
