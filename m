Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F194BC4321E
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 09:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbhLPJqL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:46:11 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:51014
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235655AbhLPJqJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Dec 2021 04:46:09 -0500
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 67C253FFDA
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 09:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639647968;
        bh=ifKlZYGTOPdFCSDCTOtZXvFjnN1ta3FdQcJv2C1mO4Q=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Qu1H6Lut0kiGGY2GXaCK8BOZNPmfiBZyJglUcsuokeNFlj4pcMRd7zCKApIXEBJXv
         3u42ybmRiP//1Ez2Ife48jCuX6S3Hh3B+rEPqCM67NGvOIbqLrix5GiV8uZ6ecwU3v
         Ty5xx4zbK9HplgIz74CfMCBLeEBh7Is8rZ0eH9d1AeKdVv+OZOzy4pcrqCVY6Gav/4
         Kh5KDZXxY+3bI9unEySdjuhLKzAx7QBlIH5BV7ZNRpDPuW+vgGra1z7OWDNBvmkqg2
         e/ibw3/xkXkbEssgfBzpjmoV7giOUCAjlZ4Kc8dRvQaVUMMZn43jNLWYgOsH03CfwM
         0q0aFov2SDCKA==
Received: by mail-lj1-f198.google.com with SMTP id b14-20020a05651c0b0e00b0021a1a39c481so8329767ljr.3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 01:46:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ifKlZYGTOPdFCSDCTOtZXvFjnN1ta3FdQcJv2C1mO4Q=;
        b=4FstuOPC9VW889eYCZNyCkdO3+qknCBtCPPMq7gTI4D9G9IcM8WMC1k3ZA8+Lvvdx3
         PgjjPzGoQk0O5q2xDx6GWcEpq8U2Phvemo4eQ5SKmxkGilUacXYYI394YqJXIryHfXbk
         ptgq1+m+0511m12V04Agp4zj6seHCzL2+jGYjAUzCKISixFx03Jve5Do8DoUrnF3NaSN
         6fDwMzQGkaVXr2l3YsmK4+gncz/WV8HyZngALmbYfskzgYbGH9WMtFZou8B8D31MwQQM
         IERP1GPCOooIQYqCbJ6eXQ061yMSPlrZFL3durF4c/vg5naAWnFaxP65m+i6GSDQrJOr
         4L2A==
X-Gm-Message-State: AOAM530F5XBSViDjPToK5/60uGpGSvlIac21OIF+a2S8aJhwB9IDdnwP
        IS7TppkNVj3eq64r++yXz8FqkbNl5wR7W1RqeG6KlIsVtdx00Qf6uiZA7XcJpg7kSY92FRgVzKe
        ST3dlS/AvxvHaVaYHPX3P070dFY9oAXj+SfUiGrQ=
X-Received: by 2002:a5d:59af:: with SMTP id p15mr8145361wrr.314.1639647955362;
        Thu, 16 Dec 2021 01:45:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzUGy/dKebedUXgoem/d6gyVVYcP7Z2hszf3HxXNiUwHW6hBLUxxafQ7sSJ/XEtEqxAbevgA==
X-Received: by 2002:a5d:59af:: with SMTP id p15mr8145334wrr.314.1639647955104;
        Thu, 16 Dec 2021 01:45:55 -0800 (PST)
Received: from alex.home (lfbn-gre-1-195-1.w90-112.abo.wanadoo.fr. [90.112.158.1])
        by smtp.gmail.com with ESMTPSA id t8sm4349398wrv.30.2021.12.16.01.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 01:45:54 -0800 (PST)
From:   Alexandre Ghiti <alexandre.ghiti@canonical.com>
To:     Steve French <sfrench@samba.org>, Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jeff Layton <jlayton@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-power@fi.rohmeurope.com
Cc:     Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH v2 1/6] Documentation, arch: Remove leftovers from fscache/cachefiles histograms
Date:   Thu, 16 Dec 2021 10:44:21 +0100
Message-Id: <20211216094426.2083802-2-alexandre.ghiti@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211216094426.2083802-1-alexandre.ghiti@canonical.com>
References: <20211216094426.2083802-1-alexandre.ghiti@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

A few references to the fscache and cachefiles histograms were left in
the Documentation and some arch defconfigs: remove them since those
configs do not exist anymore.

Fixes: 6ae9bd8bb037("fscache, cachefiles: Remove the histogram stuff")
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Acked-by: Arnd Bergmann <arnd@arndb.de> [arch/arm/configs]
---
 .../filesystems/caching/cachefiles.rst        | 34 -------------------
 Documentation/filesystems/caching/fscache.rst | 34 ++-----------------
 arch/arm/configs/axm55xx_defconfig            |  2 --
 3 files changed, 2 insertions(+), 68 deletions(-)

