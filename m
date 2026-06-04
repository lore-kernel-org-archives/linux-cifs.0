Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1603B30568A
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jun 2026 15:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585484; cv=none; b=sFZRlrkYyuJinTgglA3IJcf9qeNQFoPIoZvifwz+1Eubzmz6eUQMS1uEMKzvYvWBnACYu2jLA5taJkYmaJVu9RjmDT77zeuc2NzIPspv7jeCouEbRsfySzsH9zqwRrf8K+oPVr/anbfa5PKyxXk9MXO3m/0uTyjgR2MM1exBqAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585484; c=relaxed/simple;
	bh=J1/+Fw0l+hqjolzgxRTykfqM7a6eXYO77v2Wak+Q8wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUB73B0+08sKam1SCjl1YUyKMHfPLuXavQY3caqv7BX29iyK5g4N9PqFHDdwmYJQ4C9VnJYaNXPLuj8m789uy/yew9biTdjT5VUBrcxR1GHQ+jMacqJKLlfHM0kqf4Ukfa6paanedgBFDlThJ3y578vR31eVTjMLVKd/qEPecVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VIPsfIo8; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VIPsfIo8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780585481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWjHlpSjmYZGSbz1H2D7Jfnbqw/P4YGWd3wTm0OBKb0=;
	b=VIPsfIo8euXO3sDszmUedclgNimQtxRS45P+ddyTf6KlkFeKsilksoI1Ly6OzFOqBwp2hF
	lpwkFVO6nzCt4fpXdLwThV/nCPkZ3Aw/nQK8uJa5tS8wZTzLzx+G/GcIxwv4g96BXOBGMW
	/aAn6MyMwQVcYqz+3Bk+BA36tKeJLqI=
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
Subject: [PATCH 3/3] smb/client: refresh allocation size after fallocate
Date: Thu,  4 Jun 2026 23:03:49 +0800
Message-ID: <20260604150349.101716-4-huiwen.he@linux.dev>
In-Reply-To: <20260604150349.101716-1-huiwen.he@linux.dev>
References: <20260604150349.101716-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

SMB3 fallocate extends EOF using FILE_END_OF_FILE_INFORMATION, but the
server may also update the file's AllocationSize.  If the client keeps
the old cached i_blocks value after fallocate, the swapfile hole check
can still see:

        i_blocks * 512 < i_size

and reject the file as sparse.

This shows up in xfstests generic/496 as:

        generic/496         [not run] fallocated swap not supported here

After a successful EOF-extending fallocate, query FILE_ALL_INFORMATION on
the open handle and update i_blocks from the returned AllocationSize. If
the query fails, leave the fallocate result unchanged and force a later
attribute revalidation by setting cifsi->time to zero.

With this client-side refresh, and with a server that really allocates the
fallocated range, for example Samba configured with:

        [scratch_share]
        strict allocate = yes

generic/496 can pass the swapfile hole check.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d4875f9532b4..89230141b5dd 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3698,8 +3698,23 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_eof);
 		if (rc == 0) {
+			struct smb2_file_all_info file_inf;
+			u64 asize;
+			int qrc;
+
 			netfs_resize_file(&cifsi->netfs, new_eof, true);
 			cifs_setsize(inode, new_eof);
+
+			qrc = SMB2_query_info(xid, tcon, cfile->fid.persistent_fid,
+					      cfile->fid.volatile_fid, &file_inf);
+			spin_lock(&inode->i_lock);
+			if (qrc == 0) {
+				asize = le64_to_cpu(file_inf.AllocationSize);
+				inode->i_blocks = CIFS_INO_BLOCKS(asize);
+			} else {
+				cifsi->time = 0;
+			}
+			spin_unlock(&inode->i_lock);
 		}
 		goto out;
 	}
-- 
2.43.0

