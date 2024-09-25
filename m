Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59642156222
	for <linux-cifs@vger.kernel.org>; Wed, 25 Sep 2024 09:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727255457; cv=none; b=c81DAjaW74O03ys/BhyxZW3IVM5T6ddiBQxxjFxxyhx1xctp5pfGDHTwXrBgkVOuW7IV5TWvULD7PNxnKYGpwjUuKKF85eG+ljdR69yrsKBnATMyI/e/haYtiacyrazkL5aqBFeVfQK2R+1KB7yBxgtBz+GeNgz4Qaid7hFnZDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727255457; c=relaxed/simple;
	bh=qPOG89odr6nDTu/Y0IRoN41sQE1eJDpORZJc6ao2/mM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qpxHIp34D+jpEBQGYtvQ/BjrRGvUoBhNSAc7jYmgLIaQuvYgP762sesuKZomrJZ2UiRj2WgM7WmvwEuxGKMBa11MN1SJ6R6B23u6BxZOox1dRO+Vhy2v/mUTYkyMS4E6rME/UG0Sw0StUXUcenSLZEM8EVcGDHfJNgQjV1JOYro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cLAfyS83; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cLAfyS83"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727255453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oNcOfjKU7tZbJlgaRWEUdhjUY7VzCvgYazdTewJBeUM=;
	b=cLAfyS83tgbMVyk6ddVbF2rKh47lmtTJCfz+5gcDdwzjDoHimv3u2jj2SireheVvE7JTHp
	YcRsPu3P1ZhH9xJWe3kS2Jl7ek9FZEWgVxV+yjmvC8s7Ut9cH0dmhJEu71Bj+MafntYTrR
	GdzoJTeSCgKbmjKsDDeNcXK9AzmHoHY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2] ksmbd: Annotate struct copychunk_ioctl_req with __counted_by_le()
Date: Wed, 25 Sep 2024 11:03:13 +0200
Message-ID: <20240925090313.22310-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the __counted_by_le compiler attribute to the flexible array member
Chunks to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Change the data type of the flexible array member Chunks from __u8[] to
struct srv_copychunk[] for ChunkCount to match the number of elements in
the Chunks array. (With __u8[], each srv_copychunk would occupy 24 array
entries and the __counted_by compiler attribute wouldn't be applicable.)

Use struct_size() to calculate the size of the copychunk_ioctl_req.

Read Chunks[0] after checking that ChunkCount is not 0.

Compile-tested only.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Change the data type of Chunks from __u8[] to struct srv_copychunk[]
  as suggested by Tom Talpey
- Use struct_size()
- Link to v1: https://lore.kernel.org/linux-kernel/20240924102243.239811-2-thorsten.blum@linux.dev/
---
 fs/smb/server/smb2pdu.c |  5 ++---
 fs/smb/server/smb2pdu.h | 14 +++++++-------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7121266daa02..62312c5e790e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7566,7 +7566,6 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	ci_rsp->TotalBytesWritten =
 		cpu_to_le32(ksmbd_server_side_copy_max_total_size());
 
-	chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
 	chunk_count = le32_to_cpu(ci_req->ChunkCount);
 	if (chunk_count == 0)
 		goto out;
@@ -7574,12 +7573,12 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 
 	/* verify the SRV_COPYCHUNK_COPY packet */
 	if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
-	    input_count < offsetof(struct copychunk_ioctl_req, Chunks) +
-	     chunk_count * sizeof(struct srv_copychunk)) {
+	    input_count < struct_size(ci_req, Chunks, chunk_count)) {
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		return -EINVAL;
 	}
 
+	chunks = &ci_req->Chunks[0];
 	for (i = 0; i < chunk_count; i++) {
 		if (le32_to_cpu(chunks[i].Length) == 0 ||
 		    le32_to_cpu(chunks[i].Length) > ksmbd_server_side_copy_max_chunk_size())
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 73aff20e22d0..649dacf7e8c4 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -190,13 +190,6 @@ struct resume_key_ioctl_rsp {
 	__u8 Context[4]; /* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
-struct copychunk_ioctl_req {
-	__le64 ResumeKey[3];
-	__le32 ChunkCount;
-	__le32 Reserved;
-	__u8 Chunks[]; /* array of srv_copychunk */
-} __packed;
-
 struct srv_copychunk {
 	__le64 SourceOffset;
 	__le64 TargetOffset;
@@ -204,6 +197,13 @@ struct srv_copychunk {
 	__le32 Reserved;
 } __packed;
 
+struct copychunk_ioctl_req {
+	__le64 ResumeKey[3];
+	__le32 ChunkCount;
+	__le32 Reserved;
+	struct srv_copychunk Chunks[] __counted_by_le(ChunkCount);
+} __packed;
+
 struct copychunk_ioctl_rsp {
 	__le32 ChunksWritten;
 	__le32 ChunkBytesWritten;
-- 
2.46.1

