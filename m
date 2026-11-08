Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794182294;
	b=jQWqNjnnZ2EA6Ufx2q+uzYJN2zZkFTxgcwNXKHHnP+RFp6SUBm3oExfvzbXnN6eQGo8A
	 lxm+9oRFIreO52haXS3okGAiMwjwzelcuBSf3DgGdIgQVmU9NBDkahyZbz9B5RfKOLw/a
	 jGojgsApDrTPgnHvkGU71a48Pux/B5GxY7Y8FwpMCiPfqmr1xfadrGQwJZXlffD3Emqbz
	 G1EQzRFRzCcEYQs7W7BGXcNe8gd9qdqpvPcGZyGhJ5BCRLyhsWJfww7J4rnEEYB6Atm9+
	 qY0iRhmRoniDgUy2mwDEJegAZmsuhkkiJC14mzIrpaDK6G8oyjEi2xjLFI34RMXV86w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794182294;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=6HF7A2w5JZp9CiXgboau4SrAMUsc4/+KR7klwr6o1+E=;
	b=4di9SzaShA7jABO1b4HYG7stt3hXYk2x261h33DFW0pu2wF6FY2wm/6lpfLM/zIWSD9T
	 4xFff2wkkXOVPqoGxaLgx/XCD2cgaRxIVVjX4ZZx+oBrcWg4MTpj1pJkK4ULc2X0E5rgo
	 FkK7CSpqa9LVcNolq9Jp6+XsSziqwTdU01pirLNHplxKI3hiajA7X2eo01ptDfML5E+HJ
	 H7QVKSqj9QB27HLKKpR3eGuCoZhFWUAO3g9O4C5j18rKcq7rH3r0H1va2rVzjPZjx0HNA
	 IV4w6hp4ycLKAHNYixQlFU4Sc1YP4a/pG49O/VW9B/7nqWRPcQmecH9YZ4LNsdks1BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=wjt9oy4f;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Cncy2El6;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA45606A31C
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 23:58:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFA45606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=wjt9oy4f;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Cncy2El6
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E18427A007E
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 18:58:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sun, 08 Nov 2026 18:58:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794182292; x=
	1794268692; bh=6HF7A2w5JZp9CiXgboau4SrAMUsc4/+KR7klwr6o1+E=; b=w
	jt9oy4foZOv97TXMfH5t/f9dt5HibPWI2IcYVRGlO/AiDQGJFJeHD1+TsgjOKTp9
	ZevLPGHkmV4O/KRjHMT8fNjde/VBDFHCHsmIbx4G7+5a2fYZ/QUPA9iTlhoBmz0v
	MoHytlFZPl4nzWNasSKQpNIpHcY4DkQc0qfuaKj8Ooewh4aY9sXmpBQGJGsimvX/
	OUg7Ip9gsFrdtyruZ8W5qtLlA4Lo5nZ7vdonlv+Fv0URQJFWAtLNqGJ+Tbq7ieZV
	1qspDddLAlhjBGNzdWt3E94qovshI+oL5ptNVmJSwIjfryI9vuvh1itV6DGtCBmi
	pRj9l1T0kDWPx8yPYY1XA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794182292; x=1794268692; bh=6
	HF7A2w5JZp9CiXgboau4SrAMUsc4/+KR7klwr6o1+E=; b=Cncy2El6uOBeMd4U7
	aFc/jFWrGn60r29L1Eo2jUNDu3Ua+WtKOxns9tFB++yLEsrFo+/MUMjbE2PnzZ9l
	UC+ctkzTZknLH+a1SO80i3wxqbH20R5IqPJHoBitFwdd/zL+iZ2NRIzrD8mfFArp
	mfl+LS/OUiGyFMYM6P/XgKhZ9H/mRojPs8O0dcp4n0Gx2So4Cis8sZVuyV1kzsAR
	3syhfqn7HVwgGAlapO6ZpoZWPaZIlKUUS/OveqO/dyho0exFuBYSzhDdPtaK6vAw
	sZw6HXdrj2FDZJpZvC3l3Rc2jaF9cFH9lLejTPejDHqWSmYgLJ7lbHRleyVwI+40
	FUzkw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794182292; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:1nE7x4DWR1VTLl0XWkADLXewuVs3Uee6V5bnDbJVnXP1m9y
	KSidSPVbxYbfYJBFn05WR5OK81ZB8sGzvvvWpzG84iBV6KQnJSlDxJlL50AIFsie
	Gy341lxB/9zk2igcyHSZ61cpAMFVwcCKugB8bikvNTSNOnlBFGqOrjIRVZd5FzA6
	LIhIqlEH9iz5B2RHlBfmvP+eukmwwqQm264Qfi6m7LGpVcpDMgWj0Fhbxni89mOX
	5k7t3QRFcbsj0SPE4mMnxMDgO2ZnPMr1YvbsHxEhsdB+K5zz3IPckEES+rtvlBZR
	ahuqSHC2ydJFgg5YZs3dpYP2UaTveoOKYqsgUHA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:T7arZ3r6jExF1rOizc+AUn7aiNRo+aCADexJsy3PnPY=:6HF7A2w5JZp9CiXgboau4SrAMUsc4/+KR7klwr6o1+E=;
