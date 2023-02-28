Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06272C64EC7
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Feb 2023 23:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjB1X5M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Feb 2023 18:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjB1X5L (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Feb 2023 18:57:11 -0500
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1BB17CDA
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 15:57:10 -0800 (PST)
Received: by mail-pf1-f173.google.com with SMTP id a7so6869009pfx.10
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 15:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677628630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WiYIFDTc11Ez0GJBGJIe1NrKbB+pYkE4HeABT6cZyaU=;
        b=k3tBX997O2CmxHo5751BwmURE7QP9C+WiKlS9ncoN/DiRlyaYhMG8C/Y+zufBxQDTu
         jpef2exz+7whmrJuYAPbJujl3MpR31vHkmAwqtNyVwnYxP5fY1JFNTIPiV0fPXwPVlBd
         YAI2r+V+RDyDETHDQTLvbu3yT/tqkMxgeGNTdEotzWEY8nyal1Khq2eDG/T7lon3iYMg
         Wm6pGrn6Ng4ssRcHg4ZIQlZy+kBJMFUteVRk5eFVBt6JipxMLjCa5M8HTeoN3nB4g+RA
         +Aa69tRHiT0ZVRCyNO1IIxowFHEbgdTGTQ7cK/bBBV3t0tp95LkHAWhOPR96AwD2iGRg
         sv6A==
X-Gm-Message-State: AO0yUKVf6P3Ld6FLrlxBc5JPcL8dY0xS8oKNGFMoFks6l6ASYnhgGbW0
        FanNXrqNpK3cF/Y72ZdbJnuMYMt55a4=
X-Google-Smtp-Source: AK7set+F82Cccnt3CThqsXudMRQ/AR3jHzIOPo4RH4ka8r2CdBl5Y4fxSC0UPI/cgmrVB0boO6KqKQ==
X-Received: by 2002:a62:6dc1:0:b0:578:ac9f:79a9 with SMTP id i184-20020a626dc1000000b00578ac9f79a9mr3565915pfc.15.1677628629963;
        Tue, 28 Feb 2023 15:57:09 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id q23-20020a62e117000000b005a8de0f4c64sm6568525pfh.82.2023.02.28.15.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 15:57:09 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        Miao Lihua <441884205@qq.com>
Subject: [PATCH] ksmbd: set FILE_NAMED_STREAMS attribute in FS_ATTRIBUTE_INFORMATION
Date:   Wed,  1 Mar 2023 08:56:24 +0900
Message-Id: <20230228235624.5451-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230228235624.5451-1-linkinjeon@kernel.org>
References: <20230228235624.5451-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If vfs objects = streams_xattr in ksmbd.conf FILE_NAMED_STREAMS should
be set to Attributes in FS_ATTRIBUTE_INFORMATION. MacOS client show
"Format: SMB (Unknown)" on faked NTFS and no streams support.

Reported-by: Miao Lihua <441884205@qq.com>
Tested-by: Miao Lihua <441884205@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 013fd6452942..c774af83b5dc 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4936,6 +4936,10 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 		info->Attributes |= cpu_to_le32(server_conf.share_fake_fscaps);
 
+		if (test_share_config_flag(work->tcon->share_conf,
+		    KSMBD_SHARE_FLAG_STREAMS))
+			info->Attributes |= FILE_NAMED_STREAMS;
+
 		info->MaxPathNameComponentLength = cpu_to_le32(stfs.f_namelen);
 		len = smbConvertToUTF16((__le16 *)info->FileSystemName,
 					"NTFS", PATH_MAX, conn->local_nls, 0);
-- 
2.25.1

