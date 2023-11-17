Benchmark

Benchmark run from 2023-11-20 14:52:22.679140Z UTC

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
    <td style="white-space: nowrap; text-align: right">279.16</td>
    <td style="white-space: nowrap; text-align: right">3.58 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13.81%</td>
    <td style="white-space: nowrap; text-align: right">3.34 ms</td>
    <td style="white-space: nowrap; text-align: right">4.81 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">3.64</td>
    <td style="white-space: nowrap; text-align: right">274.95 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.71%</td>
    <td style="white-space: nowrap; text-align: right">275.05 ms</td>
    <td style="white-space: nowrap; text-align: right">278.58 ms</td>
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
    <td style="white-space: nowrap;text-align: right">279.16</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">3.64</td>
    <td style="white-space: nowrap; text-align: right">76.76x</td>
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
    <td style="white-space: nowrap">65.74 MB</td>
    <td>13.68x</td>
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
    <td style="white-space: nowrap; text-align: right">122.70</td>
    <td style="white-space: nowrap; text-align: right">8.15 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14.44%</td>
    <td style="white-space: nowrap; text-align: right">7.75 ms</td>
    <td style="white-space: nowrap; text-align: right">13.64 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">21.67</td>
    <td style="white-space: nowrap; text-align: right">46.15 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;20.12%</td>
    <td style="white-space: nowrap; text-align: right">46.06 ms</td>
    <td style="white-space: nowrap; text-align: right">61.63 ms</td>
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
    <td style="white-space: nowrap;text-align: right">122.70</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">21.67</td>
    <td style="white-space: nowrap; text-align: right">5.66x</td>
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
    <td style="white-space: nowrap; text-align: right">376.78</td>
    <td style="white-space: nowrap; text-align: right">2.65 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.50%</td>
    <td style="white-space: nowrap; text-align: right">2.64 ms</td>
    <td style="white-space: nowrap; text-align: right">2.87 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">5.40</td>
    <td style="white-space: nowrap; text-align: right">185.32 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.98%</td>
    <td style="white-space: nowrap; text-align: right">184.82 ms</td>
    <td style="white-space: nowrap; text-align: right">190.55 ms</td>
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
    <td style="white-space: nowrap;text-align: right">376.78</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">5.40</td>
    <td style="white-space: nowrap; text-align: right">69.83x</td>
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
    <td style="white-space: nowrap">52.62 MB</td>
    <td>20.69x</td>
  </tr>
</table>