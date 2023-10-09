Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218FEE95A91
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Oct 2023 15:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376414AbjJIPMX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Oct 2023 11:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376407AbjJIPMX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Oct 2023 11:12:23 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BA9D8
        for <linux-cifs@vger.kernel.org>; Mon,  9 Oct 2023 08:12:18 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-54290603887so3007737a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Oct 2023 08:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696864338; x=1697469138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qHqAJN3/xKNjyKFwf0jueH44mOYUiTA0mEdNWN0qnuk=;
        b=ng0+3aqFzgdyRQxNrbjv1R/Lz1PZFPZrmyCwJxjE2GhlJntj2khRUtwyub8Qm4X7oN
         TAjHMy7wEzcTcA8zaPa6DmQ+YLn1HvkXxsPFQ8rSan18QynxehOkqk5Zz7LHmPk4tFZA
         4mCbxRAkO7d62qySGR/m1Ipf1uYATO0pVGHhtpnZTnNB+ArnWLbekaSsqTIgI6Iz9YBB
         C4/7QJZLaTGVA2Br4+Ttn48BX+Miim+6V/Uynra65whVxL7gciI3XlW3gTQ2cXxZjiLZ
         gCF2k4wrxrtwq3pO9yY3l2dtupjTSArTMNHRWjytE5fUuSaYN2UTMEozxs/RUUt5M6U5
         V7HA==
X-Gm-Message-State: AOJu0YzITv6pK8dvMsoLetMwRBStPjehWUFKZyMdNpz9t0mnG6i8F/dV
        Us4pqmdGoq2kM5oiLN8ObYALFIMiLFA=
X-Google-Smtp-Source: AGHT+IFIPZQXiBKM9BOyj3IH0w7tNnIM2LT0A63jiTgozsiyqDWqIvGgnAo7kHHF5nlJzHAq+ZBG7A==
X-Received: by 2002:a17:90b:1b50:b0:274:8041:94c with SMTP id nv16-20020a17090b1b5000b002748041094cmr12406871pjb.13.1696864337597;
        Mon, 09 Oct 2023 08:12:17 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id mp3-20020a17090b190300b00267d9f4d340sm10529284pjb.44.2023.10.09.08.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 08:12:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: fix wrong error response status by using set_smb2_rsp_status()
Date:   Tue, 10 Oct 2023 00:11:52 +0900
Message-Id: <20231009151153.7360-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009151153.7360-1-linkinjeon@kernel.org>
References: <20231009151153.7360-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

set_smb2_rsp_status() after __process_request() sets the wrong error
status. This patch resets all iov vectors and sets the error status
on clean one.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 898860adf929..87c6401a6007 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -231,11 +231,12 @@ void set_smb2_rsp_status(struct ksmbd_work *work, __le32 err)
 {
 	struct smb2_hdr *rsp_hdr;
 
-	if (work->next_smb2_rcv_hdr_off)
-		rsp_hdr = ksmbd_resp_buf_next(work);
-	else
-		rsp_hdr = smb2_get_msg(work->response_buf);
+	rsp_hdr = smb2_get_msg(work->response_buf);
 	rsp_hdr->Status = err;
+
+	work->iov_idx = 0;
+	work->iov_cnt = 0;
+	work->next_smb2_rcv_hdr_off = 0;
 	smb2_set_err_rsp(work);
 }
 
-- 
2.25.1

