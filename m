Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794453126;
	b=W97Wa6WdTTEKNRf1XYjcZA1snuk69nbJ4ReBtSVC4ne0QyG6M1Zeb9WgWEVOsWZFtWYv
	 3MVJoweVSe8UPr62reuPsaRtYRc1CQC9HzOeKJOSXHP+Wd3/KiBdw15neYdXJWWpqNwnL
	 1K5yoeg2ujtsojykAT6yN1523xgyqfylE/yCZweh1tuFhKnImUe7yZywC2LZ8fubUOqpt
	 Lk1Qp690cDByyesaQBu4tc/9A/mOn75vfqdVGngZJU3Dm1lFtuZk+rglvOOP7hXkh5nHe
	 +9kcyUhCaZsTVKHWsoYrbhP4HgNwVzd2Z1V7OV2jWeY98dG4aQZDxvBzb6EAcwu9prg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794453126;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=QDDu/iuRer8x+fbRlhcWj5yTnvup5TRrh8zmjrv7vjI=;
	b=fK3iZG2daYoBZCM+KtDvdNLFFbObZk4kVKGGl6PU5BtL3f66FJwORb4eXv28quN/mlQ0
	 H9WXHGZ544PGYONziLpBlMzemVCr81ltOXUUkOr6TwLMWWCTzwej+H02xn/9oXDGxgcC1
	 bgPF97GpOYldBgMMO6kP6BxgyxwjVGrv3auRcniiGTDQxE1ScJqZwjxVCGZnNk+zZ9hIe
	 xu2FBj/t1KYvVrIfAMxKV3spiII8cm83mlsftQLnp5NqGdp8n7Az8rixxQD5+ERDllxPS
	 XAMMsvVCjE0U5DhROQ4hvcCWfn40jHXkZ25DMytbSOwVScHgLL+MwJ1r+/aJCRpYgHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=XLbJBrJe;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=CDSCGE6A;
	arc=none smtp.remote-ip=103.168.172.151
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C10606A321
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 03:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36C10606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=XLbJBrJe;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=CDSCGE6A
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 3C5FDEC0143
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 22:12:04 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 11 Nov 2026 22:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794453124; x=
	1794539524; bh=QDDu/iuRer8x+fbRlhcWj5yTnvup5TRrh8zmjrv7vjI=; b=X
	LbJBrJeAaYoI4iIhmCSsZ94xwQ86+SfyI7cuSb1lOlr4easPcIYTrPIZup58u/D+
	OrTAtNM7kc1re3mOivxJj0XtoM8o8/Zbb5LZKiXkLmbMrfYcqffj1SWDobO0zvRP
	xrCLHJSscHtqV34tHNYAx9TgMCMpv3glHgaHSrFR1yyhGCBP5BYTHO/Qc4yyN8ke
	If57PQlW27seR5tGVg2zGTK9GwSTVW5xk2JuDKO1uQQLw6cDDvfhHCO2hv4yQoOK
	KO98w07HBJBP/gfg3JB+0M4D82z3YhM+MPEMna3ncjwzsWJf8U889yaVbd8xtibE
	jESeF9aG5BsNHL6n28Y6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794453124; x=1794539524; bh=Q
	DDu/iuRer8x+fbRlhcWj5yTnvup5TRrh8zmjrv7vjI=; b=CDSCGE6AEmVJBlM8m
	EMdX9UOVQdmaOxoZCnFnXwsDiKTg8Uk2JVxbe2Eg2zausoqa5yssd8qPl7RPVIV9
	dhym+hyFdF50kp3oa+P6og9dgFQLKhxWrhNSEE0ZeUC+qIf77C10MXjiZ9gPEr5f
	FV8l6CtOzcgyAg7dAM+z3XN6nP8Lum/IPyhN4eTmXOYU4q8NVA1f8aaPNdkE2r/H
	XSQaTFVe3D1MTyiMVCFF1OtYHw5rveMsm+720Aczg6lBm0bIzNcrpglBcWwhQelv
	JAHA0B8eOA7N3YxEiRB7qziK4xGyBU+MQ7xfmLCOZn/WbF1giz9NbLyLF3LCdciU
	3IK3A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794453124; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:aKkkXGFAfB8K1nt0KxilcgjYH6owihRJj3H82S3eOsuk4GS
	7Q7NUqmPnbAKdNjOFU0vNeAc2Dn9NA7FV7CuX8tZVG3Q63ySdA6F+9grhu2QK+Kq
	z4lU61O5z18i+h57NHaipBzephzAJbFn1LBgmQLQlucS2a/bl+P/9+ikV77XCT2u
	C3FxP9SCxnhyJ82QGYO03i3cTMgI9K1PZZVqsS1xB4K15hfmvth9c529qPzckBS8
	eBalFH5sB+m9NTNRR63lhqrKlre1JIRZXUYPyADzpAf3jyFzwvt5Kta1zDVEjNX8
	ueCCytxD9Kw03Ll0nmRe8h/BP3p7Cg+Ikj8PnJQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:OcyGo1CLhokevaPLgeG6cWgzDe3rrghxxJMxzUmoq9c=:QDDu/iuRer8x+fbRlhcWj5yTnvup5TRrh8zmjrv7vjI=;
