Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720477;
	b=of2G2kKchZJMpPx1xUuU/0xB6lq3RASsFVjNCZeLdcZY3ReeBU6BsVdhiv4P6yhv26Ax
	 7I1orPA2SVUUUxMGXHHBHdPWHG9Q3dQ7CfWvExKTYGSAiVnID7/MocdZBSNhFUNbpGv74
	 yf0cQ/gvvZeoPrhmNwxYMlxzp+Z7cLTUM9t9IYFn0OtBXjTF7HPd3K5slDWAGKOEYt1wN
	 L3e8ZLQh+/9vdDP3b7PQCsEsnUuUBFYQfpnAa1tINfNQwIFN61UMUPabAMOkTJguXQaz8
	 riKksyj1KlSMaWZeR/u6zg7i8ZtVcQWo9xfBRNdic5R48JcvzpSs47pdTiWTXRFOE2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720477;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Content-Type:Content-Transfer-Encoding:MIME-Version:From:To:
	 Cc:Subject:In-reply-to:References:Date:Message-id:Reply-To;
	bh=3cAVfwbFrCNgv2+EqKpRHgNC9c1tU6GEEeKaHSj02bk=;
	b=vCVX4BnPiXHj0NLwX8wIhiwhU5UlPtA157r1clg0KbP8QdzZF8RJznDtHONOc5dYrSn2
	 MayfLwo+8GgesiuJ71MAoC/w0HcW5yYjjuwR7CXW1yCNRNarqg6ksj/6rZofZqIW/SFp/
	 1W6cV6kBLRicxz5clMVLblvjIo5cKlBfYd1cF2CSbnwZre4U97qYRZZbVnaHN9kDM8i8+
	 hZzFFwCo3+5yGW+04HdEx3qahcyH6UuZ64shShaEThOZkkLuOGhIAmt5SWTI1sgcNj6z3
	 t4I1xcq073cT3owKPRzmP0mnTJUdkW6gR5SStRDX4anL9u5wqRcjwSH5w37X07IxT/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ownmail.net;
	spf=pass smtp.mailfrom=ownmail.net;
	dkim=pass header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=QpmGQ5bQ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=x5w1ifjP;
	arc=none smtp.remote-ip=202.12.124.146
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952B1606A319
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 01:54:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 952B1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=QpmGQ5bQ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=x5w1ifjP
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 112871D001B8
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 21:54:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 22 Oct 2026 21:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1792720475; x=1792806875; bh=3cAVfwbFrCNgv2+EqKpRHgNC9c1tU6GEEeK
	aHSj02bk=; b=QpmGQ5bQ/vFGcY0VBzyytV0t2d+LPSbUHKLzG85hBglwihSanA4
	F3v5ta1m982ZZe4nU4yQVdHfDVJWwAInl75Jmpj1zfkwjvAmh8VIaHzVkmqktKyG
	1qzq+fLC1uD6gyC4pplm1sm9J+QPF54hXjGidF6EybUNKdbWS07LMlkFQbuvUG13
	/jVtM3xOOEpuVwbl000cjyUhDdbxYPIEId7sKpWArx7bfPzUPXRARdDupzzAItAS
	+azNrOHUwAvtxNHcO/SOij/VGv6TkrCl0K5Bh081NJq8fWyuXXeOb5Skn7UpmaYl
	85azQKcfx2SebICxXdvXVoK8jVi27mE0dWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792720475; x=
	1792806875; bh=3cAVfwbFrCNgv2+EqKpRHgNC9c1tU6GEEeKaHSj02bk=; b=x
	5w1ifjPckwX6rKvqGid/Y7cCiumafYmu2kTKVlmWndhiFiTucwCDNjl1365yYi42
	V1km69YPYLiz6O+7dsyc47tYKndIAamXFkEmQHcpa3NsL5WzGHpVagQoR9m/ofxK
	CI/paASkAZy3P5sUptBQVK2BD+9odYRdRXuLi3inyMsbWpFS80SmYEDiaalqCqh1
	4LhcSlTGgH2U/gZ42rlz8qlItfEVq3KtSfDQfORinMLRsCBVk1uYj8QeW1z4ZAOB
	YuexRn7f1qLTrXMIP7sgbKQyh6HV3VsB5bJbK5MA+XQNuQc+sVwLURXlHOYIJe6S
	/8DlwXrUOet1WlnyOFeQw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792720475; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:GVPfxU2KwcqudVLGSYT3zirCsGpq+O0PNMtEEKNXMC/rECp
	c2o8c7LsjgKhhcGGdIVkaGMDGxroOFrCuUh6FvNk5na9kMhmGVnQDMqgPNSF3HfH
	6gCpt2b0v1HUtiewOSB7+JtKCsaS7NEVEZP+q2l0COn0CYQ6v1HHJT/0secIIwGu
	DDV/iN37ZvqwoiqndMIavH2cP1e75q0xkf/dW4tW71HY33VaTP63BNGvTLV16vqS
	uUFWa523cUOv2Jmd5f2BTpUV/p+LXxne0Nbo6GHxN9zOeQSfvqAYXnpGWZ5LZGAA
	32g71EuX8ouZMP2ChVMrtm4ZbIyzJgU0in/h3Nw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,reply-to,
	subject,to;
