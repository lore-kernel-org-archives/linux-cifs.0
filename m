Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1832C43331
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 01:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99F1B2196E
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 01:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YyudXKpz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfKMBQp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:16:45 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38331 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfKMBQp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Nov 2019 20:16:45 -0500
Received: by mail-pg1-f195.google.com with SMTP id 15so213979pgh.5
        for <linux-cifs@vger.kernel.org>; Tue, 12 Nov 2019 17:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=+lOE/k6LVJEXdnmts7jJUIQUP0fNfgL7TBq9P5cqt00=;
        b=YyudXKpzR789Z54Wun5UFUDV/VfYUvR56CFlpTl9KUlwO/gV5GDVb6hQazu8xNPd5D
         l8h6oeLE8+2DnJvrlIFRc9XT1mE4GemDCo2FAfPKlSAVe7q+sZycKF6fEM1kY/v7Uzqz
         b5jztLQCZDUHpwEqes33Zb8s/K/3TYHFI+yHit1wZDN2Uwo2TObCcUeHsFvKxMndiWgD
         RsbS2pojoUAdwwmVy56TLtnbfa6ME4/fYGoisQwMVpLLZd9m2XXoAdRa3DT8F1tg2kII
         M4Brzqz8j91FqATtyw2yUvOpGRaZB2cKR38w807BTbPI2B3CQvxRpPJnCygpsKvh795F
         irKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=+lOE/k6LVJEXdnmts7jJUIQUP0fNfgL7TBq9P5cqt00=;
        b=GQ8zhX88hJyYRHtveB8knMKnC/QyvtFaxzmP9gR5luQNfT7ka08ED4F8hext7szlnh
         zc0wItyv3701Rl9JvPmz27OcK3TVmD6M3489C8590ASRALJDgO3tETOJ3FMAbtoICD6g
         Z7M9Zgdy3sVdqcv6D5qjyMJA0dTp1RzbKBffqfONFkzfnDfDLFSOHO38XjVH9nGIih8O
         yTISrRIhrBGR9trtHx+GBynF7AOT3+kmq2SKO++zYcqcy5jIwEOMTFFKl6rl9ldH7iqy
         syqRD7FhSrkpuZYFYgWmW7i/wNM3QS05a8ggzHN9dGm71veXBnn9+yvtGff2KFcPQRU3
         ZszQ==
X-Gm-Message-State: APjAAAWtB7SMSaurbKof2l67Nh4RTslJGDIT6BIeTx3aJeBhm7DGnvwi
        hZoTMZrUYxlspNXdWYn2J1pNOGY=
X-Google-Smtp-Source: APXvYqzhWIxDp5JGd6jAWASxzRGGbbLdHjg2NvtHL50Hu6KqxyOKJaffG50RrW8PioWwa4FY3OaiuQ==
X-Received: by 2002:aa7:9ab0:: with SMTP id x16mr1030971pfi.139.1573607803809;
        Tue, 12 Nov 2019 17:16:43 -0800 (PST)
Received: from ubuntu-vm.mshome.net ([167.220.2.106])
        by smtp.gmail.com with ESMTPSA id f13sm219703pfa.57.2019.11.12.17.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 17:16:42 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: [PATCH] CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
Date:   Tue, 12 Nov 2019 17:16:35 -0800
Message-Id: <20191113011635.3511-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently the client translates O_SYNC and O_DIRECT flags
into corresponding SMB create options when openning a file.
The problem is that on reconnect when the file is being
re-opened the client doesn't set those flags and it causes
a server to reject re-open requests because create options
don't match. The latter means that any subsequent system
call against that open file fail until a share is re-mounted.

Fix this by properly setting SMB create options when
re-openning files after reconnects.

Fixes: 1013e760d10e6: ("SMB3: Don't ignore O_SYNC/O_DSYNC and O_DIRECT flags")
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b6f544bc6c73..89617bb058ae 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -721,6 +721,13 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
+	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
+	if (cfile->f_flags & O_SYNC)
+		create_options |= CREATE_WRITE_THROUGH;
+
+	if (cfile->f_flags & O_DIRECT)
+		create_options |= CREATE_NO_BUFFER;
+
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &cfile->fid);
 
-- 
2.17.1

