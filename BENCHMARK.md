Benchmark

Benchmark run from 2023-11-18 14:03:41.157149Z UTC

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
    <td style="white-space: nowrap; text-align: right">267.76</td>
    <td style="white-space: nowrap; text-align: right">3.73 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14.12%</td>
    <td style="white-space: nowrap; text-align: right">3.45 ms</td>
    <td style="white-space: nowrap; text-align: right">4.99 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">22.80</td>
    <td style="white-space: nowrap; text-align: right">43.87 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2.48%</td>
    <td style="white-space: nowrap; text-align: right">43.77 ms</td>
    <td style="white-space: nowrap; text-align: right">48.11 ms</td>
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
    <td style="white-space: nowrap;text-align: right">267.76</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">22.80</td>
    <td style="white-space: nowrap; text-align: right">11.75x</td>
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
    <td style="white-space: nowrap">40.60 MB</td>
    <td>8.45x</td>
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
    <td style="white-space: nowrap; text-align: right">121.07</td>
    <td style="white-space: nowrap; text-align: right">8.26 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14.07%</td>
    <td style="white-space: nowrap; text-align: right">7.82 ms</td>
    <td style="white-space: nowrap; text-align: right">13.76 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">22.00</td>
    <td style="white-space: nowrap; text-align: right">45.45 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;19.87%</td>
    <td style="white-space: nowrap; text-align: right">45.58 ms</td>
    <td style="white-space: nowrap; text-align: right">59.34 ms</td>
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
    <td style="white-space: nowrap;text-align: right">121.07</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">22.00</td>
    <td style="white-space: nowrap; text-align: right">5.5x</td>
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
    <td style="white-space: nowrap">50.08 MB</td>
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
    <td style="white-space: nowrap; text-align: right">349.85</td>
    <td style="white-space: nowrap; text-align: right">2.86 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6.74%</td>
    <td style="white-space: nowrap; text-align: right">2.81 ms</td>
    <td style="white-space: nowrap; text-align: right">3.49 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">28.33</td>
    <td style="white-space: nowrap; text-align: right">35.30 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.73%</td>
    <td style="white-space: nowrap; text-align: right">35.12 ms</td>
    <td style="white-space: nowrap; text-align: right">45.67 ms</td>
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
    <td style="white-space: nowrap;text-align: right">349.85</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">Ymlr</td>
    <td style="white-space: nowrap; text-align: right">28.33</td>
    <td style="white-space: nowrap; text-align: right">12.35x</td>
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
    <td style="white-space: nowrap">47.48 MB</td>
    <td>18.67x</td>
  </tr>
</table>