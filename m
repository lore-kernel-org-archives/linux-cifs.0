Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C957E356A38;
	Mon, 28 Sep 2026 01:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558926; cv=none; b=Hsd3FbSXF81GrrxQSLtVwwJk88JtMRc1YGJRVm+ZDGKiFCuM5iOBU0Pgj9X0d2w5AMyVCBld8gbhhe9DTVM2FTRSpopcHGPrumXLkomnXQsFVRJAwr2tezIL0gO01JtkmxYD8W7Ha0dsy4TYRdwqR3XryHrg9S8qs7tWb0fn4o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558926; c=relaxed/simple;
	bh=qZ72wdExjBx4qrtjfaaWj2pii5nFIYx2zoF3b1K23B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMgOqthEcvOq3zBrv4zEz2VRSaPTqWSwFCGBbPmuej3SFgiwDvZxmir8aiDBNXuNuNwq4EHZ/cg0bdRudoWY1ZpyQOuaTApjvqq4ARkiq9UU4pyfDkt5pYn22sNT77pv2i87MdCWAS5QL4QhwXYndCrBYKG9d0ePZ5gOWfUKyqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=ln5ic326; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZoS30Oou; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="ln5ic326";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZoS30Oou"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D65037A0063;
	Sun, 27 Sep 2026 21:28:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Sun, 27 Sep 2026 21:28:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790558923;
	 x=1790645323; bh=erGK+AQzk4TXbJHojiBGhbq9S7OkazCWMpV38tG+cyY=; b=
	ln5ic326jEvIO1PS1LR0Iyi40LcclgKcudtnMSdgMUuCTZcJtF82CkhTZhlyzU0W
	xJgqlsT0w6zqnBGY3Ztl1O2me5jxpx7T7RtSR5fhHh3XYxfGqWPQyB2p9FjYGSqo
	X1x8SVx6sgwrN7voV8w8qLaV+L/IgIGnoRHIjKUFuQVmV/R+xP1j0vW6OZbiFMpn
	/cJkGRDe/XmeNjV3Q7Q54OX9kfnatE4Xq8zJOK3Nbl/hfNiRp5uXEWMsPX80hOA4
	zIbJEw/ScYKearCqz5irNcdm1Tngt8Mf2egvMXOCyU0XOIM2nP4zBIyUCokIYlm8
	vWnSGvwGnBWVZKrRPdYbfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790558923; x=1790645323; bh=e
	rGK+AQzk4TXbJHojiBGhbq9S7OkazCWMpV38tG+cyY=; b=ZoS30OouA8InCvTI7
	/IA/d8wWAgPRsOKlPmCgTtQ9iLUx40qH9IzWzIdPpeV5Al2OC24dvulgzxL0wdtQ
	jFhgRBbEzIzyd+KqPO6kMRNSLZVQl9vnnRr9F5k0UkEDrMLt16oX9M9hgMvsKS7Y
	yUfY0n9DnNRxMLIB8rw8fhz0D+zIG+EO7JEuZv80tMhE862q/4WvfPh5M9vL0A5N
	G3ETq+N+0CtXWWI4IKhU+afcgFWeZK3TTvbCiBQK7lMN/H2jTDDyfPni7l4G7bIW
	r+hydagPOyUt7He7TD43NuxPYmAApv5AGWdtwvvB5hi4fMBY5vqZrlBhXV305EdP
	p9kVg==
X-ME-Sender: <xms:y8K5ar9Au_6CZy_qlw7KKBIC9GCfvwtYFHjB5rzGN3gN-yDRhQXi0w>
    <xme:y8K5aqwsbzQB1MD6Ruirb7zmcbH3PndEkGIrNMV_CFEB-gJ8j5CV1FYdBXdP8bHZL
    JcHMd73W8CkRPIxAT0ZfnP48rCK-rOLrvgTbTY7DuicsjbamACT>
X-ME-Received: <xmr:y8K5ajplJujKyWWe2ejg_oJdvUYi10w47WYSRiU1LXBkT9iB6bXXCaFKfXNC_Muo0zi2kuA9z7d_0rPj5ysm6l99hDAUhpo>
X-ME-Proxy-Cause: dmFkZTEo5XpDuYcFbgku1MpxLrtlAwn9oABQiqTHUUsYGNkTkpjNR1FoAv+g+LSQLaDYOj
    FwGH3NvRNteiumxt1F6Cp/2rGUKUvMZuLPGG0GnGBjAOs/QgYPZC/bBdtw9Zv0Ksy2JF90
    tuPjd78+GZH8BIhKu53k5StZKk1mRgGOhpyEXB3DuVVMf4LwggW9Ea8/JevZ7QwaWWJV6o
    SiS5wQHhkj0btG9M0UWaWiU6MPJn3I037+6FShebRcIBMY/3oesNf2QiHKI9HbGig861FF
    EAdciql9mo1y6FQjW/1ajz0TvW9Xg4e9YuQA1XOaiJlH/3OXtturskljpXM2Qfspbb2SFs
    MtL4dCKtuCyI68qLSifEBP0NNdZ37NpPz/TNBcUgfebQBfWQ3bD0GL4PWBl4Pjo/+m2z22
    tUoci3jDoX3xXh1oqClwu6B0Ky2YAx604/v+oEK5dTwRXBhcL3AKZKmurIylLkvuUQ91VC
    f5ez6PP2NsJQPoqHlp2oeiLaOp0SdhtBB1yrK1DUwfsw0UtCFHS4DttuD6UpWQBFKZIW2H
    LZiRppaAA02TB0HvsRXoWbx3U1Qd/LPDTDdrvQl+WVVLVVu6jJjie2GIYkaiHC1Q9OqHvg
    Hd3vMqwfnzkJLd6z/d4xX30TFe8ExHo0vwPu49aG4hpBlGLtDJ0YKsIGVZnQ
