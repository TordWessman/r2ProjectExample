using System;

namespace TestClient
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			TestClient mainFrame =  new TestClient ();

			mainFrame.Start ();

			mainFrame.Stop ();
		}
	}
}
