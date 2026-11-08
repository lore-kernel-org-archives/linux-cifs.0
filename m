Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794162025;
	b=bY7SF4pc6LgKKApkUXctB1rLfkMgt3aKPeUhKGItZ55k2vfYuDp+jwGQrgqnuExxn4AS
	 LZStDw182NJkPgE7NuGSzRl9gwlczqVtC0y6BoaOhtmAazawlnFQTBK+rLrG7tQfJaWLV
	 4uq3PMeGrKPYgYQgSXVVWJJwogei6+flccwjmKVpVfooXhJEAZ3f2DBQmgEaJq7/PB9FG
	 JPc0j0q/yCFeVlo3AUSvBajRbIatVLqLY5J8HZ9iTeOZck+wB/ZstxjGobgo0Q+r+fM8q
	 2thgzMVcIph5eomoXWyOCaAdONUaWpBgtfo3YWYakmzGt3IDgRTp/dAVT4P7L+vgusw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794162025;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PbR35XiVVIWraPGWWcvFvDs5I54IAhzBzMiggypBFzw=;
	b=5C2bcxmUTJIlK/6eAQxJ9bx/v3X1MIBXFzb39+qWxKKSedzPJi4Q08noRvjo5lBk0Urq
	 7x8mKFUZoAP7/zp22zM9r4WtQF6/69lC7DDPAcxREKvLSa7gRJQ50rJePgI4gq3V2fzqC
	 DhQOkBCtKvDfGKHU815TDNh1xQ07Yxd+BS+P+gxMB2NYcdqB+a1EwHGutgFzc/0oYrA3d
	 PcIhHW1nIGjPcijABuk/TS9U5n6TGVQr5IKcPfxxsfLfpbXlcKPFAuUEqZF6KGbTmBCxN
	 /zsOdMHMV6tG0C+nlsUe30iIxG25Ps4YA5Ds4IBwUY24WuJBhbOa9LBZ1ZjUID+GDDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b="ieVkY/My";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=0BSP1A+9;
	arc=none smtp.remote-ip=202.12.124.149
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9B5606A320
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 18:20:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED9B5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ieVkY/My;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=0BSP1A+9
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 40D3C1D000A8
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 13:20:24 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Sun, 08 Nov 2026 13:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794162023; x=1794248423; bh=PbR35XiVVIWraPGWWcvFv
	Ds5I54IAhzBzMiggypBFzw=; b=ieVkY/MyUQjict4emdgBNUWBAQkGWLTriVLHv
	hUwMmA0qOivsC8aBMqwGjNNBKumy9gSGNWkZWgJOf6akY0+sZZZPqs+GQZhlWeoV
	BN2GqSAMJ7m8Jb6Jq+5vw56Iew3ND3uoYA5RjI4ruS9Fz4kcqEjMsM1DIrrEJXTe
	+L+XMsl0PTvvFGj1Lcu/Yz1zpfLfDfuQ9Of8lQ1OuwXuJIYdCuTMxP2pFs7dr8dh
	cRgZFy0ZbLU/QKvMQgy8Qdf2zobXaJ2JkXmWR77V114wB6EQ2IaLaWfgv1CUjn4d
	RSOshKMhh5rJTrXqR//OtGUuYRT3dpTk3LuipIH+tYABBrOow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794162023; x=1794248423; bh=PbR35XiVVIWraPGWWcvFvDs5I54IAhzBzMi
	ggypBFzw=; b=0BSP1A+9Q/jZ+pn1jTUWs03EC2WshDsfmxpaujfuy6nnLpSYUAC
	ujfCOTAsi4N0VKvNBcEgX80mhx7ywRUnUt0uTNBqIiauiz8v4SP/Nixxrl7BTKRk
	a8jEBeAYpbT1KF1cPiAFuSCkeD1xcLa/Da6Ky0ITBkUnVFaNx1w1yPGsLUMEeI8Q
	/Ys++J3s9qnD1PPUyfD8OpK4MT8yl0QnyDS5YIBM297qzvpxa9fQ0XZYbDBL2gRl
	LCZH6w01lhg5BHXhSUJx1MhwkbC+d+yjRiRBawYc/s3pmJD0oZp5zYYhXSOo8wqT
	lRQwQZOBGFkVd2iSz93Xq4zE7JeN2FZ7iRA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794162023; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:ovYUutdrmIHwthQJrJe7NeTdAHkmX4IzOQh3R5t6Ou0kHSt
	bNoAkWPIaCctxsJ7RGfXdoSYjEy7oAEyn86p/swpohNd1ucj8HwjmQwUITq6L+Pa
	ecPJenx69o5TSb2Xx9ZdaPAtGeTF7YSL5i4dUbK/gzqDmmURKz5HpuqoFTfblZmR
	0e9g6JhKPgv3rzd7CPFs5p72oBvkFVn1S4jxnTAl1RBxDDpxOSiwSL/qIl3EIIgS
	I48y4hChNF9Tsfhxoj5PlscXJzZO68OWXXcccZME0uZhrHqCe+vvDeVk2qI88KD2
	z7PMtN2caIAMtUl+inxhUcBgUepigHYZKSEKNsA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:1jug1UyKWT71b9GkrDBBCB8olC6QuXKeGuVlzpNj7vg=:wUxsHYGFCU3zkHneFwyevYZjfEzbUrcHmIieWC5JXMk=;
