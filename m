Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795651534;
	b=c7oGkxu8E2+6P0rAhMpYivNVHkyWsEuVJ/oTSCkpHe55dNghWIg+swlbmdfmEUQueQPC
	 hi4o/wlRa2D/HTjNHVgP9P5GlOIVS4haXjliZmSmWYcsGyAuv7uQq9RinZYpomisokhPL
	 EbmVwQw8t/tJAMobPW19ppQuO+zS/fZT5Si/6s0r6vll7Lkj3xt8ryR9bWjCTf1TborUt
	 Rr1i7NiQlSsZUYO6bY3/EVZqImTcERHoXm6QtcO4WSVzSuBJKyT0BjZO+IWDW0uBDIm2z
	 kIxeHE6JnM+ReXk3kUaGvGRZCAz5qB4MCCTqf3fTcZLx4Uwy/PNI+EhidzXAKfN0SoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795651534;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=qATJDwTIxhaEbbgMb5aNqp7FUe5rrGo3pA2kBVJDG8A=;
	b=dNf/4TulA5VOC6tOlGjoh6nYFgBwhdS9/ze3Sl+vpV0LUvz8y+z4QZtL/3nL9FFltq7Q
	 GWZ4U4uP+Tqdk1ESP/lqszUivqpcQnwTJGFFDFIzH5JVP2Xt5CcDwU9yz7GVwbF6Pwaqc
	 YPksyGjriwTuoZsrU6oZLZ9fr3rcyjx8mkyBQNinPIw045H27sscR8e12qlnjr7LHNfow
	 gOLvsnDx+s1LMSb8cGovFCM7MS7nPCkxqbw1UQC8mQdtU9tRgG1OW/Ky5kls2SxJvpPZ3
	 pyqsJrtT/LL2FDxFmI6y0t+N1Qn8GX56ZtSTJ9dXd+rgG1Z98He3Zl4y/0+kAMQSZ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=phCWr4ed;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=spsV8nsH;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CA6606A31E
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 00:05:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45CA6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=phCWr4ed;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=spsV8nsH
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8C5A67A04CE
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 19:05:33 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 25 Nov 2026 19:05:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795651532; x=
	1795737932; bh=qATJDwTIxhaEbbgMb5aNqp7FUe5rrGo3pA2kBVJDG8A=; b=p
	hCWr4edq2waZ4s3rXmCeft9i3r1VZr1AnokI8DEls0LyYvRzPyGgMKfDLqF4Iq1B
	PkEVSWLxQy1Lm78JXGE8962qwMWXuHt62OKEURVGSDPCoQ6evDgWlpxE0QQXaC+H
	sVTEV2fDFCir8M7wELmEh7R6Rh61DjGFnPY9DcsedbIuDUhNVrcLLFE9BI5J2/nu
	GBfi6Hcz+IijIOYpEW48/jBbcTTNrIS6hQVLhKM2z8vOxX7yv6GV9Pi0IyZ25aIE
	gOuKIF/aRChRrYKhlYWtgLsqc8QgR5Tuhgrg7W3VSj0BJoqhup/f7eBBEIr9Qc8/
	LrpClHa/pogzFhptMp9iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795651532; x=1795737932; bh=q
	ATJDwTIxhaEbbgMb5aNqp7FUe5rrGo3pA2kBVJDG8A=; b=spsV8nsHFqIrauwCm
	HCDX6CIo2UXz6DX0gqdRuQo//YxuRmN6QKFZOEu/kQTKA7SPZbugH4Ghn3uf2ZZo
	bjJEsKu9dBHTSmFrctV4IYrmagkDkuDd+Sl0t2/RDLFHbeKBl2OZ/LnXIC5UJ5eZ
	SaPcKkVFrdhl2iR6TxXTZsly5mHGgqmYizQ6R1BSWc120/f4+ZENYVIgKQuKl672
	ModakXSz9A9FVGgrtwCnhbuqoQlunJWYk31sGmkgKxh2HlxUEhSqv/be+vzcEZk1
	VHd6SRGCYF0ZCTZsXAotG4LgrbY5bCm78flWZf2GLWKD1ZSLHgQivYPkT6RIRks4
	xJFng==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795651532; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:fes468BS9d3AsGm0eEtk4SwdYK6tOpJ+15a/PAUaZVFdDwn
	8FU0JOVRFSedfOz3Iz9HRF3P0QXppnR9yadIX9KWewOCPyBMex5/bGs0fAeiULdn
	AUXqvSzMkBDWApnvzyFVuoBqQ0Qzhd2u2sTr0LmpWkz8ZYgBD8Wy/5xi1YMKmgGw
	HPNPwsMMckCQBST2BZEj064cvUXyQw/QE50CRPNYNHBWY74EcuWIUdsoEm8tYVJQ
	Wn5zuiLLCWfl/pA3Ziq5lFgIwNGCwpnoiG05jXsfHsQ197WFCtQ0O4hfvoikeaOV
	SEQJJ0YWVez25iZyzuk/KWONoi34AbmNAZ0xnyA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Ofmw5ZTdmyCVwiYJCMBkEfCJaycZf0DAAsJ6ap4HM/U=:yGeSomz0jiV0ypk7Cuqmy6ly6OnF7vGKffX+Redk3iA=;
X-ME-Sender: <xms:zHcHa6HBNGqMMLXmD860CgLUqEvJ81me5z6BRAavZgKg-c7uhrIa4A>
    <xme:zHcHa_BYSrT_XLZQQ9mcyxVF0vF40aI_2EMrvUphG8EUqP4Y2bup06GqNEbSHIdIy
    J1BarKE7WirwsUnK979V5MQBbk4lEuglxq4NRTFeFizIyRmkGioQMCp>
