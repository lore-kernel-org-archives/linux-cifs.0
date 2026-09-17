Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23CC50AC2A;
	Thu, 17 Sep 2026 14:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653723; cv=none; b=ReAEebedfd2e5XYXW+Eix8fYJJrhAtqsMk9DzCbKFyHMU4pUXG29/grsrfbjcaFQ57BsWhhLaFU5fz+9DO7h6UFTp+0nAdVHz6Iw8+IV7Weyf+ja7RoiK1jYQO6tVaiscpFU9/8WtirPxqjmfltS8Mbb66o4MesE/NvgiR9pxBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653723; c=relaxed/simple;
	bh=lQMKk2FfrmIBo6UkuuUFnWE+EqqClsSINE4QoCEgWEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAaPaQNMabSiMpawXNN8AmiEcfJMF2prU9KniNVtHUTeSNdaojF908E9d9Bcz343o7n8xpaZ6N8zGHPeJFxmeE31Eh3BcEfJ1ulF6c3xRebpgyzjGhDBGqO8Gt2n71vlyzvnT1DvXPNGJZVyanH8EzGN36xLPxtCwxTbCOaj+LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZ1Dpm6H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZ1Dpm6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E841F00893;
	Thu, 17 Sep 2026 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789653721;
	bh=lwODbMOOACwDLb6t8YRwxNeoE9tIv1q/lFCYjZi6Sqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZ1Dpm6Hyo52jLSMT5R5MxtGfGUQR3s81yohbHwN3GICQ1fe8QabIjAfjx3kbC0FH
	 DmmChzBox2JnVueXSWuUH8Iaq4ZgPnB9MPaEKLvKVH6diTy/IjyQeJOw5d23eFz6a/
	 vlm69VfE/72BHTCwiTiGrUfhHBd3+ahdlDshSyRC3MKyJAoP+XutL4Em/3UVZ5ocSD
	 N8QZQ0kz0Yink/NtaXnRAHaM7W1wbSI7wsVlfZbBTKJ+AOSU1uUm8idQbAwTsg/KSD
	 bnBXVeWtKl+Ttho5tyam875BDi1qfUOSQc6lBmmj47NO3Ci93xLDjaHA+Wx7jAqqlq
	 5ylWmtxPNTMYQ==
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
Subject: [PATCH 6.6.y 1/3] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Thu, 17 Sep 2026 10:01:56 -0400
Message-ID: <20260917140158.504356-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091653-repaying-rockslide-b109@gregkh>
References: <2026091653-repaying-rockslide-b109@gregkh>
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
Stable-dep-of: cd2b2b57921d ("smb: client: fix WSL reparse point uid/gid override")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fscache.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/fscache.h b/fs/smb/client/fscache.h
index 1f2ea9f5cc9a8..4c2e269a268ed 100644
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

