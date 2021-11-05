Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76601C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 15:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E08F61108
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 15:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhKEPtZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Nov 2021 11:49:25 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:42224
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232412AbhKEPtY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Nov 2021 11:49:24 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 159B13F1D8
        for <linux-cifs@vger.kernel.org>; Fri,  5 Nov 2021 15:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636127204;
        bh=AZ2gloRjaGSelBDHUs66L2AD8OBUvTDJdaiIuuRPNLk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=rPq5ElgxqzrCnG9OKsMHBSdzXr7UBhwr6jESOlSe0QrDka/Jon+TIvgOfncJ4H5t/
         gjRtUChjUeujAKVSn3VJ16lRSDlvAf+EGuQzV6HG+ejXfltwGlzGlLnLMhnYzXCeB8
         +d/Sg41YAqQqWi3ZX+uqlrZ3KETiSmibD4de+MC7afsJakIBdpvoaYYEf7uDSqUD4Y
         T2p+TfxUeW5ntl9IHoBn/5lcfI7HjMgX1iOrNVGnjpfr90rzcKXHqavgJB3lF/pg4u
         xJ7d67t1XXiyBBpPexu5DFYPFNXpwbrOLokG5FlJDu52iwMB2LupLq9cMdOQf9u7KQ
         HH7PwaNQSJrRA==
Received: by mail-wr1-f69.google.com with SMTP id d7-20020a5d6447000000b00186a113463dso2453018wrw.10
        for <linux-cifs@vger.kernel.org>; Fri, 05 Nov 2021 08:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AZ2gloRjaGSelBDHUs66L2AD8OBUvTDJdaiIuuRPNLk=;
        b=G1ZNGwvzzM3eQGPd5LK4RInPVbJ2ZD4dlFCBz7RY7moQItr3IgSwr8kf7Cb4O4xMkp
         1c18dt11SjRDAs62xNbx5dd4PUc5MpPypwy68nEvFtLdXt5RRuXkjtHh1GZhxgZ4uef5
         z5qWSfE11V6S9TZc4jmu6LYWZhTTEVUJkYHLaymf3SD9gUGEKv8MlQf2Y8uA8eSWxCOB
         aRh8OKEnwTz8nmi4dQ9dZz7UKCkAHlKlXn8MgghpjDDkxXSrAmVLAKDw4sZypqes0GDc
         AQBb1FB9GlvjuqWzNv4d/h1vJ31fH9BJ/BykiC7+wS6d2O/5M4lSDU9nAVHlEAjw8JXC
         L5OA==
X-Gm-Message-State: AOAM530wuIPxpf2QBBRs3Pfgs/SgvVHHmh9jIsUF1oBGp60umXKfYY50
        4jBiuFgHyUAd/VMFm96IitBUZCQ/e+CRQgjfZADA6F02g4g7UXGBPd2uK4BZl8Sbz9W2EF2XENa
        h3TDlq+ymF6c3L35hXS2EuC/2yevGpK6f3aTFrpY=
X-Received: by 2002:a5d:648e:: with SMTP id o14mr36228304wri.69.1636127203650;
        Fri, 05 Nov 2021 08:46:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5k996q02AvLPMDT6zp/eTqKcLpYZhxXm5GjlYrXrZ8v9D6rr2qQHoIq1Cs+RM4w+4Mx4VtA==
X-Received: by 2002:a5d:648e:: with SMTP id o14mr36228265wri.69.1636127203485;
        Fri, 05 Nov 2021 08:46:43 -0700 (PDT)
Received: from localhost.localdomain (lfbn-lyo-1-470-249.w2-7.abo.wanadoo.fr. [2.7.60.249])
        by smtp.gmail.com with ESMTPSA id 6sm8070834wma.48.2021.11.05.08.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:46:43 -0700 (PDT)
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
Subject: [PATCH 3/7] Documentation, arch: Remove leftovers from CIFS_WEAK_PW_HASH
Date:   Fri,  5 Nov 2021 16:43:30 +0100
Message-Id: <20211105154334.1841927-4-alexandre.ghiti@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211105154334.1841927-1-alexandre.ghiti@canonical.com>
References: <20211105154334.1841927-1-alexandre.ghiti@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This config was removed so remove all references to it.