diff --git a/Documentation/filesystems/caching/cachefiles.rst b/Documentation/filesystems/caching/cachefiles.rst
index e58bc1fd312a..e59861458029 100644
--- a/Documentation/filesystems/caching/cachefiles.rst
+++ b/Documentation/filesystems/caching/cachefiles.rst
@@ -424,40 +424,6 @@ for CacheFiles to run in a context of a specific security label, or to create
 files and directories with another security label.
 
 
-Statistical Information
-=======================
-
-If FS-Cache is compiled with the following option enabled::
-
-	CONFIG_CACHEFILES_HISTOGRAM=y
-
-then it will gather certain statistics and display them through a proc file.
-
- /proc/fs/cachefiles/histogram
-
-     ::
-
-	cat /proc/fs/cachefiles/histogram
-	JIFS  SECS  LOOKUPS   MKDIRS    CREATES
-	===== ===== ========= ========= =========
-
-     This shows the breakdown of the number of times each amount of time
-     between 0 jiffies and HZ-1 jiffies a variety of tasks took to run.  The
-     columns are as follows:
-
-	=======		=======================================================
-	COLUMN		TIME MEASUREMENT
-	=======		=======================================================
-	LOOKUPS		Length of time to perform a lookup on the backing fs
-	MKDIRS		Length of time to perform a mkdir on the backing fs
-	CREATES		Length of time to perform a create on the backing fs
-	=======		=======================================================
-
-     Each row shows the number of events that took a particular range of times.
-     Each step is 1 jiffy in size.  The JIFS column indicates the particular
-     jiffy range covered, and the SECS field the equivalent number of seconds.
-
-
 Debugging
 =========
 
diff --git a/Documentation/filesystems/caching/fscache.rst b/Documentation/filesystems/caching/fscache.rst
index 70de86922b6a..66e31a6d1070 100644
--- a/Documentation/filesystems/caching/fscache.rst
+++ b/Documentation/filesystems/caching/fscache.rst
@@ -201,10 +201,9 @@ Statistical Information
 If FS-Cache is compiled with the following options enabled::
 
 	CONFIG_FSCACHE_STATS=y
-	CONFIG_FSCACHE_HISTOGRAM=y
 
-then it will gather certain statistics and display them through a number of
-proc files.
+then it will gather certain statistics and display them through the following
+proc file.
 
 /proc/fs/fscache/stats
 ----------------------
@@ -413,35 +412,6 @@ proc files.
 
 
 
-/proc/fs/fscache/histogram
---------------------------
-
-     ::
-
-	cat /proc/fs/fscache/histogram
-	JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS  RETRV DLY RETRIEVLS
-	===== ===== ========= ========= ========= ========= =========
-
-     This shows the breakdown of the number of times each amount of time
-     between 0 jiffies and HZ-1 jiffies a variety of tasks took to run.  The
-     columns are as follows:
-
-	=========	=======================================================
-	COLUMN		TIME MEASUREMENT
-	=========	=======================================================
-	OBJ INST	Length of time to instantiate an object
-	OP RUNS		Length of time a call to process an operation took
-	OBJ RUNS	Length of time a call to process an object event took
-	RETRV DLY	Time between an requesting a read and lookup completing
-	RETRIEVLS	Time between beginning and end of a retrieval
-	=========	=======================================================
-
-     Each row shows the number of events that took a particular range of times.
-     Each step is 1 jiffy in size.  The JIFS column indicates the particular
-     jiffy range covered, and the SECS field the equivalent number of seconds.
-
-
-
 Object List
 ===========
 
diff --git a/arch/arm/configs/axm55xx_defconfig b/arch/arm/configs/axm55xx_defconfig
index 46075216ee6d..b36e0b347d1f 100644
--- a/arch/arm/configs/axm55xx_defconfig
+++ b/arch/arm/configs/axm55xx_defconfig
@@ -204,11 +204,9 @@ CONFIG_FUSE_FS=y
 CONFIG_CUSE=y
 CONFIG_FSCACHE=y
 CONFIG_FSCACHE_STATS=y
-CONFIG_FSCACHE_HISTOGRAM=y
 CONFIG_FSCACHE_DEBUG=y
 CONFIG_FSCACHE_OBJECT_LIST=y
 CONFIG_CACHEFILES=y
-CONFIG_CACHEFILES_HISTOGRAM=y
 CONFIG_ISO9660_FS=y
 CONFIG_UDF_FS=y
 CONFIG_MSDOS_FS=y
-- 
2.32.0

