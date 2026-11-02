Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793596492;
	b=fc9Zs5MKkIo1dPTSD74E4ymmoAdKg5zweCL/qa+b9FQT+v6ylYUmYmG/0ctf942lAp6I
	 Vs0lWBCOeBvfWEcWrYG/fnpJ3/VbItvZymsetfEUIWMEChYyKtcKWX7hZ+gNkZeCflHdK
	 Dw1VMK3lI/PvdrWAPwyTBqNUsgpE6RPF2CApo+LlApTwh6+3M14ufy6qzeFddWEccNc4l
	 ZRa8/+mA7vYTsBKDokrZvFm988spLzgosgw8um5QiQUHfhnjkvhvl+GQXtyrc+ZhD+tg9
	 0erbzdy2yoVzL0uMV85nVj3SBQ++yBqCz6CtqMZOO7qg32PShYBmLgMc9UBtLUD6ofg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793596492;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jMtjIgA43+c/lzOmY12E6boojWAvU84MMBpXv340+1w=;
	b=1WA4ZM1lJd4G0ayltE//1tiJK5J7ne6yLy+L7tCaPrEEJ0/ZzzII53fBI616mD/+6woN
	 43VJng5xQ/wg1f6aOmmX4b9fIAoez0Y+g4u+jDLMCBZlRgzVkLwv1WmtKRQ08Fd1YeUKC
	 xfPCt7A7yx7n9zALPU36SM5IVIieHBBv3EoFDwMuwMUTWmUxtCp2ow8CEwFSGS+avfGw1
	 xWsPE1Lqd5NS/iUqG0w3tn3h8wX+ToVw4fFV9YZWfqFmNmdUV1aIEVbN3DaMsjBbg1ppE
	 z8xNGpRY6l5rnauj2TpSXCeNhBypgghFl5+v+QsFv/Lb2QJlAgWtEdJlu3DLnZ2a1aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=jSazJCSb;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=sscGai+f;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAD6606A326
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 05:14:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDAD6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=jSazJCSb;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=sscGai+f
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 2AFEC1D00124
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 00:14:51 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 02 Nov 2026 00:14:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793596490; x=1793682890; bh=jMtjIgA43+c/lzOmY12E6
	boojWAvU84MMBpXv340+1w=; b=jSazJCSb1x+XATOUV4bxOI+g4tDldXs4RaMJ7
	drEGID+3jBXVPvn5Ivl3TMHSL366rOBBeIeOtg8BUyyJaScgirmdnBe/ihZ33xko
	n3MCVEDfN6xk952ZHFskTVxwa1cmmIprEgPj4uQN8zYNL8/s93CalYFDLZvrgMGu
	8XD9n67pzalmGsrr0c5+gGeGLDXL4s7V556oH6g5L0xOWKZ4225bcmhuZxmDKd7L
	G1LzGDQhEyqb5jSkvJawdp2poSGNQMS69eHZnGjto4CRiEzIMpR2aLnvSecARyWF
	s+hwdsjwoHZzLuAZcoXsX3BMuHE73wMkDMpit1TM0lTXqe9PA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793596490; x=1793682890; bh=jMtjIgA43+c/lzOmY12E6boojWAvU84MMBp
	Xv340+1w=; b=sscGai+fDjWTkh+E5NcAH5PiwKR9u3CXBs2rVjZMLN+epgWmH4n
	us5af4EUBpA8mLye0uELNZW2mRLVhPLe0JiYkVCT2lHWeYIJeUTfMvH024OyYNpD
	jxiFRNRTGAbnpHi2ynwYoAYYxDZWKRLSHEq8bp1diZBu3SRCwskOLfQPgVN4f0N0
	XQP9puyaXJ8ochDPcZig+8UetIwOFgn52pFX4uKAXYfk9E09uR7OPIBBM3VrM9Oh
	lAcUx9oV9inGnisYdwTxbASp/61gHkGKYfVanu+RzWIF2qunVUZNTqFk8NlJY4cW
	m1j8htlWRWNbvwB0CrbzlD9O/PnbOWjeh5A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793596490; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:O176CkzTxV+V/5Bv46FooCdYufheEIEJHKlL+L1N26ErXlx
	6ZTK1Osn7bUk49SaXubIZy+grmV4KC+Bf1IuoMlB0gubWQMJSFQm1+NF7rWCweBd
	DO+YtaXXOUSh3L+NOsvEro9Eth3As/+4+E/3+sXAJR67NoSIF4UAEeRbinQsL01W
	YOfSt0z+mo9wb+jK14ituD0FVGsA9ty0JE394BfxEBzfDw8i7AO+yCTCHkZPVPW7
	poKOIWNW0XHNKHg62Z+iFkyIqSJ4JkCVItPc20O6t5iwGDFT0Q2NddBTVLgBoprU
	rZk9vFaXzJ2hzPhfIIjCitA0oO0iuVVGxtXVVxA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:00w2r3bAhZe5Mnq8RfvDPanzXzlVZnIneg2QSCotbdQ=:nYDK/w6ZIE7On70icd4mEx/hnoUF9KJRBBihAIEPdos=;
