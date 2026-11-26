Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795651524;
	b=a73FM6jcOprWegQfemtwlbca7bFCP2rnJS39uV17F0n/fD/baBaEvT4hcknuM7P5cGpw
	 V0u+Qm9Lp1p8olfKAyli7pAiiWb7rxw6rfFouZwNB1Km6ORjXJfqo1o7/SddrBoR15wkx
	 IYFyLZ1DnUFkBkqyZIa9U3u3PdRnUil6U9fnlEWylAy+nU1dxp71/sc3E4XbXS3MsR+/P
	 lI/jlTlBffyRMiej17h6zvWfEzmuTzqz471WZwW/JM7jmH6tbBcq7MAiptyL+5VlGKiAO
	 Y6yAbUIdVGXUVUwC8Z9EWYOVeyu7a1Zg5QXBq5VR1A+f2fKAe6SiTjzHnLtdSvo3ofA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795651524;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=XAeOAcmFVMHWqDjhOe6xPBzRm35AUucnqHWXeLS8JhA=;
	b=bZWC5tG/bTWQNCRu+8IlcS5niy9FbE2z+Z9OTj6QRy1rrLdW/2xGXJicoTbx3tPK2Nfv
	 cQSWY5A31CfUg1cW/aMDrC+LZlqQ051o2N6afO53jVLIYBjXJB7Y3m1U1biCJDLch/g4B
	 xpka8J27rufD90vDMqruV7JjV73ci7t68LNQI95yh+goiIAHAHjftzWyg25PN2H9/5OFS
	 19pOqvX8oVji/87SdN7UpS22qk5ETHDGNs2CLMAM9KOxAICvwR+LIWdPIV1bk6uG3n631
	 dO2pmVoQ4bk6hSimI2ASLyLjBwKAzmGN7GVN8aH5ozFJzZlN4mko5MEYNXaS1UPYf7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b="VI1K5db/";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=CMNIyMz9;
	arc=none smtp.remote-ip=202.12.124.145
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D22606A31E
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 00:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8D22606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=VI1K5db/;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=CMNIyMz9
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 25DBC1D00535
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 19:05:23 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 25 Nov 2026 19:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795651522; x=
	1795737922; bh=XAeOAcmFVMHWqDjhOe6xPBzRm35AUucnqHWXeLS8JhA=; b=V
	I1K5db/QkxmQyRre5L9HVhIEf/ig5Xr0nbmsrFMc5Z7xUUYCoFGnRSbRokR0UkxC
	SMGnGvaKuG+tqOC/rKevodkkYNZgSnjuF3mS9yM1RB4sebxMX0W24vl3Xa1DnpvT
	n8dpCD90oTWcxD5S5DW0eDzG6f7pjpOTwmJUf0NCizs13VCHR/BldTMcJQPtxLuL
	xNIicH1Vp3z9rsEMwl7qYjTnO14cxO92N5OMrfOd6oxTSCbkmCp766iI+7pGVPjk
	s6wEbsRBBIT5sSqqV9PuAHTnyKYp4oIWNasL7VeX6Pc2nkyiVow1bGhLf2BhEdqP
	KVt4j9XEfRU1+0ONA8wjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795651522; x=1795737922; bh=X
	AeOAcmFVMHWqDjhOe6xPBzRm35AUucnqHWXeLS8JhA=; b=CMNIyMz91bEaF1Rbc
	wO1bI0qn9+xFqfRRL6f7k+44qXXGSahYNVdO0SGczBC/uSEsCpazvyg2uxet6FtN
	O5fuVOTGrUfEQPksjV//DwFA9piXzSwtSsejLpTgLl4oKtQkG9Uh8rpR2H5y7Ru8
	hAfiBQliijkvP3cvvIyv+1ytK30GpORNyMUfMqdqsT6Sb3lNCQSD/H4Vvxht/F/N
	OdsAuu+UKGpr6bOJ4JrfGUbnbL5u6+qrPa/SUsDZvwPGo30sTwVhZButpXLW8jes
	5l5HrmzcnfjIxdzrdALnuSghowWIfBedU4cxyxHMvB9GKjpQhM5mGACxTg9NmNN2
	rlOeQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795651522; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:LKFG/0Nt2x3JSenSut8ZF6F/KhG8LGMdPInGph0dEzzCMat
	yMkNoeP4FDt01nQOwuA6uKZSE8iCc1pm6iqDUCHp5+BZcu0I9yvlpJH/+mEuz5Tv
	UyVCweAfKYoHk3yR11DxhuiBj5OJGHBggSr166OirKkPfh9lbDqpEoco6KYxo0x/
	cx3MN3eTZ5qoJ1wJptYcGdOEd+/uq9461WmaR08PRhQvqPYeDJKZKCga8PWvzJL1
	5qUFZN1kZ3aMq+T16guu4Jf+W/XSTlo2DV68pWKrTJ8JN7izI+Aq1CrVXP9vTIzy
	1l8XXvP2g3sujBBxoIjgl2LiISTHEGxSaC5Dp+g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:pcb2LbpxySOQ4dOMisGs0T3mw5UADA5hL0JhajGFCCM=:IptBBc0HfXjhywr+rfR7Ou7SnM461sA20HilTMfkMtg=;
