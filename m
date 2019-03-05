Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DCEC43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 01:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57FC206B6
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 01:48:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lC9RslzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfCEBsJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Mar 2019 20:48:09 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44219 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfCEBsJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Mar 2019 20:48:09 -0500
Received: by mail-pf1-f193.google.com with SMTP id a3so4362873pff.11
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 17:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Can4H29Q3ejASXFiT++BZu4BbfjNyHVeu+ayDMCQ3RU=;
        b=lC9RslzQ8nz2n9yhMVeCmmVu0ttsPoFucRDghyGwuA/13gFMQ/RkqQauAY3SpqzUh9
         UjD9riWG+Pi1YBQeH9DW4u4fWhimpJim7SpubIk9BS/1rnBEg9MwrABZt3DFg+ZlAB0g
         ohmW14RxXg0/tkO8w7U1FvxnWrb6enf9AC1Ot3nU6l4hqmw/oIhzZazkzP+wHYFW2YY7
         As43IEihlzZsOrKaCQY5lGaJbpU+VcQZ3AJvEjL5FZcflTt2nu/lDjf0db3+quX63BkE
         byJHsuy7C5/dVCL3uLFmhg34gWbVYsy/Vk6djmhT29sKKrpaObJvk7qe7z3l+x2QeD8b
         Dx4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Can4H29Q3ejASXFiT++BZu4BbfjNyHVeu+ayDMCQ3RU=;
        b=e+ptrbpG0HXBFAR55aDUtndUZvJ5xUl7mwGLPf41ostiL9xw1aVY4itNVpNx7zmx2i
         Zpam1fyXsWaJkCvE5szNeBsol2mB4aS1XP/BZclo7z6VygUk7leO13qv+gsNNL0FiW/X
         ynrZMz+ZChhUdd4kXlwvI73Cpl37+8Kxa1oMuD5rH0BEf1M3UD0P5p774NXD1KkHQCts
         OX1IuHmG4ApCKgcqLrMRbOxqIJupUiJs7sLWwLCD8OUIkYgjYjI6aTkit9piJrH3c/De
         57MebWHLIDMmAnpCtIOq6unIujw9UWMnD7f4GobDeTjBIhG8bgSWyIwWpELOYGlIkVss
         YgaQ==
X-Gm-Message-State: AHQUAua0u5aKHyYxzDWxpzCQy+xS3SNrcEwW6YZT5VGdeSB4aRq4CZVM
        NaJGdTIfye7BsrrJ0dQXuXZgCmo=
X-Google-Smtp-Source: AHgI3Ibn+SlQnc+jhB7JEkEv6hM5gZyCYhUXFDv4pQcXMFIXacDhBLKMi8fwAgG3dYp2vmOzGkLW9Q==
X-Received: by 2002:a62:38d4:: with SMTP id f203mr22691553pfa.143.1551750488017;
        Mon, 04 Mar 2019 17:48:08 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:a:a184:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id y7sm10273649pge.35.2019.03.04.17.48.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Mar 2019 17:48:07 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com
Subject: [PATCH] CIFS: Fix read after write for files with read caching
Date:   Mon,  4 Mar 2019 17:48:01 -0800
Message-Id: <1551750481-17919-1-git-send-email-pshilov@microsoft.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When we have a READ lease for a file and have just issued a write
operation to the server we need to purge the cache and set oplock/lease
level to NONE to avoid reading stale data. Currently we do that
only if a write operation succedeed thus not covering cases when
a request was sent to the server but a negative error code was
returned later for some other reasons (e.g. -EIOCBQUEUED or -EINTR).
Fix this by turning off caching regardless of the error code being
returned.

The patches fixes generic tests 075 and 112 from the xfs-tests.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9b53f33..4c144c1 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3096,14 +3096,16 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	 * these pages but not on the region from pos to ppos+len-1.
 	 */
 	written = cifs_user_writev(iocb, from);
-	if (written > 0 && CIFS_CACHE_READ(cinode)) {
+	if (CIFS_CACHE_READ(cinode)) {
 		/*
-		 * Windows 7 server can delay breaking level2 oplock if a write
-		 * request comes - break it on the client to prevent reading
-		 * an old data.
+		 * We have read level caching and we have just sent a write
+		 * request to the server thus making data in the cache stale.
+		 * Zap the cache and set oplock/lease level to NONE to avoid
+		 * reading stale data from the cache. All subsequent read
+		 * operations will read new data from the server.
 		 */
 		cifs_zap_mapping(inode);
-		cifs_dbg(FYI, "Set no oplock for inode=%p after a write operation\n",
+		cifs_dbg(FYI, "Set Oplock/Lease to NONE for inode=%p after write\n",
 			 inode);
 		cinode->oplock = 0;
 	}
-- 
2.7.4

