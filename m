Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D762FC636D3
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Feb 2023 09:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBHJgl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Feb 2023 04:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjBHJgc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Feb 2023 04:36:32 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088C36A4D
        for <linux-cifs@vger.kernel.org>; Wed,  8 Feb 2023 01:36:19 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id w5so8595047plg.8
        for <linux-cifs@vger.kernel.org>; Wed, 08 Feb 2023 01:36:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mEZSkhU9/b930v+5mntVKWtcENywFzpfYI8svC/n9S4=;
        b=db4/NXSdkLKOKzCr4/Gqpr/fs/d3o+OQRgdGOORe5EDqCANTwnVdU+7eE5jTIuXz84
         gsjZ7OZ6ttdHCjgu3R8WUIIWEvI+PXOaJ8DJFnIxb1bPaaFx3EBjabuFaANF4AQ76jTX
         Kq96u/Ry6Iyd8b/pa3wjZ6cFcvp9qFaRGYvKO4Gx/T8cpwgIsWkeb2JTIj/VWTKZ8qbj
         NCB3Ts2Dcl04AIjbnnAKOH+yu7zAV2w5pR/WCrGQOR4LTX4arbRqfD8XKb9itWv/4Vd9
         jBX24bNcemiV38yprKh2dj/6hdpQqiITtCLj1vMbxYMtUVMNx917UHpGpKaBb8GE24YT
         xYxA==
X-Gm-Message-State: AO0yUKVW93uSnpMmdiOq2HQkdOIXex5p9GYRuzeuj5clhCFzTgd9xoz8
        Z0gXenSuBWnyE1DsymJmJadKI/4Fdvk=
X-Google-Smtp-Source: AK7set8Gwi8WcIzmzqQ0R5b5R4GbwSkG5zkz8P5PFyjMq2dV2UROgZrJNhag2lH7i2ShJf1m1ySu6Q==
X-Received: by 2002:a17:90b:38cf:b0:230:d786:4a22 with SMTP id nn15-20020a17090b38cf00b00230d7864a22mr8173833pjb.24.1675848978332;
        Wed, 08 Feb 2023 01:36:18 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090a728c00b00230e41e98desm1058945pjg.32.2023.02.08.01.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 01:36:18 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: fix wrong data area length for smb2 lock request
Date:   Wed,  8 Feb 2023 18:35:49 +0900
Message-Id: <20230208093549.10493-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When turning debug mode on, The following error message from
ksmbd_smb2_check_message() is coming.

ksmbd: cli req padded more than expected. Length 112 not 88 for cmd:10 mid:14

data area length calculation for smb2 lock request in smb2_get_data_area_len() is
incorrect.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2misc.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 6e25ace36568..a717aa9b4af8 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -149,15 +149,11 @@ static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
 		break;
 	case SMB2_LOCK:
 	{
-		int lock_count;
+		unsigned short lock_count;
 
-		/*
-		 * smb2_lock request size is 48 included single
-		 * smb2_lock_element structure size.
-		 */
-		lock_count = le16_to_cpu(((struct smb2_lock_req *)hdr)->LockCount) - 1;
+		lock_count = le16_to_cpu(((struct smb2_lock_req *)hdr)->LockCount);
 		if (lock_count > 0) {
-			*off = __SMB2_HEADER_STRUCTURE_SIZE + 48;
+			*off = offsetof(struct smb2_lock_req, locks);
 			*len = sizeof(struct smb2_lock_element) * lock_count;
 		}
 		break;
-- 
2.25.1

