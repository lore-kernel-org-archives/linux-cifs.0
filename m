Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEBD29992B
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 13:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481674; cv=none; b=aKrj+3NHVsvLJ8Tmq9W8EN0uCCr1DQOjIRZ+l8qw9CGfad3IQl2HPnPoMj354qhnI4/CxP+N85JOz2QSnzMApv5ZIQRJiB60ksUipzxPlJM2kU42/ixGsn3Tfh3UNvISzvVhsJipOXS8Y0eTTVij5JRU+sBmX4M1Aih8ZsXDDmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481674; c=relaxed/simple;
	bh=nzpZc44qPDbGxVbs04fK6OqKeQmsoY9TXFG2m0c9RV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4ZtMlLy5xW+Zg8b0iI3uZKESJuI+UTCtZURxemRmIxpjlOIQ+H8Mw6ADrP4JRwGxHxtmPJOgHLcJG4/p8pZJSzN84buXJF0guc/NolDK+T409cyHyx6LXye8dnWlQ0KQDvoB6GWmh980Kocb3tL16nfitfjeknXaB3dIFlUIbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EdDMdnVG; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EdDMdnVG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782481671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kTbfZywe0SBTKP7tg3g1C6jVHa5mcYVRwlrWAr8QZmQ=;
	b=EdDMdnVGvX2BrQ4sttor3kngk95UGQWKj5LRSwGEGL6u9DX5k+3bSc65KJ5A+I278nWHOU
	iR8L6Ao2p4CP6d1vh13Lv5/0kyMgPeQS2RK11BU3VkgHpR4qa58CUthLuZdolCoHHgDKv8
	vdPUV21iXTpff2lxTBKGL24ecrZjFIQ=
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
Subject: [PATCH v4 3/7] smb/client: handle smb2_set_sparse() failure in non-extending fallocate
Date: Fri, 26 Jun 2026 21:47:15 +0800
Message-ID: <20260626134719.158270-4-huiwen.he@linux.dev>
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

A non-extending fallocate on a sparse file can return success while the
requested range still contains holes. This affects FALLOC_FL_ALLOCATE_RANGE
within EOF and FALLOC_FL_KEEP_SIZE when CIFS clears the sparse attribute.
Later writes into the range may still fail.

CIFS emulates these requests by clearing the sparse attribute for the
whole file. However, it ignores failure from smb2_set_sparse() and returns
success unconditionally.

Return the smb2_set_sparse() error. This prevents CIFS from reporting
successful preallocation when the server rejected FSCTL_SET_SPARSE.

Fixes: f16994797ea8 ("cifs: fix incorrect handling of smb2_set_sparse() return in smb3_simple_falloc")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index bbcd4533406c..2017357efac5 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3786,8 +3786,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		}
 	}
 
-	smb2_set_sparse(xid, tcon, cfile, inode, false);
-	rc = 0;
+	rc = smb2_set_sparse(xid, tcon, cfile, inode, false);
 
 out:
 	if (rc)
-- 
2.43.0

