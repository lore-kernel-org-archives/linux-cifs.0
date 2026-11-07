Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794013242;
	b=BdkwXZN9ROZlNjg+a9QPSG+shEY0nqoAtyU4PWxXNGhJhdx8i0KIYl5sK2IdQ2u3wtxI
	 PV0NmvlNaVfNCTjThxTOVm6KTqwnYVUDT9e7PPLRXxKk0oR/0ERLG8GgBOQcESbtgFvUm
	 8Uly+apqWQbeXlPTm2Zpv3XY8p0JPBivvNqo450i2waSljmD8/4x3Qprk8q4MtW0TIOsJ
	 t0k0+FfWuUcCV33EkDFrmgnh+Su2+p8EU5QI2mSMWCjZbnHG0DIJkj9lIj9Tdd20T9Xhm
	 FnZRdi92hnyaPARrDAQ9eO2unEXFM0/4xweOQvZHgvq+aJZR1wRR8TIF6+2ItTzkV2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794013242;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=rX3dt3npfjCBRiFO2ZJE7jI/T3g1vybPaoDbYeiD6ok=;
	b=idFnJnJ8Na9O8vPvk1fIc0BCDvuOc7K6MQ3rBIJomiRTS6jKzOMv02HnIwDsVZr4DH8m
	 z7v98ln2GdLMCfYKtwI9QrUR4ZvO0lQ8k9SqWW2OG2h8QywXCXekPJf+/+kKE9SHGGIBj
	 Gh7rC1nBq2rui+xDhEl3zKTCCGTPB8Kckz/D5twuOuqGTNnCpModP2btDSd3kSSD2EA1d
	 QqsIgeHk5WMxHYZOUKT4d2jRZuk1ejo6o9piodtvZ39gO32M0ZLwsrltchpWdqgv1uMK4
	 FG8ziZs/gX5j7PAcN4QfCvJOv0KxA0BSQ0EZ2bDTsiiAR4FqNfuXInePvefDFBaDW9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d3yHP2JO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C1B606A32C
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 01:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d3yHP2JO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876551F008A2
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794013241;
	bh=rX3dt3npfjCBRiFO2ZJE7jI/T3g1vybPaoDbYeiD6ok=;
	h=From:Date:Subject:To:Cc;
	b=d3yHP2JO6WcYB5ECniH/Z3ajdcIukmTIWayPDX0IVVy3pbzvVOmhqguCOOCe1tHDN
	 2IFPLI+phFK/o+5DXeB+mG2BXF3ng7GpfrWoWjG5EcAOh0jINJOFDKMmwJAG+GiJXm
	 Ub8KpuAZGdSeRxPc/oTHoc72Vv6kEm9h7NcfEHJa0Z97mpGjNdLfYkc4hYJadQK1Ox
	 pIM2RX/QCfXWmAQ+f0Vn6hUdlOz2f8bnlezxwSmtzweG76qOw09PzyWf0i5Ejnjr2Y
	 ZRCZ4KzwPSxxIOxx8D01PdxDPjKIReV8OcH4mR8r6Bd+3a74jDRvK/GoNeA1I9V+RQ
	 iVkQh6uiVmFow==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d21051042so167780266b.0
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 17:00:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwA/UtaLBqdZbGOPuT61tVLIYH50FMWg7O1DcGxBrGWAPxDDdYyOT2K5wSGFpo9on+HKGw5mJZSF49g@vger.kernel.org
X-Gm-Message-State: APuU4Z+Q8Ah8yhu84QFIziY5uIP+2o5ucts9WWalmZn3b9FH1hzWtZeD
	1UzIXW7yxQ+1gAN2ZjAstUeSZDFwIYP+ZaRLkbWHl4w5Lh6WGurhAZbDp3qK3ala58eEqzr2E7H
	1tiJfroHRDFgWJwoflLeoY9ue3uEX7qg=
X-Received: by 2002:a17:907:3d88:b0:c4d:2cb4:7bbd with SMTP id
 a640c23a62f3a-c4d35641f5fmr284955466b.47.1794013240162; Fri, 06 Nov 2026
 17:00:40 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 7 Nov 2026 10:00:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8CGBxMC5oBkw=H6F0rQh5ScxOeZMCEmm5pW+rPvZvVkQ@mail.gmail.com>
X-Gm-Features: AclHuK8nsNlxYXrTqRKm2kKEiTZ4_yKdcnFTQjh4A4ee_ER4zIwIi6CiQ43aRd0
Message-ID: <CAKYAXd8CGBxMC5oBkw=H6F0rQh5ScxOeZMCEmm5pW+rPvZvVkQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes for 7.4-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus,

This is ksmbd server fixes pull request for v7.4-rc2. I add a description of
this pull request below. Please pull ksmbd with following ones.

Thanks!

The following changes since commit cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a:

  Merge tag 'power-utilities-2026.10.31' of
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux (2026-10-31
15:05:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git
tags/ksmbd-for-7.4-rc2

for you to fetch changes up to e49296d51ccbf2ad0ed0484db1382f1d7217bd6e:

  ksmbd: require NUL-terminated EA names (2026-11-03 18:23:33 +0900)

----------------------------------------------------------------
- Validate EA-name NUL termination to prevent out-of-bounds reads in debug
  logging. Return STATUS_EA_LIST_INCONSISTENT for malformed EA names in
  CREATE and SET_INFO requests.

- Grant the owner's implicit READ_CONTROL and WRITE_DAC rights when no
  ACE names it, including MAXIMUM_ALLOWED handling, while respecting
  applicable OWNER RIGHTS ACEs.

- Check group membership before granting permissions from a POSIX ACL
  group entry, preventing unintended access when a caller's UID matches
  the group's numeric GID.

- Avoid reading past the DACL when logging an access denial by printing
  the requested and allowed access masks instead.

- Handle unauthenticated sessions in procfs reporting without
  dereferencing a NULL session->user.

- Fix credential cleanup on attribute lookup failures during durable
  handle reconnect or request replay, preventing subsequent requests
  from running with another user's credentials.

- Fix read-only share handling for named stream creation, including
  AFP_AfpInfo synthesis on Time Machine shares.

- Validate DELETE access for FILE_DELETE_ON_CLOSE opens, including
  MAXIMUM_ALLOWED handling, to prevent unauthorized deletion or
  delete-pending states.

----------------------------------------------------------------
Ian Bridges (6):
      ksmbd: require DELETE access for delete-on-close opens
      ksmbd: enforce the read-only share flag when creating a stream
      ksmbd: revert fsids on durable reconnect and replay failure
      ksmbd: do not read past the DACL in the access denied debug message
      ksmbd: grant a POSIX ACL group entry only to the group's members
      ksmbd: let the owner read and change the DACL when no ACE names it

Jack Blessed Kimani (1):
      ksmbd: fix NULL pointer dereference in session_user_name() and
session_account_type()

Yifan Zhang (1):
      ksmbd: require NUL-terminated EA names

 fs/smb/server/mgmt/user_session.c |  4 ++++
 fs/smb/server/smb2pdu.c           | 34 ++++++++++++++++++++++++++++---
 fs/smb/server/smbacl.c            | 43 ++++++++++++++++++++++++++++++++-------
 3 files changed, 71 insertions(+), 10 deletions(-)
