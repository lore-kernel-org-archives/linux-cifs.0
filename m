Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C65C54EBC
	for <linux-cifs@archiver.kernel.org>; Sat,  7 Jan 2023 20:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjAGUBy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 7 Jan 2023 15:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjAGUBw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 7 Jan 2023 15:01:52 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4E313CEA
        for <linux-cifs@vger.kernel.org>; Sat,  7 Jan 2023 12:01:50 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 5F49B7FC02;
        Sat,  7 Jan 2023 20:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673121709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LofiXeTKFKJ8pmiuNoAqdnKoXD+eYhaqf8m4xufUKzU=;
        b=vKxVc0hZf5olCYJOw3ZDOP98HzszDYrv4XOE5XEuhfw4FcXvYKHdvVpa2Td/q15oUgcBXg
        mi2mL5pidVbimFa7P78/m6Oar4784IrNUzmL/6MAffw1BEQS/xDOU2tCBQ6eiBB6Y2weMF
        Wrcc+hztCFg+tC4m0kYrFg2O35pJMN9ltcl+7WtpFd/HAqLVn23yMtl8qOLog/jHksWSl4
        rIbNDCwHINtczHmCbwGom65/pKddqFWuMLlRR4kXWRmRmmLcrY+QJs+SA3IpPY9yQOoezd
        BpB9GVDd0ip6gR+TRan3+xBtSM31+SwnxJfoqv36/VEBdeFJpx9gpHRw42LLow==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/2] cifs: fix file info setting in cifs_open_file()
Date:   Sat,  7 Jan 2023 17:01:34 -0300
Message-Id: <20230107200134.4822-2-pc@cjr.nz>
In-Reply-To: <20230107200134.4822-1-pc@cjr.nz>
References: <20230107200134.4822-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In cifs_open_file(), @buf must hold a pointer to a cifs_open_info_data
structure which is passed by cifs_nt_open(), so assigning @buf
directly to @fi was obviously wrong.

Fix this by passing a valid FILE_ALL_INFO structure to SMBLegacyOpen()
and CIFS_open(), and then copy the set structure to the corresponding
cifs_open_info_data::fi field with move_cifs_info_to_smb2() helper.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216889
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb1ops.c | 54 ++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 5fe2c2f8ef41..4cb364454e13 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -719,17 +719,25 @@ cifs_mkdir_setinfo(struct inode *inode, const char *full_path,
 static int cifs_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32 *oplock,
 			  void *buf)
 {
-	FILE_ALL_INFO *fi = buf;
+	struct cifs_open_info_data *data = buf;
+	FILE_ALL_INFO fi = {};
+	int rc;
 
 	if (!(oparms->tcon->ses->capabilities & CAP_NT_SMBS))
-		return SMBLegacyOpen(xid, oparms->tcon, oparms->path,
-				     oparms->disposition,
-				     oparms->desired_access,
-				     oparms->create_options,
-				     &oparms->fid->netfid, oplock, fi,
-				     oparms->cifs_sb->local_nls,
-				     cifs_remap(oparms->cifs_sb));
-	return CIFS_open(xid, oparms, oplock, fi);
+		rc = SMBLegacyOpen(xid, oparms->tcon, oparms->path,
+				   oparms->disposition,
+				   oparms->desired_access,
+				   oparms->create_options,
+				   &oparms->fid->netfid, oplock, &fi,
+				   oparms->cifs_sb->local_nls,
+				   cifs_remap(oparms->cifs_sb));
+	else
+		rc = CIFS_open(xid, oparms, oplock, &fi);
+
+	if (!rc && data)
+		move_cifs_info_to_smb2(&data->fi, &fi);
+
+	return rc;
 }
 
 static void
@@ -1053,7 +1061,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct inode *newinode = NULL;
 	int rc = -EPERM;
-	FILE_ALL_INFO *buf = NULL;
+	struct cifs_open_info_data buf = {};
 	struct cifs_io_parms io_parms;
 	__u32 oplock = 0;
 	struct cifs_fid fid;
@@ -1085,14 +1093,14 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 					    cifs_sb->local_nls,
 					    cifs_remap(cifs_sb));
 		if (rc)
-			goto out;
+			return rc;
 
 		rc = cifs_get_inode_info_unix(&newinode, full_path,
 					      inode->i_sb, xid);
 
 		if (rc == 0)
 			d_instantiate(dentry, newinode);
-		goto out;
+		return rc;
 	}
 
 	/*
@@ -1100,19 +1108,13 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	 * support block and char device (no socket & fifo)
 	 */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		goto out;
+		return rc;
 
 	if (!S_ISCHR(mode) && !S_ISBLK(mode))
-		goto out;
+		return rc;
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
 
-	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-	if (buf == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_WRITE;
@@ -1127,21 +1129,21 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 		oplock = REQ_OPLOCK;
 	else
 		oplock = 0;
-	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, buf);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, &buf);
 	if (rc)
-		goto out;
+		return rc;
 
 	/*
 	 * BB Do not bother to decode buf since no local inode yet to put
 	 * timestamps in, but we can reuse it safely.
 	 */
 
-	pdev = (struct win_dev *)buf;
+	pdev = (struct win_dev *)&buf.fi;
 	io_parms.pid = current->tgid;
 	io_parms.tcon = tcon;
 	io_parms.offset = 0;
 	io_parms.length = sizeof(struct win_dev);
-	iov[1].iov_base = buf;
+	iov[1].iov_base = &buf.fi;
 	iov[1].iov_len = sizeof(struct win_dev);
 	if (S_ISCHR(mode)) {
 		memcpy(pdev->type, "IntxCHR", 8);
@@ -1160,8 +1162,8 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	d_drop(dentry);
 
 	/* FIXME: add code here to set EAs */
-out:
-	kfree(buf);
+
+	cifs_free_open_info(&buf);
 	return rc;
 }
 
-- 
2.39.0

