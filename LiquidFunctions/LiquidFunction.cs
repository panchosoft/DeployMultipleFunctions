using System.IO;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;

namespace LiquidFunctions
{
    /// <summary>
    /// Azure Function that processes HTTP requests and returns a personalized greeting.
    /// </summary>
    public class LiquidFunction
    {
        private readonly ILogger<LiquidFunction> _logger;

        /// <summary>
        /// Constructor that accepts an ILogger instance for logging.
        /// </summary>
        /// <param name="log">ILogger instance for logging information.</param>
        public LiquidFunction(ILogger<LiquidFunction> log)
        {
            _logger = log;
        }

        /// <summary>
        /// This method is triggered by an HTTP request. It accepts a 'name' parameter via query string or request body and returns a personalized message.
        /// </summary>
        /// <param name="req">The HTTP request that triggers this function.</param>
        /// <returns>A personalized greeting message.</returns>
        [FunctionName("LiquidFunction")]
        [OpenApiOperation(operationId: "Run", tags: new[] { "name" })]
        [OpenApiSecurity("function_key", SecuritySchemeType.ApiKey, Name = "code", In = OpenApiSecurityLocationType.Query)]
        [OpenApiParameter(name: "name", In = ParameterLocation.Query, Required = true, Type = typeof(string), Description = "The **Name** parameter")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "text/plain", bodyType: typeof(string), Description = "The OK response")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req)
        {
            // Log the receipt of an HTTP request
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            // Retrieve the 'name' parameter from the query string
            string name = req.Query["name"];

            // Read the request body as a string
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);

            // Use the 'name' from the request body if it wasn't provided in the query string
            name ??= data?.name;

            // Create a response message
            string responseMessage = string.IsNullOrEmpty(name)
                ? "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
                : $"Hello, {name}. This HTTP triggered function executed successfully.";

            // Return an OK result with the response message
            return new OkObjectResult(responseMessage);
        }
    }
}