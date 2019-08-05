Return-Path: <SRS0=kH5s=WB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043D0C433FF
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Aug 2019 22:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF6902070D
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Aug 2019 22:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfHEWqw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Aug 2019 18:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbfHEWqw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 5 Aug 2019 18:46:52 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 484AB30A699D;
        Mon,  5 Aug 2019 22:46:52 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-55.bne.redhat.com [10.64.54.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D14A510016E8;
        Mon,  5 Aug 2019 22:46:51 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: do not attempt unlink-and-retry-rename for SMB2+ mounts
Date:   Tue,  6 Aug 2019 08:46:39 +1000
Message-Id: <20190805224639.2322-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 05 Aug 2019 22:46:52 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Normally in smb you can not rename ontop of a destination that is held open
except in SMB1 where this is allowed IFF the delete-on-close flag is also set.
This special case is not supported in SMB2 so should not attempt the unlink-and-try-again
since the rename will still fail but we now also delete the destination file.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 56ca4b8ccaba..fdea45267a39 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1777,6 +1777,7 @@ cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	unsigned int xid;
 	int rc, tmprc;
+	struct TCP_Server_Info *server;
 
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
@@ -1786,6 +1787,7 @@ cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
 
 	xid = get_xid();
 
@@ -1809,6 +1811,14 @@ cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
 			    to_name);
 
 	/*
+	 * Do not attempt unlink-then-try-rename-again for SMB2+.
+	 * Renaming ontop of an existing open file IF the delete-on-close
+	 * flag is set is only supported for SMB1.
+	 */
+	if (rc == -EACCES && server->vals->protocol_id != 0)
+		goto cifs_rename_exit;
+
+	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
 	if (flags & RENAME_NOREPLACE)
-- 
2.13.6

