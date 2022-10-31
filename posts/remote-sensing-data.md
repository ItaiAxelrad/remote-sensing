---
title: Remote Sensing Data
---

Various websites host remote sensing data. The main difference between these resources are the type of data. Some websites provide you with raw imagery and others have done considerable amount of reprocessing to provide you with products.

Likewise, these websites provide you with various methods to search for data. For instance, <https://glovis.usgs.gov> provide you with raw Landsat imagery, while <https://espa.cr.usgs.gov> provide processed Landsat data. There is also <https://earthexplorer.usgs.gov/> which is the most comprehensive remote sensing data depository that provides both Landsat and MODIS satellite imagery in various formats. We will use some of these websites to download and explore that data in this lab.

## Data Download

Selecting scenes:

1. Go to <https://earthexplorer.usgs.gov/>.
2. On the left panel, you would see 4 different tabs. You would use each to filter and narrow down your selection criteria.

![Earth Explorer Data Search](/images/remote7.png)

![Earth Explorer Data Search](/images/remote9.png)

3. Click on “Path/Row” tab in the middle of the page. For path enter 33, and for row enter 32. Click “Show”.
4. On the bottom of the current tab, select a date range: April 1st 2011 to May 30th\-2011.
5. On the top, click on the “Data Sets” tab. Click the + sign on next to “Landsat Archive > Collection 1 Level-1 > L4-5 TM C1 Level-1”. Check the box next to L4-5 TM C1 Level-1. Hit the OK if warning appears.
6. Processed to the “Results” tab to see your search results. You should see a result page such as below:

![search results](/images/remote8.png)

7. Copy past the “Entity ID” of the first two search entries in to an empty text file. Save the text file and call it “33032.txt” (path-row name; this is arbitrary).

Each Entity ID should be in one line. Just copy/paste the text in front of Entity ID and not the “Entity ID” itself.

## Download the Data

This is a great resource for processed that. Many products are available for you to download. You can also use this website as a great resources for your projects and data needs.

1. Go to <https://espa.cr.usgs.gov>
2. Set up a new account. This is not a normal USGS account. Regardless of having a previous account with USGS, you need to setup a new account with ESPA
3. On the top ribbon, click on the “New Order” tab.
4. Click “Choose File” and select the “33032.txt” (You are asking the search engine at this website to find the processed version of the scenes that you have selected).
5. Scroll down, under Other Landsat Level-2 Products choose “CFMask” for cloud masking and “Spectral Indices > NDVI” for vegetation greenness index.

Other indices are also available for download after the order complete. However, the order size and processing time increases as the # of products increases.

![Product selection Panel](/images/remote4.png)

7. Leave the rest of options with their default settings.
   - You can order simple stats if you are interested. However, they are averaged over the entire scene and might not be very informative.
   - It is recommended to leave a unique note under “Order Description” in case several scenes are being processed (e.g. Colorado-2011).

8. Proceed to submit the order by clicking on the “Submit” button.
   - You will receive a first email notifying you that the order is being processed. You will receive a second email notifying you that you order is ready for download.
   - Proceed to download the User Guide. The link can be found on the top ribbon under “User Guide” tab. This PDF contains the information about each product and their meanings and characteristics.

![Top ribbon links](/images/remote3.png)

You can also check the status of your order by clicking on the “Show Order” tab.

When order is ready, go to “Show Order” page and proceed to download the tar files. Into the Sampledata folder.

![Download Page](/images/remote6.png)

The tar files can be view by free compressors such as WINRAR or 7Zip. However, this is required in order to processes the files in this tutorial.

There are other methods to search for the data on the EarthExplorer website. You can select data by drawing polygons or specifying exact location of your area of interest (AOI) using the Lat/Lon tab.
