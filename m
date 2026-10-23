Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720012;
	b=ay18MEt2xCSELKAHfXw5R8DfgVNDBrI9f6PxoC2c1JpHbPa0HWfp7fzwCt2sU+5BFQpA
	 1PbunE2KFCa1eNpE+6MQhTQJsouB1oRlZyW5qGmREge8VO93CNzfjGRm2Xd5zPIA5WTHx
	 J0shwX31RWUHG+dW+Xj9Kk8yzaM71sbeT5m5Lh5ETCal66odFH7+HXC93Lq+F1qVsVuB7
	 KXvpVCPEHrAedd+PXWwYvn/UnOxMsGJwbCQcIFIOpJT+34GG1+ImOvcahlwNheLGdDr25
	 UZLVNLQ037UQhadE6BP/qTEz7vo34eAHlr51e2JjzxvP1grXHu3cHh2zcFfmvISXODw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720012;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:Reply-To:MIME-Version:Content-Transfer-Encoding;
	bh=rw27aMQgAFj2fI6oZl7GaHXJK22x6Yrd83yH8UhPX14=;
	b=b0HVgUTb1TJKHufi1aSiDNo7y2cNdFXDdwoM9w161YNARSS7CnStT/MZsujqKATZrU6p
	 eTSJH/y5nWJTNPGvvfLt+BnCtMpnnvYFMYSkBLBH+Cm2mVa/gXhaCeVXZeVo71c/i+Hvr
	 kg5LSUnC0xkAJJn6pZ3jYUsyhq6ixeq7h7xMjrZ1x8rlVgAisBSbAhqsICdRiAzIwCukv
	 P5cbG2iNtSuw90lEAVcdMgtMnyEJGyWQyqYMNjAECKLrdnRupY4C6MZ7SO5ci4Glbrmif
	 bCtqda0BNmQMyCxc966vwkqEEtXNV3a/qK/8HWbI/KwZbVFv7IKBzn+vygLlv+OVXqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ownmail.net;
	spf=pass smtp.mailfrom=ownmail.net;
	dkim=pass header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=BGp02qbw;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b="McEv4/tt";
	arc=none smtp.remote-ip=202.12.124.155
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BB2606A31B
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 01:46:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95BB2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=BGp02qbw;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=McEv4/tt
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1B6CB7A019E
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 21:46:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 22 Oct 2026 21:46:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm2; t=1792720010;
	 x=1792806410; bh=rw27aMQgAFj2fI6oZl7GaHXJK22x6Yrd83yH8UhPX14=; b=
	BGp02qbwSjThSnVNDRAxKdeCIvpupI2RASe3o6qNZEv1pR6iU6tkqjg5gItTpwYT
	UfMocZ8SEFC8Pjp+X3EdG95PJOIa8M2b10NaP/Z3IJcRzJjHUNnDfE2QhVZZ0M/n
	ZRmqk7U+HmMMtxhuC6gmY+YAIL8pBGr903L95KTWynwC70wnHAGfLTbKCQtL57ik
	kSUC25Hy9gu5l+qld82RTpXKcQzduheaq3WbpPa75PhajOaPMlNSrbZICrLd3ibv
	QIJZwdNrjjHLm1GSBMBDKAAHffFKVQI9E6DMoG5bMgHTfabugMyWrN1c+YE1mfaI
	yhiO9lShT3dmLHvIYfTu3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1792720010; x=1792806410; bh=r
	w27aMQgAFj2fI6oZl7GaHXJK22x6Yrd83yH8UhPX14=; b=McEv4/ttB3RcucziT
	y5BNJFY39/HC900EQSd8oNh6OWJQiY3qTBDrWm7R9TnVtxObPaOHSafoD826GULu
	HdRo0XCATq/ymMsRlk6XdHijLB0lXrnSeUSBs3DVHnPVgZ3DJIKcymS8gDHDDpa9
	q1gyZNVatYVuueRAkl6eJXMvbUEvCOZ6CNayN9uP1W4hKRfylykz1QhdlVeOTQUF
	vKROkgPzl9lFdpIYxXzsiGRyIZAORd/oGRFYCIjmHpdlzPFABByVS+2RdYTiHcui
	PhLEdKN7p/dVeZto7pfCzW7IRSuW3/6QysFzsqQUlROlQxRYMDH6jv6xDCSIgJYM
	donZA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792720010; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:eM8gN+14kEKyvgS5Ve5UEQXNxTkgjL+7tzsOjPFrR+ZVPb5
	ao9Pvcd6B/m9qzBOf7fQR7GXsCtoGB8guNKiTOujlHm9vbfZeeSZTZPaORdILatQ
	8GJ53FIRNMHdqWW+Msy23TTb+kUV5OCJaL71EX8n4iVZIpasKclohdlVvq/WIpt+
	KGwelX4QVz1ZQZqHOx6L+S35Ghkl3fSNtk1b5wQ4sOZF2XwAcu34EGGECg1qPBmS
	pvIO1h2DtQIhwSy7cZ8Z9+3uzzUMCLCRkdVQR0HB/FQcDKfClkK9e7bTikqaRQCk
	yJYuhc8lQin+C0OSVG1DmQMro4klE41Sbr7ZHHg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,reply-to,subject,
	to;
