Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7583C10A8
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 07:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787210166; cv=none; b=A7+iIva8CdPFDCPh8Hgfsg0COEI4+lKqLrIYNN3Qz6mKTKXkqDsZtYeoS63mwxkJIbtYAjudM5YkVAKH10sBkTplOQ36GAwcoEQ1pTpd5KvQfkRN45e6KF6c6qdC7059CIyIWEe7brEY6KPm+/1L+tk9KaURH+zqVS/sbsCvhxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787210166; c=relaxed/simple;
	bh=D9mqq6agSOYQ0eaVwBGh6Xa9bT4lViPNUIKGYdd53ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOWZfP1cG65Jrj8s3jbV7F2RQ0YS/geKFD2T8YWOnysYWTl4haaWem80h37l1Rc94KjQlEkDe9EgNq9lbDG5g6PoWaj/syMgiHJZSuSySDfZyBeOcrEsVVeKjuzdVwSZB/8adpfCrtoSSDyCDgHDJbt6M0h66mIMg+qESS+LbWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uHWJJM8/; arc=none smtp.client-ip=91.218.175.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uHWJJM8/"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D9mqq6agSOYQ0eaVwBGh6Xa9bT4lViPNUIKGYdd53ec=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787210162; v=1; x=1787814962;
 b=uHWJJM8/iOJPqpofkQV575zKSPhiq7u8Y6cK2Ky1WsZSPEvpufJIDbdh16IpvVrtzKl/UnTx
 q2xX0fFMOAcxuMkjZziJN8vdamOFUVIghZjs2DMy0WJi5ZFwl0PM7AmTpV+MEYyqwtsWIjF/Kak
 2SnQ+ZLUuzN0XPr2KxP51bEc=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from harry-WUJIE-Series.. (116.128.244.171)
	by smtp.migadu.com with ESMTPS id a69fd6dfd499454a;
	Thu, 20 Aug 2026 07:16:02 +0000
X-Mizu-Trace-ID: a69fd6dfd499454a
X-Migadu-Flow: FLOW_OUT
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
Subject: [PATCH v2 2/6] smb/client: validate new EOF for zero range
Date: Thu, 20 Aug 2026 15:15:22 +0800
Message-ID: <20260820071526.826926-3-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820071526.826926-1-huiwen.he@linux.dev>
References: <20260820071526.826926-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

When FALLOC_FL_ZERO_RANGE is used without FALLOC_FL_KEEP_SIZE,
smb3_zero_range() may extend EOF without checking RLIMIT_FSIZE, allowing
the file to grow beyond the caller's file-size limit.

Fix this by calling inode_newsize_ok() before sending the zero-range
request when the operation would extend EOF.

Reproducer, using a file on a CIFS mount:

	bash -c '
	        FILE=/mnt/cifs/repro

	        trap "" SIGXFSZ
	        ulimit -f 3072

	        truncate -s 2M "$FILE"
	        fallocate --zero-range -o 0 -l 4M "$FILE"
	        echo "fallocate rc=$?"
	        stat -c "file size=%s" "$FILE"
	'

Before this change, the operation succeeds despite the 3 MiB limit:

	fallocate rc=0
	file size=4194304

After this change, fallocate fails and leaves the file at 2 MiB.

Fixes: 72c419d9b073 ("cifs: fix smb3_zero_range so it can expand the file-size when required")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index bc7dda6d825a..f823f9bc90eb 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3442,6 +3442,13 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 
+	new_size = offset + len;
+	if (!keep_size && i_size_read(inode) < new_size) {
+		rc = inode_newsize_ok(inode, new_size);
+		if (rc)
+			goto out;
+	}
+
 	filemap_invalidate_lock(inode->i_mapping);
 
 	netfs_read_sizes(inode, &i_size, &remote_i_size, &zero_point);
@@ -3472,7 +3479,6 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * do we also need to change the size of the file?
 	 */
-	new_size = offset + len;
 	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_size);
@@ -3489,6 +3495,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 
  zero_range_exit:
 	filemap_invalidate_unlock(inode->i_mapping);
+ out:
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
-- 
2.43.0

