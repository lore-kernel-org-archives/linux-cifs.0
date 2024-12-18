Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B231A3A8A;
	Wed, 18 Dec 2024 23:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734565271; cv=none; b=Zm/rBdcDDBfGxvzjWl3CyKR5aFdcHiHV5tpxvd478N9Xf30HtW2SRyG9F4D5WatbsrDwe7389yzDZOIv98hjyAfAunYZjjPHZEGgEaQ0TFV2TWeducU7LrJyq0NfdBN2UB0Sak1BqmvPrAu28bKsGOtFNeKkROISc6qAHrV5Mjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734565271; c=relaxed/simple;
	bh=HXCj/+HiTM+8izk99J1VFko+gJAk0Pq6hf+nMvvX8NI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Iv+tgrMOPrb5upxxsiSkndpPyQ/7rOlCmj+D6yjf7ClwDhpNbiLLLaos0L9mjML/0CGrx8frABgCJ1gO8KUMgSjSHP57RJybhN4AzZZwNZBEwwY6JIuZPdL0FVU7PRbLpI9bu6/vYXLELQw75h6wv1mr+qM2zSvW4unV95prRps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eR3cAI7l; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eR3cAI7l"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53e3c47434eso126444e87.3;
        Wed, 18 Dec 2024 15:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734565267; x=1735170067; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MrtX6X5vXAcaMBwNZyU2z10NHWjiZy9DO5f6NVtav3U=;
        b=eR3cAI7lWQUqOlseodd76nlk9jQ2YEeiZbsAJEXmMKPrxpOu1tOtWSQAo6twFWS/fx
         9vccQiNYecUOiBKsCLT4+NA/HzmTYwgnMd7IiG6sUUePTnX06XmfIZp6AiAD1yJTSzZq
         gUoq6947eFKmjBgucJVH6fQC/ErlTgwgjqsjNgBmr1HCRfNzWiG6OOl+IiqREz+el+rG
         09CqWEW5V4Gby7c1ILMRwvMDiq0oZt2eK74Yx2l3mmTuz0Hm2DeU/NXBNqbfz1V0Ioxo
         qrrkTh+MUev+G7MbYocqeKEZdw59lQh8AmxMWrHH3PllBvfBYH6kK1YYd/M6bM7LzNwE
         oVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734565267; x=1735170067;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MrtX6X5vXAcaMBwNZyU2z10NHWjiZy9DO5f6NVtav3U=;
        b=uQjaq48IF03EmYGh59kg60FtleGVDGmYTt7nVEy2wDalFFsQ2zKSqBIJ4UL6Al+7WS
         6d6XnOx/vhx2kNGdmo7yCmmRVkG/z9zDamixh4Mc3U014g/eOhM7DiVvYXqu1LLlKNPF
         agvfHIePDzxS3Rquz07Z+9YHQ5LU4kmziaMd3URCa6mq9eKHCJhRAnf4J3SWq1JfzlYy
         ozKM1k/XEet+cJ/DExmzCvCL9XM/8ofetL527azMgG+cAcaiTs92B5mfQPgSZ3XmxzCR
         7meF1uYpyoaXlbrDJTXy8jM4EZLxlpxLo6lj/Y9mS4WMpcqD94jq5ubVnvzgypxlZ7IK
         Tycw==
X-Forwarded-Encrypted: i=1; AJvYcCW8xRN8IgR0GizC1kK50vlFyOEwdo3sR73pQZzDcsPBthSJVkstI2xGLkhEDkAFeEdER5h8PAGuds1T@vger.kernel.org
X-Gm-Message-State: AOJu0Yw68zTC7olti4/Qau4COGU/CrP42Zi4dbcKD//HZN8MiboH/P4H
	dSF0jaUwNRF1TWk96XSes4c0XCFRzIH3Qp85lDgtiQnqyA963IZqczoxX4HzzryrTjSyCnDcKIF
	OWa/KVN13PsrtITxz6SjLFve8XxM=
X-Gm-Gg: ASbGncu8CNIM1nvpOxvyejRQ2KvutDjv6+59Y64fel3p+VJJQ0RanrHJ8d+0JWq6a07
	8ooGndwRM+Fqsjs37f49V0P+xzW7O/pEzf9ySKxN/4VB/U4dI27vDsNRm5tiR6hrhM2X9m8U=
X-Google-Smtp-Source: AGHT+IHKuPY+MeBUOCVG0v1nJPNrOOoDTp6QrVNA3E1A0Bcx1dYdEwONH+wvobS/rO9i7W8vqwfXh9p922sq6Dc2R3k=
X-Received: by 2002:a05:6512:b9c:b0:53e:39c2:f032 with SMTP id
 2adb3069b0e04-541e674c53emr1624982e87.14.1734565267206; Wed, 18 Dec 2024
 15:41:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 18 Dec 2024 17:40:56 -0600
Message-ID: <CAH2r5msORKXoRLDHnu8H62W7ryRf2AdV4b-4R_3w=ep2g+yzsg@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8:

  Linux 6.13-rc3 (2024-12-15 15:58:23 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.13-rc3-ksmbd-server-fixes

for you to fetch changes up to fe4ed2f09b492e3507615a053814daa8fafdecb1:

  ksmbd: conn lock to serialize smb2 negotiate (2024-12-15 22:20:03 -0600)

----------------------------------------------------------------
three kernel server fixes
- Two fixes for better handling maximum outstanding requests
- Fix simultaneous negotiate protocol race
----------------------------------------------------------------
Marios Makassikis (2):
      ksmbd: count all requests in req_running counter
      ksmbd: fix broken transfers when exceeding max simultaneous operations

Namjae Jeon (1):
      ksmbd: conn lock to serialize smb2 negotiate

 fs/smb/server/connection.c    | 18 ++++++++++++++----
 fs/smb/server/connection.h    |  1 -
 fs/smb/server/server.c        |  7 +------
 fs/smb/server/server.h        |  1 +
 fs/smb/server/smb2pdu.c       |  2 ++
 fs/smb/server/transport_ipc.c |  5 ++++-
 6 files changed, 22 insertions(+), 12 deletions(-)

-- 
Thanks,

Steve
