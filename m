Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908C531B821;
	Fri,  5 Sep 2025 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757085233; cv=none; b=KyaKo77YrKHgXi2ZKWA+YhlQEpk6zHCYHj9WV/xSNxNRtzTZClMM+40aojMewOG01URVAstgaRuMGSm3I/JaYJ2hJwI/zPYYtOOcYTMlJD1CKGpg/B9Gti6X92jY4/HTfexslYtD0ENjP8W+C5gYBLkE02ORWpFFLXMDsxsG7KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757085233; c=relaxed/simple;
	bh=PL7hTAbHxx1GFQPp1bYDbVDS1r6pAvij6AelNcKpouQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=CUAS5y9xNeJH6NZqNcMzSK2L0/my0hFgJRJyJoycZnS8ecFLbbnu53R/iDMEw0UfbNm2AZGY7Mqu84M+OT5Z3o2i5ZxQ5E0M9N43n/1jbwfAxHTfvfI9fAJoogbvwSliNxFGlqzrcWfzCkw5ISAFChSSJVAzged++4wyXUjS5TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FG0bxonK; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FG0bxonK"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-7251e6b2f9eso12778626d6.1;
        Fri, 05 Sep 2025 08:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757085230; x=1757690030; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NY8Lfy7SqIS0lJbRILVYNO0QFw2aelqYzlot2BlKOgc=;
        b=FG0bxonK6yJT4rnPCqlj7nRZFnqRxBDPsUIQd0C/gULjTbzEH2RDuZ8yFNVdcdaMRV
         gQg7bzplpGW/kDPOIEyWH9ituIA8FLQJK4kKrKtk0Opoov0eS8EZ78TcEjl7y0TObBwe
         Ecd2FQ0Sg3nyMqbCwgD01bBHzvWxBQF8OFTtGjRCbywqh2GxX3ACnyPpbDgdGp+0snRK
         8U3xLoXQOzDC4oUBjWzM4FTXKjX5Yz5azjSceQ/hMleK6R3TWvXZnQHlBVvNpASPQvho
         AoWXZenQKLNpCTROQDYkFj4FiNeKv3+uaA+ZuKGyUZWZsJVJSdkECpJ+e0089DZNrtxj
         bcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757085230; x=1757690030;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NY8Lfy7SqIS0lJbRILVYNO0QFw2aelqYzlot2BlKOgc=;
        b=BV6GgQogmvH6javuAw7dE9D/zWaImACvp+mcu7CJDRq8ilhsmNXdWXbvKQxViRGiXb
         iWTq2sZ50NayzwpH9Of22LlbwfOPAGLxtaYnQP5CJq2wDSaFAXHtSVCjh2juV8YGllo3
         ofx+YrnDy/uZnokUc6csJN0dpi75d2+m/hFPAbXde1jMJ2tdluVYWR7jVikB3vYVd+IW
         KkQkOpLxEIvu7fbdO1X7atZUojGqX6EfWsZ2C0/eUtpGQFEmoMNZpTnp582e//Ctj1vI
         4pEBAHmQy2/boC3C5COWzftuC0LpyCZfW3x9zajjYvlEXM813o3uz9qitxkfrNBAekoK
         Rrpw==
X-Forwarded-Encrypted: i=1; AJvYcCV+i0Cv3HLE4BLdDsa6OqIhmlsh7X1UEp4tAFuz2ZX5RXols2P8MHCdCqmWVHeoii6gHp+fQMkogDvQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzoU9jEJ+l2WfHaZrFZXxkaCFGZEZ2KGgqJ1jrUZTjUV1CLrFxw
	nPmZtPfWOgtYaHXXLvz1rHsNskz9IiSXWDFUFI/QiQMUd4Quzou2TQhhv/B+Q0P1Whbxu76uTub
	MByiGX+xb9HwVsL3toTQkrWb1EKoPLRjbJjrE
X-Gm-Gg: ASbGnctf4lMJ8qpPHvnAc/k3ybnDCSIsx0tcXuxHQwQcZEE26G+2a7YF8KDoHKmbeBw
	EE/qOcztjEe6zgSbMl35EC6sHvdokmShsoGdcWMlo1SPwEqO2Q3fwadxUAg7jEcQlWnTFcyqKLN
	lhaOj1T6lLscuZcCLAB1MlEG/MUU5SrRz2IttabdtlpK15opH0S1kHSSXQwTWShSjg2ow8S1SxD
	k60roWxAXHqvj9kfzU4+Raluft9CVlla5xT3fp9vqG12zo8Nnd8BTVE0TiTj6y/pO4V1cUP/z18
	EvLlmFAFovh6kgE9q1PDpKRkhL3FAOnDBytkGiD6rvB7ve+H+rDjnhzR1AMrLzj8PW7Obhtt76j
	5
X-Google-Smtp-Source: AGHT+IHNr2BUKWWVMLqOlzRAyiVe6hQV3iBCRctBkVxa8aTmxHW1Q+lpHnooiEtpp7iQbhltKkAI/WvadDeq1v1s6M8=
X-Received: by 2002:a05:6214:4017:b0:707:3cb1:3fac with SMTP id
 6a1803df08f44-70fac740196mr250211506d6.15.1757085229765; Fri, 05 Sep 2025
 08:13:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 5 Sep 2025 10:13:36 -0500
X-Gm-Features: Ac12FXy_-lRQS4tDhcF8BA6vot_f3k_vJdDFAPk11gOQPBz1P6Z50lE-wC-niHA
Message-ID: <CAH2r5mtA224oMgWCMhxo4xH_8GVziw6dUWY7zG+0WaRm6FzV+w@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
b320789d6883cc00ac78ce83bccbfe7ed58afcf0:

  Linux 6.17-rc4 (2025-08-31 15:33:07 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-RC4-smb3-client-fixes

for you to fetch changes up to 70bccd9855dae56942f2b18a08ba137bb54093a0:

  cifs: prevent NULL pointer dereference in UTF16 conversion
(2025-09-04 11:43:31 -0500)

----------------------------------------------------------------
Five SMB3.1.1 client fixes
- Fix two potential NULL pointer references
- Two debugging improvements (to help debug recent issues)
  a new tracepoint, and minor improvement to DebugData
- Trivial comment cleanup
----------------------------------------------------------------
Bharath SM (3):
      smb: client: fix spellings in comments
      smb: client: add new tracepoint to trace lease break notification
      smb: client: show negotiated cipher in DebugData

Makar Semyonov (1):
      cifs: prevent NULL pointer dereference in UTF16 conversion

Wang Zhaolong (1):
      smb: client: Fix NULL pointer dereference in cifs_debug_dirs_proc_show()

 fs/smb/client/cifs_debug.c   | 31 ++++++++++++++++++++------
 fs/smb/client/cifs_unicode.c |  3 +++
 fs/smb/client/reparse.c      |  2 +-
 fs/smb/client/smb1ops.c      |  4 ++--
 fs/smb/client/smb2misc.c     | 19 ++++++++++++----
 fs/smb/client/smb2pdu.c      |  4 ++--
 fs/smb/client/trace.h        | 52 +++++++++++++++++++++++++++++++++++++++++---
 7 files changed, 96 insertions(+), 19 deletions(-)


-- 
Thanks,

Steve
