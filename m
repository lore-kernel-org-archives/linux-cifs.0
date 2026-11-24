Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537431;
	b=4d7vZuf9jlu5G4qGz+JhEker2mzrxGZR1ViWs+LfCZiwcq8CDdIngvKmVSuoBRNf/f5b
	 uFXTlncluO5pCz5qXbabDGO94M4rxi7BsWeoAYVPWtHwlPIHYpGjNjau44hImAm0Tu9oM
	 kX94jaghXnNHdUHTMrPCC8lMjYAlrhPQFKkTXC1s/SyH9TyUjcYXasKfpc/d+6rcU8h5w
	 OdfHdnfcAkN44zR/Gk8r2kokEC4ULX7WVByOTkGAN134MmD4lSFcxK4ucgIVd44cFXlid
	 LIdPuJt5b+6hexuJPlXceY6dtdUaEfDqV5aO1HOLp7PuJmBDKDfFoSf5QtG5WrJgn7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537431;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=WEsdR1vLDh5gHFLvWv+A/t6Se60RNK761kHyMIzqWSg=;
	b=1w7shoZVfexffPBpB88WwUKyHchxYRBs0NR4ebNT4d/wD2w5QGRqMdIjZFMf3HoUGvxn
	 NXzJmGG1vsGwsZA+GgdiGJqbfNqgKGNtoNATCrRJ4krSd6SniXUt2QxankRcOmfW4xSsj
	 G3qLSszMZthGxyrpQpbYY46SGSbyrNF/w7i++PWuN2Ga6pgcQCWoMtqpBC5kQghkctZT6
	 Xi2mOghd7/eRj3kvQjOXlP3q+GCSyh9LWWVSQVRtAW4CPVyiJz3LZBdedsYhQkrTGvQTZ
	 YNXgfWdk+qxyA/mWVGAfNPARZR87W2zAsu4DNToaoET1w7p2xW9VEy/kSOYChzu7qgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b="w3Z/VN07";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mpZuVgGu;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8D3606A32D
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 16:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C8D3606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=w3Z/VN07;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mpZuVgGu
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3E99514002E8
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 11:23:49 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Tue, 24 Nov 2026 11:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795537429; x=
	1795623829; bh=WEsdR1vLDh5gHFLvWv+A/t6Se60RNK761kHyMIzqWSg=; b=w
	3Z/VN07UB44c1leig0FeXBI6QFYGTx+seX++T2xAaXQtNrNuNS4+y3lXWpiPHX3h
	CNS/SfK5K9vmyVRgmlF/VqaeTNiEpP2lkeALxxHGSNqqXtFXlNwB0I+isHElEtXD
	j81JyNzbndfCH5N2UCu0ptvJrlKHNMsSNiE4NEeO2M8A31rax4pOzd/jTiCsJRBq
	T2x48ICbR6lowWLezrwBzKM/KXtD9ZxAwkl91SdfeW68A9zfifuTbBHvuSbXOqg9
	CjrsQprPY2H/4YUYNT4z2KCxzas0PZpiVzYlfyCtwgwZUv7L6OEBRkGM9BH4ZfZ8
	WvUzbdF7Z+FVVOIjNfNtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795537429; x=1795623829; bh=W
	EsdR1vLDh5gHFLvWv+A/t6Se60RNK761kHyMIzqWSg=; b=mpZuVgGu7xCl62dD0
	f0yFbaMn2kqTZ7JN6ZbJk4MSTiOz5NABBz4k8CCDNFtPgZPbqz5mcaqNqyluxEMy
	POFlOBo4unxAN3qvOrfi3HEjgEHWh1cetXNQg4C9cyRIhxVhShclozrUQs7lmV06
	EknGEVySPWco7THR5l6M83CaUg/8MQ5taJw1sFS7GdmEopVdATWBtwgWIXhLX62G
	b3m79NLioHEngdCdseHXcndxJn40K1u++uf1X5wqn5b06pkb8W/2VlXGYqgdRGeE
	fTVEV3bUWCC1XdinQM/mOXxn4SZOcfGr5uEUoutBoQwoaJxqiutMNgaXIHdYUlcS
	1F4pQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795537429; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:vnjuOt+mrkarirepTYAGBTxCblY1JcYEoMxjWjYpCToIpPv
	vqjfvuFOb+fle/pzniRqf5B9i1Gi32cjlBoCR09PNoPN9F0S2xCHhaAwtoer3DKg
	n+h04XNCul2nJ6zNfZip6tbZYSmChZ+9Jba4kKrALsyj8axKDN3gBMYpT7c3ldbe
	u4jXnzmtspCGhL10KNCsvy6LGwETwsFx3FtV4twbABsDOQSjB+Qj82mQ70Q8FZtc
	xMKLXgZNwN4GpISZDWjif9RB92PxN/4/eGl50rKfRLh6TUJzbWHnUdS/yIOvgais
	ihv+2k46f4WqHbAJ2q6crkkFrMMvnwZeGokZx3g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:yXyEPLDrwD7n0/UBOHJKKq0pECeD17dlb6nsF+S2VrY=:hKWPGkDHbPFTBno1nXsnnOJq6fBMpjAXF9rUJJtqlMc=;
X-ME-Sender: <xms:FLoFayFK6dy7-Tv-iPCB5vmubv_AvPe92aie5rvg4oBNrraFPspbzQ>
    <xme:FLoFa3B3y5M8S7pHZctl2wKD7LqTIaG9ayFUNH7XrYkKEfxYJkErsykv9TKEOyMhI
    YgjroR5ZQOOyVP2fZLO8B7J8ry2loKLRw6owCuvWJA-2kaVP-KIsPSb>
X-ME-Received: <xmr:FLoFa1_V8z6Y85hkkPFOr8l0pTc67xPfqbpxKo63uF4syWLxIobOMjyMI3CCmhWW>
X-ME-Proxy-Cause: dmFkZTFSvR4e8buJ4s5HUUAHFKsx2Z9PD7zteb3cvtRYBs6KziXojcHnUhxaMTbajLD3Qc
    U8uFI9I9QBEs1XxGKvZfo2owRGEpKW7T40pTmbTgzKffyaflL+zKYJKM3WkL673uo/p7xQ
    G4WYbu9KbEa9c47odxt+aN6nS0SOG0Jl2Rh89gAwCFHATP7tDTpe3QP+o1E8OygIeWvcUQ
    F07Gy3guqbhOxv5028m13yjZtEBmwJ2EpZBMCp6cI94RVgSWAmsTi4fBOScVRzriJ1Uhxt
    yTNek8gtH6jJwSlLWi97jk0zcXjfLGhXSvaSM40KoDBjwzmoBk9PnHyCCdpU7pUlVjjMNE
    RMOm202PQArmceggJKfS82Ga7dI5/Grd1dT+VVvnLI5SNctMv6rJvSJbHZuBxpYvIcTmoc
    +ZVXvDfsyaP8ZNPoytxpXOw/LnkL+sHTDnIGWPd2dmmKfU0d4yzGjNYhOn39I6M6dsmwWE
    7/BVaAuXY1PSZHIJCISj0uL4lDaI8B8nHpKkXVzyZLNCWwY+V5NUPY6O1xeuPINqAWLYyf
    hBYkukIon6tZHOkWNMlcA8Y0flqvsKfJRX9by3oP2QFhqv5aVVq+QD81a1nXbLtfvqzrnR
    rRUGoKugg4mnfisUvolQDG2kjhb32RX2xO2BLTcyzQb/Wfs5WMkh7p0w0xIg
X-ME-Proxy: <xmx:FLoFazCjBtkLwZuJzN6aPOs6nQCxTy5VUUJWz6Xi-D2NpSBGACLbfg>
    <xmx:FboFa6RqJtXv6V6AuLAW19gxTArbuG3XUYeXwjEmA4Sm8UkFs69lEA>
    <xmx:FboFa6veils5RzR6SYHPSvTqtE-fqrPzBLH2xOwASg7feRLXFNZx5A>
    <xmx:FboFa23n2lu4z1A2287lqDvtA7VW0p8M2_oiKlesBRMNFoL2NKE_dg>
    <xmx:FboFayjmmSIfT__edIHSOFIjlf9kB1e1bTEnhtCZKfLWCjtprCu21cvE>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Nov 2026 11:23:48 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [RFC PATCH 2/2] ksmbd: use the security descriptor codec in callers
Date: Tue, 24 Nov 2026 10:23:31 -0600
Message-ID: <20261124162331.895789-3-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124162331.895789-1-icb@fastmail.org>
References: <20261124162331.895789-1-icb@fastmail.org>
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

Replace each walk of a raw security descriptor (SD) with
ksmbd_sd_decode() and each place that writes one with ksmbd_sd_encode().
The functions keep their names and their logic. Only the code that read
or wrote the bytes of an SD changes.

ksmbd_vfs_get_sd_xattr() decodes the stored SD and returns a struct
ksmbd_sd, so the access check, inheritance, and QUERY_INFO no longer
check offsets and sizes themselves. parse_sec_desc() decodes the SD a
client sent, and set_info_sec() encodes what it stores. build_sec_desc()
and smb_inherit_dacl() fill in a struct ksmbd_sd and encode it.
build_sec_desc() allocates its reply, which removes
smb_acl_sec_desc_scratch_len() and the size arithmetic in its callers.
dacl_add_ace_size(), parse_sid(), smb_set_ace(), and
smb_validate_ntsd_sid() are removed with the walks they served.

The changes in behavior follow.

A malformed SD is refused whole, and the decoder refuses more than the
walks did. For example, it refuses a DACL whose AceCount is larger than
the ACEs it holds.

- parse_sec_desc() returns -EINVAL for a malformed SD from a client,
  even if only the SACL is malformed. It now checks the owner and the
  group when DACL_PRESENT is clear. Before, it checked only OffsetDacl
  in that case.
- The loader returns -EBADMSG for a malformed stored SD and logs a
  rate-limited warning. QUERY_INFO returns
  STATUS_INVALID_SECURITY_DESCR. The access check denies the request.
  Inheritance falls back to the SD built from the child's inode.
- A stored SD shorter than its header is malformed too. Before, it
  counted as no stored SD.

The other changes follow.

- The SID of an object ACE is read after its GUIDs. Before, its Flags
  were read as the SID. parse_dacl() still refuses a DACL with an object
  ACE, and QUERY_INFO still leaves the ACE out. The access check now
  skips an object ACE. It still records an object ACE that denies,
  unless the ACE is inherit-only.
- Inheritance copies an ACE whole. Before, a callback ACE lost its data
  and an object ACE lost its GUIDs.
- Inheritance accepts a parent DACL of 16-byte ACEs. Before, it refused
  an AceCount above (AclSize - 8) / 18.
- A DACL that holds an object ACE is written with revision 4.
- A DACL over 65535 bytes fails with -E2BIG. Before, the POSIX ACL
  entries that did not fit were left out.
- build_sec_desc() fails with -ENOMEM if it cannot allocate the SIDs of
  the POSIX ACL entries. Before, the remaining entries were left out.
- Every stored SD is the one the encoder writes, with SELF_RELATIVE
  set. Before, SET_INFO stored the buffer the client sent. The format
  of the xattr does not change.
- A refused SD from a client is logged with ksmbd_debug(). The pr_err()
  lines of the walks are gone.