X-ME-Sender: <xms:Zr3wajrDLKQ3ByRE26Hqmdt6BmIrL43jsxMYgvvtdKlua-asZIXmyw>
    <xme:Zr3wauWpnPJs0ROp6h7he09zMZzQL4hHUxaodsEnKeh_pMg8IEmJeCRIHoTzvw88r
    FEqg2NCbYrXE9JsiJaUN5OGCGlSbLfvL_17iR3NbHBxD8We4wPKtAZT>
X-ME-Received: <xmr:Zr3wauboKIpO3x8rCoKr0gL30mxTj7hUZDScR_E-cOR6NpYx1w4Bk6JYhfLrkAJk>
X-ME-Proxy-Cause: dmFkZTEz4lTyiNlrhfEqdBUEbs0DMfQN8NYKzX9n13W2b6fXSHzuYZC4bA0OGY4WpAnTTJ
    of/ZS2XdmZzbr7hs2WU/xDrkqIc+G656ONabJgxwSG/JiAcHkpAtbN2RlclHMCZo+0lnIs
    1UUOWyZ4EiLzGsQSazJpKutoo8RgUkqUPZiv94lbNlGvIVJ7JNLY5gEluO1giqNIqnGc4Y
    hJxakEtZzGPXmfMnUdvpnSao0lF6SmoXM+u35V+DMsSFzOjlrUtpBJKcTu3vm5pAC0+DUq
    y3qUT32erocSLB24gevKxkGL993tCtua0yNuhVqVQL0/ZCSUkLPJcrtfyC2Su/MPYjZjKe
    ho9ww9PiNzwYwwGXiY2Nsxp6HvT/w7kdIhyw8irroiIAL9dPgASibqURvhALn1Olr9uf42
    /LbEn2dsUruMOuRyM18Q8E1kUwctpKpE/BZw7bQHltovOi5kSVy1hzfhxOfc3FdU0fw68+
    /WS4yjGaSilII0L7LWPRAQZBfQwuowvpsbHYNSTeBrUM3wrM7FDFnHEeHe6nQTqVAooSTN
    KDnm0rS6pCRQyCsZ7h6OwLVXYzTVtT31ZCShLkj/2nidScTJXCrpCRu660Nc974Xgu1dkT
    TBXv9eVHITdZb6yxjWo1InSzKvKFQi+4izfTezqatNeyDL73h/PVyUx4wT+w
