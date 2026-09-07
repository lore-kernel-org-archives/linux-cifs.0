Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD275013D3;
	Mon,  7 Sep 2026 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788793270; cv=none; b=ULIu3nNy04k4XA2VOWFMmcomB/LWZjdXbDs6Pi/JgfAuhHXBCZGvtMU6oXlBqs1YI8CCqWqOEHNcJyuQYlE+B9vy0BzmW7+yZdVwmEJjvN5ElwNI+LcR9hMqCFXwhIP2EFsxnACsHwVFV1DIuuaZdu4LEnbh0ZWsjHY3WFkzJLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788793270; c=relaxed/simple;
	bh=9FIWGwMJkZ/9DvqJbtl3Fuu2cQQXTPiOcgSLmXLVNjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c90a2/CKHk6Ou8WOeMbi/G50Z/GlnuvROgmwjUJkkkS+rvDIzGMUk05XPQ4t32P0uULq3DyBZ+vw7AwtBCj2yQ6/xcI5xXKZWqiIh9Kj6nQ1SM72Ch9k3aYZB+gj+FUmFzm3tlCMFGMdA/tmYkHLS8GE/CUoVEtSb5J+FdCRz9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SImu5pC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SImu5pC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EE51F00AC4;
	Mon,  7 Sep 2026 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788793265;
	bh=gwhPhcKtPCCeAsMUccSwVUZHKPYlpVmAopTKyEWCjgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SImu5pC3U8mZQQwSslErFzEDVMV3tSIfTaCjCbl4HnR9x0r99GODHsRv8tydxVqjM
	 FjfOJuUYGYsfeXA8xMoSX+8L5Cwgw40/HH34EaY8uvQ0TamPgIq1/5nH6ax7Svqoae
	 LLA3wxVk7ZjBTQBlm5HIU4sv2whAlWofbUF6rCBsN79U4uf0iXvwus+3H/kv/P2V7N
	 4ny/uXppehpJ5MaHLrrSDu2x3aoULoEbLLLqx7mvYhslevFIP8KVYe6af9DR7vYO4c
	 6WZA92HWE6CFAqBMHSTZoPCPGGNNOsE1vp/AOcmFGs8+Yz4Xvxh/okcGMq4iqrPTvt
	 mWJ21xytAolGw==
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
Subject: [PATCH 6.12.y 4/6] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Mon,  7 Sep 2026 11:00:57 -0400
Message-ID: <20260907150059.3712249-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907150059.3712249-1-sashal@kernel.org>
References: <2026090303-ashamed-silver-ed5c@gregkh>
 <20260907150059.3712249-1-sashal@kernel.org>
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
Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fscache.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/fscache.h b/fs/smb/client/fscache.h
index f06cb24f5f3cf..b6c94db5edb94 100644
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

