Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795878191;
	b=kN4l3SqJgsniuqPnZ9sTh9Hjc0+X/Ip8fuzWw+AEBuoBOlxHNmnlKD3WIefj0A1ydzNG
	 gtZfKGR5Njp6i4wWuEhzmKBLh5iVv0VrGWxkvU72JMcrhCaDdZrEA2BzjvApQDlmqSmet
	 OSmShVTj96LoCSiP99TFjOWi4tHpkyUvscg4x8x8LbOMZ+owQaJ4miuRDtSiIi0TMEZ39
	 lZySr7Wu4nwymAg7cF3VIwTtVGemwGFNRPKKHD1T0k3Wk53t0cvbbv1PE9UOUyUxOwvi+
	 3WyjW/Ik9UKfaILVE1IhWp9APQs19AQUgSmgTNdyIX3BSqrDdjUCGQDXlWTuui+eyGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795878191;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=dS/X02TcLCNC5XwaMETlyKCX8if/kiQS9T6uszOHtx4=;
	b=XJ9tbLgcSzMJXXXphl/4otsiNOfb7bMqsot0tfLW4NZfHKqTuRQBOhCF6OHj7rMiQdYo
	 /zAOqGVrjk/lcEocVjN7Nsgi837YC1tMw7DXfMbuMzbiuxN1rNy1bmTK/p4cDLTwzNmBw
	 TR2Wt5PaCF+AVjT9LFUheYI6Dv+Ff8MHwFYc9l/dNFXBpEvja7LWihfLJTMnEWvNcAFwL
	 QEhs8zd8lX3rZGYPnoA6dRmULwPX20KnVZiVwN89P+Y35gsbBwbNx/ZUSBXGHpaCqJc4A
	 SLPvlGRCpx1S0nfQgqHml4QDF/uwo0wSnPhhS1ca7d1ye/l3afSmHQDfdI2l9D9lkzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ahIYb403;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Q5QVf7rZ;
	arc=none smtp.remote-ip=103.168.172.154
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B54606A31C
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 15:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62B54606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ahIYb403;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Q5QVf7rZ
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 714EE1400262
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 10:03:09 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Sat, 28 Nov 2026 10:03:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795878189; x=
	1795964589; bh=dS/X02TcLCNC5XwaMETlyKCX8if/kiQS9T6uszOHtx4=; b=a
	hIYb4034sz6TRRwJH5eFL1+dZsjcPEuNjR2FytzQr0c560ksqFHrOfjhbyrCC9Pw
	kvKuv1OYb+11Yv1kGa1oQ+JpXmlnUq8WtoSKWd78/E3iYo+zzNHdRiu15mU9iq+f
	FgXml1T+WdV4v2Y8nsM0BlJQNdv1Tzwdn61cnqaLifN25JsS5oZwH8VUPjnUDJDz
	HpAmD5dR9GrgL7KuBZrtfL0Uq4yImH9djPdUBdzIy/FFdNg4FEPtUrHW/Qu3byoX
	e0xQRmTyFA4TbxydD3jXjH6vHwMZCx72mEkwRCO6dLAwKb/7DNOl4u94t5k1BOzk
	mGAV3M2/PGKNnFe6HHmOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795878189; x=1795964589; bh=d
	S/X02TcLCNC5XwaMETlyKCX8if/kiQS9T6uszOHtx4=; b=Q5QVf7rZs2xZVciXW
	LACkVAjzTe9QaTW/9KUTYq9ZJDxx3jFbLXpZmGeOU8KxOJj3EwR53rJ68WCmTdIv
	aH8+lsFmExq63v83/NqK/kDHrl6WPKeP8TBh+m0/33VLp6+gtjW6S0cPzcs5CoUk
	ghf4pm0aM8AQeuTuqVNn/5ftoOJRwnlrGVRNX8xY+4l6AC8YfRBe22vceW51EBHB
	fyIjWGzUk1JRZ9QNVjRbKbWQCO4dLInGvpdU2r1sD9UjZ9I5SFKxlXa4GfuKEqUv
	lmCev2O8YEFhmFRBiCJ8TLVloNtytJlx3JcH9hXBk224qTV3fgfg+Rl4tjSvpn6a
	lH4kg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795878189; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:k8qfLaKrjrcAyMDJjOxTWeIjT1wI6rUi71F6HrZ66t7D+CU
	8CRZxqNWWOuZnTBYVWX4WoxK9P3SHpQe8ZWES3X12tqh0BUrMeaky2iDImOJ23Db
	Kj3oax7ZlPuUkB/Jfv+3hRP3WL9AAXVtFP7hAeTQPfMTb4kdiKhaRY+Kx76l/sNI
	fOB7IHZzIVQ1yizO6nYpfMUs8NYvI+0Fau0X+x9yxT1BDg6SK1gRSvw1p9NWlKUs
	o9nfBZBK7eomf1QmlbjXcOCn5QvI7DHgqdJb+wO5urizIrfKetkxfP6l1V65JoAB
	avK8ix93SuzRLmq084Ee84Hdy9+UolfJVfcj8BQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:knFGVeH8OYEEWuXqS9ZLWDNRRxyMQqiisD6BgirtZ8k=:dS/X02TcLCNC5XwaMETlyKCX8if/kiQS9T6uszOHtx4=;
