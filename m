Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795363319;
	b=dcqvKnBDSPhp4ZYaCg/ET64pndluapZmUF+IRdEW6eFAzgCkoL1byruJCZswEk/yYKlr
	 OJpSY/U27i9pR85CkN48yYrg5lnnkqHGGAN3Q32v0hBmP8vNSOviawy9+eBry8cELXp/n
	 FczlZtZxDaD6wHYr+zwk1ranwtmJmAzCiI6Qv2CNVVza9wgloGrCbQDIQPg5qHxrncWZt
	 3ZhUVP1ZvkM78L4NqCSPvU/nsUU9zyOMZ/3l/FbR2mbizZXsyzyJZspQo8fHr8xSmBn0j
	 zT3dFDQCoXKb7LnG2bl5SfYTyqJ6QkAQgBACXYl6aBTkEqhGrpYeDQemHu0pHZtTYEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795363319;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XDld9PW066p+crnVitgqt2+/tNYD/KUw0fQ/XW/KMSE=;
	b=Ac8X997LWnhvc79dBI0kOXK3uLZbMjfBsZt2qYaCHLpqb+GVo4uXSqbyDyfdUfkZFkQ3
	 9KVsWWjFKF0g42uCcmNBGunF+76cP0M4Zplbe8CIYPHCjxFs+JZN2PQgRfqYLqu3p/w/m
	 YiXdXjM0JcS/webjYHZOehP9FAL5ovEYSz38fDuiGKyYTg6Ba3C+pG7a6dq7tK/bTPIAm
	 Wlsz+0h3G/XlcBfR3H3p2jdUd9411o4oeUvHnsl6anVfzEnJWnPg91ieky3utRM32OCvb
	 OpRVBHG0ajo3QXCaPR64WwkfjNWz9mVlFuhVpUcbVdjsw2bLRixpUmkTVdEG3yJv9ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Dnz9DvTP;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=FLmBb5pS;
	arc=none smtp.remote-ip=202.12.124.149
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0F2606A331
	for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 16:01:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE0F2606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Dnz9DvTP;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=FLmBb5pS
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 10CBD1D0036D
	for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 11:01:58 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 22 Nov 2026 11:01:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795363317; x=1795449717; bh=XDld9PW066p+crnVitgqt
	2+/tNYD/KUw0fQ/XW/KMSE=; b=Dnz9DvTPCmUJVBkTwV9+TghzEd6K+Mj6H/Zr5
	JMxgl4gLk4i6KqKEM+AbVYSTfB+56XP27BH7fzOSw9NOVjHbA2CLix8PL4AKGYJs
	FINO+6281EMeMUtso54vU44ctvSjXCh8KGEujAhArgNldudLr47fWpltqOAQIh4h
	ZPn996CKAdzx+MKIX6jFqRZ91PpIlXQH8Jopt4V63hlyBzisysYpNSs/gMvb8KY0
	pq3NBm2sMPnq22wkEun1dqcdTgAzz9caj0q3ibCBgInfYLK13WBQuVkVAdZDnVXD
	eFWxu2tMtdJAHrMZk62Mh/ZzIVZ/A3Dp4dXlG2GZV/8po/RyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795363317; x=1795449717; bh=XDld9PW066p+crnVitgqt2+/tNYD/KUw0fQ
	/XW/KMSE=; b=FLmBb5pS6Sg/D0t6I3SuTPnb5/EqiPHCV609fScE7VcA+Qf4kmm
	OG/MrqosXILmjjWGgbF4ImeZBeEB+vNRpCkly8h215O4qfwY4SUCZIoKmaXxhsT5
	K457j9P3eqbNWyCfqtgUf2AZHeGBu0o9i6KmhAnyynM2cr9azjvKbwNi6kXApLYL
	qElNJxdr9SQLHEFUzHk8eY6FSlhR5NS7AmICQ7znbNJ+Lx7ly7Gbl84wk2aQeemj
	AHRQYOdX3QKBYWXjm34XBoEPGnvKMs6KzR4KeqRensFSNto1h/1lYlx//c4yNXXG
	LHPumLN7QHXkWwAkaFqPjS0Rnprb+au7a8Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795363317; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:w2RuauV+esdiS/CLvl+SUTHL6uTwkSJXPD2o90lqv/bdoGm
	dewWgbiKN4+uEWavk1Dd0SSNJ1qpKHydq/qTPsHlsu+pK3qmuOWvPBgS7OdN6PKu
	p5i+gWgQ+vcO8bC1wx7bSB4HuCL48WRTvQDqPzWYFXOywnKElDdjI3NoHBTr5n3B
	HE+3Rbq00lBH5oMmaJxTQfQLQWhxok3zxexQg5kGHl5X1UCSpmiLuVnxUg4skhmF
	yBLuMSlOp9PLX+sLQHhnIaBAbXllvfLbuAkjc5nT/tCRQ58FI5GHDVOGrklwSqqM
	NusD2nQlradEePZGtZ85eApAvZdPq4Wtji2mHew==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:N4+VdSiKVh7xvP8VNSkuum4tocOkWd+AwuVc4a4nSoo=:GV0xntGjgmnV+/w/kBOIy2YiHC7ECgw6Rl0J558qJ+c=;
X-ME-Sender: <xms:9REDa2PAFaTyB8bLHlLPlFqIKDFPmb8wntoJTmXxWMOZI6UBNDMpbw>
    <xme:9REDaw_aF34v5VqPGnOpAsUJztC19zWidRyEwp9Luzt6f2p6iYwKfNVvhH-qON0f_
    I7ccovKVLXRJNGqZ3I4M2v5F8Dz6ZXouGCAVrn7zbPiMKk4LkAdiDk>
