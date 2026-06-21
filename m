Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E6672621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046165; cv=none; b=BS30YascB3ZyVHeY+DDsCJy0yho6OEVSQprWZgspJCTizhEfv+Nwg1Wix7pMcjMN3wAz22ahofUH8CdTxviqmcA4wf2yEXgsVWEiXPdfrWmBiyiFHzXFZQFIDYP7Y6e+FkWoVtO4GwCe9ncVvpIt+19tuODomU/xJzlAWYzRtAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046165; c=relaxed/simple;
	bh=xynEFuCgj0fjcdWz/XXS35DLhs2t7UHik5NLZFfDdRk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R/vadFH2/AA6je51SUMMsiEeEkga/fLmuqQVQ3ZJT2SwoE/EEcrfo+LZfGIlgobs9Pyg9UnD0hFMnwiJFoNCremr+yGqwI+CpZArRIiqe4WysgRdGr/1gI/uTMJbMQkx7lBvecm1q9y+JvhJ3p9vVp584zb7sUXy3Lb9V+yos+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CVQiFqaE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CVQiFqaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E851F00A3A;
	Sun, 21 Jun 2026 12:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046164;
	bh=/6BaXj40Md8VIUNyH5DGuZ9cuY+GMnwix+6kdVwlfZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVQiFqaEAz3e4ctLdmLfLpfLtgKOTm9vxsKIoCUdBdNlwDIPDL3BhyUWiNdJdYM88
	 AYb9OXfI1k0kSp07NVq+aBuRPUks3T48l3tuuwRVFH5e/ttP6psKbQSGBP11fENty/
	 2R8Mhc+R8WjS5kSaYnuu1LfidEJ2ic2spwcKm/NsASPTlTtNCZDIo3hIhBepY4ueFY
	 dIKzmFrPIusFkf+NJXQESgAYeS38cqXsFOY/1KIQiy+HRM8piswrX2Vh0SeitnJwCt
	 mA4laHhDDiMyKIgLKGG9wJ8KL4lTgML+R4x/1Khll/v1D+sYq771c4+vRcSOz1PP/x
	 e2rJZosDzL4gA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 17/29] ksmbd: return requested create allocation size
Date: Sun, 21 Jun 2026 21:48:32 +0900
Message-Id: <20260621124844.6235-17-linkinjeon@kernel.org>
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

smb2.create.blob sends an SMB2_CREATE_ALLOCATION_SIZE create context with
a 1MiB allocation size and expects the create response AllocationSize field
to match the requested size.  smb2.create.open additionally compares the
AllocationSize returned in the CREATE response with the AllocationSize
returned by FILE_ALL_INFORMATION on the same handle.

ksmbd applies the allocation with fallocate(), but then fills both the
create response and handle-based information from stat.blocks << 9.  On
filesystems such as ext4 this can include filesystem allocation rounding
and metadata effects, causing a response larger than the SMB2 allocation
size context and a disagreement between the two queries.

Remember the requested allocation size while processing the create context,
store the reported allocation size in struct ksmbd_file, and use it for
both the create response and handle-based allocation size responses. Update
the stored value when FILE_ALLOCATION_INFORMATION changes it, and fall back
to stat.blocks << 9 when no allocation size context was provided.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 34 +++++++++++++++++++++++-----------
 fs/smb/server/vfs_cache.h |  1 +
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d6001cdce085..cca04bf84b81 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3133,7 +3133,7 @@ int smb2_open(struct ksmbd_work *work)
 	char *stream_name = NULL;
 	bool file_present = false, created = false, already_permitted = false;
 	int share_ret, need_truncate = 0;
-	u64 time;
+	u64 time, alloc_size = 0;
 	umode_t posix_mode = 0;
 	__le32 daccess, maximal_access = 0;
 	int iov_len = 0;
