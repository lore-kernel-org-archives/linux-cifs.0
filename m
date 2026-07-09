Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C3A371868
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 02:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783565909; cv=none; b=JgfLRSJWL7HKsTyvEYfsXLhqD7S/VFwvhK+cry8JCOj+1lWhqTOf82wOzaqipOW3ragUhAyxuHdbGwkeGezG9geo2SixfUZPFgAogxmnppVteXwakoYNaNesPTwjsNRjPykVx81uMLpwjpBRyMA3t7WSQcxfLvd9iVgZlVcrlIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783565909; c=relaxed/simple;
	bh=7ZBsPTnwyuC25yr17MI9pfb8NcpZ7wUJmd0zIAFYZec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKbCxXUZyu2sHmDvu05thluoWosOM/ovSgGuFVvjbGHVv6D6mKWgZ2JquU7U9P/pDj4/9ZUaBO3uS3rdMjSstwJc176tDY2R00PoWNQfN6vAUAkrP587Wxxb330PFgYX34nW62oJA555iDZIkQGZlg7X+2DWvf1QNfSb1C1kyOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Xqom8OVu; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Xqom8OVu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783565905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9jZAn5y7iORNr9urWvEn7gvNt2zWHHSKNEUNZgpxbQc=;
	b=Xqom8OVuEZ+bQ7ygakDc7u5NRJOypkwFTv9Q7C9G+X+6kKGZQH/S0VttOIYq9iwAsGdyBD
	IUCZF/d5ygxhj/eAoPnkyRJHaHQ7JSsYqD3N9VGZ6RRyxqNY/JgPl3C4Ny1oXOEsJkemVQ
	2XH+7gmg5MSAJ2ky9w24cfiaYvEpyRAuMbBSZnoIeZHqUABrEQDIJa7tFHbljF0mwh3L7N
	/bjpGsWgOo+4cf4gGlV6j3+Y7/fAglMzQPvvjhYYM4tqQwfEWefmGJMdX/9BlhuX2TQkkO
	U+Sp2OSaH1uPeQAxFjx5trIrMfLXTkclAPnm2hbB++6Zh99VUwW7gkzpO58EHA==
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
Subject: [PATCH v5 3/4] smb/client: zero-initialize stack-allocated cifs_open_info_data
Date: Thu,  9 Jul 2026 10:57:02 +0800
Message-ID: <20260709025703.3715326-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260709025703.3715326-1-chenxiaosong@chenxiaosong.com>
References: <20260709025703.3715326-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Stack-allocated cifs_open_info_data may contain random data.
This can make some fields have wrong value if they are not set later.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/link.c    | 2 +-
 fs/smb/client/smb1ops.c | 2 +-
 fs/smb/client/smb2ops.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index b60dc407815d..8d5d6aca742a 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -234,7 +234,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index d34b3d99f6ed..f72879af12c9 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -949,7 +949,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	struct cifs_open_parms oparms;
 	struct cifsFileInfo *open_file;
 	FILE_BASIC_INFO new_buf;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 	__le64 write_time = buf->LastWriteTime;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1f5dc1d9897f..b6aadea6b780 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5317,7 +5317,7 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
-	struct cifs_open_info_data idata;
+	struct cifs_open_info_data idata = {};
 	struct cifs_io_parms io_parms = {};
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_fid fid;
-- 
2.54.0

