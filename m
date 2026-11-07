Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794093589;
	b=zsGWYzIhv+wfzMkol1+1g6e9R+yr3bljFDy5TQDK0lW0b1qSsulzWCHCd3NtnklJn9/P
	 WggL84mcgov9hFa2MjfBP9a8+4GZPrKNptAn+8wNcgzQ/VZMg99+8Gn1SRDN+k9eQhSuQ
	 ur9vSBBkNfd9eJrKAbvHhusHr7Mw+UVlEP/kR+r2ITucy0HEEVzAR6v9fK0R0EPKwa/hJ
	 sLrblRGIYPF5YYuYRAqKVwfwROrM0qDy14kWmAHJlLKYFefneXqGzJahcK1HVq0o8Hyvc
	 Vwgrh8Y5G5um/U027Q0n14qSKvx6yknK1NdeFhTNaHR14Ysk2dSgN+NPzJ9DYmg2IwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794093589;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NCDfDtJQ28tzIWj462jzqim2du8Tbjei+aJSZvgYHZc=;
	b=uoQQiiEtmxkR0poqC3dLU5mruCkckc5Mtlk1Zh8fYj2zbFnYfg9GnN7S7bIke+HlrKSs
	 Zi2xvQvk5Xq4WmBzOcLxDykHjk5iXvsHlqyK4SnsnHxbmEO5OwwIbqLa77lUtZhCqYGy8
	 3alR4pZlVWvxbgAJGMjrkIX4nkCE/zzlAyDODt45b7jeYDh6X5cAh8Kz59kIcaTE9upHt
	 pt7A7uKY0vE2b06dESHKmtyiwv0fRWHWlsBQULAgxh3a1d4ugA0c90WwE3jkMKOk6+dge
	 ekI92gz6yUSZOC1295tTCRVantATBx9DhG6CA4f3P3o9B65WOo1ejCoaBgtuwCCNZPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=EvCuYtgu;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=jOeAK6jX;
	arc=none smtp.remote-ip=103.168.172.152
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8281606A332
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 23:19:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8281606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=EvCuYtgu;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=jOeAK6jX
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D44D614000BB
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 18:19:46 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sat, 07 Nov 2026 18:19:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794093586; x=1794179986; bh=NCDfDtJQ28tzIWj462jzq
	im2du8Tbjei+aJSZvgYHZc=; b=EvCuYtgub1f8a3UA47390xqh7qQPiBdSUuV9m
	V0IEH8DMsmXOMLziFk5+a4opDNS8ZK1WOV11FQM7SnyHOPR+edd3fV3IYzlfxkn/
	WjJ7VscW/z+P+isMupaTYkv9LjlIaF4XzJ18kcKMn5yEAOsoENGOajQy/RHtIPeh
	sf2RBb9vy//7cBdlTlLsPo8a0fjlGiydqQ4IjUzn7+LJ2S9FBOyJgJPTwrze7yjp
	viWUQBniv/vAvls9lRM540ZAR9GY0Ofrt5v1fXkS0qTidDg4nXXYJ8y5x0KTCYT1
	wim/T8U0hAJjR63V0SpDg8vXPjXt0j03OPk3cfuTLsKmr50SA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794093586; x=1794179986; bh=NCDfDtJQ28tzIWj462jzqim2du8Tbjei+aJ
	SZvgYHZc=; b=jOeAK6jXbFfDMMtQqJ7dBIheOTFMd7U5IHyCqcVcfWhkz1sLTlX
	4ZIScxr8xX93regrq6pMruTJ4F1tewRaSE3cSzMA22KKAZGr3WvbOVERBUPU0BAm
	bll4lKRr8/SovmpJaEZr1JwcAjli1WPAd3Ksi4+/CjQNBTXSYALplXOHubcGj5ue
	bS9C7o4wclXoFOFXno9+FyIGHRkJqm5laeauJ/DA/zBYgbpUTilqVBHinOIFH7hj
	XfZRekuuTzQQ5UoJUQcutQH1ZAsNF/7zB8axLLkU/RhSalytjtEi4RMHByaGpxSY
	6JLRxfM4Q1FH2Q4S2ZR1aXetY6lh0QL3dlw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794093586; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:gNe/dCbO8gSjo2pV8qvkEsFZWsMCmIJzsaOMpRdBooTqEqO
	TQg4UnDI5NGfIVxBFBi6epuYD+GjGgBqhGEzOgw3W4PPA2B7CP0riWmX7zRl9+zM
	Y+ojjJ8O7Ks7rgU/cCEzwHEivrXjecF0mkJILb0eyg04204ewG2VqIcD2IiPhzb3
	51PAcxzO2wZFYWbpa+/6Syz3USGckjQy0Vq4eSq8FKm+Div0WcHR8WP3//gga0D6
	xMOOQ645t3tonQVE5bCamBQM9l3+c/xgvjZHoK9LHEcHh++6WWHc5X9pF0G4ng48
	ohBKvhkkL+o7BsBFSYEYTEILHouAfb9IwJNd5SA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:x7Sfjm0f9pqh4AqYHOsL7rmR2Jr/hc7QaD4viFSJ5W0=:6RRo+OBt1IhZ4xogOEdR2pBrdXif9X5SmwopyimVo5M=;
X-ME-Sender: <xms:ErLvas5SG4G_Pj6JZweenbWPssn_G9xMfcZ9cA_mRfb8LYPVYg646w>
    <xme:ErLvaunDng2tdZXXnSNT_Eo09l6_QH-DOYM0ZvU0j05k2nbPlEv4LablyfXIGPgn6
    iq7dz8irx8oiDk0WxG_x4N0DKdUBIl-TfT0yV0eeRWr8fYUiBUJvzP5>
