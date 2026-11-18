Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023606;
	b=XD+rfBNbKPrhyXLptIjc9ewdTSnqzfOOJUpB/+2xnoi52RRxX7S+WxEDsfEqLQ3CI6gT
	 1jaFeOsf/9DhX5QQfCHjPCNBSalUhF2ZqvIzNd15bPiFaZfYRC6ZHnBcvlAmlmSNhNBBc
	 ZUytu75LaziNUkqssoIc/YsMDUpFv+15S0z0MIucCdMR4OCTBSKFg2MGTNbaluW6mWLCA
	 J72dtdZDa9Zu2YgjQ5jLF3NYp6p3ZLYrS8StHYB4gE1E3bNXLgTD4hIyL/qSvLBywA0Ky
	 GvjbuNferDD+14EyyaBNgCGOdwPaooYR085OpIWcogqWlOrC7UKfwoOnY+Hwx0vfBkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023606;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WOX0nP5PfmFUf9Q723QgPHMMZtt0S26y3/EjkspDlFI=;
	b=iuALT9LTniu1OLPZ68lAoj/ma9k1emGJpNf+F5f7R1p8Gw3SBiwCLYDxro8x/cHPBSdV
	 qoXdcCyIk3aMcf9dT9TZJV9rVPwyqXqxzwWXDDio9JG+k2VnT0/ag+IYnEkgvHAx0tw+G
	 XWthEmokcdIQDHk2PD892uGOl85ebHbXEiUsZU64np32iS/jN5jJ3pZ+FN1F5Oh0w7HNF
	 6A056EzdJ8bdWp80qxcGWJbZM3mIQHQLWvXKGDBakIIpAWZEtsti9RWk8LScVOGYEVKuT
	 OUuP5mdyTX0duK78cckroRf4zWieUgsH+/2UcJGcVLlfzdcLplAjhQ7ZSc6Z3HNBQvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=uMPh98SR;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=ZmJAlvsi;
	arc=none smtp.remote-ip=103.168.172.144
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE7606A32F
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 17:40:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDBE7606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=uMPh98SR;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=ZmJAlvsi
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id EF862EC084C
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 12:40:04 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 18 Nov 2026 12:40:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795023604; x=1795110004; bh=WOX0nP5PfmFUf9Q723QgP
	HMMZtt0S26y3/EjkspDlFI=; b=uMPh98SRFjJTRQkpb9KX4o+cYIxrZE0xih9RO
	Yjkk0cK40nkAjxALH/87xeuNBJ+wF8ftLdvniLfCY+5Bl8UnetuSPzKfWUpNz4i1
	TffBC5C3u+GcAVR7iJO3i2Ff9vjM+Ypte7AuOdjqFPO8akjW007dP0tEp8lG1jek
	Ozn3txuKe3hMAfT6ykcjZYJ5Whv578O5BUNorCkLn2b9MjwNa/kDUoTO4duAv8jB
	xrJCTxEPgDcuxVrzLhG/6bxPmmVwO16ByyTcqMuVTMAl4LgRY1KQZXHzopQIsMKi
	uXfUCFFOQXJew0vFCZMkg3+PlXZ/iHJjljmiyYcxp2HYYFC5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795023604; x=1795110004; bh=WOX0nP5PfmFUf9Q723QgPHMMZtt0S26y3/E
	jkspDlFI=; b=ZmJAlvsiDT/hHDFRJJGhHTOwDLUqcW/vso0j92j3RPbXyfH8POc
	F0NoayI8TWQGTZlAbKYBgaxXIDFynryP0io4+XnJ3+3z0u6laNiKW7a/T6udz9+t
	yQxQA1GU0sFJI/5ofMp1Ilkwbhqx1oeqysj+Cp2PYJpv+++gi/D5S03kDcDrMGiX
	QrZimDfvRfNtvqAJgpp3cLl+X1bqIKxouCq8QtLRIWvdJ3RsxS99eOUExZ7GsWBl
	DI8pukATgDizDtoOPWvdlHDtvLoI1XfgLjjJ8f2s4ytCE1R3laZiAbMOVH32XMGB
	9mdd/Vbk+iGIVBkBNg3l35yn8/J0aP/sQvA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795023604; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:PmzaXmjU5x3I6oDDT5b+1SS6/XcVuV2VLJY3k5S4ibyOaK7
	slmOBbpzr1JY2IEf5Cl27nWb/qLvCcpT1Inz4C1hmRHqQ3rM4iWWwVwDx1KQTNjr
	sjbyLstQqWmGqCGX/R4AY+PdKEr6ngWgBCTGTtCedcive+jhkhOaHL+Skj5q7PZN
	yf7GIabWrcqhR2py1nYv/WP5+8daXURILq0SsDbpHSl0TIVvaLMv526+k17j3EyG
	eKK9YMqPcDjUUvGEyuC+J+pmDDyVW+pl9a5w1S0FmWxk5fHuW22optOGmbeEAP3d
	JsLRDdq5IwKj2fo3KctaazHvXSDzutpXS/hT+6w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:ikqs4bWmQ0O5p9jUTxjsal+djJrIFHF8sLkQv7cZmMg=:2hUnR9ZvXd+MRNEYunAX71//rBW00NLAmOP7S88GEJw=;