The fixture in smbacl_kunit.c counts two ACEs in its DACL, and only one
fits inside AclSize. That SD is now refused whole, so the case for
maximal access expects a denial, as the other case already did. A new
case sets AceCount to one and checks that maximal access includes read
and excludes write.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---
 fs/smb/server/smb2pdu.c            |   79 +--
 fs/smb/server/smbacl.c             | 1021 ++++++++--------------------
 fs/smb/server/smbacl.h             |   11 +-
 fs/smb/server/tests/smbacl_kunit.c |   42 ++
 fs/smb/server/vfs.c                |   50 +-
 fs/smb/server/vfs.h                |   10 +-
 6 files changed, 392 insertions(+), 821 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 25e19ae10ad5..6b69dda87105 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5243,33 +5243,13 @@ int smb2_open(struct ksmbd_work *work)
 					struct smb_fattr fattr;
 					struct smb_ntsd *pntsd;
 					int pntsd_size;
-					size_t scratch_len;
 
 					rc = ksmbd_acls_fattr(&fattr, idmap, inode);
 					if (rc)
 						goto err_out;
 
-					scratch_len = smb_acl_sec_desc_scratch_len(&fattr,
-							NULL, 0,
-							OWNER_SECINFO | GROUP_SECINFO |
-							DACL_SECINFO);
-					if (!scratch_len || scratch_len == SIZE_MAX) {
-						rc = -EFBIG;
-						posix_acl_release(fattr.cf_acls);
-						posix_acl_release(fattr.cf_dacls);
-						goto err_out;
-					}
-
-					pntsd = kvzalloc(scratch_len, KSMBD_DEFAULT_GFP);
-					if (!pntsd) {
-						rc = -ENOMEM;
-						posix_acl_release(fattr.cf_acls);
-						posix_acl_release(fattr.cf_dacls);
-						goto err_out;
-					}
-
 					rc = build_sec_desc(idmap,
-							    pntsd, NULL, 0,
+							    &pntsd, NULL,
 							    OWNER_SECINFO |
 							    GROUP_SECINFO |
 							    DACL_SECINFO,
@@ -8435,14 +8415,14 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 {
 	struct ksmbd_file *fp;
 	const struct mnt_idmap *idmap;
-	struct smb_ntsd *pntsd = NULL, *ppntsd = NULL;
+	struct smb_ntsd *pntsd = NULL;
+	struct ksmbd_sd *ppntsd = NULL;
 	struct smb_fattr fattr = {{0}};
 	struct inode *inode;
 	__u32 secdesclen = 0;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 	int addition_info = le32_to_cpu(req->AdditionalInformation);
-	int rc = 0, ppntsd_size = 0, max_len;
-	size_t scratch_len = 0;
+	int rc = 0, max_len;
 
 	if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
 			      PROTECTED_DACL_SECINFO |
@@ -8494,11 +8474,13 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_ACL_XATTR)) {
-		ppntsd_size = ksmbd_vfs_get_sd_xattr(work->conn, idmap,
-						     fp->filp->f_path.dentry,
-						     &ppntsd);
-		if (ppntsd_size < 0 && !smb_no_stored_sd(ppntsd_size)) {
-			rc = ppntsd_size == -ENOMEM ? -ENOMEM : -EIO;
+		rc = ksmbd_vfs_get_sd_xattr(work->conn, idmap,
+					    fp->filp->f_path.dentry, &ppntsd);
+		if (rc && !smb_no_stored_sd(rc)) {
+			if (rc == -EBADMSG)
+				rsp->hdr.Status = STATUS_INVALID_SECURITY_DESCR;
+			else if (rc != -ENOMEM)
+				rc = -EIO;
 			goto release_acl;
 		}
 	}
@@ -8512,32 +8494,18 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 		goto release_acl;
 	}
 
-	scratch_len = smb_acl_sec_desc_scratch_len(&fattr, ppntsd,
-			ppntsd_size, addition_info);
-	if (!scratch_len || scratch_len > SIZE_MAX - 7) {
-		rc = -EFBIG;
-		goto release_acl;
-	}
-
-	/* A compound response pads the descriptor to 8 bytes in this buffer */
-	scratch_len = ALIGN(scratch_len, 8);
-	pntsd = kvzalloc(scratch_len, KSMBD_DEFAULT_GFP);
-	if (!pntsd) {
-		rc = -ENOMEM;
-		goto release_acl;
-	}
-
-	rc = build_sec_desc(idmap, pntsd, ppntsd, ppntsd_size,
-			addition_info, &secdesclen, &fattr);
+	rc = build_sec_desc(idmap, &pntsd, ppntsd, addition_info, &secdesclen,
+			    &fattr);
+	/* The DACL is too large for an SD */
+	if (rc == -E2BIG)
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 
 release_acl:
 	posix_acl_release(fattr.cf_acls);
 	posix_acl_release(fattr.cf_dacls);
-	kfree(ppntsd);
+	kvfree(ppntsd);
 	ksmbd_fd_put(work, fp);
 
-	if (!rc && ALIGN(secdesclen, 8) > scratch_len)
-		rc = -EFBIG;
 	if (rc)
 		goto err_out;
 
@@ -8548,6 +8516,19 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	if (rc)
 		goto err_out;
 
+	/* A compound response pads the descriptor to 8 bytes in this buffer */
+	if (!IS_ALIGNED(secdesclen, 8)) {
+		void *padded = kvrealloc(pntsd, ALIGN(secdesclen, 8),
+					 KSMBD_DEFAULT_GFP);
+
+		if (!padded) {
+			rc = -ENOMEM;
+			goto err_out;
+		}
+		memset(padded + secdesclen, 0, ALIGN(secdesclen, 8) - secdesclen);
+		pntsd = padded;
+	}
+
 	rc = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
 			offsetof(struct smb2_query_info_rsp, Buffer),
 			pntsd, secdesclen);
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 49530198a2b6..098c9132ebe6 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -6,9 +6,11 @@
  *   Author(s): Namjae Jeon <linkinjeon@kernel.org>
  */
 
+#include <linux/cleanup.h>
 #include <linux/fs.h>
 #include <linux/dcache.h>
 #include <kunit/visibility.h>
+#include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/mnt_idmapping.h>
@@ -19,6 +21,7 @@
 #include "server.h"
 #include "misc.h"
 #include "mgmt/share_config.h"
+#include "secdesc.h"
 
 static const struct smb_sid domain = {1, 4, {0, 0, 0, 0, 0, 5},
 	{cpu_to_le32(21), cpu_to_le32(1), cpu_to_le32(2), cpu_to_le32(3),
@@ -196,12 +199,10 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 		    mode, *pace_flags);
 }
 
-static __u16 fill_ace_for_sid(struct smb_ace *pntace,
-			      const struct smb_sid *psid, int type, int flags,
-			      umode_t mode, umode_t bits)
+static void fill_ace_for_sid(struct ksmbd_ace *pntace,
+			     const struct smb_sid *psid, int type, int flags,
+			     umode_t mode, umode_t bits)
 {
-	int i;
-	__u16 size = 0;
 	__u32 access_req = 0;
 
 	pntace->type = type;
@@ -209,19 +210,8 @@ static __u16 fill_ace_for_sid(struct smb_ace *pntace,
 	mode_to_access_flags(mode, bits, &access_req);
 	if (!access_req)
 		access_req = SET_MINIMUM_RIGHTS;
-	pntace->access_req = cpu_to_le32(access_req);
-
-	pntace->sid.revision = psid->revision;
-	pntace->sid.num_subauth = psid->num_subauth;
-	for (i = 0; i < NUM_AUTHS; i++)
-		pntace->sid.authority[i] = psid->authority[i];
-	for (i = 0; i < psid->num_subauth; i++)
-		pntace->sid.sub_auth[i] = psid->sub_auth[i];
-
-	size = 1 + 1 + 2 + 4 + 1 + 1 + 6 + (psid->num_subauth * 4);
-	pntace->size = cpu_to_le16(size);
-
-	return size;
+	pntace->mask = access_req;
+	pntace->sid = psid;
 }
 
 void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid)
@@ -261,7 +251,7 @@ void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid)
 }
 
 static int sid_to_id(const struct mnt_idmap *idmap,
-		     struct smb_sid *psid, uint sidtype,
+		     const struct smb_sid *psid, uint sidtype,
 		     struct smb_fattr *fattr)
 {
 	const struct smb_sid *sid_prefix;
@@ -387,52 +377,23 @@ void free_acl_state(struct posix_acl_state *state)
 }
 
 static int parse_dacl(const struct mnt_idmap *idmap,
-		      struct smb_acl *pdacl, char *end_of_acl,
-		      struct smb_sid *pownersid, struct smb_sid *pgrpsid,
-		      struct smb_fattr *fattr)
+		      struct ksmbd_sd *sd,
+		      const struct smb_sid *pownersid,
+		      const struct smb_sid *pgrpsid, struct smb_fattr *fattr)
 {
 	int i, ret;
 	u16 num_aces = 0;
-	u16 dacl_size;
-	unsigned int acl_size;
-	char *acl_base;
-	struct smb_ace **ppace;
+	struct ksmbd_ace *ace;
 	struct posix_acl_entry *cf_pace, *cf_pdace;
 	struct posix_acl_state acl_state, default_acl_state;
 	umode_t mode = 0, acl_mode;
 	bool owner_found = false, group_found = false, others_found = false;
 	bool nfs_mode_found = false;
 
-	if (!pdacl)
-		return 0;
-
-	/* validate that we do not go past end of acl */
-	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
-	    end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
-		pr_err("ACL too small to parse DACL\n");
-		return -EINVAL;
-	}
-
-	ksmbd_debug(SMB, "DACL revision %d size %d num aces %d\n",
-		    le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
-		    le16_to_cpu(pdacl->num_aces));
-
-	acl_base = (char *)pdacl;
-	acl_size = sizeof(struct smb_acl);
-
-	num_aces = le16_to_cpu(pdacl->num_aces);
+	num_aces = sd->num_aces;
 	if (num_aces <= 0)
 		return 0;
 
