Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792719998;
	b=Im27WMPlVC26bNvgsftjsSW3DAkT7qzCXA37V281U1w4mkr9pDWFeYSKr+LGL84DsEV+
	 rY210N5aec7Se9o91iXVVadJlbYAmDJNZJIYoXECTglkZhtx5J2BKP/1xMyJtEb+Pavey
	 HC9lRFe8JxwEmnfCYCkGCC6MiFnmnod3vFbzXs8baMRUdhPShuUzquCm2k4E4ZYAMcymg
	 SUrG4HYO0FGCRv/D+JrWfE047vfu1/FEMZRkm0r9iTtEwhsoT0gXjhm6WATAjZU0LR5D+
	 hn04aDlqfcY9yVsmwx+DyNck00i/EbtHZ21gKY5Cs1Y3YE/xIKDVZVdlQ7oBFf6MfXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792719998;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:Reply-To:MIME-Version:Content-Transfer-Encoding;
	bh=uuc7z+i3OaA9Ga91YWV5yVCqvwq8DhToUpR8giOlj+Y=;
	b=xX8RzAPe1kCu7YZ0bvOsGiiTG+IW7W5vrAB1ppSo8p5rk8Mttt9xA7XNkuG21k1yJ/xK
	 1CO1jyYlaH6gUbw3MsFdR1WQrt1WdBZJzkaVzXqQnxnPtfx04ovTp9c3yIc8veJBrMQt7
	 2A06+sN/SN0+wueMlWfYOv4OxiuZDTE/cvEQ2B6Vo7i3IcWpntHrLmneiCUlwcikBBeOp
	 wVfAe86zEa1V5HBEP6wGzvo/J5Kwhfj4A3XVLb9dzp7xKj4OUvL1Ah3Tqn/3URS9Dv4eJ
	 S51CwtsiYPEoOoTjrFEOhgl71CYXeqTTE8DYdvs4PKQHw/+D3QuUfnbYbd02fklxk0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ownmail.net;
	spf=pass smtp.mailfrom=ownmail.net;
	dkim=pass header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=F7FrXXl0;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=QpBm7PbJ;
	arc=none smtp.remote-ip=202.12.124.146
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D789606A31D
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 01:46:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D789606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=F7FrXXl0;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=QpBm7PbJ
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 877AA1D001AE
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 21:46:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 22 Oct 2026 21:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm2; t=1792719996;
	 x=1792806396; bh=uuc7z+i3OaA9Ga91YWV5yVCqvwq8DhToUpR8giOlj+Y=; b=
	F7FrXXl0cMAiv2FInxqHmGAgx/u3vme4x+plw1eUcwOgU8abIrI2EmWwQHqPe7bT
	1U51gLMZMpy6+AFLT3ZJ2ZLgRfvbehuFm1vJYgNz4qhBL9nxMkvSJPfev8NZND6o
	WYbdUpnnb/Ml/swttVSXit9CSUuff7YwSBAnOCyj9ukVEC8rwxvcGCQlw7EvYfAS
	LGoUx7RwWZ/UmiJ3xgZ+/cFGDCPC+SHZF2G2Np0TO4EPmtKoCi1ZXqK9I9pRAH45
	2pkmT6Uv3312THnSn7Y4grKjg+PoOuefXD0Lac2KEd4dYgvui3fEOINcvO/lUJtp
	vDkLBHJYhXwsAOaoysUPaQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1792719996; x=1792806396; bh=u
	uc7z+i3OaA9Ga91YWV5yVCqvwq8DhToUpR8giOlj+Y=; b=QpBm7PbJj0BMDI8w1
	VrD+JM1sZ5w2U/YcMjmNN4hDJ2Q4jhGuYgxI2lGzccZ7RV/mI+0Wcuxf9ikb984s
	2Ej4J0ZZu9gKnRAc71EVCw8pQiAw2ISb6uJ5q3miCNSDzyaZx1VWvGYNduDglL/n
	LAnMFWh47mtvxPTGHE9OYuNvA+nh1e84DvxJ/dOAo2b2ejRxGqlGLQ58ehwq+Rlu
	EchR4zROhCxWRs5yrquJCrjjwlLQhRFEHkd5d/mYmL8LRnapouZf6Cn1q5PPIHgA
	HlzCeUvvFrVO4iD3AVLhyM8U/mcGgMxKobGBXL835nmKR3+GP1GjPR8Een1j9kw/
	t+DKg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792719996; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:ATZj1xlY0jg9YsoszY9mJfgCD0w/3tf/bZBMqIOwSddixeB
	MJ6J99pRHaEr0EuSz5t4bOejtCkBY7lUdZ3/SMxe4e+AJQLYn1+DDNDgyyUsWXvx
	QdbUmcVA4ZRssBwXhrQPmaykYo0V0EN9x0eFnrowPkBpXMDmHtfab429VfCVbQxx
	QC+3jDW1AFAbiGpFFyZJYKQA/sd856o0TtER82by8KU3AYVDEYZJX5KaOvNSnrBF
	b7ALRBFwe3/QuCvfIOazsLg/+1nholQxVUY0eUv0gLRXfxlrhrFJBn5iB6KdPhOi
	g1Uo8A9JKJTiioC5Fj0xEZQmclbozqlX3++rxJw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,reply-to,subject,
	to;
