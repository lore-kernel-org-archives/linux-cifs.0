Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDBC3542CF;
	Mon,  7 Sep 2026 23:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788823220; cv=none; b=uzPTpq1KVSrJUsAvkm1/PkWwO4ZDyPwMKXMh0bFyvL1KUNwYDrDhovDXxpNx8+c3YoOZVktu19U8ea87qgjaTk9HJPohLyaHCp0y1A+6aYmCArE25MhriD0q1S6dnnbtwKTdo8/pEUxFdF60Ah09If5/q9BhnzG83X2DRVdN0GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788823220; c=relaxed/simple;
	bh=s1rm128vhtUTI/agKCVeujEStb80mQkqntxKg+Caizg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aD99S4KI9dg58PvRG9HyMt7tbawzQqXx20WpDbHPWTsRw09aGKsvpWXy00lTgJ0j/CzbkMgv0TCL4xG7uu0YwZFfpwrxOS/AUv5MJhLdHetYgkyJfU0XnJHmexCgAEw0bUII2EHsddTerQMxLqPuoAz0vQyQez+nVsppti9tEA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hiI3zn2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiI3zn2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC52D1F00A3A;
	Mon,  7 Sep 2026 23:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788823218;
	bh=i8nSAyVxVRCbez6CF7JtknGWhoFuyigEybPbHugp+T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiI3zn2CUg75JLqGPGVh/UyZc+xoi5A6n3zMXSt54VhQQ7yas5KpRLKaS5kWHFGzJ
	 lNK6s2JD14bzYm2Oy1AZ4uKY9842f0n9Ww6F8bg7trS1jgAryorzgzYVsBYZO0i7RE
	 wTVyhQKihwDtsxqDg1qBEhBIbrXOsfeo4NcjgdkTFYUmdty2RrWYjqvFq90QyJk/cP
	 +U3grlICDkWuTm/1YiicTdnSHSUrgD/CMu+VmPUBvxRT+v9H8zj9H5D+dTYGpC7uvJ
	 2Hl83mTZgKOmttjumNSyWC7v5f1NeymG9vM85IoUYIyPikq+I49vvh252YUcca73Ot
	 b701KeKnStJzQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1.y 1/3] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Mon,  7 Sep 2026 19:20:14 -0400
Message-ID: <20260907232016.765564-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090336-expend-runaround-0e93@gregkh>
References: <2026090336-expend-runaround-0e93@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit bc3de356aae666de5d8b5131545be87cf7754431 ]

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 65deb1835934 ("smb: client: reject a tree connect response whose byte count is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fscache.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/fscache.h b/fs/smb/client/fscache.h
index c691b98b442a6..e89d26c6e0862 100644
--- a/fs/smb/client/fscache.h
+++ b/fs/smb/client/fscache.h
@@ -38,12 +38,12 @@ struct cifs_fscache_inode_coherency_data {
 /*
  * fscache.c
  */
-extern int cifs_fscache_get_super_cookie(struct cifs_tcon *);
-extern void cifs_fscache_release_super_cookie(struct cifs_tcon *);
+int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon);
+void cifs_fscache_release_super_cookie(struct cifs_tcon *tcon);
 
-extern void cifs_fscache_get_inode_cookie(struct inode *inode);
-extern void cifs_fscache_release_inode_cookie(struct inode *);
-extern void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update);
+void cifs_fscache_get_inode_cookie(struct inode *inode);
+void cifs_fscache_release_inode_cookie(struct inode *inode);
+void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update);
 
 static inline
 void cifs_fscache_fill_coherency(struct inode *inode,
-- 
2.53.0