-	dacl_size = le16_to_cpu(pdacl->size);
-	if (dacl_size < sizeof(struct smb_acl))
-		return -EINVAL;
-
-	if (num_aces > (dacl_size - sizeof(struct smb_acl)) /
-			(offsetof(struct smb_ace, sid) +
-			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
-		return -EINVAL;
-
 	ret = init_acl_state(&acl_state, num_aces);
 	if (ret)
 		return ret;
@@ -442,59 +403,36 @@ static int parse_dacl(const struct mnt_idmap *idmap,
 		return ret;
 	}
 
-	ppace = kmalloc_objs(struct smb_ace *, num_aces, KSMBD_DEFAULT_GFP);
-	if (!ppace) {
-		free_acl_state(&default_acl_state);
-		free_acl_state(&acl_state);
-		return -ENOMEM;
-	}
-
 	/*
 	 * reset rwx permissions for user/group/other.
 	 * Also, if num_aces is 0 i.e. DACL has no ACEs,
 	 * user/group/other have no permissions
 	 */
 	for (i = 0; i < num_aces; ++i) {
-		if (end_of_acl - acl_base < acl_size) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		ppace[i] = (struct smb_ace *)(acl_base + acl_size);
-		acl_base = (char *)ppace[i];
-		acl_size = offsetof(struct smb_ace, sid) +
-			offsetof(struct smb_sid, sub_auth);
-
-		if (end_of_acl - acl_base < acl_size ||
-		    ppace[i]->sid.num_subauth == 0 ||
-		    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
-		    (end_of_acl - acl_base <
-		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||
-		    (le16_to_cpu(ppace[i]->size) <
-		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth)) {
+		ace = &sd->aces[i];
+		/* ksmbd maps no object ACE, so an SD that has one is refused */
+		if (ace->obj_len || ace->sid->num_subauth == 0) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		acl_size = le16_to_cpu(ppace[i]->size);
-		ppace[i]->access_req =
-			smb_map_generic_desired_access(ppace[i]->access_req);
+		ace->mask = le32_to_cpu(smb_map_generic_desired_access(cpu_to_le32(ace->mask)));
 
 		/* ACEs after an NFS mode ACE do not change the POSIX mapping */
 		if (nfs_mode_found)
 			continue;
 
-		if (ppace[i]->type == ACCESS_ALLOWED &&
-		    ppace[i]->sid.num_subauth >= 3 &&
-		    !(compare_sids(&ppace[i]->sid, &sid_unix_NFS_mode))) {
+		if (ace->type == ACCESS_ALLOWED &&
+		    ace->sid->num_subauth >= 3 &&
+		    !(compare_sids(ace->sid, &sid_unix_NFS_mode))) {
 			fattr->cf_mode =
-				le32_to_cpu(ppace[i]->sid.sub_auth[2]);
+				le32_to_cpu(ace->sid->sub_auth[2]);
 			fattr->cf_posix_mode = true;
 			nfs_mode_found = true;
-		} else if (!compare_sids(&ppace[i]->sid, pownersid)) {
+		} else if (!compare_sids(ace->sid, pownersid)) {
 			acl_mode = access_flags_to_mode(fattr,
-							ppace[i]->access_req,
-							ppace[i]->type);
+							cpu_to_le32(ace->mask),
+							ace->type);
 			acl_mode &= 0700;
 
 			if (!owner_found) {
@@ -502,41 +440,41 @@ static int parse_dacl(const struct mnt_idmap *idmap,
 				mode |= acl_mode;
 			}
 			owner_found = true;
-		} else if (!compare_sids(&ppace[i]->sid, pgrpsid) ||
-			   ppace[i]->sid.sub_auth[ppace[i]->sid.num_subauth - 1] ==
+		} else if (!compare_sids(ace->sid, pgrpsid) ||
+			   ace->sid->sub_auth[ace->sid->num_subauth - 1] ==
 			    DOMAIN_USER_RID_LE) {
 			acl_mode = access_flags_to_mode(fattr,
-							ppace[i]->access_req,
-							ppace[i]->type);
+							cpu_to_le32(ace->mask),
+							ace->type);
 			acl_mode &= 0070;
 			if (!group_found) {
 				mode &= ~(0070);
 				mode |= acl_mode;
 			}
 			group_found = true;
-		} else if (!compare_sids(&ppace[i]->sid, &sid_everyone)) {
+		} else if (!compare_sids(ace->sid, &sid_everyone)) {
 			acl_mode = access_flags_to_mode(fattr,
-							ppace[i]->access_req,
-							ppace[i]->type);
+							cpu_to_le32(ace->mask),
+							ace->type);
 			acl_mode &= 0007;
 			if (!others_found) {
 				mode &= ~(0007);
 				mode |= acl_mode;
 			}
 			others_found = true;
-		} else if (!compare_sids(&ppace[i]->sid, &creator_owner)) {
+		} else if (!compare_sids(ace->sid, &creator_owner)) {
 			continue;
-		} else if (!compare_sids(&ppace[i]->sid, &creator_group)) {
+		} else if (!compare_sids(ace->sid, &creator_group)) {
 			continue;
-		} else if (!compare_sids(&ppace[i]->sid, &sid_authusers)) {
+		} else if (!compare_sids(ace->sid, &sid_authusers)) {
 			continue;
 		} else {
 			struct smb_fattr temp_fattr;
 
-			acl_mode = access_flags_to_mode(fattr, ppace[i]->access_req,
-							ppace[i]->type);
+			acl_mode = access_flags_to_mode(fattr, cpu_to_le32(ace->mask),
+							ace->type);
 			temp_fattr.cf_uid = INVALID_UID;
-			ret = sid_to_id(idmap, &ppace[i]->sid, SIDOWNER, &temp_fattr);
+			ret = sid_to_id(idmap, ace->sid, SIDOWNER, &temp_fattr);
 			if (ret || uid_eq(temp_fattr.cf_uid, INVALID_UID)) {
 				pr_err_ratelimited("%s: Error %d mapping Owner SID to uid\n",
 						   __func__, ret);
@@ -627,7 +565,6 @@ static int parse_dacl(const struct mnt_idmap *idmap,
 	}
 	ret = 0;
 out:
-	kfree(ppace);
 	free_acl_state(&acl_state);
 	free_acl_state(&default_acl_state);
 	return ret;
@@ -652,29 +589,16 @@ static bool ace_is_for_entry(const struct smb_sid *ace_sid,
 	       !ace_sid->sub_auth[dom->num_subauth];
 }
 
-/*
- * Add the size of an ACE to the size of the ACEs in a DACL. Fail when the
- * DACL with its header would no longer fit in its 16-bit size.
- */
-static bool dacl_add_ace_size(u16 *size, u16 ace_sz)
-{
-	if (*size + ace_sz > U16_MAX - sizeof(struct smb_acl))
-		return false;
-	*size += ace_sz;
-	return true;
-}
-
 static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
-				       struct smb_ace *pndace,
+				       struct ksmbd_sd *sd,
 				       struct smb_fattr *fattr, u16 *num_aces,
-				       u16 *size, u16 existing_nt_aces,
-				       bool had_nt_aces)
+				       u16 existing_nt_aces, bool had_nt_aces,
+				       struct smb_sid *sids)
 {
 	struct posix_acl_entry *pace;
 	struct smb_sid *sid;
-	struct smb_ace *ntace;
+	struct ksmbd_ace *ntace;
 	int i, j;
-	u16 ace_sz;
 
 	if (!fattr->cf_acls)
 		goto posix_default_acl;
@@ -684,9 +608,7 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 		int flags = 0;
 		bool root = false;
 
-		sid = kmalloc_obj(struct smb_sid, KSMBD_DEFAULT_GFP);
-		if (!sid)
-			break;
+		sid = sids++;
 
 		if (pace->e_tag == ACL_USER) {
 			uid_t uid;
@@ -706,49 +628,36 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 		} else if (pace->e_tag == ACL_OTHER && !had_nt_aces) {
 			smb_copy_sid(sid, &sid_everyone);
 		} else {
-			kfree(sid);
 			continue;
 		}
-		ntace = pndace;
 		for (j = 0; j < existing_nt_aces; j++) {
-			if (ace_is_for_entry(&ntace->sid, sid, root))
-				goto pass_same_sid;
-			ntace = (struct smb_ace *)((char *)ntace +
-					le16_to_cpu(ntace->size));
+			if (ace_is_for_entry(sd->aces[j].sid, sid, root))
+				break;
 		}
+		if (j < existing_nt_aces)
+			continue;
 
 		if (S_ISDIR(fattr->cf_mode) && pace->e_tag == ACL_OTHER)
 			flags = 0x03;
 
-		ntace = (struct smb_ace *)((char *)pndace + *size);
-		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, flags,
-				pace->e_perm, 0777);
-		if (!dacl_add_ace_size(size, ace_sz)) {
-			kfree(sid);
-			break;
-		}
+		ntace = &sd->aces[*num_aces];
+		fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, flags,
+				 pace->e_perm, 0777);
 		(*num_aces)++;
 		if (pace->e_tag == ACL_USER)
-			ntace->access_req |=
-				FILE_DELETE_LE | FILE_DELETE_CHILD_LE;
+			ntace->mask |=
+				le32_to_cpu(FILE_DELETE_LE | FILE_DELETE_CHILD_LE);
 
 		if (S_ISDIR(fattr->cf_mode) &&
 		    (pace->e_tag == ACL_USER || pace->e_tag == ACL_GROUP)) {
-			ntace = (struct smb_ace *)((char *)pndace + *size);
-			ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED,
-					0x03, pace->e_perm, 0777);
-			if (!dacl_add_ace_size(size, ace_sz)) {
-				kfree(sid);
-				break;
-			}
+			ntace = &sd->aces[*num_aces];
+			fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED,
+					 0x03, pace->e_perm, 0777);
 			(*num_aces)++;
 			if (pace->e_tag == ACL_USER)
-				ntace->access_req |=
-					FILE_DELETE_LE | FILE_DELETE_CHILD_LE;
+				ntace->mask |=
+					le32_to_cpu(FILE_DELETE_LE | FILE_DELETE_CHILD_LE);
 		}
-
-pass_same_sid:
-		kfree(sid);
 	}
 
 	if (had_nt_aces)
@@ -760,9 +669,7 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 
 	pace = fattr->cf_dacls->a_entries;
 	for (i = 0; i < fattr->cf_dacls->a_count; i++, pace++) {
-		sid = kmalloc_obj(struct smb_sid, KSMBD_DEFAULT_GFP);
-		if (!sid)
-			break;
+		sid = sids++;
 
 		if (pace->e_tag == ACL_USER) {
 			uid_t uid;
@@ -775,215 +682,124 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 			gid = posix_acl_gid_translate(idmap, pace);
 			id_to_sid(gid, SIDCREATOR_GROUP, sid);
 		} else {
-			kfree(sid);
 			continue;
 		}
 
-		ntace = (struct smb_ace *)((char *)pndace + *size);
-		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, 0x0b,
-				pace->e_perm, 0777);
-		if (!dacl_add_ace_size(size, ace_sz)) {
-			kfree(sid);
-			break;
-		}
+		ntace = &sd->aces[*num_aces];
+		fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, 0x0b,
+				 pace->e_perm, 0777);
 		(*num_aces)++;
 		if (pace->e_tag == ACL_USER)
