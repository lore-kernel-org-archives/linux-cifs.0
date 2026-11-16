Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794795242;
	b=2IH7uAyh2Ej/7lcumlD+tagVCpZX1tSmpcUbLZC1QRzY4wPGvrf1myRU0kbgU2vIM5ry
	 ZDPFzJmrWs0XXf+AHjQGqDVHKZHTOxXfgcBz2q8+Sglw3A9q697/TLNxt6gjCGrMukCYE
	 aBNcCawUxOCC1fKmWzVF/EhIeniMhHuMGIdZLr/FdjaglxHJe2lTz3H6O5kQOUWccrJVa
	 cvUl9PbcGBJrIhCxfyaU7AK++91RG4JVk4BiGQqAG2a2pbfDseKk3DAoHkxJ9P7LjOTLf
	 dQ0FcyM5EwOslPee1r0ZwAPmFTM/dhvFmnIUYpmq8Jgq6fREVNtaEaH5gHhrOMvKT1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794795242;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=ugaUD7Exh/dOiKWEmehd/cblaOSUygEQnFqj0j36kzI=;
	b=V6BV7XTSD4qWPXQ+wvFPIwbagw5wsZpWkKV90oY/LXqorsCvQhNd7e6pQuRlhG3HAbrn
	 hPFd197AperNAme3FsNRTCEdax93A/fipwTFXLxuanzkdD6lpX7oXuPwjfAc8fNKQT2qd
	 33H2tbHS6VPYQvns3QzmCh7WxodTjn9PYsPzyNGTKGh+KTv40ixNwxyppiUbApB1GRGjU
	 9b16ltyP7Bjrgi+72P0UlqP90j8uGPTUAWW6sOaQI+u1Ft1y4A7PDBpTF69nXjI9TdyVj
	 ec8btRlMUzuF5FPmy65HXP5KsS3UtDBKrB31LYF3lwH/NYJtqZWsm+QuPdjgRN9WXpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=sE8pUHqW;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=BZGes3vz;
	arc=none smtp.remote-ip=202.12.124.137
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568F3606A321
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 02:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 568F3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=sE8pUHqW;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=BZGes3vz
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id A52711302C72
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 21:14:00 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sun, 15 Nov 2026 21:14:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794795239; x=
	1794802439; bh=ugaUD7Exh/dOiKWEmehd/cblaOSUygEQnFqj0j36kzI=; b=s
	E8pUHqWl1m8mrq6LGKaDGpr//EwfkzcHxNv96nMbi/eJqLKBKWcmp/lyn+xCHzyX
	DjgVZng5cIcIv7Qfa0UG+z1evZ2pFe0pbGAX5nOR/cVnV8L3xX6hXm/UgfH7RB/f
	d5DbKxR9ZNgzV6pYcEYeRSrlcRmeDT0WWATxew5ltc04+5bqDzFTyY0+GIXhCl+Q
	PyPB+6sPGK6c7k28WUKkQQqxE/s5dPrQcEnRzHrVVW0mI492mKX/mj2kAIRXgows
	efjr/G9HYaVt0GRdmwL7TnvyxUPRjboD/8rJLNHKAO0sCqbDgSvIt1WREddy0Nl5
	3JuW3UedVm/qezKeX365g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794795239; x=1794802439; bh=u
	gaUD7Exh/dOiKWEmehd/cblaOSUygEQnFqj0j36kzI=; b=BZGes3vz5UcWMD4bQ
	7SmaGE9gGty/asUHAbxNRiAjXe/1zKkyB/8Z8G8iNkA3gIZPpS7BHFzieHop4fXK
	soLsl0UPGSKVgdQPrznnRZv2rxjqV7WyY/bU0oiuOKp9J/wbvaRjW+HmPSJSUsoc
	zefIoU1e0CLyHKp9eKXSo9Srx4dNWJMJ5NuHZYRGvWQVcywVMk4ffOwnKjjbqNdC
	yPWgi1pmb8GVE3M9WCIijHF79nFMUc9hJxPuTUKgxRelfIRJt4pcM+su2TmeyJW5
	GbEi8IGIZ/DsIL73jmnD1T14YWGHs1V/6EGb+9rKmr77RuUES81qoyKv0decfQ2P
	9WByw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794795239; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:np1Hq08mEIkjqezf7/SC+n8PEf6KivjI+2LIoSElgliBecU
	2FgED2nqdMQIOTGDn0rwCoKk1+KzkyhhFK02m4sp/ETkKDgDO3Pp5REriiXSvSBD
	XWaByjSGK/sWbFn1qYI3Lgc1Bd5IS74mQSN0OVP7g9cz8ZvzY3CRkezUsIN4x0oc
	KDJ2fiflI8mzqhBxDMTHhuw0dXcMaKNyRrhh+nUhWTXQkqH0mGrvTKvRpwLTjNBb
	gIothkriKjcQRKUw9CB9TQyEfQh82mGOK8816p4uCt55SOdhVqgKU9ERpnDmGpHH
	9eBBMdt8Gt/2xY6OKqU4LmUZBEbVFlkZBHpWgew==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:a0SUuwxdXjfHi9veqSVPqwMMof9IFkme6BOSKv1wGq4=:ugaUD7Exh/dOiKWEmehd/cblaOSUygEQnFqj0j36kzI=;
