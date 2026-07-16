Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FDC3D301D
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 22:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784240070; cv=pass; b=gkKY4diy8rj5Ol7EOmCPbFYwTz6iY+IceAFMKNDPslqbiI4Ko8wjhjLsFEiUzCc71LFara0X6hugzhxf6M5akH8Qja66bi8RDA66+63slPrzqRt7pptsyVyynMDvPc594XXttfdiFrNOHEYJ+XSqhg+EWhZc4U6lhZ9JMtduGkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784240070; c=relaxed/simple;
	bh=myhKaUMIB/SAY9LWOk9DGB2++bgQB3tvRvN2YEGzvpk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nuZaDvVYjwxCnNPQUqMBQdr+sAzzZJ1sLBaj6mbHhOj46VPXT1qHl5oTWV3vCMK+iETWmdbz+BHZ5xFCzMhFt8Yq0ve9yLsXVyz7i/EopdUD9MWEl5fpC0L/FfPQDBdW7E4l2gCQDrwgUlja+5dpVI6XDZbIVmngsKmnvP7m2ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+Ht0oXe; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+Ht0oXe"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81eb41c1f1aso52531347b3.2
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 15:14:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784240068; cv=none;
        d=google.com; s=arc-20260327;
        b=pSGaEqhQM9y3if5utPUseSxHKEtnFJJbkrHECRn5AHBEqimmhbJOQflk/rBHf2C3Sk
         J9AQmGWncx+MbHZ0fCIzZJSsr8bIeecNDoEEqPNhAIhjuF6nzuKUdrYcBRaslpXXyQ2p
         BI0xtts4xHZ8uo2unzkJy2a7FPhKa4PnjZ2uYcuFco19KtwBulAPqdgu1zTpoPQVhxQM
         qTfZHtQXHr7p7VOG75BjumNNxRBAvq2fQ4bgAFCq7XjQ1OCLQPE3+YD8C2bZqFRyIXtx
         O4B/36d04Tsrq79qs5J1r8s+JblB08UJw2DYnp1O2/KAr4sGWv+TX4jkz7HzgV6+gjRs
         3BMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=myhKaUMIB/SAY9LWOk9DGB2++bgQB3tvRvN2YEGzvpk=;
        fh=qPdn3nxQgygyQjJTDEl9+ZhpBtTWrqIbsZA12qELXjI=;
        b=jMA5bkgSKWoS+VaC5jV0qbxVuv1XJMtv9xmu6rDYu1arb/tLKbPsEmFMihlr0jlPAX
         sZGj4D/sRcZr7UfNg70hLCTlnQUWbGUMTDlQzDd87gWIX5L4m1BOBgNYSqbS9GEdKYB+
         B1yo0CBjR8l04kLYf0z+6Ga3SMzR4B/MiEcFVnyyfYkWfQDX7HLepe0BMmBy0h11QDLl
         /SFxDJZaJn1iaB0Eqhw+uyqWBoaAtGH77z4vBXi1OJbAXcnGOx4kEpefpTKqRq964JtA
         OA/emZX6kE4MEt6OIz5Nf1z+mxkUtOI4hSdwXFq1nQ/nJzog0n4VqxgN8koyG+ggvBLf
         HrQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784240068; x=1784844868; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=myhKaUMIB/SAY9LWOk9DGB2++bgQB3tvRvN2YEGzvpk=;
        b=V+Ht0oXefNC+y30mT+NNnh+H54Seb1cO2SeyrwGd7uAI8MBvDM78q1vA0IzrAgidWJ
         KCjnkZcMFVWhdoypMIk66TYfgXwrWtk8DUP0WB1mZe2rIWJ/zcVLh6eOvb2kU4prMKlN
         loqm975XI7/TT/+KOUtK/l7aHGx595FGx+51ypgeHGxvN4Z40ZRO2qJopP+43QLQOja4
         F9KsdfiJ+/aR2ebVh1YfqFFZ/syNA0YdcrQN2/5lRCoX0t2qM0KnTeMIidb8svG04bwQ
         QRoJMxmRyFn7wN5Zy0G2RliFKqzlHvzePtMMpUOT69eJhSG7zvRfSrRnH20DvAZpC21K
         0bkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784240068; x=1784844868;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=myhKaUMIB/SAY9LWOk9DGB2++bgQB3tvRvN2YEGzvpk=;
        b=TenWesZPsZob2irZX5oJQWjsh1WjtJ63OYRwpr9tz7m/bocIHp7hw3wb9u2KDfstr3
         EuzuyJvPSM6prgv8W/GeWOdY6gGte3EEs2u/7u3PVpX/CykzfnmIsBQDvN7EQdInGRqL
         DT3gCwCNQrmmhp/vsvSDvtiwn3f21xQDbQEUAAzzjcSahSZNJdhAggrlQQ1o7gG7orFx
         Fae08Why3lHUhlA4dkQR5xshLA15B0Y9wYdpHJK68gk3CUMnMgjXrEZQrOCcYK6fa+bR
         MufVW6f+1gsBjBgPt6mKNlGnnGrh2UPTIUrAUXW3Ycw/85goi9h+JmwTh6Z/1oN2hMQB
         cP2Q==
X-Gm-Message-State: AOJu0Yzsn1ef59UdlpAYG3oQxMdifghR/4nJ1T9gjDtXE9u8zxYcMu/3
	QTOv2ONASXfTbO/rpNl0aF7fHZfPVtaGx9VAgQySdYpsXpkhJDY9SP7MVJP94AOx7KvTQ9Rd9Tw
	XkQA6vFUg9jw49jJVBJP2XmnvzXtybXjCNj2U/Gi6sQ==
