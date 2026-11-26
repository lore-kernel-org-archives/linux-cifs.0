Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795651531;
	b=o/WUyu9amIyJ+7YPzmppmqrt8Qg2nmlQ/7BUOUSwdHbArAM9IgYzkJURMzqswtqEtuJe
	 RZ6WwM9CuVsZuEH6Nsd23MmWAePOTkoRI/Afnsszdv8hZm/OZIwwjy0xBINVER4E4khiX
	 +axtfw2nkTbRB6I0s9ftrDgJ4WajMzSWzYtFPUMGVAhcipyvFa2H/2oALB0BPmuQrXEqC
	 dHV4TU8kgp3OMk/PFB9I8bPNIBbWkXKkuxvuyOBSx0OntH9nnKJsJe3Dj9W8mY1x6B2W7
	 9zOhfJGftZDWss4dKx8fQiFzjgZUJFIBLORUwOxUSTdYa1QPrA7WSM6TEsje+Z2u4Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795651531;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=Nh3ILBsOsmhHNfSrgi6sf6h+ytCvNbNoinx9nXsS0CU=;
	b=YDG6LlG7HuPKuBX+5YvuUh3rO5pRoC6kyN/Go+1AvwFki9XCDCDANoXgMw7JWPjT/8Lh
	 LA11r9oggcuPxhS/FjlOS+EGBkUyNyLkw+TMmge9rQAdn8ixAHApsjQsyFSTQEsubD8kE
	 +SbnZ0LZ8K6jXMykqe+XGpqv+lQgK91vx68nx1HTCDi8X/Vm7KcC3NixocID3e4WsKgn0
	 vh8feF3KP7AH0jkuVQkVqmR4xNlySTc+JXjDlE49Jx36DuuqzLu60bGQt91PN4niN+89P
	 s4QQF2GO2s5IdMcqw7/Rm58QjsrEe2cL9bYvUZM3Wshq0uATDJO3+v14V4xcMo95/Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ro+2jJNH;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=jt2VlAe3;
	arc=none smtp.remote-ip=202.12.124.145
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B64606A326
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 00:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41B64606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ro+2jJNH;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=jt2VlAe3
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 9E6741D00540
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 19:05:29 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 25 Nov 2026 19:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795651528; x=
	1795737928; bh=Nh3ILBsOsmhHNfSrgi6sf6h+ytCvNbNoinx9nXsS0CU=; b=r
	o+2jJNH4cPCl+qtwtRaF09Xht/TiGeNxWcWUglj4h4K0VvzzHOnHaNeUX6o3dctW
	7hLb1GnSpxV+2YalDCdMk2t5mmbr2DVKf9Nu7HKqoj9j1FltYMiLb0SwviuAtRAF
	00gU+sAZZf/Q2Fnsv/jFAdUabP/XyH32aMNEyJoxiAv3ASyjU/QN6RqlGElGmatV
	vcnuczzgXCNdsbI4AWuLYcWd4xdQAgigpWSBqWvif9BowyXyMJTGOnm0QCrY8Bsg
	Ot1XW/XVeQef5en2YcJvN2M04rajhsNMR5T/hd0OHGiCmVYLpp6AK2sULKLfpbSW
	ygX3GD+BOH4HmDxy+P8Qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795651528; x=1795737928; bh=N
	h3ILBsOsmhHNfSrgi6sf6h+ytCvNbNoinx9nXsS0CU=; b=jt2VlAe31mfQBGMM1
	8DLhejUuzL6C7iUQS0DYKoOX+DUvs6EBgfXQMpRTtsjWYD3/xn6DspVwdFPNn/Q6
	/6PY5WmuNzzXGcMO1lRRodpsm4Lx+fzSXEoFWX5sm73Aq1uKEBNmqqUR2/PZMtO8
	kj158C7XMCPfHkYJ1lo0DGLFV79LYI7LPkXlVqiBQRg7scA1/Kl+QWHW8k0D3JPv
	OqaunZl4otjWTfh1P3gASkytwvRPUxh5jNdFhTGUdhy8dS9kHEizGmfCDyfaVkCq
	6G4cfoWuK/wza23YhKp6wAdjlWZFWd3xHwz5v4slIrgi4dEEhPXQYxWC0Kxigvcy
	7J7cQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795651528; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:O542NcEQA7MlQzvp+CbKuppdOv6M8zLLRH/kr6Z07/Xo8a/
	zCyUkHr1P1wM8D7gSsGOzczchlv+em/MXEnWzSMqK3J3TkyDoJ2P87iBNoJ1FOKz
	rsJZM+noim2L/aS3XlQHV0huhumFCNS/Cvz3izwcAiFWc3m9PjwcPITptXBHKg9w
	VQaExFuVfCOz+mBsV+sJs60dQzfJ4UWvD1Gh9RrIXVr97nnBuAYDB+PyPzWtjlNO
	HsMS7bYjFDQJBLC2aJFJD3iJPD3MOo7KBsHZuQZ9gE6VwI0ab23ePpjilz7UFRaI
	nLuA/WLJvDEzT+XBMEEzPjjPCQw93ipJmgK4T5Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:5IflrfKLDs4dVYOUkxHurj8gq5+IjXKcWvmUqxI5frQ=:qAidfylD8U2XumRSowIJxAxcvZCfpvaLWBIXT9ZN4uU=;
