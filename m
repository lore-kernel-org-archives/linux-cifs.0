Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073741;
	b=bzLEd1JmJiAuy8Uw3R9bX+sFceb3d59KomwBEx8HHv9auwWtfatsyXqHaMbPpOe0OJOo
	 tadBV8ISxBjYSd8K6pdgNQ0WzK7WH1LVJr4JlER08tUYOwXQVE/DZ27RA/dMEHnFA3ZKf
	 j1dQmq0LQFUDebCdLDgeVEWX00n19xbljUXjSF1CrxL54XvrHwOKO6Beb995/TPP9D0rK
	 k1Pf+jrO5uHtD2fUIkwL1FTPtoBNEL9RIPMNJzatstPZ35dsA/3qu0+k4NqwZTfsLq2yW
	 4be3PnccsiDm/ShOFnwz9VzbgS/fvfvH+nkus/DIcuMAzQ77Ih5FeFTIOtlYdBBdzlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073741;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oi0aNVIBMCm8d4UjKD3/O0s9LgNgYotreQH795dQowA=;
	b=cU2qA57UpQYO7a0LJ9ohcWKn9a1fa/x90PJ3ratCAOqsq5VIAvks/RQ3FE5IRkylm4f1
	 hkx6N4wYJ/hCSQ9k2x/qkdg0tzLVhwez6K9TL9Ew4upT9qvrjjMn+vvocAHVlWfibfeUy
	 x9YStTSxW370lMCDOisyXEYn0aic25wC0mRK0iBtFAlcoeaZ/9AW5S14l69VPozJIW9DO
	 cijJImLH24EQLSRKCyKu3EpqAC/V8ESmVNKD3BR2MECma3L1gTYv0owbF+vVsDdVTcnQ9
	 gjyIBxiqxaeTDb021qbyUra2fMnoLp9f20hu9e2kByl0XzzEO26Brwgy6gOU/EPns3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=qIrk9Gj9;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Ne0p2TvK;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D463606A324
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 07:35:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D463606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=qIrk9Gj9;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Ne0p2TvK
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id EE4D01D00272
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 02:35:39 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 19 Nov 2026 02:35:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795073739; x=1795160139; bh=oi0aNVIBMCm8d4UjKD3/O
	0s9LgNgYotreQH795dQowA=; b=qIrk9Gj9SKkbn21jzQqcCaRG+CDEz4iT7bmzw
	WKkVSBHc16ZtcAFdiR8vHnAoskYlVpQI6+wXFBQ3mpwQQOWpi5xJSF8qIGKK4pkX
	eWByc7HPvhQJ2URjmPvsfxxAF2yhUV3CMM6qY0JykeVJSgjq2LwjTtiEmrnCHD+A
	8TyxGLXCh4she3dA0Pq8SvYOxY2SLltBxKwG3pE0hesY1oGgrLqpdCNXPTQKlXqY
	bpGb9yTjbN1Fx6Q0ltaaF5rPfJetfv9mjLzrD3goG3yq5KciBopbgjZdIBwpp4N6
	uwkdGyOUJLKroJW4cIdjejJsOjYl1IxZYNSdLwTcdmLFh1/wA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795073739; x=1795160139; bh=oi0aNVIBMCm8d4UjKD3/O0s9LgNgYotreQH
	795dQowA=; b=Ne0p2TvKZ1QDvBisBLjiwZRIXAQH3r4VROE4RcjwA48MofdZfR9
	Lt7m7rca0so3MudGTpVTEtmbl2fIlIUzdomvONtrzUCQ5KjFQOMtXhTr7mIV/gTz
	F2Gn7fGUTbM+CK/5DdUxnDHqeIw37K5c1cenfoZIL5A/1LxF7ntXr5djiqjzytXp
	Xsy5cyIsNdNKAn4OTFfnNW11AJc+IwjO/3FLHuIjK063dLxJR2ARNmzUCIBzI+nX
	ls7mhHF7V3EPF1bLsyG1PPED3MorxnLuA9HvhjYZaqrykz7qa0nlj5+PEKSdsY3t
	zH4HxbZOZYGpD/dKo7mu+5lkF+evbQ9i7Jw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795073739; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:EESis6qXG3tEfzmsha2l7sSfkBSP3a6UZWIqVs74GJS81v8
	zn53kfQo1Bonx0SrMOTzITxMVhn5vkKS31l1XWgBSAe3NLadHqlh7hcJhnS8SrAi
	RYf0UcLReJvbbsu+piOdzGdWrmUiHo+wN/hD7rEE0+Z/Eqz/0A7jaOOg3/7BUBz+
	gUb4kBQYkSwQPyzfM4SbP2nPwt/j5ye8i4WTaTNuja+iyZ98qtlOwRPDECUHnp54
	yyekao2e1SoKLnwHiXzsd2h3GusNw5FhTgoIY2kTt3RWVBBPAJC9QpwcLIqu9E4w
	Kn5LUmET+6rInNBO032RijpTJ/cgbaJpE+6hK3g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:i4lRE6kRnqMrehNxJD906+fU4MXzmCN80dJV+0vuKak=:Emy2iT/KeEv2BIGFTgfSGrS6ZkMD1uAT/6jyRR3fI9A=;
