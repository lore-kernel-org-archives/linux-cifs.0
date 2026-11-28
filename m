Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795835806;
	b=nBBNtc0L7rDgignNB3db1CRbU65peyxy4h6qP8n96rZKEY7WNmpnaKlEvrzceE8Sg0tf
	 mukMdcem8uStsGgy300PSYchGYD1G3N7F+RHnqy39s5KC76EDWkiz5p4VZsqUYJh6+DlR
	 20DwDrmVBmIxEs71K1S4g2U1EyeaSvqemb/VOIFpa/00B6UXeQarpGbc1ww/BBipLdJ7U
	 rcbYxI0CTA7j5hbM63x3HxcB1aSG6ZkpFuYb3FXrlcNwMNCeAVYlRV7oJmhxBP9bu2RJd
	 omkbCPl2WzFad0dNjj5WPS+hzbPbRvLVa5iwgerNvuL4SwIBwZrnOKZzwSdOrkxk+cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795835806;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=dO75eYs4/wSCsD22L1OYraPAAdLFv71JWnrQsWMvtSQ=;
	b=uaWYRd9H5khqu8NONcVt2anx6XHU2/HSb52Q6q8/KrvJuxHG4D9fczfPEUp2NQfoIS8L
	 LwDz3YTX8gvcUsXZCDShruAIIxrpvX54c7hdkFD3CDGGF23cyNy902mrN/3xXT8Oc6jj6
	 xJnWvozNfm3KZIMkI8AoV5CUUj+7AHDYMi+wNGtLi6I/DUGFGSXdyCiNEyFGJ+2/FYmcV
	 wu8rcX5bDzxDrtD/EL8xrNRWQrJtAXwnHxUlIEXv4T3x7wLQdRiSfH4L1y1qR3cMjofMA
	 tmPnEOa/aaJivbdbXF5NtN4q29ju6YK/wDEfym6xlx7wZi/Fg9PJfhFIcZ5pc+tZksQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ywi15rvw;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=EgjwHJDF;
	arc=none smtp.remote-ip=202.12.124.145
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD21606A31E
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 03:16:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DD21606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ywi15rvw;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=EgjwHJDF
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 5B6091D00426
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 22:16:40 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 27 Nov 2026 22:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795835799; x=
	1795922199; bh=dO75eYs4/wSCsD22L1OYraPAAdLFv71JWnrQsWMvtSQ=; b=y
	wi15rvwYzqycUXJ6Xo3MaJrOybHvBFrB0docEqkLQsBEGJQUkOwtu6tDO7LSi7DP
	XJw3tjP6viEkI+Wf02/qTD2OUbR8rlrUNKZTaga8k5QwL9i3E5W/aNbEiJo0ujV3
	mQU5E3faVSwca4WZ35x/tqfw59v9Ea/Mc1OMIHfGAO4GFWK6pDTmeLFVEhgOOUBX
	qzGOsI1VqOdewPi5nY/xh5fuFYp6LmteJg3gsOURSATb4dGvgwPbzp7aJBWZ8g9c
	tvWCrxHKDkZ2B+w7b2NTxYi6q6zb36qI7MfX3Z/15ThGw2FSCtfZBF9qhTrJDQIL
	d78cJChJMW8PQoC/8j/fw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795835799; x=1795922199; bh=d
	O75eYs4/wSCsD22L1OYraPAAdLFv71JWnrQsWMvtSQ=; b=EgjwHJDFXOsEqWBdo
	oylj6TEUc/7sp31ZMtxpeBBvzavdPFlF8F7eIO5ok0/I03RjYe7UM9Nhh9kdMPmZ
	FZnwZdpEvlakGQHbM6X6ptCAwz9DbJcZqi+vF6KAlkMWDc20Uz+N60j1nBcm4aCs
	yOtNh+vpwTMjnc1hOkZYFScb1t8nOBmhLbEVliF7pB0aaocFnFWA8Y6Wkqz36HBv
	DHeCc8mETUftgsUTLctXVGzAHElahNQKEN2lLJniPq+sOMiZuVPDnCJ07p9SVtWH
	1EjpFHW9DZJw8MfSH8gakvhuOc85WoGfHPPnw3QJILRFSYbnag/3/5WX3ov06t2X
	bMWRQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795835799; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:SQFeg4CIRVXgL11ocZelJuRYKPunrrTw8AsfgXLFJKWqx5q
	bFTn72CwfEXv/etdoBBWAH4G+akVt+jSW9aoeAuixb99BZm7Cz2q8xHsAbGP3rOB
	krBgsLKF2/9ygRCiTQx78n1Kim4P0UgGIq3EsHNiIfvJ2VJW6uF8wVxxGARWxjCY
	N3jeDbPRb2NWtCRtPC1vxF1VngwHZGQjhOpZqCvtAD9wu7i/AiCF/wbE1pTvybmL
	jaMUYC9r2SNzGX4O6MPDvY12yqcSiBXimuqS9oemI0wYIcKz2jtOTa83rMYK2dSE
	q2q6msK24GZWJtsgQO/jO6iuXmL3+lgJzTSj+2Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:HWiHDUXKWqiS/Iaoi4EQuK2Qmng/oCFfnuvbkTRHlO0=:dO75eYs4/wSCsD22L1OYraPAAdLFv71JWnrQsWMvtSQ=;
