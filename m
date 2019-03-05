Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2EAC43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C74320661
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hf8yYyVY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfCEXwJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 18:52:09 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:33111 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfCEXwJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 18:52:09 -0500
Received: by mail-pg1-f182.google.com with SMTP id h11so6798623pgl.0
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 15:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=q7Xjx3ImxRb9Dz2fGk0FA5bqkJIA9Oji3akMM4VIS2o=;
        b=hf8yYyVY1NXG5b/d5eyF8f+h4LYdGQjhcANYrSXvqxckE52Ng7E26eLj9MjVf/Txsm
         VcTX1j6jklcGOch1NR8f9rS1/B5ul86ODRD2w42vQChffXFq04ER2PlmLxbjcvWKVpw9
         TCeix7q3KRrTLmkokRZhDWpcnmcL67T/BPBidYY49Xol9kX0JvUL3LNj5WfNjDjELobc
         moYt0Xn+/+u9srhaTpZ4rsOlcwIF04QMkfDAAgtBNlX667cvDsOeNjlN66jK0nlD6TRe
         ekSFlXrmWlp4UyenjETCXYY+JLhSuIXKzBZKIZQY9I4gd8LRg7ybaiWLUrp5mcivdNXP
         LoPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=q7Xjx3ImxRb9Dz2fGk0FA5bqkJIA9Oji3akMM4VIS2o=;
        b=AhKsatQtM8FPt/mhV/K1W6Fsio7YsSPyPmYja7Z+zOj1d4dGCeyAr214+Lzx/cGPEU
         ZBlR7zzlAeTeGlMvg3X43lVYwgY6W0RkNJN4wQQaxtAvzWIfjzZeenCtHcuIR9FnjP0B
         9rxPa90/ePO7xadyPJcdWpO8oHnZdytH+g/h1TDsXNk4bmAqigs9krHNdj63xaQCycD2
         rQwUvD/W/LhnJkJlu9C1UlsvvhE4R4BixEckIOASVp21QtddEbXDTsKKwyFbUjOpGVAU
         etqURsDHpr4R+V9EbIiMv0snKS2zFmxL//H+j42jWd6CAjoVVeMso+xTHciXG37x092T
         scgA==
X-Gm-Message-State: APjAAAVa2VNCIYi9p5kXm6QiDpbTrI+89IdpDhFFMr3GgitpgBODhTlU
        0Z2oGbqKsmaFAItwkKLyi5Q4XgU=
X-Google-Smtp-Source: APXvYqx2lqxokv97RVRmU4gmM5VBmyfF3EqpeWPSl5h8c4Y09PbAucffQi81L/AOzGPeIKGMHnDCFw==
X-Received: by 2002:a63:c0b:: with SMTP id b11mr3645897pgl.388.1551829928228;
        Tue, 05 Mar 2019 15:52:08 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:1:a18d:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id l64sm50342pga.87.2019.03.05.15.52.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Mar 2019 15:52:07 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: [PATCH 3/3] CIFS: Mask off signals when sending SMB packets
Date:   Tue,  5 Mar 2019 15:51:57 -0800
Message-Id: <1551829917-48772-5-git-send-email-pshilov@microsoft.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551829917-48772-1-git-send-email-pshilov@microsoft.com>
References: <1551829917-48772-1-git-send-email-pshilov@microsoft.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We don't want to break SMB sessions if we receive signals when
sending packets through the network. Fix it by masking off signals
inside __smb_send_rqst() to avoid partial packet sends due to
interrupts.

Return -EINTR if a signal is pending and only a part of the packet
was sent. Return a success status code if the whole packet was sent
regardless of signal being pending or not. This keeps a mid entry
for the request in the pending queue and allows the demultiplex
thread to handle a response from the server properly.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/transport.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 9f23a45..7ce8a58 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -33,6 +33,7 @@
 #include <linux/uaccess.h>
 #include <asm/processor.h>
 #include <linux/mempool.h>
+#include <linux/signal.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -291,6 +292,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	int n_vec;
 	unsigned int send_length = 0;
 	unsigned int i, j;
+	sigset_t mask, oldmask;
 	size_t total_len = 0, sent, size;
 	struct socket *ssocket = server->ssocket;
 	struct msghdr smb_msg;
@@ -305,6 +307,11 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	if (ssocket == NULL)
 		return -EAGAIN;
 
+	if (signal_pending(current)) {
+		cifs_dbg(FYI, "signal is pending before sending any data\n");
+		return -EINTR;
+	}
+
 	/* cork the socket */
 	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
 				(char *)&val, sizeof(val));
@@ -313,6 +320,16 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		send_length += smb_rqst_len(server, &rqst[j]);
 	rfc1002_marker = cpu_to_be32(send_length);
 
+	/*
+	 * We should not allow signals to interrupt the network send because
+	 * any partial send will cause session reconnects thus increasing
+	 * latency of system calls and overload a server with unnecessary
+	 * requests.
+	 */
+
+	sigfillset(&mask);
+	sigprocmask(SIG_BLOCK, &mask, &oldmask);
+
 	/* Generate a rfc1002 marker for SMB2+ */
 	if (server->vals->header_preamble_size == 0) {
 		struct kvec hiov = {
@@ -322,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		iov_iter_kvec(&smb_msg.msg_iter, WRITE, &hiov, 1, 4);
 		rc = smb_send_kvec(server, &smb_msg, &sent);
 		if (rc < 0)
-			goto uncork;
+			goto unmask;
 
 		total_len += sent;
 		send_length += 4;
@@ -344,7 +361,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 
 		rc = smb_send_kvec(server, &smb_msg, &sent);
 		if (rc < 0)
-			goto uncork;
+			goto unmask;
 
 		total_len += sent;
 
@@ -366,7 +383,25 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		}
 	}
 
-uncork:
+unmask:
+	sigprocmask(SIG_SETMASK, &oldmask, NULL);
+
+	/*
+	 * If signal is pending but we have already sent the whole packet to
+	 * the server we need to return success status to allow a corresponding
+	 * mid entry to be kept in the pending requests queue thus allowing
+	 * to handle responses from the server by the client.
+	 *
+	 * If only part of the packet has been sent there is no need to hide
+	 * interrupt because the session will be reconnected anyway, so there
+	 * won't be any response from the server to handle.
+	 */
+
+	if (signal_pending(current) && (total_len != send_length)) {
+		cifs_dbg(FYI, "signal is pending after attempt to send\n");
+		rc = -EINTR;
+	}
+
 	/* uncork it */
 	val = 0;
 	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
-- 
2.7.4