Message-Instance: m=1; h=sha256:0T7TgnvcBa5HjIfzaYDehm2MTArXF69IgxreKTEz3Go=:3kzvpiJ7RQhrlwH3lZ3Wft1zr+dxHyKsDs6G2XbelBw=;
X-ME-Sender: <xms:W77aahzE8_h1hFtzVaj42l1tpdz1NqxVDJhh6gEi08EMD51nvXfnRg>
    <xme:W77aakWpQESpJ_hvVqpX2DdfGnfln6uyQE3vEBhJrsFvgCyK-XKKIBSGwFr-txfyY
    k0j89z6DULF6N1H75xu5a_q-vj57DT19SZRQVXCTSjPFS4N>
X-ME-Received: <xmr:W77aal_oVWUzTOt1Z9CaqfdtNKhNfEzW4L3HklInr1gUCXotSpXIyNGVo2moS0JlJwdnTCBoidndssjImts0NmHVyr9seyk>
X-ME-Proxy-Cause: dmFkZTFVW0+ou5GQ+tyQ7PbmYU7dwTTOW6VjzYJaNLufwkMo9mpseLPBHNMl4drdZj5kj6
    JpHgXtotuosN1/JJDeTLVtlWX69alxRsy9PhU8qhpt7xFYDkNvJztS2+kB0QvVUhoH5FXA
    ckVpc+dSK6JmSbWQA6nnnujkvjV+T+M8KFlshJ7mNhPLG3wxz/xCuhRl8oHEwtg+yUU/mA
    ySJZ6h7+zkNRBW++vw72Oxzf4+Sm7WMqJPY1KMh8xSPZY4vLRt+YgOpsEZvnEtSCe2Fej0
    AR3Hv6mGB6M2jgCGkr4zQe2q+ST/ZhiyqhQMuWqpJMF0RMrTyPABbDIJYykf88OlD+GTpd
    9We682YOG/ax0nLOqBpheWrY6sGhyCcht7WPxUBGlsmTJaSPsFeroAplQP0Ve3zCm/kIP1
    7ln+xAPsjn8o7BHUrNDpFrJzJ/rllHWKD3b7XfVYaxN+bY96Mtx7v33S/mnuNiVxl85HdA
    xIJwRnOYtUZsn7bTJluwyid50+ckshzDm+N84pOKh4pb4j187RQsbisMihc3Hcxo+mao4o
    sRajx8Vpp0EOrT8vex5RQ1EetoQWiKEELUNgMNj9zaFzzG62LtAav7mJq6ZW9kNbkdLjI3
    4YcLWUXvCbN08pCxz9QYAy5/NEu5BhPzSLbZVo604YQ028YsdPORGWZq81kw
X-ME-Proxy: <xmx:W77aavvB78a1w6lYBhrQHZI9Ewo1FBH8SvAfLJJ-Uc_nPmeWj2HxVQ>
    <xmx:W77aat2CgS0G5XjuvYRAawgmTlVpdW_7N4roPVAlpJJ8KJ-Hkidzyw>
    <xmx:W77aasRW5cdLTmN6FFCO_xxm85tJOtPRAdTP_EZJD7bkP5CWA5iydA>
    <xmx:W77aapfLxKYJVO3BHRyvnC4LxrUQ1YDviZyxkIxqoCXwzvFvbqodQg>
    <xmx:W77aargL6F7wj5i0ebC2fv9gO7VYdXgewP5Lud4Pygnzm6hxbtvncHmP>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 21:54:32 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Paulo Alcantara" <pc@manguebit.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>
Cc: "Jeff Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] smb/client: prepare for locking changes.
In-reply-to: <20261023014211.2120871-1-neilb@ownmail.net>
References: <20261023014211.2120871-1-neilb@ownmail.net>
Date: Fri, 23 Oct 2026 12:54:30 +1100
Message-id: <179272047063.2068970.18335523787621027348@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>


[[Missed the Subject on the cover letter - sorry.  ]]

This v3 removes the DCACHE_BLOCKED #define and uses IS_ERR_OR_NULL() as reque=
sted.
Also adds the ack-ed by from Namjae Jeon - thanks!
NeilBrown

[PATCH v3 1/3] smb/client: don't unhash and rehash to prevent new
[PATCH v3 2/3] smb/client: use d_alloc_trylock in
[PATCH v3 3/3] smb/client: Use d_alloc_trylock() in
