Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794278036;
	b=aai1N9R+jXOebyIpAgSAa0sCEKkOvfWbc+G5BE5lhLWElWlw3YqAEE8/X6a68XIpbOAl
	 3RnqAVLtrmqYlFf1NfVeN7e5luW/p3MzMWKX6mS6zdlf1+Q60JDK+9A2Vnwdz/OFX6BJw
	 3zCtJTvLcaalplR/zY3y6LVMgq1Xv5bkL43iaJyhCkBPLVhxtfOzg9kn3jjPn7Rc3Qpdc
	 9aUHf5BPtdGdbLGLhBYbGN+MU/g8uDGH4C8PuCgdDZOZAzhMYrjGS8Uz/1v91ddrKLNyw
	 ByyUQQWI1c1Wy7zMEUWTivB4440sL0VZfsV1rsj7sH6ZQQD7YHOiuEIhQ2ERrBT8ecw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794278036;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=g1VIsYyLXpbp2selItXnLHOrtqqaZK6VFKqYqk+/4fE=;
	b=VIyE+DVmRGYwVi/ZD99SQh5aRvk6lOypar3lCcrIFtcy1N/hvlrgj1v5LvanleflirsM
	 mgb+T1iYyHCnJ/CD2tnHt8/6qFHp80C4NAytI0gp0Dj3B3xlvlCGWFA71Dj9jajChKt6P
	 RY7KUKjT5sWhvLO5Xjyc2ITuS2esb1kgsVL3Lyb3rZRvTYL5l8YG0dQ4G4hAHA9qM+6Xq
	 E6X6uPLsGF0uJ6+vkdibgN0v2KsZYlU6BAzf/rkjltLS44GpYnapBw8hQmIJKCBQya4/V
	 45DuY0Tsxbptar5IMWydOFRbZhMMNoaqskSo1K68OG4jD/bIusMMNSpEa9bAZRiKYbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=bXj8nXao;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=jMVi2CE1;
	arc=none smtp.remote-ip=103.168.172.144
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA1D606A321
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 02:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FA1D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=bXj8nXao;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=jMVi2CE1
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 96AE5EC04D1
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 21:33:54 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 09 Nov 2026 21:33:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794278034; x=1794364434; bh=g1VIsYyLXpbp2selItXnL
	HOrtqqaZK6VFKqYqk+/4fE=; b=bXj8nXaohzoFelziePzf868blggMXjkn3fFaB
	TWioAAfimNfjcAImsdDK04HlGQOUUqj6nc2pL4ziDM4HbyVZ6VEw4LjT8AHhmFfz
	bystM9WZ9Zu/Etdn11YBPp8ypipJ6z18GRr+r8oSU2Xaus10ghsvN2bFgdcsAp2t
	x1agSYOdu453w5//r/TSYD7dGcZ+onFw/MD7Anm2y2NSCGPik5CtWY3AfbV17Tbr
	3PSZERX4YZIdTiiTvd1UDjBRniaWT1AKapfp5H1oyNAIzf0+waArqmCbO0OHH03D
	Em7v7vj7L8W/HwKeCmAywUhYsA1Dp53Z9xiQSPcOV+/DN+uHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794278034; x=1794364434; bh=g1VIsYyLXpbp2selItXnLHOrtqqaZK6VFKq
	Yqk+/4fE=; b=jMVi2CE1TxaDXYqFBo4/thZmhetcJD7HexhKqPekN9byw2tUjfV
	qJ3StqdgeK/giP/DfQ6b9A9QW6T2yAZCgihAZi32E99aaWH5ilIlGaAJeY8MS+lC
	AR/9Aim2nFLZn3Roezx+aS5P5//u1XPXQkpAtLhZAm7LkuP1bphnPisNSm4NzZ5O
	9J1cqSAFitBvRpXZh4V/Kn1dOJkurPgNwEUCrHf16LbM/e7guoi5KFmn9+qMZEfI
	k1qcwcelJWZ2gxmGEbZmNwAHex8hXw7AN+xd5tJhx2v1vx1cg9VW5ZbQcZL0ESvO
	ftUf5T24PNX3sZYtXDBDph3XxsKhqtzzS/A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794278034; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:Myu3xlmxH33MS7pxBoSPRDbP5BgFMEN+3tDBB7X0iLNk95H
	5z2QijsPpooQT38Jj8gfqgQkfyFVgn8a1BvN1XGYdEE6rA9FXBp1SUL+7g6Mk6dW
	pbnKqCdhCo/T838H/9lEvnW9eH9oq3SEl1hLbzdRDm0fii2Pw3M4ha4KhA4bVeyq
	GZzQ3s5xHgofpCMgd2iDe1wPyICLCOuP2qkDNxqki1H4vKYYX4JXE+nrf5Bdn7CZ
	c5BcO/RUrszpEdi2A+p3vrw3yu2QGIPQVz2Ea4vC2Qcxv9rP8s2bMk+D+0ZTGSu3
	eG5QrgO0bzpzSEi51k3o8q0+wyyCMqY5BpfWrMg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:kMWAz0Y7LcfoM4kZwhM6zeRlTGJLvTg9J/ndnRR9zuM=:sG0Hqyd7/PCaADqMeTD+NKc9g3wk445JcBSTksY5AEg=;
X-ME-Sender: <xms:kYLyak2SpphrsDGHgHi_zG1synKO2rSTajgKkWNXosZo59WkX7Nc7g>
    <xme:kYLyavgu-1y2yuLOIUa1a9pWNhi019eU5WZNVM-8fYJfwGYbTPGebciNfxlq9BXyR
    4Uw1yjBaA2kS3coQKZUkkiNKgnLGtGE8frMd2XCFGiQHSizioYKF-LG>
