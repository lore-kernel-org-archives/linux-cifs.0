Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD03501F47;
	Mon,  7 Sep 2026 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794096; cv=none; b=PHE6KHcPK0rJfQ34pkFnCIanWBDKk6OWY3yiKqEjHGsJ4dRvd5ChZPEC1kGAm9GfHKzZtG9SVutAiE6iRz9p7s3ZgfizQL6Ay2TpHDPNP0fwS+wob8PY6zfbS2eqlXk3ZwvYK/DLdHhZQPyPyDQFKS7BsN1W6embPabwrro37KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794096; c=relaxed/simple;
	bh=UE3DvX9k8x91jIsR3T7WdH/vrR1IFqo7ESsc1dwiytk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qdt5/rQx3NVz2xl5o3p/7RYgWSRHTA2pLMsQI11aRGQFENUx0ZfJZ8JTlYXF4BBJOxoH2gAkwVO7PnQ1XhTrxt5oVbdF47a/FXB5MKNPmH8w7esV79qkEy1UT7mpHZrt96MckzyXrX9bC7lt+Jcc2LjFOgh5m1J3z26aO62IFyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bblvdamh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bblvdamh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AD01F00A3F;
	Mon,  7 Sep 2026 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788794094;
	bh=L3r8c6+2/cREJq285zS5xtPxoOkK62q7YUlNvEziciQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bblvdamh4/ffjVkZz4S7Q9Ostc2j0eHA/VFGEGaEhJLVftS5MdHNiUoa4CBn0BDnl
	 9uNG2cjDq/YxJXhPiVfijgjlRulHhkDHB2XYDneiwVC/HYbfLjc7eLAYf+A5qQyZ9L
	 bOGoQ2WeOjjUZphkwOJ8nz0wTTy0yr0VeHfqFIMfoLGWUFWunGT8HcaiNJ5r7EpEze
	 G7qp9VUV/o72jv/osthqUBS1Imhzi75TxCdJQTm2FRWx5f3rJ3DkHZ7ligczQIHS6a
	 cUhR1NbnnWHqVZxS4f5gq+YQpGIYP7Y2taf/8S60uAZoUnLCwJ2gHuSTqRVYOgVqhT
	 0nLtKjWk3iL3g==
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
Subject: [PATCH 6.18.y 3/4] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Mon,  7 Sep 2026 11:14:48 -0400
Message-ID: <20260907151449.3749114-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907151449.3749114-1-sashal@kernel.org>
References: <2026090335-figure-bright-e488@gregkh>
 <20260907151449.3749114-1-sashal@kernel.org>
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

