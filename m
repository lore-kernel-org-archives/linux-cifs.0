Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A89D29992B
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 13:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481667; cv=none; b=Z+x3TmNp5fHs8M7YdW77TAWe23keMQhbaMFhhM8990HRYIpN746+D4z8eQK/FFXMT7VNDUB5+zigNVkNNWNW7PMACrVni0RhAPHUHttj+lW9/F/HEzo4VBnHyvbyEhTRk7n2Kqx0uxgTuVRuvANnqKgqRbRG0bQdq2zQJ85pu2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481667; c=relaxed/simple;
	bh=81VevHZm3U7O9oLwrvXpFySVQz8xwWH7G5/kB6equQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVHC4XMyZ4jqyFYu6Qzc1afBz4JICYOQkup7mPRkvoXVYhPRgrwjpPQTg5nK29HmgcqvrMfwz/+KwaFqkdQlAfvJBGmonlYFq9kKJ8VT76lfs8+1bBR/gBhkYJ3qSBgLyLHnyEfD9lfdNYROduuzNv5p2ldtVXuFQqV5fJW6HsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TlLYRJCx; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TlLYRJCx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782481664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBUWz9uqsxWmKPMmk37cN/lQIUIdNNXcWpj3inCqJNE=;
	b=TlLYRJCxrV1Pghu2n41HEs9w6oFCqsUnao5gp3gUx7SKl6VedeRsUvT//RooEDFAl8GZ4e
	3sKuDGzyCEuvHSsQhSADZRFUkql1RjrX8sp2zR9oyB+rG9fyFzmOlwLWcGE0OzXv9ph76B
	HypABrF2AXW2bhjJ8mg2beF7/AeZAU0=
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
Subject: [PATCH v4 2/7] smb/client: handle smb2_set_sparse() failure in EOF-extending fallocate
Date: Fri, 26 Jun 2026 21:47:14 +0800
Message-ID: <20260626134719.158270-3-huiwen.he@linux.dev>
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
index f13e5d902244..bbcd4533406c 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3707,8 +3707,11 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
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

