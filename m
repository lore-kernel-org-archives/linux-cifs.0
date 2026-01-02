Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0500E21B9C1
	for <linux-cifs@vger.kernel.org>; Fri,  2 Jan 2026 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767364639; cv=none; b=syqIrpxBQBnyNhvKLvFbjlws7mgNCsuHggk5cJWWK842Irj9Bie61Xo4VfQ+tv8UT61+xysGPqFZSBpoiTxtF9oGXxxjt3cGEPNRLPNwfD6yuJP5SsFpC2kFSCIhQA5LQMvbeCUgCqqEZSQM+Pw4Monu8UCOSM1u0y9NmToR+Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767364639; c=relaxed/simple;
	bh=/KrYmvFUpydZv2ktL2TLJkEEJAUF5MVRH4Zva/Z2G0Q=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=aw1ob91ann1cQclXR8NVayWkcokQ2IoNbq9pqL7tpeom9RdkRQK+OpmX1NrV2eWH9jacFjHhFCkqBsKeke4LFv/O0l552AwEjxjUQZ84FVHa4JwWKwAKR9DjKniww3qqYfRHBeYVSZkGJWIg5jCo4ukCVE7Ihy3zVqN0naazGzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=axg3nR7o; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="axg3nR7o"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88a35a00502so125155846d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 02 Jan 2026 06:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767364635; x=1767969435; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jmpSJOVIFg4M2aacWsc9e3hmgzuy+9LOHvIW6f6DhhE=;
        b=axg3nR7oUhgwZFamBHR64i89X3s2/60rMvw5tXIQu9cYfJQQtaQdU4WR8geT0kSma1
         5RS9SW2CJs6VNbWcKkyuy69jpXr2nJ+8rrCjz1jBmeNpcBcEzTg7GGSBOicbAK74vN2/
         fsHXdIYrOTDNS7oA/blfxm2EJkq8BfYxsKZ10NTlSwH5EZtaABAQoAw8fmIZCxAnOdSR
         iNg+xGbx7gnsK/kOTIfNxEJswT6mou+P4HEvkKdlTQv0UIyVwk/yg/fNPFHCK1OpPRbL
         90j/n1utG9d7AnjoexL/fQkbJV6qgAUv3nY0We24Y0LI5TykeMYE9znGgIli7MhHIL2s
         pktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767364635; x=1767969435;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmpSJOVIFg4M2aacWsc9e3hmgzuy+9LOHvIW6f6DhhE=;
        b=UYIwA5ObD2r8mu5QTEZRBUVi8QbwAu1JnHbYVYTeKppP+EpDXeV88Yjz1t9+ezD9Yo
         SX04Qe8Utscc4MMECqF6J/yjaTXII6ALhB1difekwma9+Pna7Xz0tGwq5cEm8fcrJDl8
         l2C3N4zYlgjU6tHjY0/Gg0nhWr4yeRxo1l6e3/TWL7VpssfpZY2jwfffWUuIJQw+Bd15
         Vj8zNSY126vUGwNZe4+mJUw7I+UHri63GalmLYWaxvkXmeNG77ntH7D9lYDEauFU6QUD
         0FLJF8v+DzKAyR9uDGg9tUyvrxuH1FiGcdr9Ob3TbKVkBdoIEPsBfXh+T+TIlwDA+V5i
         Xwkg==
X-Forwarded-Encrypted: i=1; AJvYcCVA1mwXiAxmEzcXUivICiU4xgj++OWYPZFwm2oczylbD1ckrK7XL+ZwcXOvhnaW/OVzR3qOgP5d16F7@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa2379wyg2TtDarZBqwVH6LnqtAEuJu9wuxhgg3AjrRSzyI8ec
	Z/nY522qqJLzhgf2tmZ71+qRkaXuFkEVM9hncdzAVrGKZwc5MqjDYuc7lvwGiAw33wDp22aZsqR
	AxYwKtXrMbiwN8pUdSq8cTtKuY2x4pq4=
X-Gm-Gg: AY/fxX4BdzKTHw2kz7QMN5VPGjVWcZVOEEDv9FwrpEoAZzVJfwGt57jhP8DyF9TLaGr
	gCXREGT+2feKMPGK1NjTJBuhL08el2kUNcBUtFvjJjdirdIJlCGb0rLLATlFfC7Rq+cFUEiYEka
	7Gg7sXOBuKij/iboPvN4slyyQGXqdrhi7qOZ4l5ZdTPZwLINFS+jruH5eAVu8HKDJdblkxFz1SC
	Wxle8JafdibO6G+Il+vLHSrp4fm311xWKGvJhmtncbvfu+K/+Btc0fdy5X6TPWsCO9TTZNcYGNc
	36Qv94B3wmEy+Z7Ni2B0bDffjbAZW9/WPNnMarrhroQ7uFqx/h98PQXv0f++6v27g/Inu/iVnPU
	COlrce1gJZ9ycMB+Eyfntkp8ACjeykyvONKQkvZi8uZ7tF0s7fQU=
X-Google-Smtp-Source: AGHT+IEE2iqiN1E5UIb/YYfs6lj3Yj3uCVZRA6sxMGHpHx+t1Aygzz9I0cMBXLvuWS2L7ibk1mog/EV5GNp8x5CEnI8=
X-Received: by 2002:a05:6214:6115:b0:88a:42b1:25e7 with SMTP id
 6a1803df08f44-88d8252611cmr655446896d6.29.1767364634657; Fri, 02 Jan 2026
 06:37:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 2 Jan 2026 08:37:03 -0600
X-Gm-Features: AQt7F2oSuGIeM3Cv7RcApeTZCAv4r6P2bHK04YA1bQCwKv8bRnwAcKzL9lfFFI0
Message-ID: <CAH2r5mtZfrePFu5F-xiQXaaE_piwoe1i=BkpwFmve_ywKiCpsA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da:

  Linux 6.19-rc3 (2025-12-28 13:24:26 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.19-rc3-smb3-server-fixes

for you to fetch changes up to f416c556997aa56ec4384c6b6efd6a0e6ac70aa7:

  smb/server: fix refcount leak in smb2_open() (2025-12-29 17:39:58 -0600)

----------------------------------------------------------------
Four smb3 server fixes
- Fix memory leak
- Fix two refcount leaks
- Fix error path in create_smb2_pipe
----------------------------------------------------------------
ZhangGuoDong (3):
      smb/server: call ksmbd_session_rpc_close() on error path in
create_smb2_pipe()
      smb/server: fix refcount leak in parse_durable_handle_context()
      smb/server: fix refcount leak in smb2_open()

Zilin Guan (1):
      ksmbd: Fix memory leak in get_file_all_info()

 fs/smb/server/smb2pdu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

-- 
Thanks,

Steve