X-ME-Proxy: <xmx:Zr3warct_w5nb88av92VvvTF7UZR7JiRlzA1Of5cQwk0w76ZIwnaCw>
    <xmx:Zr3wao08R_DZ5zNHyy84KTc8T_Yb4w1fzsZ6L_nYQLrImZu3hbp7nA>
    <xmx:Zr3waiJxIPWGZXlc9lBY4BzLfsjIhNhQu2BPe23HgYAdz_y12S9wBg>
    <xmx:Zr3wanF1Wd-ECdGQt8XWbJtbIDV0UiultFZLKvTzocwwPRMubduLUw>
    <xmx:Z73waoOF7xYMYOpSvHadnPHK9uJ5t0X9iTL_u9XxsM5HmHwCRIM7zrjC>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Nov 2026 13:20:22 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH v3 0/2] ksmbd: fix explicit DACL checks and parent-derived rights
Date: Sun,  8 Nov 2026 12:20:09 -0600
Message-ID: <20261108182011.1888520-1-icb@fastmail.org>
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

smb_check_perm_dacl() mishandles explicit access requests. It can turn a
deny ACE into a grant, ignore earlier deny ACEs, and treat guest and
anonymous sessions as Authenticated Users. This can grant read or write
access that the stored DACL does not grant.

The function also ignores rights granted by the parent directory.
FILE_DELETE_CHILD can grant DELETE on a child, and FILE_LIST_DIRECTORY
can grant FILE_READ_ATTRIBUTES.

Patch 1 evaluates explicit requests in DACL order and excludes guest and
anonymous sessions from Authenticated Users. Patch 2 obtains explicitly
requested DELETE and FILE_READ_ATTRIBUTES rights from the parent DACL.

Patch 2 uses the authentication state added by patch 1. It also restores
parent-derived rights that patch 1 can remove from guests. Backport the
patches in order.

Older stable trees first need commit cc2f133e80eb ("ksmbd: fix maximum
allowed access checks") and the preceding DACL fixes through "ksmbd:
grant a caller what its groups and OWNER RIGHTS ACEs allow".

Changes since v2:
- Patch 1: keep the POSIX ACL fallback from replacing the DACL result
  when an Authenticated Users ACE is present, including for guest and
  anonymous sessions. Namjae found that the fallback could otherwise
  grant access denied by the DACL.
- Rebase onto the current ksmbd-for-next.

Changes since v1:
- Patch 2: let group and OWNER RIGHTS ACEs decide the strict parent
  check before the POSIX ACL fallback. Sashiko's review of v1 found that
  a POSIX ACL entry could otherwise hide a FILE_DELETE_CHILD grant.
- Patch 2: add a comment on which MAXIMUM_ALLOWED requests omit group
  ACEs.

v1: https://lore.kernel.org/linux-cifs/20261107062233.1579198-1-icb@fastmail.org/
v2: https://lore.kernel.org/linux-cifs/20261107231941.1824289-1-icb@fastmail.org/

Both patches were tested with KASAN on ksmbd-for-next 6f42553e493d.
Its fs/smb/server tree is identical to current head 2f14fe2d5895.
smbtorture results are unchanged.

This series was developed with LLM assistance.

Ian Bridges (2):
  ksmbd: evaluate the DACL in order for explicit access requests
  ksmbd: let the parent's DACL grant DELETE and FILE_READ_ATTRIBUTES

 fs/smb/server/mgmt/user_config.h   |   5 ++
 fs/smb/server/smb2pdu.c            |  11 ++-
 fs/smb/server/smbacl.c             | 133 +++++++++++++++++++++++++----
 fs/smb/server/smbacl.h             |   2 +-
 fs/smb/server/tests/smbacl_kunit.c |   4 +-
 5 files changed, 131 insertions(+), 24 deletions(-)


base-commit: 2f14fe2d589583ce649b2bf1b449cc9839abda8b
-- 
2.47.3

