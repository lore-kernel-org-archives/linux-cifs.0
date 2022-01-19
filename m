Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD40C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Jan 2022 15:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355426AbiASPBj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Jan 2022 10:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349566AbiASPBi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Jan 2022 10:01:38 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9007C061574
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jan 2022 07:01:38 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id p125so2873639pga.2
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jan 2022 07:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zgBbQ9wNUvkfhI9BOFDKAJ35bWh/CFXR2wzthqKsMDw=;
        b=GRnvDO7daPYqMXIFhwOhEePyvUji4UqgYnF/8O5qMNq+wxbeS2tQb8WozF/d9SN7fG
         yJ0kQiyjuaAKXdp7R+3LR6Vok/vCuP72nJF2srrgm7aWdNlmk1rzcpb7xfy3xdRDTGdS
         Z6F536JorIfhv4Z7idZelM374Bgp5+b0npMHZ2dTmQ38mlWghJ9HXq7Fuu7lxQAT+FRj
         cEROmNqvRNKUM6AQwjAXbO/WDQI97uZ+tfjlr+TXOph6pbpHXiX8GVFCwptxM9+z+Ec1
         79xiGNtFgBPKF+cDW0cbGNvvTZEpiUYbGjAQX0wMf0shjyk+6a90Qa0T1GdQEuEp/5mo
         WIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zgBbQ9wNUvkfhI9BOFDKAJ35bWh/CFXR2wzthqKsMDw=;
        b=OiKnImW2sMv6yUJy7PuVpPgiJJ72NxZnzgGvhv0rXYL707ej8JsD79ltlCAGdYUgij
         oEo8sq4m/BnQw5cbrP+aWJHDuHamlqrfq7tCOo1k5yZv7rtjX5++eTEmQ6tt8+EJqnma
         sMC3lQwTbuM2X95zpddkoq1Epk+5nKmp9P4wJTilRyHLayscG6jNQbF19ORiC2h+MOnL
         5AyE7b+FyrXL+pSeaSBB0IbkTZFAlOLqyfE9ErNZaWyWezatn6wCO5CQzJpEF5WYs98F
         G0r2xpEm4oJsbN9WKU3XeSoTQalCmiQ2B8PS2pmNlKl0rmRfNH0TzvdjAahsnAtztOyq
         /+KA==
X-Gm-Message-State: AOAM5305fL+Afb/Yaza/FffZ/lCiZ85MWVsmGJjKYugNzmF79yFL5gKG
        yODu39RVvV4vVpjO3oodB+vPXUBj+54=
X-Google-Smtp-Source: ABdhPJw2zLw4SW+4PDK5V0cxcb6efhhzoWqwKWPqi1XgpC/HX0sq87FoUPLGFSA8NjKA9cCRieOXog==
X-Received: by 2002:a62:1ec3:0:b0:4bb:ea7d:6c4f with SMTP id e186-20020a621ec3000000b004bbea7d6c4fmr30716730pfe.4.1642604497887;
        Wed, 19 Jan 2022 07:01:37 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id gj1sm6265016pjb.18.2022.01.19.07.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 07:01:36 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: smbd: validate buffer descriptor structures
Date:   Thu, 20 Jan 2022 00:01:15 +0900
Message-Id: <20220119150115.177058-1-hyc.lee@gmail.com>
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
 fs/ksmbd/smb2pdu.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c3f248d461e6..f664fbadb09a 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6130,12 +6130,20 @@ static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
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
+	for (i = 0; i < ch_count; i++) {
+		ksmbd_debug(RDMA, "RDMA r/w request %#x: token %#x, length %#x\n",
+			    i,
+			    le32_to_cpu(desc[i].token),
+			    le32_to_cpu(desc[i].length));
+	}
+	if (ch_count != 1)
 		return -EINVAL;
 
 	work->need_invalidate_rkey =
@@ -6189,9 +6197,15 @@ int smb2_read(struct ksmbd_work *work)
 
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
@@ -6432,11 +6446,16 @@ int smb2_write(struct ksmbd_work *work)
 
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

