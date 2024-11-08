Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A941AA1F1;
	Fri,  8 Nov 2024 22:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731105014; cv=none; b=E56PoqYVgR1qp7sdQ7ExBBtYxSMMBlCygvZywvXOUk8PDPA+L2KcFK7Qn93FxFi/pIeMRmNkvpgAMNjIxB1feiDTFBMKLl9TISYXSWw1Ye1c037Hr2uaf8RvZ+/H+P89aMrbUGgUJiLV4/T1Gh4A1y6rnDf83oS+xUxpmtieZio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731105014; c=relaxed/simple;
	bh=9ZtlgWcb8duhNVqPDAn5hIYaU83Rr15xcO+2oQoFQmg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=sRh6Ikhb2x7KhVGC4fKhq+xbmoupIncn+GYU/frtlXmYf/8Dy3tBF3R5IFSOZzlaaHMAMJ8a5ETVoJC0Xi31xwBAsx809GAJhYwfv+3UzvJKMtGyN8ve9lszyLrxEnbtPXMu56E45jeedACHT7YAicu3kXHEu6Ki5ojlymSFcvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bStwo8Y5; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bStwo8Y5"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539f6e1f756so3190057e87.0;
        Fri, 08 Nov 2024 14:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731105010; x=1731709810; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ntDc+E2Dx+rmuw80lGROxVvsemnHwiBssXUslPLnRYQ=;
        b=bStwo8Y521BMUXe6O0AIDEH2bijEN1vRjc20O5hWbzfhSwa6WEkjJ8wQKhe2gVGO4/
         XKJa2oxAuSjLY3e+kmSdWfYUy8XS3HA0/SYJQhVeXZtNu2GyViwpubaf9YoadFQoKn1h
         OF2JsBRzfAuOQeVOj6RfNb7v+6Uj2S7Puuft1syj91u2fC72H3w7s96YQZjKxc9G5HcD
         dfuC5BFnrFNitWN6hZxm7SG7s4WClEzF5CR1SuZXYt6dRwsQaLPhprU+POP+RkaFYs/l
         0GRWDCh+JEk2+Mgo60NNgwxtgRXsLO/+ga7s/STWduaJMlw1Vc/AAjOCs/E+Hfmy+tLm
         Z9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731105010; x=1731709810;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ntDc+E2Dx+rmuw80lGROxVvsemnHwiBssXUslPLnRYQ=;
        b=TIzs8S0rlUm/A3RdSYBFgKda2W6KqSaUZh1FY3+qAm001cDiON4tK4ub7+N8o8ngD3
         rTIlK+IiLJPZZjNYRg3Dxbo5qQjRqurBNocTK3Q8vJ+t/ZHEMFINshWtUtJ/tzMS4Eo7
         B1VMwk6ErH6eRWF8j45Yq95qiH8pSd56XBgJ4OAc/M674ISl27B/m03yv2BKeNNxnieD
         YEreLnEWvvLTWslE7rWury/dtE18CGmp9g3o3Q4FASFS3gBPsgUUoAq8M+LlA+X3ZQaf
         fCMZHzrqrJGfpVPIh/YxOds5z9OMJXX5cdEToH6q2slLzVGLAn+L7E4AW5HL/Zw9o7h9
         PqRg==
X-Forwarded-Encrypted: i=1; AJvYcCVCxE+8zhwDNUwMtSG1uUty6KqL6uZ6KtMhxJ3TlWlBmu2Vt9z5v6WLH46rX1+y2s+XGOMesgBTSKew3rcO@vger.kernel.org, AJvYcCVr9ll2UdtH8b36SAxhgwuW9cko8kRRuhdl8daZJNrK8UvqFSBQ+YAJe1n06mjje1YYF5Qe8KQR/gf5@vger.kernel.org
X-Gm-Message-State: AOJu0YyeDH6j+q1oAwT5i1uSNa99Z3zlEljzsp+0r25zqjEz8nSftgUy
	8aAGV09wOaanlt66LglKhL52T/Cg2vRdmkjda+h5eKyrNooaDU3Jz4d7pkW/oOmF3jrdzCg4vGk
	3EIoFRPgWQGczlukNpY0CtsXu4i8=
X-Google-Smtp-Source: AGHT+IHIxtFntdiAEdNB/zI5le+OJOQGaLItdQu1V7tD6VQauamRkwfCYrsvhzoidJUK+BCHm7KG3uJNe0DkqtWlwzo=
X-Received: by 2002:a05:6512:33c6:b0:539:e88f:2398 with SMTP id
 2adb3069b0e04-53d862ee21emr2239992e87.39.1731105010176; Fri, 08 Nov 2024
 14:30:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Nov 2024 16:29:59 -0600
Message-ID: <CAH2r5mu+pJMkChJBwgZ9mHjf6s8JxDAtfTU5fFcqir1rdqNXtw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
81983758430957d9a5cb3333fe324fd70cf63e7e:

  Linux 6.12-rc5 (2024-10-27 12:52:02 -1000)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.12-rc6-ksmbd-fixes

for you to fetch changes up to 0a77d947f599b1f39065015bec99390d0c0022ee:

  ksmbd: check outstanding simultaneous SMB operations (2024-11-05
09:26:38 +0900)

----------------------------------------------------------------
four fixes, also for stable
- fix two potential use after free issues
- fix OOM issue with many simultaneous requests
- fix missing error check in RPC pipe handling
----------------------------------------------------------------
Jinjie Ruan (1):
      ksmbd: Fix the missing xa_store error check

Namjae Jeon (3):
      ksmbd: fix slab-use-after-free in ksmbd_smb2_session_create
      ksmbd: fix slab-use-after-free in smb3_preauth_hash_rsp
      ksmbd: check outstanding simultaneous SMB operations

 fs/smb/server/connection.c        |  1 +
 fs/smb/server/connection.h        |  1 +
 fs/smb/server/mgmt/user_session.c | 15 ++++++++++-----
 fs/smb/server/server.c            | 20 ++++++++++++--------
 fs/smb/server/smb_common.c        | 10 +++++++---
 fs/smb/server/smb_common.h        |  2 +-
 6 files changed, 32 insertions(+), 17 deletions(-)

-- 
Thanks,

Steve
