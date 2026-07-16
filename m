Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB23840A931;
	Thu, 16 Jul 2026 10:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784197111; cv=none; b=bIGoVeEbJdHyNqXvD0uNDcG7s7WLbeIyExPhNBgMQdjQiaUvAlJR1TMqeHZSPPKg7G2eRXQdnVJ8xiLX8bVf2Uzf+pJNQxOChsDfyY1wF/uTi+kpD1kWlF8rarULqi4h9nMsCJ1Y2/xaXw1Ybqi9SOF6gmLwdVLYljojY2Xpehc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784197111; c=relaxed/simple;
	bh=jHXzdWAXRbof0xFngL3b/BRr1QMqOYc9Mrsi51mK0pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiyzDxIZEpyMzWxpQQNhhSFJvkj4qGWbnjqZS6UYRo6CW/igklutLdezIyJyY/HYMhp4Qs9ldn7Mda8DdkAhuuKlTmSWvu/UlmFffwBz4h+qGoR7pwDVJKlxegh8q0JEQKfRngq7G7lcAfxMFSOrzNm8C4CBLGiXJccOLdJ/030=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0aLPiNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0aLPiNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AB21F00A3D;
	Thu, 16 Jul 2026 10:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784197110;
	bh=dq3cJunQ1H94nv1c2sLjFJe3hqa6AwVtxahK5anJnZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0aLPiNxl6CQGf6Hf7kF6ki2EqNYm4VQecwFcgoq1MqdbzSf2ZFIQdt9j/XEJHuG3
	 WOGeJSreNxLRrdwebpVRUG4BNjPgWHZBWizOSd26UTMDXRKUGz2jPJHEVj6BYE6zbH
	 yZ2jYV2T2jLBWY6TK1hs2fRcpFNVdM1yA3J5tPCG4HKRO+Aa9j6ijCPR0T5kpxF99W
	 PxCvUjoxnlO4Sp3PrCtomek9YK2D959U/AzyxDXh/P3mbLD70RFh3n4RPzlDJ2odhp
	 hmXf4B0nC7FVpjGTbq7CudzaYJ0HUC9DSuiB7LusL4k4BybBbELS68a97xcJ7leGG9
	 kWnycNtjuW8GQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1.y 3/5] cifs: Fix reacquisition of volume cookie on still-live connection
Date: Thu, 16 Jul 2026 06:18:22 -0400
Message-ID: <20260716101824.1461870-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260716101824.1461870-1-sashal@kernel.org>
References: <2026071415-visiting-rise-04bc@gregkh>
 <20260716101824.1461870-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit dad80c6bff770d25f67ec25fe011730e4a463008 ]

During mount, cifs_mount_get_tcon() gets a tcon resource connection record
and then attaches an fscache volume cookie to it.  However, it does this
irrespective of whether or not the tcon returned from cifs_get_tcon() is a
new record or one that's already in use.  This leads to a warning about a
volume cookie collision and a leaked volume cookie because tcon->fscache
gets reset.

Fix this be adding a mutex and a "we've already tried this" flag and only
doing it once for the lifetime of the tcon.

[!] Note: Looking at cifs_mount_get_tcon(), a more general solution may
actually be required.  Reacquiring the volume cookie isn't the only thing
that function does: it also partially reinitialises the tcon record without
any locking - which may cause live filesystem ops already using the tcon
through a previous mount to malfunction.

This can be reproduced simply by something like:

    mount //example.com/test /xfstest.test -o user=shares,pass=xxx,fsc
    mount //example.com/test /mnt -o user=shares,pass=xxx,fsc

Fixes: 70431bfd825d ("cifs: Support fscache indexing rewrite")
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: ec457f9afe5a ("smb: client: resolve SWN tcon from live registrations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/fscache.c  | 13 +++++++++++++
 fs/smb/client/misc.c     |  3 +++
 3 files changed, 18 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 8d8d7f150f695d..a63de0ee134108 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1205,7 +1205,9 @@ struct cifs_tcon {
 	__u32 max_bytes_copy;
 #ifdef CONFIG_CIFS_FSCACHE
 	u64 resource_id;		/* server resource id */
+	bool fscache_acquired;		/* T if we've tried acquiring a cookie */
 	struct fscache_volume *fscache;	/* cookie for share */
+	struct mutex fscache_lock;	/* Prevent regetting a cookie */
 #endif
 	struct list_head pending_opens;	/* list of incomplete opens */
 	struct cached_fids *cfids;
diff --git a/fs/smb/client/fscache.c b/fs/smb/client/fscache.c
index 6df4ab2a6e5dc4..fb47da1d96168f 100644
--- a/fs/smb/client/fscache.c
+++ b/fs/smb/client/fscache.c
@@ -43,12 +43,23 @@ int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
 	char *key;
 	int ret = -ENOMEM;
 
+	if (tcon->fscache_acquired)
+		return 0;
+
+	mutex_lock(&tcon->fscache_lock);
+	if (tcon->fscache_acquired) {
+		mutex_unlock(&tcon->fscache_lock);
+		return 0;
+	}
+	tcon->fscache_acquired = true;
+
 	tcon->fscache = NULL;
 	switch (sa->sa_family) {
 	case AF_INET:
 	case AF_INET6:
 		break;
 	default:
+		mutex_unlock(&tcon->fscache_lock);
 		cifs_dbg(VFS, "Unknown network family '%d'\n", sa->sa_family);
 		return -EINVAL;
 	}
@@ -57,6 +68,7 @@ int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
 
 	sharename = extract_sharename(tcon->tree_name);
 	if (IS_ERR(sharename)) {
+		mutex_unlock(&tcon->fscache_lock);
 		cifs_dbg(FYI, "%s: couldn't extract sharename\n", __func__);
 		return PTR_ERR(sharename);
 	}
@@ -90,6 +102,7 @@ int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
 	kfree(key);
 out:
 	kfree(sharename);
+	mutex_unlock(&tcon->fscache_lock);
 	return ret;
 }
 
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 049a14677c9106..db897c38970312 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -139,6 +139,9 @@ tconInfoAlloc(void)
 	spin_lock_init(&ret_buf->stat_lock);
 	atomic_set(&ret_buf->num_local_opens, 0);
 	atomic_set(&ret_buf->num_remote_opens, 0);
+#ifdef CONFIG_CIFS_FSCACHE
+	mutex_init(&ret_buf->fscache_lock);
+#endif
 
 	return ret_buf;
 }
-- 
2.53.0