X-ME-Sender: <xms:9OL9ahhmvb0rokcBydyyzpw9ahWPsedKacMpIHAjFH5wSkXnp9vqwQ>
    <xme:9OL9aiAGNsKExxhZZCdHd5U9MHGwJ8rGDc23vuYOPq86iD6lmylO6t6fUDoR2rCw8
    pG-simB5qTLa0drphOMX5EhYUROLzt7WsalE_i_ehOheRokwyN7SHGvTA>
X-ME-Received: <xmr:9OL9ajSsxCI72_1dQsw6gawpkFTjYQNBBEYENEtSYpQNKWskgJHwATCwEp5YHf6b>
X-ME-Proxy-Cause: dmFkZTGeGXXOSWoH9YX7eY7zbjJR7vgoMjSUawdmwaHh923uKJ0B+BNjVdJifHN61FAC0P
    3GVzypdXA4c9TLSaWZIfjqE4ti6KG5yLL2967424AB8dJDAgBwXA6vSsU7YwWklBecErYN
    yp1BZNWGELaUaxZppgFY2Va7CF2Ozl6EL3GpQ6n2HV+N8AdBuLviC5mGF4ME5N3MYj6d5a
    XzDKLSoMQ1nAvdvYWWDQmPdyfSNK5C8bb33j7CiIsq8rOPfcpppY44MQ4pp3hnmV0p/noC
    nr3xVcgO0YlnbcxJriBv0eFprPx18ltJYm3AJ1a6U6E6R9oUPSCMDF5aaYmxpFadRoWIA+
    e77qrBqqwvz+1gCReHpnOkuOpIro5bWPKrVcrXiHgdmwTYZjTnih/DTTNs95Ju4boLguXE
    bYdk1UPMPLmHYVHcitbuHN1HoduoDf7E7kwXXKgjtLhz6X+C42UvoM3GCTV6UT5hq7uIbH
    MlMSIoXKdq1/LMG0o3R49EiMCxa8qXzCMozjdwF8tp67xL26AlZmnndFmHbU/1cFDx/GR/
    4XuVq/IsBeMGjCGnBkWzDFX+GkQ4oSwWXhKjNgz82KgUdSWlIx9cdj9+RGg1//Evc4RXtB
    wgpOZ/X5lykevLxbyKLJCkSiXJxvJ6WYgQrcuCubKy2UBr7sJzjWmELnGCrg
X-ME-Proxy: <xmx:9OL9anXqF4ug4dOTYdXYrrXX2pJHntwWCtFmHVP3_leuV1M0c32mwA>
    <xmx:9OL9asfGzdb4TNAupirTSCjYFi3SPC-X6UhLmXaQwQF8d5F7vmqW6A>
    <xmx:9OL9ajIiNTVh6VvTy7vjWDcBeEjKem0sCVjRlKYxdO6h1aSCKZ1Gdw>
    <xmx:9OL9ahyr8MfvGWJg-ZjJkkn-jsgN-OV3-oux-hW4ut9GdY-F0Dlzbw>
    <xmx:9OL9arRgjt6TiG4fSJkvQvgROZpit9Eam1A8WnvX1xKF5fv8va1uK-Er>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Nov 2026 12:40:03 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: clear DACL_PRESENT when the query omits the DACL
Date: Wed, 18 Nov 2026 11:40:00 -0600
Message-ID: <20261118174000.76954-1-icb@fastmail.org>
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

build_sec_desc() starts the Control of a security query reply from
SELF_RELATIVE and ORs in the Control of the stored descriptor. A stored
descriptor with a DACL has DACL_PRESENT. When the client asks only for
the owner or the group, the reply then has DACL_PRESENT set and no
DACL. A client reads DACL_PRESENT with a zero DACL offset as a NULL
DACL, not as a DACL that was left out of the reply. The server's own
access checks are not affected.

Do not take DACL_PRESENT from the stored descriptor. build_sec_desc()
already sets it when the DACL is requested.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Tested on ksmbd-for-next 267029b35ad1 with KASAN. On a file with a
stored descriptor, a query for the owner, the group or both now returns
Control 0x8000 instead of 0x8004. Replies for the other tested
AdditionalInformation values are unchanged. smbtorture results match
the base.

This patch was developed with LLM assistance.

 fs/smb/server/smbacl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index a87c22fa9a6e..5bd0c7eab515 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1077,8 +1077,9 @@ int build_sec_desc(const struct mnt_idmap *idmap,
 	pntsd->sacloffset = 0;
 	pntsd->revision = cpu_to_le16(1);
 	pntsd->type = cpu_to_le16(SELF_RELATIVE);
+	/* DACL_PRESENT is set below when the DACL is requested */
 	if (ppntsd)
-		pntsd->type |= ppntsd->type;
+		pntsd->type |= ppntsd->type & ~cpu_to_le16(DACL_PRESENT);
 
 	if (addition_info & OWNER_SECINFO) {
 		pntsd->osidoffset = cpu_to_le32(offset);
-- 
2.47.3

