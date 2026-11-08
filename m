Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.31
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794177252;
	b=ehClOF7wfxndv3Cyx65IyS7tvWJOUAQbqK/XDfKXoumbLY7+A6bUe8YNMxzyd1OReIbR
	 t6+ya2+bKz7wBfdR4U/FYoUitHVSWOfKoXreNuXr85Ud8KtDoQbhoxOpRk1Co7XK5NHeM
	 R7iwRNv2SXGOexIYiD1t5BdGt2VOMpNqQuVbLWdhvhyC0ATGOTw9xrRzs9v0gNg/T3eVu
	 3X7I0KdUENb7+4yd/vEBukTvILj47BCdS8+zazyN5+286Nmde9zWZSY1k108miwIn2k1F
	 e3D5e7H9jrL30g2Bx5mrye3XetQTZiufGovZCmytFgHCf4fwyL+oteMMA1JhU4+SoBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794177252;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=eBgNJUN7Yw9OQB33Kog9Tdzkp7HIfiQwrNHzFR4EF2k=;
	b=M7bwewVcJom9VObMchFgng1jwL1v536JsIMBMwnF6DBt0qWzCW/sS20VFWngHGqvjVmS
	 kNejHYR25hXc9JANWULeM8IcfVB5OBhCh6ZxOVh+gLYnkqHyOXnEFRcoWI2cGbNLX9mu8
	 ++Mz/I9nCfs85ctn2VFjQh4qtLeB8qqGPqtXbbpzHnLv/6WrEVqO+O8PGSAmV6kt0UVD+
	 LDQwORQ6mcO4BhFKfxbW65ADy4fMUArIeKa35KQ2nXqTn5xYsiQVF8eZWAE0kYy641U5Q
	 Ayit9/Ri3GOS3T9ZC438r4KdVmEF8RiJijbrYH8EmdF7zE4AmrKAPVG+CnwuJrgkzxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=NF6mh20x;
	arc=none smtp.remote-ip=79.135.106.31
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54428606A320;
	Sun,  8 Nov 2026 22:34:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54428606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=NF6mh20x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1794177250; x=1794436450;
	bh=eBgNJUN7Yw9OQB33Kog9Tdzkp7HIfiQwrNHzFR4EF2k=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=NF6mh20xEFOUKkpyd2N3NPs9XI+wBSy+2CBmal/8U/NLGFO7lVtCNC0mNTBEtbK0h
	 kBNZ219EMpzA85bVS5ho3akI8dx6I9IZaJ3h9+O6gQdKsHR1awtKhTTYBlLlK92ePa
	 05Swvjr35xTdTYH2Nf3w2G06h/0Oh8gAkJ38xZTM71Ns566nf4iX1Hd+Ba2nVke8Wl
	 ei7cOY0JXe0lAduwDeGdZVJ0pIu/OdY/4SxWlI3iqEH8FCxNstAaN7gnRv2MA5Ub8O
	 m3lN/COuf0nnsj2p9nfb1qi59FuQog7QjtsIAgz2uHlz7rU+AFcIa1jtdVyW/Cel6y
	 Zxj4oAMF7cnIQ==
Date: Sun, 08 Nov 2026 22:34:08 +0000
To: "linkinjeon@kernel.org" <linkinjeon@kernel.org>
From: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "security@kernel.org" <security@kernel.org>
Subject: [PATCH] ksmbd: check sign flag of the current compound command
Message-ID: <IQLTi_rZrPgaD4zlFXgSybFdR3EsaBQVIorCAH3otR3SGOlNjacAL7jt2xb4mhqNNcdBMPel5CrrBxTOsKoRIFuil5wToLwoYXtR8AJ9vF8=@proton.me>
Feedback-ID: 186545857:user:proton
X-Pm-Message-ID: 8855dee553ba75382178afbe236f3f91e572001a
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

smb2_is_sign_req() decides whether a command must be verified/answered
signed based on the FIRST command's header, even when dispatching
commands 2..N of a compound, so the SIGNED flag of the current command
is ignored and its response goes out unsigned.

When the session mandates signing, __process_request rejects the whole
compound because the first header is unsigned, and when signing is
optional an unsigned request was already permitted - so I could not
construct a bypass; this is a conformance/defense-in-depth fix. Use the
current command's request header, like smb2_check_sign_req() does.

Affected version/commit: mainline fa4ad798f6f681031775266044ba1b0cf3c670bd =
(v7.4-rc1, 2026-11-07), fs/smb/server/smb2pdu.c:12811-12820 (smb2_is_sign_r=
eq).
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
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b084cca..d0c6356 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12812,6 +12812,9 @@ bool smb2_is_sign_req(struct ksmbd_work *work, unsi=
gned int command)
 {
 =09struct smb2_hdr *rcv_hdr2 =3D smb_get_msg(work->request_buf);
=20
+=09if (work->next_smb2_rcv_hdr_off)
+=09=09rcv_hdr2 =3D ksmbd_req_buf_next(work);
+
 =09if ((rcv_hdr2->Flags & SMB2_FLAGS_SIGNED) &&
 =09    command !=3D SMB2_NEGOTIATE_HE)
 =09=09return true;