-			ntace->access_req |=
-				FILE_DELETE_LE | FILE_DELETE_CHILD_LE;
-		kfree(sid);
+			ntace->mask |=
+				le32_to_cpu(FILE_DELETE_LE | FILE_DELETE_CHILD_LE);
 	}
 }
 
 static void set_ntacl_dacl(const struct mnt_idmap *idmap,
-			   struct smb_acl *pndacl,
-			   struct smb_acl *nt_dacl,
-			   unsigned int aces_size,
-			   const struct smb_sid *pownersid,
-			   const struct smb_sid *pgrpsid,
-			   struct smb_fattr *fattr)
+			   struct ksmbd_sd *sd,
+			   const struct ksmbd_sd *nt_sd,
+			   struct smb_fattr *fattr, struct smb_sid *sids)
 {
-	struct smb_ace *ntace, *pndace;
-	u16 nt_num_aces = le16_to_cpu(nt_dacl->num_aces), num_aces = 0;
+	u16 nt_num_aces = nt_sd->num_aces, num_aces = 0;
 	u16 copied_nt_aces;
-	unsigned short size = 0;
 	int i;
 
-	pndace = (struct smb_ace *)((char *)pndacl + sizeof(struct smb_acl));
-	if (nt_num_aces) {
-		ntace = (struct smb_ace *)((char *)nt_dacl + sizeof(struct smb_acl));
-		for (i = 0; i < nt_num_aces; i++) {
-			unsigned short nt_ace_size;
-
-			if (aces_size < offsetof(struct smb_ace, sid) +
-					CIFS_SID_BASE_SIZE)
-				break;
-
-			nt_ace_size = le16_to_cpu(ntace->size);
-			if (nt_ace_size > aces_size ||
-			    nt_ace_size < offsetof(struct smb_ace, sid) +
-					  CIFS_SID_BASE_SIZE)
-				break;
-
-			if (ntace->sid.num_subauth == 0 ||
-			    ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
-			    nt_ace_size < offsetof(struct smb_ace, sid) +
-					  CIFS_SID_BASE_SIZE +
-					  sizeof(__le32) *
-					  ntace->sid.num_subauth)
-				goto next_ace;
-
-			memcpy((char *)pndace + size, ntace, nt_ace_size);
-			if (!dacl_add_ace_size(&size, nt_ace_size))
-				break;
-			num_aces++;
-
-next_ace:
-			aces_size -= nt_ace_size;
-			ntace = (struct smb_ace *)((char *)ntace + nt_ace_size);
-		}
+	for (i = 0; i < nt_num_aces; i++) {
+		/* ksmbd leaves an object ACE out of the reply */
+		if (nt_sd->aces[i].obj_len ||
+		    nt_sd->aces[i].sid->num_subauth == 0)
+			continue;
+		sd->aces[num_aces++] = nt_sd->aces[i];
 	}
 
 	copied_nt_aces = num_aces;
-	set_posix_acl_entries_dacl(idmap, pndace, fattr,
-				   &num_aces, &size, copied_nt_aces,
-				   nt_num_aces != 0);
-	pndacl->num_aces = cpu_to_le16(num_aces);
-	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
+	set_posix_acl_entries_dacl(idmap, sd, fattr,
+				   &num_aces, copied_nt_aces,
+				   nt_num_aces != 0, sids);
+	sd->num_aces = num_aces;
 }
 
 static void set_mode_dacl(const struct mnt_idmap *idmap,
-			  struct smb_acl *pndacl, struct smb_fattr *fattr)
+			  struct ksmbd_sd *sd,
+			  const struct smb_sid *pownersid,
+			  const struct smb_sid *pgrpsid,
+			  struct smb_fattr *fattr, struct smb_sid *sids)
 {
-	struct smb_ace *pace, *pndace;
+	struct ksmbd_ace *pace;
 	u16 num_aces = 0;
-	u16 size = 0, ace_size = 0;
-	uid_t uid;
-	const struct smb_sid *sid;
 
-	pace = pndace = (struct smb_ace *)((char *)pndacl + sizeof(struct smb_acl));
+	pace = sd->aces;
 
 	if (fattr->cf_acls) {
-		set_posix_acl_entries_dacl(idmap, pndace, fattr,
-					   &num_aces, &size, num_aces, false);
+		set_posix_acl_entries_dacl(idmap, sd, fattr,
+					   &num_aces, num_aces, false, sids);
 		goto out;
 	}
 
 	/* owner RID */
-	uid = from_kuid(&init_user_ns, fattr->cf_uid);
-	if (uid)
-		sid = &server_conf.domain_sid;
-	else
-		sid = &sid_unix_users;
-	ace_size = fill_ace_for_sid(pace, sid, ACCESS_ALLOWED, 0,
-				    fattr->cf_mode, 0700);
-	pace->sid.sub_auth[pace->sid.num_subauth++] = cpu_to_le32(uid);
-	pace->size = cpu_to_le16(ace_size + 4);
-	size += le16_to_cpu(pace->size);
-	pace = (struct smb_ace *)((char *)pndace + size);
+	fill_ace_for_sid(pace++, pownersid, ACCESS_ALLOWED, 0,
+			 fattr->cf_mode, 0700);
 
 	/* Group RID */
-	ace_size = fill_ace_for_sid(pace, &sid_unix_groups,
-				    ACCESS_ALLOWED, 0, fattr->cf_mode, 0070);
-	pace->sid.sub_auth[pace->sid.num_subauth++] =
-		cpu_to_le32(from_kgid(&init_user_ns, fattr->cf_gid));
-	pace->size = cpu_to_le16(ace_size + 4);
-	size += le16_to_cpu(pace->size);
-	pace = (struct smb_ace *)((char *)pndace + size);
+	fill_ace_for_sid(pace++, pgrpsid,
+			 ACCESS_ALLOWED, 0, fattr->cf_mode, 0070);
 	num_aces = 3;
 
 	if (S_ISDIR(fattr->cf_mode)) {
-		pace = (struct smb_ace *)((char *)pndace + size);
-
 		/* creator owner */
-		size += fill_ace_for_sid(pace, &creator_owner, ACCESS_ALLOWED,
-					 0x0b, fattr->cf_mode, 0700);
-		pace = (struct smb_ace *)((char *)pndace + size);
+		fill_ace_for_sid(pace++, &creator_owner, ACCESS_ALLOWED,
+				 0x0b, fattr->cf_mode, 0700);
 
 		/* creator group */
-		size += fill_ace_for_sid(pace, &creator_group, ACCESS_ALLOWED,
-					 0x0b, fattr->cf_mode, 0070);
-		pace = (struct smb_ace *)((char *)pndace + size);
+		fill_ace_for_sid(pace++, &creator_group, ACCESS_ALLOWED,
+				 0x0b, fattr->cf_mode, 0070);
 		num_aces = 5;
 	}
 
 	/* other */
-	size += fill_ace_for_sid(pace, &sid_everyone, ACCESS_ALLOWED, 0,
-				 fattr->cf_mode, 0007);
+	fill_ace_for_sid(pace, &sid_everyone, ACCESS_ALLOWED, 0,
+			 fattr->cf_mode, 0007);
 
 out:
-	pndacl->num_aces = cpu_to_le16(num_aces);
-	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
-}
-
-static int parse_sid(struct smb_sid *psid, char *end_of_acl)
-{
-	/*
-	 * validate that we do not go past end of ACL - sid must be at least 8
-	 * bytes long (assuming no sub-auths - e.g. the null SID
-	 */
-	if (end_of_acl < (char *)psid + 8) {
-		pr_err("ACL too small to parse SID %p\n", psid);
-		return -EINVAL;
-	}
-
-	if (!psid->num_subauth)
-		return 0;
-
-	if (psid->num_subauth > SID_MAX_SUB_AUTHORITIES ||
-	    end_of_acl < (char *)psid + 8 + sizeof(__le32) * psid->num_subauth)
-		return -EINVAL;
-
-	return 0;
+	sd->num_aces = num_aces;
 }
 
 /* Convert CIFS ACL to POSIX form */
 int parse_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