X-ME-Sender: <xms:LO0KawsSMdtGniTkrYS1p_QAVBKHVyd0pd8N3mxLyV2L36JLkmNLdw>
    <xme:LO0KaxLSr42t4c8Ebrd_FLGmEXGb2fIsfKU6vLnHsQxAVNh6IMuGoBFsY2zqaDMzo
    l9TdvracXD4vnqoVVk5sdBbCmfIR82DMBUA4-MxR7DjZWGW1T0UF8wV>
X-ME-Received: <xmr:LO0Ka1n489eXPno_nQUhFJm0vR_7m7fPM4CNtmhxHAfbz19zv3LpOtLPg7GKpbD8>
X-ME-Proxy-Cause: dmFkZTEm7pJBIO0sQNBQA7w89RUWxezUeUpey/R+PVQbf7bLS5Qu/fPVAHI4i84ayBnWZB
    e78yB6hZi6ebeCIKscZslAF4bPDHzJvx1IsnPVS7zNJvjUCHzIbXtqCmv86eAj3yrn6uTL
    qbwebPcqE0eD1/Uyjlp+OJj0VliWs/aRh4NznDTCvaynFPC0D+R6oZb1T2atvimfKfp2l4
    nNycEjKHj4CcvR/1EFtPwngZZZKVcxOLz7NZrgtxW2iVS1HlIb0tEEIVx+HEqJzLBXKYca
    RPh+AEZWyEBn4BG8M/W/KLOHoAhyxnPlMDbPq/9EKMgVeYu/nToFJTS6PkPTUGUTQ4/sPL
    63KZq2GmvGg+rT2OuSintH821TUEwUGW2Wo0lmoRbkiL3GO86x9+4eJxi/obDvybZUBGcP
    MCO5R9F0xPsaIP2snDYhtsgdapxB0bAU54PGBFL/gPUYcTxHHHEaGaJxQcBoCsTDJpPqYR
    yzMNfWIMDeFvKw21ibq9EP1T8+Tt8aWU1a3QWYOUHNk94RE73BJZL1WZHdCDg7oTnUlAjh
    p/iFyMgn4W8YkJgxLyXB0ohuxxHQF4Z2ykheWclFegh/A69X7sJgJ+YTcACB/rRf0y3yDc
    VntEXQJnS096PeLq9W2U8yg1XdDAXRttmcDWprIs3+YDj3OiMFoO4MFk2ATA
X-ME-Proxy: <xmx:LO0Ka6Ij-idFcBwCYIBKAS-0SIe_gUOSpD5-rL352cyVTygBjA0z8A>
    <xmx:LO0Kay6HUn0JgDdLgW0uUnt7kfaWJpYfk3KUxZ5fZSjWmk15ckedzA>
    <xmx:LO0Ka20BL5NuVMUXF6-BRd3RxBGYQ_Z09sc7GCH9ihbrfVB_YivSHA>
    <xmx:LO0KawcA0Mp7VsiKTAtmzs-ilN53zRgWmp263Ly3uJrkGs4ZDjUjHw>
    <xmx:Le0KaxKiwWnGnQ_D5slr02MnboJXP4WV3BJgvvHrvj40EbjeWNVxIZYT>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 28 Nov 2026 10:03:07 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [RFC] ksmbd: rework the DACL access check?
Date: Sat, 28 Nov 2026 09:03:01 -0600
Message-ID: <20261128150301.1782640-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKYAXd9vYAHR9Ak6=Pe8=fn+HX3aVMX=z1odpbDc3dk=j+bLTw@mail.gmail.com>
References: <CAKYAXd9vYAHR9Ak6=Pe8=fn+HX3aVMX=z1odpbDc3dk=j+bLTw@mail.gmail.com>
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

On Sat, Nov 28, 2026 at 9:03 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
> I agree with the proposed rules overall. My one suggestion is to use
> the parent directory's Linux permissions to determine whether it can
> supply DELETE or FILE_READ_ATTRIBUTES when it has no current stored
> DACL.

Thanks. I will do that. The parent will supply DELETE only if the
caller has w and x on it, and FILE_READ_ATTRIBUTES only if the caller
has r and x on it. Those are the directory entries of the table for
FILE_DELETE_CHILD and FILE_LIST_DIRECTORY.

I would like to make the same check when the parent does have a stored
DACL. Otherwise, storing a DACL on a directory could give a caller a
right that the directory's mode refused before. With the check in both
cases, the parent supplies a right only if its DACL and the filesystem
both allow it. That is the formula applied to the parent.

> Yes, leave directories out of the DOS read-only restriction, as Samba
> does. For regular files, please also match Samba by reporting the MxAC
> mask before applying the DOS read-only filter.

I will do both. The maximal access reply for a read-only file will
report the rights that a MAXIMUM_ALLOWED open would get without the
attribute. The read-only share rule will still apply to the reply, as
it does in Samba.

> No, You can drop the existing read-based fallback and follow Samba
> here. For MAXIMUM_ALLOWED | GENERIC_EXECUTE, ksmbd should check that
> the DACL grants FILE_EXECUTE.

I will do that.

Thanks,
Ian