X-ME-Sender: <xms:gy71amF2OZjQt-rAwrScN0soUpwXXDEcMHC5BRDfZ_TGwOZInyuzrg>
    <xme:gy71atUEQYnxL7-Edl6Qn98JXVU_J4z2BpjfIcOIWeaxygNzQFTGxG1ItR--AdZWW
    VYRPy6FgH73VpOfbTXiVAl3r5krdQIsrKwF8DZEO70hOB1itZYSB0Nw>
X-ME-Received: <xmr:gy71aq_VIpl6yLL6Spc4vRbyHoBjSnfxb50yHIoxBQ_zcdioV_xSk4cpOhNtUZ1c>
X-ME-Proxy-Cause: dmFkZTFNA1EioliXvsibs9nY0jsX4m0LHoiIOvGZ20LIJ5ZaqSDo+uQ6o48EJexOI05kgH
    WBO8y3ITgx4b9ZP6RtPmKx5JnC6O8gI8WNlKSfLzZWnyLJu+OPBp4wym6f15KGaCtuwt+h
    gKTyT4TdeUdnIyKUQkRqsJYz6/1t6n9ofCC1iRHUX58V+h7I3t+6L+TlDNSYSQj672xPPs
    rG+2MqyMfMYuPFf4ZPe068Y+X0+cbE6dNkKxTikNrrOn06sERyadkvaTDWYQjDSjJ5VSJj
    4kpc2eYP61Y7QLy18fZiAVb4gqlFV9tdQ8jhaHWLcGpk4BrAfc9XtHLbSof0Wa7gXeHRio
    5kwTsaVN563kx/cz7CodPHgOIHpgL1Bg7tAcfvnBsRdYGkpaMxBzM9fYnaZH8rSxxlzMql
    eIsKRRchuyp5aH2qn5H7OQYFsdaiEXWisoDUa7YOsbASAH1oXIU9fVcwDkSu4ZFVFtpRBE
    cxn/AMXR/sqY2Nrn1iYyubp9VtcUT6Mtj79af/tcUbM06ENcJQqaXH9o5TT1e8nMi5Doi1
    /DNLpVYBnMRGdmsr4BV8jd2akAqsaLTY1O0jSdsrhtzE9ntMhOU3r/FBCgCM+EdyajEcpx
    GBmF+kAqjjy2VBi6QlB5QaWNZmWch68Zw9PBDxwf1rhS6uDJjGC1yBRflESw
X-ME-Proxy: <xmx:gy71ai5GlgEbupl7qc9ihoIkCasE954kb6uYW9WtvydAa8a1SvlubA>
    <xmx:gy71arn368_6z9Rz_MYIWM8NlMaDs38lvt4X5PBso9P5LXk2B5MdQg>
    <xmx:gy71atE1DbeMELo8Rk_2dCEPc1X-S3kUJdMe8VapRAEAHqor3UVN5g>
    <xmx:gy71aq_z86BFWsbjJ1iLWA2qZE7rFTCHFjR9RtbvAvIL3j80KAl8Fw>
    <xmx:hC71atQcqm8poy6UJ9dOsFpd12H9UbyFJer5Xw-POGQQUDGt-09IR0OU>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 22:12:02 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: koray.fra@gmail.com
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH] ksmbd: fix timestamp corruption on special values
Date: Wed, 11 Nov 2026 21:11:57 -0600
Message-ID: <20261112031157.677256-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111222534.839117-1-koray.fra@gmail.com>
References: <20261111222534.839117-1-koray.fra@gmail.com>
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

Hi,

On Wed, Nov 11, 2026 at 11:25:34PM +0100, koraynilay wrote:
> When a timestamp is being sent with "-1" or "-2" as its value because it
> should be ignored, as specified in MS-FSCC 2.4.7 FileBasicInformation,
> ksmbd would clobber it in both the xattr and on-disk value by setting it
> to -1.

I tested this with the ksmbd code from ksmbd-for-next. Before the
patch, setting any of the four times to -1 or -2 stored that value.
The access and write times on disk moved to 1901, and the creation
time in the DOS attribute xattr was overwritten. With the patch, -1
and -2 leave every time unchanged, and valid times are still set as
before. smbtorture confirms the result in the commit message, the rest
of its results are unchanged, and KASAN reports nothing.

Reviewed-by: Ian Bridges <icb@fastmail.org>
Tested-by: Ian Bridges <icb@fastmail.org>
