Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817435;
	b=nypthiI995JMwsXuMaMyre3vCdpW74Ft7947G/Ys8n5Wj5lg0rtEphuo74a1ZLWkQIkd
	 TsOOzFp5gvbatTq7wYhuE5ysd6kVHzLXUZKLM3efDDrHwWHbBWy1XwvtTQ3NPe1uJV30R
	 wmyxJbRJTRgD9f4wW7yLuRN0p+X81YHzSg+Zybzb434Bd9KPYt9fQc8KKQ0RCiQRFwM57
	 xeQy48gdQ/R+PlREc+nMtrmTdrzvaetenHjl0S6exourJFole3wXlxdF3skHhTJyStWRV
	 8AJFdCfy5NOlwcLmolw8rLf1RS1riej752XM4ANBt1iAPUq371X6vgbtCxEDV82MBDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817435;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kR9ds4gxs4QnnZayu61PX4mlUkEOr8LJPJJPb9FCbn4=;
	b=GNgMrPX8Z6HtRFLMQ0KuYMBIf0UPJ1ecTx7FLAL6X60PpD3zLPhdEcHmdUCcDuslfjoo
	 wSEqFn9KJQ65Um4Sg5kA/qAWJL5kiNgLOKHjNrp9Ny0gYlK04w14j93EaleBbejcSRq0i
	 ulNvFojFHSC3d0COa/KuyEfCgj0sLgY2CkCHKyw1YcU3Zh3JUj0FdPakNljUWgUMExO68
	 qgUBY8Y/NZDw5ycYxOsfNYTyxTNaACV4WIyIesviKyTMyBndkgY59F2e4fEGVgUEbzXLj
	 O/x8E+RHKW2XwXxmHprztrzCln0OUzSCvXVvER0ToOfVQWIn6MOvV3YJ4nnrloWWXBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=l4zcL94t;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="D+dpq5/+";
	arc=none smtp.remote-ip=103.168.172.144
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F8B606A31B
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 18:37:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11F8B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=l4zcL94t;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=D+dpq5/+
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 44E79EC2297
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 13:37:13 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 04 Nov 2026 13:37:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1793817433; x=1793903833; bh=kR9ds4gxs4QnnZayu61PX
	4mlUkEOr8LJPJJPb9FCbn4=; b=l4zcL94tPS/8L7LdHwUvFKRPdqpwnnTWXtk2O
	nN/hkgxANWclns9l5EKVshZ81npmrVlZ39YFDiqKQFRnk/jVvEcNoTib71uaN2Gz
	d3Jw5CuLehVS0INKXiadtjEfeu9mPA4JTAXnCuiysF7gfDqmw9C/v1/0woxDlSTZ
	Jen0BsXMaXpoRNgh6IVKJ7W8CCIjw1CQGUpSMaHODiX+fVXpzTUz/j+kXWMFf7H+
	iU/1HZiD7qzSspZqnFSkHzwGEK6OoaPt3MZV0SZGq+dspdZJq4OtwWH4gnmiaGNP
	/dYZYHF0uYQf/ZwzdRj4oNvpvbLK8WqKdUTX80QqwkofmWRlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793817433; x=1793903833; bh=kR9ds4gxs4QnnZayu61PX4mlUkEOr8LJPJJ
	Pb9FCbn4=; b=D+dpq5/+Dgks5PeBPUq4WV2ccxdXZUFwn+KDm3630r4dSden5Z+
	4wPu1NIvASMLOKX8KTzsNqlb02qyfT4O2eT7Z3iEBkgjkPdtNTcXSTiz9gw93XKG
	CiY55YtuBy8Pud3038nIgRbLapCWZLDOR5tiFuJiCCiN3jiXOYAtx6dzUI+BWo4o
	lIloYSQe+dqIAZVmlafwu7pa+XjBWNevzqnv42hRQsuukOlTkdJXfARu+W4I4xV0
	001fJ0eITbn7z4HzGzoX0D0/qUdCFUUz3PydKMIv6p3koKvXCr/8TMfw0S61nwsN
	9pA//oluRU9iig3I6lQCN0yrnyXxhCfbRXg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793817433; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:c4GyfIyzLl2Zy6vlslE2Q3a9dg3ML9ihjdrTz5GmABWrNoI
	eraKruv3JcYb8G/qap4pnURkn7vEKZG0e8qh4X62UqLA1HTOR4lilURsyUx1N619
	hfsDps5uqE8IfRFspk8xZUzaAMnfLRlMsNLKep90DALDBB/NvZEQvGV4FpUX4DMe
	kKQsPKYFnoTviY0Ejt8k2K69L+eyZyfqS2YJ4KManZmdqtpz5W5PxDKT0H/u0tw5
	NM/V3gY+wR6WStilRX9ykFYfnMRIv5wA8/GVETo6tziBNZywm3K2/ETvvJdLco7T
	L/fEhGkPCj0YBRtF953EZnDi0yDgpcVNvdoLw/g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:1sKIgHV4eSMTQk4r1axBRwl4+P4NfvxFGc/xm71r4rA=:TUGd7GPPqPNihiBFNeK3H6P0IKEdvfO//O9wkd5/uxg=;
