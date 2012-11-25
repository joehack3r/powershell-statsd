<#
.SYNOPSIS

Send metrics to statsd server.

.DESCRIPTION

PowerShell cmdlet to send metric data to statsd server.  Unless IP or port is passed, tries the default IP of 127.0.0.1 and port of 8125.

.PARAMETER data

Metric data to send to statsd.  If string is not enclosed in quotes (single or double), the pipe character needs to be escaped.

.PARAMETER ip

IP address for statsd server

.PARAMETER port

Port that statsd server is listening to

.EXAMPLE

Send-Statsd "my_metric:123|g"

.EXAMPLE

Send-Statsd "my_metric:123|g" -ip 127.0.0.1 -port 8125

.EXAMPLE

Send-Statsd my_metric:321`|g -ip 10.0.0.10 -port 8180

.EXAMPLE

Send-Statsd 'my_metric:321|g' -ip 10.0.0.10 -port 8180

#>

param(
  [parameter(Mandatory=$true, ValueFromPipeline=$true)]
  [string]
  $data,

  [parameter(Mandatory=$false, ValueFromPipeline=$true)]
  [string]
  $ip="127.0.0.1",
  
  [parameter(Mandatory=$false, ValueFromPipeline=$true)]
  [int]
  $port=8125
)

#Statsd running on localhost on port 8125
$ipAddress=[System.Net.IPAddress]::Parse($ip) 

#Create endpoint and udp client
$endPoint=New-Object System.Net.IPEndPoint($ipAddress, $port)
$udpclient=New-Object System.Net.Sockets.UdpClient

#Encode and send the data
$encodedData=[System.Text.Encoding]::ASCII.GetBytes($data)
$bytesSent=$udpclient.Send($encodedData,$encodedData.length,$endPoint)

#Cleanup after yourself
$udpclient.Close()
