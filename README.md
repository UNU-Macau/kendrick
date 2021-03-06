<p align="center">
<h1 align="center">Kendrick</h1>
  <p align="center">
    DSL and Simulation Plarform for Epidemiology Modeling
    <br>
    <a href="https://github.com/UNU-Macau/kendrick/wiki"><strong>Explore the docs »</strong></a>
    <br>
    <br>
    <a href="https://github.com/UNU-Macau/kendrick/issues/new?labels=Type%3A+Defect">Report a defect</a>
    |
    <a href="https://github.com/UNU-Macau/kendrick/issues/new?labels=Type%3A+Feature">Request feature</a>
  </p>
</p>


[![Pharo version](https://img.shields.io/badge/Pharo-8.0-%23aac9ff.svg)](https://pharo.org/download)
![CI](https://github.com/UNU-Macau/kendrick/workflows/CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/UNU-Macau/kendrick/badge.svg?branch=master)](https://coveralls.io/github/UNU-Macau/kendrick?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/UNU-Macau/kendrick/master/LICENSE)

Kendrick provides an embedded Domain-Specific Language and a Simulation Plaform for mathematical epidemiology modeling. It helps epidemiologists craft custom analyses cheaply. It's based on [Pharo](http://www.pharo.org/) and it's open source under MIT licence. Classes of epidemic model include deterministic compartmental models, stochastic individual contact models, and individual-based network models.

Kendrick is based extensively on several Pharo ecosystem tools including [PetitParser](http://www.moosetechnology.org/tools/petitparser) and [Roassal](http://agilevisualization.com/) visualization engine.

[![Screenshot](images/screenshot.png)](https://raw.githubusercontent.com/UNU-Macau/kendrick/master/images/screenshot.png)

## Citation

If you are using Kendrick for research, please cite our work as:

> Mai Anh BUI T., Nick Papoulias, Serge Stinckwich, Mikal Ziane & Benjamin Roche (2019), *The Kendrick modelling platform: language abstractions and tools for epidemiology*, BMC Bioinformatics volume 20, Article number: 312 URL:
https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-019-2843-0

## Documentation
You will find documentation about Kendrick DSL in the wiki : https://github.com/UNU-Macau/kendrick/wiki

Kendrick is also described in a chapter of the [Agile Visualization book](http://agilevisualization.com/).

## How to install the development version of Kendrick from github

* Download Pharo 9.0 VM depending of your platform: http://pharo.org/download
* Load Kendrick: Open Pharo 9.0 image then right-click anywhere to open the main menu. Choose Playground to execute script. Paste the script below in Playground, select all then right-click and choose Do it to execute this.
* You need first to update the Iceberg version in your image. See CONTRIBUTING.md for more details.

```Smalltalk
Metacello new
        repository: 'github://UNU-Macau/kendrick';
        baseline: 'Kendrick';
        onWarningLog ;
        load
```

If you have errors due low bandwidth or github access, use the following script instead:
```Smalltalk
| count |
count := 1.
Transcript open.
[ true ] whileTrue: [ [
		^ Metacello new
        repository: 'github://UNU-Macau/kendrick';
        baseline: 'Kendrick';
		  onConflictUseLoaded;
        onWarningLog ;
        load.
	]
	on: IceGenericError "Failed to connect to github.com: Interrupted system call"
	do: [ : ex |
		Notification signal:
	        	String cr ,
			ex description,
			String cr ,
			'RETRYING ',
			count asString.
		(Delay forSeconds: 2) wait.
		ex retry
	].
	count := count + 1 ]
```

## How to invoke Kendrick from the command-line

### DSL Editor
After compiling from source or downloading the pre-compiled versions of Kendrick, you can run the 
dedicated Kendrick editor (using the Kendrick DSL), by invoking:
```shell
./KendrickUI
```

### Development Environmement

To run Kendrick with the full Pharo environment (allowing to use both the DSL and the Pharo API of Kendrick),
you can invoke:
```shell
./KendrickDevUI
```

### Using External Tools

Finally, to use Kendrick with an editor of your choice, you only need to navigate in the Sources directory
of your installation, edit / add files for your project and invoke the non-interactive kendric executable 
as follows (example for simulating and visualizing the results described in Influenza1Viz.kendrick):
```shell
./Kendrick Sources/Projects/Infuenza/Visualization/Influenza1Viz.kendrick
```

In the above example you can then find the results in: 
```shell
Sources/Projects/Infuenza/Output/Influenza1Viz.png
```
