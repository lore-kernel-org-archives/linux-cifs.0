Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E7E3B47DD
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 16:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403404; cv=none; b=MzmKeg5wIYXsC51HwnNUntax3QfwfFq5mVwujj7gSJxSy/DBEOn6/NYjNa5RghFepfOU4vBVp8kDrGWizix50BcGpMp/U6ajmdsCbzHVJbd/i4YOpcMPHr/6cppGKO/6Q9T7aj7Lp4XLquky43t/f8qwtHsXZRO++Lbu7rpkzVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403404; c=relaxed/simple;
	bh=3jRrWVkTcbo6DdjKUyzXcC0lqaeTegJFupqNdfAn2Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpaQypvvSNtRyf2WBLMc/n+QtCViZX/gEuGLgGrtTtf0nrEpMMJQ7U32KDV2Tf9ZX5VUytd2E2/hSYF3CLEuBIh6glkDiXZtwTnuISiSNQrCkZdzAaYf+G82GEHR7FHw9nbAx9Zi+Y3i21Y2IChQnAWuHe8mqvvUvj4ST8Atfxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H2gqJ++9; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H2gqJ++9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782403399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7CoAVzvGRXJvu2D4xPUGPjIhdzwv5vNMfz2bRkI6Mk=;
	b=H2gqJ++9jFaWQqT0sewIjsK51tfaqYhCm4xvjPliq7UIFDQgCDfSlK/iu86nW7LdubHSQb
	FzrNn00MnQhuk8FXXNNqcxX4uNPwtO03JFJndIk9mJYss0SPWlg3rNh8XF/GEEdtCSFfwd
	Nc992S1HXp6p2jc8tIFmgn1L9MDE5e0=
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
Subject: [PATCH v3 4/9] smb/client: handle smb2_set_sparse() failure in non-extending fallocate
Date: Fri, 26 Jun 2026 00:01:49 +0800
Message-ID: <20260625160154.104450-5-huiwen.he@linux.dev>
In-Reply-To: <20260625160154.104450-1-huiwen.he@linux.dev>
References: <20260625160154.104450-1-huiwen.he@linux.dev>
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
index f68c0df1b66e..b8474ed9af16 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3770,8 +3770,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		}
 	}
 
-	smb2_set_sparse(xid, tcon, cfile, inode, false);
-	rc = 0;
+	rc = smb2_set_sparse(xid, tcon, cfile, inode, false);
 
 out:
 	if (rc)
-- 
2.43.0

