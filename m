Return-Path: <SRS0=Aodf=XZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADDBC35280
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Sep 2019 17:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B0A2086A
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Sep 2019 17:06:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JCJgCSPq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbfI3RGc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Sep 2019 13:06:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41323 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3RGb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Sep 2019 13:06:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so7718078pgv.8
        for <linux-cifs@vger.kernel.org>; Mon, 30 Sep 2019 10:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XdIZEeRl8rX3xz1HbP4700Ee7ySwvlKM/eWCQUVJ3a4=;
        b=JCJgCSPqm3YYzpwSGh7+gJ3I6gCzAwIWdsJ9XaxlXdeND+mhxBE4TSOT75fmgWBWpc
         PJ60ZXTPBHoba/777E0PTEIfjfcjZ4x2tGpTqsa/KHCDqQrBEt2AYmHddjzFLrZm6XFn
         5mV8ZJtu7sdTwgc43MVv8dcTQ4kiBAoYtz93ue6xB5xw8WU83YtyZyUuqpUtMeZhTnCA
         GMe2WJHBrbdy0gQnqRB+5wjr1sPdo2nJWP9tAjimZDPdeQUL90/a/hQ99mAKnyqPXigX
         +5cDgc7vKwG9UZdy5RNqC6evgLWucikCrhZS/n8JEPX6/r8gT8D7OqmKxmJrNqpaiHd5
         UPpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XdIZEeRl8rX3xz1HbP4700Ee7ySwvlKM/eWCQUVJ3a4=;
        b=WExsKGkCj4CrYItKrmgORyWsVTeN93I6T3osQTwljBxkk1O4o5Rrn859V2GPoKzSqz
         kzq6+BOa0XLJxv+KABItsHM7p8m/+Y8/iOD2QZfybcFwRo/CUHLzB+Toqc4fDTK/PkB3
         4LSzumQ7lpN1oivICpnumYFAeyiQfC0qYzhThht99atEWe16K/kFdfQroNhBFZ7fkGsU
         UryYrvakJuQCs0vYarJHTw5AnsHZAWrSOoRsElIuJFaEMxfQ89zrn/GLfGWYBNIOR+dU
         3ywDS/rO5F++3t/yn80X2Vb631GdhMzZcFXtWNALCHox2ydP6ato1MtwU2vMEgMVdYPQ
         ddOQ==
X-Gm-Message-State: APjAAAUso9d4zrKH1MjbTyXnVg4+Cp6x2maoDiA2aieJHOjJICEqQyaT
        xBRwj9/pVtzPpuIQxHhJxsK3eks=
X-Google-Smtp-Source: APXvYqyyxlIQjuRdKygo76MFhgoVhfEJoy1UlB8hlnX0ogrbzwGsR6LQsSl1iiTw9q62YQTCU6qhrg==
X-Received: by 2002:a17:90a:fe0b:: with SMTP id ck11mr234764pjb.87.1569863189303;
        Mon, 30 Sep 2019 10:06:29 -0700 (PDT)
Received: from ubuntu-vm.mshome.net ([131.107.147.106])
        by smtp.gmail.com with ESMTPSA id d5sm18350780pfa.180.2019.09.30.10.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 10:06:28 -0700 (PDT)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Subject: [PATCH 3/3] CIFS: Force reval dentry if LOOKUP_REVAL flag is set
Date:   Mon, 30 Sep 2019 10:06:20 -0700
Message-Id: <20190930170620.29979-3-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930170620.29979-1-pshilov@microsoft.com>
References: <20190930170620.29979-1-pshilov@microsoft.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Mark inode for force revalidation if LOOKUP_REVAL flag is set.
This tells the client to actually send a QueryInfo request to
the server to obtain the latest metadata in case a directory
or a file were changed remotely.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/dir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index be424e81e3ad..91a46b01d748 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -738,10 +738,16 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 static int
 cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 {
+	struct inode *inode;
+
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
 	if (d_really_is_positive(direntry)) {
+		inode = d_inode(direntry);
+		if (flags & LOOKUP_REVAL)
+			CIFS_I(inode)->time = 0; /* force reval */
+
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
 		else {
@@ -752,7 +758,7 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 			 * attributes will have been updated by
 			 * cifs_revalidate_dentry().
 			 */
-			if (IS_AUTOMOUNT(d_inode(direntry)) &&
+			if (IS_AUTOMOUNT(inode) &&
 			   !(direntry->d_flags & DCACHE_NEED_AUTOMOUNT)) {
 				spin_lock(&direntry->d_lock);
 				direntry->d_flags |= DCACHE_NEED_AUTOMOUNT;
-- 
2.17.1