X-ME-Sender: <xms:wncHaz9ABPOuyGGNNHjFIjDbD0dc7FgBfbK0Vynpoqy8neKdM7RbHg>
    <xme:wncHazY2DR6lNZnDdkxeobtEsuG4K6pw60f9WcaKG__l89iMaV9wYwmpuFD_qX1B7
    SiqemtNOR7KzYR5JXj-FP78O5pwjmR-QGez-G6dBrH_i5ok81YxBd9Arw>
X-ME-Received: <xmr:wncHa63z38B9GVGUaXf94QOKR-ewVRkagdu6VI9bzgqdkcXW4wUSGuG4PcUBhidn>
X-ME-Proxy-Cause: dmFkZTEx0G9z4yOsroN1iT/9V0ivk5kC9v576gDgC2lOpkali9wIE8/ZVsapkMqoEdsK6Y
    MVZmAtTmfnhN2Gt1FBKYcI09SJ0I9Ggd9uVOdDT07VW1RqWTsJG/aXW0TV3vkVMQIWi5E4
    8K92yrD9dZQa3GeaUNveFDzfdgiZAueCHhx9A1uyGM5i004D+Yv6CiCn6ny9ZJIX/Lpet5
    CeQiTQZnHmEoDg2/cXPenzEi6u1s75nSH6aKzW78X15YLuYxiA3buV5Ja1SlZyGXDNJvy7
    Spn5F+8VrC+V1TEXjVtcc/loFVDEXgpSeWV1acVnszdByjXgmZViq1A5vJcpiUPRXpESDM
    WEGQgv27h8h9gpa0YmJiuxLliw6HCS/uiKWnXqP1QIq6r2XOFuH/pae2pWKySrybf5bsgF
    B4+ncmqN7161kJQs5Hrtac/YZiqqrLoF6W9OoZJQQK0AssHBfvbD9SSuHR8Oswq29TKreB
    H3VwWZDjG549WkE3FXeJkSOKngl+38KN1wsty7tozIePGz0VA3Zlk9NOh3PAtDxB0D/WzY
    FWBZNTGacsZOoDvZkGo3/OMU6d1IzpHgcA/S6iejad0HWeszMCs0YT+O10Ya8T1TrM+wWY
    qZyru2hqN0d3zrMOX84zJ13QWqUuUaNQj8a7MAqGQytfvGLowy6kyml29jbQ
X-ME-Proxy: <xmx:wncHa2aeseGkg6eDUK2F0TQuVsPHiaQ2IPePe_9dVjsb17XPXJ4-uA>
    <xmx:wncHa6LkbY0FZsOyr3x9RU8UDH2ZtY3z9IwZdSwHLwSXYrkyWmWvOg>
    <xmx:wncHa9EDvMPba6SkEEfNpOEkLX6gAQFmFCjmchtJpE_lvJhSCYUrjg>
    <xmx:wncHa5vcLxPxj8iEruCgTV7sNqtXxromXE4IX-nlESYKwq1J8YsFkg>
    <xmx:wncHa0Z4H5YHe5WP0uBrQ6Fg-Fih_7EC65PCjGU0WmG32WYdifBlG6MN>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 19:05:21 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 1/4] ksmbd: match SIDs exactly when a DACL is mapped to POSIX
Date: Wed, 25 Nov 2026 18:04:57 -0600
Message-ID: <20261126000500.1375459-2-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126000500.1375459-1-icb@fastmail.org>
References: <20261126000500.1375459-1-icb@fastmail.org>
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

parse_dacl() maps the ACEs of a DACL from a client to the mode and the
POSIX ACLs of the file. It compares the SID of each ACE with the owner,
the group, and Everyone. It uses compare_sids(), which compares only
the sub-authorities that both SIDs have. So a shorter or longer SID
matches as well. An ACE for S-1-1-0-5 sets the mode bits for others. If
the SD names a user of the server's domain as its owner, an ACE for the
domain SID is mapped as the owner's ACE.

