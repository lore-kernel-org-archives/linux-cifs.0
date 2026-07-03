Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E615360EF6
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 05:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783056857; cv=none; b=tt2Mi7xOdnriLtT8wNJmzCawq17n9iGoHbnYnGCj0hDYxKSHbJ30knDcRXHZyLhYKTADWa/x+l/Nujgqdu6QaZ3xkmKkeKEu2BeONaxoDi0Jp1+pStSo4zOBkOtoi3/c5al6cEPVpXNR4N0ESmUPNFF974xXQrUsUvCHWCBpuYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783056857; c=relaxed/simple;
	bh=nAoQuXaEWPDMKkchero+s6ooWY88LIHmKoCd8Lqdjf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojrFPXpRGLggg2fBcQGk982KIQPu7ZmlXJCPC2fyYeTJUMXGc4sMfnR+HgdO+PRcqXHmV5v1+PbW1OtItjTVnH9F168fhjyYSqG3vyBDqS6SI19dKVJ9x0t3bCe0TSDIydBJUFMkQ6Lx60GJOUI0A3WW4I/o0fQ+TlGCn+YKpVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dpQxKMBp; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dpQxKMBp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783056850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XyNuScMABbWX/1uYxAb28EZfdbVQ1YR4LPwnq9ZzWfo=;
	b=dpQxKMBpg+sE5RBbGUTR9mImB520CGHfnk/uOeW3LpKZcinqhjlFRAInLfgf7N7deXbEUk
	YgKvt/+qzehj25z4RKxwKuCcqsH8FAgQkcP9LdIRO3oxoEF29KyH7k2yhSopwjj9f0nppi
	ycu2HcjPPPLAceLuyxq2t0l26mbynAM=
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
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v8 5/5] smb/client: refresh allocation after EOF-extending fallocate
Date: Fri,  3 Jul 2026 13:32:59 +0800
Message-ID: <20260703053300.913371-6-huiwen.he@linux.dev>
In-Reply-To: <20260703053300.913371-1-huiwen.he@linux.dev>
References: <20260703053300.913371-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Before this change, xfstests generic/496 was not supported on ksmbd:

        generic/496 ... [not run] fallocated swap not supported here

ksmbd handles SetEOF as truncate, so EOF extension alone does not
allocate backing blocks. A fallocated swapfile can therefore still
look sparse to swapon.

Request allocation for EOF-extending fallocate ranges that can be
represented by FILE_ALLOCATION_INFORMATION, and refresh the allocation
state afterwards.

With this change, xfstests generic/496 and generic/701 pass on ksmbd.

However, Samba "strict allocate = no" now exposes the real generic/701
failure: the old pass came from inflated local i_blocks, not from
server allocation. generic/213 also fails in that case because an
oversized allocation request may not return ENOSPC.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c   | 43 ++++++++++++++++++++++++++++++++++++---
 fs/smb/client/smb2pdu.c   | 19 +++++++++++++++++
 fs/smb/client/smb2proto.h |  3 +++
 fs/smb/common/fscc.h      |  5 +++++
 fs/smb/server/smb2pdu.h   |  4 ----
 5 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 21628606a721..75eaf0105716 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3788,12 +3788,49 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
 		new_eof = off + len;
+
+		qrc = SMB2_query_info(xid, tcon,
+				      cfile->fid.persistent_fid,
+				      cfile->fid.volatile_fid, &file_inf);
+		if (qrc == 0)
+			asize = le64_to_cpu(file_inf.AllocationSize);
+
+		/*
+		 * FILE_ALLOCATION_INFORMATION can only describe allocation up to
+		 * new_eof. Some servers may accept it without allocating blocks,
+		 * so refresh AllocationSize before updating i_blocks.
+		 */
+		if (off == 0 || off == old_eof) {
+			if (qrc || asize < new_eof) {
+				rc = SMB2_set_allocation(xid, tcon,
+							 cfile->fid.persistent_fid,
+							 cfile->fid.volatile_fid,
+							 cfile->pid, new_eof);
+				if (rc)
+					goto out;
+			}
+		}
+
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_eof);
-		if (rc == 0) {
-			netfs_resize_file(&cifsi->netfs, new_eof, true);
-			cifs_setsize(inode, new_eof);
+		if (rc)
+			goto out;
+
+		netfs_resize_file(&cifsi->netfs, new_eof, true);
+		cifs_setsize(inode, new_eof);
+
+		qrc = SMB2_query_info(xid, tcon,
+				      cfile->fid.persistent_fid,
+				      cfile->fid.volatile_fid, &file_inf);
+		spin_lock(&inode->i_lock);
+		if (qrc == 0) {
+			asize = le64_to_cpu(file_inf.AllocationSize);
+			if (asize >= new_eof)
+				inode->i_blocks = CIFS_INO_BLOCKS(asize);
+		} else {
+			cifsi->time = 0;
 		}
+		spin_unlock(&inode->i_lock);
 		goto out;
 	}
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d058584b8f05..1374bbae627f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5947,6 +5947,25 @@ SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 			0, 1, &data, &size);
 }
 
+int
+SMB2_set_allocation(const unsigned int xid, struct cifs_tcon *tcon,
+		    u64 persistent_fid, u64 volatile_fid, u32 pid,
+		    loff_t allocation_size)
+{
+	struct smb2_file_alloc_info info;
+	void *data;
+	unsigned int size;
+
+	info.AllocationSize = cpu_to_le64(allocation_size);
+
+	data = &info;
+	size = sizeof(struct smb2_file_alloc_info);
+
+	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
+			pid, FILE_ALLOCATION_INFORMATION, SMB2_O_INFO_FILE,
+			0, 1, &data, &size);
+}
+
 int
 SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 		u64 persistent_fid, u64 volatile_fid,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 78a4e1c340f9..16a02c1eb0a1 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -204,6 +204,9 @@ void SMB2_query_directory_free(struct smb_rqst *rqst);
 int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 		 u64 persistent_fid, u64 volatile_fid, u32 pid,
 		 loff_t new_eof);
+int SMB2_set_allocation(const unsigned int xid, struct cifs_tcon *tcon,
+			u64 persistent_fid, u64 volatile_fid, u32 pid,
+			loff_t allocation_size);
 int SMB2_set_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		       struct smb_rqst *rqst, u64 persistent_fid,
 		       u64 volatile_fid, u32 pid, u8 info_class, u8 info_type,
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index 859849a42fec..941db5a95564 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -283,6 +283,11 @@ struct smb2_file_eof_info { /* encoding of request for level 10 */
 	__le64 EndOfFile; /* new end of file value */
 } __packed; /* level 20 Set */
 
+/* See MS-FSCC 2.4.4 */
+struct smb2_file_alloc_info { /* encoding of request for level 19 */
+	__le64 AllocationSize;
+} __packed;
+
 /* See MS-FSCC 2.4.15 */
 typedef struct {
 	__le32 NextEntryOffset;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index c2512dbcdec8..aa06c8c905f1 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -212,10 +212,6 @@ struct smb2_file_ea_info {
 	__le32 EASize;
 } __packed;
 
-struct smb2_file_alloc_info {
-	__le64 AllocationSize;
-} __packed;
-
 struct smb2_file_disposition_info {
 	__u8 DeletePending;
 } __packed;
-- 
2.43.0

