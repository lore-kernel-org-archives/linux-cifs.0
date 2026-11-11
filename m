Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794413438;
	b=Wnm0p61GpsltHC9wNUOjPkhkUGDNA1NhKhy+4IE9BTdDeUuWQncSw5ypcO1+iQrBo++/
	 DcyYjNFkZqZvPskrfYG1fvJTroICZY5Jrd9QSO53VAFKbwWZ58nXZc+0PBp8GTfNgGIbu
	 +Pg08AksVPonaXyheF8jU26eo1O0jIgsn0mdicw+5r6awUzBeQ0GMPA4BGpec5G8ZqTn3
	 xTQseziFbXkku7u2qTBbmn2BOdmPgUis297/Jad+FTHIlVF2c/CzC2GOQClP4apj4lQTB
	 ++qFqjRoWzZTYadQUkVaToFiYvCOK+hgaLWw9aQnSO0yVrd5fljRb8nnqm5EV2hEaWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794413438;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=Uq7SAWfC40SPdH0tndk0XJhDRBsFA05lXparVsZ7Ty8=;
	b=F0tjViJ83KKrshZRkU2AF9auFrgyTDRLyDbtu9oG68W0QLHoiVg0EEpotUEOG3LeMSrG
	 4spMUHLqMAju+2kehbqcpNVtSZR/FsKS8XzpL7tcvMHKHgmSuQFBlkLSbyUNZRSKAsAOF
	 P07NlQlTxpE9fWnzD+6RNxj5J+PcQkXSDRgvYBot8CZwd3tM+4KzIRU8cakAyeB+cYUr4
	 kti5Bt3IlFvQl2SsrkaPPTGTxLoT2OqgvMt22VTOWVBKc8za3MMGj8U1U2i+i4HGGesil
	 aVtabvtlZAmGfnCLPXr9e9Fg+FUxPvAZyC+bCPKC5C+aAkW3SmNKQuJ6jWYzdjtLNlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=LWB9BK1a;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=EkblR73Q;
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B478606A324
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 16:10:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B478606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=LWB9BK1a;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=EkblR73Q
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 3CE47EC066E
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 11:10:37 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 11 Nov 2026 11:10:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794413436; x=
	1794499836; bh=Uq7SAWfC40SPdH0tndk0XJhDRBsFA05lXparVsZ7Ty8=; b=L
	WB9BK1ax4wfjtsvmqbcZKT1CC0g3HvYjfAYPI4k54Cn4t4pYbKXzC6QQe6Zt/9tZ
	ogVQGE75SesYgwFNVetfhcK020oaN/qE/G34HdbTP7i3HgF/mJX36x88Wp0VINVX
	7U7BwBgg6+tfJQXaYk5NRzGTgdKFQiLu6/JPPhNGNByHh/idqw9qHEsYW6gzMSRm
	NBiKPOmsqBJ4mor+vpZfZ3dq4RNbJ/n8+GSOleO8JF7Pb+cOcprIzE6ufNO8N2MH
	6K7sonqxYn9i0RpGVLI7Og88FeYZ+wiepbF1Q5W460JV0jIxlMIp7elUdxSHyFGu
	cYqjy88GA0P3hSOjhCPRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794413436; x=1794499836; bh=U
	q7SAWfC40SPdH0tndk0XJhDRBsFA05lXparVsZ7Ty8=; b=EkblR73QhVsYDKCaU
	8GWvHlgtVtJMV3wNQnYQYcrJMMjGbIbS8h+eAyKO2afAsqkycbiYf/PeU56Y1lxG
	coepsyyKb/rdjWazi4LL+uqfHiHQd/BPq1ESjFCnOIUF3mRg1CEXJvFzOpR/x6Kl
	fDLkuRde65nDAqg+/xe/ZiFyfilwylmEk1wxcGCH+NtVaDd2wPuHC08cg8i+xhpy
	6Zmf/+9pShOkstC6wppbOaXq0IzOugQnBt/WSuw/ZLJtu7eXcNTHxmYMXjOXwUTZ
	T9azUDLB/sWSm7iG4m94WMfGwCZ4aifncDtv9/qh8hW+VnqM0ORUboV8aPoOfYU6
	QDj7w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794413436; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:IljpdiT8P66sgh8QuY03JmaO7/kW3ED9MuMUxJ0Ct+GuWta
	aK61FzBRn12EWy9Dg2YzYpPIG1EZnct5R6I0Qj3X7JN2ksavj8mJZp4NFbWmxnUe
	0WFJQC0M5nw1JqF+5/WQojXrAjagZSlFQ9Tje7i3g655sbkL1tg2jQmR6LJRal1j
	LULpN08RryfrcUqVUwnxQYwYUSniXbc4AikGROhWqEDy3u/EF311UaZa3YQEds1Y
	+neOj+kfe6qXLJhiESmOdS3x2CpknfPkcw2re3t+4EpkDiK02JlU1mcW0uL8CObw
	4HqN14GwVUgM8C7tS6YgpO1kuXltbGzl56F66Wg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:mJgToMQj3UVdzf4WOyKY91r/yHCkIH8/h+TooU7quKg=:53TFk04Yc9rvZUNv7nt8CxhI7DWNLllMy0Brtg/yPus=;