X-ME-Sender: <xms:5mb6ao6SX6CxSKaKTOKXXI3btITn9Y0sLRnu5aTj6hJcAPHvDK8d8A>
    <xme:5mb6au2v0XI78fi0hpbTAwbN9nxcJiBEMUybUOam-eXZyD5hceIyf_Li730_N90l5
    c5ydbB4fPOBAshPhKYt7QK3ppmZLtmpRB7D1jV2V6lb_Qj0Plu49oTa>
X-ME-Received: <xmr:5mb6arsFU31bWWmgtY_EzyWNWh6dYWGqBR_r_OGld-6Mtr03AszqahEhc_73X5y8>
X-ME-Proxy-Cause: dmFkZTGFIhyhDLa8hCqx+pHyX8RXm1/F8IxDFWP8po2umGjNomO14L385ifnOaol0e1Q5S
    mozlZXmxCzAlnLWsWrciqC6HsT5r/gK8BNB9f9TVyiBE7J9LY1DnAVrwQx2I38fNqJl3sB
    RszqqvNLy5iEFfWM2ZaJt4+ymipA1yv7b4IC0rIe5AT/vDy6OaPXXuZksIR1iB1AkBSIxm
    VAeH3j5Z1CSzyCYYnL6dC47Odz3LiGX0GVTlZTL/K9Q13klpH3uZA+NemLKVnbCa9OneN1
    SLWhBX7j4vD66cdqEqh91UULtg0ueJ31/Quw5mTnuG2s9j+ffvQX8JabMhbsmSAtzLuYXu
    6P5qYNEz5cYSQ0Cy0sxLxI4fnRnc50MCnyhLyoPqQ4NgFTv9cQykdYWuuD9ZZkpYdgVvMY
    YP1UIorhMlfjvKrC4gQtgc5JBwrxJ3m+ZUdjOZfiavUxdYYQuFPBIhUY0XXUR53L3RJw8X
    s+2zghNronIEMpwT/7EWoj/0FAqMXoQbgw3vB77e2KgBRowUoqJcVnbq4l1Lr6oAgJcS97
    ALmWSnnM/V18sQsk+qYvpA7H/B/b5IeIda3LjEquH9IqbCu28uF8d137xX9nDLWFQv4e94
    8P/THNLu1OpzR83z47tupFqUboSdePPxcV7q+GmRY2qejXMbuA9qOPTrFd4A
X-ME-Proxy: <xmx:5mb6as4ohXdKOHORDuMzjnTSWoe3SgxZJZOyjFmwNGarQAKdUlMTBQ>
    <xmx:5mb6avdvSpEfENdaHoQ_iQIGegNN-MrbecIIqRNacbDIFdxIzrEcFQ>
    <xmx:5mb6ahx9yZ7dvoJbBmirUStwf115uolXwmHRFmml6jzsATlgvgUdrQ>
    <xmx:5mb6as-lp7OtHaFDCN-NTal-DAHtywfcUB3FvkcexkinRCqLzRBCCw>
    <xmx:52b6atKjVJdktuvSULswZb9v2_QkWkhrqMjGfKW4LjTenKCjdz9tIMC8>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 15 Nov 2026 21:13:57 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: koray.fra@gmail.com
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH v3 1/2] ksmbd: decode and honor DOS attribute validity flags
Date: Sun, 15 Nov 2026 20:13:51 -0600
Message-ID: <20261116021351.2485365-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115155308.415734-1-koray.fra@gmail.com>
References: <20261115155308.415734-1-koray.fra@gmail.com>
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

On Sun, Nov 15, 2026 at 04:53:07PM +0100, koraynilay wrote:
> Currently, when setting file attributes via FSCTL_SET_SPARSE,
> FSCTL_SET_COMPRESSION, or FileBasicInformation, ksmbd hardcodes
> flags = 0x51 (XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
> XATTR_DOSINFO_ITIME). This injects unrequested creation time and itime
> into user.DOSATTRIB on disk, even though the client only requested an
> attribute modification.

I tested both patches with the server code of ksmbd-for-next
(3bc1fb9c3b20). Files whose xattr older ksmbd left without the creation
time flag now report their stored creation time and attributes, and a
rewrite sets the flag again. A file created over SMB keeps its flags and
itime when it is made sparse or compressed. A creation time set through
a second handle survives a later sparse request through the first.
smbtorture gives the same results as without the series, and KASAN
reports nothing.

Reviewed-by: Ian Bridges <icb@fastmail.org>
Tested-by: Ian Bridges <icb@fastmail.org>
