Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC61101DE;
	Sat, 14 Sep 2024 04:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726287709; cv=none; b=DhaarM65RALviTwJjn7RYjNIdtlM256a3foLgK0b4ghWnHFYrvxAnoMHQ07GgyWD4BIBft9WmRNwzn4/V5hYcmz9DTcSeaPKXmcJGJ2o8d7d0oKNr3CGa3AKb1vpBMx9jEHoHokSPmYLFbI9bfq3yYIiWb7nX9FsZpwlc2FAlB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726287709; c=relaxed/simple;
	bh=o7pU50qUsKwdWjfpB394skTGyPgd6i3JnbcdgCJzgDM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=WX52D0SoQsb1NRX2YNoXP4xrUsLDLA8ZXMTumiMNcIx6Z0NgE77qZLYdbeVboNAC/y/l4iut0/U13NMUSn5NPJC3XNBLu49f9nXeVnIylEp1dZ9DkjpnMJFfgsM6YdfoI/Fcm0kvGYGF4fvEXyVu8DGsEhbOHUP6siBLUukP9Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ik3aqvWi; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ik3aqvWi"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c24ebaa427so5728305a12.1;
        Fri, 13 Sep 2024 21:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726287706; x=1726892506; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0lz3GO7vzO2NCS9fmbQm6YDu2k75zvPDogftxNWVKSA=;
        b=ik3aqvWiCdHnriXf9obCTJn3S1uvF0K/+kY6Y/470krcHOIl/3f3+hirmBHbvg7dtW
         9N2qjUovUvd2PYeJLpHp/ulJOa9P07lyXkQN4HysybnXCLprLJkV3/pJec3yIH2aMMqm
         /00eGKddOMlaOi9pHvXONaNuxrH2nh6TNhHhnnUbJIPwYe4jM3aI3fdrLDDF/zjexTWE
         qb5f1mSj2ctlR4vBto/9JIv77GOivgQZjRT3p1Mn3Aodn6caDxuApk55Jzzeeagz184i
         JoVEIWHQTBGbR1HW/7FlxHIWGsAkeb2VM1/ltXW35JqHtzaSfM6JdGQP7dw/bN2d9XJR
         4Rlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726287706; x=1726892506;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0lz3GO7vzO2NCS9fmbQm6YDu2k75zvPDogftxNWVKSA=;
        b=DcbbrX3iq4+8UoyeVV55PMVgOc9qNzO2tfGYvcR/tOCHe8Ro2LjHJZW6Syg8bqVlwr
         skKeM6c4vZC2ggc6mWQq01PNcB2UoXL6lwL0wNB5vLWge59QR6ttKYrD7BhDmCT6Lsls
         QCosj+N7lpAG/VInRoIugoKEuDjDQtYDw+sET0P19/OlSbGiHiv4jV+UMZsyASHvJ/SP
         cO756DiYi2RTYyRUhXFT4iaBLNejgULYy+2LhyIqYzEiY5FyRjgm+o0C49Sa0XhQNp54
         pTJIhIbh51S4K8r0SJdqs23IotJz2+9THltNLIqd1sjsKMu3hPBGvZrnmYSIVcKswa4X
         6qdw==
X-Forwarded-Encrypted: i=1; AJvYcCWoBgzZ/D8XPjHH7A/hJnO8jfqRKZjHMs92neGY2OtCuPAP2Spqp/qE8SjUyoOkhrhVhN3Oqv7X6I1c@vger.kernel.org
X-Gm-Message-State: AOJu0YxQhp2+ioFsW5ed63VGPHhUlw/LD8l1t3KRNJ5a2dGUUVSOKw+b
	/rOE+5xR4uAAK59l2dnS4M0UaA7iT4GkFdXi04Rro/XefiYz2YjxJ2JwRTDI2hCTfhpmdhu91Y7
	yUvHUyXf5o8PUm6VQyBxh0TMSUji6MSu6MPY=
X-Google-Smtp-Source: AGHT+IF5u+pVRBbm+qTLi3RywGR16q3xzP7+gDLAY1XDk0Y+B7Km6TJYXQr27FdGaH+Zh4pAz3gMW8Qd506Ta/tiAss=
X-Received: by 2002:a50:cbca:0:b0:5c4:aea:5833 with SMTP id
 4fb4d7f45d1cf-5c414387621mr6577871a12.18.1726287705619; Fri, 13 Sep 2024
 21:21:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 13 Sep 2024 23:21:33 -0500
Message-ID: <CAH2r5mvA_0dp2NBd9Q46GxnqyZ43SaDFJp6aSVp4xFHWa4zX+Q@mail.gmail.com>
Subject: [GIT PULL] smb3 fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
da3ea35007d0af457a0afc87e84fddaebc4e0b63:

  Linux 6.11-rc7 (2024-09-08 14:50:28 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc7-SMB3-client-fix

for you to fetch changes up to 5a20b7cb0d8d3ee490a8e088dc2584aa782e3355:

  cifs: Fix signature miscalculation (2024-09-12 19:28:48 -0500)

----------------------------------------------------------------
Fix a case where many signing check of write failures
   ("signature verification returned error = -13")
----------------------------------------------------------------
David Howells (1):
      cifs: Fix signature miscalculation

 fs/smb/client/cifsencrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


-- 
Thanks,

Steve
