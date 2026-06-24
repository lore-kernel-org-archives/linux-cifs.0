Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C921127587D
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 02:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267437; cv=none; b=lM89IaL+AQJHpqRVtBpwdPrXM89rsSbBMIa2vVIyJbGKINbBcJsU+hhLsz3kYJExGmdmX5pN//qau6qPnqebA7nqo+sDmvx/yB2Gg2c10OPEbh5DVf5GPsgK0C1lcBAD8f4HiPuIsvPMPo/jIG83fslMLZwbaOJkprwyNgZGpY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267437; c=relaxed/simple;
	bh=qzBwMPm44p6DDVqxxFkLNbZw83Un3dpLJuXaXe+yx74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCTw2X8Y97DdvhicuWiM7ppO2iXbiI7uOfOkmHb+mb7BfjCd9cOO8iPDYNMy+mMaUOhZCpwFQ4fq/VOgtffQk7hxMPljvuSdYOA0+fjoMOYFzVLhCX4xrTZjYfkO30O3wcHv/PCXiH5BGq98Cpqmzl1lDzFhM7WxdjkvgpegNvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NVu/R04O; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NVu/R04O"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782267433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=idJ2NmcTCdlomdjBjJ+GRirzHI61x8jbPJTkj+VdToM=;
	b=NVu/R04O2zigADfF2CyX1caKbSzUrIAZVDr2RT2/C/D7M5V8GFv/eFvcf9VGguz2aQJ3oE
	+pA3nICBAe7YY/6aF1d05EERVX0Z/q4r5VNpxYYn9fGluJDHstcs+8uJ9MahHT7dKia2uV
	qd41gUxMznq3BHB09an+mZiTSkyqiPo=
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
Subject: [PATCH v2 3/9] smb/client: handle smb2_set_sparse() failure in EOF-extending fallocate
Date: Wed, 24 Jun 2026 10:15:44 +0800
Message-ID: <20260624021550.1548952-4-huiwen.he@linux.dev>
In-Reply-To: <20260624021550.1548952-1-huiwen.he@linux.dev>
References: <20260624021550.1548952-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

An EOF-extending fallocate(mode=0) can return success while the newly
extended range remains sparse. A later write into that range may
therefore still fail with ENOSPC despite fallocate having succeeded.

CIFS clears the sparse attribute before extending EOF so that the
requested range is allocated. However, it ignores failure from
smb2_set_sparse() and continues to SetEOF.

Return the smb2_set_sparse() error without extending EOF. This prevents
CIFS from reporting successful preallocation when the server rejected
FSCTL_SET_SPARSE.

Fixes: 8bd0d701445e ("cifs: add support for fallocate mode 0 for non-sparse files")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 965a4d21dd43..f68c0df1b66e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3691,8 +3691,11 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		if (rc)
 			goto out;
 
-		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
-			smb2_set_sparse(xid, tcon, cfile, inode, false);
+		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) {
+			rc = smb2_set_sparse(xid, tcon, cfile, inode, false);
+			if (rc)
+				goto out;
+		}
 
 		new_eof = off + len;
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-- 
2.43.0

