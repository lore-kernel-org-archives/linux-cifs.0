Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A162C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jun 2022 23:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiFMX0G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jun 2022 19:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242275AbiFMX0F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Jun 2022 19:26:05 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4167326C8
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:26:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id e11so7084154pfj.5
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yN8hHNAS2X7XeqIfgYyKc1r6w1n1SpyCvaZTrgnZbZM=;
        b=hJ7/cBRR6rBMLpePD4oerBOndb8zxGVGaGLK3goKJjFwVnhiYhZRqyVO4uOqPsgCaL
         zMaHqbPLOOOPaQtLB0jc2DCEYd5W2UIdAn98jit07/v/UawQJeUcIncIxdA/1cXjEJZt
         XRt1dgwkwueUqLg3Dus3hasSnYQOuQjZY/hRtNQvR/v4UUXD+sQr+wfX8hbq+ibNVBmg
         JcyBIJyuOdTmGKamN/XlVltAdPdzSMPXAE2hXcD6nZotJQ17970MxUUjBBgXvEGuRooe
         XZYBSiquSQ6T+s0a6OPvauFRJRtOHDqp6lJozqvSmUxwDVom0oRcm+ZehtdXKbeg4VQE
         QQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yN8hHNAS2X7XeqIfgYyKc1r6w1n1SpyCvaZTrgnZbZM=;
        b=FgerNbyAHB/2cxAdChvMOE6LwrXik9Pxk4LC82pxc1rF691Tzbw4DyJJQVW0G6J1rP
         Vl7qwQRPu5N7GoOS96AYxvdO4w99Mk2EXGbydEtC5fhkB7SoKzs0/uOXGF4kk3r7B4p9
         oI9YUp4ytQZKLLNgnhf0Ow5hRZ7EXLcci49SPRNG+FjeZchV7PaG7wYixRYVwPLzjtCG
         pUPBMyIQB6H/Lw3gfw1MqJVVjgktEFhUyk3f169ySOMMlpMIfE7EE8Vp5/zUAYJpPjpe
         JYYXf+xVsDOaoVGGA3v2x+7D/eJlSRKejz/B45UEpXOqVn5xVJCIPh/91OYEzQ3qhmqm
         raHw==
X-Gm-Message-State: AJIora/PiGoFJoO77+epgGtagoK41EubN9VGksGin+6pbTWAMc31kVzt
        5RWgsom6m0qCzKDmRIvacs/huSKxWLw=
X-Google-Smtp-Source: AGRyM1traD3TQ0BFM0a/YhrhcBoc/dcvecuvXDEKeB/ENPf7XkTPfa8M5hCXNL2BCIsBRVni8aNMPA==
X-Received: by 2002:a63:9043:0:b0:408:a759:2234 with SMTP id a64-20020a639043000000b00408a7592234mr217325pge.304.1655162763937;
        Mon, 13 Jun 2022 16:26:03 -0700 (PDT)
Received: from localhost.localdomain ([210.217.8.148])
        by smtp.googlemail.com with ESMTPSA id a5-20020a17090a008500b001e325b9a809sm7907707pja.38.2022.06.13.16.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:26:03 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2] ksmbd: remove duplicate flag set in smb2_write
Date:   Tue, 14 Jun 2022 08:25:50 +0900
Message-Id: <20220613232550.85071-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The writethrough flag is set again if
is_rdma_channel is false.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
changes from v1:
 - move ksmbd_debug for flags over the line which checks req->Flags

 fs/ksmbd/smb2pdu.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e6f4ccc12f49..e35930867893 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6490,6 +6490,7 @@ int smb2_write(struct ksmbd_work *work)
 		goto out;
 	}
 
+	ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
 	if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
 		writethrough = true;
 
@@ -6505,10 +6506,6 @@ int smb2_write(struct ksmbd_work *work)
 		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 				    le16_to_cpu(req->DataOffset));
 
-		ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
-		if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
-			writethrough = true;
-
 		ksmbd_debug(SMB, "filename %pd, offset %lld, len %zu\n",
 			    fp->filp->f_path.dentry, offset, length);
 		err = ksmbd_vfs_write(work, fp, data_buf, length, &offset,
-- 
2.25.1

