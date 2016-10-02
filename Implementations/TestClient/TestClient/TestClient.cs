using System;
using Core.Scripting;
using Core;
using System.IO;
using PushNotifications;
using Core.Memory;
using Core.Network.Http;
using Audio;

namespace TestClient
{
	public class TestClient
	{	
		private BaseContainer m_base;
		private IScriptProcess m_setupScript;
		private AudioFactory m_audioFactory;

		public TestClient ()
		{

			// Set up the base container containing standard functionality. Specifiy name of database and external communication port
			m_base = new BaseContainer (Settings.Consts.DbName(), 1236);

			// Retrieve the device factory
			var deviceFactory = m_base.GetDevice<DeviceFactory> (Settings.Identifiers.DeviceFactory ());

			// Retrieve the script factory used to create (Ruby) scripts.
			var scriptFactory = m_base.DeviceManager.Get<IScriptFactory> (Settings.Identifiers.ScriptFactory ());

			// Create the setup script for the test client. 
			m_setupScript = scriptFactory.CreateProcess (Settings.Identifiers.SetupScript());

			// Add the setup script to the task monitor
			m_base.TaskMonitor.AddMonitorable (m_setupScript);

			// Creates an audio factory instance. 
			m_audioFactory = new AudioFactory ("audio_factory", Settings.Paths.Audio());

			// Add the audio factory to the known devices list.
			m_base.AddDevice (m_audioFactory);

			// Set up http server
			IHttpServer httpServer = deviceFactory.CreateHttpServer (Settings.Identifiers.HttpServer(), Settings.Consts.HttpPort());

			// Adds a Json interpreter which opens up access to devices implementing the "IJSONAccessible" interface to be accessed through the http server
			httpServer.AddInterpreter (deviceFactory.CreateJsonInterpreter (Settings.Consts.DeviceListenerPath()));

			// Adds an image feeder which allows the transmission of images through the http server
			httpServer.AddInterpreter (deviceFactory.CreateImageInterpreter (Settings.Paths.WebImages(), Settings.Consts.ImageListenerPath()));

			// Add the httpServer to the known devices list.
			m_base.AddDevice (httpServer);

			// Start the http server
			httpServer.Start();

			// Start the setup script
			m_setupScript.Start ();

		}

		public void Start ()
		{
			// Will initiate and start the base container devices.
			m_base.Start ();

			// Initiates the run loop.
			m_base.RunLoop ();
		}

		public void Stop ()
		{
			m_base.Stop ();	

		}
	}

}
