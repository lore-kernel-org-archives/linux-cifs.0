Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ECCC10F09
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6173720661
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="swjtLlVb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfCEXwH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 18:52:07 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:34160 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfCEXwG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 18:52:06 -0500
Received: by mail-pf1-f172.google.com with SMTP id u9so6942590pfn.1
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 15:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=jeh9kj+3kqhQKH7ieaG0fHxPOku5+prnDq6x9rAw5tE=;
        b=swjtLlVb5V7nR6DYdh1fVRa8S16ajOdN9HWVXb83nsOuZsC3TdYTR6BfbJtdUkHoP3
         7aIh7hQOYNdQyZ1iC3pN6MWt4StS6Yipc5oF6NL1Or2QlGY0Wgv+JUvtRdff6eD5R6VZ
         tJElJ9K5vtxsFGaD96639PW+73KHdKG7w1wmjGHkGttmHr0C4GDE6z9U+q5hBpJ2zW+j
         aYM+2j+SGlaYqSgBsH2JDJnBgN59pRfxZIx4EbdSr64m9rrW543SWEqmPP8vbX3tLFAS
         tW6PmIIVYIWLR5/Rh0hTBD2oFpYi6fa5dpzPAa+84aiLyX0N0hjDyhH2Y7a4hAprd8v/
         bWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=jeh9kj+3kqhQKH7ieaG0fHxPOku5+prnDq6x9rAw5tE=;
        b=XDOTAk9g4FtKXl3nx1jgfr0688Q/XYg8QlQ3RGl5lmzqQIzOJ93oi5TZYgYfmE0Gfp
         xizVAWY4Ib6/tggRy0ZgLHdUKvj+cxFumwJvGyPV/Q0UdNK3hAmgHZ1XbliJbbO0bCnu
         ISMk2Kq41jNkrmZqqkMeQJ27gTDQ/zYuFVCI7igzByIgEww0J/ZOPcIZxK003KPS6lNQ
         tiN2zosQv4GqZronNtF+UBhdk0aLBooGX2i/dnUWObsgpQQ2rxBdCHGZz9nS9MuxNItZ
         ZXuikxT87brYyBj1h+I3q162ZXpscl3Pz7ltcUynJ+LDXwOq3nsq+EmaXqf3bK3pHp0v
         YOHA==
X-Gm-Message-State: APjAAAVxuA6C8wTngeZBv6v8gEXIN3uQU+b3TPcCVvPlUn/6F03qHJx4
        gaiuYorSqjzsxbwR5HwUIrktxsc=
X-Google-Smtp-Source: APXvYqzaIsmbJM4BpO+9GwrWnRK1czkkEjEA+v86avWADm0K/wnJvifP8dXJWdwrMxY9Whma1tSjRg==
X-Received: by 2002:a17:902:4081:: with SMTP id c1mr3871085pld.297.1551829925940;
        Tue, 05 Mar 2019 15:52:05 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:1:a18d:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id l64sm50342pga.87.2019.03.05.15.52.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Mar 2019 15:52:05 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: [PATCH 1/3] CIFS: Only send SMB2_NEGOTIATE command on new TCP connections
Date:   Tue,  5 Mar 2019 15:51:55 -0800
Message-Id: <1551829917-48772-3-git-send-email-pshilov@microsoft.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551829917-48772-1-git-send-email-pshilov@microsoft.com>
References: <1551829917-48772-1-git-send-email-pshilov@microsoft.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do not allow commands other than SMB2_NEGOTIATE to be sent over
recently established TCP connections. Return -EAGAIN to let upper
layers handle it properly.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/smb2transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index fa1fec2..d118157 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -619,6 +619,10 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_sync_hdr *shdr,
 		return -EAGAIN;
 	}
 
+	if (ses->server->tcpStatus == CifsNeedNegotiate &&
+	   shdr->Command != SMB2_NEGOTIATE)
+		return -EAGAIN;
+
 	if (ses->status == CifsNew) {
 		if ((shdr->Command != SMB2_SESSION_SETUP) &&
 		    (shdr->Command != SMB2_NEGOTIATE))
@@ -702,6 +706,10 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
+	if (server->tcpStatus == CifsNeedNegotiate &&
+	   shdr->Command != SMB2_NEGOTIATE)
+		return ERR_PTR(-EAGAIN);
+
 	smb2_seq_num_into_buf(server, shdr);
 
 	mid = smb2_mid_entry_alloc(shdr, server);
-- 
2.7.4

