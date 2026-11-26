Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795671332;
	b=JHj9NTCK35WYkexxK3Zo1NLBlHCk4Gnwi/QtXGY/rJ4ARzBnPFEH7SbOEtNp7+GawDxh
	 8E3ji+sTixK4Owhd8DUaqwTkxifvjl+CAg+q+opYrZ70Ho1XR/yzHjeNp7a8VbRyIgIZd
	 PaP0JYvGiHJbXfe8NiLpgM2zQTaAT/KzhhhspVMmS2RGxdTyezJzHQWQkaNJKsxAO1+v8
	 5qIBFROQrH2hn90ipH2wyOI08mfvAR55m7sI/H859To7Tp4xA/1aOAHGWrXWbF6saXwyW
	 BJ0LvA6fq7KRfvz9wN7VId/nznmLDT+LL4GazqcxSqInQfK6nC062jBexSp31nTTOOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795671332;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8DtGeYEGxxNLTH3hwKR8jYnbNmaE3iTZ8iDGiEPeGmg=;
	b=2EkFtHATG7p3RigC9HCVFtdI5YGKoRdxXxIXv6d5YRPc0Pe4XeQniF1bVllfF4HUEmUM
	 7MlaBc3lw0WcH9XtlMEfspUjgf/G6SJIEol9u/6HD6toIGwfczp7VoWlLaKHz5E5uc2s8
	 ufbyPfFINSkbmUF/TGxSk7H6IFVCgrVJEQkBUOp664XlVGkWKCBvwhq5b/5gOg1u0vyEh
	 0zicNYBP716tIk81OlwMVoyo9Uc1ChDE8bPFmGB8sVjlF94u+WWJYmoWVWe7Im73nDjJp
	 PlK7RI4bt0V+MHKT1dNhXzn8sZsIb06C1dnZOeiXmEgzwJkzTcx+ovcVIZTmqY1h7JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=D4eIGbZw;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=HKie2Gec;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B65606A321
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 05:35:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60B65606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=D4eIGbZw;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=HKie2Gec
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id BA36B1D0058F
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 00:35:30 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 26 Nov 2026 00:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795671329; x=1795757729; bh=8DtGeYEGxxNLTH3hwKR8j
	YnbNmaE3iTZ8iDGiEPeGmg=; b=D4eIGbZwF8LrCWjqXd/dxhXzs6sDFtQXX1sLl
	tfqGkxf2zvNJjzWLdxvAWZZzstlvaj58KTxzGRiWwPtnAHQKMcjKqttqmbyNGAOe
	HC3o7xMSqf7yRgFh/+hyAhxM3H8Sg1i6QiwczwblpvlUPaIyncsI/GoW+tp/s35q
	Frv1FHhTaNOY32GuOBU4qlFreNYl1vg54ur5rxcBttERP0yJCWETrG1ehUZXf0qu
	2VR+HG5Q1PYobvbXVsdGqEVyvIRLAJ3QH2p9rts8VX2gIQnrhgPL5VWuLXdlqSR0
	/r+BUZXKyVQ5KiNtZzkNm8hY0iJcu9RJ02akiVzIsjhr4YMvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795671329; x=1795757729; bh=8DtGeYEGxxNLTH3hwKR8jYnbNmaE3iTZ8iD
	GiEPeGmg=; b=HKie2Gec59lxWskSMKm9VklaVqTNHpOBCnBE4gwz+w2qMrbgQrc
	oMW2ACvBobVaakvbt4zkBcawqKAAiitgVKLWhiEntgugj2+98L5Kp4kA5EeXKY7L
	sWDGK+wvfInw4/2mZoJZS43gKu1U6x22QCrtncRNYWmwi7SqCG6QVTKbeb9l6dux
	vMOZrnAPBpeMorb3w3ybfRT60GbKf0D+EgIiiEKV9mDkg4Kd9oT7y3R79Pu1XC3P
	lRCK+vw4cH6yvipO6iI1lfUibO5H41QYUtnKP2tz2TLrcO9gwNFIgEfqgHozKGmy
	dmELtbI+1qbsQRAM9JUglzBB85CpyuOg0fw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795671329; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:1enopMaSpgR1wdbI4/fj4pyYfn6G217s1sVhkPmwnJo9HfK
	tszyOmj5oden9hvd3dv+khyYYQIUoX3qj4BV9YaDhGDq+AcSg1pRkOHKZo2ctCaA
	JrJAp0Gssqi+AuzLhXvnCSQqpH0YqprTiPgc3rgr/FNOrKKUAuF1TtuFpXj/94BZ
	WmTvsfxbSs/0Vby9DDGVgess3N94EusAuurR4t9fJXflQ4flHPz6QfLG9PavR/1m
	gaT7Bgr+9GX8lxCNaQ2e6JTZ7DM1fyew56SlEc3umQ+dKt0Zj7suo+MbD7uw3lSD
	NOtybt+XKaC1+Qh7YgZDDryKKARolPTUzzXAZwQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:1GGQGXL8K2jxhwJXwPusQa4TFcCITwLYnsMZ/mg7xyI=:jR9Ird6VfDE1ztR0/OAKEC+sWbySvUM5gFj8Q2LcvsI=;
