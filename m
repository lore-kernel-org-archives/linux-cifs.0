Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AECA282F15;
	Mon,  7 Sep 2026 21:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788816994; cv=none; b=tBrEoPwvMevf/K4xYaoUTRH1Q0p+Fu+WHsdX8lf1/at17MDzmQ9fkSrVSyVWs4Hgzu/kkodrWALaV0ef/wVls1TAzI8QnDpSPo3St3GAto8WUD4fL9yPFB4To1E5FMqA4RSV+NCXey1GBTYBiYz0V96WCI8+2j+Mb62wfOiEEfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788816994; c=relaxed/simple;
	bh=znQ9OivNEMphTJUrNlZjNs/Y71W/ipZbIh2o6NuKw2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyZgC/EhIyz8+kuCc8r/tgcJf5wUO5XV52L54QnWFPj6ekpmelQB7a5XOmQ6E7pAun7uADMlI3fGNM8kL/lYfMpAz2ClkR5aYIGmtu/q7742uaVJawrKuvdbpU7fQwvaHc0JAhu5548UH2JjS+EcBO7W2Pc9bpXoyeZRHoZPKAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAS8qN14; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAS8qN14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB8C1F00A3A;
	Mon,  7 Sep 2026 21:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788816992;
	bh=TIMK3K2+TXFj63w90gvVT/Kexo0InQ1Pu/JQPGQYX0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAS8qN14ijtwqSTNhj/yg7oHXWieQFxChL2Vqlsc1qLwed2S68nWynYevcM+j8my1
	 E+TmgZEikh5HiniS4b+m0vc6Y/zc9Ykh+xqs+rCmu8rWHSUwgKxTZnTDPfUoO+uC+K
	 fhPlYJxk3HY8d3Dgnbu6u7VHXfg5mOUH+LQ4X4IZV59ZQcbGfo+DomaU0CXZkaoWyk
	 xzg4GLPlLF/qvsXt/Tz4P3hYLhbQPEpNz9DH+qZMw5M17XhVtKH6aV90ydYUp9s8UH
	 JvrzcAGLocrD6nqmevKvtAtkIYScioZ4DU8idxiZC/iE6qqwiWdlWjqWowlDaP6Kwl
	 262VxTPKLRV/Q==
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
Subject: [PATCH 6.6.y 1/4] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Mon,  7 Sep 2026 17:36:27 -0400
Message-ID: <20260907213630.573772-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090336-riverboat-makeover-fe69@gregkh>
References: <2026090336-riverboat-makeover-fe69@gregkh>
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

