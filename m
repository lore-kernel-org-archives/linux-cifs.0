Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9291AB6F1
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182901; cv=none; b=eTQi6PFq4bIvekMxBtiVrvJaot6Rp9LWnoaphNvz56hNra38SwOwQmY5UuTsh6aA1R+Iw9LIXRruQ9VEtNGse/jn4UhVx77/K3nSONxKjFsYpmVVkFgq7zcUlrbYALvLYdXczntqK8hn2nXh7eFjq1eLd2SX17ALNV1FuvlKthM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182901; c=relaxed/simple;
	bh=3cBucOjj8zfHKgD4A7QESeitB4zMLn5pDukRWwvkIws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNGXaR9uRh0tPB19r+Dw/CUOat1DsIbdCIaCQViYV89+yPJZyNNR585ndpnUKEE5UZqgXTC0tZQm4Qa/18iQdu0DJvLCEuemszoxhPKVFbMjAFAqcS2vcpcgTKGBjn+gArunf+th9ck94XNOvcLFs+MTJWNePBynYI3HsOwZedY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gzkGuaB0; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gzkGuaB0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782182897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IX4Jsro2k7lcFAb6PkbpwHCnQhGJxvtnQLf6F8hJB3s=;
	b=gzkGuaB0Saz3Kls0JIoWnzXa7FZmHsSlMddve0sW47WwTAq6LnWlN6cWxCLFaACTDbdOBL
	/6p2YONl3ga6C5tyfJ06oN61ZXdufyal62VWXcNQ75YlzIW1zMlrbTJjwdc5AsrA0sIkTo
	aq92DBOtoWbKqGKxYeTVPHbuvynr5mM=
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
Subject: [PATCH 2/7] smb/client: handle smb2_set_sparse() failure in EOF-extending fallocate
Date: Tue, 23 Jun 2026 10:46:14 +0800
Message-ID: <20260623024619.1360127-3-huiwen.he@linux.dev>
In-Reply-To: <20260623024619.1360127-1-huiwen.he@linux.dev>
References: <20260623024619.1360127-1-huiwen.he@linux.dev>
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

Return -EOPNOTSUPP without extending EOF when the sparse attribute cannot
be cleared. This prevents CIFS from reporting successful preallocation
when the server rejected FSCTL_SET_SPARSE.

Fixes: 8bd0d701445e ("cifs: add support for fallocate mode 0 for non-sparse files")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 2964f461fc84..554c1f51871d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3691,8 +3691,11 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		if (rc)
 			goto out;
 
-		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
-			smb2_set_sparse(xid, tcon, cfile, inode, false);
+		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) &&
+		    !smb2_set_sparse(xid, tcon, cfile, inode, false)) {
+			rc = -EOPNOTSUPP;
+			goto out;
+		}
 
 		new_eof = off + len;
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-- 
2.43.0

