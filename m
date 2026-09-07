Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C93332907;
	Mon,  7 Sep 2026 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788791978; cv=none; b=kAfpjoaesnH8kzkmldn+mZyBAbvfQzecVz2DPGSRfJInWqfawAYwQByarn/5bFjS2/iJ8TLA4ufYcSU4Q/dZhmJDnYwxeqMsANFpERNLBtYH0GeQBHo+3I2eguhZAq9kLFNldZ3krC5TLY2NhQUHGyLCaLVF3UCVkZ78bsbIOqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788791978; c=relaxed/simple;
	bh=z1K0lVKYxkDKXJvsoHgg0yuAcXcfSjAMsOXBAT3AzJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1011i2GM/WIBVhbkrND5jBQ45REUnCs07oUtH2ePq1yHnXFj8QuHYs//DIuSJyGCsEOdMiuFCIQoQQIkZDB5Rpvz0dqSlJtrPBn4wbVBef/vkMXW5LaXJHsPcfxyLFdYXuezpCXi0+iKry4PPu/li7SjgLDIkAfmyZNX8jWVfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HiR3NKH7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HiR3NKH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6364A1F00A3A;
	Mon,  7 Sep 2026 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788791966;
	bh=qiSjDK5sYs3aqzPe5CBwatVc4SmprRz1LQ2TfPS5Eu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiR3NKH7DdAyC1HIqWBt/XQdQqkheLv/Rxq/79SemIM8qN/nvDj/F7OjjYgU+sLWa
	 oFOrWSpAgpxmkv7xUMtApqWHR0dZlnLfxE5z5g/+rEl87VRjle4Ool39gBT4YnSfNd
	 t3usZ8vPZznuiDNJDJkUh4AYB9tDKth+0cOTwYoSBQH0oksNyw0SVzRDW6Vhxhm81+
	 3dY7PGQued+P1VHqmZGIZiWEAHSjdscf0wFojkAcfnyOwsNYsjBlGl3QJngN+K3Lmz
	 sxsZg3m+7tSH2VFeQSPyxwYSNEFahVYNjB3hHBGhYdU/ZY9l4cJenQzYImnDVQdOla
	 E0pMN0TRzLOIw==
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
Date: Mon,  7 Sep 2026 10:39:20 -0400
Message-ID: <20260907143923.3586545-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090352-renegade-sneeze-d3c6@gregkh>
References: <2026090352-renegade-sneeze-d3c6@gregkh>
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

