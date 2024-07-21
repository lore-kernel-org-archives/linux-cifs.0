Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F62F168489;
	Sun, 21 Jul 2024 19:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721591331; cv=none; b=cFsXGRPmoUDv/C7EqIyXx4KNdUMQEiGpZ1QKVyfnJ+INvg0SP5AKFcr+sQr6jRLibFXq4s00aHTIglXnpYhuk6NZsW7FovR9hYMqKUYlCJffDZ5UCFmxeRT9n4jx36iEPefBoJ9912gfYVQWatkm/BJFXk3r7LY8m1RtTWsKcTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721591331; c=relaxed/simple;
	bh=30as8Sz/8gSN5FhacKSRbAJZoo1ohmwxGOzwb3Y7yFI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=joc2nbD5oAoZOaCM/vr7kBovcHQXCPcxzI3QqWFPg7iEQ2sMCkguTFr7CKA2WWC9xZ166uZpkJPUbRQPJjE97gtD5Acdc5/gkdyNM2HsrOgg/pbqONfh1Jl00I+7K+nkicfY/DpIFO9Clt9cYK/28PoDvDLCgdtmJF0jsmr2kmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eyHhbUNH; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyHhbUNH"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52f008aa351so869370e87.0;
        Sun, 21 Jul 2024 12:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721591328; x=1722196128; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p7n1MTWeeiqkGXdo3+0zlmWH1fQltcN/tXEmUFSC7w0=;
        b=eyHhbUNHo81L3F1kLujkf4TUeI2/ilrwp5rXk4Yhhny8gA+6Fdd/lNB+U+Nq64ER2f
         NTs6rcfg5RWaDkIsmDUjG904ao+fEQ7F5mE+PCJSUxyJOIhRzUnOOTMXu051p5dgumaq
         6kDtb6Ez7CEIUZhK57ulBIC7OIuOolDmSr6iJfjU1/VC+NAYw/Fmixu0ANZbRUFNSdYh
         ausXONnI5WhJj9qBieh/90+9w4/TiAjPNzE9KyKAhuMgVqPitRjw8OzR5FrAS1V/9iKj
         uHrg4omumwDEUTbLa9ZW+an7RseAkTFlh3Hbg9ZS1rYcpRkVWZMf1O7ZCmyXfw/TBpN5
         XWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721591328; x=1722196128;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p7n1MTWeeiqkGXdo3+0zlmWH1fQltcN/tXEmUFSC7w0=;
        b=qmaR/6fQViM0J/ShAqC+vB5B3pepeoOhbpXkDextOI/ZZWGumYB/Cd1vExYcChrisj
         UYaGMzv/AWNjjfE9U92vSoFkS0ZKHUzbI6AysovqYx54g2Rv6ChD+m5wlJCW3AnxSZu2
         qtQp0N1G280n8fwc06AHcSH9qB87qVpbDy9L8sZOl1wX2UobG2emxuOYQmIyKyNQ2M+s
         KnR+ZgwR9slSAk/KIwWut+WZpOwtiWjsfupzu7oI26i6J6jLJRPLqSnXXJewFhWudzoG
         9Ae3VHbZYExvvnWGwxg3PWLiSfVgoc5YZvrT3bzmS6CGvsM7Wl5U/m64o+4DMQiL/1Aw
         /t9g==
X-Forwarded-Encrypted: i=1; AJvYcCXfHOzss7HXDAi6qj2TLH97iW9YhKEtaSrf+XwbFqjWdc6qyURA1us5dxh37fNMr5K9teM8snG9K0dtBPbr0yDu681F0Y1kvKOjKQ==
X-Gm-Message-State: AOJu0YxIKIn+qelGdLSE8gM+b7eiqTFlqAWUeW+xfcse+VrgwzdlSBiY
	/QvgXIshv13NVbevZzV+9Be2qAqR3mfOypLmUTkyOwcTMbQcUDAOfrs3ukqpVw+OVKmMlNHXuzX
	RcZHuNN4aWnFlDuba+sX846hSzOYjfMZt
X-Google-Smtp-Source: AGHT+IEqDSItIujOuXcC9pEBhiaaY3A48D84X56rTHa6H4HlbaPPT/Fgxk+CyId2KzBefieWteed28EMY04FR7Wb7N0=
X-Received: by 2002:a05:6512:1308:b0:52c:9421:2739 with SMTP id
 2adb3069b0e04-52efb522685mr2567121e87.9.1721591328221; Sun, 21 Jul 2024
 12:48:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 21 Jul 2024 14:48:37 -0500
Message-ID: <CAH2r5msA=eLHHR14qDo8opf13yGiSKp9D=hN2WzY8FuKPhNvog@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
0c3836482481200ead7b416ca80c68a29cfdaabd:

  Linux 6.10 (2024-07-14 15:43:32 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc-part1-smb3-client-fixes

for you to fetch changes up to a07d38afd15281c42613943a9a715c3ba07c21e6:

  cifs: Fix missing fscache invalidation (2024-07-20 13:55:29 -0500)

----------------------------------------------------------------
six smb3 client fixes, most for stable including important netfs related fixes
- various netfs related fixes for cifs addressing some regressions in
6.10 (e.g. generic/708 and some multichannel crediting related issues)
- fix for a noisy log message on copy_file_range
- add trace point for read/write credits
----------------------------------------------------------------
David Howells (5):
      cifs: Fix server re-repick on subrequest retry
      cifs: Fix missing error code set
      cifs: Fix setting of zero_point after DIO write
      cifs: Add a tracepoint to track credits involved in R/W requests
      cifs: Fix missing fscache invalidation

Steve French (1):
      cifs: fix noisy message on copy_file_range

 fs/smb/client/cifsfs.c    |  2 +-
 fs/smb/client/cifsglob.h  | 17 +++++++++-------
 fs/smb/client/file.c      | 53
++++++++++++++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb1ops.c   |  2 +-
 fs/smb/client/smb2ops.c   | 42 ++++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb2pdu.c   | 43 +++++++++++++++++++++++++++++++++-------
 fs/smb/client/trace.h     | 55
++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/smb/client/transport.c |  8 ++++----
 8 files changed, 191 insertions(+), 31 deletions(-)

-- 
Thanks,

Steve
