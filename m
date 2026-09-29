Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B792F547066;
	Tue, 29 Sep 2026 02:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649880; cv=none; b=j7zDIw82Q+c+63WN+GBVDa4iXMfECOdY5Z7Rrd0CwTgqoOuyBs1bpbS4nXy2FKf5U/wMxyZ1zFoxznSwvpxE3OasIsidLbGFBlPV5Icsicx8rt2tqtyKYHzrsuqz8h1di6D2X0Y2+vsljVoaCwjCaU0HV8sqNx8QORPANB1Havk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649880; c=relaxed/simple;
	bh=qZ72wdExjBx4qrtjfaaWj2pii5nFIYx2zoF3b1K23B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGMGqR8qF8PHXBfq0UldFMVnVQzM1qJ5s35BogesZ3zgzDbwX+8qKuW5MG+R0vrfF2uRyFVFLEy561G1z1vU8VzssAmJQBQcokoOEth9aB5XW7UenapmTAWmCyblwG4Rjm1EHNfCHFEEEYS7zVGzanZ9ZCrlaBPDMt5K4iQPyn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=TWq6DSo1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hLJZTOXe; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="TWq6DSo1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hLJZTOXe"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C21A07A008A;
	Mon, 28 Sep 2026 22:44:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 28 Sep 2026 22:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790649877;
	 x=1790736277; bh=erGK+AQzk4TXbJHojiBGhbq9S7OkazCWMpV38tG+cyY=; b=
	TWq6DSo1LKqO1he14Qz3Kxy3Dh4k8sEXRAmlUZ3NHC9Et+XhBI3hvooadspqQM8c
	xfRZ54RGTxrusgUVagRgxMdaSQj3iHcIl88wntePGWCwf0K8tyjvsoTW46/jukGO
	sYVhlIHyfrAYFONmUl2uA3JcUUUF3CSif1MZasf0BCHJr3YK7w13kPzS8cpppLJb
	GpvT4UkLmUGd69OMEaflidCNmbWTwl1T42/zSfJqCwtDgicRc+2QHqfxWZY0IzQ8
	JmrKtdTir4esbP5kMfvMzc0AtmAmPwJ+CQJu5Tfe1UBPWNmNSgEJ74NrTrPkg/II
	8esJsPqP/WoYcmOSMxavWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790649877; x=1790736277; bh=e
	rGK+AQzk4TXbJHojiBGhbq9S7OkazCWMpV38tG+cyY=; b=hLJZTOXe1DRUuyYr9
	opmdYNH7yes2mosOcB4jPq94b64zfGOSp2T8ScjccFswkah+Gx3u5opSIerYFUOC
	aHyD01WAsciLBKHO+7YlH4tYJ4p1wOyRvJRoOS+bSJLwr0fxHTZ9oWyw4h/cDnJz
	Mu3hHWZR2XbLhhf0hiRwWxkoxUXrKsglt+662eDd0Sd+xdo01RM+C/GeXs07qpaY
	sgSuO0Odv+6d6p9gDvPcVeJo4t7fCDHXT6F1Fcseh5WKlaq7z2vhoZM2ueI0LX9T
	+EQs+Mf1wshH/WHYIdJAuJF07N4lCZXxrh9q7JiCgBrI3Ox/ALqhgzc9oo5YTbMn
	5g5fQ==
X-ME-Sender: <xms:FSa7avwUXgnkUymSgDB41lMBj5kI95v2uTVS_wxhIUEF8cWF0Qs3PQ>
    <xme:FSa7aqVYrpThwFqxcZ3TS06-kyejCd8XZn_QVPmqdB0poQrlgK54_SNGnppb7w4hD
    LHmxzaMZq7pAoUuzPqYc7y_-BqjiZQjLlOXC0pptt2dsbT3t7k>
X-ME-Received: <xmr:FSa7aj_UGRwKXstE_fxUE-ICY-8veD3UtxXx1fH4LbJZLcniAyaq2Ljqj1cPfo_rZLUNw3GPy8ja6nNtICfiQjxR-Mi69zk>
X-ME-Proxy-Cause: dmFkZTGAETtLDaRhdK6zWwmD1skNo8oznbv/e2xQZSM2ujkSFd8PU+upR8wF9a9fwoqrPi
    faFoaFPojV/QsMDEtCK+pCBky2JCKDOeWUD5950YGVNewPYv1IqWWG2tHJT/nOvQXrcJ2C
    /dpBuqeOPU2uOmbufh4kWWa+l7OFQMxu6h0qLmDFlSzqkcbyXgnWtP7/5Hlg9k5TDoNx7W
    Lnhj8TKJndVGVDvl1jI4nKhIHo66v/mWkc8wAAFi0DtOQRMaKIvR3BY7zTw13iHmHBEtzh
    xF5p/hKrSHHFxZfSHEj+9lI/7B/SyYuQzS+5bRvoY3OjIJ4y7CH2qWNNwosk4t5FaLNCVQ
    mf9Lcmwy1jHDkSW/PqO8yAz7858yqELRnWeb7RCG2qLFUONp+k+eHsUfeFj9JbQcTobZlv
    hgM8FivAA/wRzuuepPgqyH6dapqiRHMShGMZqWRQQRnLZjW+IOGarodZe+XeiT4z/bhWuY
    72HmjMJmFKe5EnCJ6L25JBMiFQzf+hOe0VrxbUhE4yiEoMRbnduj38epwX1Na5w2ih0G0i
    PpGhMTNwvruXPoIdYsWA3OPqXN8Si3Tk6mt7Yg+BZQovzNxlZOZ9IEKOYMOJL3bSx//bz+
    B27M6Uxwx/NoDGSyFdJp04evSBCa1MPuRB0iJce/VhPXF2xTYfwp2Ib+JoKg
X-ME-Proxy: <xmx:FSa7altwxlDL-R5ntVq7cQbPJuJZmO2NS8vvt3p5-fhUDIr6zN2tlA>
    <xmx:FSa7ar0BFL_qQX44x69x1alSdypo-tpxnOXW5gl2FRKuMWAoqMfe6w>
    <xmx:FSa7aiScwpdmkvazzEyDphZgu6P2WJLC6z76JdnD6KzMn7S6WiTBUQ>
    <xmx:FSa7aneVzygsxmLcwWbN-ePURc-yjV-X4B2nDgflejC5nQigiJPNoA>
    <xmx:FSa7ahigGvXu0uw9FpMgv11EJU-g3RBUacJ7EqFiMxqeOMFG6HC7d89f>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 22:44:34 -0400 (EDT)
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
Subject: [PATCH v2 3/3] smb/client: Use d_alloc_trylock() in cifs_prime_dcache()
Date: Tue, 29 Sep 2026 12:40:03 +1000
Message-ID: <20260929024352.1433257-4-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929024352.1433257-1-neilb@ownmail.net>
References: <20260929024352.1433257-1-neilb@ownmail.net>
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

