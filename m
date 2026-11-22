Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795362973;
	b=OHAmSG8tJqQGzNuaRDH5an75XTxhnLxBGE7qLNYs5wKdVxEZ4nJMgY/q/MGWjLLE9qgG
	 IeS3jJmmU9CBPv/ALxTAI0oEDOSEZCRsIfxiOeeGw+xt1dVQv0dahACdASDOdG02kzLHV
	 Gsg+VoUBXfpgfvgLjtO8K1IAst6BKOUV/z2NY117gX3JpDDwCrSsG+McXN5U5kTPb7+ZM
	 5inJUMCp3ggaazqyur6blmLXuNxzjaRRbdSRdz39HTXlYnxlRKM1xzAXqqF3m7uZGWVJW
	 +jsOMccibdBNCFm7HBc44gmFi38xh7sDq5cpubQZhqRZwkWfZazYEAHRXojk/bUtM+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795362973;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aj5uA9WSzm4j8ar/oaYuz0vEVC+pQSuH005rTpdkqr8=;
	b=xZ8JJHeKh6kGFwWmRfwb8Q+r6R5OpcfXWBgNP19Js5mkbLGIWqBEkRVUHLj1AP0FRz4E
	 uS8H4oEmopqRjygI5SrC1UwMgK31n/kdklOQ1OWXKnL8L8SSinl5Lf+Jo4w+kbtRbnL8W
	 PY96+sWO2vjr/xS3045yLwjXwZYB+QvUtAm/QLaVd42RMR6dghfa7OYPu6KI4RXvigMIu
	 ySTm+ZdaUJsMVrAmcX67w2qoW/FJ71mfaK8B7eeTBdsKgmVWhGG4j2ffSKyUxSfKnlM42
	 /bVwdHwxIYDUu3fwa3LIQj8MeBrDj6GC3nPhwRT+Df+uv9Mw3MB8FK+5k+VkPzygAWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=orkns+7j;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=MrKBc1gv;
	arc=none smtp.remote-ip=202.12.124.149
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317F5606A320
	for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 15:56:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 317F5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=orkns+7j;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=MrKBc1gv
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 78BE31D004C9
	for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 10:56:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sun, 22 Nov 2026 10:56:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795362970; x=1795449370; bh=aj5uA9WSzm4j8ar/oaYuz
	0vEVC+pQSuH005rTpdkqr8=; b=orkns+7jrGoeOrNIEoghemPcFFCuVAQ6jJtyJ
	MJFq3KIW5foCcYRCgDVyt03qeSMby9+Td2ygo+lU7wzftV2wVO2l5+znFj3AGpZr
	E1CyNe8esUTN9Ia0fnCx0uMYRQ04+d9cevD1OqyqlKvmg/2C0EM3XlQWmTiMz34P
	05BihA2n3fKaX2jSFyijUGtra1cMbvdilvIGh/PZx20MFI8BYXJGlVR44BUVGDsv
	uyvdn6fSUUjXmJjigSxMbXmqcKl2mpGXQbTxkDQDwNznRtbBJ8qtSZW4pKMBGcXp
	urWb0FUuLEHrPiWI3grKlPUrgvOTARON8uQEO++82acEOo//A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795362970; x=1795449370; bh=aj5uA9WSzm4j8ar/oaYuz0vEVC+pQSuH005
	rTpdkqr8=; b=MrKBc1gvN8UEmRD7wEhbsOgSdzYDbq6wVvlO1rtGRjVPw+3Y2Kn
	81xKVIwqU3gpOEPxF57bQ63+tq/3l1xTCIhDiPB6k6wiPc+0crb+0fne3Z7xajRO
	TExhewfzSmBNjXEuLApjk4GEDALj9kpd/fKmCTzVn4dnhWBmYE3OB2TD/9D+RD+L
	K1gBL7I1G9Al1F81uaGx9szYwupkdAGnjaYvCdFfXd8+cqJ8CePr5HmHb6E5P8XS
	qnrWb+U0PXqvKfLh/F3zLFAdg3FBvQDHQbGgct7deupjThixIV4L7hPb/yhHAQxq
	YdCrBETX7rW7WgMaAYPrPAY/l2z+Mc1UqCQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795362970; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:lOzOrbrlnxiXuAjs8i6n49qdomGfUkS4OpZS0m384DeNY11
	ZG/NzFXttAmbR8jXihS3lz7R5iHwqTChSo0Z+kb/HyBx23RRUSufCfbVQQB6daN+
	lNnXY6+MgtCLC9I4+Y0cpqz4/H20NeXEWiO75utZoZBMj7m9qEEqC4bFqQw57cYA
	d3f+sAfy6Tu9Ftd59ASROEg585tf+HfCjNkp1fIW0UmeFyq/fOb8iqMavVLVDtqb
	eyCwaqhFZm9kx2qy6i2vaeiSVhSE6Pnq5QXPXyw+ZLNl0KCOtr+NNkyt0hoZlyXE
	WiL4lSgWcyqJYENSgSE5CRWYT8IeOcT4K0h7cWQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:Eg4nZxDRigF5N42CCAZFZpqkBaxJSKFPJJTdyTcL6h0=:VRexWZxJ8G3o6qLdVRnCKpd+joNecszQyUs2s5c8WtM=;