@@ -3826,7 +3826,6 @@ int smb2_open(struct ksmbd_work *work)
 			rc = PTR_ERR(az_req);
 			goto err_out1;
 		} else if (az_req) {
-			loff_t alloc_size;
 			int err;
 
 			if (le16_to_cpu(az_req->ccontext.DataOffset) +
@@ -3876,6 +3875,8 @@ int smb2_open(struct ksmbd_work *work)
 	else
 		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
 	fp->change_time = ksmbd_UnixTimeToNT(stat.ctime);
+	fp->allocation_size = S_ISDIR(stat.mode) ? 0 :
+		(alloc_size ?: stat.blocks << 9);
 	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
 		fp->f_ci->m_fattr =
 			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
@@ -3926,8 +3927,19 @@ int smb2_open(struct ksmbd_work *work)
 	time = ksmbd_UnixTimeToNT(stat.mtime);
 	rsp->LastWriteTime = cpu_to_le64(time);
 	rsp->ChangeTime = cpu_to_le64(fp->change_time);
-	rsp->AllocationSize = S_ISDIR(stat.mode) ? 0 :
-		cpu_to_le64(stat.blocks << 9);
+	/*
+	 * The cached allocation size hides filesystem rounding for the
+	 * requested allocation, but it can go stale when the file grows past
+	 * it via writes (e.g. across a durable reconnect). Refresh it once the
+	 * file exceeds the cached value, rounding the end of file up to the
+	 * volume allocation unit (the filesystem block size, matching the
+	 * SectorsPerAllocationUnit/BytesPerSector ksmbd advertises) rather than
+	 * using the raw on-disk block count, which can include filesystem
+	 * preallocation and metadata rounding.
+	 */
+	if (!S_ISDIR(stat.mode) && stat.size > fp->allocation_size)
+		fp->allocation_size = roundup(stat.size, stat.blksize);
+	rsp->AllocationSize = cpu_to_le64(fp->allocation_size);
 	rsp->EndofFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	rsp->FileAttributes = fp->f_ci->m_fattr;
 
@@ -5236,7 +5248,7 @@ static int get_file_standard_info(struct smb2_query_info_rsp *rsp,
 	delete_pending = ksmbd_inode_pending_delete(fp);
 
 	if (ksmbd_stream_fd(fp) == false) {
-		sinfo->AllocationSize = cpu_to_le64(stat.blocks << 9);
+		sinfo->AllocationSize = cpu_to_le64(fp->allocation_size);
 		sinfo->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
 		sinfo->AllocationSize = cpu_to_le64(fp->stream.size);
@@ -5317,8 +5329,7 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->Pad1 = 0;
 	if (ksmbd_stream_fd(fp) == false) {
-		file_info->AllocationSize =
-			cpu_to_le64(stat.blocks << 9);
+		file_info->AllocationSize = cpu_to_le64(fp->allocation_size);
 		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
 		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
@@ -5525,7 +5536,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	file_info->ChangeTime = cpu_to_le64(fp->change_time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	if (ksmbd_stream_fd(fp) == false) {
-		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
+		file_info->AllocationSize = cpu_to_le64(fp->allocation_size);
 		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
 		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
@@ -5658,7 +5669,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->Inode = cpu_to_le64(stat.ino);
 	if (ksmbd_stream_fd(fp) == false) {
 		file_info->EndOfFile = cpu_to_le64(stat.size);
-		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
+		file_info->AllocationSize = cpu_to_le64(fp->allocation_size);
 	} else {
 		file_info->EndOfFile = cpu_to_le64(fp->stream.size);
 		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
@@ -6373,8 +6384,7 @@ int smb2_close(struct ksmbd_work *work)
 		}
 
 		rsp->Flags = SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB;
-		rsp->AllocationSize = S_ISDIR(stat.mode) ? 0 :
-			cpu_to_le64(stat.blocks << 9);
+		rsp->AllocationSize = cpu_to_le64(fp->allocation_size);
 		rsp->EndOfFile = cpu_to_le64(stat.size);
 		rsp->Attributes = fp->f_ci->m_fattr;
 		rsp->CreationTime = cpu_to_le64(fp->create_time);
@@ -6707,6 +6717,8 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 		if (size < alloc_blks * 512)
 			i_size_write(inode, size);
 	}
+
+	fp->allocation_size = le64_to_cpu(file_alloc_info->AllocationSize);
 	return 0;
 }
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 8aa87843025f..f85021c11d6e 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -98,6 +98,7 @@ struct ksmbd_file {
 	__le32				cdoption;
 	__u64				create_time;
 	__u64				change_time;
+	__u64				allocation_size;
 	__u64				itime;
 
 	bool				is_nt_open;
-- 
2.25.1

