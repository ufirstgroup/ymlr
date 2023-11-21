Benchmark

Benchmark run from 2023-11-21 21:51:23.068588Z UTC

## System

Benchmark suite executing on the following system:

<table style="width: 1%">
  <tr>
    <th style="width: 1%; white-space: nowrap">Operating System</th>
    <td>macOS</td>
  </tr><tr>
    <th style="white-space: nowrap">CPU Information</th>
    <td style="white-space: nowrap">Apple M2 Max</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">12</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">64 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.15.7</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">26.1.2</td>
  </tr>
</table>

## Configuration

Benchmark suite executing with the following configuration:

<table style="width: 1%">
  <tr>
    <th style="width: 1%">:time</th>
    <td style="white-space: nowrap">5 s</td>
  </tr><tr>
    <th>:parallel</th>
    <td style="white-space: nowrap">1</td>
  </tr><tr>
    <th>:warmup</th>
    <td style="white-space: nowrap">2 s</td>
  </tr>
</table>

## Statistics



__Input: CITM Catalog__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">Jason</td>
    <td style="white-space: nowrap; text-align: right">273.46</td>
    <td style="white-space: nowrap; text-align: right">3.66 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;15.86%</td>
    <td style="white-space: nowrap; text-align: right">3.37 ms</td>
    <td style="white-space: nowrap; text-align: right">5.53 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">3.50</td>
    <td style="white-space: nowrap; text-align: right">286.06 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.60%</td>
    <td style="white-space: nowrap; text-align: right">286.03 ms</td>
    <td style="white-space: nowrap; text-align: right">289.08 ms</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">Jason</td>
    <td style="white-space: nowrap;text-align: right">273.46</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">3.50</td>
    <td style="white-space: nowrap; text-align: right">78.23x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">Jason</td>
    <td style="white-space: nowrap">4.80 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap">67.38 MB</td>
    <td>14.02x</td>
  </tr>
</table>



__Input: Canada__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">Jason</td>
    <td style="white-space: nowrap; text-align: right">127.15</td>
    <td style="white-space: nowrap; text-align: right">7.86 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14.06%</td>
    <td style="white-space: nowrap; text-align: right">7.44 ms</td>
    <td style="white-space: nowrap; text-align: right">13.61 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">22.26</td>
    <td style="white-space: nowrap; text-align: right">44.91 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;19.91%</td>
    <td style="white-space: nowrap; text-align: right">44.52 ms</td>
    <td style="white-space: nowrap; text-align: right">58.06 ms</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">Jason</td>
    <td style="white-space: nowrap;text-align: right">127.15</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">22.26</td>
    <td style="white-space: nowrap; text-align: right">5.71x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">Jason</td>
    <td style="white-space: nowrap">9.22 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap">50.09 MB</td>
    <td>5.43x</td>
  </tr>
</table>



__Input: Twitter__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">Jason</td>
    <td style="white-space: nowrap; text-align: right">391.80</td>
    <td style="white-space: nowrap; text-align: right">2.55 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.91%</td>
    <td style="white-space: nowrap; text-align: right">2.57 ms</td>
    <td style="white-space: nowrap; text-align: right">2.94 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">4.93</td>
    <td style="white-space: nowrap; text-align: right">202.80 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.12%</td>
    <td style="white-space: nowrap; text-align: right">202.63 ms</td>
    <td style="white-space: nowrap; text-align: right">208.55 ms</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">Jason</td>
    <td style="white-space: nowrap;text-align: right">391.80</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">4.93</td>
    <td style="white-space: nowrap; text-align: right">79.46x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">Jason</td>
    <td style="white-space: nowrap">2.54 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap">65.35 MB</td>
    <td>25.69x</td>
  </tr>
</table>