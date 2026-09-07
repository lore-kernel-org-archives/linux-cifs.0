Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9DF48C3E4;
	Mon,  7 Sep 2026 11:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781653; cv=none; b=t2srndpBwMhB034kpn+6hP6vIPC+Y+OoA/VrPii6yYD86bpn/Eqnws28B6+kGd+PCmvw/Sxxx6KjS0TfSwCBNN8opwQ2uo8XrXsU6KPhim4Y0iDJO3QM9DCuZ19qV02SBH8wlzxxqcyc49SJW4mLXKKlXinUeTjyHpV9GMWSHa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781653; c=relaxed/simple;
	bh=uwv6zQ2VktRR4vUBWvrp6mJ/ybKLzTYV7VFT/ZtvNMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vmrv+5ZEARSh99w9AbllPPutea+hZIKSrBo5FTf9dzfPC6imYLpHLWjzuj35SUGE6EeEWMLdiN+lAQqb3z550jvQUfYnIXFSvR7qfOFRLflz0hXp4CQybKmYIA75rk+BcKtJ+2ApMFhmvLuw+MRPLEa0AJeidrFlvbB65vj6AhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHI3esio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHI3esio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D6B1F00AC4;
	Mon,  7 Sep 2026 11:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781651;
	bh=34zLm7+tqYXxng4BxbeNhNfQyzoQe6VfoncDGYVEKCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHI3esio7FkpT1qUclzXXYAFIUuUFs2RAS5aG2Je1EOG+yFCUnylORsjd2wy1tVJ6
	 7mm2U/WQzs4RDAUhyzqsMSp4FyJPzT1mG3F1YcdtRqZuA31wW7rMUsQzljqxosRtK3
	 dx5nOePb6Tvux9sZtw9gg42MaXGaGl//rGVh+NvOTTFAv0fK8FyUpXJr15P2dds3tI
	 BlfQq3jnLdDQ6KQXekE81ucsERwTbUc/ZUTWbjg/cVHdfo5lNnERN/NyGedr31kE8W
	 soSbtF3yFmNeW/7MPypvHnw/UVC/PQt6yeiHB466hA/f1i6ugVsaeB8n/o8bcGiUqb
	 R+M4qJv5E0o2A==
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
Subject: [PATCH 6.18.y 2/5] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Mon,  7 Sep 2026 07:47:24 -0400
Message-ID: <20260907114727.2870618-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907114727.2870618-1-sashal@kernel.org>
References: <2026090302-bronco-shame-0d3f@gregkh>
 <20260907114727.2870618-1-sashal@kernel.org>
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
Stable-dep-of: 6343c1da5619 ("smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()")
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