X-ME-Sender: <xms:yqb-anv38pEbSxMrfy906CVhW6TO6nfo2jHV9WenxTH4cwVpt7lw-w>
    <xme:yqb-akff5x45G-m3VBuFIA9NGQS15UNLduXeQ7Zsx8SIEv4oQVwKWMTOVmWEQcKFY
    en6q9Ay1C_BroGFbVIvi8-zWWA5L4LyvBGzakFOrpsuhvbLwz3o1bkt>
X-ME-Received: <xmr:yqb-as8ri2WoGhXq0X1Q0JhkHAJJ6rFHGSfxRe0n3vxP6TPY8ikKoP37cj1a7pMI>
X-ME-Proxy-Cause: dmFkZTGdM2SSko0BN9tk7pzVunvYEY0ZzuuT7qsrn7kV+2rxI1QfDbD99o77ZbcBPTQjul
    jvrY7bcbsHQSVDFTqNd3UYtAP1mL/Ybt+PAqXxfoAudQk4JTx3ozXWAtghIMZh77QNOK6i
    OlEX7Hrt4wOiMefkY0fpcPXFfY+WHeXOqnlZ5KSh4P+gfk3olQoYfqZMzzGdrSLT3qrL2D
    CaL49EH74j67mx7UWzk5IXsn1qmQ6XzOUWhBmQwseAE+4Fs8PbY45tCd8ObPIIOndWUdMK
    KFqKH7/7zSvJSh5lxp+H95hvpY5xeF/tHoKDMxFpy85yH/IiE7R5srdS5jfC9+DtIvFYCD
    ZjjvnKG25+C/QRB2sCUOzLCVa9ksh7Nn7ZD0rwsEvdw8zYfsY2G7Y3cgqmwpYYMLlDFTKG
    WxbxJmxIepW0vgmaBmUvnzTnlOSj6U2i5Aj6F9RjzJ7TN278W8vLCCITNkHj0RkFMwjlDO
    TaZRRfp4q2jH9ts7fG8TVK/BFktc+hCdwPcLE2hSuxIuZIwX7D1HzZKvfp6eOSJ7oUnuWU
    Xe0/fhU9U95QXy68NnuhRawQP7hC0F9HXA0nPCoRkg11m0mp3dgRfKgXbbE0AJ7vurmGk6
    rxeSqNv1Zw1car8Rt2DfKoL0ZSdVZPjpXLJDKCdGX/Tbtwx6BQaXerzlbwfg
X-ME-Proxy: <xmx:yqb-anSBJV1UvyfJ92eNt3zv4aPhar7guaPSlh5yBf0u326vu92dRQ>
    <xmx:yqb-alorVNEBSn5HgDCOxcFlDowrazfuQ2Y7Q2SjhAXtX90Z-GOADw>
    <xmx:yqb-askGTtDVPj-mrMl0t1XvKhDh1hkEbTgZXeQMgAillh2DkSmWng>
    <xmx:yqb-amepHdwtfZIMulgNBk6PTu6BX3hM6_IFLEKBBGEoBb5eTf-45Q>
    <xmx:y6b-ag2aW87dEOjkpp5OpDNS-iPfHWR57XNfNSrE0dK2Y7hNvXihR65c>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 02:35:37 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: build an inherited security descriptor with its own offsets
Date: Thu, 19 Nov 2026 01:35:34 -0600
Message-ID: <20261119073534.118732-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
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

A new file or directory can lose the access rules it should inherit from
its parent. smb_inherit_dacl() sizes the child's descriptor for its SIDs
and inherited ACEs but copies the parent's offsets. The owner and group
SIDs keep their sizes, while the child's DACL can be smaller or larger.
The parent's offsets may therefore be wrong for the child.

ksmbd preserves the component order sent by the client. The Linux
cifs client puts the DACL before the owner and group SIDs, so their
offsets depend on the parent's DACL size. If the child's DACL is
smaller, the copied SID offsets can fall outside the allocation.
ksmbd then uses a default descriptor, losing inherited deny ACEs.
If the child's DACL is larger, it can overwrite the SIDs.

