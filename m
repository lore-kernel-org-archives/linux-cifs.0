Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E58533D6;
	Thu,  2 Jul 2026 02:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782958288; cv=none; b=gO8M7UOSE2wqI3OXwbsQCVEIVuexyXVO90qE8CJAl/O5hxXXZaIvZ35dA88RaCjCkGGK84BQVvL1eqYPZIYxffrSB/mDHPP387VSNyfDWstyNWav6y7sboxioS8RQKnAhJ0iGnUACczaKyqqVcabFAb+yXEyperHCcKyFZCvPaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782958288; c=relaxed/simple;
	bh=NaQ6YN6GOd7XOD/Ui6bxepvYIzqOvrI84Gs6/OC+v/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AE+Cd4LlNG//ux9i794Lu8X47dJbFkd6aT00CMy3RaVgvnMyhfAAlxQjADZ7g5EnNn/INs1inzPx9xdNsJWNSHjYJwxqMwi1JoKu80xD2O+8JI5XDHPf8BgmFz4fFcEMG4LJOCom0L6xqoWzV8Kkjg61k5+JGhfopD+0Op6WJWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=F6tH2bCH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SNTS9H9w; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="F6tH2bCH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SNTS9H9w"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5FF0C1400011;
	Wed,  1 Jul 2026 22:11:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 01 Jul 2026 22:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1782958286;
	 x=1783044686; bh=ajqsFk8kDJXpWMaviJCrShFpiHDjUjFDJ6Kz1B32xhE=; b=
	F6tH2bCHlKKP+zkjLmMMcjfD8AERjscBHOTBXtuN+Zwm92JNVZv81XbpdHCNXehK
	kWY9RTaPdPC/pNTPoxbXvk88o50cDeraWnlKjCSKMxV5Wr4V9hmvBRsm2NsrBs9B
	RUx9ghEIM7cqnqQJL1qravdaUBfIUQv6fOLqQgFdlCUIwH8GS23g8jNPZRj96RJv
	Q6gRWjvlyHrG0A8Dj2DcEhnmHMn9GBzwn77ZB/ECbIuovoC8uaHRQSugQDInmjC6
	TKr4TQgLc2c+AqIHe8VrhYjwmfm84EacmdLc16/4stGLeVnRZ03TmBKK9nSD4FsP
	gDfXfT8GLrgk/HzY75B8uQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782958286; x=1783044686; bh=a
	jqsFk8kDJXpWMaviJCrShFpiHDjUjFDJ6Kz1B32xhE=; b=SNTS9H9w55q57DuQL
	FsHpnaCA3pUolgtpx6Qzwy7yaDnwMEZgYBpQJ6OOzBIuJ3wBXHi+887bXYeqUWcO
	tXIWULSB0o+F/0baAmOvYEnn8MkGxu78U54PUEggV7Q81mMWwoc2SxYnAXWBvQGv
	2skfc2uhi7bGcfRb7Efm8SkCw+D5ZFfSyv20ymwUtPhupO/2DoFNbJ/BVGtfJqw/
	GL6fgyoV+uT9Ky7k34PJuDULhxjdgJk+iPmssbcf+CzUiZfKK9EmHQbTdPFyDZfx
	sCXUxtoakjOO4PpDn35riaAHWt/gEoYBO7zDwT0WK3vbQOPSf1GnGhu9podB84Xm
	POBcg==
X-ME-Sender: <xms:zshFaqNUy_azb03VELu0uK7-hhsCyZAycbqJFNPhJbp37BbM3m6CTg>
    <xme:zshFaqelgqjA6mR_3yq5LJDBJ5iTEeNg3thhWxpgAZDSsrNhJuXYpci4JETvotjvP
    6n9JJCF4XEtNTDj4mQ-mn7lH7aaLSROY7Jzs-9bX1CU3NN9>
X-ME-Received: <xmr:zshFahVPft2rVYH-pVJt-PJXDJNiiaBb0_pcqkObDLFdq2b4OOsxPi9gJfETXiuntUZKSt_hXlGDX4N8etIYxW4pZqHSaSU>
X-ME-Proxy-Cause: dmFkZTGAEOo5W6aeAz1EvVDq/cXpxQX9egqo4dJxaChguspbG3Yjd001v/oZjrDEc7l98n
    Jqw1+jou6fhFN/fRgBLFTaap8p/VCgeL65FGU1u+k/+LDmlAw+K+UAzugHjBqFdD+VAMLZ
    tE7A1KjbPztAI7WemYbU040niq24UuiPbgF+5HsJ0+jZKmLswAxMMNJQckCDS3cyj0MB1Z
    OkfUmXWKhULOonU2BzfbKFt36BZbQ9fE+lNlR8fDjkY/5mujHfqsaCWKZDVjEjK17xVxKs
    hOPOmx6HZhmioQknllsKTgXZERidWuU3WKhLvMsA1nJr6hj3duzPEiDnn+ZHyeafGxv7nh
    K2PXRVs6wpqq9HWEnpaAGxTvTE/QXlq2qA6eNUr7azMe+gVjtjTw/L5TlO8aq8CvyJkbb1
    CPKVQF6YwLIfg9VUCE/NY2Jv3bw3T3VMkfcLwN1JgrUOMGAWyLX5pjaU8QaaxqnaqgW6Jn
    Pv42gtxvoeFaydpGDGLBvrkXqkroMKFDgWgLmO8Z+SNrtAbMPe1KQpZmdNldOYF/WS1w3S
    HHc3x/EK4TNTiQ5HJt6W3dKcBuFJnYtA8f1/IYqh/zOyukP6DOkH3gMFpnOpMBsUQMaDX5
    L3bQ192n9abAPKRUlLmx1rBRr1KGshyFFvvgEkkvWEE+b87OjO43dDm/ViNQ