Use smb_sid_equal() instead, which also compares the number of
sub-authorities. Do the same for CREATOR OWNER, CREATOR GROUP, and
Authenticated Users. parse_dacl() skips the ACEs for those three. An
ACE that no longer matches is handled like an ACE for any other SID.

The NFS mode ACE has the SID S-1-5-88-3-<mode>. Take the mode only from
a SID with three sub-authorities. Before, a longer SID that starts with
S-1-5-88-3 was read as a mode ACE too.

Move smb_sid_equal() above parse_dacl(), which now calls it.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---
 fs/smb/server/smbacl.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index f287b69fe185..8d2e4c3ff35b 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -376,6 +376,12 @@ void free_acl_state(struct posix_acl_state *state)
 	kfree(state->groups);
 }
 
+/* Whether two SIDs are the same SID */
+static bool smb_sid_equal(const struct smb_sid *a, const struct smb_sid *b)
+{
+	return a->num_subauth == b->num_subauth && !compare_sids(a, b);
+}
+
 static int parse_dacl(const struct mnt_idmap *idmap,
 		      struct ksmbd_sd *sd,
 		      const struct smb_sid *pownersid,
@@ -423,13 +429,13 @@ static int parse_dacl(const struct mnt_idmap *idmap,
 			continue;
 
 		if (ace->type == ACCESS_ALLOWED &&
-		    ace->sid->num_subauth >= 3 &&
+		    ace->sid->num_subauth == 3 &&
 		    !(compare_sids(ace->sid, &sid_unix_NFS_mode))) {
 			fattr->cf_mode =
 				le32_to_cpu(ace->sid->sub_auth[2]);
 			fattr->cf_posix_mode = true;
 			nfs_mode_found = true;
-		} else if (!compare_sids(ace->sid, pownersid)) {
+		} else if (pownersid && smb_sid_equal(ace->sid, pownersid)) {
 			acl_mode = access_flags_to_mode(fattr,
 							cpu_to_le32(ace->mask),
 							ace->type);
@@ -440,7 +446,7 @@ static int parse_dacl(const struct mnt_idmap *idmap,
 				mode |= acl_mode;
 			}
 			owner_found = true;
-		} else if (!compare_sids(ace->sid, pgrpsid) ||
+		} else if ((pgrpsid && smb_sid_equal(ace->sid, pgrpsid)) ||
 			   ace->sid->sub_auth[ace->sid->num_subauth - 1] ==
 			    DOMAIN_USER_RID_LE) {
 			acl_mode = access_flags_to_mode(fattr,
@@ -452,7 +458,7 @@ static int parse_dacl(const struct mnt_idmap *idmap,
 				mode |= acl_mode;
 			}
 			group_found = true;
-		} else if (!compare_sids(ace->sid, &sid_everyone)) {
+		} else if (smb_sid_equal(ace->sid, &sid_everyone)) {
 			acl_mode = access_flags_to_mode(fattr,
 							cpu_to_le32(ace->mask),
 							ace->type);
@@ -462,11 +468,11 @@ static int parse_dacl(const struct mnt_idmap *idmap,
 				mode |= acl_mode;
 			}
 			others_found = true;
-		} else if (!compare_sids(ace->sid, &creator_owner)) {
+		} else if (smb_sid_equal(ace->sid, &creator_owner)) {
 			continue;
-		} else if (!compare_sids(ace->sid, &creator_group)) {
+		} else if (smb_sid_equal(ace->sid, &creator_group)) {
 			continue;
-		} else if (!compare_sids(ace->sid, &sid_authusers)) {
+		} else if (smb_sid_equal(ace->sid, &sid_authusers)) {
 			continue;
 		} else {
 			struct smb_fattr temp_fattr;
@@ -1083,12 +1089,6 @@ static bool smb_sid_in_group(const struct smb_sid *sid)
 	return in_group_p(make_kgid(&init_user_ns, gid));
 }
 
-/* Whether two SIDs are the same SID */
-static bool smb_sid_equal(const struct smb_sid *a, const struct smb_sid *b)
-{
-	return a->num_subauth == b->num_subauth && !compare_sids(a, b);
-}
-
 /*
  * compare_sids() compares only the sub-authorities both SIDs have, so it
  * also matches a shorter or longer SID, such as S-1-3 or S-1-3-4-777
-- 
2.47.3

