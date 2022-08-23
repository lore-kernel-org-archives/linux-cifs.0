Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E35C32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 16:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244860AbiHWQjV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245154AbiHWQi0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 12:38:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43570558FF
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 06:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661260062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9xAYAAOCpEEEwELWePUFnuDfySASzSuNbOm12cspl+0=;
        b=IlNhwnZ79xN0JgGELAAPs0NtghysnHp3XU5upwX7lNKNbAcOnvxOVIo2bTUAj14zL4IljD
        rNz5szK53Wp8iiciPxTyLKYLxLZH0c2O7dQQydLjBkRAoYzoZsCJyuqFHhQWqal0gg5G4a
        mjCWpitBFxZDpeETdKvEuoSdKjZbVGI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-chscAqNLNMC1MwvnguUTyg-1; Tue, 23 Aug 2022 09:07:37 -0400
X-MC-Unique: chscAqNLNMC1MwvnguUTyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB11029AB449;
        Tue, 23 Aug 2022 13:07:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7003118EA8;
        Tue, 23 Aug 2022 13:07:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/5] smb3: missing inode locks in zero range
From:   David Howells <dhowells@redhat.com>
To:     sfrench@samba.org, linux-cifs@vger.kernel.org
Cc:     lsahlber@redhat.com, jlayton@kernel.org, dchinner@redhat.com,
        willy@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org
Date:   Tue, 23 Aug 2022 14:07:34 +0100
Message-ID: <166126005487.548536.8031989219056277959.stgit@warthog.procyon.org.uk>
In-Reply-To: <166126004083.548536.11195647088995116235.stgit@warthog.procyon.org.uk>
References: <166126004083.548536.11195647088995116235.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

smb3 fallocate zero range was not grabbing the inode or filemap_invalidate
locks so could have race with pagemap reinstantiating the page.

Cc: stable@vger.kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---

 fs/cifs/smb2ops.c |   55 +++++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7e3de6a0e1dc..1c5a93ced946 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3298,26 +3298,43 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
 	return pntsd;
 }
 
+static long smb3_zero_data(struct file *file, struct cifs_tcon *tcon,
+			     loff_t offset, loff_t len, unsigned int xid)
+{
+	struct cifsFileInfo *cfile = file->private_data;
+	struct file_zero_data_information fsctl_buf;
+
+	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
+
+	fsctl_buf.FileOffset = cpu_to_le64(offset);
+	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
+
+	return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+			  cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
+			  (char *)&fsctl_buf,
+			  sizeof(struct file_zero_data_information),
+			  0, NULL, NULL);
+}
+
 static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len, bool keep_size)
 {
 	struct cifs_ses *ses = tcon->ses;
-	struct inode *inode;
-	struct cifsInodeInfo *cifsi;
+	struct inode *inode = file_inode(file);
+	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
-	struct file_zero_data_information fsctl_buf;
 	long rc;
 	unsigned int xid;
 	__le64 eof;
 
 	xid = get_xid();
 
-	inode = d_inode(cfile->dentry);
-	cifsi = CIFS_I(inode);
-
 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 
+	inode_lock(inode);
+	filemap_invalidate_lock(inode->i_mapping);
+
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
 	 * first, otherwise the data may be inconsistent with the server.
@@ -3325,26 +3342,12 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	truncate_pagecache_range(inode, offset, offset + len - 1);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
-	if (!CIFS_CACHE_READ(cifsi))
-		if (keep_size == false) {
-			rc = -EOPNOTSUPP;
-			trace_smb3_zero_err(xid, cfile->fid.persistent_fid,
-				tcon->tid, ses->Suid, offset, len, rc);
-			free_xid(xid);
-			return rc;
-		}
-
-	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
-
-	fsctl_buf.FileOffset = cpu_to_le64(offset);
-	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
+	rc = -EOPNOTSUPP;
+	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
+		goto zero_range_exit;
 
-	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
-			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
-			(char *)&fsctl_buf,
-			sizeof(struct file_zero_data_information),
-			0, NULL, NULL);
-	if (rc)
+	rc = smb3_zero_data(file, tcon, offset, len, xid);
+	if (rc < 0)
 		goto zero_range_exit;
 
 	/*
@@ -3357,6 +3360,8 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
  zero_range_exit:
+	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,


