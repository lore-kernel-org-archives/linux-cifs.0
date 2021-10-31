Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1B1C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 31 Oct 2021 01:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F56A60FC0
	for <linux-cifs@archiver.kernel.org>; Sun, 31 Oct 2021 01:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhJaBGr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Oct 2021 21:06:47 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:38492 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbhJaBGr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Oct 2021 21:06:47 -0400
Received: by mail-pg1-f180.google.com with SMTP id e65so13701094pgc.5
        for <linux-cifs@vger.kernel.org>; Sat, 30 Oct 2021 18:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eRFQ1Ko1HhlANB0OJdAzRtBToDc/emvxLDXUnxFxCnU=;
        b=eZhQec/wyiQYw0OWEJsdfL1qyUYnumUJ3yVeZO3+0+A8xayfhg1Vrsc3lF5gdwqZ4O
         r5WuqatRixit346M578BxIcmsQqqUaz78pXJGqcG6F6zscv0ZZrORAm46h3yPpdO/p+H
         D2/oekw4BpiY+GCfBWRRO7eejNlNk2SGZKZA2y/gUn4S6PMJF4Y1qKM4wvvJ2N6Vdq4v
         i8CZ8Xn6zcLNvXC3vtreFn99EPFAMjfiY6yNV+yNTUFJb7CLyiFs0ytEZzME5e9QpMjZ
         0ucZfiSU2teYoefbXIHvm7xXjo+YZ6y9sCqvNUpEXD1lr9c77DEIQ/9Cz1Obay4AWDO8
         YR3g==
X-Gm-Message-State: AOAM5318CdQ/7BR5E+E5pkvf6itPq8pCOAHfQ720TunOO8wxWw10VJ49
        FiOwfnXPgDdy+lkcXC9UiAMF9Zgkq24=
X-Google-Smtp-Source: ABdhPJzuMfpB102Vj+i1GvpoyX+u8ZOub/K/cfMyaQ/L6v7q8TZYx5HGlXx8bDVJt/igo5YCGoyj5w==
X-Received: by 2002:a63:720c:: with SMTP id n12mr14920152pgc.95.1635642256133;
        Sat, 30 Oct 2021 18:04:16 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g7sm8714843pgp.17.2021.10.30.18.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 18:04:15 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 1/2] ksmbd: set unique value to volume serial field in FS_VOLUME_INFORMATION
Date:   Sun, 31 Oct 2021 10:04:06 +0900
Message-Id: <20211031010407.11078-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French reported ksmbd set fixed value to volume serial field in
FS_VOLUME_INFORMATION. Volume serial value needs to be set to a unique
value for client fscache. This patch set crc value that is generated
with share name, path name and netbios name to volume serial.

Reported-by: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/Kconfig   | 1 +
 fs/ksmbd/server.c  | 1 +
 fs/ksmbd/smb2pdu.c | 9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/Kconfig b/fs/ksmbd/Kconfig
index b83cbd756ae5..6af339cfdc04 100644
--- a/fs/ksmbd/Kconfig
+++ b/fs/ksmbd/Kconfig
@@ -19,6 +19,7 @@ config SMB_SERVER
 	select CRYPTO_GCM
 	select ASN1
 	select OID_REGISTRY
+	select CRC32
 	default n
 	help
 	  Choose Y here if you want to allow SMB3 compliant clients
diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index 2a2b2135bfde..36d368e59a64 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -632,5 +632,6 @@ MODULE_SOFTDEP("pre: sha512");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
 MODULE_SOFTDEP("pre: gcm");
+MODULE_SOFTDEP("pre: crc32");
 module_init(ksmbd_server_init)
 module_exit(ksmbd_server_exit)
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a925e0f67fb8..04f82b5870c3 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4892,11 +4892,18 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	{
 		struct filesystem_vol_info *info;
 		size_t sz;
+		unsigned int serial_crc = 0;
 
 		info = (struct filesystem_vol_info *)(rsp->Buffer);
 		info->VolumeCreationTime = 0;
+		serial_crc = crc32_le(serial_crc, share->name,
+				      strlen(share->name));
+		serial_crc = crc32_le(serial_crc, share->path,
+				      strlen(share->path));
+		serial_crc = crc32_le(serial_crc, ksmbd_netbios_name(),
+				      strlen(ksmbd_netbios_name()));
 		/* Taking dummy value of serial number*/
-		info->SerialNumber = cpu_to_le32(0xbc3ac512);
+		info->SerialNumber = cpu_to_le32(serial_crc);
 		len = smbConvertToUTF16((__le16 *)info->VolumeLabel,
 					share->name, PATH_MAX,
 					conn->local_nls, 0);
-- 
2.25.1

