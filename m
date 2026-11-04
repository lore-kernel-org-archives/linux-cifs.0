Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754456;
	b=ywNxLl9shVAdkOnyL1gSh9doNDUmxuzeB14++yTYvXZcXzAvpbjL0pT1QXgjyvtC2s6h
	 JOTxLsxMQt7SKOVK6N7PT2WVU+p0C3UjcVLlCqCL2odQO09xD4yEIuVxfGK4XZHu8lbE6
	 TkQ1RVxrLDwMZftKzYYOodwrW7GZsw9NU3gFi4lLj9wsa1l+1rvQ3Q8Beg6G1JzleAw4i
	 lz9d8T70KADR3e2/AhJSsRH7AArOUeiSzBLS80GdG5zvEF5evLLT90dbIJ4CV/hZTVBUg
	 VeVYGVSO2WZgjxiifxrKREBAd2AuYDE6pXkd/S/D38ocKZ66It3DD+M7pKFemZYVwYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754456;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zGCh1OkGoBoXZ21/5FTokci4OtmlG8hpLkF/qEQ8aFY=;
	b=ZresrUkb4z9i0pEoPdJzx7lT322F0dFU7ZXxzVv+5SFFEk6MrDAYNL/E1hTa2h0fTByI
	 0XckWSeK9rJPrXxBggeqBMiKh/v+NZ8jVoW2vu8enMO7qwKpOx99dVlwV2sfOK4cDLGMk
	 cwuzkXr2q7QH38PxjS+hwDHt/6XMFGo8OamuC+6Yr2PXLuQ0XNdhSIBdksVcDzKBZ4hD7
	 mgFxQefoh0h+ETUZM/RXPKmbbcwUBIQ+guEqaH0h2aePpLS3dekoQwtFcDa8QyYLuk6e8
	 dB5aW0f9DiPda70ZW5MQyg2MNA9saP0hvIi+ZUaGPZGLqhhwnDVKb2moP1FdNAYdAig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ytzJhIEk;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=K58GHiSC;
	arc=none smtp.remote-ip=202.12.124.158
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D2D606A326
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 01:07:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01D2D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ytzJhIEk;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=K58GHiSC
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 41F627A01C0
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 20:07:35 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Tue, 03 Nov 2026 20:07:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1793754454; x=1793840854; bh=zGCh1OkGoBoXZ21/5FTok
	ci4OtmlG8hpLkF/qEQ8aFY=; b=ytzJhIEkb7IrUnDYA26TvbS2kXxFP7YbPJyq2
	sAAcEZzi6GOcHg9s6jhLLcgh2Znbziw7dUVa7oV3i45/PZyxDs1SsA9WTZmRznB0
	8xen6HRXRs/vnL3yGoKK8jZk3EBwbdWtRKm3kZG1Y3+ajPycyUUCcI3nn3MjIyXT
	68cn4ZP+3kELriNxKD5elSi90sShvrP4rI8/FBUpJmSUbqvtKFbHQuVwhTFPeDSh
	jlbjKx7HpOwfSQVqHfKWFwga7ELFhfUG/ThChfJ/0VvTN3oY1xz32l6tnDqW5e+p
	YwqJxV5XfBQuj3ZyTb7Gze03hfXUc6fqo8P3YHsiuXF+SOZaQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793754454; x=1793840854; bh=zGCh1OkGoBoXZ21/5FTokci4OtmlG8hpLkF
	/qEQ8aFY=; b=K58GHiSCIK0vSi5PaCXKYbv2grVXFk4JqENfluoaR2G2OfCXd5C
	6d3hyueAZDUeE83dmki/GZJOFR3dZ1+D2rqFoN4WT2dJEmFQQaR/IY2SNAtkp0QU
	T2AqOJiqzDrG/1gmLff67r1lpRsADWt6DdRBCUIUfyShpmDOIX2XwQVVCjhRAv71
	Q5V6uEI0MUG0zePxQ0A3ejkcaDd5dPchZDKmdsfLoDBJjQrNNirFpaJ7o3caRDvi
	+iUUjYLrg84Fw9YGfx4+CmaZM8xZb+Z3iuZ8Y3odka7b/QP/pxmzJG1DME5RHQxc
	rDMXyJKQOZiO7wXbFogjccvS0UfKFUPAxvQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793754454; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:Bq4rrcKsrW+9VrbRa16/xYN1856WXgnnWbBJ18Gyuf6FnHx
	txEW5H4HKoSKW0+EIrjrvPU8SwBcV1VHrkK7+QFPBN/xWRH/FGCkAOQTcfKgLHuN
	pMnlClZXwTMhpzu2axcJd11vugPVEgq4dM6RNdUG1UKhzV4xuDUtDm2NpF2JuZSs
	8Ttdmdl6+YK6xuT6nIGoxrAqTrWjZGJ0l+e3fWaI/CHNQtS03yfHk9ge5yP5adDC
	5TptMqTXsTJXN/Is+EwdYdR3En0GsERYW6FQMJIJl1mp2WYKC7MIofzTIDBFv8DY
	xrd0sDcV3ccUwFBQgrKUhEtMe2GM8uEYC9L6y2Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:lXaadC0KDhRDjv4HTsi94SDbyf5VOzVJDkdqxfUYr08=:RpQm8F9CptO+tcgUt5aIxy4p0uOxK73ebC4rWzuOd3c=;
