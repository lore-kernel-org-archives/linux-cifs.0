Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793726271;
	b=t3chyQWfZ5VXo4Q4vyrC4kn8rg1cKbFVPzaieHDVVp//LTTPVG1mHkhL21KK5LTmqpQ1
	 qiLEPCLIqeoMRhpRTaJFgo29U90+USv+7FOxcoopwxY96k3f3kbwGnw8r61QMa0bd83f9
	 N/P17WuE6ru3PvtrYU9S9Aq8uLGF2naWYOEfhhtxmuAhAKaEJ5VuUrDTnau1rsWflW+0+
	 1fVhbX1hjf1l839bbCuWQ9y9N7O/bCl6AdB6k7tzos1wGlxY2JCTQ+w9UirJ5h2bWSV2G
	 PQmhvtKpita6aEfsnwu8ytIxN+V5ZEH1/Z6l7hcGePsCd5qNwt8/rYVp0rpQqr/lEtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726271;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=/0eFtgdWCT9ievg6BvBpvg8HubF+eG36xt5HuaU9W+I=;
	b=OW1ZQvYImLi4VyMDr1VmeD/4R/Rn7Lf0DBBuWyZKcU62EIb/A37eDrwtiZfhIPGw1Zda
	 UD6I1A0oXZwI49xHBPoZY2kwhm5ISX0VA17fD7pRJ9utLLmifSVdVav9glESoYqKc2dWM
	 O39YkSKekUVOU/Rhs/n3SRDeURIsC4NEcuQMr7zcztZ+41Ja2WEkB8MXiY9TQvbR25tfU
	 eqb9oQ1vGFdYTlAFgmiOnluug+pb3eEgODWpaneHdLoia1S3suMhSfxS1Y/PZhJRxIBTY
	 3w411x8Im0tZrpUa7gIEM9KUw53robMXbae91t4r3C/R1XBEVMtGNAz1bOsSRUsj3xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=K7CP5YGl;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=RWJGMlgd;
	arc=none smtp.remote-ip=202.12.124.153
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CEF606A324
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 17:17:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83CEF606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=K7CP5YGl;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=RWJGMlgd
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B78CC7A0170
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 12:17:49 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 03 Nov 2026 12:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1793726268; x=
	1793812668; bh=/0eFtgdWCT9ievg6BvBpvg8HubF+eG36xt5HuaU9W+I=; b=K
	7CP5YGlTXxCYIOmseDiowX4hiJJtJLhc38w+iDX2GJ0Zeo14/HRLLvwggsIcLUqg
	+soWdbJy1COc5biytiZyBrxWlcQbds3R14jbDRQc9Ssxsi9aXXQYokPRXGN00qHH
	p/zDotqamxDOogeOb63zksxzBrccatjPB4Lx7qQ4wxMWzRwcb874QM/VY5h5h3+M
	OWb831DDW8PbfCsiJHfbXh9jVejGHw1sH5rwiIKuWbqgPijMf0hifjsjoz3Q8VpJ
	wGqQQvtvwbDeD9tJzc+A5PVZ1zyIYs68TrUptgfH47gGgCgcPmPLDs/cATYxTsKF
	dlxcmj0ctNtjGoF22CirA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1793726268; x=1793812668; bh=/
	0eFtgdWCT9ievg6BvBpvg8HubF+eG36xt5HuaU9W+I=; b=RWJGMlgdxjNY/ZaFY
	wskV9/34Vrp+acAAFZfWXiAnz3MSCXZFaP5jJZUnwmOn7OHr0vWqUqkpx1IFsD+u
	U+YyMc33IspoRiZJpEs5tsBpsDbuK/TsrxiN+jBB9XjjJh7maZCtnC6CMo8A87S2
	soys19Z9to5tG9aYHc11tjO7fLoptkQ67L7K7o7ff4EosyJn0pITZ07iGvt+9Mbj
	8y/hcw/a2NdgHw+k/VqEvyIgf3ZoSImbKlRdsaUjHSxrKxCFx/J14eBBH9rqajdg
	XLMh2ArxlVljjiWIz60Ilt4mxv4i8SQRUH4SdSXE8D1D693XyusCvISYp8JNOU0r
	RUG2A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793726268; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:mYkFtAh+1Hz/suCyJd3nuD4KVMRytuND9/Aylx4hCgM8ZFV
	bY3wGSB/UMT+bStWHVor4iUroned0Tnro0EkQ4bPU4waO7DHOlxKbHmWAEbNrFCl
	HAjYanJG1x+WvcOI8Lxf16wOG2VKHFXmTzv1zNxJXhGZ0r5VpN0QumAyQMWGvCYF
	XMZG9AP4IU9B4ZjkzXV8bghXlw1Vxi3HBVgTL54JCYY4b3SByfo1WB+TFR3IkJTi
	8hp7XwUwDk68R2ZuGY37dMPNPQOiUpmri3KI7WWQELo/OlFsXdh09iw/kTGSvcNp
	lJHng8/Pb7mKNx0+OeUGFHU2dAHRnNI9eGXIhvw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:x1og4i9NDhPD4bFSB+EtGtr1eRBzzoGXLC74GmldXxc=:/0eFtgdWCT9ievg6BvBpvg8HubF+eG36xt5HuaU9W+I=;