-		   int acl_len, struct smb_fattr *fattr)
+		   int acl_len, struct smb_fattr *fattr, struct ksmbd_sd **psd)
 {
 	int rc = 0;
-	struct smb_sid *owner_sid_ptr = NULL, *group_sid_ptr = NULL;
-	struct smb_acl *dacl_ptr; /* no need for SACL ptr */
-	char *end_of_acl = ((char *)pntsd) + acl_len;
-	__u32 dacloffset;
+	const struct smb_sid *owner_sid_ptr = NULL, *group_sid_ptr = NULL;
+	struct ksmbd_sd *sd __free(kvfree) = NULL;
 	int pntsd_type;
 
 	if (!pntsd)
 		return -EIO;
 
-	if (acl_len < sizeof(struct smb_ntsd))
+	if (acl_len < (int)sizeof(struct smb_ntsd))
 		return -EINVAL;
 
-	dacloffset = le32_to_cpu(pntsd->dacloffset);
-	ksmbd_debug(SMB,
-		    "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
-		    pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
-		    le32_to_cpu(pntsd->gsidoffset),
-		    le32_to_cpu(pntsd->sacloffset), dacloffset);
+	/* An SD from a client is stored whole or not at all */
+	rc = ksmbd_sd_decode((u8 *)pntsd, acl_len, &sd);
+	if (rc == -EBADMSG || (!rc && sd->sacl_dropped))
+		rc = -EINVAL;
+	if (rc)
+		return rc;
 
-	pntsd_type = le16_to_cpu(pntsd->type);
-	if (!(pntsd_type & DACL_PRESENT)) {
+	pntsd_type = sd->control;
+	if (sd->dacl == KSMBD_ACL_ABSENT) {
 		ksmbd_debug(SMB, "DACL_PRESENT in DACL type is not set\n");
-		/* Without DACL_PRESENT, OffsetDacl must be 0 (MS-DTYP 2.4.6) */
-		if (dacloffset)
-			return -EINVAL;
+		*psd = no_free_ptr(sd);
 		return rc;
 	}
 
-	pntsd->type = cpu_to_le16(DACL_PRESENT);
-
-	if (pntsd->osidoffset) {
-		if (le32_to_cpu(pntsd->osidoffset) < sizeof(struct smb_ntsd) ||
-		    le32_to_cpu(pntsd->osidoffset) >= acl_len)
-			return -EINVAL;
-
-		owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
-				le32_to_cpu(pntsd->osidoffset));
-		rc = parse_sid(owner_sid_ptr, end_of_acl);
-		if (rc) {
-			pr_err("%s: Error %d parsing Owner SID\n", __func__, rc);
-			return rc;
-		}
+	/* The stored SD keeps only the Control bits set below and no SACL */
+	sd->control = 0;
+	sd->sacl = KSMBD_ACL_ABSENT;
+	sd->sacl_len = 0;
 
+	if (sd->owner) {
+		owner_sid_ptr = sd->owner;
 		rc = sid_to_id(idmap, owner_sid_ptr, SIDOWNER, fattr);
 		if (rc) {
 			ksmbd_debug(SMB, "Owner SID has no Unix uid mapping\n");
@@ -992,19 +808,8 @@ int parse_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		}
 	}
 
-	if (pntsd->gsidoffset) {
-		if (le32_to_cpu(pntsd->gsidoffset) < sizeof(struct smb_ntsd) ||
-		    le32_to_cpu(pntsd->gsidoffset) >= acl_len)
-			return -EINVAL;
-
-		group_sid_ptr = (struct smb_sid *)((char *)pntsd +
-				le32_to_cpu(pntsd->gsidoffset));
-		rc = parse_sid(group_sid_ptr, end_of_acl);
-		if (rc) {
-			pr_err("%s: Error %d mapping Owner SID to gid\n",
-			       __func__, rc);
-			return rc;
-		}
+	if (sd->group) {
+		group_sid_ptr = sd->group;
 		rc = sid_to_id(idmap, group_sid_ptr, SIDUNIX_GROUP, fattr);
 		if (rc) {
 			ksmbd_debug(SMB, "Group SID has no Unix gid mapping\n");
@@ -1015,82 +820,34 @@ int parse_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 
 	if ((pntsd_type & (DACL_AUTO_INHERITED | DACL_AUTO_INHERIT_REQ)) ==
 	    (DACL_AUTO_INHERITED | DACL_AUTO_INHERIT_REQ))
-		pntsd->type |= cpu_to_le16(DACL_AUTO_INHERITED);
+		sd->control |= DACL_AUTO_INHERITED;
 	if (pntsd_type & DACL_PROTECTED)
-		pntsd->type |= cpu_to_le16(DACL_PROTECTED);
-
-	if (dacloffset) {
-		if (dacloffset < sizeof(struct smb_ntsd) || dacloffset >= acl_len)
-			return -EINVAL;
+		sd->control |= DACL_PROTECTED;
 
-		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
-		rc = parse_dacl(idmap, dacl_ptr, end_of_acl,
-				owner_sid_ptr, group_sid_ptr, fattr);
-		if (rc)
-			return rc;
-	}
+	rc = parse_dacl(idmap, sd, owner_sid_ptr, group_sid_ptr, fattr);
+	if (rc)
+		return rc;
 
+	*psd = no_free_ptr(sd);
 	return 0;
 }
 
-size_t smb_acl_sec_desc_scratch_len(struct smb_fattr *fattr,
-		struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info)
-{
-	size_t len = sizeof(struct smb_ntsd);
-	size_t tmp;
-
-	if (addition_info & OWNER_SECINFO)
-		len += sizeof(struct smb_sid);
-	if (addition_info & GROUP_SECINFO)
-		len += sizeof(struct smb_sid);
-	if (!(addition_info & DACL_SECINFO))
-		return len;
-
-	len += sizeof(struct smb_acl);
-	if (ppntsd && ppntsd_size > 0) {
-		unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
-
-		if (dacl_offset < ppntsd_size &&
-		    check_add_overflow(len, ppntsd_size - dacl_offset, &len))
-			return 0;
-	}
-
-	if (fattr->cf_acls) {
-		if (check_mul_overflow((size_t)fattr->cf_acls->a_count,
-					2 * sizeof(struct smb_ace), &tmp) ||
-		    check_add_overflow(len, tmp, &len))
-			return 0;
-	} else {
-		/* default/minimum DACL */
-		if (check_add_overflow(len, 5 * sizeof(struct smb_ace), &len))
-			return 0;
-	}
-
-	if (fattr->cf_dacls) {
-		if (check_mul_overflow((size_t)fattr->cf_dacls->a_count,
-					sizeof(struct smb_ace), &tmp) ||
-		    check_add_overflow(len, tmp, &len))
-			return 0;
-	}
-
-	return len;
-}
-
 /* Convert permission bits from mode to equivalent CIFS ACL */
 int build_sec_desc(const struct mnt_idmap *idmap,
-		   struct smb_ntsd *pntsd, struct smb_ntsd *ppntsd,
-		   int ppntsd_size, int addition_info, __u32 *secdesclen,
+		   struct smb_ntsd **pntsd, const struct ksmbd_sd *ppntsd,
+		   int addition_info, __u32 *secdesclen,
 		   struct smb_fattr *fattr)
 {
 	int rc = 0;
-	__u32 offset;
-	struct smb_sid *owner_sid_ptr, *group_sid_ptr;
 	struct smb_sid *nowner_sid_ptr, *ngroup_sid_ptr;
-	struct smb_acl *dacl_ptr = NULL; /* no need for SACL ptr */
+	struct smb_sid *sids = NULL;
+	struct ksmbd_sd *sd = NULL;
+	size_t num_aces = 0, num_sids = 0, len = 0;
 	uid_t uid;
 	gid_t gid;
 	unsigned int sid_type = SIDOWNER;
 
+	*pntsd = NULL;
 	nowner_sid_ptr = kmalloc_obj(struct smb_sid, KSMBD_DEFAULT_GFP);
 	if (!nowner_sid_ptr)
 		return -ENOMEM;
@@ -1109,10 +866,30 @@ int build_sec_desc(const struct mnt_idmap *idmap,
 	gid = from_kgid(&init_user_ns, fattr->cf_gid);
 	id_to_sid(gid, SIDUNIX_GROUP, ngroup_sid_ptr);
 
-	offset = sizeof(struct smb_ntsd);
-	pntsd->sacloffset = 0;
-	pntsd->revision = cpu_to_le16(1);
-	pntsd->type = cpu_to_le16(SELF_RELATIVE);
+	/* Room for every ACE that set_mode_dacl() or set_ntacl_dacl() adds */
+	if (addition_info & DACL_SECINFO) {
+		if (ppntsd)
+			num_aces = ppntsd->num_aces;
+		if (fattr->cf_acls) {
+			num_aces += 2 * fattr->cf_acls->a_count;
+			num_sids = fattr->cf_acls->a_count;
+		} else if (!ppntsd) {
+			num_aces = 5;
+		}
+		if (fattr->cf_dacls) {
+			num_aces += fattr->cf_dacls->a_count;
+			num_sids += fattr->cf_dacls->a_count;
+		}
+	}
+
+	sd = kvzalloc(struct_size(sd, aces, num_aces), KSMBD_DEFAULT_GFP);
+	sids = kvmalloc_array(num_sids, sizeof(*sids), KSMBD_DEFAULT_GFP);
+	if (!sd || !sids) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	sd->num_aces = num_aces;
+
 	if (ppntsd) {
 		u16 flags = 0;
 
@@ -1122,129 +899,51 @@ int build_sec_desc(const struct mnt_idmap *idmap,
 		if (addition_info & GROUP_SECINFO)
 			flags |= GROUP_DEFAULTED;
 		if (addition_info & DACL_SECINFO)
-			flags |= DACL_PRESENT | DACL_DEFAULTED |
-				 DACL_AUTO_INHERITED | DACL_PROTECTED;
-		pntsd->type |= ppntsd->type & cpu_to_le16(flags);
+			flags |= DACL_DEFAULTED | DACL_AUTO_INHERITED |
+				 DACL_PROTECTED;
+		sd->control |= ppntsd->control & flags;
 	}
 
-	if (addition_info & OWNER_SECINFO) {
-		pntsd->osidoffset = cpu_to_le32(offset);
-		owner_sid_ptr = (struct smb_sid *)((char *)pntsd + offset);
-		smb_copy_sid(owner_sid_ptr, nowner_sid_ptr);
-		offset += 1 + 1 + 6 + (nowner_sid_ptr->num_subauth * 4);
-	}
+	if (addition_info & OWNER_SECINFO)
+		sd->owner = nowner_sid_ptr;
 
-	if (addition_info & GROUP_SECINFO) {
-		pntsd->gsidoffset = cpu_to_le32(offset);
-		group_sid_ptr = (struct smb_sid *)((char *)pntsd + offset);
-		smb_copy_sid(group_sid_ptr, ngroup_sid_ptr);
-		offset += 1 + 1 + 6 + (ngroup_sid_ptr->num_subauth * 4);
-	}
+	if (addition_info & GROUP_SECINFO)
+		sd->group = ngroup_sid_ptr;
 
 	if (addition_info & DACL_SECINFO) {
-		pntsd->type |= cpu_to_le16(DACL_PRESENT);
-		dacl_ptr = (struct smb_acl *)((char *)pntsd + offset);
-		dacl_ptr->revision = cpu_to_le16(2);
-		dacl_ptr->size = cpu_to_le16(sizeof(struct smb_acl));
-		dacl_ptr->num_aces = 0;
-
 		if (!ppntsd) {
-			set_mode_dacl(idmap, dacl_ptr, fattr);
+			sd->dacl = KSMBD_ACL_PRESENT;
+			set_mode_dacl(idmap, sd, nowner_sid_ptr, ngroup_sid_ptr,
+				      fattr, sids);
+		} else if (ppntsd->dacl == KSMBD_ACL_PRESENT) {
+			sd->dacl = KSMBD_ACL_PRESENT;
+			set_ntacl_dacl(idmap, sd, ppntsd, fattr, sids);
 		} else {
-			struct smb_acl *ppdacl_ptr;
-			unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
-			int ppdacl_size, ntacl_size = ppntsd_size - dacl_offset;
-			size_t dacl_struct_end;
-
-			if (!dacl_offset ||
-			    check_add_overflow(dacl_offset, sizeof(struct smb_acl),
-					       &dacl_struct_end) ||
-			    dacl_struct_end > (size_t)ppntsd_size)
-				goto out;
-
-			ppdacl_ptr = (struct smb_acl *)((char *)ppntsd + dacl_offset);
-			ppdacl_size = le16_to_cpu(ppdacl_ptr->size);
-			if (ppdacl_size > ntacl_size ||
-			    ppdacl_size < sizeof(struct smb_acl))
-				goto out;
-
-			set_ntacl_dacl(idmap, dacl_ptr, ppdacl_ptr,
-				       ntacl_size - sizeof(struct smb_acl),
-				       nowner_sid_ptr, ngroup_sid_ptr,
-				       fattr);
+			sd->dacl = KSMBD_ACL_NULL;
 		}
-		pntsd->dacloffset = cpu_to_le32(offset);
-		offset += le16_to_cpu(dacl_ptr->size);
 	}
+	if (sd->dacl != KSMBD_ACL_PRESENT)
+		sd->num_aces = 0;
 
+	rc = ksmbd_sd_encode(sd, (u8 **)pntsd, &len);
+	*secdesclen = len;
 out:
 	kfree(nowner_sid_ptr);
 	kfree(ngroup_sid_ptr);
-	*secdesclen = offset;
+	kvfree(sids);
+	kvfree(sd);
 	return rc;
 }
 
-static void smb_set_ace(struct smb_ace *ace, const struct smb_sid *sid, u8 type,
-			u8 flags, __le32 access_req)
-{
-	ace->type = type;
-	ace->flags = flags;
-	ace->access_req = access_req;
-	smb_copy_sid(&ace->sid, sid);
-	ace->size = cpu_to_le16(1 + 1 + 2 + 4 + 1 + 1 + 6 +
-				(ace->sid.num_subauth * 4));
-}
-
-static int smb_append_inherited_ace(struct smb_ace **ace, int *nt_size,
-				    u16 *ace_cnt, const struct smb_sid *sid,
-				    u8 type, u8 flags, __le32 access_req)
-{
-	int ace_size;
-
-	smb_set_ace(*ace, sid, type, flags, access_req);
-	ace_size = le16_to_cpu((*ace)->size);
-	/* pdacl->size is __le16 and includes struct smb_acl. */
-	if (check_add_overflow(*nt_size, ace_size, nt_size) ||
-	    *nt_size > U16_MAX - (int)sizeof(struct smb_acl))
-		return -EINVAL;
-
-	(*ace_cnt)++;
-	*ace = (struct smb_ace *)((char *)*ace + ace_size);
-	return 0;
-}
-
-static int smb_validate_ntsd_sid(struct smb_ntsd *pntsd, size_t pntsd_size,
-				  unsigned int sid_offset, struct smb_sid **sid,
-				  size_t *sid_size)
+static void smb_append_inherited_ace(struct ksmbd_sd *sd, u16 *ace_cnt,
+				     const struct ksmbd_ace *parent_ace,
+				     const struct smb_sid *sid, u8 flags)
 {
-	size_t sid_end;
-
-	*sid = NULL;
-	*sid_size = 0;
-
-	if (!sid_offset)
-		return 0;
+	struct ksmbd_ace *ace = &sd->aces[(*ace_cnt)++];
 
-	if (sid_offset < sizeof(struct smb_ntsd) ||
-	    check_add_overflow(sid_offset, (size_t)CIFS_SID_BASE_SIZE,
-			       &sid_end) ||
-	    sid_end > pntsd_size)
-		return -EINVAL;
-
-	*sid = (struct smb_sid *)((char *)pntsd + sid_offset);
-	if ((*sid)->num_subauth > SID_MAX_SUB_AUTHORITIES)
-		return -EINVAL;
-
-	if (check_add_overflow((size_t)CIFS_SID_BASE_SIZE,
-			       sizeof(__le32) * (size_t)(*sid)->num_subauth,
-			       &sid_end))
-		return -EINVAL;
-
-	if (sid_offset > pntsd_size || sid_end > pntsd_size - sid_offset)
-		return -EINVAL;
-
-	*sid_size = sid_end;
-	return 0;
+	*ace = *parent_ace;
+	ace->flags = flags;
+	ace->sid = sid;
 }
 
 int smb_inherit_dacl(struct ksmbd_conn *conn,
@@ -1252,18 +951,14 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		     unsigned int uid, unsigned int gid)
 {
 	const struct smb_sid *psid, *creator = NULL;
-	struct smb_ace *parent_aces, *aces;
-	struct smb_acl *parent_pdacl;
-	struct smb_ntsd *parent_pntsd = NULL;
+	const struct ksmbd_ace *parent_aces;
+	struct ksmbd_sd *parent_pntsd = NULL, *sd;
 	struct smb_sid owner_sid, group_sid;
 	struct dentry *parent;
 	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
-	int inherited_flags = 0, flags = 0, i, nt_size = 0, pdacl_size;
-	int rc = 0, pntsd_type, ppntsd_size, acl_len, aces_size;
-	unsigned int dacloffset;
-	size_t dacl_struct_end;
+	int inherited_flags = 0, flags = 0, i;
+	int rc;
 	u16 num_aces, ace_cnt = 0;
-	char *aces_base;
 	bool is_dir = S_ISDIR(d_inode(path->dentry)->i_mode);
 
 	parent = dget_parent(path->dentry);
@@ -1271,85 +966,32 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		dput(parent);
 		return -ENOENT;
 	}
-	ppntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap,
-					    parent, &parent_pntsd);
+	rc = ksmbd_vfs_get_sd_xattr(conn, idmap, parent, &parent_pntsd);
 	dput(parent);
-	if (ppntsd_size <= 0)
+	if (rc)
 		return -ENOENT;
 
-	dacloffset = le32_to_cpu(parent_pntsd->dacloffset);
-	if (!dacloffset ||
-	    check_add_overflow(dacloffset, sizeof(struct smb_acl), &dacl_struct_end) ||
-	    dacl_struct_end > (size_t)ppntsd_size) {
-		rc = -EINVAL;
-		goto free_parent_pntsd;
-	}
-
-	parent_pdacl = (struct smb_acl *)((char *)parent_pntsd + dacloffset);
-	acl_len = ppntsd_size - dacloffset;
-	num_aces = le16_to_cpu(parent_pdacl->num_aces);
-	pntsd_type = le16_to_cpu(parent_pntsd->type);
-	pdacl_size = le16_to_cpu(parent_pdacl->size);
-
-	if (pdacl_size > acl_len || pdacl_size < sizeof(struct smb_acl)) {
+	if (parent_pntsd->dacl != KSMBD_ACL_PRESENT) {
 		rc = -EINVAL;
 		goto free_parent_pntsd;
 	}
 
-	aces_size = pdacl_size - sizeof(struct smb_acl);
-
-	/*
-	 * Validate num_aces against the DACL payload before allocating.
-	 * Each ACE must be at least as large as its fixed-size header
-	 * (up to the SID base), so num_aces cannot exceed the payload
-	 * divided by the minimum ACE size.  This mirrors the existing
-	 * check in parse_dacl().
-	 */
-	if (num_aces > aces_size / (offsetof(struct smb_ace, sid) +
-				    offsetof(struct smb_sid, sub_auth) +
-				    sizeof(__le16))) {
-		rc = -EINVAL;
-		goto free_parent_pntsd;
-	}
-
-	aces_base = kmalloc_array(num_aces * 2, sizeof(struct smb_ace),
-				  KSMBD_DEFAULT_GFP);
-	if (!aces_base) {
+	num_aces = parent_pntsd->num_aces;
+	sd = kvzalloc(struct_size(sd, aces, num_aces * 2), KSMBD_DEFAULT_GFP);
+	if (!sd) {
 		rc = -ENOMEM;
 		goto free_parent_pntsd;
 	}
+	sd->num_aces = num_aces * 2;
 
-	aces = (struct smb_ace *)aces_base;
-	parent_aces = (struct smb_ace *)((char *)parent_pdacl +
-			sizeof(struct smb_acl));
-
-	if (pntsd_type & DACL_AUTO_INHERITED)
+	if (parent_pntsd->control & DACL_AUTO_INHERITED)
 		inherited_flags = INHERITED_ACE;
 
 	for (i = 0; i < num_aces; i++) {
-		int pace_size;
-
-		if (aces_size < offsetof(struct smb_ace, sid) +
-		    CIFS_SID_BASE_SIZE)
-			break;
-
-		pace_size = le16_to_cpu(parent_aces->size);
-		if (pace_size > aces_size ||
-		    pace_size < offsetof(struct smb_ace, sid) +
-				CIFS_SID_BASE_SIZE)
-			break;
-
-		if (parent_aces->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
-		    pace_size < offsetof(struct smb_ace, sid) +
-				CIFS_SID_BASE_SIZE +
-				sizeof(__le32) * parent_aces->sid.num_subauth)
-			break;
-
-		aces_size -= pace_size;
-
+		parent_aces = &parent_pntsd->aces[i];
 		flags = parent_aces->flags;
 		if (!smb_inherit_flags(flags, is_dir))
-			goto pass;
+			continue;
 		if (is_dir) {
 			flags &= ~(INHERIT_ONLY_ACE | INHERITED_ACE);
 			if (!(flags & CONTAINER_INHERIT_ACE))
@@ -1360,121 +1002,52 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 			flags = 0;
 		}
 
-		if (!compare_sids(&creator_owner, &parent_aces->sid)) {
+		if (!compare_sids(&creator_owner, parent_aces->sid)) {
 			creator = &creator_owner;
 			id_to_sid(uid, SIDOWNER, &owner_sid);
 			psid = &owner_sid;
-		} else if (!compare_sids(&creator_group, &parent_aces->sid)) {
+		} else if (!compare_sids(&creator_group, parent_aces->sid)) {
 			creator = &creator_group;
 			id_to_sid(gid, SIDUNIX_GROUP, &group_sid);
 			psid = &group_sid;
 		} else {
 			creator = NULL;
-			psid = &parent_aces->sid;
+			psid = parent_aces->sid;
 		}
 
 		if (is_dir && creator && flags & CONTAINER_INHERIT_ACE) {
-			rc = smb_append_inherited_ace(&aces, &nt_size, &ace_cnt,
-						      psid, parent_aces->type,
-						      inherited_flags,
-						      parent_aces->access_req);
-			if (rc)
-				goto free_aces_base;
+			smb_append_inherited_ace(sd, &ace_cnt, parent_aces,
+						 psid, inherited_flags);
 			flags |= INHERIT_ONLY_ACE;
 			psid = creator;
 		} else if (is_dir && !(parent_aces->flags & NO_PROPAGATE_INHERIT_ACE)) {
-			psid = &parent_aces->sid;
+			psid = parent_aces->sid;
 		}
 
-		rc = smb_append_inherited_ace(&aces, &nt_size, &ace_cnt, psid,
-					      parent_aces->type,
-					      flags | inherited_flags,
-					      parent_aces->access_req);
-		if (rc)
-			goto free_aces_base;
-pass:
-		parent_aces = (struct smb_ace *)((char *)parent_aces + pace_size);
+		smb_append_inherited_ace(sd, &ace_cnt, parent_aces, psid,
+					 flags | inherited_flags);
 	}
 
-	if (nt_size > 0) {
-		struct smb_ntsd *pntsd;
-		struct smb_acl *pdacl;
-		struct smb_sid *powner_sid = NULL, *pgroup_sid = NULL;
-		size_t powner_sid_size = 0, pgroup_sid_size = 0, pntsd_size;
-		size_t pntsd_alloc_size;
+	if (ace_cnt) {
+		size_t pntsd_size;
+		u8 *pntsd;
 
-		rc = smb_validate_ntsd_sid(parent_pntsd, ppntsd_size,
-					   le32_to_cpu(parent_pntsd->osidoffset),
-					   &powner_sid, &powner_sid_size);
-		if (rc)
-			goto free_aces_base;
-		rc = smb_validate_ntsd_sid(parent_pntsd, ppntsd_size,
-					   le32_to_cpu(parent_pntsd->gsidoffset),
-					   &pgroup_sid, &pgroup_sid_size);
+		sd->num_aces = ace_cnt;
+		sd->dacl = KSMBD_ACL_PRESENT;
+		sd->control = parent_pntsd->control & DACL_AUTO_INHERITED;
+		sd->owner = parent_pntsd->owner;
+		sd->group = parent_pntsd->group;
+		rc = ksmbd_sd_encode(sd, &pntsd, &pntsd_size);
 		if (rc)
 			goto free_aces_base;
 
-		if (check_add_overflow(sizeof(struct smb_ntsd),
-				       (size_t)powner_sid_size,
-				       &pntsd_alloc_size) ||
-		    check_add_overflow(pntsd_alloc_size,
-				       (size_t)pgroup_sid_size,
-				       &pntsd_alloc_size) ||
-		    check_add_overflow(pntsd_alloc_size, sizeof(struct smb_acl),
-				       &pntsd_alloc_size) ||
-		    check_add_overflow(pntsd_alloc_size, (size_t)nt_size,
-				       &pntsd_alloc_size)) {
-			rc = -EINVAL;
-			goto free_aces_base;
-		}
-
-		pntsd = kzalloc(pntsd_alloc_size, KSMBD_DEFAULT_GFP);
-		if (!pntsd) {
-			rc = -ENOMEM;
-			goto free_aces_base;
-		}
-
-		pntsd->revision = cpu_to_le16(1);
-		pntsd->type = cpu_to_le16(SELF_RELATIVE | DACL_PRESENT);
-		if (le16_to_cpu(parent_pntsd->type) & DACL_AUTO_INHERITED)
-			pntsd->type |= cpu_to_le16(DACL_AUTO_INHERITED);
-		pntsd_size = sizeof(struct smb_ntsd);
-
-		/*
-		 * Lay out the child as owner, group and DACL. The parent may
-		 * store its components in another order, so its offsets do
-		 * not fit the child.
-		 */
-		if (powner_sid) {
-			pntsd->osidoffset = cpu_to_le32(pntsd_size);
-			memcpy((char *)pntsd + pntsd_size, powner_sid,
-			       powner_sid_size);
-			pntsd_size += powner_sid_size;
-		}
-
-		if (pgroup_sid) {
-			pntsd->gsidoffset = cpu_to_le32(pntsd_size);
-			memcpy((char *)pntsd + pntsd_size, pgroup_sid,
-			       pgroup_sid_size);
-			pntsd_size += pgroup_sid_size;
-		}
-
-		pntsd->dacloffset = cpu_to_le32(pntsd_size);
-		pdacl = (struct smb_acl *)((char *)pntsd + pntsd_size);
-		pdacl->revision = cpu_to_le16(2);
-		pdacl->size = cpu_to_le16(sizeof(struct smb_acl) + nt_size);
-		pdacl->num_aces = cpu_to_le16(ace_cnt);
-		memcpy((char *)pdacl + sizeof(struct smb_acl), aces_base, nt_size);
-		pntsd_size += sizeof(struct smb_acl) + nt_size;
-
 		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size);
-		kfree(pntsd);
+		kvfree(pntsd);
 	}
-
 free_aces_base:
-	kfree(aces_base);
+	kvfree(sd);
 free_parent_pntsd:
-	kfree(parent_pntsd);
+	kvfree(parent_pntsd);
 	return rc;
 }
 
@@ -1536,25 +1109,21 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			bool authenticated, bool strict)
 {
 	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
-	struct smb_ntsd *pntsd = NULL;
-	struct smb_acl *pdacl;
+	struct ksmbd_sd *sd = NULL;
 	struct posix_acl *posix_acls;
-	int rc = 0, pntsd_size, acl_size, aces_size, pdacl_size;
-	unsigned int dacl_offset;
-	size_t dacl_struct_end;
+	int rc;
 	struct smb_sid sid;
 	int requested = le32_to_cpu(*pdaccess & ~FILE_MAXIMAL_ACCESS_LE);
 	int granted = requested;
-	struct smb_ace *ace;
+	const struct ksmbd_ace *ace;
 	int i, found = 0;
 	unsigned int access_bits = 0, denied = 0, grp_granted = 0;
 	unsigned int grp_allowed = 0, grp_denied = 0, bits;
-	struct smb_ace *others_ace = NULL;
+	const struct ksmbd_ace *others_ace = NULL;
 	bool or_ace = false, obj_deny = false, au_ace = false, member, counted;
 	bool grp_ace = false;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
-	unsigned short ace_size;
 	bool is_owner, owner_rights = false;
 	bool maximal = *pdaccess & FILE_MAXIMAL_ACCESS_LE;
 	/*
@@ -1567,25 +1136,16 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
-	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap,
-					    path->dentry, &pntsd);
-	if (pntsd_size <= 0 || !pntsd) {
-		if (pntsd_size < 0 && !smb_no_stored_sd(pntsd_size))
-			rc = pntsd_size == -ENOMEM ? -ENOMEM : -EACCES;
+	rc = ksmbd_vfs_get_sd_xattr(conn, idmap, path->dentry, &sd);
+	if (rc) {
+		if (smb_no_stored_sd(rc))
+			rc = 0;
+		else if (rc != -ENOMEM)
+			rc = -EACCES;
 		goto err_out;
 	}
 
-	dacl_offset = le32_to_cpu(pntsd->dacloffset);
-	if (!dacl_offset ||
-	    check_add_overflow(dacl_offset, sizeof(struct smb_acl), &dacl_struct_end) ||
-	    dacl_struct_end > (size_t)pntsd_size)
-		goto err_out;
-
-	pdacl = (struct smb_acl *)((char *)pntsd + le32_to_cpu(pntsd->dacloffset));
-	acl_size = pntsd_size - dacl_offset;
-	pdacl_size = le16_to_cpu(pdacl->size);
-
-	if (pdacl_size > acl_size || pdacl_size < sizeof(struct smb_acl))
+	if (sd->dacl != KSMBD_ACL_PRESENT)
 		goto err_out;
 
 	if (!uid)
@@ -1594,7 +1154,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	vfsuid = i_uid_into_vfsuid(idmap, d_inode(path->dentry));
 	is_owner = uid == from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
 
-	if (!pdacl->num_aces) {
+	if (!sd->num_aces) {
 		unsigned int allowed = 0;
 
 		/*
@@ -1627,58 +1187,44 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	 * owner, grant. It is used when the SID lookup and POSIX ACL fallback
 	 * below do not decide.
 	 */
-	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-	aces_size = pdacl_size - sizeof(struct smb_acl);
-	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-		if (aces_size < offsetof(struct smb_ace, sid) +
-		    CIFS_SID_BASE_SIZE)
-			break;
-		ace_size = le16_to_cpu(ace->size);
-		if (ace_size > aces_size ||
-		    ace_size < offsetof(struct smb_ace, sid) +
-			       CIFS_SID_BASE_SIZE)
-			break;
-		aces_size -= ace_size;
-
-		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
-		    ace_size < offsetof(struct smb_ace, sid) +
-			      CIFS_SID_BASE_SIZE +
-			      sizeof(__le32) * ace->sid.num_subauth)
-			break;
-
+	for (i = 0; i < sd->num_aces; i++) {
+		ace = &sd->aces[i];
 		if ((ace->type == ACCESS_DENIED_OBJECT_ACE_TYPE ||
 		     ace->type == ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE) &&
 		    !(ace->flags & INHERIT_ONLY_ACE))
 			obj_deny = true;
+		/* ksmbd evaluates no object ACE, so one matches no one */
+		if (ace->obj_len)
+			continue;
 
-		if (!compare_sids(&sid_owner_rights, &ace->sid)) {
+		if (!compare_sids(&sid_owner_rights, ace->sid)) {
 			owner_rights = true;
 			if (!is_owner)
-				goto next_ace;
+				continue;
 		}
 
-		member = smb_sid_in_group(&ace->sid);
+		member = smb_sid_in_group(ace->sid);
 		/* The grp_ masks count groups and OWNER RIGHTS only */
 		counted = member ||
-			  (is_owner && smb_sid_is_owner_rights(&ace->sid));
+			  (is_owner && smb_sid_is_owner_rights(ace->sid));
 		if (ace->flags & INHERIT_ONLY_ACE ||
-		    (compare_sids(&sid, &ace->sid) &&
-		     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
-		     compare_sids(&sid_everyone, &ace->sid) &&
+		    (compare_sids(&sid, ace->sid) &&
+		     compare_sids(&sid_unix_NFS_mode, ace->sid) &&
+		     compare_sids(&sid_everyone, ace->sid) &&
 		     (!authusers ||
-		      compare_sids(&sid_authusers, &ace->sid)) &&
-		     compare_sids(&sid_owner_rights, &ace->sid) &&
+		      compare_sids(&sid_authusers, ace->sid)) &&
+		     compare_sids(&sid_owner_rights, ace->sid) &&
 		     !member))
-			goto next_ace;
+			continue;
 		/* Other requests count only SIDs that match exactly */
 		if (!open_max && !member &&
-		    !smb_sid_equal(&sid, &ace->sid) &&
-		    !smb_sid_equal(&sid_everyone, &ace->sid) &&
-		    !(authusers && smb_sid_equal(&sid_authusers, &ace->sid)) &&
-		    !smb_sid_is_owner_rights(&ace->sid))
-			goto next_ace;
+		    !smb_sid_equal(&sid, ace->sid) &&
+		    !smb_sid_equal(&sid_everyone, ace->sid) &&
+		    !(authusers && smb_sid_equal(&sid_authusers, ace->sid)) &&
+		    !smb_sid_is_owner_rights(ace->sid))
+			continue;
 
-		bits = le32_to_cpu(ace->access_req);
+		bits = ace->mask;
 		switch (ace->type) {
 		case ACCESS_ALLOWED_ACE_TYPE:
 			grp_ace |= counted;
@@ -1701,8 +1247,6 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 				denied |= ~access_bits & bits;
 			break;
 		}
-next_ace:
-		ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 	}
 
 	/* Keep only file rights, not MAXIMUM_ALLOWED or generic bits */
@@ -1731,40 +1275,24 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		access_bits = 0;
 	}
 
-	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-	aces_size = pdacl_size - sizeof(struct smb_acl);
-	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-		if (aces_size < offsetof(struct smb_ace, sid) +
-		    CIFS_SID_BASE_SIZE)
-			break;
-		ace_size = le16_to_cpu(ace->size);
-		if (ace_size > aces_size ||
-		    ace_size < offsetof(struct smb_ace, sid) +
-			       CIFS_SID_BASE_SIZE)
-			break;
-		aces_size -= ace_size;
-
-		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
-		    ace_size < offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE +
-			      sizeof(__le32) * ace->sid.num_subauth)
-			break;
-
-		if (!compare_sids(&sid, &ace->sid) ||
-		    !compare_sids(&sid_unix_NFS_mode, &ace->sid)) {
+	for (i = 0; i < sd->num_aces; i++) {
+		ace = &sd->aces[i];
+		if (ace->obj_len)
+			continue;
+		if (!compare_sids(&sid, ace->sid) ||
+		    !compare_sids(&sid_unix_NFS_mode, ace->sid)) {
 			found = 1;
 			break;
 		}
-		if (!compare_sids(&sid_owner_rights, &ace->sid) &&
+		if (!compare_sids(&sid_owner_rights, ace->sid) &&
 		    !(ace->flags & INHERIT_ONLY_ACE))
 			or_ace = true;
-		if (!compare_sids(&sid_everyone, &ace->sid) ||
+		if (!compare_sids(&sid_everyone, ace->sid) ||
 		    (authusers &&
-		     !compare_sids(&sid_authusers, &ace->sid)))
+		     !compare_sids(&sid_authusers, ace->sid)))
 			others_ace = ace;
-		if (!compare_sids(&sid_authusers, &ace->sid))
+		if (!compare_sids(&sid_authusers, ace->sid))
 			au_ace = true;
-
-		ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 	}
 
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
@@ -1857,11 +1385,11 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	if (!maximal && obj_deny) {
 		switch (ace->type) {
 		case ACCESS_ALLOWED_ACE_TYPE:
-			access_bits = le32_to_cpu(ace->access_req);
+			access_bits = ace->mask;
 			break;
 		case ACCESS_DENIED_ACE_TYPE:
 		case ACCESS_DENIED_CALLBACK_ACE_TYPE:
-			access_bits = le32_to_cpu(~ace->access_req);
+			access_bits = ~ace->mask;
 			break;
 		}
 	}
@@ -1883,7 +1411,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 	*pdaccess = cpu_to_le32(granted);
 err_out:
-	kfree(pntsd);
+	kvfree(sd);
 	return rc;
 }
 EXPORT_SYMBOL_IF_KUNIT(smb_check_perm_dacl);
@@ -1933,6 +1461,10 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 bool dacl_requested)
 {
 	int rc;
+	struct ksmbd_sd *sd = NULL;
+	size_t store_len;
+	u8 *store = NULL;
+	bool store_sd;
 	struct smb_fattr fattr = {{0}};
 	struct inode *inode = d_inode(path->dentry);
 	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
@@ -1942,7 +1474,7 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	fattr.cf_gid = INVALID_GID;
 	fattr.cf_mode = inode->i_mode;
 
-	rc = parse_sec_desc(idmap, pntsd, ntsd_len, &fattr);
+	rc = parse_sec_desc(idmap, pntsd, ntsd_len, &fattr, &sd);
 	if (rc)
 		goto out;
 	if (fattr.cf_posix_mode && !dacl_requested) {
@@ -1954,6 +1486,19 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		goto out;
 	}
 
+	/*
+	 * Encode the SD to store before anything is changed. The SD of a
+	 * CREATE context (type_check) is stored only if it has a DACL.
+	 */
+	store_sd = test_share_config_flag(tcon->share_conf,
+					  KSMBD_SHARE_FLAG_ACL_XATTR) &&
+		   !(type_check && sd->dacl == KSMBD_ACL_ABSENT);
+	if (store_sd) {
+		rc = ksmbd_sd_encode(sd, &store, &store_len);
+		if (rc)
+			goto out;
+	}
+
 	newattrs.ia_valid = ATTR_CTIME;
 	if (!uid_eq(fattr.cf_uid, INVALID_UID)) {
 		newattrs.ia_valid |= ATTR_UID;
@@ -2001,14 +1546,10 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	if (rc)
 		goto out;
 
-	/* Check it only calling from SD BUFFER context */
-	if (type_check && !(le16_to_cpu(pntsd->type) & DACL_PRESENT))
-		goto out;
-
-	if (test_share_config_flag(tcon->share_conf, KSMBD_SHARE_FLAG_ACL_XATTR)) {
+	if (store_sd) {
 		/* Update WinACL in xattr */
 		ksmbd_vfs_remove_sd_xattrs(idmap, path);
-		rc = ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len);
+		rc = ksmbd_vfs_set_sd_xattr(conn, idmap, path, store, store_len);
 		/*
 		 * The CREATE context (type_check) stays best effort because
 		 * the file exists already. A filesystem without the xattr is
@@ -2019,6 +1560,8 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	}
 
 out:
+	kvfree(store);
+	kvfree(sd);
 	posix_acl_release(fattr.cf_acls);
 	posix_acl_release(fattr.cf_dacls);
 	return rc;
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index b51a8c6c1d4e..b14bbae6ab48 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -38,6 +38,7 @@
 #define SELF_RELATIVE		0x8000
 
 struct ksmbd_conn;
+struct ksmbd_sd;
 
 struct smb_fattr {
 	kuid_t	cf_uid;
@@ -83,9 +84,9 @@ struct posix_acl_state {
 };
 
 int parse_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
-		   int acl_len, struct smb_fattr *fattr);
-int build_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
-		   struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info,
+		   int acl_len, struct smb_fattr *fattr, struct ksmbd_sd **psd);
+int build_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd **pntsd,
+		   const struct ksmbd_sd *ppntsd, int addition_info,
 		   __u32 *secdesclen, struct smb_fattr *fattr);
 int init_acl_state(struct posix_acl_state *state, u16 cnt);
 void free_acl_state(struct posix_acl_state *state);
@@ -95,7 +96,7 @@ int compare_sids(const struct smb_sid *ctsid, const struct smb_sid *cwsid);
 bool smb_inherit_flags(int flags, bool is_dir);
 int smb_inherit_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     unsigned int uid, unsigned int gid);
-/* Missing, unsupported, malformed or stale SDs retain the POSIX fallback */
+/* Missing, unsupported, unreadable, or stale SDs retain the POSIX fallback */
 static inline bool smb_no_stored_sd(int rc)
 {
 	return rc == -ENODATA || rc == -EOPNOTSUPP || rc == -EINVAL;
@@ -110,8 +111,6 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 bool dacl_requested);
 void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid);
 void ksmbd_init_domain(u32 *sub_auth);
-size_t smb_acl_sec_desc_scratch_len(struct smb_fattr *fattr,
-		struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info);
 
 static inline uid_t posix_acl_uid_translate(const struct mnt_idmap *idmap,
 					    struct posix_acl_entry *pace)
diff --git a/fs/smb/server/tests/smbacl_kunit.c b/fs/smb/server/tests/smbacl_kunit.c
index 37d21c10a144..b5c379f8f4e5 100644
--- a/fs/smb/server/tests/smbacl_kunit.c
+++ b/fs/smb/server/tests/smbacl_kunit.c
@@ -262,6 +262,47 @@ ksmbd_smb_check_perm_dacl_maximal_boundary_test(struct kunit *test)
 				mk_vma_flags(VMA_NORESERVE_BIT));
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, file);
 
+	rc = ksmbd_vfs_set_sd_xattr(NULL, mnt_idmap(file->f_path.mnt),
+				    &file->f_path, pntsd, ntsd_size);
+	KUNIT_EXPECT_EQ(test, 0, rc);
+	if (rc)
+		goto out;
+
+	rc = smb_check_perm_dacl(NULL, &file->f_path, &daccess,
+				 FILE_MAXIMAL_ACCESS_LE, 0, true, false);
+
+	/*
+	 * The DACL counts two ACEs and holds one, so the stored descriptor
+	 * is malformed and every request against it is denied.
+	 */
+	KUNIT_EXPECT_EQ(test, -EACCES, rc);
+out:
+	fput(file);
+}
+
+/*
+ * The same descriptor with a DACL that counts its one ACE is well formed.
+ * The trailing ACE is outside the DACL, so maximal access has the read
+ * access of the first ACE and not the write access of the trailing one.
+ */
+static void ksmbd_smb_check_perm_dacl_maximal_test(struct kunit *test)
+{
+	struct file *file;
+	struct smb_ntsd *pntsd;
+	struct smb_acl *pdacl;
+	__le32 daccess = FILE_MAXIMAL_ACCESS_LE;
+	int ntsd_size, rc;
+
+	pntsd = build_boundary_ntsd(test, &test_owner_sid, FILE_READ_DATA,
+				    FILE_WRITE_DATA, &ntsd_size);
+	KUNIT_ASSERT_NOT_NULL(test, pntsd);
+	pdacl = (struct smb_acl *)((char *)pntsd + sizeof(struct smb_ntsd));
+	pdacl->num_aces = cpu_to_le16(1);
+
+	file = shmem_file_setup("ksmbd-kunit-dacl-valid", 0,
+				mk_vma_flags(VMA_NORESERVE_BIT));
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, file);
+
 	rc = ksmbd_vfs_set_sd_xattr(NULL, mnt_idmap(file->f_path.mnt),
 				    &file->f_path, pntsd, ntsd_size);
 	KUNIT_EXPECT_EQ(test, 0, rc);
@@ -319,6 +360,7 @@ static struct kunit_case ksmbd_smbacl_test_cases[] = {
 	KUNIT_CASE(ksmbd_dacl_walk_must_stop_at_declared_size),
 	KUNIT_CASE(ksmbd_smb_check_perm_dacl_boundary_test),
 	KUNIT_CASE(ksmbd_smb_check_perm_dacl_maximal_boundary_test),
+	KUNIT_CASE(ksmbd_smb_check_perm_dacl_maximal_test),
 	KUNIT_CASE(ksmbd_vfs_set_sd_xattr_keeps_caller_sd_test),
 	{}
 };
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 39bbe6aad629..5b0722fe7788 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -29,6 +29,7 @@
 #include "connection.h"
 #include "vfs.h"
 #include "vfs_cache.h"
+#include "secdesc.h"
 #include "smbacl.h"
 #include "ndr.h"
 #include "auth.h"
@@ -1699,7 +1700,7 @@ static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(const struct mnt_idm
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
 			   const struct path *path,
-			   const struct smb_ntsd *pntsd, int len)
+			   const void *pntsd, int len)
 {
 	int rc;
 	struct ndr sd_ndr = {0}, acl_ndr = {0};
@@ -1780,10 +1781,13 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 }
 EXPORT_SYMBOL_IF_KUNIT(ksmbd_vfs_set_sd_xattr);
 
+/*
+ * Returns -EBADMSG if the stored SD is malformed. The caller frees *@sd with
+ * kvfree().
+ */
 int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
-			   struct dentry *dentry,
-			   struct smb_ntsd **pntsd)
+			   struct dentry *dentry, struct ksmbd_sd **sd)
 {
 	int rc;
 	struct ndr n;
@@ -1792,10 +1796,12 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	struct xattr_ntacl acl = {0};
 	struct xattr_smb_acl *smb_acl = NULL, *def_smb_acl = NULL;
 	__u8 cmp_hash[XATTR_SD_HASH_SIZE] = {0};
+	struct smb_ntsd *pntsd;
 
+	*sd = NULL;
 	rc = ksmbd_vfs_getxattr(idmap, dentry, XATTR_NAME_SD, &n.data);
 	if (rc <= 0)
-		return rc;
+		return rc ?: -ENODATA;
 
 	n.length = rc;
 	rc = ndr_decode_v4_ntacl(&n, &acl);
@@ -1836,29 +1842,29 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 		goto out_free;
 	}
 