X-Gm-Gg: AfdE7cnPMy5ccv4CBwIg2UwWIMPC8lkgi+WEC5yTFe3VAL9DpIUohpLCAuDgVOFpS01
	/eeyfPhMWxMBpdFUiHI3TGcaPk8CDH5kz0j31PFe55ZcSswatJNCfGRVFuiOgnhIU8lPVDwTNBG
	bnH0Up0arSw5fyMXmWWcy436c8LzQ+6Ad7jf/qhR29RY9Yjz2rJGZLysyeAMWJ2RKRz3LA2PP6F
	hj7oG5WT8GCAxTImU6AmyAgwtfoFGY8wtxU16u90jKk6RUUoIcwt9cJKhG0ThPVoRkcDU5MndXY
	wQIR52NmTxSTU0b2Gekv/VYTyS7pNNrmBTT+uBv535c=
X-Received: by 2002:a05:690c:6806:b0:81e:8985:e10 with SMTP id
 00721157ae682-81ec00bef61mr101676987b3.68.1784240068157; Thu, 16 Jul 2026
 15:14:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Charles Research <trilobyte777@gmail.com>
Date: Thu, 16 Jul 2026 18:14:16 -0400
X-Gm-Features: AUfX_mypoePVW_V9QEiNQmkROFTAHb_Qou2Cg1fczmyjiuu3ym2vKwtlkHGCPzs
Message-ID: <CAPS2u-U8ac6JfgFGyWLruCCe5f_Dvk_BRu64jd9Lue8LiOsZbw@mail.gmail.com>
Subject: [SECURITY] ksmbd: unsigned request bypasses mandatory SMB signing
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello KSMBD maintainers,

KSMBD decides whether to verify an incoming SMB signature based on the
request-controlled SMB2_FLAGS_SIGNED bit. An unsigned ordinary request
can therefore skip signature verification even when trusted session
state requires signing.

Affected Versions

The vulnerable gate is present in the initial in-tree KSMBD merge:

Commit: e24c567b7ecff1c8b6023a10d7f78256cef742c4
Release: Linux 5.15

The issue remains present in Linux 7.2-rc3:

Commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa

I therefore assess the source-level affected range as Linux 5.15
through Linux 7.2-rc3.

I dynamically reproduced the issue on Linux 7.1.3:

Commit: 199c9959d3a9b53f346c221757fc7ac507fbac50

I did not dynamically test every intervening stable branch.

Required Conditions

An authenticated plaintext SMB2 or SMB3 session that requires signing.
An on-path actor able to modify bytes in that transport flow.
A victim request already authorized for the target operation.
A session that is not protected by SMB encryption.

Observed Impact

In an owned disposable KSMBD test environment, SMB 3.1.1 negotiated
server security mode 3, and the client session had signing enabled.

A WRITE request carrying SMB2_FLAGS_SIGNED with a deliberately corrupt
signature was rejected with STATUS_ACCESS_DENIED.

A WRITE request on the same authenticated context with
SMB2_FLAGS_SIGNED cleared and no signature returned STATUS_SUCCESS. A
subsequent signed read and a direct backend check returned exactly:

UNSIGNED_CANARY

The server also signed its response to the accepted unsigned request.

This demonstrates that signature verification works when invoked, but
an unsigned request bypasses that verification path and is processed
using the victim session's existing authorization.

The demonstrated impact is same-flow integrity loss.

I am not claiming:

An off-path attack.
Recovery of the signing key.
Authority beyond the victim session.
Code execution.
A bypass of SMB encryption.

Root Cause

fs/smb/server/smb2pdu.c:smb2_is_sign_req() returns true only when the
incoming SMB header already contains SMB2_FLAGS_SIGNED.

fs/smb/server/server.c:__process_request() calls check_sign_req() only
when that predicate returns true. Otherwise, it dispatches the command
without signature verification.

The requirement to verify a request is therefore derived from
attacker-controlled message state rather than trusted session or
channel policy, such as work->sess->sign.

Reproducer and Retained Sequencing Detail

I have a tested Python source reproducer using Impacket.

The reproducer:

Performs a corrupt-signed rejection control.
Sends an unsigned WRITE request.
Verifies the resulting backend canary.
Contains no binary-only components.

The retained test result records MessageId 6 for both crafted requests
because the harness uses Impacket private internals on a single
authenticated context.

The accepted unsigned write and the source-level defect provide direct
evidence of the issue. However, I am preserving this sequencing detail
rather than overstating the result. A fresh-session or
transparent-relay rerun would remove that ambiguity, and I can provide
one if needed.

Because AI assistance was used to review and package this report, I am
treating the report as public and am not attaching the reproducer to
this public message. I can provide the Python source and retained
evidence privately upon request.

Suggested Fix

For every non-exempt command received on a signing-required plaintext
session, use trusted session or channel state to reject the request
before handler dispatch if SMB2_FLAGS_SIGNED is absent.
If SMB2_FLAGS_SIGNED is present, verify the signature before dispatch.
Preserve protocol-defined signing exceptions.
Preserve compound-request behavior.
Preserve multichannel signing-key selection.
Preserve encrypted-session handling.

Regression tests should cover:

A correctly signed request.
A request with a corrupt signature.
An unsigned request on a signing-required session.

Temporary Mitigation

Require SMB encryption for sensitive shares, or place KSMBD traffic
inside a protected network or VPN until the issue is fixed.

Mandatory SMB signing alone should not be relied upon to provide
integrity on affected KSMBD versions.

I am available to perform the fresh-session rerun and test a proposed
fix in the disposable environment.

Regards,

Charles Vosburgh
