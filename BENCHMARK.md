Benchmark

Benchmark run from 2023-11-23 21:52:00.638488Z UTC

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
    <td style="white-space: nowrap; text-align: right">271.78</td>
    <td style="white-space: nowrap; text-align: right">3.68 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14.00%</td>
    <td style="white-space: nowrap; text-align: right">3.44 ms</td>
    <td style="white-space: nowrap; text-align: right">4.95 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">70.89</td>
    <td style="white-space: nowrap; text-align: right">14.11 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.32%</td>
    <td style="white-space: nowrap; text-align: right">14.06 ms</td>
    <td style="white-space: nowrap; text-align: right">15.51 ms</td>
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
    <td style="white-space: nowrap;text-align: right">271.78</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">70.89</td>
    <td style="white-space: nowrap; text-align: right">3.83x</td>
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
    <td style="white-space: nowrap; text-align: right">124.25</td>
    <td style="white-space: nowrap; text-align: right">8.05 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14.06%</td>
    <td style="white-space: nowrap; text-align: right">7.67 ms</td>
    <td style="white-space: nowrap; text-align: right">13.61 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">30.69</td>
    <td style="white-space: nowrap; text-align: right">32.58 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8.57%</td>
    <td style="white-space: nowrap; text-align: right">33.61 ms</td>
    <td style="white-space: nowrap; text-align: right">36.95 ms</td>
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
    <td style="white-space: nowrap;text-align: right">124.25</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">30.69</td>
    <td style="white-space: nowrap; text-align: right">4.05x</td>
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
    <td style="white-space: nowrap; text-align: right">372.32</td>
    <td style="white-space: nowrap; text-align: right">2.69 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.89%</td>
    <td style="white-space: nowrap; text-align: right">2.67 ms</td>
    <td style="white-space: nowrap; text-align: right">3.22 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">123.21</td>
    <td style="white-space: nowrap; text-align: right">8.12 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.95%</td>
    <td style="white-space: nowrap; text-align: right">8.11 ms</td>
    <td style="white-space: nowrap; text-align: right">8.59 ms</td>
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
    <td style="white-space: nowrap;text-align: right">372.32</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">123.21</td>
    <td style="white-space: nowrap; text-align: right">3.02x</td>
  </tr>

</table>