Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1831CC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2A360249
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhISCPA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 22:15:00 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:44853 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhISCPA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 22:15:00 -0400
Received: by mail-pg1-f181.google.com with SMTP id s11so13765157pgr.11
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 19:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eQo+PtaWrUl+hgVhXUG5UoM0UZNnX88d57f7Mi2vU2M=;
        b=HL19iD09RcSVRPxEJZgrejd8SBqA7ZbpLQYw8QgPvfm3gj0qO9Swx+E8/qr5Fxya/6
         1N1ePR+awKVjtEZN6h8Ni05EKJzsHEfDyUBuLO6qbDqK5VdFM4ALm6+jZTZQFhzwqoPB
         XQG8+MHsFFZCXi7hsJDdj2DtuHRDKw2i3HNygt89lVV/6ar5TJfhHBx8W14ppv6Ig8b6
         KzJuDmOhbq9bAnkY3rDeu1qZ7KBbigNLzwUlO/dAsjoo/4aZbnyPJhb93Jxs7oumktov
         LYcwtno9zT9Un1LRtWfrWo+J0VRQ8HDwHMffqIVlJsGG4rOcVudWA5NZV2pWdR+ssmRW
         HSsg==
X-Gm-Message-State: AOAM532tg/GE+qE0MfssCT4yNta81GcAlR4V7WlXMJAihoOCJd26Wm4y
        G/26M2GIDQnq/Z/1kmnOOmBeb95Y7kWX6A==
X-Google-Smtp-Source: ABdhPJwBXeFtAKj5cyObIzFow+Bs43tteb0vxSeSQ2GFic88xyNFywwf5AdddoCVaFLRpMaW3PBFzQ==
X-Received: by 2002:a63:6f06:: with SMTP id k6mr17224687pgc.281.1632017615588;
        Sat, 18 Sep 2021 19:13:35 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id m28sm10849537pgl.9.2021.09.18.19.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 19:13:35 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH v2 3/4] ksmbd: add validation for FILE_FULL_EA_INFORMATION of smb2_get_info
Date:   Sun, 19 Sep 2021 11:13:14 +0900
Message-Id: <20210919021315.642856-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919021315.642856-1-linkinjeon@kernel.org>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add validation to check whether req->InputBufferLength is smaller than
smb2_ea_info_req structure size.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - fix typo of validation in patch subject.
 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 6ea50a9ac64e..117cf242d9b8 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4059,6 +4059,10 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 	path = &fp->filp->f_path;
 	/* single EA entry is requested with given user.* name */
 	if (req->InputBufferLength) {
+		if (le32_to_cpu(req->InputBufferLength) <
+		    sizeof(struct smb2_ea_info_req))
+			return -EINVAL;
+
 		ea_req = (struct smb2_ea_info_req *)req->Buffer;
 	} else {
 		/* need to send all EAs, if no specific EA is requested*/
-- 
2.25.1