X-ME-Received: <xmr:kYLyatnLzGjdqQ_B26sgqUfJlzC7QUOd_8gbby5l4UVyU2uMLItjbpVjXvQ6odtV>
X-ME-Proxy-Cause: dmFkZTEaFI12Qo/RXtAOqBnkLtQHGnHF3OoWfQsLrjLl2B3nKseZbWYD1SlSSdLYdT6M+o
    e8hnVKv2IA1quSLS0a1l1PpLXpODgHN4VcCJ9WoTKIq1WjgSRLm3GowCs7pYS30cp7MtUe
    BYEHO17M2s0d+tj+GXIFjnmffkE7+g8EC3xvIigL/ydpa46T3Y+FPXzcsDAMlKkceYMykW
    WWBFDuqK9pWlFelMeEvubbZ/9UgUxuDOVxrz3Ouni6rwUDOXHG7Dph3x9nLByj6FzCFCFn
    Mvtx0HfMKKHE0uGqNXN01wCzdGg3kR+xZsb9M5+AdOuipFxxcUyRaFs9FQkLV/6aojAnqn
    456z3MHg4CaXnU8SMVPMr3/Ez3Sc3sRRTiqQKC0yFdJSfjJkPMUASqwGVIcnePTq0OdoUL
    M08KGvbdOblfzU8m8EwCwhA0SD7Xh1cb5ImOXxt7UVHAbgR9f30ADUztiq5X8wKVx/3DMa
    erTmuZKKwjf0bbIC1VUxc/FT6kboeMDq0Qi2hOujQMmq/jMEQ81hNVOQcF8cUQR3qI70yQ
    SGqIgf42tR1BGi2kuXwjuEhHO4icLs+1G+CknaoHOr3hWkpQhZDrWU/x+R0YJK41k035xh
    +Q2H+v7WKdhly0GyVOl//KZzv7MewIXA69+RCKROK/chCsBb0bWy2P3QsL0w
X-ME-Proxy: <xmx:kYLyalaoLzDAlroJXNqKbMXziVTww2WGupcqne2RtUJqqxCy6ZVdxQ>
    <xmx:kYLyaoEpdow6vX0TeSPPwSeZCQx_kIBA82t6s70WmYf0k5BmL16SkA>
    <xmx:kYLyakaT-kjGqL77QE9BH7mf5UIHmLdjczuC1QZdQWxrRJY0qr3yAw>
    <xmx:kYLyasxwpwcSTV8QzA3TB8RJzkD4w4Iwx37ATu_wMBmnZJkGmYaejg>
    <xmx:koLyatMymf-G8UNhPl_lVw5h1N8FX9hPa-yDvwK4PlXDLjK1azMGv6fd>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 21:33:52 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: keep group denials when a POSIX ACL entry decides access
Date: Mon,  9 Nov 2026 20:33:44 -0600
Message-ID: <20261110023344.2105916-1-icb@fastmail.org>
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

When no ACE names the caller, Everyone or Authenticated Users,
smb_check_perm_dacl() lets a POSIX ACL entry for the caller decide
access. The entry's rights replace the result of the DACL walk. Deny
ACEs for the caller's groups, and OWNER RIGHTS for the owner, are then
lost.

For example, a deny of FILE_WRITE_DATA for one of the caller's groups
should refuse writes. A POSIX ACL entry that gives the caller write
access still lets the caller write.

Remove the requested rights that those ACEs deny from the entry's
rights. The DACL walk already records them in grp_denied.

Fixes: 42ac1f1917ae ("ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261102200353.884509-1-icb%40fastmail.org
Link: https://sashiko.dev/#/patchset/20261103150458.11591-1-icb%40fastmail.org
Link: https://sashiko.dev/#/patchset/20261107062233.1579198-1-icb%40fastmail.org?part=1
Link: https://sashiko.dev/#/patchset/20261107231941.1824289-1-icb%40fastmail.org?part=1
Link: https://sashiko.dev/#/patchset/20261108182011.1888520-1-icb%40fastmail.org?part=1
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    A POSIX ACL entry that decides can still drop rights that ACEs for
    the caller's groups grant. The implicit allowances that every
    non-strict check adds are also unchanged.
    
    For MAXIMUM_ALLOWED, only the rights named in the request are
    checked against these denials. Group deny ACEs still do not limit
    the rights that MAXIMUM_ALLOWED adds, as on the other paths of this
    check.
    
    Tested with KASAN on ksmbd-for-next 4ab80fd4d1f1, and over SMB on a
    kernel whose fs/smb/server tree is identical to it. smbtorture
    results are unchanged.
    
    This patch was developed with LLM assistance.

 fs/smb/server/smbacl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 1b387c262d59..45f70a05e21f 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1764,6 +1764,15 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 					if (!access_bits)
 						access_bits =
 							SET_MINIMUM_RIGHTS;
+					/*
+					 * Only ACEs for the caller's groups,
+					 * or OWNER RIGHTS for the owner, apply
+					 * here. The POSIX ACL entry does not
+					 * grant an explicitly requested right
+					 * that they deny first in DACL order.
+					 */
+					access_bits &= ~(grp_denied &
+							 requested);
 					posix_acl_release(posix_acls);
 					goto check_access_bits;
 				}

base-commit: 4ab80fd4d1f1c4363b336ddb3d8818ea37c4997d
-- 
2.47.3

