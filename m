Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2C5430797;
	Mon,  7 Sep 2026 11:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781667; cv=none; b=P8E7Rv5M+kC2SnJi7Ub1TtIFtoS9WKXVaoT+kyVde6YpuPIlkuZIBL8QAZ/9F4A+eDiutvMDBGPnu3snNcGviHf8NK1Q22BEYvkv2YdkOZsGoVegrMc21ewBKrTlaFLg5Gvb6bPOV865cH2RNoQ3ektqmw+NCHx4xtdMMd5hLso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781667; c=relaxed/simple;
	bh=SwiJvY7841r6HZHeU3Kbv2XYqlZY16xDqfek92Kbfqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpH7f2+3yhUI2s1v2N1FnaiXPNIQlX7qw7yA6br9dt6w76RPcFFzun8HgI5HjGiMWUpjqqisSpCbQHuso6o8gQbSi+NqvhC2/LxbOxjEqUndVL3lOdFED7uwV9oa8frh3rnxfO2Oa5dN/OVtvW0+tgLram2CkypgzkXcskFy8Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0SNYVky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0SNYVky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE181F00A3D;
	Mon,  7 Sep 2026 11:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781666;
	bh=DpVjTYzqKoBwjxX/qPfSlinhE5TBflVi14T5Md5AzCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0SNYVkyuWgMvSgUY0OB8uRlXEkIjw3ZXJoplDVNy36stZim9AHQOxl9CWErpH6Cv
	 blHvOiqY+szIoDWsTkuh+uzZMqXTihBuarv9dFTwyMLv2rnsxXi0PJqqDtK0bMvyPj
	 jwyy4XqWBONpRThXzPaBpuF/IeF25yI7UBA8npmCi8FbmKhoYAaE5n6dduPw0iE/It
	 torkQjX6oZI3RTmQPR95LxFZ+n6GkJckZakwFpp7HogkKVLs7ERixZje9AvsxBlt4W
	 ke/QJtkr/d1XictKVZx4VDAPYKMbus3l3hv+tQ9gUMD285zpUMR9Dn23+Xp0Md0YnB
	 hJtIhlVA9ZpLw==
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
Subject: [PATCH 6.12.y 2/5] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Mon,  7 Sep 2026 07:47:39 -0400
Message-ID: <20260907114742.2872537-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907114742.2872537-1-sashal@kernel.org>
References: <2026090351-popper-penpal-d0a0@gregkh>
 <20260907114742.2872537-1-sashal@kernel.org>
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
Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
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

