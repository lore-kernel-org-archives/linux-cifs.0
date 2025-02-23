Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E201417E;
	Sun, 23 Feb 2025 01:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740272645; cv=none; b=Q5OT0UC1WIBaZS5ifpQaBnOYG6RTQmqG1Bfm0MgPYgmjRXmcviZPw8BkZVWkQ4NU78fw0iB3tFfgB15s4GZUteWhVUdOGUCeH0K+0SIQ86O5Bh5VtDkjzgeX1IKoTJ23BBCIE5yKBhanyimle9HGhCRZOsCFLK8Ek5bJwHW5I2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740272645; c=relaxed/simple;
	bh=Ww/0bc1JUCYTULToRkhYf+3soQdu3u5h08izRnjSRK4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=AsGYC9KJ8aD02jRQW+aiE6to9NQiek9WeA4zyAgWrZjadQCtojttXa6jyFOfPz+Xw9mWSF9zGEK0DKDXCs5nM48+Uki31pz89MezoLIShw3dkta+7xVKlYVHNoGeebncG5dMP9/RHqLH8cas0Vk3PNVgYUdXnpy3e3AaDAbChqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7dq70mq; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7dq70mq"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-543e4bbcd86so3795554e87.1;
        Sat, 22 Feb 2025 17:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740272642; x=1740877442; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x8C1J25Jqyjs/L9E7dRONPDUFFLo3QFIy3Cj8CV+5hA=;
        b=f7dq70mqA+QQPiLDqTxMC07xglZIEOWuAKB4O+KQJIBS9wSz7lmtHIM0R45Pf/OxH5
         sBYfZ53qid3fnzDdua6Q3GTHjN0C496XOIUIJfuceg3cj9//k76/U59hnIna36j5IY32
         DyG31wGdP8e/dqyIeMDMqe5ZSR5mLX1GvRUWXCpLL2jHl3jXvBDCqEl9IFysWOHSiqw/
         n7XmUUYEE3mZtv0D0U3HKw0iGisJL0Zyw/riwyqpXV13pQOIUINNt9v5AsR1GSDOZM3J
         njnXf+3HuxWpE7IdfSpI2uYb4h03LzZ0/zlrN9/gIw9CxrNbG74cO1Cfl+Mfd7AlQ1lq
         e4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740272642; x=1740877442;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x8C1J25Jqyjs/L9E7dRONPDUFFLo3QFIy3Cj8CV+5hA=;
        b=gwgvcjiU7gFbiTegQBEW0I8RDLOtgIyUF7JmvneVa9le6EAjs3s0ZpWSjT3FFWibmm
         EnV2dBlfyPlc1rAhOE5vyO0Rz7Is/gAHH5GXnc16k+3iMYELpHT2STGJHL9uO+mDbF7/
         jkpDPR58N/oxylsRyZWiDvsA+x6wZ/EY5GHQOw5/f2MOj6YeDkgHSh2wc2D+Vg0/cS7F
         3s+CkwQSm4sFGQkTovzIuQArvizfjhY1O7cQG9pdJXLJyskT9bUDVh/i+jsMcl0LZKNn
         1cyU8rwZjNbb33muccNUFJq+968qWYh2m2uOx+EmQJ8yjZpTx/y5CfrkA8l48fuzRlCw
         CYzw==
X-Forwarded-Encrypted: i=1; AJvYcCXQpMPwlz0L8u0AW771sSVV57ShXiddoC2mffgXammgAPmBJB3QhyU4Ch17jwAvxXR37wLjMDOOIJrD@vger.kernel.org
X-Gm-Message-State: AOJu0YwE3RH/UYmSwGLSAovNDxxZ5DJW5uwO8c8P5P9GMLj4I+Ge8swy
	QTJ2IHjmxlt4mOYib+3SNcXJhn/CNDGfjZf2ctFFrujm3j61BnIWKz2pnhPFmsekRpMUszHdGCi
	l9rNUjgTs5WxIgeXcRsBbsyin7704bQCs
X-Gm-Gg: ASbGncvZDnRG7ZtigDLWzfhvzpj5PZOkx2I5U2AOKhi/rA8GDdV5mSHJuNcd633deQY
	26rGS2d8MmfD1E4GfpoAc2IMnDC2EeroUImb+VQaPZGhlI/u/5yBgg7KBypfAvSfmrXJ831xxkI
	b/5wnq
X-Google-Smtp-Source: AGHT+IHvPaRlIiVJP2tOoyKtiXyxVs0f5xua03Gz0EDSPoMxjtF0NP9789bfP25QA3+vmVegvODjKgnCdVTmetU+Q9E=
X-Received: by 2002:a05:6512:2212:b0:545:54b:6a0e with SMTP id
 2adb3069b0e04-54838f7ac9amr3704277e87.48.1740272641695; Sat, 22 Feb 2025
 17:04:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 22 Feb 2025 19:03:50 -0600
X-Gm-Features: AWEUYZmcAFT_HHCXcLlLwztRGdcQHKqiB_hfEPVxR6scXfJzJCZpneQBnBNvKkw
Message-ID: <CAH2r5mt2PEH5ZOR6YP8wNSkaQGrAy0FJJB7bPT5VPxb3-kTAkg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e9a8cac0bf895efe0bc7b11d174e8dae9b195da8:

  Merge tag 'v6.14-rc3-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2025-02-20 08:59:00 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc3-smb3-client-fix-part2

for you to fetch changes up to 860ca5e50f73c2a1cef7eefc9d39d04e275417f7:

  smb: client: Add check for next_buffer in
receive_encrypted_standard() (2025-02-20 12:10:39 -0600)

----------------------------------------------------------------
SMB client fix
- Fix potential null pointer dereference
----------------------------------------------------------------
Haoxiang Li (1):
      smb: client: Add check for next_buffer in receive_encrypted_standard()

 fs/smb/client/smb2ops.c | 4 ++++
 1 file changed, 4 insertions(+)


-- 
Thanks,

Steve