X-ME-Sender: <xms:lAzxalCObCPwm-RIwMTJqDugpTAKQhEswLQMbYPMUC2lnLt5EonS8g>
    <xme:lAzxalCidbSOrGnRVaUhBMEC8mnEx3tV5oIXDoaLkx38jCGCmE3Lnyt1zyIbk4as6
    6X0FHeTy3BJcawECRljulGqUfiFh7xlja2R5ivZcJd8tH8vPJbtFDs>
X-ME-Received: <xmr:lAzxagq5v7zZCkfXqqCTjQgdvLcgZjhvGbdM0ycB_n3bIChM-OjSRK0CSUWsNjfi>
X-ME-Proxy-Cause: dmFkZTG1tboIGfyRP83MqnDVBpyiQnXFYFjtglUn7niQiNXBCd/0FDvY7bOMyu7eyI+Fox
    3teq3wLO3BI5PkeK6FRUS5Iw34AiDcM4szV+TId30yEliSltD3Ad5mU4d++0M+h6O6VHSg
    FOzZScghTebcQZL4g5eUgARU5ISRvkx1t6R070O0bLglCJEIp/hJUXNiA1uu37s2whr30H
    zR3FRZTeFq+8s4Ex0j4m6xplIoCFKK9DSnbd2NVVxZ8RUwn37ZfxArhgZxUVSHJ47pYtwU
    mEtWVAlQ5ydEBRq5ri9CY3r1Glyg3GRI9ydN0yOKin2wHhoMbLchX1AxgSt+zl6MvqyldQ
    8a0euoj20TZd9Q7zw1lrCpz/lSSp/HSV5EfYt7PRaciYPrYi/2pcApIJbX8EHDKwrw+d5s
    3D+79p2gw/CpScKLIAkPmho3/URSi/6bl2l5NIbb+P0IxklZZOvp7LthRtDBLK9q8k5siW
    2YvZeeqRipuEaBIp9yc8VM0ncZAygl3UH3efTosb1TTh1fGgAhPn63ROYkcUEZTM22SVDW
    z6ukxQ4BHCOhPXRTTjWtpAxQK2Uiz/akjnmNFiNpMEZ5k39oZdjnBwWvzA22DdCF+HPcsz
    Ac4jMuJ8340tF3pZjkTn+E8BzRMF/KbkIvZeAmVjJ1duC1JKbpqL32tCiwFw
X-ME-Proxy: <xmx:lAzxavkeFePWAR1McwVnR-ZMiZ-FOs5LAgDEgZndhqyCb72EkCsBHg>
    <xmx:lAzxagwul3uJswRnS5T6RDO7uol_PMmCeZpnYYwtkvCIjA-U-PIipA>
    <xmx:lAzxan-kPkWMSPPAc9g4PN4-Zcu1F21WoyQZv_KsRvh-v2s_KMuSvw>
    <xmx:lAzxasJ-TdMEbTDSZTfcqUzATPZSF9WaKTFOeipW095uW7SdmR8VKQ>
    <xmx:lAzxatVlgRBMdBzFIbH1W61261YJT2MVd-V1XKyz2XZhtseFkPyMxOr->
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Nov 2026 18:58:11 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH] ksmbd: take credits lock for SMB1 negotiate accounting
Date: Sun,  8 Nov 2026 17:58:07 -0600
Message-ID: <20261108235807.1919994-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <oPhvAPE0sxlR5lgMX9hnaRTGnfk-M5xIdlUmNn35FwqbLJ9lx9Rn3gva5lYH0iR9rxit-qJXK4e3IXqlJGu0nAJ2rTD58d-aFphchKYXFhQ=@proton.me>
References: <oPhvAPE0sxlR5lgMX9hnaRTGnfk-M5xIdlUmNn35FwqbLJ9lx9Rn3gva5lYH0iR9rxit-qJXK4e3IXqlJGu0nAJ2rTD58d-aFphchKYXFhQ=@proton.me>
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

On Sun, 08 Nov 2026 22:34:09 +0000, Noah Weinberger wrote:
> The SMB1 multi-protocol negotiate path increments
> conn->outstanding_credits outside conn->credits_lock, while every other
> writer of that counter holds the lock.

I can confirm this. smb2_validate_credit_charge(),
smb2_set_rsp_credits() and the release on the send path all update
outstanding_credits under credits_lock. The increment in
ksmbd_verify_smb_message() is the only one outside it. The suggested
change moves it into the critical section that already follows it. The
increment is still returned by smb2_set_rsp_credits() as before.

I also tried to reproduce the issue, with and without the change. After
an SMB1 negotiate, an SMB2 session and a few requests, the counter is
back at 0. Two SMB1 negotiates sent in one write are answered one after
the other. An SMB1 negotiate on a connection that is already on SMB2 is
ignored. This matches your reasoning that the race cannot happen.

Thanks,
Ian