Fixes: 76a3c92ec9e0 ("cifs: remove support for NTLM and weaker authentication algorithms")
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
---
 Documentation/admin-guide/cifs/usage.rst    | 7 +++----
 arch/arm/configs/cm_x300_defconfig          | 1 -
 arch/arm/configs/ezx_defconfig              | 1 -
 arch/arm/configs/imote2_defconfig           | 1 -
 arch/arm/configs/nhk8815_defconfig          | 1 -
 arch/arm/configs/pxa_defconfig              | 1 -
 arch/mips/configs/fuloong2e_defconfig       | 1 -
 arch/mips/configs/malta_qemu_32r6_defconfig | 1 -
 arch/mips/configs/maltaaprp_defconfig       | 1 -
 arch/mips/configs/maltasmvp_defconfig       | 1 -
 arch/mips/configs/maltasmvp_eva_defconfig   | 1 -
 arch/mips/configs/maltaup_defconfig         | 1 -
 arch/mips/configs/nlm_xlp_defconfig         | 1 -
 arch/mips/configs/nlm_xlr_defconfig         | 1 -
 arch/powerpc/configs/ppc6xx_defconfig       | 1 -
 arch/sh/configs/titan_defconfig             | 1 -
 16 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/Documentation/admin-guide/cifs/usage.rst b/Documentation/admin-guide/cifs/usage.rst
index f170d8820258..3766bf8a1c20 100644
--- a/Documentation/admin-guide/cifs/usage.rst
+++ b/Documentation/admin-guide/cifs/usage.rst
@@ -734,10 +734,9 @@ SecurityFlags		Flags which control security negotiation and
 			using weaker password hashes is 0x37037 (lanman,
 			plaintext, ntlm, ntlmv2, signing allowed).  Some
 			SecurityFlags require the corresponding menuconfig
