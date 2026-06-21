Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59A33559F2
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046143; cv=none; b=gxNpWVb9tScN0tfAikj9D/uy+NP1cZu8Oa5+mVPqfMvW1bmX4D2NmjjlzZOZQII8l1FneNz66cPs7L85ISNxrAhJTOu5u93tGngfLNuZo5yX8vnBHjjR2E+Ipq/rTNUv2D/Vx5dulg03+9nUZViibLUWbSHDNCYn2HrKm6vLyt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046143; c=relaxed/simple;
	bh=CMSo736uQ6T/cVUVx03g5UzFjA7X8JpEtO1YsNbqfH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LEkNIA2bCgcCV4T3CefhxAcp7AQ/U2AFQqQjLDCUAtB0TozrW5Df9ogtMiKuMjpNaXQrmqZkrXXIWMY/2TPfsxT6jNX1i4FqUWt6Vxg2hROaowLD+6Au/CQkkxO0y2PsAIU5qNjlEhsKcoa7XqkTR8X9f90yGg4QwB9N62kSudk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdM/m/9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdM/m/9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B2C1F00A3A;
	Sun, 21 Jun 2026 12:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046142;
	bh=XoM7J/OWgkB9FS9tiUnLHsSxVT+H7R2/LB0eIOKPjuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdM/m/9NO4hmSFFxKNMEpQfRCt8ACZ0ODZAs1i8q/Xfot/uOrPaVnEqxBRAabLsud
	 pu+303l1YBHKkwYBMsiR5orh8EFk9FgzpLoKr6lhRO7mRq7KfWCwUligFdb4+vaZ0v
	 EaZhR575yDdzlmK1wCBJVp1elajelTbj/18VjPxXWlRt8z9rKaE1SZo6zGLKbTgjKu
	 OXVNMQNkHuK+/Uei+IWQhJQmcM1JlOe46Sa28z+TABTOZMUeAaOKCqfg4n8ezpFvS7
	 xLa4lBygmmxyNHOyrNXL7cF8ReUzoapllE0wNiIReIG1v3i7l+0QyuBujNVrgfjSch
	 GS4G+epTAHPGg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 06/29] ksmbd: preserve open change time across rename
Date: Sun, 21 Jun 2026 21:48:21 +0900
Message-Id: <20260621124844.6235-6-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inode ctime is updated when a file is renamed. ksmbd returned that
ctime directly as SMB2 ChangeTime for handle-based query information.
This makes ChangeTime change after a rename through an already-open
handle, while Windows keeps the handle's ChangeTime stable for this
case.

Store the SMB ChangeTime in struct ksmbd_file when the handle is opened
and use that value for create, close, and handle-based query information
responses.  If a client explicitly sets FILE_BASIC_INFORMATION
ChangeTime, update the stored value as well.

This fixes smbtorture smb2.rename.simple_modtime, which expects
ChangeTime and LastWriteTime to remain unchanged after renaming an
already-open file.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 23 ++++++++++-------------
 fs/smb/server/vfs_cache.h |  1 +
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a21760394637..f2ba52c7e325 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3783,6 +3783,7 @@ int smb2_open(struct ksmbd_work *work)
 		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
 	else
 		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
+	fp->change_time = ksmbd_UnixTimeToNT(stat.ctime);
 	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
 		fp->f_ci->m_fattr =
 			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
@@ -3832,8 +3833,7 @@ int smb2_open(struct ksmbd_work *work)
 	rsp->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	rsp->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	rsp->ChangeTime = cpu_to_le64(time);
+	rsp->ChangeTime = cpu_to_le64(fp->change_time);
 	rsp->AllocationSize = S_ISDIR(stat.mode) ? 0 :
 		cpu_to_le64(stat.blocks << 9);
 	rsp->EndofFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
@@ -5102,8 +5102,7 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	basic_info->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	basic_info->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	basic_info->ChangeTime = cpu_to_le64(time);
+	basic_info->ChangeTime = cpu_to_le64(fp->change_time);
 	basic_info->Attributes = fp->f_ci->m_fattr;
 	basic_info->Pad = 0;
 	rsp->OutputBufferLength =
@@ -5205,8 +5204,7 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	file_info->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	file_info->ChangeTime = cpu_to_le64(time);
+	file_info->ChangeTime = cpu_to_le64(fp->change_time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->Pad1 = 0;
 	if (ksmbd_stream_fd(fp) == false) {
@@ -5415,8 +5413,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	file_info->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	file_info->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	file_info->ChangeTime = cpu_to_le64(time);
+	file_info->ChangeTime = cpu_to_le64(fp->change_time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	if (ksmbd_stream_fd(fp) == false) {
 		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
@@ -5547,8 +5544,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	file_info->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(stat.ctime);
-	file_info->ChangeTime = cpu_to_le64(time);
+	file_info->ChangeTime = cpu_to_le64(fp->change_time);
 	file_info->DosAttributes = fp->f_ci->m_fattr;
 	file_info->Inode = cpu_to_le64(stat.ino);
 	if (ksmbd_stream_fd(fp) == false) {
@@ -6271,8 +6267,7 @@ int smb2_close(struct ksmbd_work *work)
 		rsp->LastAccessTime = cpu_to_le64(time);
 		time = ksmbd_UnixTimeToNT(stat.mtime);
 		rsp->LastWriteTime = cpu_to_le64(time);
-		time = ksmbd_UnixTimeToNT(stat.ctime);
-		rsp->ChangeTime = cpu_to_le64(time);
+		rsp->ChangeTime = cpu_to_le64(fp->change_time);
 		ksmbd_fd_put(work, fp);
 	} else {
 		rsp->Flags = 0;
@@ -6485,9 +6480,11 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		attrs.ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
 	}
 
-	if (file_info->ChangeTime)
+	if (file_info->ChangeTime) {
+		fp->change_time = le64_to_cpu(file_info->ChangeTime);
 		inode_set_ctime_to_ts(inode,
 				ksmbd_NTtimeToUnix(file_info->ChangeTime));
+	}
 
 	if (file_info->LastWriteTime) {
 		attrs.ia_mtime = ksmbd_NTtimeToUnix(file_info->LastWriteTime);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index ca391d597e2e..8c456484cab2 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -97,6 +97,7 @@ struct ksmbd_file {
 	__le32				coption;
 	__le32				cdoption;
 	__u64				create_time;
+	__u64				change_time;
 	__u64				itime;
 
 	bool				is_nt_open;
-- 
2.25.1