X-ME-Sender: <xms:VYXqasNSKSMj83JawXgmkG-6XYusHIs6sx4UNHiZg_cFRUfBHP5G5g>
    <xme:VYXqamqwKHbo4ZjHOpVUM9RCPimhcZ9mBYmiQH614_Yn7lnxNhfmHadCNtG-CFaud
    nxi40LiQnjdjy1WEl7G_RBY2r1hOXBZ0GPsXdTIOtBrlXqXMQkTSE0>
X-ME-Received: <xmr:VYXqatGzTbTHx38G9_IfeY-6Av6-DwsFtBQr7HjgNN689F_huW7J-q_6XqihB-9_>
X-ME-Proxy-Cause: dmFkZTFaKiZYrnak2mph4swdY3pQpp5F5edwV9Lzu1BmRVJKLmuFNzjAM7LXIVu33EYe+h
    qZiiasDQMnhtEMbdH+lgpTnye7ndiSXS59dPSYvkOYJ0Eoax+KQ+6jg8k9+7yJ3lczgppO
    SBXl1eSVBLiKfZ8Fv3iCRmVnGbrPf5cMXOHiqnEbZGaRM1EZstePtFIuVNhEaWFUmuOY0q
    pnCQFg3kniHfLw8+kN0JpBaaE28dXoYoGkjIYNK8usniOuBAwMbWyh+CKnmkLMMA3nWNwP
    jk9LLuVEFJiZ22vjzgaq3mUrHKeXHpfEeQIX5qgbvfYo6eQAr3kQ2VzlvrSEU+OZZSc8sB
    ziYT08sJ0FNxs/Bkr5EID4EFtrx12L+3KEr3hUibZ7xewpsGjRjb5WWH2iZaXV2i9g3OOH
    HPjUjQZ94GoOUm/3R4xbX681WaY+SxxSwikI0SHsGSujAlcARB2RQsQNV6OYHuhKIRnK4k
    4ZHx9ibVEblam4ZCPy+eQiMh4VSKGgAbUuzN5hR0md8oLie2N0mUtDyceVsQTy+xwCUrOT
    60rt/GhDIC+m2mYj0Wt8SYTKuzqCyTPZfjv84/99RTYfnhsOt7nOqhA7VVypf3ILoPcszu
    xaW0FjlzNW/zDsfo7aOZ0VZM4nVVGmgwLCIXk7IHlFzlRsi2NhEBIwwZfTZQ
X-ME-Proxy: <xmx:VYXqarrFPHuG4T-tUNJY7M5x68GetUzzUNwoHRf5509lg3zb_R6nZQ>
    <xmx:VYXqamYbcwz1uJK6fEwELEYlPdEj4OAmBD2zFoe2v1BSLtcS2kSDGA>
    <xmx:VYXqakVt2Px_EA9exJfDa8urw1S7XRbbCYDiBh5AKDpN_mr3OzdiXw>
    <xmx:VYXqav_69rnRUH6QX_CVE92vlmLpkRQM0RN8JOZhy4HKGhOe_Vt4Rg>
    <xmx:VoXqasrSKKDEKkJB3yYtr6w_fdQamhuQV3ZHvxJ4V3U--BiLRxpycGmV>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Nov 2026 20:07:33 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Ian Bridges <icb@fastmail.org>,
	linux-cifs@vger.kernel.org
Subject: ksmbd: refactor security descriptor handling?
Date: Tue,  3 Nov 2026 19:07:25 -0600
Message-ID: <20261104010725.50071-1-icb@fastmail.org>
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

Hi Namjae,

Would you be open to a refactor of the security descriptor (SD)
handling in fs/smb/server/smbacl.c?

Since February 2025 smbacl.c has taken 24 fixes for bounds checking,
sizing and SID validation, 20 of them this year. Several readers walk
the SD bytes independently, each with its own validation
(parse_sec_desc() and parse_dacl(), smb_inherit_dacl(),
smb_check_perm_dacl() and build_sec_desc()), and the QUERY_INFO reply
is sized by an estimate and then written ACE by ACE.

Roughly, the plan would be
 - One decoder, one encoder and one decoded type. The decoder checks
   the whole SD once and returns a structure that callers read and
   build from, without handling SD bytes themselves. The encoder
   computes the exact size first and bounds every write by it.
 - QUERY_INFO, SET_INFO and inheritance moved onto them one caller at
   a time. The access check stays as it is.
 - Current behaviour kept, apart from rejecting a malformed SD before
   it is stored or used. Everything stays inside fs/smb/server.

I would test it with KUnit tests next to the existing smbacl tests,
smbtorture's smb2.acls tests, and by comparing each converted path
against the unmodified module. I would also check the decoder and the
encoder with CBMC, a bounded model checker, for memory safety on every
SD up to a fixed size, and can share the harnesses.

If you are open to it, I would send a prototype as an RFC series. Is
anyone already working in this area, or is there anything you would
like done differently?

Thanks,
Ian