X-ME-Proxy: <xmx:zshFaqjjLOsGkRW5Rw4lS6fowRYvrsxl8xHhjCPVV69rObr2hwvGzg>
    <xmx:zshFao8mv1vBv9NtqGA5QlkcORH2q-nQLZ7TzhY5U3z94cXxmEQ6nw>
    <xmx:zshFakYmTVJx9hKEBTAAGAe7Yzu9K2S1gnyhrlY1pRQlp_qlgJmFmQ>
    <xmx:zshFan2Kh6Ck-Kz4i2uKE4aFWazRNEM8A1zd8oiaxPYyrGYgZDzx_w>
    <xmx:zshFalWw8n55sBIxtV3vfPghx8EE5dhNhQNyihVLRvsVq5PgB5-fJS8p>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Jul 2026 22:11:24 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Steve French <sfrench@samba.org>,
	Steve French <smfrench@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] smb/client: don't unhashed and rehash to prevent new opens.
Date: Thu,  2 Jul 2026 12:07:38 +1000
Message-ID: <20260702021105.3406439-3-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260702021105.3406439-1-neilb@ownmail.net>
References: <20260702021105.3406439-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

smb/client needs to block new opens of the target of unlink and rename
while the operation is progressing.  This stablises d_count() and allows
a determination of whether a "silly-rename" is required.

It currently unhashes the dentry which will cause lookup to block on
the parent directory i_rwsem.  Proposed changes to locking will cause
this approach to stop working and the exclusivity will be provided for
the dentry only, and only while it is hashed.

So we introduce a new machanism similar to that used by nfs and afs.
->d_fsdata (currently unused by smb/client) is set to a non-NULL
value when lookups need to be blocked.  ->d_revalidate checks for this
and blocks.  This might still allow d_count() to increment, but once it
has been tested as 1, there can be no new opens completed.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/dir.c   |  3 +++
 fs/smb/client/inode.c | 48 +++++++++++++++++--------------------------
 2 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88a4a1787ff0..6f8ab4fbf1d9 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -876,6 +876,9 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
+	/* Wait for pending rename/unlink */
+	wait_var_event(&direntry->d_fsdata, direntry->d_fsdata == NULL);
+
 	if (d_really_is_positive(direntry)) {
 		int rc;
 		struct inode *inode = d_inode(direntry);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1dbcfd163ff0..cb489ed09679 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -28,6 +28,13 @@
 #include "cached_dir.h"
 #include "reparse.h"
 
+/* This is stored in ->d_fsdata to block d_revalidate on a
+ * file dentry that is being removed - unlink or rename target.
+ * This causes any open attempt to block.  There may be existing opens
+ * but they can be detected by checking d_count() under ->d_lock.
+ */
+#define CIFS_FSDATA_BLOCKED ((void *)1)
+
 static void cifs_invalidate_cached_dir(struct cifs_tcon *tcon,
 				       struct dentry *parent)
 {
@@ -1961,27 +1968,21 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	__u32 dosattr = 0, origattr = 0;
 	struct TCP_Server_Info *server;
 	struct iattr *attrs = NULL;
-	bool rehash = false;
 
 	cifs_dbg(FYI, "cifs_unlink, dir=0x%p, dentry=0x%p\n", dir, dentry);
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
 
-	/* Unhash dentry in advance to prevent any concurrent opens */
-	spin_lock(&dentry->d_lock);
-	if (!d_unhashed(dentry)) {
-		__d_drop(dentry);
-		rehash = true;
-	}
-	spin_unlock(&dentry->d_lock);
-
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
+	/* Set d_fsdata to prevent any concurrent opens */
+	dentry->d_fsdata = CIFS_FSDATA_BLOCKED;
+
 	xid = get_xid();
 	page = alloc_dentry_path();
 
@@ -2101,8 +2102,9 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	kfree(attrs);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
-	if (rehash)
-		d_rehash(dentry);
+
+	/* Allow lookups */
+	store_release_wake_up(&dentry->d_fsdata, NULL);
 	return rc;
 }
 
@@ -2523,7 +2525,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
-	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
@@ -2539,23 +2540,15 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
 
-	/*
-	 * Prevent any concurrent opens on the target by unhashing the dentry.
-	 * VFS already unhashes the target when renaming directories.
-	 */
-	if (d_is_positive(target_dentry) && !d_is_dir(target_dentry)) {
-		if (!d_unhashed(target_dentry)) {
-			d_drop(target_dentry);
-			rehash = true;
-		}
-	}
-
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
+	/* Set d_fsdata to prevent any concurrent opens */
+	target_dentry->d_fsdata = CIFS_FSDATA_BLOCKED;
+
 	page1 = alloc_dentry_path();
 	page2 = alloc_dentry_path();
 	xid = get_xid();
@@ -2592,8 +2585,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		}
 	}
 
-	if (!rc)
-		rehash = false;
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
@@ -2684,8 +2675,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 			}
 			rc = cifs_do_rename(xid, source_dentry, from_name,
 					    target_dentry, to_name);
-			if (!rc)
-				rehash = false;
 		}
 	}
 
@@ -2699,8 +2688,9 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
-	if (rehash)
-		d_rehash(target_dentry);
+	/* Allow lookups */
+	store_release_wake_up(&target_dentry->d_fsdata, NULL);
+
 	kfree(info_buf_source);
 	free_dentry_path(page2);
 	free_dentry_path(page1);
-- 
2.50.0.107.gf914562f5916.dirty