X-ME-Sender: <xms:WHvrajglk9QzmY-wX3r6yrqT1lQcMKEfVD_PwF3SGUCeiafvefJnXA>
    <xme:WHvraguXZiS4N1zqGXClhDEK-ZslJxOiiMuUP3c_F3DBDbxoAeNeEyca3QMa7VEGJ
    zdoN_eSZ6R5EslCk4Y7GmnqCshBM-XPVl4GZH3zMcjvzAyBVLscRNvbig>
X-ME-Received: <xmr:WHvrahQGO7t3TPi7hOfZuI5WYwV6DNSkU2ra5w0F40rGlrLiyils0DidnCxqZA3y>
X-ME-Proxy-Cause: dmFkZTGs5LIRwT60gHzi1IkrnGEHtt/rx/Req0MY2hPerlEUBs/Vv+BGOPqdJKDiba94u5
    /OA/i0vMS/PlEyP3A9APv/ZWx5ADi/ZFkGMN3CzaiXEE+kJ1Kccy+YZAOmYB2ohAHo/AGD
    sZc52LhUI5A86RsCW7qsYQ9ryu9jFUmtsS3Fv7+ouM899vzK7u+c7QNaaHXy8U5KjXFCRn
    mlu1BJf7eCjAgMKcWbJ7uSdjW9RpI7ZKHymRxBpEcNx5wG1bcvk1ekRJy7tEbQtTCIIYa0
    Y1q1kPOqjmppCTfrBH++U2x1GQdmHRETl3ng9oTKdzGsYrQsyyXOiTrvEU6W5GWm93bFUv
    7tITs3jSXE42fB7yN2QgzksIk52iN8FbBD1e8PfBUvH3Dw/Q0mvKJT+I/KDSRil5yT/EcC
    qeFftyekaO3ipxjgPMnXiBQlvFwYQ3ADAu2eZr0EE6IwRUUKgKXdhLa0LlI11Saza1OCTU
    ejX1KUr3HvVP1Acte8glHPvuam2cejHrxdq+hqnWXCeL+nQLkRtBC/aMe/dAGgB4vZAVrO
    c7cyIU1X+R/tOEZdzZLwvE4Rk1MgouSkAK9x0WLfo65+h8BHdRw7BDuo0L51ZENGMiQ45e
    qB4udo7s0I6QBtHuG3/0w/kp9G+VDg2clx9GqslRQhz4mG5ch5blQtF0e3Tw
X-ME-Proxy: <xmx:WHvrak3uVAQSOxKXxCsht9dm__-WWJzvadYn3QZ6lkg3bkTsg43Rug>
    <xmx:WHvramsAGQ8-L2HeHqyAbfe84Wp2g307TYkeD5B6yZ85Wrtsinkyyg>
    <xmx:WHvraqhKEp-NoC6FXOJYmylG9lX3VF5VaPWhTfsegpxBIi3erZ2h2g>
    <xmx:WHvran93SUCw6Y3IBOcbYQVpZEND3mW8pCH-QOIx9_KV76YnezDg2Q>
    <xmx:WXvraqmeMLi9LPn20tVRnurf1dZxyeLg6SyjPM9XbX4Xkl3ReNmMpo_E>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 13:37:11 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 0/2] ksmbd: exclude metadata-only opens from sharing checks
Date: Wed,  4 Nov 2026 12:37:00 -0600
Message-ID: <20261104183702.192452-1-icb@fastmail.org>
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

A metadata-only open holds none of FILE_EXECUTE, FILE_READ_DATA,
FILE_WRITE_DATA, FILE_APPEND_DATA and DELETE. An open for READ_CONTROL
is one example. ksmbd still counts such opens in sharing checks. Held
without sharing, one blocks later reads, writes and deletes of the file.
Held on a stream without FILE_SHARE_DELETE, one blocks deleting the
file.

Patch 1 fixes the general sharing check. Patch 2 fixes the stream
delete check added in v7.2. They are split so that patch 1 can be
backported without the v7.2 stream helper.

This series was developed with LLM assistance.

Ian Bridges (2):
  ksmbd: skip metadata-only opens in sharing checks
  ksmbd: skip metadata-only stream opens in the delete check

 fs/smb/server/smb_common.c | 9 +++++++++
 fs/smb/server/smb_common.h | 4 ++++
 fs/smb/server/vfs_cache.c  | 7 ++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)


base-commit: e49296d51ccbf2ad0ed0484db1382f1d7217bd6e
-- 
2.47.3