X-ME-Received: <xmr:ErLvapqUHWHVTmMoMKcsUgZSW8WaPSSDqE8dDqRRoFIUTUaYl2VkPbFXOKXUdXFT>
X-ME-Proxy-Cause: dmFkZTEdNd9HusIe971QxMMayAxtNsdVz6nTopCxpWyiyaErsYPBNj++TmKnpp4i4Al0fW
    LDFzS8yRyg4TaX5igoqvTEfnXgKBaY6xsNZBnomgtnnHIvWIL2TzUnG1bThbe5FMgWwiG+
    g620mYADKWIaLEaUsVYioZqvhTyeHIcJKzMXmH5QtBmwavrBv6KRkCUdMBRGVmwe/QJshq
    wUqoTRRW5DVXhIX6KwMJeLoK0ysdAURocJmQ89XsMBc3Gi4QftJSXz8Epf5GQiHl574BRH
    YDJ49sZMky4A5Ih26dSX0utNSJQZmkB2ceRt5HuwOfr1sqFz5cO5EEmRARhJ75kYD4eeMr
    R6G6lG3mf2Kbd/n707OKVZWopXmptaDUPpSV/WpfjE0fbU9cLMV6ucZL4hue1zlHhDA/Fx
    sYfYFzjwFmFVb08m2d1Y86U8R2by5jo9Ab4Ojp4fN1fzyC8YwcEBrTrfA1R+yFwHW4nOlC
    V3Pf0qRF8QzASXSEmGzL6DeNRiQSdzBHwKKkyd2v+Mq6P6oQqWJi6ecT7St3rJ8AXs2Mb9
    JFbQVEkgUkLjJHRYUibhMz4a2zZTpzoXe7P+JEmGd150VVFvUsU8+7VpgJFqVsL+iWqR7B
    iuVx7LqisuvsfURvntVInvLKajIWE5TRWVrcXlqtICnwrpNquJF2IEu44XgA
X-ME-Proxy: <xmx:ErLvalsBYMmVsmkIpDWH2fhguEsNSgvfBMO7YlKtD1JMQ9Cmft9-6A>
    <xmx:ErLvamGx1pzxfm64vLwv9MIt4pRNTKZoL_fLnF-KqZqqmArJCWAXrA>
    <xmx:ErLvamanm9wD2ZYINSZdzPvW18pC59RWsE9Kn0aP6l9srfL_W9Y-bw>
    <xmx:ErLvamWoQCC7THEosRMaHQO64m0fvMy93EswfYZ0Xv1VB_GkzqrinA>
    <xmx:ErLvaofnfL3X9X-89nPPNMwLg3RZch0nM3bKvN89Tj_gz1PaF5T1NuIJ>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 18:19:45 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH v2 0/2] ksmbd: fix explicit DACL checks and parent-derived rights
Date: Sat,  7 Nov 2026 17:19:39 -0600
Message-ID: <20261107231941.1824289-1-icb@fastmail.org>
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

For explicit access requests, smb_check_perm_dacl() uses one ACE: the
first for the caller or the last Everyone or Authenticated Users ACE.
When that ACE is a deny ACE, the function allows the complement of the
ACE's mask, so the deny grants every right it does not name. Deny ACEs
before that ACE are ignored. Guest and anonymous sessions also match
Authenticated Users. On acl_xattr shares, callers can therefore read
or write files that the DACL denies, and guest and anonymous sessions
can read files granted only to Authenticated Users.

The function also never checks the parent directory, whose
FILE_DELETE_CHILD grants DELETE on a file in it and whose
FILE_LIST_DIRECTORY grants FILE_READ_ATTRIBUTES. ksmbd can therefore
refuse the opens a caller needs to rename a file, set its delete
disposition or read its attributes, even when the parent grants those
rights.

- Patch 1 evaluates explicit requests in DACL order and fixes the
  Authenticated Users match.
- Patch 2 lets the parent's DACL grant DELETE and
  FILE_READ_ATTRIBUTES.

Patch 2 passes the authenticated argument that patch 1 adds to
smb_check_perm_dacl() on to the parent check. It also restores
parent-derived rights that patch 1 can remove from guests. Backport
both patches in order.

Older stable trees first need commit cc2f133e80eb ("ksmbd: fix maximum
allowed access checks") and the earlier DACL fixes through "ksmbd:
grant a caller what its groups and OWNER RIGHTS ACEs allow".

Changes since v1:
- Patch 2: in the parent check, ACEs for the caller's groups and OWNER
  RIGHTS now decide before the parent's POSIX ACL. Sashiko's review of
  v1 found that a POSIX ACL entry for the caller stopped the parent from
  granting DELETE through them.
- Patch 2: a comment on the DACL walk now says which MAXIMUM_ALLOWED
  requests skip group ACEs.

v1: https://lore.kernel.org/linux-cifs/20261107062233.1579198-1-icb@fastmail.org/

Each patch was tested with KASAN on ksmbd-for-next 6f42553e493d.
smbtorture gives the same results as on the base.

This series was developed with LLM assistance.

Ian Bridges (2):
  ksmbd: evaluate the DACL in order for explicit access requests
  ksmbd: let the parent's DACL grant DELETE and FILE_READ_ATTRIBUTES

 fs/smb/server/mgmt/user_config.h   |   5 ++
 fs/smb/server/smb2pdu.c            |  11 ++-
 fs/smb/server/smbacl.c             | 127 +++++++++++++++++++++++++----
 fs/smb/server/smbacl.h             |   2 +-
 fs/smb/server/tests/smbacl_kunit.c |   4 +-
 5 files changed, 126 insertions(+), 23 deletions(-)


base-commit: 6f42553e493d3f25059a215748ae241e525c865f
-- 
2.47.3

