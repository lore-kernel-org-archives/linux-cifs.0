Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D1730D3FA
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 13:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481662; cv=none; b=D4mJ5ZY74GhI8pdeAy0dOnYtBoojMQEl2Qe3M+U1kJFs3mF3sb60rdeFqU6s49wsOpZPgmPVmt79V87PKdrDTMKH7iAkVHX7bjQSCoqu1KVLos3EvO63bLLbzeyWm+yp1Kg5lSlMTWre7b7Qboygu1BnyfBWwi8jsENmcokAB2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481662; c=relaxed/simple;
	bh=rj77aVpwYA6l34T+TiuXauxlM3MmN9ZMPFQUDLpxkvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKg2/0Xyuj9t6bcfkb1+kMI1eAjs/B8U0Oc4+ckN5KPa33aSdsFN4a4TR0dXBqGVVKfdCZplZiiwbtkA8uH8U0wg/t8BnTXJ7BZ319HMDoff7gHIV+qP7YRTTj2BFY5YFk+kATAhd9CY+n2x32WJNNMMSrIyvtjqZp8bOQW3SYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=harOy/lT; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="harOy/lT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782481659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nbpfQ3pTR0WM4xOtuuaUvn1NYQkeW1x/u728njq2dWU=;
	b=harOy/lTA0mXdM2So3bIloDuj1SHJ0B9Wz67MxpHzTFoB0MbhIDiuTt6VFT03z8u7cVm3X
	WvTrqhNmAZl8A/8raoPun5lhNBPdFGSP80zE0AimyYzdH7q9bntXvMCqi8n//hhcyMXC8A
	c6Upg9ad3c8WNT46zH8252ntT+qlbgE=
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
Subject: [PATCH v4 1/7] smb/client: refresh allocation size after duplicate extents
Date: Fri, 26 Jun 2026 21:47:13 +0800
Message-ID: <20260626134719.158270-2-huiwen.he@linux.dev>
In-Reply-To: <20260626134719.158270-1-huiwen.he@linux.dev>
References: <20260626134719.158270-1-huiwen.he@linux.dev>
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

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 965a4d21dd43..f13e5d902244 100644
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

