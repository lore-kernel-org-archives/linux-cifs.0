Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852A0C433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 15:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E8EA6008E
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 15:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhKEPuh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Nov 2021 11:50:37 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:55610
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233632AbhKEPug (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Nov 2021 11:50:36 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 43D123FE09
        for <linux-cifs@vger.kernel.org>; Fri,  5 Nov 2021 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636127276;
        bh=BQNpoEejJgdqfTjT6uEW5F1j+u2r6UT1ueKsgaIRjOY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=PDe44V+uldWUwDxj5FKSTYeboPrVN/w3qkZn49FetUhcf1ox73ih/FqUWEbiSQvBT
         rw6hr/nMKxslz4q2gy1wHYtPReeJhy4NASox9jO0Ybrgae7qoAcpr3WMnNEmB021eg
         M+Qd1Fz8XFyK6duP68DeuOuN0ChuahCM3RZ0PWeFfw4abvuaaKeagC0Xj0UJGFKQjK
         Y1nssZxzMUGdBUyOVWK1iE5jhuf7Ahxi4bFSsBI7JeYhIFjynsQguZBY6fc0VFH0po
         g4rqYZ/wwqdALNk9sQf1y64uol7eBv6BTS2Yd5gfl37l+jAuBMDUULVKbh/YKl0/jX
         CGOBVle3q7uJw==
Received: by mail-wr1-f71.google.com with SMTP id h13-20020adfa4cd000000b001883fd029e8so1819178wrb.11
        for <linux-cifs@vger.kernel.org>; Fri, 05 Nov 2021 08:47:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BQNpoEejJgdqfTjT6uEW5F1j+u2r6UT1ueKsgaIRjOY=;
        b=l2Cm272+4M71XqDvpDaGOGR7MrmBhFYCwijT7Wd4UvMXfKK1S/Ar1UK3zjIFM3NLI/
         YDJT6A96YowayFU+KGmgABywF1QvXdMfkLe0ThGO7j8hbgTyYXP8EgdvQHa5mgcu3vvi
         V4O7u6AJUozh/9Got0twgtYnU365wzr5zuKHlit2AGgcRbg/Senvon4phAUSyp8A2Fy+
         Y0txHkTVOdLESywAIO+5HOlF06EnVX/P+EYIxJUyVhxxxW5ppfepCH5vcNGBJuyfdfun
         9BWP27SJ2fm8rTotjnJfepqrEj83TThApjahVMtiSzcWE8YvkYz3LJSvG58RArm5gwhG
         rRDg==
X-Gm-Message-State: AOAM5331CMOR+V7UqrRNcd+0uFPVWREZXDavBJGNHXsoksveRVsMoEcw
        9Z1H9arecsRQNs02DElIg6m/OcjBcbr7dfxm2lYj2TG1ds9YVm4JraH2kzlhq0sjZ84RglxHNtV
        O4GZN/q+YX8f9dyMsGyOAOT3BrWimeIRzMyPL4HY=
X-Received: by 2002:a05:600c:430c:: with SMTP id p12mr32522642wme.127.1636127265135;
        Fri, 05 Nov 2021 08:47:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqsDazjeBLc3GzOdhywA22fmz71ZuD2zXBh7/jcJh3Kp1/GITAo9FHVASySm/M442PUPtjWg==
X-Received: by 2002:a05:600c:430c:: with SMTP id p12mr32522621wme.127.1636127264973;
        Fri, 05 Nov 2021 08:47:44 -0700 (PDT)
Received: from localhost.localdomain (lfbn-lyo-1-470-249.w2-7.abo.wanadoo.fr. [2.7.60.249])
        by smtp.gmail.com with ESMTPSA id o8sm8452479wrm.67.2021.11.05.08.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:47:44 -0700 (PDT)
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
Subject: [PATCH 4/7] arch: Remove leftovers from mandatory file locking
Date:   Fri,  5 Nov 2021 16:43:31 +0100
Message-Id: <20211105154334.1841927-5-alexandre.ghiti@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211105154334.1841927-1-alexandre.ghiti@canonical.com>
References: <20211105154334.1841927-1-alexandre.ghiti@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This config was removed so remove all references to it.

Fixes: f7e33bdbd6d1 ("fs: remove mandatory file locking support")
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
---
 arch/mips/configs/decstation_64_defconfig  | 1 -
 arch/mips/configs/decstation_defconfig     | 1 -
 arch/mips/configs/decstation_r4k_defconfig | 1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index 85f1955b4b00..e2ed105f8c97 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -144,7 +144,6 @@ CONFIG_EXT2_FS_SECURITY=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
-# CONFIG_MANDATORY_FILE_LOCKING is not set
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_PROC_KCORE=y
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index 30a6eafdb1d0..7e987d6f5e34 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -140,7 +140,6 @@ CONFIG_EXT2_FS_SECURITY=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
-# CONFIG_MANDATORY_FILE_LOCKING is not set
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_PROC_KCORE=y
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index e2b58dbf4aa9..6df5f6f2ac8e 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -140,7 +140,6 @@ CONFIG_EXT2_FS_SECURITY=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
-# CONFIG_MANDATORY_FILE_LOCKING is not set
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_PROC_KCORE=y
-- 
2.32.0

