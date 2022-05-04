Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120B6C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 22:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiEDWu1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 18:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiEDWu1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 18:50:27 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86E4527E3
        for <linux-cifs@vger.kernel.org>; Wed,  4 May 2022 15:46:48 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 1-20020a05600c248100b00393fbf11a05so4062378wms.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 May 2022 15:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DLbpXK0SKNcRTwM3HyAH1/dBJo8DNm4VBDa339P8R/Y=;
        b=lxp0s09sgf3QZfPFCzoUN3KWVzxOFtCOg7drbWR+L+GIUjMjPUHSTplv3BLVHSddJt
         gkDK8AjglyIuiBG7gAXqNM0yrJq8FCP/yn+Az9536y/s9Uu7CF4M2mzw432hIj9loBpP
         yhrb5pOzkVUUAOu2S2LLqPXYoe4WkVo9fk7Ssdf8OeX1G9Ur6LjWH7N9fBm8OWxcE7iV
         BhYRSuKcBly3dxpDJ6DIqYilqqGaVCqAOcblGEPg3mP+S/URVjhiUZ1++ifyCbQR6A/Z
         IYgBxIgXH+N17b7J6nOUCUHW0/mmmWebbiYpl3Y3PzwCa7vgF9NetcZvQW7+yrhdyw6y
         GI/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DLbpXK0SKNcRTwM3HyAH1/dBJo8DNm4VBDa339P8R/Y=;
        b=2NU3vbpBLSfBw76kI31oM0orofv2XgRw+l221beWdr4WiTyBpet5C/R3/6S8cJvxXt
         IBG69zM8fcVkC3XIIQgbNztfHvrzHKaE4hsWuUTe3urIgPADwyiFmFvo2SA/Pgu2aN7y
         s4McTHVY/81XclLUnIa10Cf3SeIpKcQePjbO10U8IKiJ5tH2yDIagcwl+/hYVVe0nxRD
         RUMklMlHUnhYw0iyZgaGyzOqItfoo5b6QWFGbJ3/FPwJp9wVDL0QD4+r4OL8EaCFWXFm
         mKKhTCxhlDB9N51luzIyWtXcO/UDcsKr8nFWf40nmdcPZSXmw7dc1IlfBoyi8CDIqcfR
         +5FA==
X-Gm-Message-State: AOAM530QUATtDVJByT90g2tUvfyWdDpJwdzys7jSAxMdhCiqnA+i8LEL
        jLw3+nNKxeNCUJKD/6KX8eBaP819M6OSFXGL
X-Google-Smtp-Source: ABdhPJwndgm9ERBYU+a+cmDMP0QhLuAs41QWCuy2xVYAYAH7DorFrPOIHFy2UC6zR5b9CzyNvhjeYQ==
X-Received: by 2002:a1c:f30b:0:b0:380:e444:86b9 with SMTP id q11-20020a1cf30b000000b00380e44486b9mr1506865wmq.81.1651704407174;
        Wed, 04 May 2022 15:46:47 -0700 (PDT)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id r17-20020a05600c425100b003942a244ee2sm19371wmm.39.2022.05.04.15.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 15:46:46 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH v3] ksmbd: validate length in smb2_write()
Date:   Thu,  5 May 2022 00:46:40 +0200
Message-Id: <20220504224640.2865787-1-mmakassikis@freebox.fr>
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

Additionally, fix the length check: DataOffset and Length
fields are relative to the SMB header start, while the packet
length returned by get_rfc1002_len() includes 4 additional
bytes.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
Change since v2:
 - the length check was wrong, as it did not account for the rfc1002
 header in work->request_buf.

 fs/ksmbd/smb2pdu.c | 49 ++++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 16c803a9d996..23b47e505e2b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6328,23 +6328,18 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
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
+	    get_rfc1002_len(work->request_buf) - 4) {
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
@@ -6489,22 +6484,16 @@ int smb2_write(struct ksmbd_work *work)
 
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
+		    get_rfc1002_len(work->request_buf) - 4) {
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

