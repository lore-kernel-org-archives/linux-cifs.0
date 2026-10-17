Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A8920D4FC
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199089; cv=none; b=EzpTY9kVP9GvmOQ0xgTjjR45vfo6dSYBawGrXRcu3tlzATWR2lu+DE0qa3taIyfW1Uoeg4lRIpSsZSMFMRv1i+3VQh1jnSp+/3izMGuY2wWRY7LaBgNhJQFXHmNZ/oPhyspOhwHBk98Ka2ib4WXLAepRe8xDgxCBlN7c9ZosF9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199089; c=relaxed/simple;
	bh=rAm0cW2jHdDmevkEbf15gl4ibZHf/kb+5GPfK7VN47E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tD7Y9yk2wHCh6PmVqxeOanRF8GbTIRhdDIiOYGa69Q9cCLVMj91GKTiS5PKUmFBELOMa28eud+Hz8F/B3FPnGSaME1Djn5RQsiGZajN54RxyleWwkK0aAKcYNg/zn3LI2PumpRu9YTNyyr3FgTF1+DDzAUmzDd5EhhepmaHrzLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWXzROo6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWXzROo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27771F000C4;
	Sat, 17 Oct 2026 01:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199088;
	bh=0f/J7FlEbxO5PINukdT0ew5J73HzZTK/IKBiLyECw+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWXzROo63ISmd1j+y7j70HOFcMbkoXSwnqzxFPqa4cmSnCbMowLgSDgtM1i4YTjGv
	 r7cuzDaNlgHuFAPlTPoJ3P/LxTbnd1XCiEQ2IsE0256+YtiK9jvEc7T0GSc8+ELk/r
	 YACXpXmXC+j1Xu7PT49MUWHxY0VI6VIL0Gt/byz1I6+xiSoyepejJjDrQg3fxCd1aM
	 kIXwfsF1u8MoNco6Oe7dXUpzB+noMUgTaj4sqsc9kkd2uclV6TFCGEjSpgNx9EJc4K
	 lWPD8Vzs3z/y39e1RycQSVnSMC1HNdF3PbLQMxsqdL+68k7Gbkt46PCIoazzZL763S
	 xngE80zpienLA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 21/22] ksmbd: query POSIX filesystem info through the open file
Date: Sat, 17 Oct 2026 10:03:43 +0900
Message-Id: <20261017010344.11478-21-linkinjeon@kernel.org>
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

POSIX filesystem queries use the share root for statfs and do not
validate the requested file handle. This can report the wrong filesystem
for files below a mount point within the share.

Require SMB3.1.1 POSIX extensions and a valid POSIX open. Resolve the
requested handle, including compound file IDs, and use its referenced
path for the filesystem query.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 73 ++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b3683e85cb31..6dfeb6078600 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7747,20 +7747,47 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_share_config *share = work->tcon->share_conf;
+	struct ksmbd_file *fp;
 	int fsinfoclass = 0;
 	struct kstatfs stfs;
 	struct path path;
 	int rc = 0, len;
 	unsigned int fixed_len = 0;
+	u64 id, pid;
 
-	if (!share->path)
-		return -EIO;
+	if (req->FileInfoClass == FS_POSIX_INFORMATION) {
+		if (conn->dialect != SMB311_PROT_ID ||
+		    !work->tcon->posix_extensions) {
+			rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
+			return -EOPNOTSUPP;
+		}
+		id = req->VolatileFileId;
+		pid = req->PersistentFileId;
+		if (work->next_smb2_rcv_hdr_off && !has_file_id(id)) {
+			id = work->compound_fid;
+			pid = work->compound_pfid;
+		}
+		fp = ksmbd_lookup_fd_slow(work, id, pid);
+		if (!fp)
+			return -ENOENT;
+		if (!fp->is_posix_ctxt) {
+			ksmbd_fd_put(work, fp);
+			rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
+			return -EOPNOTSUPP;
+		}
+		path = fp->filp->f_path;
+		path_get(&path);
+		ksmbd_fd_put(work, fp);
+	} else {
+		if (!share->path)
+			return -EIO;
 
-	scoped_with_init_fs()
-		rc = kern_path(share->path, LOOKUP_NO_SYMLINKS, &path);
-	if (rc) {
-		pr_err("cannot create vfs path\n");
-		return -EIO;
+		scoped_with_init_fs()
+			rc = kern_path(share->path, LOOKUP_NO_SYMLINKS, &path);
+		if (rc) {
+			pr_err("cannot create vfs path\n");
+			return -EIO;
+		}
 	}
 
 	rc = vfs_statfs(&path, &stfs);
@@ -7973,25 +8000,19 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	{
 		FILE_SYSTEM_POSIX_INFO *info;
 
-		if (!work->tcon->posix_extensions) {
-			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
-			path_put(&path);
-			return -EOPNOTSUPP;
-		} else {
-			info = (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffer);
-			info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);
-			info->BlockSize = cpu_to_le32(stfs.f_bsize);
-			info->TotalBlocks = cpu_to_le64(stfs.f_blocks);
-			info->BlocksAvail = cpu_to_le64(stfs.f_bfree);
-			info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
-			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
-			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
-			info->FileSysIdentifier =
-				cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
-					    (u32)stfs.f_fsid.val[0]);
-			rsp->OutputBufferLength = cpu_to_le32(56);
-			fixed_len = 56;
-		}
+		info = (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffer);
+		info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);
+		info->BlockSize = cpu_to_le32(stfs.f_bsize);
+		info->TotalBlocks = cpu_to_le64(stfs.f_blocks);
+		info->BlocksAvail = cpu_to_le64(stfs.f_bfree);
+		info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
+		info->TotalFileNodes = cpu_to_le64(stfs.f_files);
+		info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
+		info->FileSysIdentifier =
+			cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
+				    (u32)stfs.f_fsid.val[0]);
+		rsp->OutputBufferLength = cpu_to_le32(56);
+		fixed_len = 56;
 		break;
 	}
 	default:
-- 
2.25.1

