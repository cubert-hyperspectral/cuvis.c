![image](https://raw.githubusercontent.com/cubert-hyperspectral/cuvis.sdk/main/branding/logo/banner.png)

# cuvis.c

cuvis.c is the cuvis.hub landing page for the Cuvis SDK written in C ([available here](https://github.com/cubert-hyperspectral/cuvis.sdk)).

- **Website:** https://www.cubert-hyperspectral.com/
- **Source code:** https://github.com/cubert-hyperspectral/
- **Support:** http://support.cubert-hyperspectral.com/

This SDK enables operating Cubert GmbH Hyperspectral Cameras, as well as, 
analyzing data directly from the corporate data format(s).

For other supported program languages, please have a look at the 
source code page.

## Installation

### Prerequisites

You need to install the Cuvis C SDK from [here](https://cloud.cubert-gmbh.de/index.php/s/m1WfR66TjcGl96z).

### Importing Cuvis C SDK via CMake 

First, you need to add the directory containing *FindCuvis.cmake* to *CMAKE_MODULE_PATH*. Assuming you added the *cuvis.c* repository as submodule as "${CMAKE_SOURCE_DIR}/cuvis.c" you can add it like so:
```
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cuvis.c")
```

Then you need to run the *find_package* function:
```
find_package(Cuvis REQUIRED 3.2.0)
```

If cuvis is installed to default locations, they are found automatically. Else, locate the cuvis.lib and the directory containing cuvis.h.

Finally, link against *cuvis::c*. In the following example, the target *main* is linked against cuvis:
```
add_executable(main main.c)
target_link_libraries(main PRIVATE cuvis::c)
```


## How to ...

### Getting started

We provide an additional example repository [here](https://github.com/cubert-hyperspectral/cuvis.c.examples),
covering some basic applications.

Further, we provide a set of example measurements to explore [here](https://cloud.cubert-gmbh.de/index.php/s/3oECVGWpC1NpNqC).
These measurements are also used by the examples mentioned above.

### Getting involved

cuvis.hub welcomes your enthusiasm and expertise!

With providing our SDK wrappers on GitHub, we aim for a community-driven open 
source application development by a diverse group of contributors.
Cubert GmbH aims for creating an open, inclusive, and positive community.
Feel free to branch/fork this repository for later merge requests, open 
issues or point us to your application specific projects.
Contact us, if you want your open source project to be included and shared 
on this hub; either if you search for direct support, collaborators or any 
other input or simply want your project being used by this community.
We ourselves try to expand the code base with further more specific 
applications using our wrappers to provide starting points for research 
projects, embedders or other users.

### Getting help

Directly code related issues can be posted here on the GitHub page, other, more 
general and application related issues should be directed to the 
aforementioned Cubert GmbH [support page](http://support.cubert-hyperspectral.com/).
