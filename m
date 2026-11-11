Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794413291;
	b=HDZQbu5LAEXNeXs+idzr7WLCATlFWOWRSC6f5YVmZIl2HDm5QV6Wm9HMEGKMdPcXurpL
	 +Ao7h75pZ0yCiZpt0ayV/BPb5pGMz/hNSWbyFQpeldYkPVLThq02kUAAWzyqGS1Cciqh+
	 N/mmjik+bUWdpdM9U/jafC441N+uz5/+MyObW+Aa9P7lOVRzHGxTALfCK02uVY9t3s7ka
	 IvOJPDIDFcZ77Jt6a4l8j1VGciUpUACvjQ1CtLKKOHuQfdyqURgAegrr/Rp7IDC0beW3U
	 YHTasY+F3wyqn+AnXapCWuix//PFePTzIRT2bkrXwlaebpsUUECT+NZZRtL5Iy0542Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794413291;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=xNI7FhhWXJTVEfgFdiCjAwu1qJ5S7uLHPAT406qre8I=;
	b=Lp/LSX3uwkkCHnj+9xf63Y/2y/Hk4bhQWpyLEGeuwC456w/NxDb4kMBwXiQrnRnzzI2S
	 Rdq0d87Sp31y5lmv/kKo9zD3XUKP3II6ML7ALPu9jVY3k23plZqVV4mh3u/Xhajx40Ncf
	 HgD5WFHk/dwnWXJRziTJJH49Rg5M9WBRJJsKQkziwMCQYRwK3a7Xyc1xt0FLXNyZRHBbA
	 Jb5mOuOOe3b3tGw22YHIELXpTUivBPltZ/bVUEjs0g4TA96bScf3eKHWSajeD9ueNlHee
	 PSYjjzKkDMCc9/3IOd0XLZNefhR3vkQzMLY77Dduh9Mx0G0DFKf3cuZBmy7a6KkNyEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=h49wniB0;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=IFU7woW5;
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0956E606A32A
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 16:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0956E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=h49wniB0;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=IFU7woW5
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 3EA37EC0644
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 11:08:10 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 11 Nov 2026 11:08:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794413290; x=
	1794499690; bh=xNI7FhhWXJTVEfgFdiCjAwu1qJ5S7uLHPAT406qre8I=; b=h
	49wniB068XoKCYc16cwroR95107cIRIUqZArGJasPF8iCfif6ZrWhE6+n/8MQtNI
	WnEoF9SZE98wxsJORStlWBY+jXqsvavVfKm98js7heddFmR5coDb4km5lwAjdppQ
	Z+CiR6m3PUxB52b/itq0+H0QdG0n79KsL1E3R3Mi23aFK6uj6U46SZwVLU+g/idW
	NFkY2aPRX/DcdVOqiS45e9NWwV2jCDF9lGXDW0ip1bkqP1nPIkxM1p26GdeRgxlq
	YQCGppdAAaDd92Aw9aXYr0zCdmMVLuhqSPcPnyr+80CX9ncJXQd7b0QZ5T0KD8JT
	8Ybgn/KZOsEk/8ijMJkuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794413290; x=1794499690; bh=x
	NI7FhhWXJTVEfgFdiCjAwu1qJ5S7uLHPAT406qre8I=; b=IFU7woW5wrHXHZG6t
	AFBd4EO8pbxiv8ZpiZJl3EvLfPIjZRZuLwX3DxVVBYW1m4i29mWHCAz+xh6PAqdc
	qclQlYnC3xOhKsuaUtF09J4AWZgUBi8OdaDuMpmLyuQp7y0zosPdSHAF2z5v1gVU
	ZH6iAMe6pZ9oBBVNTabAykD03GwWXjgaOaEOHHNVNPUjSTFZWDNBZkqUjCyfxg4A
	ziapT0EZPQBYjcsRDLf1YDUjJu/Qx/Ih0X/fIB8b4J3zqL9u9IF2lOUMiJ80VyPr
	2BR+M2QT3NQKGvhdqm1lEftcjsqDt9m8W+0nEoeSGa7m61FfD1jBAMmVGJZyNdY9
	J10+g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794413290; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:X4oOQ0i+g0DeM6Y8H+lEynssOZtOL1ggTecnfEimyepngpy
	bKYYmx2GLs2ANXIr+8W6ZfDt7+Qws4Xwl9sQdeLfbZpS2HpphsmKR4iQ3/7QZcyM
	llqpEyRhTiBI1qzmL/lPUrTMAD07uk/ic++ey7tXSVQ0K0Pw4SZtsPgAPalY8JnH
	sJOn6BhTn8T3YClWpLDYo84kgm3829B+fDDjYl7gVmTLqSjwQkb7XsW4/LhRIKf3
	5FKWvgBu0sqQpbdQ1Ld6PWW3FE9L+DkADFuq+XyQh/nqFLEOwxuFVQbu+qizsjlQ
	tH76iMGZe8I/Un4SVPvCw/Jiob47xlPS/o6rQTw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:IrfuLGt7KRhZcItFVJOYu4jJrkvaWCkKSe7X6yBCEEI=:j3mfKCSAZysz8cOYO4xunMlz4f8Xoig17FxZxB7+pAQ=;
