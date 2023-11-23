Benchmark

Benchmark run from 2023-11-23 17:53:11.749718Z UTC

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
    <td style="white-space: nowrap; text-align: right">248.88</td>
    <td style="white-space: nowrap; text-align: right">4.02 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14.75%</td>
    <td style="white-space: nowrap; text-align: right">3.81 ms</td>
    <td style="white-space: nowrap; text-align: right">5.72 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">3.27</td>
    <td style="white-space: nowrap; text-align: right">305.72 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.14%</td>
    <td style="white-space: nowrap; text-align: right">305.02 ms</td>
    <td style="white-space: nowrap; text-align: right">317.72 ms</td>
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
    <td style="white-space: nowrap;text-align: right">248.88</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">3.27</td>
    <td style="white-space: nowrap; text-align: right">76.09x</td>
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
    <td style="white-space: nowrap">68.18 MB</td>
    <td>14.19x</td>
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
    <td style="white-space: nowrap; text-align: right">121.34</td>
    <td style="white-space: nowrap; text-align: right">8.24 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;142.36%</td>
    <td style="white-space: nowrap; text-align: right">7.35 ms</td>
    <td style="white-space: nowrap; text-align: right">13.61 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">21.10</td>
    <td style="white-space: nowrap; text-align: right">47.39 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;62.18%</td>
    <td style="white-space: nowrap; text-align: right">43.84 ms</td>
    <td style="white-space: nowrap; text-align: right">319.16 ms</td>
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
    <td style="white-space: nowrap;text-align: right">121.34</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">21.10</td>
    <td style="white-space: nowrap; text-align: right">5.75x</td>
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
    <td style="white-space: nowrap; text-align: right">368.32</td>
    <td style="white-space: nowrap; text-align: right">2.72 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;251.44%</td>
    <td style="white-space: nowrap; text-align: right">2.57 ms</td>
    <td style="white-space: nowrap; text-align: right">3.29 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">4.76</td>
    <td style="white-space: nowrap; text-align: right">210.14 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.45%</td>
    <td style="white-space: nowrap; text-align: right">209.83 ms</td>
    <td style="white-space: nowrap; text-align: right">211.96 ms</td>
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
    <td style="white-space: nowrap;text-align: right">368.32</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">4.76</td>
    <td style="white-space: nowrap; text-align: right">77.4x</td>
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
    <td style="white-space: nowrap">65.86 MB</td>
    <td>25.89x</td>
  </tr>
</table>