Message-Instance: m=1; h=sha256:fc5gv6Rpz93VOLMyyGAWCs9vFH5j3DSZ5axu9uyTvQI=:n8n41v6lERX9M8ikQ/ANJB/A0daLXxUpkSVIE9kh4bQ=;
X-ME-Sender: <xms:fLzaak2-8zbCdnX3ru08_bq9CT8iwgssqBkaW308NLk5Mm0w-S_7ag>
    <xme:fLzaaiI2MsiArPjBwNSrfTeTQKnlfTaQH4e8AVCswLNxgVbsygz9gQaOEUkAhLFNo
    IMiYWBbjQtv0u_fWPKaImrtHVYATL-g6vPy2cqpoJXpu36H5X0>
X-ME-Received: <xmr:fLzaanhweRl19z_VTnA-5VF9fqRdrhvene5gxMmSTQpcHjbym2apQ9QLkc5sWWDYiwsEI8cSGiMLBbTXUTNR9kFwDYTWwfw>
X-ME-Proxy-Cause: dmFkZTGIvEnf2Th7X2Oi7hWodsjoWDPm8osLzyiWFkT+1WrqV4GWqpbbj9jlKTsoQCAQ+V
    M67SqmEAn84TLmtm4ACXe3jiHS0ENhF1RLgsH/2p8mIU45KV47yZDb39ikr1X43iA6byGk
    V1LxEwXXKgQ+NTyjAYyzFbdm0nceX4uiAUq3AQ0Gu+ZiKGi9rB8emb8wSU3k0FnXZEdtr+
    WiEz/dW8cXNpjbWMmEMsZTWvqe3QtsxBK5thmMAFzmuNk9/k6KQmyG3H2d0aNK9gR72V49
    EcVNML0qZ8Aw1eY4XNIg74h+/WwcYLkRzUCPNha6wapC8hOLmqzgVXUpZAjOs13tUt4vO8
    fY0YR7vKaIuShpdQTSew8usfWD1031ew7oUu0hjqwTD/Cdh9e3MgcOXxO3rSg+2WuMN6xw
    Y45f7FaaY8RCMCpTBMg3f+3BNCz3HKnsizt503qjVoBpAfCScZgJ67OajklFrDnRB0s8mC
    JymznWv97bmZ9x+ndG9mzguSEU9vZBPkAyxpW4PtFNVA96btdaxdht3u8t5DZbCn0Euuzh
    rvSFLbAWPZj0fwCudJqEtMGRb/5vP6F15LQMAdOzmIqwtIbLzNvU/zhrb8EMNGXZyI2TNy
    y4o0iZK+cGAK2oK6n3Zm1dZ429fcnU4e6iJRrSdYlOhgnIwQOXpGpFjSsTgg
X-ME-Proxy: <xmx:fLzaaqAqY4vVv0TWGPcYJha5ycNYelyH6At43LRUgvjSInlur_YtAg>
    <xmx:fLzaah5PxRCoh3ObjRvuL53HJegexr6xqOAAdgv6hqC1R1HbYdW3uA>
    <xmx:fLzaanG0MR80R3R93c5pz75k-IUxCMLe2wXUNWuCr7xAy-il37d_ig>
    <xmx:fLzaakAc7s_CBWkOpPBHE0tFQllfUwDfW-jSjG5YnH3v95U2Uj5NKw>
    <xmx:fLzaaq22Mm6E6Jka3gy91LOeFhejhABd-Ys9AvPrUYjRCuPGAniMbN6n>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 21:46:33 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] smb/client: don't unhash and rehash to prevent new opens.
Date: Fri, 23 Oct 2026 12:40:23 +1100
Message-ID: <20261023014211.2120871-2-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20261023014211.2120871-1-neilb@ownmail.net>
References: <20261023014211.2120871-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

smb/client needs to block new opens of the target of unlink and rename
while the operation is progressing.  This stablises d_count() and allows
a determination of whether a "silly-rename" is required.

It currently unhashes the dentry which will cause lookup to block on
the parent directory i_rwsem.  Proposed changes to locking will cause
this approach to stop working as the exclusivity will be provided for
the dentry only, and only while it is hashed.