X-ME-Sender: <xms:IcUHa-yDiMX0cxBbEx5C5a5qGdza6ICESrXy5qRzleqatAYEMzqa7w>
    <xme:IcUHa990p_7C6w6vd9UK9N3pi_uP_gQGTUfvdue0RHmVFO40QzrxKr-Q5N6WeWLBk
    B0uBI6k68ynmUA-O62s-UzaZKFL9iIJnSieTZ4nkQwarrUwm5h6ZtGW>
X-ME-Received: <xmr:IcUHa6J3pEhLC6mYXBzRgklQMkZhG25Up3EnVvAHP-CmJZhRHDFb4tL4dsD_2T0F>
X-ME-Proxy-Cause: dmFkZTEkwpsBnkFYpY/57pMEFp4Hj4JSMFkHCioM+lkshhvn4iL3b2VmK3DO5rk/tz/dLG
    tK3+ZLi4Y81nnKpooGIHCGZtK32FAnDMEH0WbYtB+6dA1hZlhF97koJSOI7f7VfaT/9y3K
    2K19IYI7QHHu0yQoL9DUU1e0KCh3bVkXPl5RhCXu3EMBh6ztyhFFD81HPLMHlmygERO/Nk
    vPfABmnLG2jnZu5RTh4VxLIkfoR+YqgNJsT8825dSmvm/2GB+mKM10m2OX1KbSjf1OqQ7Q
    c/ruqCmoBZufHGLivfBgqRjQe9ARaOgDBuOo7gQ1/pG/0dx4LcGbx500au2OVwqL39H5ko
    3aZUuhs771k19Fp6CWP7pC/lsWdoBGJ72KKhR+Q5omjmxP4H4uKVK9a9qO05j8LCPM4LKs
    LkjGnBaH56fpF7Iv4kTIs5Mq+Qmm5ZwcYuJvyAzwUQSKWJ/QF7MfsmzctYhgw9RK2+sO5j
    uQnlVUpBQm/XHH3Z5OXyFhv9LuA01g2GAmRw2Aqh2XDox5MPyMso0Hc/KM5LsfcVsG3KGJ
    pQci9BWhrnvY35BPLwktlTOX+4ZivyFf0mvnLoNfVODCIVupRk4O10J9uKj0tAT2HYI4RL
    RCOtC2wUuyxXK16mMpY205ZOIhzv2Qq8gDqbSzNKEv0Cfr7TEtw2T10cKYXw
X-ME-Proxy: <xmx:IcUHa7frx1qPZhZFsVJw8_M0ZhZMHQI_3dU4PRTgdEpYGpJZWxSvbA>
    <xmx:IcUHax-WD6rwsJEY4sRbagBobrDb-6__iaRZzrq1PKyfZZMqvUQDww>
    <xmx:IcUHawrkRj9pAoHcqfMXJ3KOs-_jPYMr7SiDF9_5xfDz2u_rqLPTCQ>
    <xmx:IcUHa-CKUJVkyAFBuAUfUOPwEaRsVFo0Zydj1nlm7mOXyr3ZYAFNdQ>
    <xmx:IcUHa_Ol8HcMyfa4NxpEGHeO5vA0-5OtyeJgQv1JQLftGoaOGSCbJQuE>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Nov 2026 00:35:28 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [RFC] ksmbd: rework the DACL access check?
Date: Wed, 25 Nov 2026 23:34:56 -0600
Message-ID: <20261126053456.1412092-1-icb@fastmail.org>
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

Now that the security descriptor codec (encoder/decoder) is in
ksmbd-for-next, I'd like to rework the DACL access check in
smb_check_perm_dacl().

Since April, 15 fixes have changed this function. Five dealt with
bounds checks that the codec now handles. Ten changed what the function
grants or denies. Some were about the DACL walk itself. Others were
about how the DACL and the POSIX permissions combine. ksmbd has no
single rule for that. smb_check_perm_dacl(), the inode_permission()
calls in smb2_open(), and ksmbd_vfs_query_maximal_access() each decide
a part of it.

I propose one access check for an existing file, built on one formula.

	granted = (DACL rights | parent rights) & POSIX rights

The DACL rights come from one ordered walk of the stored DACL. The walk
would use the uid and groups that ksmbd installs for the request and
would match SIDs exactly. A file without a current stored DACL gets
every DACL right, so the POSIX rights alone decide. The parent rights
are DELETE and FILE_READ_ATTRIBUTES from the parent directory, as
MS-FSA 2.1.5.1.2.1 describes. The POSIX rights are what the mode and
the POSIX ACL allow, checked once for all the rights a request needs.
WRITE_DAC and WRITE_OWNER need ownership of the file. A read-only
share removes the write rights from a MAXIMUM_ALLOWED open. An
unreadable DACL would still deny access.

An explicit open succeeds if the request is a subset of the result. A
MAXIMUM_ALLOWED open and the maximal access reply both get the result.
The app instance takeover and the hide unreadable listing would use
the same check. The series would also settle how delete-on-close opens,
overwrites, and the read-only attribute fit the same rule. The same rule
would also decide creating, renaming, and linking a file, where today
only the POSIX permissions of the target directory are checked.

Would you be open to an RFC series along those lines?

Thanks,
Ian