X-ME-Proxy: <xmx:y8K5ajqtxc3SKbqNzu3qL_wm15JpQjFrElIxoGHECVI5EdnaMQjSLg>
    <xmx:y8K5arBGBcgFezMFvMP-DD1peIxWkEP5fPKlk_36MI8FIODdfQHa0g>
    <xmx:y8K5aptJc3TqmfbVIDMk-jIvVnSxkBBz9NavNFmlHGkdxm0Ri51e5g>
    <xmx:y8K5aiJblvfZZYnYcmQgbWCDMQhrYxvAyjGzSD09s0FF6i6bLuh3YQ>
    <xmx:y8K5audScpVyZEZHM-4mnyjDD4nnRl3untylIzaatfGpUFMFM_vrUjDz>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Sep 2026 21:28:40 -0400 (EDT)
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
Subject: [PATCH 3/3] smb/client: Use d_alloc_trylock() in cifs_prime_dcache()
Date: Mon, 28 Sep 2026 11:25:04 +1000
Message-ID: <20260928012812.2890035-4-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260928012812.2890035-1-neilb@ownmail.net>
References: <20260928012812.2890035-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

cifs uses the results of readdir to prime the dcache.  Using
d_alloc_parallel() can block if there is a concurrent lookup.  Blocking
in that case is pointless as the lookup will add info to the dcache and
there is no value in the readdir waiting to see if it should add the
info too.

Also this call to d_alloc_parallel() is made while the parent
directory is locked.  A proposed change to locking will lock the parent
later, after d_alloc_parallel().  This means it won't be safe to wait in
d_alloc_parallel() while holding the directory lock.

So change to use d_alloc_trylock().  As d_alloc_trylock() includes a
try_lookup we don't need both.   Rearrange the code so we can choose
either a try_lookup or d_alloc_trylock.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/readdir.c | 50 ++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 32a75afca8f5..19d0c77046ab 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -77,36 +77,34 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 
 	cifs_dbg(FYI, "%s: for %s\n", __func__, name->name);
 
-	dentry = try_lookup_noperm(name, parent);
-	if (!dentry) {
-		/*
-		 * If we know that the inode will need to be revalidated
-		 * immediately, then don't create a new dentry for it.
-		 * We'll end up doing an on the wire call either way and
-		 * this spares us an invalidation.
-		 */
-retry:
-		if (posix) {
-			switch (fattr->cf_mode & S_IFMT) {
-			case S_IFLNK:
-			case S_IFBLK:
-			case S_IFCHR:
-				reparse_need_reval = true;
-				break;
-			default:
-				break;
-			}
-		} else if (fattr->cf_cifsattrs & ATTR_REPARSE_POINT) {
+	/*
+	 * If we know that the inode will need to be revalidated
+	 * immediately, then don't create a new dentry for it.
+	 * We'll end up doing an on the wire call either way and
+	 * this spares us an invalidation.
+	 */
+	if (posix) {
+		switch (fattr->cf_mode & S_IFMT) {
+		case S_IFLNK:
+		case S_IFBLK:
+		case S_IFCHR:
 			reparse_need_reval = true;
+			break;
+		default:
+			break;
 		}
+	} else if (fattr->cf_cifsattrs & ATTR_REPARSE_POINT) {
+		reparse_need_reval = true;
+	}
 
-		if (reparse_need_reval ||
-		    (fattr->cf_flags & CIFS_FATTR_NEED_REVAL))
-			return;
+retry:
+	if (reparse_need_reval ||
+	    (fattr->cf_flags & CIFS_FATTR_NEED_REVAL))
+		dentry = try_lookup_noperm(name, parent);
+	else
+		dentry = d_alloc_trylock(parent, name);
 
-		dentry = d_alloc_parallel(parent, name);
-	}
-	if (IS_ERR(dentry))
+	if (!dentry || IS_ERR(dentry))
 		return;
 	if (!d_in_lookup(dentry)) {
 		inode = d_inode(dentry);
-- 
2.50.0.107.gf914562f5916.dirty

