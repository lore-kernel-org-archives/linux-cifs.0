Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794177256;
	b=ieATFnRMjktqiW7tQsiPKvN2DpANLZcF0QBKIIKpDoqesfZPPxhUv5zsls8EaQVNdGrY
	 x3LCET2IcUpHUcEmYQswelaadlkuyihIkb0rEed+17T/stAUjF1aAE4pTB5eLW53/3ajl
	 R/lr2PvYTY6Ba+iQtc6nWt5LIBJub4CBy5rDzzDyuc9/bIJne5S2tiXHbSXyr45l7jezq
	 v2cvSMMTIKSXif90XAwwtgtUpv0szsMCzfDkX+tZKDH9W0rGxgeFZEwdnipNlhVrT4yaB
	 Q3ZswASrjqjsVw3fQcDID+V4UvK3mBP4UIgStXB9n6hpry2l8mDiSMSHX9OOIbsqrLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794177256;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Awqw1FuWKnlZPPdmJBYU0qJgaH04TsizxmLyTOVCgws=;
	b=pJhr/jwPFAvxCPDb4wceKHOuhJ+vLqpYUiJ9pRDuaKkKebaYJE5pONP0aT8POa4hGNGB
	 +wcBA/+vyz+VjC3/DagJnq920dhYXNaRnCsctt7P7KcDMUWu8+VUdQ43LrPvQ+ZD5GNVV
	 wdI0Dg4FRrO712anpca4JTjfoZMIiaNPTod93eXwx53FHo4YEPJdzQrn0Fj0KTkzdaeJ4
	 qhk37hi33DYhPVL6UWw9+U4uVluhJIrjHcIW75F9O+frG7XcEO5+xk74KS2os5lLB2hIW
	 a9TTEZVH3vFRcOxrgwrk8OW+1IZXGlWEh2MOPUCo/7LAT9bof52m5/tKRViJfjwyj1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=uMtFQaKK;
	arc=none smtp.remote-ip=185.70.43.100
Received: from mail-43100.protonmail.ch (mail-43100.protonmail.ch [185.70.43.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2043B606A335;
	Sun,  8 Nov 2026 22:34:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2043B606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=uMtFQaKK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1794177253; x=1794436453;
	bh=Awqw1FuWKnlZPPdmJBYU0qJgaH04TsizxmLyTOVCgws=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=uMtFQaKKDyqKKEavXe5ZEsDPdmsEJKC8us+/DbXtUIkwKPwMy0N9l+fsxMGfHsVpy
	 nm9EtU37aisas8o8qYO/tFNwq6Wm25Pb/wm9I6RtrtBLFOFfEhH/cob8C4kMHZeRHe
	 aXOC2G4Bsr6ZeQp7yI0xbZCjmX9fM5HeVYDdUMBHN9K5RaFTuQxiV4xhVpF71iZFic
	 ZG+F/8QhU1CTFmAVu9A68QMJIGcueOZe1oxWqlxPEGDI6QSD73AUdVgOvM0MnGMSRT
	 O9yJEqyK7H3xtvorjfR6SI+fZLDVg4tavmjG7XpvL9wBI8FM4feU1ys9hFY71hKcJw
	 R0VcrtPu+9tEw==
Date: Sun, 08 Nov 2026 22:34:09 +0000
To: "linkinjeon@kernel.org" <linkinjeon@kernel.org>
From: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "security@kernel.org" <security@kernel.org>
Subject: [PATCH] ksmbd: take credits lock for SMB1 negotiate accounting
Message-ID: <oPhvAPE0sxlR5lgMX9hnaRTGnfk-M5xIdlUmNn35FwqbLJ9lx9Rn3gva5lYH0iR9rxit-qJXK4e3IXqlJGu0nAJ2rTD58d-aFphchKYXFhQ=@proton.me>
Feedback-ID: 186545857:user:proton
X-Pm-Message-ID: 6b761c1ccb7d85f9de3b5f52052e28389568bbe9
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

The SMB1 multi-protocol negotiate path increments
conn->outstanding_credits outside conn->credits_lock, while every other
writer of that counter holds the lock. The race is unreachable in
practice (connections in need_neg state are serialized by
queue_ksmbd_work(), and SMB1 messages are rejected before work
allocation once the connection is upgraded), so this is a consistency
fix: move the increment under the existing critical section.

Affected version/commit: mainline fa4ad798f6f681031775266044ba1b0cf3c670bd =
(v7.4-rc1, 2026-11-07), fs/smb/server/smb_common.c:165-183 (ksmbd_verify_sm=
b_message).
Pre-existing in v7.3.

This was found during an assisted (AI-supported) static source review of
mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07); e=
very code path cited below was re-verified by the
reporter against that tree. The patch below has NOT been compiled and has
NOT been runtime tested, and no reproducer was produced - the triggering
conditions are described above instead. Please treat this as a report for
verification rather than a battle-tested fix.

Reported-by: Noah Weinberger <noahweinberger2003@proton.me>
---
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index f9fb374..7453b0f 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -166,7 +166,6 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
 =09    hdr->Command =3D=3D SMB_COM_NEGOTIATE) {
 =09=09struct ksmbd_conn *conn =3D work->conn;
=20
-=09=09conn->outstanding_credits++;
 =09=09/*
 =09=09 * A legacy SMB1 multi-protocol negotiate occupies sequence
 =09=09 * number 0 but does not pass through
@@ -175,6 +174,7 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
 =09=09 * window can advance instead of staying pinned at 0.
 =09=09 */
 =09=09spin_lock(&conn->credits_lock);
+=09=09conn->outstanding_credits++;
 =09=09if (conn->seq_low =3D=3D 0) {
 =09=09=09__clear_bit(0, conn->seq_bitmap);
 =09=09=09conn->seq_low =3D 1;

