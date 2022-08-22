Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D69AC28D13
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Aug 2022 16:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbiHVQPN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiHVQPL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Aug 2022 12:15:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BDD32A8D
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 09:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661184909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZYcX7i12OLQjRtFMCpG1WFZ73LDRbWXnHfP0DqkCOQg=;
        b=eYN9JxxJXx2asHHx4HIxe2hKnk57ZnfzAZVwrKWsz974Ew0R3vWmUIHrBmq6quZ10TjkgM
        r/1ponxjhqjYhIn7HstDBOhLeAkXhERxrXgv6XbRCIT2QCY1SH8DJQPcEDMYymuVgPLsXV
        t9Ss+0iDiiSuGEU4qVhLFGAoB5zJxgk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-2CFo4Y1YMcGXJ167URRj5w-1; Mon, 22 Aug 2022 12:15:07 -0400
X-MC-Unique: 2CFo4Y1YMcGXJ167URRj5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 605F2185A7A4;
        Mon, 22 Aug 2022 16:15:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEACD2166B26;
        Mon, 22 Aug 2022 16:15:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mtVOKN-8ET1oYC0L+ihAWpmwFY3=Q=-KP+qwcaAb002_A@mail.gmail.com>
References: <CAH2r5mtVOKN-8ET1oYC0L+ihAWpmwFY3=Q=-KP+qwcaAb002_A@mail.gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH][SMB3] fix temporary data corruption in collapse range
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2082179.1661184906.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 22 Aug 2022 17:15:06 +0100
Message-ID: <2082180.1661184906@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

I think we need something like the attached.  I haven't tested it yet as I
have to go out for a bit.  I added inode locking and filemap-invalidation
locking and put the invalidations before the ops to take care of mmap.

David
---
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f406af596887..5b267d4515d3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3316,22 +3316,39 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
 	return pntsd;
 }
 =