X-ME-Sender: <xms:yHcHayTrhr8ruhyvkxPuRYerW-wlBUN8DmPnWODDSf88h5NVCkLbpA>
    <xme:yHcHa7e3Vbh0FphUo51d64LfWip-8sBAbuxq56e4JrNB5NeswzM-3DDpf8Bxu6UkG
    05nMzZO9LNSZQcPdx5KqZu8PictE3EJGtPyMp1bAnYbC8t-bWRlTFx4>
X-ME-Received: <xmr:yHcHa5r9BNfp1MQQgkqBNK5B0S9LdlrZX4xsbk2C1Oj26Wei2wlq0s7EwSVYX2F9>
X-ME-Proxy-Cause: dmFkZTEZihnefkpBrIBTeuMKaIKlDLMoaXXrEgegYGz3Ngnih9gV/0f7gzSntzuVBT6lr8
    ks8fXkQcut9+g8sTvtcHVXW2oLk6UqN8VaCBW0IbEBO74WTie9ABq8xk+jM+MmJ6ru+xVy
    DkJWOfsCwNkHTAzaloV7C8GUJuuM3XpOp/pP/ifGax3OSYBNf6Xqw2qqA5wLSQG35BLETP
    yrVZM21L5byKMiclWgM1ehOUC+McSxMR1fqj61Y1B0t0fTvYwWql24HVvGRjaA4bcB32aH
    nN6CLOzPDn1I0xFuC5zJmz7lhE+HiQGxbdisvpcMUtbEDSAoSYpA+c3Dc/Y6VfYEo0jNKK
    leAAG6zmt0FaOL+AuIsAJmLVGtIC3fnBvCvFMRpj24jlgtt53e8QNP7lGYJvWC1TX8fcbJ
    rfMnTrnN16Wo5fm+1fzhFGo1M8rZAjHLujwR7+bmZfDFTu23IYrQzACvQjCBfFnTUW55OT
    vx1F0qJEdLzckyjz8L3w0DHQxF/SFVOiM4IOlT8AUfLYQVhA5okF2tvJC6knY1FS5OsG0Q
    RjFPmXHo4hxFRdv80Es8EW+9KpkIkVQPUE+3IvBs3m5QYSYqELYcQZdUyCL5mMsGIaj+14
    e+DYGdBXZpPLTZeDBXTbot3Mq6NxxdibBbdcNfeHfT5YQASrA5xOuJcrgbqw
X-ME-Proxy: <xmx:yHcHa0_G3UIIJyE-6MtMQrO24ivnlCjHjQHqMRg-_N6_OtZoVZsh3A>
    <xmx:yHcHa9c44nFIxHk_6ch8UvGXufcczzK0sO3jbP5RNY-hYlYPNBkyww>
    <xmx:yHcHa2J8xyOXOqmxhOoheJCDYxUTYtkV4gLXxb4bzS3cm5oaYRD72Q>
    <xmx:yHcHa1h4ECpfVS_XIV-U6Z9v5_U0Z3jtrVXYnhcD5n817Sq9JkCNbA>
    <xmx:yHcHayv9cmBzm83oAjPM7xg3XcMZJ9el5fO5iBQJhoaQP8r1FOzeNOA2>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 19:05:28 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 2/4] ksmbd: replace only the CREATOR SIDs in inheritance
Date: Wed, 25 Nov 2026 18:04:58 -0600
Message-ID: <20261126000500.1375459-3-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126000500.1375459-1-icb@fastmail.org>
References: <20261126000500.1375459-1-icb@fastmail.org>
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

smb_inherit_dacl() replaces CREATOR OWNER (S-1-3-0) and CREATOR GROUP
(S-1-3-1) in an inherited ACE. It puts in the SID of the user who
creates the file and the SID of that user's group. It finds the two
CREATOR SIDs with compare_sids(), which compares only the
sub-authorities that both SIDs have. So an ACE for a longer SID, such
as S-1-3-0-9, is replaced as well.

Use smb_sid_equal() instead, which also compares the number of
sub-authorities. Only CREATOR OWNER and CREATOR GROUP are replaced. An
ACE for any other SID is inherited with its SID.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 8d2e4c3ff35b..fabe01a54998 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1008,11 +1008,11 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 			flags = 0;
 		}
 
-		if (!compare_sids(&creator_owner, parent_aces->sid)) {
+		if (smb_sid_equal(&creator_owner, parent_aces->sid)) {
 			creator = &creator_owner;
 			id_to_sid(uid, SIDOWNER, &owner_sid);
 			psid = &owner_sid;
-		} else if (!compare_sids(&creator_group, parent_aces->sid)) {
+		} else if (smb_sid_equal(&creator_group, parent_aces->sid)) {
 			creator = &creator_group;
 			id_to_sid(gid, SIDUNIX_GROUP, &group_sid);
 			psid = &group_sid;
-- 
2.47.3

