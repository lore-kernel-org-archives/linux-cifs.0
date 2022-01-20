Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17EDC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jan 2022 12:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiATMKU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jan 2022 07:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiATMKT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Jan 2022 07:10:19 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AAAC061574
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jan 2022 04:10:18 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d10-20020a17090a498a00b001b33bc40d01so4328523pjh.1
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jan 2022 04:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3bwLvQpBC3Gj8vEqJSlEfgT0a+lniW2+2CulhEgl7WA=;
        b=XdVz6pG6o44upNVLz5yttmpkkZ17F1RmBdERY5QrT2YrbpaNnfOkXg+4bxMYFiUgnF
         ACcvyUXcsLFOPFGkDy8LtOBaW6iIITEEMt8BzIP8Tgozj0ddBn7cOKtdFP3ruL6c/ayt
         EG4b9oOj1n5aVjVpWFAww2d4e9Yj5M98VMSm9z2O0CTwEs4eImCoWDk0gjrNnei3sNn6
         aiK/U+I4c3JiYHQTUBQpltFBZ9vfB9hDuH97cMihEIBWvcNgB/U4Sh0xWjkVPOloeDqu
         gIBkuCTiumWNonMwNcuhc0WDYYXyCdx4ySWnWzKMqBbqGmLrz3swT447MTNFdO0N2MxB
         Vivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3bwLvQpBC3Gj8vEqJSlEfgT0a+lniW2+2CulhEgl7WA=;
        b=Qfdi3gZY/kp9RWtk5XC18s8mwq+sgQfmuPBidqajGYczcRzmbGLjMWyOBMUIviQqbW
         M0b4DIITJxdxZXkODTHuqLyUspX8dcvrhj3iEt1SbPYtxTX+i/FV0GOk+MrhFUXXjz0J
         PdVeOTo8afnmFONa/W2UV39aLdkmGZB1sGaZO64Q6uIki/G2WwnUuFvUKTM5s2AGXGUm
         cuGz539JEgg2Heh2jkXGCC5KA01V7lRlZKLRiR5ayFsDtciIIyiFDnjbKJuyg5pPkmcP
         p0oMUq/NenZyE5zQkrj8zGLFoUscr05SAXCCqyufRRi1K9Tk1800q0hxzUOkrP901RGK
         MK9Q==
X-Gm-Message-State: AOAM530fX2+HGXqJHYSTwX84Tm8+TRLHTkuzUkdKvqMZjKMZ7DMk2bVm
        SMZuUPKLTV4gBxH4XSRYGkvD3q4+k+U=
X-Google-Smtp-Source: ABdhPJzFhfTlJJdDgkoBa9r3PK1855GoOHjAVYH67yrBkF+WnUp3jNQweFJBcvB8sVL4gOKBhf0W3Q==
X-Received: by 2002:a17:902:bcc1:b0:149:a13f:af62 with SMTP id o1-20020a170902bcc100b00149a13faf62mr37625746pls.147.1642680618182;
        Thu, 20 Jan 2022 04:10:18 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id o11sm2459032pgj.33.2022.01.20.04.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 04:10:17 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2] ksmbd: smbd: validate buffer descriptor structures
Date:   Thu, 20 Jan 2022 21:10:11 +0900
Message-Id: <20220120121011.213873-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Check ChannelInfoOffset and ChannelInfoLength
to validate buffer descriptor structures.
And add a debug log to print the structures'
content.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
changes from v1:
 - avoid a loop for printing debug logs.
 - print a debug log if the number of buffer descriptors is not 1.

 fs/ksmbd/smb2pdu.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c3f248d461e6..de8e651248bd 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6130,13 +6130,26 @@ static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
 					__le16 ChannelInfoOffset,
 					__le16 ChannelInfoLength)
 {
+	unsigned int i, ch_count;
+
 	if (work->conn->dialect == SMB30_PROT_ID &&
 	    Channel != SMB2_CHANNEL_RDMA_V1)
 		return -EINVAL;
 
-	if (ChannelInfoOffset == 0 ||
-	    le16_to_cpu(ChannelInfoLength) < sizeof(*desc))
+	ch_count = le16_to_cpu(ChannelInfoLength) / sizeof(*desc);
+	if (ksmbd_debug_types & KSMBD_DEBUG_RDMA) {
+		for (i = 0; i < ch_count; i++) {
+			pr_info("RDMA r/w request %#x: token %#x, length %#x\n",
+				i,
+				le32_to_cpu(desc[i].token),
+				le32_to_cpu(desc[i].length));
+		}
+	}
+	if (ch_count != 1) {
+		ksmbd_debug(RDMA, "RDMA multiple buffer descriptors %d are not supported yet\n",
+			    ch_count);
 		return -EINVAL;
+	}
 
 	work->need_invalidate_rkey =
 		(Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
@@ -6189,9 +6202,15 @@ int smb2_read(struct ksmbd_work *work)
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+		unsigned int ch_offset = le16_to_cpu(req->ReadChannelInfoOffset);
+
+		if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
+			err = -EINVAL;
+			goto out;
+		}
 		err = smb2_set_remote_key_for_rdma(work,
 						   (struct smb2_buffer_desc_v1 *)
-						   &req->Buffer[0],
+						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->ReadChannelInfoOffset,
 						   req->ReadChannelInfoLength);
@@ -6432,11 +6451,16 @@ int smb2_write(struct ksmbd_work *work)
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
-		if (req->Length != 0 || req->DataOffset != 0)
-			return -EINVAL;
+		unsigned int ch_offset = le16_to_cpu(req->WriteChannelInfoOffset);
+
+		if (req->Length != 0 || req->DataOffset != 0 ||
+		    ch_offset < offsetof(struct smb2_write_req, Buffer)) {
+			err = -EINVAL;
+			goto out;
+		}
 		err = smb2_set_remote_key_for_rdma(work,
 						   (struct smb2_buffer_desc_v1 *)
-						   &req->Buffer[0],
+						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->WriteChannelInfoOffset,
 						   req->WriteChannelInfoLength);
-- 
2.25.1