X-ME-Sender: <xms:6ZL0ary0rHHpQoM4cPwCYPEiNyO65BbgIZkXBV9349ApxK4THaxCfw>
    <xme:6ZL0apRTPA_GWoFNE2tksT8XUIrYt6FLi5-OCgvup5-W1T63p6PCTj1qTl1FDILLa
    9W8NhJLoxZPuZj6x28V8g57H1ZeOIbE2KLHUztdks4RpEIuTGKApxNi>
X-ME-Received: <xmr:6ZL0agL39qcEeSwgbzDAQ44KyR9Mnz73oE0padfW55j7E_wtELaAoYUDHjg49c-W>
X-ME-Proxy-Cause: dmFkZTEGiWpjkAqvpdpTZAueIN2nKSWOBCp/471wSdPjoZ6M4A7svfpQVH1R8hL0xV027/
    e/Kc7t5m5zPL0cbReHQKNc5TdJDTo0B9hXmMzycYcte96r8JDR2uPmZPqUWM0DzimKCgdm
    Js4TJUWLPj3WH9yiGOKX/Z1Ijz8WIQ05VA35XI6CHJrBzU7UWxlE6R9xvZ0B/cyNv7Xm3L
    5rKv8i28Vg4bQXfxrtySwyKEQjLwngDFIhc2+Q1N+AdzaJ/KasUAdq5US6/JhmoAqVXSW0
    54pZcTWvZ9LtMFIjdyMWDcT6HAVQSBA88K+xj9JEI1cA3aG9bWoe5ScMMuy4q18OWdN7tI
    bAd79twYMGOTX2E1qNkzINWfv0r6Z6XOhRmW7hTOQ/IhU+52ziBJE0ONQiT+L95WCFeEne
    4VigZaFsXqwpQZyRqzuSpi7MGKUuE/+I59r7EfS+86c9r6+PxkYwXnnDAL1ehVDi3TZ/Df
    n4lUsk+bZtNrg89Ea42L75BsP8lzCwkKX/c+EalxIeCzxQiVmV7MSuFidWX0+iYcS9zt5Z
    GuWXtgR+wr8vk1vIxwHui/eqD8QuN+9kdkKhBUe2kfngaf7H2iw4KiCLKOFYNgumrFh3De
    TYu3EBqN5BEC6lVykz6+9v+wOVJ7jet88Dxl46gZFIuF4XcA4z3skmGCv6Ug
X-ME-Proxy: <xmx:6ZL0aoUIXZqnGP3XzM7_cl2wOFH2u01Z3i8jyqT6upYAmRhsYFgipg>
    <xmx:6ZL0asTgWgkMOULmkRu1L1LAutocht9pR6-WEDi1eYbChGkeDRNtdQ>
    <xmx:6ZL0aoBRyjD1sr8U_rFkeRPleyGnAoCJ7PW1CF5ZU_GF9N1KbFTxqw>
    <xmx:6ZL0ajL3q6S2ZI26zS8UlkqCvAKbxtg2BExMzLZkR8d4gbA-66K3Xg>
    <xmx:6pL0an4d-6UGIVGINvBC8bnevHSc054WhOc-JtjyKMEXnY65LXE2iTGr>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 11:08:08 -0500 (EST)
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
Subject: Re: [RFC PATCH 4/6] ksmbd: map user and group ids to Windows SIDs through user space
Date: Wed, 11 Nov 2026 10:08:03 -0600
Message-ID: <20261111160803.4128207-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a1eda764f3c867c02a5a5ce0@groupi3>
References: <a1eda764f3c867c02a5a5ce0@groupi3>
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

On Tue, Nov 10, 2026 at 09:02:46AM +0000, Jan Koester wrote:
> + * one) and ksmbd's. Built at login; a
> + * mapping user space couldn't give then is missing for the session (its
> + * ACL entries don't match: access is denied, not granted).
[...]
> +	sids = kcalloc(max, sizeof(*sids), KSMBD_DEFAULT_GFP);
> +	if (!sids)
> +		return;
> +	if (!mapped_uid_sid(user->kuid, &sids[n]))
> +		n++;

If user space cannot answer at login (-EAGAIN), ksmbd_user_set_token()
seems to leave that domain SID out of the token. It builds no token at
all when the allocation fails. The comment says access is then denied.
That holds for an allow ACE on that SID, but wouldn't a deny ACE on it
stop applying? Take a DACL with a deny of WRITE_DATA for a mapped
group, followed by an allow of full access for Everyone. Would a member
whose group SID is missing get write access through the Everyone entry
for the whole session? Could -EAGAIN and allocation failures be
returned from the token build so the login fails, while -ENOENT, for an
account with no mapping, stays as it is?

Thanks,
Ian
