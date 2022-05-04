Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDDFC433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 13:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347485AbiEDNo3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 09:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbiEDNo3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 09:44:29 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C511615700
        for <linux-cifs@vger.kernel.org>; Wed,  4 May 2022 06:40:52 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k126-20020a1ca184000000b003943fd07180so853097wme.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 May 2022 06:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Qlk9s81S/TU40LcE0QlCxCmDQs/ITviUVCm9ssWplo=;
        b=VuURli4/43kfRfAc4HxdNl21EBfZTtMpBP0QmcdgFHtlbPEwXuzz6YcC9X+a3wEDFT
         s0z4sOcLzIPV/v/Nqj3wuuU38MVhcK9NWQSiDNDcfwK3O0V8c9xm6OjwDu1J9yAfhBM3
         t/Hpoz0CWXnKM/ROAhs++ZaSrcgaZuqUyMWp7n7WPoiKFqJwF3Zdwag4MpW/9tXPM/ZE
         9t7GYlUKvi0ZlhH7sUZ5NOBIXvpOpvyzdtwqBFBbwUO/g1aIkSU9C7WfC20o3NyhxmFw
         0hDgVMWjkOc8gDN6jaivb/Q78Sdo/heIDUxSBXkHSdS+3NSuKabXUPkHSG/4UKVWhuF5
         i6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Qlk9s81S/TU40LcE0QlCxCmDQs/ITviUVCm9ssWplo=;
        b=uErfLX2FgxZqC1d6U8B3wP6cIBRmhot2DxvZ6DkVpMcqQsZtMCUvX4f5rUmjlvGtS8
         yY483XQLJbTHAAgbZz05/l6yQHUDd8dxo57ZYOtJiH5Q4vv6roZparYAzeRZkJmZwim1
         QcBlE2o8sJq9v2pQqdmwL/t5hwgOY6EK/Ox5HaYZlIE3okJkhlXGedMBwLoCyqb5h4H5
         NP2uGaqAuey3GKJ+aQtlUWmeurq/gFGmS6INo18fSSwpKXSXovx4P1G9BzO+gjRwsrcb
         EQTMwlzwVyxIDzLyo1mOq48v9UIUeewV+f5Gg5fn9OYbWv0aaAUE9kGLenuPHdimGEiJ
         n7PQ==
X-Gm-Message-State: AOAM531wxzreCY9ppnPz3VkAWM7uy2FCC+jmQMTRerXtomAONbt2aESv
        ZPezdJ4Ym47fKSf8nlpF/4Lk/K6BJho7YUEj
X-Google-Smtp-Source: ABdhPJwajQx+hslnS72AQDbJpz+2meKyVEAC6VcwUnYqpPoVLaIgcmw9LB6awtEv6uxY/LwsUSzI+A==
X-Received: by 2002:a1c:f207:0:b0:38e:9aac:df41 with SMTP id s7-20020a1cf207000000b0038e9aacdf41mr7700179wmc.14.1651671651044;
        Wed, 04 May 2022 06:40:51 -0700 (PDT)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id n21-20020a7bc5d5000000b003942a244f47sm4542217wmk.32.2022.05.04.06.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 06:40:50 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2] ksmbd: validate length in smb2_write()
Date:   Wed,  4 May 2022 15:40:10 +0200
Message-Id: <20220504134009.2586828-1-mmakassikis@freebox.fr>
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
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
The previous patch did not apply cleanly with git-am.

 fs/ksmbd/smb2pdu.c | 49 ++++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 16c803a9d996..2bdfe449b2da 100644
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

