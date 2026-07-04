Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ED72EEE86;
	Sat,  4 Jul 2026 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783208644; cv=none; b=VqOiljJlwkJzqGU/W2UxekDJZGr7MpIdPShKbRb9HzkazXxMCtVebi5qf6ZKarRuiG7n9LBR+OuN+o0Pz0475KKdwWV4FdBQVWS7sEb3HnbIgnZkkLFqAB9fEizsAK8H5Sxj1F9A78zB26K1Ky149k2TFBFD9vqKNgRXRYJOFfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783208644; c=relaxed/simple;
	bh=F/dF5b4mbPKddEIujT1nDha0bE8TJxCzuvZOKyQlSWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR0J26Wm+YfZFfJRAco93qE1h9NzabMsl+4ST9DapaKNbXajSapwZzY1apOlGBFUtyAnwbPj1ebL5jGjzgeeKXN302e1GlGgOqlHaXl3WcZlM9shxA1fe0U6rUPehRGnvgiZCMEyzTKl7Xw0IFanOPDcJ3fTYct/kSpy/wDCpf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=DDQ+Trfl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hFvvdSpi; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="DDQ+Trfl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hFvvdSpi"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 80FE7EC0187;
	Sat,  4 Jul 2026 19:44:01 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sat, 04 Jul 2026 19:44:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm2; t=1783208641;
	 x=1783295041; bh=/7nHZa71UwoDIcb8Pu/N8eXwmypjp2fLQAbaBD5FjP8=; b=
	DDQ+TrflSt4fSk/Ys+pFOGBGKSGRepDdYCMAcWC5cBcFnbd6PVLIeVgkbqXS7njb
	ZHrSrDmZ2y/OWnu7CAkDjRbwrJP83LRu7pKL4NiB3aunEVPih/jAIbu4AY6q0C1/
	NUotXvhps59dmY9LA0mjVzL0GDe7hObcBhQMwiNYjv8HUMrsbnBbrwhXbfwpsai4
	tU5j6HGwyDqWRUm23PXfNvuhw+SWq4HK4t2VdTdpDmRlj4AWSIoI8avgfPQ1kRwF
	GaCwIq3RrL+1GVVbG0+9WYMAQPne7lUoWe2s5zQBmA1vAHGgkebQIIhWJ2kKErWk
	q70kNIQGPq+gVkYObpX4kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783208641; x=1783295041; bh=/
	7nHZa71UwoDIcb8Pu/N8eXwmypjp2fLQAbaBD5FjP8=; b=hFvvdSpi0FPzYmuv7
	MDCNvj9BPcm0LWv6SXsLNkR0j73l/nr3kmDy3jTK3xRTaXAXn1n0Gy3mECt1Venx
	Llt3JgETgn+mQ1A+BREDtE/Zm23lQuebkmbzfogEKmfsswIyhdxYEdG/CHay8Y4C
	HaJvlrsfya7H5byy++bVgrKFZuWZAxw0UTEdB7dSjTWcZx0WDfaBqMK/0trV0Np1
	sUQBdxx8OkqHxIkFHWGMYNtZDJY7aPohOxEdmwrHQVCvxzRjVwf7qxIAkqbY0mrv
	Is9ZNkjO9RVhrmyZee4KsXvk+8mm6Afyq3HuHlVN0mxlRpprWEvtTAIirv4rk0Vv
	HV8ag==
X-ME-Sender: <xms:wZpJavn5YEBFzD6UWcQJsGdBqouHv_smlyx4u2LP6UW5sAHs2dIioA>
    <xme:wZpJakVPDW8Leg1jMd-50gK4isGOI9fzLn_u0CEDq-77JbDq-VwCZkwpW9KKe1Uge
    L80QZMLCHKO93iPjhgcKb80sUEYFrBr6JntsPtlAdT6gWAO>
X-ME-Received: <xmr:wZpJalt7lFzFferlY6H04MnJK3vIb6RlquLnymo7llCN2nzJsAoIAvhwA_uCL5wsSefOZGyTdqLKa-oQpbgpO0Gsj9Thu4E>
X-ME-Proxy-Cause: dmFkZTEO5dRXSqJvvQqPK9YLP1e4rkpUyEa/sOUM6Ze3bsjUJjRzNN46ZJ9WRBVLaTM3kH
    /Z7pPIYb8/NKmmmfDYw9n7gOS/sRi7KSmQSy85cs+/cZj5XWF80b9P8nxVnVOkDXWOF1yT
    Nb3vz0DXDjv0+iXn+uZzO8ReD4Y0dSvQCN1vHrsUI2v/gvs0ryw5QinGTXBsHvvz00ClI5
    s4PWHtebsOmLZyjDmwYigI1dHptzfEzPfCDFtQ2olJJoIwbYIKvgiIhu8ziWm5nK45Xy2F
    a34bWeZ0I8pwI8L6rwcB3IyC0yE8q6+451+PudVtTMPDb4ndxTS9n2K+hdlhO3/f1XTiqK
    2lA77gKqLiy+g7dtembwVUkXr0/KiOePXGnab3f10NiyZ+9mcM4LjwSU64LPnRUtFRyIpN
    9aBYm5v5AoO27VTyx1YQVZSBmA7yNsW+yRqErR1OZI3rTRkh1iJSjMw+oZ8BseU9Zng6ME
    KTPoAo1Px98UHXgfAUiQyruUAEDJ3x/NsB9PApQhjIvdcYnQpKsnPoOcey26stDUga11FM
    +xxlUL4rqWG3LBpjTlOtRyrOJe7kfhlyiFqNwSY36jPCL6lI9MQ4WdbaCHsP0sQGAI3n32
    ZF0kNPVJvFGOqNc3r3uzL1ipXglgv1zCG6EdEBbt085M2pdj2Xft0Z10AaLQ