X-ME-Sender: <xms:fJP0aiBKHyOpzgiRVGQtZwAFBFPgpLXLBCGgOpEoMqbHWbuN8F9lDg>
    <xme:fJP0aijHbf-JIlIxtgIkhQaPRDynoEskHlzjXsabpXYFx3GPz3NHcsS8NsD3lVAzK
    rnUEDu7AfBj64Bn71_iwgMg_HxNu2m69yAoJYDBGUgqImehkmmvsWFylw>
X-ME-Received: <xmr:fJP0agYlTD-2YyxcYLgknkZffhKTfO723z2gHU7Q9-XFyTQ9O2p-PsA8z0HiTQ0z>
X-ME-Proxy-Cause: dmFkZTFh6uuZJisOPSkiBRmlP3c7Xf1zTKcKKUCvf24GxmCEwWyBzY/I1K82tFLPeGmxxT
    xG+pB+I0tJWavgH01uW9qnC/zq6yGMVBAKKqZCFocpPU3BJhRma7ck41UtZp2SpFJnOElW
    LRH8pqqlF3clj8ccod5i2sl3WTtPamT1wZaY0HKdNoiz2d6x5vfPAIn7P9NtQpsp9n0IgN
    aJN/Ow99o15SMzPKMjqkIzNyAya+QLRQVAEfXBLM1ij9IohlJMssGjwTDSfK0rVlBEuEfB
    gL2Hbaen1QpckbBbRByTwoe6S3ut3LNKY8FkEcjABo0YNpA+IK4EaAEWQvScJDe5k1PbIo
    aI0yZslM5jk4kPxwts6+o8i82eSOjS0No+cR7ufrb+54XLUznb4YCOGCcyne50jkzF6xC7
    KjfNXrxdYS3McLMAOp0FAPPmirZhhvTjfuuasA2xvtJUauDdiYN0ErhqF77rBOPWEa3g5l
    jQnBEU8beTHYzhEJDRwjjG+pnDtiGBoY+k98rMUGhlEqR2ki/smKgXDK20RIrZ8D8TSmlk
    jJ/buQLGnxKAsmsPRzHiGZOZ8orqFPM1baPGnv2+4ReeSt8k3blZCL/4lpLCWJub3pz+Ng
    3GYx6RRcMHkav1+wXzaEkXso88Hm94UkXb1P6fyrfgy0RsTEZWEDM8SPxgyA
X-ME-Proxy: <xmx:fJP0ajk4qXT95cwC37FKtTmrKD7fp2Ol6E51x42CGQdTcERGqalJ7A>
    <xmx:fJP0amjoloCyaISnS3HEEwYVCDTvls8bdJHDXUIVb22hel-MjInZfQ>
    <xmx:fJP0alTqZidY2oPr-Pm6QITojdNVI_HXH878uJMydZ-1t8vuDlPquA>
    <xmx:fJP0anaBFxL-QPLWCmf5wV4D7lhlJWkqPP5KFMewfVC2Zhv9TssOLg>
    <xmx:fJP0agLQMigu_DHqk36D9Nm-FfOItddtAbnUkbQ_mlVT6YnzS6xR_m4o>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 11:10:35 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: jan.koester@tuxist.de
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	brauner@kernel.org,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [RFC PATCH 5/6] ksmbd: show classic users as S-1-22-1-<uid> on every server
Date: Wed, 11 Nov 2026 10:10:29 -0600
Message-ID: <20261111161029.4128473-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <f30f64394434b17ac1347afb@groupi3>
References: <f30f64394434b17ac1347afb@groupi3>
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

Hi Jan,

On Tue, Nov 10, 2026 at 09:02:52AM +0000, Jan Koester wrote:
> +	else if (uid_is_legacy(uid))
> +		id_to_sid(from_kuid_munged(&init_user_ns, uid), SIDUNIX_USER, ssid);

smb_check_perm_dacl() seems to still build the caller's own SID in the
old form. For a user other than root, would an ACE that a client writes
for S-1-22-1-<uid> then match the user only through the token? If
ksmbd_user_set_token() builds no token, as when its allocation fails in
4/6, would a deny ACE on the user in the new form stop applying? With a
deny for S-1-22-1-<uid> followed by an allow for Everyone, the user
would then get the access the deny should refuse.

Thanks,
Ian
