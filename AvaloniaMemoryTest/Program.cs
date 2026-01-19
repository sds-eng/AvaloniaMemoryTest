using System;
using System.Linq;
using System.Threading;
using Avalonia;

namespace AvaloniaMemoryTest
{
    internal class Program
    {
        // Initialization code. Don't use any Avalonia, third-party APIs or any
        // SynchronizationContext-reliant code before AppMain is called: things aren't initialized
        // yet and stuff might break.
        [STAThread]
        public static void Main(string[] args) => BuildAvaloniaApp(args)
            .StartWithClassicDesktopLifetime(args);


        // Avalonia configuration, don't remove; also used by visual designer.
        public static AppBuilder BuildAvaloniaApp(string[] args)
        {
            var app = AppBuilder.Configure<App>()
                .UsePlatformDetect()
                .WithInterFont()
                .LogToTrace();

            if (args.ToList().Contains("--drm"))
            {
                SilenceConsole();
                app.StartLinuxDrm(args: args, card: null, scaling: 1.0);
            }

            return app;
        }

        public static void SilenceConsole()
        {
            new Thread(start: static () =>
                {
                    Console.CursorVisible = false;
                    while (true)
                        Console.ReadKey(true);
                    // ReSharper disable once FunctionNeverReturns
                })
                { IsBackground = true }.Start();
        }
    }
}

