Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E786BC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  3 May 2022 23:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240423AbiECXRJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 May 2022 19:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbiECXRI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 May 2022 19:17:08 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D5B4163C
        for <linux-cifs@vger.kernel.org>; Tue,  3 May 2022 16:13:34 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w4so25176184wrg.12
        for <linux-cifs@vger.kernel.org>; Tue, 03 May 2022 16:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4orKuiPB2ax1I4aEqfTCLk+8DHMUb5raivwQJLdVUJ8=;
        b=Sul6t8sKgqzY7gqm+dZZJlezkzCimUrK+I2Ik7VFexMrYY6/8SVic64EgIxosdPneC
         4ZQdgcFCoHmt7ndDTw8Y0s9a9bOfuW19obrj2HZ8e6JNA/sIMGGZdhGc1AzqRPGK7jOG
         jIQTBHIDw5nlTgTfGwkjuvhNglikUuNNPzihIuO5LsqnMm4n4cujbgPOto2pjzpgs7bk
         NmCJEZ0XIfizLSeyv7ERlaTL2QPhzkyzZ8W4u6uPkGJoYhJk00JUZOxmRlzT8ui30FXu
         4ni5BDVlG3PQ1ivpgR3pXUnDI5rxbGHv6Q1xw3oarKRmszAan1ZeiSMfKgwjjWDo11Me
         UVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4orKuiPB2ax1I4aEqfTCLk+8DHMUb5raivwQJLdVUJ8=;
        b=njDy0HWJ6SmC5IP1tXqVtF05Z/P2t/7bIWPRvFZis7oCTzcBNezcmEeUlNtOlEHmW9
         O96dyRpGe9m2whwEoxdA174W9IuwVkc9Ihyfp9iCIXP+aS/y0FaRd2EhmSqPat72ssIY
         WvlW2VGmaWuhQRZzNvBgkoBmulqx0SSXQ2F4yAAFNtvRjczoYnMNO78kNL/zdx4J2yoG
         x+KeQ33jz8jr9PmsiHYZ4ryPLj3se96TiKzfyCrESDIFcJ4tR/ieLmO7Vl7n74L3+VMo
         lNuqawma2HZp2lZNoWmWV5WLBUbLu/O3ABHCrWEQIZyuvxjQL+6yeQuHeJw8asBppORg
         XUdw==
X-Gm-Message-State: AOAM530MivkJkSaN2sL1ES+7HYjoxORJt8fSWk+0r2WgbUVIT+S71XMn
        GX2vM7oki9umi5Ss1A9iKLgh2XZakqHXAvUg
X-Google-Smtp-Source: ABdhPJy0abvMJNhfokmLL/sjKTvcQFIyzdBAUxpzXolQvQY1Meg9p89Im9lxn1+s+ZUJNs5NCAnY3Q==
X-Received: by 2002:a5d:6d0b:0:b0:20c:4ecb:1113 with SMTP id e11-20020a5d6d0b000000b0020c4ecb1113mr14138501wrq.203.1651619612693;
        Tue, 03 May 2022 16:13:32 -0700 (PDT)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c3b1500b003942a244f4bsm2789368wms.36.2022.05.03.16.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 16:13:32 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: validate length in smb2_write()
Date:   Wed,  4 May 2022 01:13:23 +0200
Message-Id: <20220503231323.740251-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The SMB2 Write packet contains data that is to be written
to a file or to a pipe. Depending on the client, there may
be padding between the header and the data field.
Currently, the length is validated only in the case padding
is present.

Since the DataOffset field always points to the beginning
of the data, there is no need to have a special case for
padding. By removing this, the length is validated in both
cases.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 smb2pdu.c | 49 +++++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/smb2pdu.c b/smb2pdu.c
index 1caf0d4..cd7b4fb 100644
--- a/smb2pdu.c
+++ b/smb2pdu.c
@@ -6408,23 +6408,18 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	length = le32_to_cpu(req->Length);
 	id = req->VolatileFileId;
 
-	if (le16_to_cpu(req->DataOffset) ==
-	    offsetof(struct smb2_write_req, Buffer)) {
-		data_buf = (char *)&req->Buffer[0];
-	} else {
-		if ((u64)le16_to_cpu(req->DataOffset) + length >
-		    get_rfc1002_len(work->request_buf)) {
-			pr_err("invalid write data offset %u, smb_len %u\n",
-			       le16_to_cpu(req->DataOffset),
-			       get_rfc1002_len(work->request_buf));
-			err = -EINVAL;
-			goto out;
-		}
-
-		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
-				le16_to_cpu(req->DataOffset));
+	if ((u64)le16_to_cpu(req->DataOffset) + length >
+	    get_rfc1002_len(work->request_buf)) {
+		pr_err("invalid write data offset %u, smb_len %u\n",
+		       le16_to_cpu(req->DataOffset),
+		       get_rfc1002_len(work->request_buf));
+		err = -EINVAL;
+		goto out;
 	}
 
+	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
+			   le16_to_cpu(req->DataOffset));
+
 	rpc_resp = ksmbd_rpc_write(work->sess, id, data_buf, length);
 	if (rpc_resp) {
 		if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
@@ -6565,22 +6560,16 @@ int smb2_write(struct ksmbd_work *work)
 
 	if (req->Channel != SMB2_CHANNEL_RDMA_V1 &&
 	    req->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
-		if (le16_to_cpu(req->DataOffset) ==
-		    offsetof(struct smb2_write_req, Buffer)) {
-			data_buf = (char *)&req->Buffer[0];
-		} else {
-			if ((u64)le16_to_cpu(req->DataOffset) + length >
-			    get_rfc1002_len(work->request_buf)) {
-				pr_err("invalid write data offset %u, smb_len %u\n",
-				       le16_to_cpu(req->DataOffset),
-				       get_rfc1002_len(work->request_buf));
-				err = -EINVAL;
-				goto out;
-			}
-
-			data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
-					le16_to_cpu(req->DataOffset));
+		if ((u64)le16_to_cpu(req->DataOffset) + length >
+		    get_rfc1002_len(work->request_buf)) {
+			pr_err("invalid write data offset %u, smb_len %u\n",
+			       le16_to_cpu(req->DataOffset),
+			       get_rfc1002_len(work->request_buf));
+			err = -EINVAL;
+			goto out;
 		}
+		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
+				    le16_to_cpu(req->DataOffset));
 
 		ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
 		if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
-- 
2.25.1