X-ME-Received: <xmr:9REDa_eiqKixe9eOJL1QmO-C_iGG_BL_pjBc44JpZiEdgZM0MqizDd-fWS4FEdoD>
X-ME-Proxy-Cause: dmFkZTFPgQwZylzjtFt3UJY3D8HF7UmyC8nzGTIQ8ejJnpDqHGKvStENkj8iGnLvJf6Ajt
    nOhvQuoIUtqykhB2DQ230t+aMouFq0GCfRobqXnKT2cUcttNT/vNdzMxXU/q/EJTf0UPEw
    rtCJcS9xFi+ybeO6t5SRG+mShzEQUgg6YAzeSMpRredYk/9Dqkj/O3za4UYSZkv++j87LA
    2M3roU5I/iLfvgo9xfJjD4+3o2ngkbvin9NhQU30LLCOEUWEL/J0h70zk7V6hVnqABrlbD
    UnFybTtif2cYNQugUYNC6BwInKFgVYdwvu2uFPHZCHdC0Qwp64B3gMg1xg84/AQrl0hSXI
    vS+qnZsJm4yaMKqyyX1STqBn9Tbg7HbA23Aa8sR579k/zj2q3ODC069o3klDpTANolYVzw
    nt6sCpnuNoShuT3dPRoyxKsm2XXzMtPrXYnTjYNlazzyitEbBm80DYQFW+hW5Ge2gixRF7
    bChN1LLjM9mil5xkS9MfxgFoQfItokUtcCm5sgWXv3z3X6nQtobzc84d7aWGTnuKD2L5H0
    Qw7O6W+Z6RoQj93BE6/3xlCNXGhzq/6wXOidTGMzB4zGz9onAH5iuWuCV2EE/95iy3EF1B
    q9JdxwYHCAzFRCyPVWgpgQgrCemoWjuFRM4WFb4oCpN8OcTX3GepSL8k/epw
X-ME-Proxy: <xmx:9REDa3wtn_KTaTe6TJJJbIM_qPIjFcY7WeK8RqTVA4qu9MuZ5LDH_A>
    <xmx:9REDa8KaEU7IVrEqZCwIPxNyXkpClyvEI8WCklUE-om-tU4A6BRoPA>
    <xmx:9REDaxHm7QI0bxD7InjdHi2zctn_av471UJawin1dZ68IlWzodPUMw>
    <xmx:9REDaw9rKlOosnmAT8q1f_CFaTNVzWcTAyprSK4h8jD6r4i0UEAnGQ>
    <xmx:9REDa7thbAJ1nSTM1HD56kjH6NxHryP9eKThpXB25kGpHACz4gtwe_LI>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Nov 2026 11:01:56 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: return only the control flags of the parts in a query reply
Date: Sun, 22 Nov 2026 10:01:49 -0600
Message-ID: <20261122160149.403491-1-icb@fastmail.org>
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

build_sec_desc() copies the stored control flags into the query reply
and clears only the DACL flags when the DACL is not requested. A
SET_INFO without DACL_PRESENT stores the control word as the client
sent it. Its other flags then appear in every reply, such as
OWNER_DEFAULTED in a reply without the owner, and SACL_PRESENT
although ksmbd refuses to query the SACL.

Copy a stored control flag into the reply only when the part it goes
with is in the reply. OWNER_DEFAULTED goes with the owner and
GROUP_DEFAULTED with the group. DACL_PRESENT, DACL_DEFAULTED,
DACL_AUTO_INHERITED and DACL_PROTECTED go with the DACL. The SACL
flags and the other stored bits, such as SERVER_SECURITY and
RM_CONTROL_VALID, are not copied.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Tested on ksmbd-for-next 89d5e8fdd5a7 with KASAN. After a SET_INFO of
the owner with DACL_PRESENT clear and other control flags set, every
query reply returned those flags, for example 0xebf3 for the owner
alone. The replies are now 0x8001 for the owner, 0x8002 for the group
and 0x8004 for the DACL. Replies for descriptors stored with
DACL_PRESENT, smbcacls and the Linux cifs client, and smbtorture give
the same results as the base.

This patch was developed with LLM assistance.

 fs/smb/server/smbacl.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 7bb28ea195c8..a4a36983852b 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1111,13 +1111,17 @@ int build_sec_desc(const struct mnt_idmap *idmap,
 	pntsd->revision = cpu_to_le16(1);
 	pntsd->type = cpu_to_le16(SELF_RELATIVE);
 	if (ppntsd) {
-		pntsd->type |= ppntsd->type;
-		/* These DACL flags are returned only with the DACL */
-		if (!(addition_info & DACL_SECINFO))
-			pntsd->type &= ~cpu_to_le16(DACL_PRESENT |
-						    DACL_DEFAULTED |
-						    DACL_AUTO_INHERITED |
-						    DACL_PROTECTED);
+		u16 flags = 0;
+
+		/* Return the stored flags only of the parts in the reply */
+		if (addition_info & OWNER_SECINFO)
+			flags |= OWNER_DEFAULTED;
+		if (addition_info & GROUP_SECINFO)
+			flags |= GROUP_DEFAULTED;
+		if (addition_info & DACL_SECINFO)
+			flags |= DACL_PRESENT | DACL_DEFAULTED |
+				 DACL_AUTO_INHERITED | DACL_PROTECTED;
+		pntsd->type |= ppntsd->type & cpu_to_le16(flags);
 	}
 
 	if (addition_info & OWNER_SECINFO) {
-- 
2.47.3

