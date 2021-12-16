Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70284C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 09:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhLPJo4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:44:56 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:50850
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235530AbhLPJo4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Dec 2021 04:44:56 -0500
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AA07A40703
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 09:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639647894;
        bh=QTOsClZwyZOKWiOCdpIZ53KKqBtgpNixsjVEw+qtuPg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=jofQGy9bxDhJovnAmriRtPsAeBWkfMI11f5mRC7BakbypG5tYhyMznhrHR3LE5pqc
         LvcB1mZr6JrhyMrjF31cK7PhZWHEXWMbOFjsCtZwGdH89bt5EfS33X0obUPPRN3AIE
         pJ2QOilO4hotMLCVmNFbfHB3iXM8em0zqvCZaRTnaC/dA0A1Sv3cbybcW4mtJqZ+Xt
         U973jDeYd8sPU2R3tOZSdQ7+jCxvEIa3ZdZvw2efPM3f1agyrJUVFxxYffDx/af8vc
         zry+5WwIhzQesrVT4F3rBWAfov/4HkmLNjCWhMvvfldl1/1FE3IzhSl9JxDMrrA6De
         keYn/E0DF8j4Q==
Received: by mail-wm1-f70.google.com with SMTP id b75-20020a1c804e000000b0034569bde713so1012685wmd.9
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 01:44:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTOsClZwyZOKWiOCdpIZ53KKqBtgpNixsjVEw+qtuPg=;
        b=hX0X/taVMNA8AVeEGTNoYGPZopr3HCmNZxPhQxC/8klGEZAeAqJ9mADH7lDDFvD9i0
         LhoF1LN7I+rKAsBXcyzwDJtooTMtBZpyCHetQY0xOVhR8aOhCmuYuqTtG8tgdQnR+J+J
         cI2tNypO9L4ymPOqBJhufGBJDMbN/pYrKCcyieTLEqoLJmPCkG6HMKm85ZdzjvP9zTzu
         +0QfFUw9xA2KtaGCyz/sNK2xfz8zdMCww5zGDvY0HuPWkDMd5qPnAC38r64FSgF8h1px
         +HlaBnnA4oPSUHwjSxU58YHwR56+bYq29rkO67L1Adl6+/bzahhMmV2abj0+BsonOTmJ
         TGuQ==
X-Gm-Message-State: AOAM531MNd2DcEBdxQQW22y+LeLUC8rQRqAjMQl/H7qs8D+canXL28v6
        xiN0IZYOheXVPm1PMj8V6JPvAtVwuIwMd8jSFgQSkSqqdIBUN5yuityqGb8p55kXK5x657+FnvL
        J5P9Vyl/NqzLKOLnbL94PIF6qfeBKNf4mUERgDKg=
X-Received: by 2002:a5d:650f:: with SMTP id x15mr646226wru.57.1639647893946;
        Thu, 16 Dec 2021 01:44:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZMiPMQ+W+qW8IbAibX8DdTl4xnrovvGfEQoGvcsc6W8MrweFtPS/7ET8ki9T9yPPhmGQd1g==
X-Received: by 2002:a5d:650f:: with SMTP id x15mr646199wru.57.1639647893659;
        Thu, 16 Dec 2021 01:44:53 -0800 (PST)
Received: from alex.home (lfbn-gre-1-195-1.w90-112.abo.wanadoo.fr. [90.112.158.1])
        by smtp.gmail.com with ESMTPSA id h4sm4313251wrf.93.2021.12.16.01.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 01:44:53 -0800 (PST)
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
Subject: [PATCH v2 0/6] Cleanup after removal of configs
Date:   Thu, 16 Dec 2021 10:44:20 +0100
Message-Id: <20211216094426.2083802-1-alexandre.ghiti@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

While bumping from 5.13 to 5.15, I found that a few deleted configs had
left some pieces here and there: this patchset cleans that.

Changes in v2:
- Rebase on top of v5.16-rc1
- Removed patch 6 since Matti said he would take care of that
- Added AB, RB

Alexandre Ghiti (6):
  Documentation, arch: Remove leftovers from fscache/cachefiles
    histograms
  Documentation, arch: Remove leftovers from raw device
  Documentation, arch: Remove leftovers from CIFS_WEAK_PW_HASH
  arch: Remove leftovers from mandatory file locking
  Documentation, arch, fs: Remove leftovers from fscache object list
  arch: Remove leftovers from prism54 wireless driver

 Documentation/admin-guide/cifs/usage.rst      |   7 +-
 Documentation/admin-guide/devices.txt         |   8 +-
 .../filesystems/caching/cachefiles.rst        |  34 -----
 Documentation/filesystems/caching/fscache.rst | 123 +-----------------
 arch/arm/configs/axm55xx_defconfig            |   3 -
 arch/arm/configs/cm_x300_defconfig            |   1 -
 arch/arm/configs/ezx_defconfig                |   1 -
 arch/arm/configs/imote2_defconfig             |   1 -
 arch/arm/configs/nhk8815_defconfig            |   1 -
 arch/arm/configs/pxa_defconfig                |   1 -
 arch/arm/configs/spear13xx_defconfig          |   1 -
 arch/arm/configs/spear3xx_defconfig           |   1 -
 arch/arm/configs/spear6xx_defconfig           |   1 -
 arch/mips/configs/decstation_64_defconfig     |   1 -
 arch/mips/configs/decstation_defconfig        |   1 -
 arch/mips/configs/decstation_r4k_defconfig    |   1 -
 arch/mips/configs/fuloong2e_defconfig         |   1 -
 arch/mips/configs/ip27_defconfig              |   1 -
 arch/mips/configs/malta_defconfig             |   1 -
 arch/mips/configs/malta_kvm_defconfig         |   1 -
 arch/mips/configs/malta_qemu_32r6_defconfig   |   1 -
 arch/mips/configs/maltaaprp_defconfig         |   1 -
 arch/mips/configs/maltasmvp_defconfig         |   1 -
 arch/mips/configs/maltasmvp_eva_defconfig     |   1 -
 arch/mips/configs/maltaup_defconfig           |   1 -
 arch/mips/configs/maltaup_xpa_defconfig       |   1 -
 arch/powerpc/configs/pmac32_defconfig         |   1 -
 arch/powerpc/configs/ppc6xx_defconfig         |   1 -
 arch/powerpc/configs/pseries_defconfig        |   1 -
 arch/sh/configs/titan_defconfig               |   1 -
 fs/fscache/object.c                           |   3 -
 fs/fscache/proc.c                             |  12 --
 32 files changed, 6 insertions(+), 209 deletions(-)

-- 
2.32.0