-	*pntsd = acl.sd_buf;
+	pntsd = acl.sd_buf;
 	if (acl.sd_size < sizeof(struct smb_ntsd)) {
-		pr_err("sd size is invalid\n");
-		rc = -EINVAL;
-		goto out_free;
-	}
-
-	(*pntsd)->osidoffset = cpu_to_le32(le32_to_cpu((*pntsd)->osidoffset) -
-					   NDR_NTSD_OFFSETOF);
-	(*pntsd)->gsidoffset = cpu_to_le32(le32_to_cpu((*pntsd)->gsidoffset) -
-					   NDR_NTSD_OFFSETOF);
-	(*pntsd)->dacloffset = cpu_to_le32(le32_to_cpu((*pntsd)->dacloffset) -
-					   NDR_NTSD_OFFSETOF);
-
-	rc = acl.sd_size;
+		rc = -EBADMSG;
+		goto malformed;
+	}
+
+	pntsd->osidoffset = cpu_to_le32(le32_to_cpu(pntsd->osidoffset) -
+					NDR_NTSD_OFFSETOF);
+	pntsd->gsidoffset = cpu_to_le32(le32_to_cpu(pntsd->gsidoffset) -
+					NDR_NTSD_OFFSETOF);
+	pntsd->dacloffset = cpu_to_le32(le32_to_cpu(pntsd->dacloffset) -
+					NDR_NTSD_OFFSETOF);
+
+	rc = ksmbd_sd_decode(acl.sd_buf, acl.sd_size, sd);
+malformed:
+	if (rc == -EBADMSG)
+		pr_warn_ratelimited("malformed stored security descriptor of %pd\n",
+				    dentry);
 out_free:
 	kfree(acl_ndr.data);
 	kfree(smb_acl);
 	kfree(def_smb_acl);
-	if (rc < 0) {
-		kfree(acl.sd_buf);
-		*pntsd = NULL;
-	}
+	kfree(acl.sd_buf);
 	kfree(n.data);
 	return rc;
 }
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index fb184546d26b..a6a42e979022 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -164,11 +164,11 @@ int ksmbd_vfs_remove_sd_xattrs(const struct mnt_idmap *idmap, const struct path
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
 			   const struct path *path,
-			   const struct smb_ntsd *pntsd, int len);
-int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
-			   const struct mnt_idmap *idmap,
-			   struct dentry *dentry,
-			   struct smb_ntsd **pntsd);
+			   const void *pntsd, int len);
+int __must_check ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
+					const struct mnt_idmap *idmap,
+					struct dentry *dentry,
+					struct ksmbd_sd **sd);
 int ksmbd_vfs_set_dos_attrib_xattr(const struct mnt_idmap *idmap,
 				   const struct path *path,
 				   struct xattr_dos_attrib *da,
-- 
2.47.3

