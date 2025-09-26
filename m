Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B78247DE1
	for <linux-cifs@vger.kernel.org>; Fri, 26 Sep 2025 16:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758903500; cv=none; b=lQyhIqxZNN6KDZcz9dbCVIS8KPNISnwl4o7bwozbFt3XFxW+kRu83TGl9HhEZ0OVeiPZ+P6UgDX4q8T1YOccARxFXaCjozPaq4PmP4fp0cCwp7pKiWihgcW0hvQrNH5qPfS/mttjoZRqA859+C7qbHDPsPF/ob7lnjIBTxNYjBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758903500; c=relaxed/simple;
	bh=S1GTduvaoLk6gEzu62VYZTVkf6MEF6lfNFpCGY60rSk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=WBzZHxBx3KcHSTyxxYDsfy8i9DVroOH82eHVjsbg+Ol1Rzg/qV+gRJLZCcq6qIsP4b7yWo2DraQy5/umwu3emPemplxXiE3bYN81MTymiy/pMTrHQ7js4Bo0Tsuw8QgSBoWmtWw8lATh2hDtfBEIe+rKc009ymQdjVm8ZeQQCxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QbrtBm1b; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbrtBm1b"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-7e3148a8928so16904306d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 26 Sep 2025 09:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758903496; x=1759508296; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7lEG3WGSz305Arms624ajjoShLogPxrkuH6t9XOTDc4=;
        b=QbrtBm1brKS+9OArHU+Wsh8VepzcFtQ/ilwrkVUP60dljLgbTFFRT5RRKFoknWMong
         TczeHXdXoiXoleoBemC4hIyjQENSxEPxeR2+BVu6P9MY0Vh7NXg6Ef3mCCPQ3DGfHHaK
         Clens2WdBHkuOXWdit6YySbUPbQ2oMAnBHpk83Xh6rjyKf+8ZJpJW0NFrfcf/sL0gCtQ
         nKv4XCAmjRA4LS0aEyHSj4cty1txOFJuRHBVzb//cfKzT8heX/y769yLE29am5kCccpv
         501SoN9+I9nZpbh9jLbG5EfkajR62pNXUIxsctjcdM4ecM2RWdy/Qbu3UjAonXWTFvhO
         /8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758903496; x=1759508296;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7lEG3WGSz305Arms624ajjoShLogPxrkuH6t9XOTDc4=;
        b=f26xaiNdLKaB1MFqj9aDpZY1caE0B6pVOpYmj1xEEoOOH0nX51hr0RRqOr4eKOE8tp
         BMh3ZuTWED6xWIBfC4TuzudcUpS8Vxw2gWagva7UIQFh7YO0rYIX5f5Pas2oHMutAYvu
         NyJYmoRb4nT38EkP3GcaGLT7wPqZAr/xIYkFBbqIqm3NhdLivF9glsWEpCwLB512QZeK
         o4QbIYD115kipDqlEQ0eAnONG7ZeD7xmPWWZO5Ye08kmiSJepwpSfsBr93rw5ENkuMO3
         o8128VBMnkPGfpgCMp0DBVlfi/L0lSHg4APPRsUrQ9SvQAzfzGA8guqFeSkdMfniPc+N
         ab6A==
X-Forwarded-Encrypted: i=1; AJvYcCX4QEBEtxVfpvJqA4k94NDkPp0Cv8Gxd5xm3/iaiZ/vBa1M3VI9RI1QxDERzYy7l0St6aVjOxKbf1HM@vger.kernel.org
X-Gm-Message-State: AOJu0YwdZJA/6CLnteVs3sTfZBxKUfLyBTjug6V6HC+Wm1taV9xgMqcH
	SUQTf2ZohC98BK1MurHEenDL+vEULHoeXxG2Qq8484ZilP1NeyS2NjYfQYpLaBBtIC/4gyiJGiX
	arEUpH+kegCyGyTRxwZ/TgBUnCwL3wKL98oIG
X-Gm-Gg: ASbGncvhFIYvMkEZYHhLBzcAxIx+3ZGeB/9GHu1kqtjTmMZvF2X0GXdzec5e0ajEiCB
	xMFhPCQFF3pv1q6UGTt5El0VA+OcnHSCxmCcGS5bB76/RT3VP5eNJLD4MS9/Ie8BarcfkyFAJLp
	Jw571GzXjfhZACwH9proFPu690sfw9JRPstMrX5gsdtx+AYX7m/zUkMaBxqMhY2AA1F0pmC4hLP
	UBAGxYvVNiulVmWIqq1BkkjlnbyicOtdICIpK45nuC3kw1DJgJz3xo1lgsAzi9lZ7dpr3BdCtEV
	zfIO33wvVcNIwsqOzJdqqtJ8LoflOExkDU20H03RpskHL2pym+dSTRfefKhE3xgspXuT+cZbRiJ
	catQi8D76atr7iiVw470CFcMXfmxvIRxt1pioxEIiD0E=
X-Google-Smtp-Source: AGHT+IGC3tiqbCfTYRmntqx+NLKt+dWS84jJKMNkbhRWzPUBrzwjyNVDO2kCof/FXRFfnnm77JUQ8sQHe5MQkjONu3Q=
X-Received: by 2002:ad4:5dec:0:b0:7cd:91ff:6215 with SMTP id
 6a1803df08f44-7fc42fb6770mr92298746d6.61.1758903495323; Fri, 26 Sep 2025
 09:18:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 26 Sep 2025 11:18:04 -0500
X-Gm-Features: AS18NWAQHcShMAHSei_C5dFYvflhD2ibYmlqEQVJhJMuBjTPuMnePdqGeUk7MNI
Message-ID: <CAH2r5muDMKFMMtG1_rUK6-h6T34qM4miRUL+hCQh72r-TrNoow@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
07e27ad16399afcd693be20211b0dfae63e0615f:

  Linux 6.17-rc7 (2025-09-21 15:08:52 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17rc7-smb3-client-fixes

for you to fetch changes up to fbe2dc6a9c7318f7263f5e4d50f6272b931c5756:

  smb: client: fix wrong index reference in smb2_compound_op()
(2025-09-26 09:45:16 -0500)

----------------------------------------------------------------
Two smb3 client fixes
- Fix unlink bug
- Fix potential out of bounds access in processing compound requests
----------------------------------------------------------------
Paulo Alcantara (1):
      smb: client: handle unlink(2) of files open by different clients

Sang-Heon Jeon (1):
      smb: client: fix wrong index reference in smb2_compound_op()

 fs/smb/client/smb2inode.c | 101
+++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 89 insertions(+), 12 deletions(-)


-- 
Thanks,

Steve
