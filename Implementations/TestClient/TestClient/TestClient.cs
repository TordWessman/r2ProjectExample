using System;
using Core.Scripting;
using Core;
using System.IO;
using PushNotifications;
using Core.Memory;
using Core.Network.Web;
using Audio;

namespace TestClient
{
	public class TestClient
	{	
		private BaseContainer m_base;
		private IScriptProcess m_setupScript;
		private AudioFactory m_audioFactory;
		private WebFactory m_webFactory;

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

			var httpFactory = deviceFactory.CreateWebFactory ("http_factory");
				
			// Create a simple http server
			IWebServer httpServer = httpFactory.CreateHttpServer (Settings.Identifiers.HttpServer(), Settings.Consts.HttpPort());

			// Creates a receiver capable of communicating object data ("remote controll" of devices.)
			IWebObjectReceiver receiver = httpFactory.CreateDeviceObjectReceiver ();

			// Creates an endpoint listening to the path "/json" using the receiver for interpreting requests.
			IWebEndpoint jsonEndpoint = httpFactory.CreateJsonEndpoint ("/json", receiver);

			// Add the json endpoint to the server
			httpServer.AddEndpoint (jsonEndpoint);

			// Add another endpoint serving files
			httpServer.AddEndpoint (httpFactory.CreateFileEndpoint (Settings.Paths.WebImages(), Settings.Consts.ImageListenerPath()));

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
