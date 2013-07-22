using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConvertHtmlToRegGen
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] readAllLines = File.ReadAllLines("repgen.html");
            var cleanedLines = readAllLines.Select(CleanLine).Where(line => line != null).ToList();

            File.WriteAllLines("converted", cleanedLines);
        }

        private static string CleanLine(string line)
        {
            if (string.IsNullOrWhiteSpace(line))
            {
                return null;
            }
            return "HTMLVIEWLINE(\"" + line.Replace("\"", "'") + "\")";
        }
    }
}
