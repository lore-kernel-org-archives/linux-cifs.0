Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D8C3BBFD3
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 07:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787901658; cv=none; b=WLnwED/HBb3G7mhNXeQJsgkMtafB5sTjtncZPdiWiqB2ChYkQLlGC4/NMkvk1OxUEVY8kZlE6ewH/yqU/4rrOB+TnDN3h2ijCB2ldn5zM7CE0rEh/uD62WAHmXMSoc4d6RmZ+orLr4yAB1ZEf4fYbNDCo1IAsP1Pjyei5WkqqVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787901658; c=relaxed/simple;
	bh=aQ1B+qPMdjb6JW/Mzg5fDPsolNK8Utc76dCx5zPiI+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlA06ozFbbMqa3SbOgBFRRPJiPQDM9cwYKCSlc0zDhgZszVzSt6VFlDlRw89XL8Q4CV6/cLm8wceeXTNTYaQ9Soo+ZjiffrK0171zoQuv+C54KGCReDKYoBjF9DfpgQ7YZko7HlyDbBZ1BzGW1a2TS2/hAaugZdK5lQyHJ7/OrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UlZNDzbQ; arc=none smtp.client-ip=95.215.58.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UlZNDzbQ"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aQ1B+qPMdjb6JW/Mzg5fDPsolNK8Utc76dCx5zPiI+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787901654; v=1; x=1788506454;
 b=UlZNDzbQZnexx/4ycL+NFY6TG0WixE6DU4eNfn+q7v9Ta7PH1j2BfmA8X/1VFRht5Nsie9Ko
 ozsaZ5BfqmiKMH+nb1c6N0DSq6tl12fDCBs/R+obQcMrdgu0lm8T65XvlfRyR+Itb1O0F3Lcnjn
 0swsTb2awiKhZ5+HMzZAO68g=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6b23ecf4dd3d470d;
	Fri, 28 Aug 2026 07:20:54 +0000
X-Mizu-Trace-ID: 6b23ecf4dd3d470d
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v4 2/7] smb/client: validate new EOF for zero range
Date: Fri, 28 Aug 2026 15:19:30 +0800
Message-ID: <20260828071935.552165-3-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828071935.552165-1-huiwen.he@linux.dev>
References: <20260828071935.552165-1-huiwen.he@linux.dev>
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
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
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

