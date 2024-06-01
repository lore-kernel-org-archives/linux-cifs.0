Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60EF1CD23;
	Sat,  1 Jun 2024 21:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717276455; cv=none; b=RJ/YZi+MLcucv+5llRvi07+rSeIKo2pb9z6D+MzuNny2Dccx/3l/Xdx/DuSQjf7Jd53Qv1kaGAf6oPu1rioTuBAK6Sguy8AatoWbwSxZ9o5dwq7gAinWvaa4PYw+lONgBYRttTYXJjO59mSstb9k+67h7c3zmsUmtg1xw+ozUOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717276455; c=relaxed/simple;
	bh=qCQm7c8rkAYNOeNDGO+QtgYo39jEifLfdZ5r2gy+biw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kQ5QKNCMPQwKZosvnIoQOFAcOKs1w4pQDgiaGZnxheK6p0XJCvkscuzduZE1WDu90tcGfl/1+fQo700svkNVSpI9tIl5g+3oWODGdDVpwQk4cy93Vs4nYHA7dz/zO9lmEOAjO4pVBQWOIMVynbmbPCHDvmcfT8a9Br4AjvPPDP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSoAARe2; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSoAARe2"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52b91f655d1so533102e87.1;
        Sat, 01 Jun 2024 14:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717276452; x=1717881252; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jof1YoOQbALrNF0HmF8zO+AXFV4ZYQLjGir3yALDwfs=;
        b=mSoAARe2IXTkvxAHpbj7mhg2fCY/GdoCnitpvTHT/9p/8ai+GT0xNdWO1xzoPuvWl+
         WjXIN/t+y6RWbkZ5+VLhXaVVnMpJJJRoOR7qdCOMBbmFP4bXXJtLpqGbunMGkscvgU+B
         lmkhSN/9Gztx19J0RxgFrj9Yotnhrbw7e3sAlC7jS/nl8s4HNG1V8IY+F/ZzmRMlefPQ
         0jlcLV/nQFHNnoi6D78cRyxn/je03hzwx67vcFmX9Y6B6q/sP04gGk9FDzc1cwItL6bM
         g7aKp+WATOTX6EhhbaIBBTfmGr4zKslq26QwWrO/T9UpN2bJVUtOoyswGew1ZSOTQ3l0
         EhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717276452; x=1717881252;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jof1YoOQbALrNF0HmF8zO+AXFV4ZYQLjGir3yALDwfs=;
        b=B//WH5ZsfJN9E5POxFAhwZ4whIut6I6WN6d/uv9Neakp0sinfutSvrdUpDk6FeSRre
         CTcUfMuNyKJbHdj7LohGO9i7aIV4Jmow2l3+VaM1QDLskVfKxdlQ3VwpOInnBEzMmXRC
         H1WGuQN3ztLNHulKZtuAKY8BpAC0NK4EmOQbJlT25BrozpWfK4GV0W/VFWnsIhhpeYEg
         PUiSixIAl9zii1gWjQkn0Xq1gE8wzfQaT+J0xAsYtj+InKbCfddOtr83yB+Mq7uW3jjy
         Xw6mNUFCQUjmaZgMtmh1DhH0jpNWM8J7K5OwbNfUq1bDi+kTxUgKKrIPRx4nEdpqZ3H2
         Tsww==
X-Forwarded-Encrypted: i=1; AJvYcCXCs5dLLZmrc2mktPBdXcNowh+vgmQv0dqbibjh6bnQLAEqR8rCX3lqjkK4KPVm0sKwT/FfjeetwcYvVTQkqxswZ/oreqAMi8l0VA==
X-Gm-Message-State: AOJu0YzflyX7B++WBC20JcXeq1lrPqkRp6wKXCsg7apUT+wzKuDr+8B8
	nhCIz9vtAA1UF1nB6ShVwx2tqcawRXJZMXLBQYiIUtXNzN0zRZ7ZQNelWdI5FGmgQkMrrQBaDSC
	S6rE1G8/f6EQeh47HLdbUbHZm06gPs83V
X-Google-Smtp-Source: AGHT+IHu7mzrFwMJ0oB5zAbkpUqinwwAWnmn4tlEiH/AUz1SDdi3nznnwWqX+lhFfSaQAzgtjenLckJnnrg2umnP0IA=
X-Received: by 2002:a05:6512:3e7:b0:52b:8409:ffb2 with SMTP id
 2adb3069b0e04-52b840a0076mr1643262e87.29.1717276451595; Sat, 01 Jun 2024
 14:14:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 1 Jun 2024 16:14:00 -0500
Message-ID: <CAH2r5mstfGRS6XazUAM7uX=FkpJ+da7jesa1_8BcOvZgLx1RYQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0:

  Linux 6.10-rc1 (2024-05-26 15:20:12 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc1-smb3-client-fixes

for you to fetch changes up to 518549c120e671c4906f77d1802b97e9b23f673a:

  cifs: fix creating sockets when using sfu mount options (2024-05-31
10:55:15 -0500)

----------------------------------------------------------------
2 small smb3 fixes
- Fix make socket with sfu mount option (spotted by test generic/423)
- Minor cleanup: fix missing description in two files
----------------------------------------------------------------
Jeff Johnson (1):
      fs: smb: common: add missing MODULE_DESCRIPTION() macros

Steve French (1):
      cifs: fix creating sockets when using sfu mount options

 fs/smb/client/cifspdu.h   | 2 +-
 fs/smb/client/inode.c     | 4 ++++
 fs/smb/client/smb2ops.c   | 3 +++
 fs/smb/common/cifs_arc4.c | 1 +
 fs/smb/common/cifs_md4.c  | 1 +
 5 files changed, 10 insertions(+), 1 deletion(-)

-- 
Thanks,

Steve