-			options to be enabled (lanman and plaintext require
-			CONFIG_CIFS_WEAK_PW_HASH for example).  Enabling
-			plaintext authentication currently requires also
-			enabling lanman authentication in the security flags
+			options to be enabled.  Enabling plaintext
+			authentication currently requires also enabling
+			lanman authentication in the security flags
 			because the cifs module only supports sending
 			laintext passwords using the older lanman dialect
 			form of the session setup SMB.  (e.g. for authentication
diff --git a/arch/arm/configs/cm_x300_defconfig b/arch/arm/configs/cm_x300_defconfig
index 502a9d870ca4..45769d0ddd4e 100644
--- a/arch/arm/configs/cm_x300_defconfig
+++ b/arch/arm/configs/cm_x300_defconfig
@@ -146,7 +146,6 @@ CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_ISO8859_1=m
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index a49e699e52de..ec84d80096b1 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -314,7 +314,6 @@ CONFIG_NFSD_V3_ACL=y
 CONFIG_SMB_FS=m
 CONFIG_CIFS=m
 CONFIG_CIFS_STATS=y
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
diff --git a/arch/arm/configs/imote2_defconfig b/arch/arm/configs/imote2_defconfig
index 118c4c927f26..6db871d4e077 100644
--- a/arch/arm/configs/imote2_defconfig
+++ b/arch/arm/configs/imote2_defconfig
@@ -288,7 +288,6 @@ CONFIG_NFSD_V3_ACL=y
 CONFIG_SMB_FS=m
 CONFIG_CIFS=m
 CONFIG_CIFS_STATS=y
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
index 23595fc5a29a..907d6512821a 100644
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -127,7 +127,6 @@ CONFIG_NFS_FS=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
index 58f4834289e6..dedaaae3d0d8 100644
--- a/arch/arm/configs/pxa_defconfig
+++ b/arch/arm/configs/pxa_defconfig
@@ -699,7 +699,6 @@ CONFIG_NFSD_V3_ACL=y
 CONFIG_NFSD_V4=y
 CONFIG_CIFS=m
 CONFIG_CIFS_STATS=y
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_DEFAULT="utf8"
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index 5c24ac7fdf56..ba47c5e929b7 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -206,7 +206,6 @@ CONFIG_NFSD_V3_ACL=y
 CONFIG_NFSD_V4=y
 CONFIG_CIFS=m
 CONFIG_CIFS_STATS2=y
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_CIFS_DEBUG2=y
diff --git a/arch/mips/configs/malta_qemu_32r6_defconfig b/arch/mips/configs/malta_qemu_32r6_defconfig
index 614af02d83e6..6fb9bc29f4a0 100644
--- a/arch/mips/configs/malta_qemu_32r6_defconfig
+++ b/arch/mips/configs/malta_qemu_32r6_defconfig
@@ -165,7 +165,6 @@ CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
diff --git a/arch/mips/configs/maltaaprp_defconfig b/arch/mips/configs/maltaaprp_defconfig
index 9c051f8fd330..eb72df528243 100644
--- a/arch/mips/configs/maltaaprp_defconfig
+++ b/arch/mips/configs/maltaaprp_defconfig
@@ -166,7 +166,6 @@ CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
diff --git a/arch/mips/configs/maltasmvp_defconfig b/arch/mips/configs/maltasmvp_defconfig
index 2e90d97551d6..1fb40d310f49 100644
--- a/arch/mips/configs/maltasmvp_defconfig
+++ b/arch/mips/configs/maltasmvp_defconfig
@@ -167,7 +167,6 @@ CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
diff --git a/arch/mips/configs/maltasmvp_eva_defconfig b/arch/mips/configs/maltasmvp_eva_defconfig
index d1f7fdb27284..75cb778c6149 100644
--- a/arch/mips/configs/maltasmvp_eva_defconfig
+++ b/arch/mips/configs/maltasmvp_eva_defconfig
@@ -169,7 +169,6 @@ CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
diff --git a/arch/mips/configs/maltaup_defconfig b/arch/mips/configs/maltaup_defconfig
index 48e5bd492452..7b4f247dc60c 100644
--- a/arch/mips/configs/maltaup_defconfig
+++ b/arch/mips/configs/maltaup_defconfig
@@ -165,7 +165,6 @@ CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
diff --git a/arch/mips/configs/nlm_xlp_defconfig b/arch/mips/configs/nlm_xlp_defconfig
index c97f00ece828..1c8b73d03263 100644
--- a/arch/mips/configs/nlm_xlp_defconfig
+++ b/arch/mips/configs/nlm_xlp_defconfig
@@ -459,7 +459,6 @@ CONFIG_NFSD=m
 CONFIG_NFSD_V3_ACL=y
 CONFIG_NFSD_V4=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_UPCALL=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
diff --git a/arch/mips/configs/nlm_xlr_defconfig b/arch/mips/configs/nlm_xlr_defconfig
index 60ea102783d9..11acfc173058 100644
--- a/arch/mips/configs/nlm_xlr_defconfig
+++ b/arch/mips/configs/nlm_xlr_defconfig
@@ -411,7 +411,6 @@ CONFIG_NFSD=m
 CONFIG_NFSD_V3_ACL=y
 CONFIG_NFSD_V4=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_UPCALL=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 6697c5e6682f..bb549cb1c3e3 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -1022,7 +1022,6 @@ CONFIG_NFSD=m
 CONFIG_NFSD_V3_ACL=y
 CONFIG_NFSD_V4=y
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_CIFS_UPCALL=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
diff --git a/arch/sh/configs/titan_defconfig b/arch/sh/configs/titan_defconfig
index ba887f1351be..cd5c58916c65 100644
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@ -242,7 +242,6 @@ CONFIG_NFSD=y
 CONFIG_NFSD_V3=y
 CONFIG_SMB_FS=m
 CONFIG_CIFS=m
-CONFIG_CIFS_WEAK_PW_HASH=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_ASCII=m
-- 
2.32.0

