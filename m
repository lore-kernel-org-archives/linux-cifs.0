Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F2B35DA68
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 05:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783056844; cv=none; b=HzdJ6drSWb+GQCjUl75BJ5Ev2Dt9qcJ+Mu2JE4HROuUZfLl0M3XIgf3f59Yu8GE9NeQadoIwaWzw2Uy/8FmIz/TzR3+nY3cP26WjOXC9wL7C6H001bp9WRPz7mTC9nuCqHuN1Hdj/OR09XztrVQyw/Lvhxnew93q6NsGm/wrGW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783056844; c=relaxed/simple;
	bh=Cy+9AKMMKAQgrU4rb5DA4sRNgUzprVtmmfRnqH63mBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkwMkwX8ZMIzO3xIxg+X6zhLIIs4Np20pZ9JNWHgRvZdji1pq9WpP4MXjQhA4R4wR8ZX0gSlj6Z1W8cgCU1GeHKuh9813R9YHlY0jsbfGWF3JLrF8rXnjQ9vaYM+Q6oNHpOT1Syxtf3eBsWTYJj98ATBTV2zqFOCPcAWwqWxYME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=is5DBwI2; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="is5DBwI2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783056838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4YzfWYBPsvwHeMn9f1B/pOoX8p2kdRHRyoFt675wl+M=;
	b=is5DBwI2sbUMPvlSyB6A1RvL+FVVlXbu+CelSck/ST/MMZsQCRGlA4k7Tg/npUXaHh5epF
	Cu+/U7zSkPASLbxmpXQwrmOul59JUbtjIjDbHJ2bUr9TtZQLNRUDgOl1k+Yv5cAec0Fxuy
	DY4LJhshpKL880WEAFccFRS8YERtnIM=
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
Subject: [PATCH v8 1/5] smb/client: refresh allocation size after duplicate extents
Date: Fri,  3 Jul 2026 13:32:55 +0800
Message-ID: <20260703053300.913371-2-huiwen.he@linux.dev>
In-Reply-To: <20260703053300.913371-1-huiwen.he@linux.dev>
References: <20260703053300.913371-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

FSCTL_DUPLICATE_EXTENTS_TO_FILE changes the target file extents on the
server, but the client does not refresh the target AllocationSize/i_blocks.
Callers can observe or use the wrong st_blocks value immediately after the
clone, before a later attribute revalidation corrects it.

For example, create a reflinked file with a leading hole:

        xfs_io -f -c "pwrite -S 0x61 0 64k" src
        touch dst
        chmod 600 dst
        xfs_io -c "reflink src 0 1m 64k" dst
        mkswap dst
        swapon dst

The file still has a hole after mkswap:

        /mnt/scratch/dst:
          [0..7]:       allocated
          [8..2047]:    hole
          [2048..2175]: allocated

The server also reports only the allocated ranges:

        server dst size=1114112 blocks=144

but the client reported EOF-derived blocks:

        client dst size=1114112 blocks=2176

and swapon succeeded:

        swapon_result=success
        /mnt/scratch/dst 1.1M 0B -1

So EOF-derived i_blocks can let a sparse reflinked file pass the CIFS
swapfile hole check.

Fix this by querying FILE_ALL_INFORMATION on the target handle after a
successful duplicate extents request. Update i_blocks from AllocationSize
and keep the refreshed target inode attributes valid so a following stat
does not immediately revalidate again.

If the query fails, mark the cached inode attributes stale so a later
getattr can refresh them.

This also fixes the xfstests generic/370 regression introduced by the
i_blocks accounting change, as tested on a Samba "vfs objects = btrfs"
share.

Fixes: 99cd0a6eeb6c ("smb/client: do not account EOF extension as allocation")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c  | 10 +++++++---
 fs/smb/client/smb2ops.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index ea4fc0fa68ca..7fc2b0ad950d 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1478,9 +1478,13 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 		}
 	}
 
-	/* force revalidate of size and timestamps of target file now
-	   that target is updated on the server */
-	CIFS_I(target_inode)->time = 0;
+	/*
+	 * On success, duplicate_extents already updated the target inode attrs
+	 * or marked them stale if the refresh failed.  On failure, mark attrs
+	 * stale because EOF may have changed before the clone failed.
+	 */
+	if (rc)
+		CIFS_I(target_inode)->time = 0;
 unlock:
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 06e9322a762a..26366098c4b7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2193,10 +2193,14 @@ smb2_duplicate_extents(const unsigned int xid,
 			u64 len, u64 dest_off)
 {
 	int rc;
+	int qrc;
 	unsigned int ret_data_len;
 	struct inode *inode;
+	struct smb2_file_all_info file_inf;
 	struct duplicate_extents_to_file dup_ext_buf;
+	struct timespec64 ts;
 	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
+	u64 asize;
 
 	/* server fileays advertise duplicate extent support with this flag */
 	if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) &
@@ -2232,6 +2236,32 @@ smb2_duplicate_extents(const unsigned int xid,
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
+	if (rc == 0) {
+		qrc = SMB2_query_info(xid, tcon, trgtfile->fid.persistent_fid,
+				      trgtfile->fid.volatile_fid, &file_inf);
+		spin_lock(&inode->i_lock);
+		if (qrc == 0) {
+			asize = le64_to_cpu(file_inf.AllocationSize);
+			CIFS_I(inode)->time = jiffies;
+			if (file_inf.LastWriteTime) {
+				ts = cifs_NTtimeToUnix(file_inf.LastWriteTime);
+				inode_set_mtime_to_ts(inode, ts);
+			}
+			if (file_inf.ChangeTime) {
+				ts = cifs_NTtimeToUnix(file_inf.ChangeTime);
+				inode_set_ctime_to_ts(inode, ts);
+			}
+			if (file_inf.LastAccessTime) {
+				ts = cifs_NTtimeToUnix(file_inf.LastAccessTime);
+				inode_set_atime_to_ts(inode, ts);
+			}
+			inode->i_blocks = CIFS_INO_BLOCKS(asize);
+		} else {
+			CIFS_I(inode)->time = 0; /* force reval */
+		}
+		spin_unlock(&inode->i_lock);
+	}
+
 duplicate_extents_out:
 	if (rc)
 		trace_smb3_clone_err(xid, srcfile->fid.volatile_fid,
-- 
2.43.0

