Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794339071;
	b=RyiZpNsrPIMd5ek6NjDLcM6rDXVwWcli3XyL7Tqzh+8JmK44CY8pr0T4pimP4a8Get4n
	 V1kouoiNvghaFWp9pEj4xsd3JucSl8n64dIKHIt1TQNGK2A4r7iIdelssAdi2moddfEUM
	 SY7p95Gd8ytrTwlAj8g3CVx4JD7FKLWLkS4hP+BmlWVgIQ4CeecRTecgJ1gSUihfwXzm4
	 CZfmfZKMzBZZN+08vsaZMWT1s6AJqbqEG9cq0L9+XiRDE3vZ2N6Wc2pJ6ARdok1wcYI47
	 ZD24CuNeWW9qyMG9y4xRjynvsx2H5efxkXtlE6+InBIn8PEMtQ4insfK47VEf0QDtYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794339071;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=v03e9Y03TCTAkAvci/8PC8X7VD3txoGBmM2Y7VpeMIE=;
	b=ix/09MvQpOXt6CaQ3gLWe4daZbDEPsM0eppZ0gPVwbpPdeLkNWGWxN+gkr6oTZcy1d4h
	 daf8JLMv7w+DbuKaqeVB6i1YipccZv1eNzvZvwQeOw0Jg33GgVXBYgcDU/eRxIZ6G0yhO
	 dh+ensIbKoUbSYI0/XuQ+37kptbdN7OOlAivOrvxeDi/oHnfeLpOy+b94Oi8DtaDHBEf1
	 g/I69hhBA1/qcW9lvpb4jglRvDLVuGIadYL3MowaTnBTChSQUMU8TGr/nQikEc2SxHTKd
	 CjGDLYan71LZv28dIgNkA5uHs3E7of74lPH4JODceS57DG7cCmlUXZbbog0py7cyPLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=HdezrP3u;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Ihs84QX2;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04FF606A321
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 19:31:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F04FF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=HdezrP3u;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Ihs84QX2
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 35BEA1D00296
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 14:31:10 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 10 Nov 2026 14:31:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794339068; x=
	1794425468; bh=v03e9Y03TCTAkAvci/8PC8X7VD3txoGBmM2Y7VpeMIE=; b=H
	dezrP3uFOzaBbwW6Ego1tbYbzvAe0I7ekXaqqeIJak52WN7Sh74ZLdn5cMe7kpCN
	ca8+SKinjojeyahQENreiVALLKSid26J5HjX+Mv0tr+r+zVZymqb30EEFgCA21Zj
	MZLNaHeMQuR/WqXICKsirAU5OA907RiJwFTGiJqbT7q1UW1L0EEhJHCW3kWixBqW
	OpJYN+NYC+QzaJhgN8mhdZY8wog4MyAmfFi14i45PodwrkO4UEsPqbNPtCAiBrPK
	7h04MnU/i1liwwJbP9C4qvhzmnN+Npt8ff6GcyPbQUy81fGKSlft6rtGMvr7um4P
	kgKZbsMyCXiMM7iXDU/dA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794339068; x=1794425468; bh=v
	03e9Y03TCTAkAvci/8PC8X7VD3txoGBmM2Y7VpeMIE=; b=Ihs84QX29h/gxJhFu
	WxtDkmWm10fdzVkU/vHi9enYgbBP2jq6vDBm9+pmmpTG8ylHxv+9TgbRjxKpV6Q3
	zTDLfd9kA9H3a6pMeXAq9+RJEnVMvY2G6yByEbl/ivyr8KQYxE7XNqTw2kmFaeNh
	DdRn3LYfn5VjNMSm1v64Z+aesCTx9poSzAPpj5QPN839F+4sAsoF6mgNl+LTib3u
	UPlKyeic1yQR/9Vu0h8NDb+0ECYyonkMrCaDtBwXCt7kv4yzA07jk/5tT3NgBrCp
	Xeu8AcsDI8Fs2JLSfZ1QaEHbDwjBUEbwcb72HHpbKHZKg9429y5x05S6b9Wow5gs
	LUofQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794339068; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:Y+Ww+OC21tb81hquFqBAaY2cZkmZqZCHVy2obSjifSp8Lbn
	eLRupA8ZUurJU0uk6aMv4dL6yxw3wiIPiXrxGncGN9t5b+LqY7D5yhVaf4XotWjW
	pIzZU3sNKtTGEeWhH6bRf9+rQ0BJ3M9b6eF1NfxQhbRgdlrHkjO3iXaSWwbh1N74
	Tx3N4PFeP7BNbsKIp0LyUzRSwLdRkCz2wBw/iekJLd0ILRMH96cewLM6mgpmHioT
	QBJOTC8UKLy5c5TShEv0l/7ipdmGbFeiZ5mvlwA/ypefh9XLh4VsIHV53guX6uaR
	7TBjS62I3kl9uVyUdJ6cWKdWE0/L6oRL1ZMlc2Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:MAJ9DqFnDeSq70XNulQ6ZtRPOgcYsxs2eX/baM6PlZI=:v03e9Y03TCTAkAvci/8PC8X7VD3txoGBmM2Y7VpeMIE=;