Message-Instance: m=1; h=sha256:7L+Q2bYz836nIzdSsBA1Ywh9GN4LH1TKGFEWfA3wVCg=:yMAH2BNkGNRQdg2sIiN5OpRyXeHS/EKzFFsE+4dgGIA=;
X-ME-Sender: <xms:irzaaigpQudkvTySH9g9144BQFD55E9AWyhOyOte7QkELNnM_eO0UA>
    <xme:irzaamF3erlacin0Fv2UzzBp34F2FwPW_8wem-5uCv2MkFdFydmH10WQiQPeHfILV
    xYFkDD8y0dz5MmNb7bB107YIcAKgjLepYkxAacGwWRDKB28CXo>
X-ME-Received: <xmr:irzaakvS74eTFCDtzZTV87muQ5dhDbLra4k-lfp0T1kGKg5-W1HU5uZUvxe9RIZ_u-RNZGls8rkrzcMGoECV7xKLK95bgGw>
X-ME-Proxy-Cause: dmFkZTGl+xsAtvLsCyudD/GYbjbLiO7mC6fgMzgxHJg4SkelHJgi8RKtTINmUMuQzay/u+
    QVCbOW7bTbX7xJFJgFoaBQOOs3VpBjL1wZprWEaYW8eAxEPUY5NHtX6r+HVfMGm0Z7wV3x
    YG+eZOSoOgy8pNB4Ab5s2DPE74yJ7q3Iy1sTmRHlcpjCp0tgleuh+/gA8Zq8i65BDB/zOI
    FlbyjaqcHgztWkNPGkM4Cm8T//WrdkCcBY+dcaliUVnjPvJiKBAfyu3DelNaFERRhGuMAG
    V8gCaPewMcXEWkz2ujcYLd+AS4CpFFDLil4h8rWlkoWfgVCzldO2B1PEbAcEcEayFPe9ZO
    MxYM0WOgmvEJuAQv2j7uIIzjFurBEU0vaUn4qqXTNMJjPG0hS0543PsJ0SEOSrvriyGP2g
    JVDOIX/Ogr8uJqt5J7vjRJDOyLArdhJTwi9R8VR+rOeyZ2XXPMEjtSTsgvJZAWNFROclIe
    /vI6utZW+wZniqwqarb/9VbgAoLDBBRoba5zddBvmgNqukPBp5cwe0JeeoI+JkXKEMrLaD
    SdzgmAY+cSNRDmZf0SvOxGhTrkybKHxzO9wxj1PmbmCt9vtR1GjjATNgAh8CL03QkEGhQK
    6gL/9avHqdjYE/TDfjucKDu5fsMruSWSIrpQtH0tjt4Sj9dSoYcrh3T1fSkg
X-ME-Proxy: <xmx:irzaandjMhjc_8UP1gUX2bygcqObozbrzgUNmQO6ttTJ137C_P5rGw>
    <xmx:irzaaqmsRQp3nExGPY4sQ-FvRy290V0nh7rlg_LU1G1AwkcqsvhSEQ>
    <xmx:irzaaqBqCHXT8Ma-3OMxAVxVHfn8_v6iioPJx_RsZvNECVKqafrNow>
    <xmx:irzaakPoW_kIDbn_fRsc9D_ZB2IanWVAveCtEnx-losQ2BlLyU4WSQ>
    <xmx:irzaavRkt3WYfEwsX-jLbou_w--0O2NceLy9e9cl1f2Q2TJx1YXg9W6p>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 21:46:47 -0400 (EDT)
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
Subject: [PATCH v3 3/3] smb/client: Use d_alloc_trylock() in cifs_prime_dcache()
Date: Fri, 23 Oct 2026 12:40:25 +1100
Message-ID: <20261023014211.2120871-4-neilb@ownmail.net>
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
index 525f99181485..9e3bc8dd2acc 100644
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
+	if (IS_ERR_OR_NULL(dentry))
 		return;
 	if (!d_in_lookup(dentry)) {
 		inode = d_inode(dentry);
-- 
2.50.0.107.gf914562f5916.dirty

