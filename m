Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794795299;
	b=dt0T+i74/jqtjBKkUaGHtPBT7Rp5gwxZznX8wuP37Yb2SkIAmgfAZIYKpCbFa4v85oNg
	 urjPklNYW7NP5zLWmltK7K5joU4gGBNwXxRX7wI2VgQyLjxC1nD+E+QltNuzHSCQDuEEL
	 ewWD0r7H1+U4KUgmQZTUcXJqdR6IgWUKwN48zilT2FF41smeSWyMVzTlH9u0W5QfwFCuw
	 IjrEmK73wCq7djhlbcydxTQHJT9STF20gxzPjFI2P0E7uG+ozZvEvVHKMURQm6umxNsZr
	 FJzVa5kfSPOrl7XXuO4ZK6myOwoDjmACXJnmkbQRixfgtNfchYR8CQCtdXd+JifWy6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794795299;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=rfaxPZTK/QbMCHFi6RkGMIRhTOgUbQXDaCoH945uFQs=;
	b=ldAas8mN9fYvcc2Bva+a9v0BRAC+g8jCyCiHkIRZlxMCmKsOVOGh/OGHr2iM4LB5/bNh
	 0Zczz+AJzMp0rYXbeSDXnrH/S4XWncxDVFAG6ju14lF404qt23akT8ubaPiT0Wlk4R+hU
	 Jk5kYvL8xB0o2wbjnH5I17oR3+B+DVvbdVxddJ7LCQHzl0rK64q88Kbo6GXBX285jMff4
	 NQX4/8GKTkuzOwPpMJEUDHRbSKAUki/VRwVNpV59CZDtd/anGsEbQwJ1mQnwsfWJVqbn8
	 ydNh7kPk4o3Itmx6Gd52Gj+u7nP3PXDVGDTFyYACFx8Iz5pcr9/k/Xd6DtaXfJkMqxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=sIuQyFl6;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=isOCFcL6;
	arc=none smtp.remote-ip=202.12.124.137
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF87606A31C
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 02:14:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BF87606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=sIuQyFl6;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=isOCFcL6
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 997B61302A42
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 21:14:58 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sun, 15 Nov 2026 21:14:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794795297; x=
	1794802497; bh=rfaxPZTK/QbMCHFi6RkGMIRhTOgUbQXDaCoH945uFQs=; b=s
	IuQyFl6U9Dv3kVGlpPMrkBwnIRvnpCy38BWAvNklUcFa8OlaDRrGSEElHK7/pdgH
	CTAzingEcshphh/iKHQMkA1cECMsdwBsmniKTHhKgzqdnvCqF8HRoDr0fD8pZ4iw
	UNeT8dVBRnt8ttT+3WQ9TOyEVYIm+99swmfXU8Izr+GBWLkIdlfe3jPUWyTzzmBK
	XHgddYAeCQarCsjjC6KjQ7GJkcRA8KuETFWlpG8TFjvFrZilXw6rX5tATRlZbJnh
	4uu0I+Df050rYWRQ9Arra2E6Gk7w2NlZvtkiLJWFDp8Hc+GDMvVoe8jexryn9g5x
	5asJGnR9AAmvVtnn84kcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794795297; x=1794802497; bh=r
	faxPZTK/QbMCHFi6RkGMIRhTOgUbQXDaCoH945uFQs=; b=isOCFcL6XU19IfOlK
	ZvgcH+XcXFViesRjSlntGVolyxMLPmVTxiTI7iqF2/fQgFfD8HE/g8FCwKgSsQPC
	q0uHgdDEJiOx1NnFmj4GrevN3Pf/N5/ee4R54PEMaWytU1ve5yDwk1MLMZP86poR
	mzgGYv/jjCWPbMIvGgIWMjpv2fbuHi+JSC79DKGWYfROULHn8WDLW7rHFuVmzL47
	xlqH5lPrH28LWfXw9SYjSjqS4PDKTIl2jRtOt/QQCFiV0eZbfdpGMdnggn/0hpYB
	SS1ob2iX5HdNWR7BbuIgJE4UDvBQI4QhqWSHluAzQQ8+xx0jrQHLUZ46N70FuDdk
	1EHBw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794795297; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:V4jFJ4Mf93gV/Errca11buq0QntiJUPwQa6cfVYkyMi7D6U
	e+kfdh0gF/D9u5PW1s/SILkP504XxyEoiJQlUaYK1dNLSYl8iYQMB1tPZjOGoaqJ
	3LHHIDMn3A8WqVtFiwc37UG00rqVGvqt1uN+KhbAaai2yFXyXGnRkPfdtD9pxkfH
	bZ9iY/rhBpf8z+l9BmvATZ/QFn968B2zt41hLNVTfa6K3EH9LdqghXmH3d1ntfgt
	1BEQRchmyNg9gebVVIAOg9QcBGAUAvHhbURLCDtsUk+G0idRoiV+BQkTzhrbG1I6
	fiayU8bJHCbbmINwkHCw7Vz/6Ru4cq/2S2KFtsg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:xZiIPiMo1RsjLCYWjE1klgNgqzU0DS3eClQ9FWI/0/w=:rfaxPZTK/QbMCHFi6RkGMIRhTOgUbQXDaCoH945uFQs=;