X-ME-Sender: <xms:l0cKa72aH_9QiasKlAxcHkE-vocuZJJd2ItJzMPy0GBrNTMZGqactQ>
    <xme:l0cKa6weZiDHotF3pByJW6he0hV31WslLXOslUmUDDz7g254uTxOKnRdRlx_Ca97N
    irya8B4_by9KzCTFz3iFbNnZoa691GfrpG8-qWUOXV37AH-E7MNx3qM>
X-ME-Received: <xmr:l0cKa6FrTkFiwin9jvPrzZnTJqm-si30NUqAZ4Z3EWjIa1LB6X7Re5T_zfN202_H>
X-ME-Proxy-Cause: dmFkZTEmvkgyibbKm58BjX83mzPkZbGMNrxTvkC9R66z+eOCc7ZxVsoQwz3uTkoMNpjaDC
    4Maln4+2ERBGUvVi2DO81YQlZuDupqg+YgDN0xzPEQz1dl8poc1DKW8H3TB8ekM3fiH293
    aBT2gzVSOmb34ocfXmH2CkHjEOx4KXBPBkhZgC1Nt/l1TtvBv1SUiA6bY+qD8D+PiCz/8a
    pyUkq0lbvH9k1Q25ZyzfKRBySWEOAQ8JT2b6ALAMPC7RZzFJEJ1hI0rRnVKk0ST0F4QUwk
    yYmprghPOCOa8UHKkYpUKbWtwgPW3j9P8ljcv64XjhGP44OPkJ1RBjRKb85Os04epIVBY2
    OLfV4diYKCYgfKjYDwOIRdNsiGPdc5WdLTu/9SuCl6IZwfgnxus55eC6trzRrulU5C16s7
    /AkJzKfykfh27KIi2RH0GcXcE+YhYixg2mGBNOeeJDnbltcSB56diKxNqHF1WPVOGXEG6M
    atXT5RXfMZCPhj4LagGG42ae0XGBCMbWdD/+N+c7g/pF9d12xQAPvoAE2f5byrdRT+zFo9
    X5XjEPRX6cbBpaNprTsnfFdDuY73rnirHksVLBMnIO8zurczu/mbIwqSEJQeZyqjKW+cKJ
    dde38TzXt3vHs/jBzX69ouvtcyJ818gcC/RzDnLrIU/1lC/Ajbh2HAbjjNHA
X-ME-Proxy: <xmx:l0cKa1bZz2th0x1pxACPncOGmY1bNKBxIcjnMYVqpo-byOFgITwj8Q>
    <xmx:l0cKa0Ap5QdbYjJGMBuTftFWfodrHonPaM2-Flk8ZV_y-hXjJJl12g>
    <xmx:l0cKa1kLC1XNs2SjRNDTrFhKdU0HJpMmSY0SzOIgOxaw9thD-3fDNA>
    <xmx:l0cKa9yIfllQejmbDozwPCx5EgBhB76NMaYIICq4h7USCq5ox9fYMw>
    <xmx:l0cKa0o4n9R0pn-HGCV8qkCam8ePUbJ5XR-PXvdKLZWbWricAVcdogm1>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Nov 2026 22:16:38 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH] ksmbd: return the cause of a failed link
Date: Fri, 27 Nov 2026 21:16:31 -0600
Message-ID: <20261128031631.1713665-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKYAXd-qC2UZbsOUEWvt3mhViwOyvHEqHt9hLK5+aiiuMC-4iQ@mail.gmail.com>
References: <20261128013952.1691873-1-icb@fastmail.org> <CAKYAXd-qC2UZbsOUEWvt3mhViwOyvHEqHt9hLK5+aiiuMC-4iQ@mail.gmail.com>
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

Hi Namjae,

Thanks for the review. You're right that passing the errors through
does not handle all the link failures correctly.

I'd like to propose one default mapping for errors from the VFS, shared
by the handlers, with the link path as its first user. It would cover
the cases you named, STATUS_NOT_SUPPORTED for a filesystem without hard
links and STATUS_TOO_MANY_LINKS. Results that a handler carries in an
errno today, such as -EPERM for a sharing violation in smb2_open(),
would set the status directly instead. The other handlers would move
over later, each in its own patch.

Would you like a v2 of this patch along those lines?

Thanks,
Ian