Build the child in owner, group, DACL order and calculate each offset
as its component is copied. These writes exactly fill the allocation,
so the checks on the copied parent offsets are no longer needed.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

The inherited SIDs and ACEs are unchanged. Only their placement in the
child descriptor changes.

Tested on ksmbd-for-next 267029b35ad1 with KASAN. Children of DACL-first
parents now retain inherited deny ACEs and refuse the denied read.
Smaller child DACLs inherit correctly, and larger ones leave the owner
and group SIDs intact. Across the tested parent DACLs, both component
orders produce the same child DACL. Children of parents already in
owner, group, DACL order are byte-for-byte unchanged. smbtorture results
match the base. Windows client layouts were not tested.

This patch was developed with LLM assistance.

 fs/smb/server/smbacl.c | 63 ++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 43 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index a87c22fa9a6e..891bfb6f54e2 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1392,56 +1392,33 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		if (le16_to_cpu(parent_pntsd->type) & DACL_AUTO_INHERITED)
 			pntsd->type |= cpu_to_le16(DACL_AUTO_INHERITED);
 		pntsd_size = sizeof(struct smb_ntsd);
-		pntsd->osidoffset = parent_pntsd->osidoffset;
-		pntsd->gsidoffset = parent_pntsd->gsidoffset;
-		pntsd->dacloffset = parent_pntsd->dacloffset;
 
-		if ((u64)le32_to_cpu(pntsd->osidoffset) + powner_sid_size >
-		    pntsd_alloc_size) {
-			rc = -EINVAL;
-			kfree(pntsd);
-			goto free_aces_base;
-		}
-
-		if ((u64)le32_to_cpu(pntsd->gsidoffset) + pgroup_sid_size >
-		    pntsd_alloc_size) {
-			rc = -EINVAL;
-			kfree(pntsd);
-			goto free_aces_base;
-		}
-
-		if ((u64)le32_to_cpu(pntsd->dacloffset) + sizeof(struct smb_acl) + nt_size >
-		    pntsd_alloc_size) {
-			rc = -EINVAL;
-			kfree(pntsd);
-			goto free_aces_base;
-		}
-
-		if (pntsd->osidoffset) {
-			struct smb_sid *owner_sid = (struct smb_sid *)((char *)pntsd +
-					le32_to_cpu(pntsd->osidoffset));
-			memcpy(owner_sid, powner_sid, powner_sid_size);
+		/*
+		 * Lay out the child as owner, group and DACL. The parent may
+		 * store its components in another order, so its offsets do
+		 * not fit the child.
+		 */
+		if (powner_sid) {
+			pntsd->osidoffset = cpu_to_le32(pntsd_size);
+			memcpy((char *)pntsd + pntsd_size, powner_sid,
+			       powner_sid_size);
 			pntsd_size += powner_sid_size;
 		}
 
-		if (pntsd->gsidoffset) {
-			struct smb_sid *group_sid = (struct smb_sid *)((char *)pntsd +
-					le32_to_cpu(pntsd->gsidoffset));
-			memcpy(group_sid, pgroup_sid, pgroup_sid_size);
+		if (pgroup_sid) {
+			pntsd->gsidoffset = cpu_to_le32(pntsd_size);
+			memcpy((char *)pntsd + pntsd_size, pgroup_sid,
+			       pgroup_sid_size);
 			pntsd_size += pgroup_sid_size;
 		}
 
-		if (pntsd->dacloffset) {
-			struct smb_ace *pace;
-
-			pdacl = (struct smb_acl *)((char *)pntsd + le32_to_cpu(pntsd->dacloffset));
-			pdacl->revision = cpu_to_le16(2);
-			pdacl->size = cpu_to_le16(sizeof(struct smb_acl) + nt_size);
-			pdacl->num_aces = cpu_to_le16(ace_cnt);
-			pace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-			memcpy(pace, aces_base, nt_size);
-			pntsd_size += sizeof(struct smb_acl) + nt_size;
-		}
+		pntsd->dacloffset = cpu_to_le32(pntsd_size);
+		pdacl = (struct smb_acl *)((char *)pntsd + pntsd_size);
+		pdacl->revision = cpu_to_le16(2);
+		pdacl->size = cpu_to_le16(sizeof(struct smb_acl) + nt_size);
+		pdacl->num_aces = cpu_to_le16(ace_cnt);
+		memcpy((char *)pdacl + sizeof(struct smb_acl), aces_base, nt_size);
+		pntsd_size += sizeof(struct smb_acl) + nt_size;
 
 		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size);
 		kfree(pntsd);
-- 
2.47.3