X-ME-Sender: <xms:_HDzaumnvnU24hp5y0Vh8PkY5D4dGqLhNJlTnEwOFhEdmOzmcayMPQ>
    <xme:_HDzao7VSXYadpPxo2zesqDx0usG9PeLh6TsV4IMOm2MBULB3OMzZWLxr8Jzj_fRz
    AJB2Kx1lJHsrrfDt5yskHY7TRuHl0zD8JXWvhja2mWzLYiS8pYwzWM>
X-ME-Received: <xmr:_HDzanRZUxKDFxvw5kMD6n06tsYKqPUGZxV8TTTCb89mxp4b4HNGGQuJXe-MFe9a>
X-ME-Proxy-Cause: dmFkZTFMeJeww1ENRAMLr95NPIDKq1Ih4yfW4uN7X/Y1stIPZFHR4+JaX2YuW0S+cxsHv9
    sv3MxakxEf+rP/GyryRvnt7z79clzwe3xEamKCrWfJG6rPX/iB72O3dvmBglFpXB5H9Vhx
    WuGL/MMY6lpktrXZhpEcLS0JVQjSbwhxcYcPGigkKqOGJUINLSes3PRTGjXcZHFnc+Oyey
    K1zvPf2qJhi/3hDixgre65FZul7xMH7hJXANtv57+BLIGrVhzp5vOvy3cxNujD9TJciwUy
    xLiGyFEE55n/B4tr+fB9E9N1Iy9QXDaJEojjqIDR1roi0ZK8CgyF8CUmm2jNPO3eeP6Gs2
    PWt08khz2cY9Zgn4cF02e9zSV5tvpeichBCj8EnBUQIjG6rZInrJcW7dhC93uMx/x5Wa3F
    iNUuBFunr2KLmQzbQZnSHTR4JUyMzXjlCvEBltwEON/3B/WRHkOa5dDIBjpKCqgoRWwjXg
    Z+yn3GOgmc/kMA5djQb3GexYuen3bhAcYD9aKf07wXqXkCgOEg+nxFSvT5AQzTYrz6dtpM
    VHujIz9WR6Bd8ixopl/vrfJ+XuA9s6NBWWVf60f4XwahVRvzZCNkK4Wa/TfYGC89GPZnft
    QV6BxmCBTCvEjAHXf/BS9ydY9bzuOtshZwL8pWI+p2j5G/f/vEWIOjNrXgLQ
X-ME-Proxy: <xmx:_HDzauzFzZeHLTDqtfFN6yCL1XwIZ_8OwDda1yfJHIOfaLOyw20rsg>
    <xmx:_HDzanq2vzPMljd90zOsbCeCsn9w3wC1j5LJvQTswlfrfIBBX4WNmQ>
    <xmx:_HDzap1efA1y3Gnbw3k4e8YF93hmdmW2MDvCXaWtQmOkUKTWMGamDA>
    <xmx:_HDzavwYLGMWAHpkd4gisPz5SjOZphccL7n-2ZEfGSlipxgrdOrZFg>
    <xmx:_HDzageRxP64uxRoSs7wDNYux7rxZDyn8rA9QZm81jbcjvlQcZJ_ZpYa>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 14:31:07 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: mike.michalo@gmail.com
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	ematsumiya@suse.de,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH v4 2/6] ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
Date: Tue, 10 Nov 2026 13:30:59 -0600
Message-ID: <20261110193059.3200468-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110165834.28162-3-mike.michalo@gmail.com>
References: <20261110165834.28162-1-mike.michalo@gmail.com> <20261110165834.28162-3-mike.michalo@gmail.com>
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

Hi Michail,

On Tue, Nov 10, 2026 at 04:58:30PM +0000, Michail Andreas Michalopoulos wrote:
> Since connections of the same session can now use different
> algorithms, each signing key also has to be used with the algorithm it
> was created for. The session signing key belongs to the connection
> that set up the session, and MS-SMB2 3.3.5.5 requires a binding
> request on a new channel to be verified with it. Store that
> connection's algorithm in the session and use it together with the
> session key, while channel keys keep using their own connection's
> algorithm.

I don't think the spec ties the algorithm to the key. MS-SMB2 3.1.4.1
and 3.1.5.1 use Connection.SigningAlgorithmId, the algorithm of the
connection the message travels on. That holds for a binding request
too. The key is Session.SigningKey, but the algorithm is the one the
new connection negotiated.

The two algorithms also cannot differ for a client that follows the
spec. When it opens another connection to a server it is already
connected to, it offers only the algorithm it negotiated before
(3.2.4.2.2.2). ksmbd supports that algorithm, so it picks it again.

So sess->signing_algorithm looks unnecessary. Where the two could
differ, with a client that offers a different list on the new
connection, the patch verifies the binding request with the old
connection's algorithm, while the client signs it with the new one's.
Taking the algorithm from the connection, as the spec does, would
avoid that and the extra field.

Thanks,
Ian
