Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2482434E20
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 14:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213275; cv=none; b=ZDx1zuzLhMEjAus/RGnAjHxB9eP6YCdMELbEzD9iqrmMeTSq0sOm9XSOx4GFkZfsFAb0p/7yr6cm+1gkLeN5GrLPHJ57gShgFpiXLg6Blvk9omTZZwSjompkFzQiMlSfo4cTt5p4T9kPxbVc5oOC+B5hgGj3ZH77LogQC099Wfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213275; c=relaxed/simple;
	bh=anrN0zLpzBz7q3TfjF12y0lddtJQudw6mk1PgbWWtic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GVoJhGLnIelnAloQSzMxw5Jj4N6uX19qiQ1I2/8lj9a45JY5UwZXMFm0IoX05iwgAn309aZXotMTXmOci7tcAaLb57Ucyce7kXe77RSDqU+NZ6hgzyp/q/KUROVnVx8yc1Mg046mj77+AqbsXGr7jNBMZfS0OK+tDF7jST6nBzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P9RWN7JH; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P9RWN7JH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784213265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Jx2YwXw/QAbkCCIbkCHPqoi6uSpH7Yd6cSf32MCglWU=;
	b=P9RWN7JHGe2DhTw97Zz1QWc4GSBE41TsfC480MeFjX6xlucW+IRUcjGKwBhXvqfMJCyJKM
	hZDY8YVRf2b68OmgeWAf+Hinw9IsbRlGGMEZ7b+osLgkelu9CkVRSKEhHoPtWavLuhK7gJ
	OePG4FCH4WswiHj0WH0Si7QnbdUWRQc=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH] smb/client: fix unaligned fallocate emulation with O_DIRECT
Date: Thu, 16 Jul 2026 22:47:31 +0800
Message-ID: <20260716144731.729559-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Commit 4a7d2729dc99 ("smb: client: fix atomic open with O_DIRECT & O_SYNC")
made atomic O_DIRECT opens correctly use CREATE_NO_BUFFER. This exposed
an issue in the fallocate emulation added by
commit 966a3cb7c7db ("cifs: improve fallocate emulation"), which may
reuse the handle for unaligned zero writes.

Windows requires the offset and length of writes on an
unbuffered handle to be sector aligned, and rejects these writes
with STATUS_INVALID_PARAMETER, causing xfstests generic/760 to fail.

For SMB3.02 and later, fix this by keeping the handle buffered and using
READ_UNBUFFERED or WRITE_UNBUFFERED only for actual direct I/O requests.
Determine this from the netfs request origin rather than the file flags,
since mmap writeback on an O_DIRECT file is still buffered.

For older dialects, retain CREATE_NO_BUFFER since they do not support
per-I/O unbuffered flags.

With this change, xfstests generic/760 passes against Windows with SMB3.02
or later, while Windows SMB3.0 remains affected.

Fixes: 4a7d2729dc99 ("smb: client: fix atomic open with O_DIRECT & O_SYNC")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsglob.h | 13 +++++++++++--
 fs/smb/client/dir.c      |  2 +-
 fs/smb/client/file.c     |  4 ++--
 fs/smb/client/smb2pdu.c  |  6 ++++++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 08e94633a9c1..2e43dbd564de 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2374,17 +2374,26 @@ static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
 		WRITE_ONCE(cinode->oplock, 0);
 }
 
+static inline bool
+cifs_server_supports_per_io_unbuffered(const struct TCP_Server_Info *server)
+{
+	return server && server->dialect >= SMB302_PROT_ID;
+}
+
 static inline bool cifs_forced_shutdown(const struct cifs_sb_info *sbi)
 {
 	return cifs_sb_flags(sbi) & CIFS_MOUNT_SHUTDOWN;
 }
 
-static inline int cifs_open_create_options(unsigned int oflags, int opts)
+static inline int
+cifs_open_create_options(const struct TCP_Server_Info *server,
+			 unsigned int oflags, int opts)
 {
 	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
 	if (oflags & O_SYNC)
 		opts |= CREATE_WRITE_THROUGH;
-	if (oflags & O_DIRECT)
+	if ((oflags & O_DIRECT) &&
+	    !cifs_server_supports_per_io_unbuffered(server))
 		opts |= CREATE_NO_BUFFER;
 	if (oflags & O_TMPFILE)
 		opts |= CREATE_DELETE_ON_CLOSE;
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88a4a1787ff0..72b1b13c560e 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -336,7 +336,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 	if (!server->ops->open)
 		return -EOPNOTSUPP;
 
-	create_options |= cifs_open_create_options(oflags, create_options);
+	create_options |= cifs_open_create_options(server, oflags, create_options);
 	/*
 	 * if we're not using unix extensions, see if we need to set
 	 * ATTR_READONLY on the create call
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 968740e7c9c3..d4d23a313869 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -597,7 +597,7 @@ static int cifs_nt_open(const char *full_path, struct inode *inode, struct cifs_
 
 	disposition = cifs_get_disposition(f_flags);
 	/* BB pass O_SYNC flag through on file attributes .. BB */
-	create_options |= cifs_open_create_options(f_flags, create_options);
+	create_options |= cifs_open_create_options(server, f_flags, create_options);
 
 retry_open:
 	oparms = (struct cifs_open_parms) {
@@ -1321,7 +1321,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		rdwr_for_fscache = 1;
 
 	desired_access = cifs_convert_flags(cfile->f_flags, rdwr_for_fscache);
-	create_options |= cifs_open_create_options(cfile->f_flags,
+	create_options |= cifs_open_create_options(server, cfile->f_flags,
 						   create_options);
 
 	if (server->ops->get_lease_key)
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4ce165e40657..bbbcb5b9bdf2 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4578,6 +4578,9 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	req->MinimumCount = 0;
 	req->Length = cpu_to_le32(io_parms->length);
 	req->Offset = cpu_to_le64(io_parms->offset);
+	if (rdata && rdata->rreq->origin == NETFS_DIO_READ &&
+	    cifs_server_supports_per_io_unbuffered(server))
+		req->Flags = SMB2_READFLAG_READ_UNBUFFERED;
 
 	trace_smb3_read_enter(rdata ? rdata->rreq->debug_id : 0,
 			      rdata ? rdata->subreq.debug_index : 0,
@@ -5170,6 +5173,9 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	req->DataOffset = cpu_to_le16(
 				offsetof(struct smb2_write_req, Buffer));
 	req->RemainingBytes = 0;
+	if (wdata->rreq->origin == NETFS_DIO_WRITE &&
+	    cifs_server_supports_per_io_unbuffered(server))
+		req->Flags = cpu_to_le32(SMB2_WRITEFLAG_WRITE_UNBUFFERED);
 
 	trace_smb3_write_enter(wdata->rreq->debug_id,
 			       wdata->subreq.debug_index,
-- 
2.43.0

