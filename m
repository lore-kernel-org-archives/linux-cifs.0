Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83898C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 22:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiEDWvr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 18:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiEDWvq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 18:51:46 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50260527E3
        for <linux-cifs@vger.kernel.org>; Wed,  4 May 2022 15:48:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w4so3825160wrg.12
        for <linux-cifs@vger.kernel.org>; Wed, 04 May 2022 15:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y5ZW9wfARE35+mzpPBdQ/WwQHvHMPvRL2CC5yRh5lbs=;
        b=3KCR+VDZAh7975nHLf51P5iad1NxKBkIxBDP7oyomf2dk+In/64XyuCTJhDZKUlIOv
         7jN2cQIWbYM/hXN7LXZVO3McIAZ/dQwr5QAmWwix8l5mKopQl+Smb1/Dm83ZVYlAmJYS
         I0BMLnpWebPl1DgDp0MzW8sI6BM964bD/juZqRPBYnXu0eYcO6U1o42gmrzmr3iodvpT
         ux5d6N96wKZZ4VWdEcG8nBmnxefwQiQwbxqHN4uI6y/lFI8dBw5Gyks9aDyCZ1Og9Heg
         t/n91tmlJiq3YLCeINk5xmzYLHUSe1u+u/KI46oGqu/lFdAsFGRHTBVwfX874AdsXW05
         SM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y5ZW9wfARE35+mzpPBdQ/WwQHvHMPvRL2CC5yRh5lbs=;
        b=GhPOjloeRH1/IVW0XHf6WP6NVRXd7A3AOviJyKB4walJzWJAVEzX0kxcSX2XuvGQD+
         JPSSSP4A0ndeyYStSx6NpCX3leE8oe59oGyfbG9JLyJqUYggDX/6un4qGQlBKJFMkTfP
         4yV/xyo0auBDiOT2EmJiI7PrzsH8aTEnWakEVls2JNXkAqKFlkOmhhSuELmtgJ4Oa/m5
         w/TrxQpDObmvYYLdt5bkPpeHAVqDn9vzBA4LaeLoRxvpVwRx83efHJ/AeD4bRtbmnrDe
         6GhkA4Jqxpms7msB8AlCJTGnwIxYmXiRmE2h+QuA/gnKUp/zK5FtMEMmOKA/j+ffrIvS
         BC6w==
X-Gm-Message-State: AOAM530oZETgcRVINwyXrND7gcAQfQ5xd32aF2t1CQ0GT2mhw+GjR1wd
        zp0rdLU4ZF59HkYlgH6pOHh21Pe5GtnDzy6R
X-Google-Smtp-Source: ABdhPJyVBb2qiF2uuR0k8UZy4cc/jPQS12AREismuOpQsUkJqnoYMKKp9au7KG/1FkfQrUhknaXQ/A==
X-Received: by 2002:a5d:6949:0:b0:20a:e021:f8e0 with SMTP id r9-20020a5d6949000000b0020ae021f8e0mr18772980wrw.231.1651704486781;
        Wed, 04 May 2022 15:48:06 -0700 (PDT)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id t1-20020adfba41000000b0020c6fa5a797sm6512127wrg.91.2022.05.04.15.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 15:48:06 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: validate length in fsctl_pipe_transceive()
Date:   Thu,  5 May 2022 00:48:01 +0200
Message-Id: <20220504224801.2900034-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The InputCount field contains the number of bytes that should be copied
from the buffer, starting at the InputOffset.

Change to code to:
 - validate InputCount with regards to the buffer length
 - read data from InputOffset, rather than ->Buffer, as there may be
 padding present

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/ksmbd/smb2pdu.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 23b47e505e2b..7e4051479993 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7432,12 +7432,23 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
 				 struct smb2_ioctl_req *req,
 				 struct smb2_ioctl_rsp *rsp)
 {
-	struct ksmbd_rpc_command *rpc_resp;
-	char *data_buf = (char *)&req->Buffer[0];
+	struct ksmbd_rpc_command *rpc_resp = NULL;
+	char *data_buf;
 	int nbytes = 0;
+	size_t length;
 
-	rpc_resp = ksmbd_rpc_ioctl(work->sess, id, data_buf,
-				   le32_to_cpu(req->InputCount));
+	length = le32_to_cpu(req->InputCount);
+
+	if ((u64)le32_to_cpu(req->InputOffset) + length >
+	    get_rfc1002_len(work->request_buf) - 4) {
+		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		goto out;
+	}
+
+	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
+			   le32_to_cpu(req->InputOffset));
+
+	rpc_resp = ksmbd_rpc_ioctl(work->sess, id, data_buf, length);
 	if (rpc_resp) {
 		if (rpc_resp->flags == KSMBD_RPC_SOME_NOT_MAPPED) {
 			/*
-- 
2.25.1