X-ME-Sender: <xms:mRADa3l_RqxNyqrEl0deT50GeBjav5bpoSG9GiauzjtZ0LWBM1on0A>
    <xme:mRADa236zgJuuGPKnvuBIEMiuBQxFzSXC-6Tg20a5H2QZ1MdJpoJsbrFX0t-GtLjZ
    450rsEVS4pRhuJT_1gbIHd1MGyXE6qWegoZp7ws04HzFTtudU9oiIi_>
X-ME-Received: <xmr:mRADa_3eXQxjyz9NeuIeZdEGw3eVs-zsZ6es-xtkqtCCCXegg7MZM2BWbk7lKihx>
X-ME-Proxy-Cause: dmFkZTEFo8o6T59g15GkbbqOo3uuSa6Rsptd+h+VTKd66H7DDtwC6YdpUHpSVEdYWpDZZ8
    sfxdtglR0WbV64a26KcI5fZdOej/LvnHvAWBXTfNjRjxZgel6q8dkHK3uXUGLo+I7ccZbJ
    ZGZ/YCc3pfq7T1gMEqwFzF5zv2EnuLXGCV7R6mw/v/3rxBqhoQWLgbHJ6oJ9/2sL3wlPc2
    OaRaV7w0pFcS9r9kwh2HwCHGjK/5Owj3cT9LJeDs0oaUHQbRu0731qR5Xiekaj2clrt0z/
    uv8fXtC813do3uMLGv9Zg19QrMdMZPWDGiHo7OHZdEta92Ive2MuUUx6X9uNZBKRONXPcD
    DG7Ip6hiizjOkcsyEABYmzU8n74ofYB26k3SCcQuO/ZuO5lbcDZcB2qCWmr/D36l+rsShl
    HX18hljKlcVFDZRIXGa3ijsxFKF7m9nP9OKO/D2ZwyldsF9bkrfw1tec/3FJHbNW0CkuWy
    5nqiDaT/whgo6cHjii6vxNWNHOKpC2imMuNl4RP1WKjV+JKKwgGBA071qrBGnvNoqSXIep
    8aquHJ0Eg6VEJpgKLEmmsPnK6OmysfpnfC3puc/CfEifJcRQ9Z7iyJcZ2aIx/YNoARqY19
    fHJ+ZuQxVROH47GurOiXbTr1svV7CpNebLtiKZPy6vV6CoKw5FimKXaFJpkg
X-ME-Proxy: <xmx:mRADawogP8SZY_Ufj47uZmcY4259z9X8iqjT9SW1OvHwv1rkTscURw>
    <xmx:mRADazh1_wE0K1SS_LuBJo1ogSU7fgNCwGMhDy1hH1GCblB-9LMISw>
    <xmx:mRADa0_uQQr7dfdDAwLRSzRk4j_nMUr9bI7ZR2wo4Ufvpk0g6wE22Q>
    <xmx:mRADa3WhgU6NKGoI8affKqpLM17llO6k62gTmJURvHbh8V3Q9rXfqA>
    <xmx:mhADazsJgCVazyuJFTFD0jfhckR7uBTgtcp4Ysqx8Wuq0Khp7oGmqGC8>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Nov 2026 10:56:09 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: reject a security descriptor with OffsetDacl but no DACL_PRESENT
Date: Sun, 22 Nov 2026 09:56:04 -0600
Message-ID: <20261122155604.401963-1-icb@fastmail.org>
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

parse_sec_desc() returns early when DACL_PRESENT is clear and checks
nothing else in the descriptor. set_info_sec() then removes the POSIX
ACLs and stores the descriptor as sent, OffsetDacl included. The
access check, inheritance and QUERY use the DACL at OffsetDacl without
looking at DACL_PRESENT. A SET_INFO without the flag can therefore
store a DACL that was never checked or mapped to the mode, and that
DACL is enforced.

A descriptor without DACL_PRESENT has no DACL, so its OffsetDacl must
be zero. Reject a nonzero OffsetDacl in that case with -EINVAL, as
parse_sec_desc() does for other malformed descriptors.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Tested on ksmbd-for-next 89d5e8fdd5a7 with KASAN. A SET_INFO with
DACL_PRESENT clear and a nonzero OffsetDacl now fails with
STATUS_INVALID_PARAMETER, and the file keeps its previous descriptor
and POSIX ACL. Before, the DACL was stored without checks, the POSIX
ACL was removed, and a deny ACE in the DACL was enforced. A CREATE
whose security descriptor context has this form now fails the same way
after the file is created, as a CREATE with another malformed context
does. Descriptors with DACL_PRESENT set, owner and group changes from
smbcacls and the Linux cifs client, and smbtorture give the same
results as the base.

This patch was developed with LLM assistance.

 fs/smb/server/smbacl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 7bb28ea195c8..446b4f69d7c4 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -963,6 +963,9 @@ int parse_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 	pntsd_type = le16_to_cpu(pntsd->type);
 	if (!(pntsd_type & DACL_PRESENT)) {
 		ksmbd_debug(SMB, "DACL_PRESENT in DACL type is not set\n");
+		/* Without DACL_PRESENT, OffsetDacl must be 0 (MS-DTYP 2.4.6) */
+		if (dacloffset)
+			return -EINVAL;
 		return rc;
 	}
 
-- 
2.47.3

