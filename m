Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF40128819;
	Fri, 23 May 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748013849; cv=none; b=EGGGTMk0vjp+Az++GrkypqRTNf0oyOstSJOW6vu9BHFGgJBaAAVAMwulGGCPIAOUvyNbZ0gYtKtCmwJT+W7S8x2zSG5SwjRT/QLUE4norySQvyFJT6xTRbeB4Fhj9gl2eu7H7D1QL9S10dTOiv8S78N4Exbzuda64nkOUhFD3Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748013849; c=relaxed/simple;
	bh=aybk4ZTu2CHB13ywbeiIrf4tZ1CKFZ8NXxl51xMTjls=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=sXyLJ4DE2ZIfgc7TdbQvxOUKmbBCpAf8PEr36BsMzzHgXX1UTqvGlitCCCrtwMbntoGiPYPErk5KSPFpmuKAhca3eCMtfa7QnvSAKhHLn5Dm5bpnZsJDlUqFvAG2ARksVvT8NYhdXuFneydz14/p/KQ4VTSHjD/ngVVVaG0J708=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cd72XMMS; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cd72XMMS"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3292aad800aso723571fa.0;
        Fri, 23 May 2025 08:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748013845; x=1748618645; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8JJ66wIohXcLESISEjoolqhH9fgMI2jr1X4zSiAvmzM=;
        b=Cd72XMMSnFdLLw1fNwrwxcFclsNl+gR2C8jt2qQ+Kp/E5dq7emsMTZc5VHLeN3DDhl
         CUIfpLweGiBkFO6AMHMfpXuIwbF7FF/lIZiRhNlLX/LS5xbE9XPMYyFI3wCcscNSmNW6
         VpdT4xNSsUzniEC8JBUNF9s+9Lxy6i9+c79I0oenavHTyTlApIBnghOkyQKQ2VonjVdk
         18MYYE+a0e3nwd0QEQDaL31btQ2y5ShIPAYV0ttR7cgUIK8+8+QLPw5puDpmwOY6VMPd
         HdaMydFNR4VtV8Kb11uIZLxpPIGl/ctABFjsz9Jcje+lQFdAMYy70+5FFu1yC9Ixrp6j
         RLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748013845; x=1748618645;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8JJ66wIohXcLESISEjoolqhH9fgMI2jr1X4zSiAvmzM=;
        b=BqpZlHI3pUp+yQ1sRegPEVM9kkaSIssOD5pmXzVKPjFJeOHVNNesDqv7nqyMdC4oC7
         vui0gJDhKjgcDtZv39MEDrgJcrAU+eoTk9mYn2qmzK8ksfxvJDTucpkJIR/kId8Us+kd
         WwULFvpAg7Bv4mhiHF0unJvCMQKyPi4s+vHAmyed7DiJ8txNDzETmHwvebWTRiccPWo3
         GHMfzD+20VQoXWEY9cSbP/QHdmSymZjNXTPRG4cRa30M4c51DxG5aimRVPOWmWMPCU/C
         ONKilEUfJUPAjh1vkGygGABc5o1yuJvvYcS7vslrK6HBUj2KpN5m2+rb0K86DqWhxKvP
         SgpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtLSfJ6XunYAGk8FkMsNaAUbt4k26COICK+2+IE0528GybEBJIzY6GakBUm1uV0908gnzf1KqDZmtOIsyG@vger.kernel.org, AJvYcCX8KUU0IfMLGMJ79LVJ4E6ho93vNSu05Zmn5hYExAB9lf53AjcXgxQqKKqakx/yeSn1bydJgqRW2bNB@vger.kernel.org
X-Gm-Message-State: AOJu0YwRFxiOq3p1+wIhZoBgrAwOvtNKSwbDe1BXmHH+DBJz0Cc6lq5V
	GYdk/Hcq2hVOKNeD8cH8XLpZBGqZK7hJVsZTw3tIp/BGDFx3VfYgojiByg2H8lDbcJEK62/oO7X
	Xh1vxv2OAAmk5GEY/F/1X1OqrTXeDk+A=
X-Gm-Gg: ASbGncvvIZ0TSpLeg8oqd8dNBzofLhxoi6ju18giD3m/7QkOQi8tQNBdOlOFXcEBtg4
	SI50YTz9tB3Kj0gKTt0YdQL/UIgLfTwZolRHirDKqidgxzTwKpueNLBrrb6UCuvSVy6PuhtcYZa
	s1EzIV1QQlbnwUmDgooRJb9VpPz4nLMvRR0uvj/eMNcnmgkLVBtRtDRjW3Icy3QTZAWnA=
X-Google-Smtp-Source: AGHT+IFETx+XnLeGryEGTIHXcggMM1QEBwgHv5SM/hnhJunXtePjyQxDPwfMdeHdcHcjhcz5S7e6OaLvxNXG6RLZ0VM=
X-Received: by 2002:a05:651c:2223:b0:329:c65:eae8 with SMTP id
 38308e7fff4ca-3294f7a3566mr13460661fa.13.1748013844987; Fri, 23 May 2025
 08:24:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 23 May 2025 10:23:53 -0500
X-Gm-Features: AX0GCFtaqsBKPBeQ98kMeSxLBW6aT3ewKIPavkorTrFRFRzJ12ngoqnSfHwIlOk
Message-ID: <CAH2r5mud60X1UsmL0OiF6OQhA-wW8WzfP7SyOZBmDEG-hfD4QQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
a5806cd506af5a7c19bcd596e4708b5c464bfd21:

  Linux 6.15-rc7 (2025-05-18 13:57:29 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.15-rc8-ksmbd-server-fixes

for you to fetch changes up to 10379171f346e6f61d30d9949500a8de4336444a:

  ksmbd: use list_first_entry_or_null for opinfo_get_list()
(2025-05-21 22:30:39 -0500)

----------------------------------------------------------------
3 ksmbd SMB3 server fixes
- Fix for rename regression due to the recent VFS lookup changes
- Fix write failure
- locking fix for oplock handling
----------------------------------------------------------------
Namjae Jeon (3):
      ksmbd: fix stream write failure
      ksmbd: fix rename failure
      ksmbd: use list_first_entry_or_null for opinfo_get_list()

 fs/smb/server/oplock.c |  7 ++-----
 fs/smb/server/vfs.c    | 16 +++++++---------
 2 files changed, 9 insertions(+), 14 deletions(-)

-- 
Thanks,

Steve
