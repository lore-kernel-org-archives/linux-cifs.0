Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE6D40B6EF
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 15:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782919365; cv=none; b=dOQEc2QGVT7xuTSoL7LlhCA7Sh81iwICwmB6nJs9ABskamWIGkLN7SiDj+BHOFkkbZwzqkd9AgRMRj66sbUaP3bY83z/W923TJdPIuqTDTvWzxzvVxfQLQkc1WxdvDxjf6hJabzNWN4OUoxPZ0ZdwAbi2LdO5aAaTOMyaXu3im0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782919365; c=relaxed/simple;
	bh=GCnvJHBio/Ubb1Wgm9L59E/Torx+eCsMHP7htQ1hHrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OD1am0uu8JPO1ju4jLU4IkrCQ8gOjDQE5I9caxPudc04JU6VuAcIgu4qZ8hfQ/P4myJ9ph1iezKEUJpgxNXNn/Cj6FJUIGgTce9WVjVqXlbNMi2uRafm1JzweIVXNN1cK+aiNqTkp1lhq21QbyYJsBiTOjF1XA8slE3BFfyfO2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J9fRrzAK; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J9fRrzAK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782919361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tk463rdj5KIex1vNO8TGbE7YBIG6qoWl+fn1XvPJ+7I=;
	b=J9fRrzAKoHgoznuY1w0oOC8uL65zkQAppBlgoqvA87q2CXvyFcQF2BlKQLcGOwLLNBPbn9
	ZHdsxpEbajl5e/Ag2jKwRBOrr5zqKsxyDn5U2B+YC94wfhlH8C5ga3OJo+zo6tXIuF6h+p
	LkiIrkRm5+3X52UTO+pLR8NB2FHtZrk=
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
Subject: [PATCH v6 1/5] smb/client: refresh allocation size after duplicate extents
Date: Wed,  1 Jul 2026 23:21:53 +0800
Message-ID: <20260701152157.822207-2-huiwen.he@linux.dev>
In-Reply-To: <20260701152157.822207-1-huiwen.he@linux.dev>
References: <20260701152157.822207-1-huiwen.he@linux.dev>
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
successful duplicate extents request and updating i_blocks from the
returned AllocationSize. If the query fails, invalidate the cached
inode attributes so a later getattr can refresh them.

This also fixes the xfstests generic/370 regression introduced by the
i_blocks accounting change, as tested on a Samba "vfs objects = btrfs"
share.

Fixes: 99cd0a6eeb6c ("smb/client: do not account EOF extension as allocation")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 06e9322a762a..cc8e0595e504 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2193,10 +2193,13 @@ smb2_duplicate_extents(const unsigned int xid,
 			u64 len, u64 dest_off)
 {
 	int rc;
+	int qrc;
 	unsigned int ret_data_len;
 	struct inode *inode;
+	struct smb2_file_all_info file_inf;
 	struct duplicate_extents_to_file dup_ext_buf;
 	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
+	u64 asize;
 
 	/* server fileays advertise duplicate extent support with this flag */
 	if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) &
@@ -2232,6 +2235,19 @@ smb2_duplicate_extents(const unsigned int xid,
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
+	if (rc == 0) {
+		qrc = SMB2_query_info(xid, tcon, trgtfile->fid.persistent_fid,
+				      trgtfile->fid.volatile_fid, &file_inf);
+		spin_lock(&inode->i_lock);
+		if (qrc == 0) {
+			asize = le64_to_cpu(file_inf.AllocationSize);
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