So we introduce a new machanism similar to that used by nfs.
DCACHE_PRIVATE is set when lookups need to be blocked.  ->d_revalidate
checks for this and blocks.  This might still allow d_count() to
increment, but once it has been tested as 1, there can be no new opens
completed.

Unlike unhash which does not need to be reverted on error, and which
must not be reverted on a successful d_move, blocking of opens must
always be reverted.  So we don't block the open until after the last
early "return", and we always unblock on the final "return".

Strictly speaking it is only necessary to block opens before the value
of d_count() is tested under ->d_lock. But we block as early as possible
to discourage new opens from starting.  As open is path-based in cifs a
concurrent rename can be confused a rename of one other the paths.  Once
cifs_open() has generated the full_path it doesn't hold any locks to
prevent a rename from making that path invalid.

The important details of the interlock between __cifs_unlink (which both
unlink and rename use) and "open" are that __cifs_unlink() sets
DCACHE_PRVIATE  *before* testing d_count() which is
in a d_lock locked region,  and cifs_d_revalidate() tests the bit *after*
->d_lock is taken by e.g. __d_lookup() to increment d_count().
Thus ->d_lock provide serialization between the set and the test
even though the test isn't in a locked region.
(The fact that cifs_d_revalidate() always returned -ECHILD when
 LOOKUP_RCU is important for this sequencing to work as it ensures
 d_revalidate() is called *after* d_count() is incremented).

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/dir.c   |  3 ++
 fs/smb/client/inode.c | 68 +++++++++++++++++++++++++------------------
 2 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 2f6d769a9c83..4b0a402a6991 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -896,6 +896,9 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
+	/* Wait for pending rename/unlink */
+	wait_var_event(&direntry->d_flags, !(direntry->d_flags & DCACHE_PRIVATE));
+
 	if (d_really_is_positive(direntry)) {
 		int rc;
 		struct inode *inode = d_inode(direntry);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 2647785ec1e4..31f9a9ea5ec8 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1977,24 +1977,31 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
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
+	if (!(dentry->d_flags & DCACHE_PRIVATE)) {
+		/*
+		 * Block opens - and all lookups that involve d_revalidate.
+		 * This guarantees that if another thread tries to open(), it
+		 * will either block, or will increment d_count()
+		 * before we test it below.
+		 */
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_PRIVATE;
+		spin_unlock(&dentry->d_lock);
+		unblock = true;
+	}
+
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
@@ -2116,8 +2123,13 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	kfree(attrs);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
-	if (rehash)
-		d_rehash(dentry);
+	/* Allow lookups/opens */
+	if (unblock) {
+		spin_lock(&dentry->d_lock);
+		store_release_wake_up(&dentry->d_flags,
+				      dentry->d_flags &~ DCACHE_PRIVATE);
+		spin_unlock(&dentry->d_lock);
+	}
 	return rc;
 }
 
@@ -2545,7 +2557,6 @@ cifs_rename2(const struct mnt_idmap *idmap, struct inode *source_dir,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
-	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
@@ -2561,20 +2572,20 @@ cifs_rename2(const struct mnt_idmap *idmap, struct inode *source_dir,
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
+	 * Block opens - and all lookups that involve d_revalidate.
+	 * This guarantees that if another thread tries to open(), it
+	 * will either block, or will increment d_count()
+	 * before we test it in __cifs_unlink().
+	 */
+	spin_lock(&target_dentry->d_lock);
+	target_dentry->d_flags |= DCACHE_PRIVATE;
+	spin_unlock(&target_dentry->d_lock);
+
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
@@ -2614,8 +2625,6 @@ cifs_rename2(const struct mnt_idmap *idmap, struct inode *source_dir,
 		}
 	}
 
-	if (!rc)
-		rehash = false;
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
@@ -2707,8 +2716,6 @@ cifs_rename2(const struct mnt_idmap *idmap, struct inode *source_dir,
 			}
 			rc = cifs_do_rename(xid, source_dentry, from_name,
 					    target_dentry, to_name);
-			if (!rc)
-				rehash = false;
 		}
 	}
 
@@ -2722,8 +2729,11 @@ cifs_rename2(const struct mnt_idmap *idmap, struct inode *source_dir,
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
-	if (rehash)
-		d_rehash(target_dentry);
+	/* Allow lookups/opens */
+	spin_lock(&target_dentry->d_lock);
+	store_release_wake_up(&target_dentry->d_flags,
+			      target_dentry->d_flags &~ DCACHE_PRIVATE);
+	spin_unlock(&target_dentry->d_lock);
 	kfree(info_buf_source);
 	free_dentry_path(page2);
 	free_dentry_path(page1);

base-commit: 864c07de0c7dcbca58b61625dfa2e461ae63b242
-- 
2.50.0.107.gf914562f5916.dirty

