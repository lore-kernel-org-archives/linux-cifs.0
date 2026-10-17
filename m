Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D882C87F
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199071; cv=none; b=BmHlqlnv2doMSqbtdpVYBBEPEGB6fkSK2qUNcrOy2zxn6DXGMM3pN/ndcHsBYWFsywdjIiqPOwmIoQrBAih+VImXZDxJVYB1q+jN0jfEbdOMTZJVDHzqsCPR0t3NPUXas3bSmg0Kb5gu6W+mrPsblMpamDTsSpfG3ZZ6I2mintE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199071; c=relaxed/simple;
	bh=gGuEhx/m8DwhroNBIElC3LHFM1cbIAe5UtBlOcFiXjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QZ83aworYoremPSm0sS4C3/drvzX0O/VVjkIemtuqpkbxoyZRHBoHlU0ZCqlNEfdMthVjMPohUvRFEZVaXQHpYNZUQZSmI673vBjRLqKWDeTqCqtucyQCmTIIsrC6kUkhaXsmusO+w4s11q0KnYGzW82s5krLbz5f+TPd10aF10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XyRMOpC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XyRMOpC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15FD1F000C4;
	Sat, 17 Oct 2026 01:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199070;
	bh=swX7paI9j0MAiqRNo0uGKOvEfK7Etper+B+XARQd6Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XyRMOpC2AehxmdERYyP0fctxeRa0LckjYW+SscMAJJ/F4dQTCcAGvTW7UlECpwT9n
	 Dbu3Zd9MFZBLbWwsNWxe4we0WK/5HuiyJNuHjvEGvMd9KrEO8H02JF0HF04l75Zvqb
	 Xp7GS1RVRzQb0/v+tghcgurAaVaLhPugTB4jWsU8KQDUfbRyqc1yhTyBz7rDtdU9zx
	 ND1eeIJm8nQ51ArepXAtLvMPLFAmDrQZZzpATKk3tCbj7QJlOcCEQp6M1T7bs+NzZt
	 36KYV88uPFYjtxLHIlUFgZYuRWAKtKarqZ8khneOGIL0cW3eikJPDCdf2T28usoShI
	 epEuDSUyUY19g==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 14/22] ksmbd: enforce POSIX append-only writes
Date: Sat, 17 Oct 2026 10:03:36 +0900
Message-Id: <20261017010344.11478-14-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

POSIX append-only opens do not set O_APPEND, and the SMB append sentinel
is rejected as a negative write offset.

Track append-only POSIX opens, set O_APPEND and require the U64_MAX
offset sentinel for their writes. Accept FILE_WRITE_DATA or
FILE_APPEND_DATA for WRITE requests, preserving ordinary SMB write
permissions. Use the POSIX append flag and offset check to prevent
POSIX append-only opens from overwriting existing data.

For synchronous writes, derive the fsync range from the completed write
position so append writes flush the range actually written.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 14 ++++++++++++--
 fs/smb/server/vfs.c       |  3 +--
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a1e553ddde46..396f10fb2a91 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4736,6 +4736,9 @@ int smb2_open(struct ksmbd_work *work)
 					    &may_flags,
 					    req->CreateOptions,
 					    file_present ? d_inode(path.dentry)->i_mode : 0);
+	if (posix_ctxt && (req->DesiredAccess & FILE_APPEND_DATA_LE) &&
+	    !(req->DesiredAccess & FILE_WRITE_DATA_LE))
+		open_flags |= O_APPEND;
 
 	if (!test_tree_conn_flag(tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 		if (open_flags & (O_CREAT | O_TRUNC)) {
@@ -4975,6 +4978,7 @@ int smb2_open(struct ksmbd_work *work)
 			FILE_WRITE_ATTRIBUTES_LE | FILE_SYNCHRONIZE_LE));
 
 	fp->is_posix_ctxt = posix_ctxt;
+	fp->posix_append = posix_ctxt && !!(open_flags & O_APPEND);
 
 	/* fp should be searchable through ksmbd_inode.m_fp_list
 	 * after daccess, saccess, attrib_only, and stream are
@@ -10223,6 +10227,7 @@ int smb2_write(struct ksmbd_work *work)
 	ssize_t nbytes;
 	char *data_buf;
 	bool writethrough = false, is_rdma_channel = false;
+	bool append_write;
 	bool async_interim = false;
 	bool chseq_err = false;
 	int err = 0;
@@ -10254,7 +10259,8 @@ int smb2_write(struct ksmbd_work *work)
 		return smb2_write_pipe(work);
 	}
 
-	offset = le64_to_cpu(req->Offset);
+	append_write = le64_to_cpu(req->Offset) == U64_MAX;
+	offset = append_write ? 0 : le64_to_cpu(req->Offset);
 	if (offset < 0) {
 		err = -EINVAL;
 		goto out;
@@ -10357,11 +10363,15 @@ int smb2_write(struct ksmbd_work *work)
 		goto out;
 	}
 
-	if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_READ_ATTRIBUTES_LE))) {
+	if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE))) {
 		pr_err("Not permitted to write : 0x%x\n", fp->daccess);
 		err = -EACCES;
 		goto out;
 	}
+	if (append_write != fp->posix_append) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	if (work->next_smb2_rcv_hdr_off && !req->hdr.NextCommand) {
 		err = setup_async_work(work, NULL, NULL);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 181d27f43f31..f917f6aeb84d 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -526,7 +526,6 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 		    ssize_t *written)
 {
 	struct file *filp;
-	loff_t	offset = *pos;
 	int err = 0;
 
 	if (work->conn->connection_type) {
@@ -573,7 +572,7 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 	*written = err;
 	err = 0;
 	if (sync) {
-		err = vfs_fsync_range(filp, offset, offset + *written, 0);
+		err = vfs_fsync_range(filp, *pos - *written, *pos, 0);
 		if (err < 0)
 			pr_err("fsync failed for filename = %pD, err = %d\n",
 			       fp->filp, err);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 1054002ec4c5..064a053b92b1 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -173,6 +173,7 @@ struct ksmbd_file {
 	bool				durable_replay_consumed;
 
 	bool                            is_posix_ctxt;
+	bool				posix_append;
 	struct durable_owner		owner;
 	__le16				channel_sequence;
 	unsigned int			outstanding_requests;
-- 
2.25.1