X-ME-Received: <xmr:zHcHa9_YkvVoKOv5l6RS19EnFQ84AO4AVccfXWSdI2K0gLHqw4aru02FQpL0oIBz>
X-ME-Proxy-Cause: dmFkZTE1HyX83ajJvYTajDdPkmswZGPofo9vhmQAgtKdxS8jiOam/U5ZShiTIMjhsuqlEB
    GVZeZIjFPWZGPP/1ow3kAHXLXxMfOlyw8DA8OdgJlw06IBBtPX8TubFTFRfEbBQgadP2oi
    KYctq0xf7KWGPzaw7XM4VJF4Ciy7ipSSlZPikQzizjWu34mzQFwb0BUOAleBHDIukSHYW5
    g76eEBX9ukwy9p7x6V21JyEtEd0NxpjIy1X7/6zq8glRWgbLjmoqVKhdubksyXqSXKJTk9
    xTQ3b8zkNtN7DrU7BMyFwgWJEJ9t6VrlGX8n54qylMHGkk+c5nre77gwA2GiW0kzSfHCkF
    6xavmR+Etsh3+rIP93bvXqXxOMeOwzb1r5R989P2dOgkrfu4NzQ91oUM2sFzwm6BYtcIXc
    /Ai3Yg5MZ+ZExcyn3KdfVv0A20qTREx5cpJTsreg1VbomAu6vRwIw1AyxAzxDpEpik8mRg
    GfajT56h11zsP/IFKSBpdMPOEhdKTWsxn/fQjcFh3BbCKoXWOujBIZpfJ+c5D9mWBu4Dos
    PZNq8S/KFfX/BtBxv/dP8k2CviMUA4wQ6EsoLtHWFi0r2ywzvKO4QDh5afYx3LttvJs+3f
    6hTjM2O8Q/R8iK4nCkp92Gaja7mog6Q9Y2ReAygMzub/oGfkwHzkI4q0pfMw
X-ME-Proxy: <xmx:zHcHa7Ag4LEvk5rWf7joelrz6B2Z4cBDwpacTLp2P0Yjr43bNzm_6Q>
    <xmx:zHcHayTagUJZLiwPHnn5aVbZzvt5Je3IprmR73ZgTFBxgfvfzFA1XQ>
    <xmx:zHcHaytYptuUunUnR5ScNGpomgSfLe7H0lk3YFltWGmOFseQTJ-anA>
    <xmx:zHcHa-2itphfLFLMlDDelpUN-ou8GqfDmOKn3mgoitzQpQXQBkWhjA>
    <xmx:zHcHa6hdbKkqUXvGYP0hxLUEB_GKm1GVWgORsmcMhntsVsiOdosgXTci>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 19:05:31 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 3/4] ksmbd: skip SIDs with no sub-authority in the access check
Date: Wed, 25 Nov 2026 18:04:59 -0600
Message-ID: <20261126000500.1375459-4-icb@fastmail.org>
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

smb_check_perm_dacl() finds the ACEs for the user who makes a request
with compare_sids(), which compares only the sub-authorities that both
SIDs have. A SID with no sub-authority has none to compare, so it
matches every SID of its authority. An ACE for S-1-5 matches every user
of the server's domain, Authenticated Users, and the NFS mode SID. An
ACE for S-1-1 matches Everyone, and an ACE for S-1-3 matches OWNER
RIGHTS.

ksmbd gives every user a SID with at least one sub-authority. Everyone,
Authenticated Users, OWNER RIGHTS, and the NFS mode SID have one too.
So an ACE whose SID has no sub-authority is for none of them. Skip such
an ACE in both loops over the DACL, as an object ACE is skipped.

This changes what the check decides for a stored SD that holds such an
ACE. The ACE no longer applies to any user. A request that was granted
because of the ACE can be denied. A MAXIMUM_ALLOWED open no longer gets
rights from an allow ACE with such a SID, and it no longer loses rights
to a deny ACE with one.

SET_INFO refuses an ACE with such a SID, so a client cannot set one
today.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Tested over SMB with two stored DACLs.
    
    - The DACL has one ACE, which allows read and write to S-1-5.
      Before, the owner and another user could each open the file for
      READ_CONTROL, WRITE_DAC, and DELETE. A MAXIMUM_ALLOWED open gave
      each of them READ_DATA and WRITE_DATA. Now the owner can open the
      file for READ_CONTROL and WRITE_DAC, and a MAXIMUM_ALLOWED open
      gives the owner those two rights. The other user is denied.
    - The DACL denies WRITE_DATA to S-1-5 and then allows everything to
      Everyone. Before, a MAXIMUM_ALLOWED open was granted everything
      but WRITE_DATA. Now it is granted WRITE_DATA too. An open that
      asks for WRITE_DATA itself is granted before and after.

 fs/smb/server/smbacl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index fabe01a54998..20e4117cd323 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1193,8 +1193,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     ace->type == ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE) &&
 		    !(ace->flags & INHERIT_ONLY_ACE))
 			obj_deny = true;
-		/* ksmbd evaluates no object ACE, so one matches no one */
-		if (ace->obj_len)
+		/* An object ACE or a SID with no sub-authority matches no one */
+		if (ace->obj_len || !ace->sid->num_subauth)
 			continue;
 
 		if (!compare_sids(&sid_owner_rights, ace->sid)) {
@@ -1277,7 +1277,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 	for (i = 0; i < sd->num_aces; i++) {
 		ace = &sd->aces[i];
-		if (ace->obj_len)
+		if (ace->obj_len || !ace->sid->num_subauth)
 			continue;
 		if (!compare_sids(&sid, ace->sid) ||
 		    !compare_sids(&sid_unix_NFS_mode, ace->sid)) {
-- 
2.47.3

