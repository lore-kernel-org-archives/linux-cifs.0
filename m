Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.28
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794177065;
	b=KUt3cMMsovvjsS70NQ6crUoa+nd8oog/jkmaiMBhSw5JdY46gLhlcKHJPZ2QGqPIfNLU
	 YpnNGlWVyerK+w8semgpsaeDdr3gcJmf6Uj6drQFiLZF6dJXpyv1A6ESLOcswtkRdyJbY
	 +6aW+YeCdXm5rfWVoYDP3vQd0CWQHbLt+9Y59E8SmXvtgn3xvyViX9sza2gEBD5ZedLZ0
	 +tQGTPnrM2dfLLuc/PBxR3V0RJzK1xYM6LQqabGjs0NDM8EpW8MAZarFSsJSfTyAlxsM7
	 DUiIQytKSRk0Irm3tDjDy+Jl55xSEfnslWUrLNNFKbNET83IGuysf/Ok32yBjbZoQQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794177065;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1sW1mmLPlw0EKa7jU988h9/QwbW3FrIHOvYZABaI7ME=;
	b=cLIAei1vHjgPaMw3pYi+rY0R/knByoqR92ULplKHTsggPEtkrX90XJKXfdWnEqHq2jLt
	 HyhW1zbvxCE8l88SV7FTuddDjtx7rQ2bcL19QndgXe4Eymogh9DyjXyad6EqFRoG7J6Lo
	 2CCcSTiST6N6RyJoHLzY/Lhjqo7wzfuwSGcthsPxNIxQlXJ6YrWUZuj7QFEdPuGGwL1/r
	 yqxT6V/dltAey3V9bGyByx3EJEOcmoHGdE+B0GurLbDtihG/DzZFbyb1vaPRZ6ujHP6N8
	 KGFTraIDhfTRW8zgCaznQQBAdCkJDmXztSi+ysZO4WOyi/GtQXZX16eKYWgXFqslUqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=ttz5znjgmbg6hozo2ejrmcjh2e.protonmail2 header.b=Uph2DApY;
	arc=none smtp.remote-ip=79.135.106.28
Received: from mail-10628.protonmail.ch (mail-10628.protonmail.ch [79.135.106.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E7B606A320
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 22:31:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1E7B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=ttz5znjgmbg6hozo2ejrmcjh2e.protonmail2 header.b=Uph2DApY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=ttz5znjgmbg6hozo2ejrmcjh2e.protonmail2; t=1794177062;
	x=1794436262; bh=1sW1mmLPlw0EKa7jU988h9/QwbW3FrIHOvYZABaI7ME=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Uph2DApYA1WZrge6sTCfSMA8XLaHKdo7LqEIx3pEVIbSotG6hxAAAEG/SJzCOshTJ
	 BuJzJUrIgYBWSVmqepb4espY/tlRt3TSa8l+eUdNEVElRgOt0qNFJ5N25JmvBU7Hc3
	 ESQDeerg4Lh9mKUWWocQAPZXAQ70hKKBafdlEpFqBkejmp9PMsk00/l0gm/ResuqK3
	 EqpKw/tVl9u5NrdEAff3FcqHeLPYLNaRRRgkWrVQbob/SyZVXBQFx8LFjDTJHlot4s
	 ousE5KteOo4Cm0sKvTUFp+BiNr9MdmHmxJpQOmqBUWR+EwyYvh5z0Tu1LvYvkUTP5d
	 CiPWYc27OR5MA==
Date: Sun, 08 Nov 2026 22:30:59 +0000
To: "linkinjeon@kernel.org" <linkinjeon@kernel.org>
From: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "security@kernel.org" <security@kernel.org>
Subject: [PATCH] ksmbd: read request header for compounded CANCEL
Message-ID: <0cRgD2yOWbwKBhBZfP0O2ejMhJmcsRk-SQgKJhFyowKBsLZmKYKUb_iKGC1VTDPMUlJrnX1Qpa-CsfMFLwt8hxFqjGhvOLwzEGkO-0JgtvQ=@proton.me>
Feedback-ID: 186545857:user:proton
X-Pm-Message-ID: 9264b9ba86082f5e8c578dec8ef8e37008e7e2f3
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

For a compounded CANCEL, smb2_cancel() matches the cancel against the
*response* header:

    if (work->next_smb2_rcv_hdr_off)
            hdr =3D ksmbd_resp_buf_next(work);

The chained response header is initialized with Flags =3D
SERVER_TO_REDIR|RELATED, so SMB2_FLAGS_ASYNC_COMMAND is never set there:
an async-form CANCEL therefore always takes the MessageId branch and
matches nothing, i.e. a compounded async CANCEL is a silent no-op and
the deferred work keeps running until it completes, times out or the
connection closes. MS-SMB2 forbids compounding CANCEL, so only
non-conforming clients are affected, and the read itself is always
in-bounds (the response header is fully initialized).

Read the request header for the compounded case.

Affected version/commit: mainline fa4ad798f6f681031775266044ba1b0cf3c670bd =
(v7.4-rc1, 2026-11-07), fs/smb/server/smb2pdu.c:10515-10524 (smb2_cancel).
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
index b084cca..36c5a40 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10521,7 +10521,7 @@ int smb2_cancel(struct ksmbd_work *work)
 =09struct list_head *command_list;
=20
 =09if (work->next_smb2_rcv_hdr_off)
-=09=09hdr =3D ksmbd_resp_buf_next(work);
+=09=09hdr =3D ksmbd_req_buf_next(work);
=20
 =09ksmbd_debug(SMB, "smb2 cancel called on mid %llu, async flags 0x%x\n",
 =09=09    le64_to_cpu(hdr->MessageId),