+static long smb3_erase_range(struct file *file, struct cifs_tcon *tcon,
+			     loff_t offset, loff_t len, unsigned int xid)
+{
+	struct cifsFileInfo *cfile =3D file->private_data;
+	struct file_zero_data_information fsctl_buf;
+
+	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
+
+	fsctl_buf.FileOffset =3D cpu_to_le64(offset);
+	fsctl_buf.BeyondFinalZero =3D cpu_to_le64(offset + len);
+
+	return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+			  cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, true,
+			  (char *)&fsctl_buf,
+			  sizeof(struct file_zero_data_information),
+			  0, NULL, NULL);
+}
+
 static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len, bool keep_size)
 {
 	struct cifs_ses *ses =3D tcon->ses;
-	struct inode *inode;
-	struct cifsInodeInfo *cifsi;
+	struct inode *inode =3D file_inode(file);
+	struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
 	struct cifsFileInfo *cfile =3D file->private_data;
-	struct file_zero_data_information fsctl_buf;
 	long rc;
 	unsigned int xid;
 	__le64 eof;
 =

-	xid =3D get_xid();
+	inode_lock(inode);
+	filemap_invalidate_lock(inode->i_mapping);
 =

-	inode =3D d_inode(cfile->dentry);
-	cifsi =3D CIFS_I(inode);
+	xid =3D get_xid();
 =

 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
@@ -3343,26 +3360,12 @@ static long smb3_zero_range(struct file *file, str=
uct cifs_tcon *tcon,
 	truncate_pagecache_range(inode, offset, offset + len - 1);
 =

 	/* if file not oplocked can't be sure whether asking to extend size */
-	if (!CIFS_CACHE_READ(cifsi))
-		if (keep_size =3D=3D false) {
-			rc =3D -EOPNOTSUPP;
-			trace_smb3_zero_err(xid, cfile->fid.persistent_fid,
-				tcon->tid, ses->Suid, offset, len, rc);
-			free_xid(xid);
-			return rc;
-		}
-
-	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
-
-	fsctl_buf.FileOffset =3D cpu_to_le64(offset);
-	fsctl_buf.BeyondFinalZero =3D cpu_to_le64(offset + len);
+	rc =3D -EOPNOTSUPP;
+	if (keep_size =3D=3D false && !CIFS_CACHE_READ(cifsi))
+		goto zero_range_exit;
 =

-	rc =3D SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
-			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, true,
-			(char *)&fsctl_buf,
-			sizeof(struct file_zero_data_information),
-			0, NULL, NULL);
-	if (rc)
+	rc =3D smb3_erase_range(file, tcon, offset, len, xid);
+	if (rc < 0)
 		goto zero_range_exit;
 =

 	/*
@@ -3375,6 +3378,8 @@ static long smb3_zero_range(struct file *file, struc=
t cifs_tcon *tcon,
 	}
 =

  zero_range_exit:
+	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
@@ -3388,23 +3393,22 @@ static long smb3_zero_range(struct file *file, str=
uct cifs_tcon *tcon,
 static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len)
 {
-	struct inode *inode;
+	struct inode *inode =3D file_inode(file);
 	struct cifsFileInfo *cfile =3D file->private_data;
 	struct file_zero_data_information fsctl_buf;
 	long rc;
 	unsigned int xid;
 	__u8 set_sparse =3D 1;
 =

-	xid =3D get_xid();
+	inode_lock(inode);
 =

-	inode =3D d_inode(cfile->dentry);
+	xid =3D get_xid();
 =

 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
 	if (!smb2_set_sparse(xid, tcon, cfile, inode, set_sparse)) {
 		rc =3D -EOPNOTSUPP;
-		free_xid(xid);
-		return rc;
+		goto out;
 	}
 =

 	filemap_invalidate_lock(inode->i_mapping);
@@ -3424,8 +3428,10 @@ static long smb3_punch_hole(struct file *file, stru=
ct cifs_tcon *tcon,
 			true /* is_fctl */, (char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
-	free_xid(xid);
 	filemap_invalidate_unlock(inode->i_mapping);
+out:
+	inode_unlock(inode);
+	free_xid(xid);
 	return rc;
 }
 =

@@ -3682,28 +3688,31 @@ static long smb3_collapse_range(struct file *file,=
 struct cifs_tcon *tcon,
 {
 	int rc;
 	unsigned int xid;
-	struct inode *inode;
+	struct inode *inode =3D file_inode(file);
 	struct cifsFileInfo *cfile =3D file->private_data;
-	struct cifsInodeInfo *cifsi;
+	struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
 	__le64 eof;
+	loff_t old_eof;
 =

 	xid =3D get_xid();
 =

-	inode =3D d_inode(cfile->dentry);
-	cifsi =3D CIFS_I(inode);
+	inode_lock(inode);
 =

-	if (off >=3D i_size_read(inode) ||
-	    off + len >=3D i_size_read(inode)) {
+	old_eof =3D i_size_read(inode);
+	if ((off >=3D old_eof) ||
+	    off + len >=3D old_eof) {
 		rc =3D -EINVAL;
 		goto out;
 	}
 =

+	truncate_pagecache_range(inode, off, old_eof);
+
 	rc =3D smb2_copychunk_range(xid, cfile, cfile, off + len,
-				  i_size_read(inode) - off - len, off);
+				  old_eof - off - len, off);
 	if (rc < 0)
 		goto out;
 =

-	eof =3D cpu_to_le64(i_size_read(inode) - len);
+	eof =3D cpu_to_le64(old_eof - len);
 	rc =3D SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, &eof);
 	if (rc < 0)
@@ -3715,6 +3724,7 @@ static long smb3_collapse_range(struct file *file, s=
truct cifs_tcon *tcon,
 	truncate_setsize(inode, cifsi->server_eof);
 	fscache_resize_cookie(cifs_inode_cookie(inode), cifsi->server_eof);
  out:
+	inode_unlock(inode);
 	free_xid(xid);
 	return rc;
 }
@@ -3725,18 +3735,24 @@ static long smb3_insert_range(struct file *file, s=
truct cifs_tcon *tcon,
 	int rc;
 	unsigned int xid;
 	struct cifsFileInfo *cfile =3D file->private_data;
+	struct inode *inode =3D file_inode(file);
 	__le64 eof;
-	__u64  count;
+	__u64  count, old_eof;
+
+	inode_lock(inode);
 =

 	xid =3D get_xid();
 =

-	if (off >=3D i_size_read(file->f_inode)) {
+	old_eof =3D i_size_read(inode);
+	if (off >=3D old_eof) {
 		rc =3D -EINVAL;
 		goto out;
 	}
 =

-	count =3D i_size_read(file->f_inode) - off;
-	eof =3D cpu_to_le64(i_size_read(file->f_inode) + len);
+	count =3D old_eof - off;
+	eof =3D cpu_to_le64(old_eof + len);
+
+	truncate_pagecache_range(inode, off, old_eof);
 =

 	rc =3D SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, &eof);
@@ -3747,12 +3763,13 @@ static long smb3_insert_range(struct file *file, s=
truct cifs_tcon *tcon,
 	if (rc < 0)
 		goto out;
 =

-	rc =3D smb3_zero_range(file, tcon, off, len, 1);
+	rc =3D smb3_erase_range(file, tcon, off, len, xid);
 	if (rc < 0)
 		goto out;
 =

 	rc =3D 0;
  out:
+	inode_unlock(inode);
 	free_xid(xid);
 	return rc;
 }

