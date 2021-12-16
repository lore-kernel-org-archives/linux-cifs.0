Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AFAC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 09:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbhLPJrW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:47:22 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:51066
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236090AbhLPJq7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Dec 2021 04:46:59 -0500
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8C01C3FFD8
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 09:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639648017;
        bh=vikRa1nxzcY4uLugL2Q09RF+hmHrdpmpkJ7AXRwjM28=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=nF2cORUTKJACdz8C6aVCKuDjvoXmFw9DBhYNaI1yRD+MedexsI/TLDFa500zY/ovb
         HS3LU4XanYooO3n9xX+NCgHZZG9aIe9m+rrcMdaozzR2FJ94A3pAjx8cV1qvJUpaXz
         Du7g/8+CPtx2SXjpkHQJVnPW9jhWveANFJSnZ4ud4JP8K2LbUjEC3zWqs79DaC6KbV
         PhTrt2PXV5+pDuda15o3VCQ421+49DQtctVso+Q3CApgA1BP/M6Y+xpvc9enI1aRyv
         iU16/YGtV8xCuO/WHLPsy90Uki3BarTMIc62POzmW6xNMAObrCmORACyMjmk4FTco7
         vWrRug9mEOAYw==
Received: by mail-wm1-f72.google.com with SMTP id k25-20020a05600c1c9900b00332f798ba1dso1025370wms.4
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 01:46:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vikRa1nxzcY4uLugL2Q09RF+hmHrdpmpkJ7AXRwjM28=;
        b=skZbs0h7/Gsi6A9+q8QEkWHpFEg1u4VH3B8/nPos2MRFSTqmeNrCWKTx7VLZ9mSxbs
         nwRzS6iXXD+ArhcN5uMM3Gfwtnbg9c03lrglpGkIMPs72mteA1CB0/qJo2XQomFPVzFd
         3f0e0rHmW2/dVdYZDvjOEnVxJCLiU+P9n3FbHJR+oD47h1aECAnX9Qn//g0JfW6hg2mm
         S4htheFUo4zr0f8ns7zd+4qvg2UEXUiSqm7OVAQh3L+cOzIEImTFbxVV1QiyXXIKmj/Z
         wnGnn/ueM6ntgGD2Pnwf/dI11Bu9gSpr3oolQbALy+sSLb2V7YdOn0JIJ79MZSRvy0VD
         L6oQ==
X-Gm-Message-State: AOAM5305rgBuh/L9aUwDcbX2S/PGHiUkyjm25dloNuNq5MNnixdw5cVD
        1L+u32gSZNmkTC8N+JmE290pHR7G2y57cZ+pr4lTjENEp/72qtBkEyJd9tLSp0T24cceGPLqvtH
        wsUiQZKoInWtgP/e99BUxCwk0A0XOfDWPknX0Iro=
X-Received: by 2002:a5d:5850:: with SMTP id i16mr8192903wrf.410.1639648016598;
        Thu, 16 Dec 2021 01:46:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwA4Cb/78g/Np23rRrFeNNA+mcm6HyKEgF1u2KfoVSUn+c47106OcZ0yzWX4XGZuoK1ZlxQZQ==
X-Received: by 2002:a5d:5850:: with SMTP id i16mr8192881wrf.410.1639648016431;
        Thu, 16 Dec 2021 01:46:56 -0800 (PST)
Received: from alex.home (lfbn-gre-1-195-1.w90-112.abo.wanadoo.fr. [90.112.158.1])
        by smtp.gmail.com with ESMTPSA id d15sm5660966wri.50.2021.12.16.01.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 01:46:56 -0800 (PST)
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
Subject: [PATCH v2 2/6] Documentation, arch: Remove leftovers from raw device
Date:   Thu, 16 Dec 2021 10:44:22 +0100
Message-Id: <20211216094426.2083802-3-alexandre.ghiti@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211216094426.2083802-1-alexandre.ghiti@canonical.com>
References: <20211216094426.2083802-1-alexandre.ghiti@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Raw device interface was removed so remove all references to configs
related to it.

Fixes: 603e4922f1c8 ("remove the raw driver")
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Acked-by: Arnd Bergmann <arnd@arndb.de> [arch/arm/configs]
---
 Documentation/admin-guide/devices.txt  | 8 +-------
 arch/arm/configs/spear13xx_defconfig   | 1 -
 arch/arm/configs/spear3xx_defconfig    | 1 -
 arch/arm/configs/spear6xx_defconfig    | 1 -
 arch/powerpc/configs/pseries_defconfig | 1 -
 5 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
index 922c23bb4372..c07dc0ee860e 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -2339,13 +2339,7 @@
 		disks (see major number 3) except that the limit on
 		partitions is 31.
 
- 162 char	Raw block device interface
-		  0 = /dev/rawctl	Raw I/O control device
-		  1 = /dev/raw/raw1	First raw I/O device
-		  2 = /dev/raw/raw2	Second raw I/O device
-		    ...
-		 max minor number of raw device is set by kernel config
-		 MAX_RAW_DEVS or raw module parameter 'max_raw_devs'
+ 162 char	Used for (now removed) raw block device interface
 
  163 char
 
diff --git a/arch/arm/configs/spear13xx_defconfig b/arch/arm/configs/spear13xx_defconfig
index 3b206a31902f..065553326b39 100644
--- a/arch/arm/configs/spear13xx_defconfig
+++ b/arch/arm/configs/spear13xx_defconfig
@@ -61,7 +61,6 @@ CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=8192
 CONFIG_I2C=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_SPI=y
diff --git a/arch/arm/configs/spear3xx_defconfig b/arch/arm/configs/spear3xx_defconfig
index fc5f71c765ed..afca722d6605 100644
--- a/arch/arm/configs/spear3xx_defconfig
+++ b/arch/arm/configs/spear3xx_defconfig
@@ -41,7 +41,6 @@ CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=8192
 CONFIG_I2C=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_SPI=y
diff --git a/arch/arm/configs/spear6xx_defconfig b/arch/arm/configs/spear6xx_defconfig
index 52a56b8ce6a7..bc32c02cb86b 100644
--- a/arch/arm/configs/spear6xx_defconfig
+++ b/arch/arm/configs/spear6xx_defconfig
@@ -36,7 +36,6 @@ CONFIG_INPUT_FF_MEMLESS=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=8192
 CONFIG_I2C=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_SPI=y
diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index de7641adb899..e64f2242abe1 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -189,7 +189,6 @@ CONFIG_HVCS=m
 CONFIG_VIRTIO_CONSOLE=m
 CONFIG_IBM_BSR=m
 CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=1024
 CONFIG_I2C_CHARDEV=y
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
-- 
2.32.0

