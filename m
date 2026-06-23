Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EBB12C534
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182910; cv=none; b=IV5PYRtQBfMGQLkb0dXQPbNGuvYpR84MV48/nLdhlvNk3vGw9JrnBfDKsPqpEpo0ji8hTkYMZ2Ava6oqCdLv91WiFMZJBKY7pGh13X/TlneNbTnPLtlwv35jytnZiVHdNt9Crci2pF8JLBa43mvaxAe/WXZ4RzS1TWEn8mfU2FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182910; c=relaxed/simple;
	bh=AWNytZftJTkqaKcqhlQBUtAsqbXiD4972rFlkpT/06A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJidywzTJGfoY1bK5tChLNsm9/OyvPYofAdzQKq4WDJNE8p30EJGKLTxM9FzqLDmIMI8J0CFDr0hrHq71E/7V5zZHKEhH34YyoKRWkrKit8i0tYKQZIwYo5HOXD+66sTvY6xN3PExUZuoEiSivFBgEk7hDOB/T4G4oCPvODRsOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pB4+5txe; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pB4+5txe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782182908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g0ys28iqgF1Okw6EvSX9eUnD2NWkaZhitnoS8IExUlg=;
	b=pB4+5txeCfOduAqfifjfvIoAIgvS2R//O1puSHKt5B7E5hNpRkPPdeFYvmqaTRH1dlW9Cv
	h6+jNDfxBWadjjDCUekc6nBsZ4olQpwZ2cW41KqNtefGwGtKtfqm2iU9eKUPH7HxzvaAfY
	uDRfagPNAP5jboT7jEu4rhEYsejTjh4=
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
Subject: [PATCH 3/7] smb/client: handle smb2_set_sparse() failure in non-extending fallocate
Date: Tue, 23 Jun 2026 10:46:15 +0800
Message-ID: <20260623024619.1360127-4-huiwen.he@linux.dev>
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

A non-extending fallocate on a sparse file can return success while the
requested range still contains holes. This affects FALLOC_FL_ALLOCATE_RANGE
within EOF and FALLOC_FL_KEEP_SIZE when CIFS clears the sparse attribute.
Later writes into the range may still fail.

CIFS emulates this operation by clearing the sparse attribute for the
whole file. However, it ignores failure from smb2_set_sparse() and sets
the return value to zero unconditionally.

Return -EOPNOTSUPP when the sparse attribute cannot be cleared. This
prevents CIFS from reporting successful preallocation when the server
rejected FSCTL_SET_SPARSE.

Fixes: f16994797ea8 ("cifs: fix incorrect handling of smb2_set_sparse() return in smb3_simple_falloc")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 554c1f51871d..61b581d86686 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3770,8 +3770,10 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		}
 	}
 
-	smb2_set_sparse(xid, tcon, cfile, inode, false);
-	rc = 0;
+	if (!smb2_set_sparse(xid, tcon, cfile, inode, false))
+		rc = -EOPNOTSUPP;
+	else
+		rc = 0;
 
 out:
 	if (rc)
-- 
2.43.0