X-ME-Sender: <xms:ShzoahHhjp7qEyIJAnnPAQmpnNQ-7iyNHKUhMVFms0XmjYIF0yHDKw>
    <xme:ShzoaiUYb_uFIT1ICFKqvm9qvPw5yrpKCL7nG9oBICBlFLNk3xma1TvDxiIbddAHK
    dYWV3b-LKsqbEx9MJZ4MS1uUx74HN1DROsVfJ5Inx7Bt8azl3Bj2VMK>
X-ME-Received: <xmr:ShzoalXW3biAU7q1xDH8JWrKw9FinQQIJWQdr3JFPJUrDALadwak1U_baWPK9DgY>
X-ME-Proxy-Cause: dmFkZTF7LU1oUKbshqWTEClbsUf7zYe5dwP6RhfDFn/QDn+SGv9JujCGoZBiRPCW5Zy8uM
    xBwo65hFt35V1L7ISt3DAImlh6poIQ8FPym7u5AmmPp2jiD6gDAt9D9U8V5YggvyFk4VKG
    CNqNmbtd7buavIpnfuGMEfEC7D9jRrDg5szR+n3W+kUnlNK0y6XHELnAMKwfNkBW3cMJZU
    j8r9v2JNyfGnla+sSeCGQjE3pVls51LufjIMFsk4VVsNAfT6zpaPNDlR0XwAs8AeZfipr9
    PxiGUsatxAs4YiEqzxjtnld2UXGyW2fWX6VihwnVNimc3z/yfNAdiRHc851Tv6j5ypANbU
    QEFACfWplQIm3wWppfyZRzzrtXygVcDyrPm9DxP+w3jcGcehZnglTCzzT5wvXApSTnVW8H
    xQhRBUnJVAjcnK6rBwh12PjHFL2aerczyYvDy6KReGTFAteHBee/Zs34znQqGXHI1qUQes
    Ms+XUM5Hl0ac3jqe0hAaLJ1jOnyDpW0Ecxd9pjhoElZ/9/V0lT+p9ct4Gj9Dl0jxPD9OMo
    /QJh7cw05+TFqK4QSt6jDHExEVyBRjg7SCaKXvFLADJS60KYq23qg4KaoGTjUvvYbpdNu4
    mDV5Cw+zgvce/G94HXF0B/y6vCFOv4S6gDOlthv3rQ3LynLQbJ4Er6YOh7vA
X-ME-Proxy: <xmx:ShzoaoKAFITaR4ADRwU0QoPWX2vl_ooLj5vPeN9lxdBg0mlE5y-d4Q>
    <xmx:ShzoalBYJWN9WD59jlm0N1Y0peDYziZ-YxLrjcoJa8PxXBoYqXb4Bw>
    <xmx:Shzoaocvi5vsMJbfcgqVq9oQingT4EsebFDJeM3rIGufCJY6IAQbXQ>
    <xmx:Shzoak226qrVlQXm5BZZXcE4yTVohZnS0bjMGnc9GIIyxcT45aWIpQ>
    <xmx:ShzoasGgSsl4JqgB9MwIeYfa6VnL5Vgm7OdAcV8ue65esyA9V6xgrPKr>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 00:14:49 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH] ksmbd: grant a POSIX ACL group entry only to the group's members
Date: Sun,  1 Nov 2026 23:14:28 -0600
Message-ID: <20261102051428.817037-1-icb@fastmail.org>
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

When no ACE of the DACL matches the caller, Everyone or Authenticated
Users, smb_check_perm_dacl() falls back to the file's POSIX ACL. It
takes the first ACL_USER or ACL_GROUP entry whose id equals the
caller's uid. For ACL_GROUP, this compares a gid with the caller's uid.
A numerical match grants the group's permissions even when the caller
is not a member.

Match a group entry only when the caller is also in the group.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Namjae Jeon <linkinjeon@kernel.org>
Closes: https://lore.kernel.org/linux-cifs/CAKYAXd93czbFD=znZUq_pJLXzDR5N3zc_auvAGWT7pzKR1f9Ag@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Reachable on a share with "vfs objects = acl_xattr" when the fallback
    runs and the POSIX ACL has a group entry whose gid equals the caller's
    uid. Such entries come from setfacl or from ksmbd's own mapping of a
    DACL to POSIX. A guest account reaches it the same way on a share with
    "guest ok = yes".
    
    The fallback retains its existing id match and adds a group membership
    check.
    
    Tested on ksmbd-for-next d13da43938d1 with KASAN. Generated DACLs of one
    or two allow or deny ACEs were probed on files and directories as the
    owner, other users, group members, a guest and an anonymous session. In
    the tested cases, only the results of the guest account with the uid/gid
    collision change. It no longer gets the rights of the file's group,
    which it is not in. Its MAXIMUM_ALLOWED opens were granted with no
    access and are now refused, matching the maximal access reply.
    smbtorture gives the same results as on the base.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smbacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 664f01263611..d9ceeb84d8da 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1625,7 +1625,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 				else
 					continue;
 
-				if (id == uid) {
+				/* A group entry grants only to the group's members */
+				if (id == uid &&
+				    (pa_entry->e_tag == ACL_USER ||
+				     in_group_p(make_kgid(&init_user_ns, id)))) {
 					mode_to_access_flags(pa_entry->e_perm,
 							     0777,
 							     &access_bits);

base-commit: d13da43938d15b0b719827d8f2b32df8eaec5def
-- 
2.47.3

