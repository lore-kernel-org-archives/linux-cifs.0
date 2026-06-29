Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E3B42EED9
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 15:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782746853; cv=none; b=kNKS2b8n3zEzJ/QTuSaWp0NEHDyTuXmnXPYApI3viLwMC+vwN875n5RHo9j/Oo/wwdizxj6GMzmM4Kx0RGSWng1QKG0nWb4TBZ2RDIpp9oW4ldD4gdb+wOgi5DHBbXcHjK0YIh4p5/T6Dlp3Orq8g1tw0h6QtiI/GPZI3ejxnyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782746853; c=relaxed/simple;
	bh=aDAWzkEWBX9i42wg5Gyc+k2CjUdekkDyUzqwn3yopM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YO4C0ZjsLwggsONExgFpEpogA9JIsW26TeX6Zr6mz/stL/22OzTruCxa8SANBWw4seyz1i8+jzAOjwXOJl6iDeuESCGagNTMtcp84yF1ex//oyeEAgdreM0/eaQ1nztrB8EMxf9YaFViajwz8tnkq9j03bwYRTZc066Qp02ryFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=OcNDgo83; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="OcNDgo83"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782746846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VAdiXe6qb5mfIdVeIr8WKKXs6IbXFDAza+fvGqjPyj0=;
	b=OcNDgo83Pmg7hfp3aEglIsblc8XKJtbqK9on0J2zuC7qwd/mjMsFM7uUNr9hhryHBkuxJu
	3Svq3WZMoTZj5FbC4x8az+FN7JqmUftQNer9C6zYud7s3qwEqn8SJfoL5nUE+YI28UQxrE
	5IzD5tAinLavTuSzNKVCRC/Ki6ALIjDCu09O9akd0pOx8EfWMVb/X+a0c/I6Rfauh9LtXg
	0iuF9TuFsWBIKYwzs8G5oAL0yiINqi7TDAecpUnO4FZgNdBYlNbE5eYM+BTxK/FK8B6A9g
	cx1LWO9CNZk2v3s1hhos0rKeEPVxobsc6xFEToK42pN75VwpoKE+WdBVWGB8zQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/client: fix incorrect nlink returned by fstat()
Date: Mon, 29 Jun 2026 15:26:59 +0000
Message-ID: <20260629152659.703943-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. mount -t cifs //${server_ip}/export /mnt
  2. touch /mnt/file1; ln /mnt/file1 /mnt/file2; ln /mnt/file1 /mnt/file3
  3. C program: int fd = open("/mnt/file1", O_RDONLY);
  4. C program: struct stat stbuf; fstat(fd, &stbuf);
                stbuf.st_nlink is always 1, should be 3

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d058584b8f05..70b3beb96aff 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3371,15 +3371,19 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 #endif /* CIFS_DEBUG2 */
 
 	if (buf) {
-		buf->CreationTime = rsp->CreationTime;
-		buf->LastAccessTime = rsp->LastAccessTime;
-		buf->LastWriteTime = rsp->LastWriteTime;
-		buf->ChangeTime = rsp->ChangeTime;
-		buf->AllocationSize = rsp->AllocationSize;
-		buf->EndOfFile = rsp->EndofFile;
-		buf->Attributes = rsp->FileAttributes;
-		buf->NumberOfLinks = cpu_to_le32(1);
-		buf->DeletePending = 0; /* successful open = not delete pending */
+		int qrc = SMB2_query_info(xid, tcon, oparms->fid->persistent_fid,
+					  oparms->fid->volatile_fid, buf);
+		if (qrc) {
+			buf->CreationTime = rsp->CreationTime;
+			buf->LastAccessTime = rsp->LastAccessTime;
+			buf->LastWriteTime = rsp->LastWriteTime;
+			buf->ChangeTime = rsp->ChangeTime;
+			buf->AllocationSize = rsp->AllocationSize;
+			buf->EndOfFile = rsp->EndofFile;
+			buf->Attributes = rsp->FileAttributes;
+			buf->NumberOfLinks = cpu_to_le32(1);
+			buf->DeletePending = 0; /* successful open = not delete pending */
+		}
 	}
 
 
-- 
2.54.0