X-ME-Sender: <xms:Oxfqar_QDTewW3ciSbVwFHEbAdqm2MW2Cw5Shm2oivPxhA5w0FIBNg>
    <xme:OxfqalHkQYCAdUvz7uDnEObiNbIfbQffMuhszGNdsk64pKjHDwjptOT-sHvVrYcM5
    CkdK58tz-2HAGk9c43Zq1xjPDxzF-mjGJthpCyeWF81DJTiJ6Jgkjk>
X-ME-Received: <xmr:OxfqaigNTUqLWt63OFjUh3K8EwbGgcyhegr6kPKBb7Rs8m6iCymsGVM-V_Pq00X6>
X-ME-Proxy-Cause: dmFkZTFrKKiluzU9F/faxFNTYz8OEzrdlp/+P1qopLzgYZTahfODAjENwYGXpf1A5UmCh3
    JzBOYS65Awfj6tV/+k1isntrPCiC5T6/iK/4jotiqccvnXNyPJsgJeZOJe0fBLW9z+r9Hq
    uARKg56uZat2hdIbaf6uedLqzqTYFknS19lGFvqGdXfEcSAPG60cxrca13Wn16NGJ4ABMC
    jloGmfFJjY9ipgNQCebBNE0cVARDOBORlZx0yrTBdIscubR1e0HXLfk5LYRwgqJ3M+etLZ
    zBj0LQcQzYqWFn2R/PQCfT7qqpUuIK7T2kLLLJxQHYFZNCOvpA5Y465NieQ9f0yPRnWecp
    oc0bRGDCaHV56erFQrxudOQMw9nVmBs3urlJw1zYGOabTZJj1u/ipOhCZq+E+/d0gcIwXs
    cM2M4JogJej9qHn27oe/H7r3XXEASpdfLGMR9jPl0HZzqhCQfwECMexMRlu4TaZZJlXAry
    tTQYCDs6XAW0KdxszlnI8Ay++hugKXuQuM75GGfbFt4QY5vrSkUrhd9/gRmLPGdg1UF+af
    lrS2dvpSsOwTd7a46UjmIdA1Jkc9XoP43IADlvn4BXJbvUKx00AyF6wUjBdQL5j9oGYZCq
    4+SwOSXY22TLUnOKTbiYMPG0pxGTvkDi5rfcdZuR1ji/piex9fKztgfbd8aA
X-ME-Proxy: <xmx:OxfqaitM-zYmscBAxi6X8GMHGFlseFe5WAZ7wrVm9v5q5YDlnzdMJQ>
    <xmx:OxfqaluWihOKKD3_IOkpVsJ4FWjkBZalXRHgK6a8PXkdb-esmn6XgQ>
    <xmx:OxfqanEKSlJYcWRlA0CHFCRJYUj5V2kzNxzY1jXsqi1aU5J5XZtluQ>
    <xmx:OxfqagPL-COEgepbht8CoWdoM29KnFc6mGegh3f0DsvKOoTOz6g_Gw>
    <xmx:PBfqatwIbMCzae6PdLu7SbgrsT29_OlJNHOF-_0Cqh3PJ2lQ6b-Y4AjT>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Nov 2026 12:17:46 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: mike.michalo@gmail.com
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH 2/2] ksmbd: add AES-GMAC signing support
Date: Tue,  3 Nov 2026 11:17:42 -0600
Message-ID: <20261103171742.18816-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103111453.84804-3-mike.michalo@gmail.com>
References: <20261103111453.84804-1-mike.michalo@gmail.com> <20261103111453.84804-3-mike.michalo@gmail.com>
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

With patch 2, an existing gap in SMB3 binding request verification
leads to AES-GMAC nonce reuse. It needs
"server multi channel support = yes", which is disabled by default.

In the multichannel branch of smb2_sess_setup(), ksmbd checks that
SMB2_FLAGS_SIGNED is present but does not verify the request with the
existing Session.SigningKey, as MS-SMB2 3.3.5.2.4 requires. The request
can then reach authentication processing, and a non-success
SESSION_SETUP response is signed with that session key.

I reproduced this with multichannel enabled and AES-GMAC negotiated.
Three new connections sent binding SESSION_SETUP requests for an
existing session, each with MessageId 1 and a random signature. All
three returned STATUS_MORE_PROCESSING_REQUIRED. Each response was
signed with the existing session's key and used the nonce
010000000000000001000000.

The responses contained different NTLM challenges, so distinct
messages were authenticated with the same AES-GMAC key and nonce.

This violates GMAC's nonce-uniqueness requirement (NIST SP 800-38D).
The same test with AES-CMAC confirms the pre-existing signing oracle,
but does not create the GMAC nonce-reuse problem.

The probe also recovers the GHASH key from four of these responses,
two pairs of different lengths, without the signing key. With the
GHASH key and one more response, it computes a tag for a different
message at MessageId 7 that verifies under the session's signing key.
A single connection reaches other MessageIds by stepping through the
credits the server grants, 64 per response.

Could the binding request be verified with Session.SigningKey before
it is processed or any response is signed with that key?

Thanks,
Ian