X-ME-Proxy: <xmx:wZpJanah7Hcq-zDcMQ-cWek-FQnXlKOpt_ihtL4TVmh-A5aWzFOxnw>
    <xmx:wZpJakUL0iuUyBeiJImHJ6gCrThQ-1Il-aknn8CYm9deqso1RrnhNA>
    <xmx:wZpJasQLnI8-5wKXCPerI7n0ptw-TMnEQjH1xXWlap1MsxdGMX5w4w>
    <xmx:wZpJaiN1dnGrw0yTX9oGOqMk4dCfHD1AKpaXJqy1SOTOhnC2TlYz0g>
    <xmx:wZpJagN5wmUf3RrR6EVGBnZA6Ma0YLKqkus8grpn-fFMGweSBW1zNalT>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 4 Jul 2026 19:43:59 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Steve French <sfrench@samba.org>,
	Steve French <smfrench@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 2/2] smb/client: don't unhashed and rehash to prevent new opens.
Date: Sun,  5 Jul 2026 09:31:42 +1000
Message-ID: <20260704234339.377234-3-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260704234339.377234-1-neilb@ownmail.net>
References: <20260704234339.377234-1-neilb@ownmail.net>
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

So we introduce a new machanism similar to that used by nfs (and soon
afs).  ->d_fsdata (currently unused by smb/client) is set to a non-NULL
value when lookups need to be blocked.  ->d_revalidate checks for this
and blocks.  This might still allow d_count() to increment, but once it
has been tested as 1, there can be no new opens completed.

Unlike unhash which does not need to be reverted on error, and which
must not be reverted on a successful d_move, blocking of opens must
always be reverted.  So we don't block the open until after the last
early "return", and we always unblock on the final "return".

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/dir.c   |  3 ++
 fs/smb/client/inode.c | 74 ++++++++++++++++++++++++++-----------------
 2 files changed, 48 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index bd9684b61c2b..737e2c668d5a 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -877,6 +877,9 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
+	/* Wait for pending rename/unlink */
+	wait_var_event(&direntry->d_fsdata, direntry->d_fsdata == NULL);
+
 	if (d_really_is_positive(direntry)) {
 		int rc;
 		struct inode *inode = d_inode(direntry);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1dbcfd163ff0..aaa9f1c87206 100644
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
@@ -1961,24 +1968,34 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	__u32 dosattr = 0, origattr = 0;
 	struct TCP_Server_Info *server;
 	struct iattr *attrs = NULL;
-	bool rehash = false;
+	bool unblock = false;
 
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
+
+	/* opens might already be blocked by rename */
+	if (dentry->d_fsdata == NULL) {
+		/*
+		 * Block opens.
+		 * No locking here as all that this guarantees
+		 * is that if another thread tries to open(), it
+		 * will either block, or will incremnt d_count()
+		 * before we test it below.
+		 * It also discourages concurrent opens which, being
+		 * path-name based, might try opening with the
+		 * old name after the silly-rename has completed.
+		 * This is not a strong guarantee though.
+		 */
+		dentry->d_fsdata = CIFS_FSDATA_BLOCKED;
+		unblock = true;
+	}
+
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
@@ -2101,8 +2118,9 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	kfree(attrs);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
-	if (rehash)
-		d_rehash(dentry);
+	/* Allow lookups/opens */
+	if (unblock)
+		store_release_wake_up(&dentry->d_fsdata, NULL);
 	return rc;
 }
 
@@ -2523,7 +2541,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
-	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
@@ -2539,20 +2556,23 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
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
+
+	/*
+	 * Block opens.
+	 * No locking here as all that this guarantees
+	 * is that if another thread tries to open(), it
+	 * will either block, or will incremnt d_count()
+	 * before we test it in __cifs_unlink().
+	 * It also discourages concurrent opens which, being
+	 * path-name based, might try opening with the
+	 * old name after the rename has completed.
+	 * This is not a strong guarantee though.
+	 */
+	target_dentry->d_fsdata = CIFS_FSDATA_BLOCKED;
+
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
@@ -2592,8 +2612,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		}
 	}
 
-	if (!rc)
-		rehash = false;
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
@@ -2684,8 +2702,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 			}
 			rc = cifs_do_rename(xid, source_dentry, from_name,
 					    target_dentry, to_name);
-			if (!rc)
-				rehash = false;
 		}
 	}
 
@@ -2699,8 +2715,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
-	if (rehash)
-		d_rehash(target_dentry);
+	/* Allow lookups/opens */
+	store_release_wake_up(&target_dentry->d_fsdata, NULL);
 	kfree(info_buf_source);
 	free_dentry_path(page2);
 	free_dentry_path(page1);
-- 
2.50.0.107.gf914562f5916.dirty