X-ME-Sender: <xms:IWf6anqUpxeMofp4EIyNBQePX7UZPzmb1Hsw6hTp8lJh-WXPa6dciA>
    <xme:IWf6ammJxFvnVYG7b6z8TaVNjGK5HoC3tA9KALL3n1A8FaFOYpi0FWY16-Q8a-4s3
    d9z18_sH4u7UHcweIK_IiLR4Y1dMD7K14DWUEbpHpjRn45Wd_PUIhoV>
X-ME-Received: <xmr:IWf6aocHb-J135Db1lAkX_xJSCHUwpJ-5Ewqh7-qDrfhoqfNsoaR10Eil8Ucn0Wu>
X-ME-Proxy-Cause: dmFkZTGFIhyhDLa8hCqx+pHyX8RXm1/F8IxDFWP8po2umGjNomO14L385ifnOaol0e1Q5S
    mozlZXmxCzAlnLWsWrciqC6HsT5r/gK8BNB9f9TVyiBE7J9LY1DnAVrwQx2I38fNqJl3sB
    RszqqvNLy5iEFfWM2ZaJt4+ymipA1yv7b4IC0rIe5AT/vDy6OaPXXuZksIR1iB1AkBSIxm
    VAeH3j5Z1CSzyCYYnL6dC47Odz3LiGX0GVTlZTL/K9Q13klpH3uZA+NemLKVnbCa9OneN1
    SLWhBX7j4vD66cdqEqh91UULtg0ueJ31/Quw5mTnuG2s9j+ffvQX8JabMhbsmSAtzLuYCK
    JU+r09UPdYzJg/UUthyMu6YLs17qghLalfJQztGnJrelFRkJ7nD/fZTkE3xxXOCSuXf/7o
    7mqjdhjPCgs2t/Rn0QazZvd497rPTjGQweoMuz9XJcdq6v1Wle0v0IZr8o6JI2zmQWDAQn
    +KattwYgtuPvPr4+fQvUUaT4bpupFpJ9UmO/sIB6/cQhr9Ak39A2ySRIIqH+4ordDvwnn+
    pTwdlMS0EpHmYmq28nDWvIIvnbQhZWGfb1pgf4r814ZueGU8lbZGuxd6IkIiVSBH4N60FR
    jIQH5/Ju/sXcQk5KdEbhaMj3PJNvKzPqVWZ0pUp1jsGYkyVEiarAk5eSEJkw
X-ME-Proxy: <xmx:IWf6aqo0Hz5IesFDkv3XsjUfclh3ZjOvwGaiqCeOOHPLAXBqNOKkrA>
    <xmx:IWf6aqMkWT4owQqlCj850764vWHlSLNpKPxdW6e8dBKZZwfO0o9g4w>
    <xmx:IWf6aljy7jqYOA00bdxKnVcJOqW1r-U_vuSJZZcx50n7HEk8_KFUHA>
    <xmx:IWf6alt4PvKJytobHXo_6s2K0A-cpzmP9I5CLuDPT6LpGRCR4aEhgg>
    <xmx:IWf6ar52K0Ndv1I2F_1SIwCdbdMqKWfJtgk4RDeZOmdgQ0Tw8QKhWxQe>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 15 Nov 2026 21:14:56 -0500 (EST)
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
Subject: Re: [PATCH v3 2/2] ksmbd: decode version 3 fields in ndr_decode_dos_attr()
Date: Sun, 15 Nov 2026 20:14:48 -0600
Message-ID: <20261116021448.2485495-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115155308.415734-2-koray.fra@gmail.com>
References: <20261115155308.415734-1-koray.fra@gmail.com> <20261115155308.415734-2-koray.fra@gmail.com>
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

On Sun, Nov 15, 2026 at 04:53:08PM +0100, koraynilay wrote:
> When decoding a version 3 user.DOSATTRIB xattr, ndr_decode_dos_attr()
> discards ea_size, size, alloc_size, and change_time into NULL. When the
> xattr is subsequently rewritten, ndr_encode_dos_attr() writes zeros for
> these fields, clobbering their existing values on disk.

I tested this on top of 1/2. A version 3 xattr keeps its flags and its
size fields when ksmbd rewrites it. Without the series the rewrite
cleared the creation time flag and zeroed the sizes. smbtorture gives
the same results as without the series, and KASAN reports nothing.

Reviewed-by: Ian Bridges <icb@fastmail.org>
Tested-by: Ian Bridges <icb@fastmail.org>
