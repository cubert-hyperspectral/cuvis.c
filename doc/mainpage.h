/** \mainpage CUVIS C SDK
The documentation of all functions can be found \ref cuvis.h "here".

 - - -

 # Getting started

 The cuvis SDK can be used directly as C SDK or via the included wrappers (e.g. cpp, Matlab, Python...)

 ## Initialization

 The first SDK command should be setting the log level (default: info, \ref cuvis_set_log_level). The Programm will start logging into the console. The Debug log is also written to file, for additional informaiton see \ref log.
  
 Then initialize the system by setting the location of the settings-directory (default: "C:/Program Files/cuvis/user/settings" for windows or "/etc/cuvis/user/settings" for linux, \ref cuvis_init). \n
 From this the required performance settings for the local system are loaded. This step is crucial for recording images. When only processing data offline, this step can be skipped.


 ## Handles

 The SDK is handle-based, i.e to access an internal data object you will require a handle.

 A measurement handle (\ref CUVIS_MESU) can be obtained either by loading (\ref cuvis_measurement_load) or
 by recording (\ref cuvis_acq_cont_capture or \ref cuvis_acq_cont_get_next_measurement) a measurement. \n
 A measurement is equivalent to a data-cube and would be called a frame in a traditional Camera-Setup.

 To record a measurement an acquisition context handle (\ref CUVIS_ACQ_CONT) is needed, for processing a measurement
 a processing context handle is needed (\ref CUVIS_PROC_CONT). Both can be obtained from the via the calibration handle (\ref CUVIS_CALIB). \n
 To save a measurement to disk an exporter handle is needed (\ref CUVIS_EXPORTER).

 Alternatively, the processing context handle can be loaded from an already processed measurement (from disk), however
 special conditions need to be met (!sic).

 ## Examples

 When the SDK, several \ref examples are installed.
 Assuming the hardware is set up, perform the following steps to record single measurements in software trigger mode (\ref cuvis_operation_mode_t).\n
 This is equivalent to the Example 05_recordSingleImages.

 1. load calibration (\ref cuvis_calib_create_from_path)
 2. load acquisition context (\ref cuvis_acq_cont_create_from_calib)
 3. set operation mode to Software (\ref cuvis_acq_cont_operation_mode_set)
 4. set camera parameters (e.g. integration time)
 5. set up processing context (\ref cuvis_proc_cont_create_from_calib)
 6. prepare processing context arguments: \ref CUVIS_PROC_ARGS
 7. set up cube exporter (\ref cuvis_exporter_create_cube)
 8. in a loop run:
    1. capture a measurement (\ref cuvis_acq_cont_capture)
    2. process measurement (\ref cuvis_proc_cont_apply)
    3. read image data (\ref cuvis_measurement_get_data_image)
    4. save measurement (\ref cuvis_exporter_apply)
    5. free measurement (\ref cuvis_measurement_free)
 9. free exporter (\ref cuvis_exporter_free), acquisition context (\ref cuvis_acq_cont_free),
 processing context (\ref cuvis_proc_cont_free) and calibration (\ref cuvis_calib_free).
 */