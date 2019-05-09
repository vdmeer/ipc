<?xml version="1.0" encoding="UTF-8"?>
<!--
 ============LICENSE_START=======================================================
  Copyright (C) 2018 Sven van der Meer. All rights reserved.
 ================================================================================
 This file is licensed under the CREATIVE COMMONS ATTRIBUTION 4.0 INTERNATIONAL LICENSE
 Full license text at https://creativecommons.org/licenses/by/4.0/legalcode
 
 SPDX-License-Identifier: CC-BY-4.0
 ============LICENSE_END=========================================================

 @author Sven van der Meer (vdmeer.sven@mykolab.com)

-->

<document>
    <properties>
        <title>%LCN_PAGE_TITLE%</title>
        <author email="vdmeer dot sven at mykolab dot com">Sven van der Meer</author>
    </properties>

    <body>
        <section name="%LCN_PAGE_TITLE%">

            <subsection name="As Reference">
<source>
  Sven van der Meer: "%LCN_TITLE%", version %LCN_VERSION%, %LCN_Month% %LCN_DAY%, %LCN_YEAR%, available: %LCN_URL%
</source>
            </subsection>


            <subsection name="Biblatex">
<source>
  @online{vdmeer:ipc:lcn,
      author = {van der Meer, Sven},
      title  = {%LCN_TITLE%},
      url = "%LCN_URL%",
      date = {%LCN_DATE%}, version = "%LCN_VERSION%",
      urldate = {%LCN_DATE%}
  }
</source>
            </subsection>


            <subsection name="BibTeX">
<source>
  @misc{vdmeer:ipc:lcn,
      author = {van der Meer, Sven},
      title  = {%LCN_TITLE%},
      howpublished = "online",
      url = "%LCN_URL%",
      year = %LCN_YEAR%, month = %LCN_month%, day = %LCN_DAY%,
      note = "version %LCN_VERSION%", key = "vdm"
  }
</source>
            </subsection>


            <subsection name="Older Versions">
                <p>
                    For older versions substitute the date and version with the following:
                    <ul>
                        <li>version 0.7.2: 2019, May, 8</li>
                    </ul>
                </p>
            </subsection>

        </section>
    </body>
</document>
