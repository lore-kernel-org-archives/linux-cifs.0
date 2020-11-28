Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75206C64E7D
	for <linux-cifs@archiver.kernel.org>; Sat, 28 Nov 2020 22:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBC1922470
	for <linux-cifs@archiver.kernel.org>; Sat, 28 Nov 2020 22:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="GOA9n315"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390110AbgK1Vuo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:44 -0500
Received: from mx.cjr.nz ([51.158.111.142]:18290 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387404AbgK1THC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 28 Nov 2020 14:07:02 -0500
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2020 14:07:01 EST
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 7948A7FC02;
        Sat, 28 Nov 2020 18:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1606589845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=c1WGihg4Y+TeY8FPEUibMT9rpbNIyyXMCxx2MN5QcfY=;
        b=GOA9n3154H1X4Gh5avl9QrMGkrWGSzh78amusVe0e/H/If+23v/zeSoUH8T1i4WEHaKO79
        BDq4/mHbmpzeKbPZFOIkCEy7EllLuji6JNDEQdTJXWPA5031271MiQPev15dB3h/WD2egC
        2eY6KOjMh3iJD9tCDa6NvR2ibeWgPw6+9X1kNHLP+J+dx9ePd1jf21kTn1yt9nxZ5FLQpU
        9BmiuKiPmWdxA9Fn2C2QS6hx/we4Jek7ynBESZZP5+0XUJJZk2KT++kzBrMuumLoiQrPui
        weZ0q0h+93+/gHySfMB2hY63Kjy3kSVivDpkOacFxWUGM1NCHLjSPjxwd2M37g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: allow syscalls to be restarted in __smb_send_rqst()
Date:   Sat, 28 Nov 2020 15:57:06 -0300
Message-Id: <20201128185706.8968-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

A customer has reported that several files in their multi-threaded app
were left with size of 0 because most of the read(2) calls returned
-EINTR and they assumed no bytes were read.  Obviously, they could
have fixed it by simply retrying on -EINTR.

We noticed that most of the -EINTR on read(2) were due to real-time
signals sent by glibc to process wide credential changes (SIGRT_1),
and its signal handler had been established with SA_RESTART, in which
case those calls could have been automatically restarted by the
kernel.

Let me the kernel decide to whether or not restart the syscalls when
there is a signal pending in __smb_send_rqst() by returing
-ERESTARTSYS.  If it can't, it will return -EINTR anyway.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/transport.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e27e255d40dd..55853b9ed13d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -338,10 +338,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	if (ssocket == NULL)
 		return -EAGAIN;
 
-	if (signal_pending(current)) {
-		cifs_dbg(FYI, "signal is pending before sending any data\n");
-		return -EINTR;
-	}
+	if (signal_pending(current))
+		return -ERESTARTSYS;
 
 	/* cork the socket */
 	tcp_sock_set_cork(ssocket->sk, true);
-- 
2.29.2

