Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B62569F0C;
	Thu, 17 Sep 2026 14:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653733; cv=none; b=DpUu6cW9Q4yaUmrmfC1y+PiyABiuND6hoCywkPPaR6Ntq7SNVGbd0fR/KlCkrXnu8k0kNhURHiuCavg0VyOFnceCAwWxdRiq5vZNHV9Xo4nRY1rYZpeystsC8KD97QuDIrIAR00m7Fgh6ETqxZBlGkofvhuOQJgPpml5tc9WjTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653733; c=relaxed/simple;
	bh=M6hDV8cW9iySlwr5e1Ieu8Zqt6sbe/AK6hc2ZoCGLPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTOF4FWwYkrIkBSQqh/Ms/yoZRF/PYQNxmMqaOOiIw84z1zluA0guL6b/JmxCap1pcaKIQgBA+/ZwqAGGAY3tARTEFykRwMfIENIKnNzIZDwH7rFoAORBEBnnIk2p0rU9s8bcrMCTj/xKDN+5/Qm+JzPNshMZTVGndMdgSz9qFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APi4JzDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APi4JzDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B311F00893;
	Thu, 17 Sep 2026 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789653731;
	bh=rF7CdMLVPvmv5//zwYFoLYOrzmF58EOEgydkuzxIxQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APi4JzDS+0MQazr+qeQStzYiUGungghaZX794swKv/xoIlgJWBOGd+JMJzbtJKMgT
	 eFisnZBV+WEAUHzpYHyguD2Vh7R5XuiWkjohqfzvpqMuQqrmV602psLwdfbQ/vKdcz
	 9xYUhv/4dmoxcCAUAYzC5uXcfL5nocbh7hbJiSl5csiIJQnHLjSLmcfUwW7kxULgE8
	 4sbSZ4YJ/wgIYzaOTTlChr+lvCKv+ZbjM8/DxJiODWdTT3hWw1JGC9WhTHx7+xUKmg
	 wURtMCSY7ZuJrEtB/JCpVo7KTvYmaDsEGph9YEWD9cSc4ecA1Ldu0NKTKao6NyPPSj
	 1y9c7PwTyattg==
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
Date: Thu, 17 Sep 2026 10:02:06 -0400
Message-ID: <20260917140208.505903-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091634-finch-unglazed-c530@gregkh>
References: <2026091634-finch-unglazed-c530@gregkh>
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
Stable-dep-of: cf4d35896621 ("smb: client: fix uid/gid override in getattr with posix extensions")
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

