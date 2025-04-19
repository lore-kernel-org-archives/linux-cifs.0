Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A072AEED;
	Sat, 19 Apr 2025 02:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745031452; cv=none; b=ol/TkhCjrPaMkLLtAMkAkyEcgHN6ooNqkKenplphaGuKmIcyi9PR7XbPkgGmp4K+DuSY+xLqeY7u/YBFsOKv5OX5eNxuQNxQpgMKxkAp1AM4TjbghB7/QcT/oSVZxFUd+2IuAqIL1R5ZLgPTMTO+uMvG/H9hzFqN2tyn/+aftlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745031452; c=relaxed/simple;
	bh=oYQU52FTMIcVNzxozSb6a1YBQuGXoxDmd1o9zWWNLC4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=co8zXUEkoekPhYfMC2uBsYO5jjdt8j0pKpUr/6IZj14bemrj1RaYp97olJnQA+UwWjxMy842duigWZ28TSmj8HH0m7a26ZnelPzK+ft87mipXP7t/OdcJ6Avlltj6tn+YeWRGIkz4ETadSH4LdbCtu9Mv3oGIAoAczuEaZFBdsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ni3NvFTA; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ni3NvFTA"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-54991d85f99so3785241e87.1;
        Fri, 18 Apr 2025 19:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745031449; x=1745636249; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gOKBK6TLc+/4yVp3WA/MHV1AsW5HIJfli9PYQyF6N1Y=;
        b=Ni3NvFTAxPEIjoeazy0ZZnYsy4MgqeAC245GpB7aUm+bukbRpw9o3Ckf75wqF370mg
         7eeaEmyP7UGPwn1MXP5+k+lccqGPpO96oPKnomgr+eZV5zQxcdznvrtdkuWmaXO+L9UD
         xQZbeytNiL23tC/6tgsL3ZomUHrwytcxuuyx5GUO8VrG5t47cH51LTM6PyXuOlLqLkHP
         nA4XYc4AzfrUE1Oe6GW+nAnC/VdawP67QV9xrdw/tJhm5e8qe4H2KVY7cNcBoqOvNY07
         FXuvPLVatJ4Qwzt4tho2CqpiInC8ASo0L/2O3JElPzeX9plvP10PuN99taLJJrh9ot+r
         XvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745031449; x=1745636249;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gOKBK6TLc+/4yVp3WA/MHV1AsW5HIJfli9PYQyF6N1Y=;
        b=AQ7rWRsmxwstxBJXxuo6S8zDIagdZQkRe1igMOcb6cMj6YSR50iy/i5vAOYKmSt+1H
         mY3x7TBiA7JsFrm7cxcfuzH/wKcm+nOoh6f3aT5jurmbBhz2KdaFbSIwn+zHUrDBOcdw
         KNdr8SqmkUX82Awmf6JuUqMCXOCsyYrBc82FaTww8GhG6ru4lGpDoLh8u5skHacUrvYY
         yqIe9cERLpOjs7EHl8b3tANIH1nBk41toHNQ9vVUQlPKak4FBy2XWWeQHMipv2gjo3/L
         JVgrWWTnnhP5GkxKxAKHQUT5LmgshMpPI0PTUx0QXwdzoekp+7kYs+YyR6qPPysycP9/
         biFA==
X-Forwarded-Encrypted: i=1; AJvYcCXtKwefvYm9lB5beWPRQyp6FfbU/4dI0jjaO9pwHA7A/KyqvKZopR+4d9JxbnWSv+x9eMZKiOt1qx+E@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1ecDFIdpIjlZ7l1C3gUaeDim7xp4M4TeCadoi2VwXqgzCR5LO
	eObR/APfVTiFyAbupJ8Vnzx+nXmBxjUiYOKtMly7q7aaDfvbIXXn7FnK7wePLznSdcWB/r0LcHf
	TjJVvs1p+JEC8Pa4HzyManTzOvnHgLRZG
X-Gm-Gg: ASbGncvFaQiqAjQpludFSh91Es9JgmO4xzK9dptVOR6ut8T2AKDj0yw8wNaay2MWBxK
	eOUyo4xKWVi9FiLWwRnMlLrFP/dIz1yyu134mss1mxBPIdcdrO94HeZ4osUHcaYyvNPcdCnRoQ/
	AAihEdeqSbvJa0RjAJ1/oT9jZ1qMhQohEk3CQt5YfGwvQceeI1c5hO2gS3
X-Google-Smtp-Source: AGHT+IGqL0LdxgbVEW8lh9R7dG0BuEkpVoTAi7YuZ/uhK0cpymdk0NrxI3h7fL+AqI1JtdqQbzfMfEEiHoPG7wEDmfI=
X-Received: by 2002:a05:6512:3e08:b0:549:90ac:cca2 with SMTP id
 2adb3069b0e04-54d6e7705cbmr1413649e87.1.1745031448577; Fri, 18 Apr 2025
 19:57:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 18 Apr 2025 21:57:17 -0500
X-Gm-Features: ATxdqUEsswlNUerJxEUNa1zdaEV_Yj3d1RtMSTKbJhEMUhN9KFfT0mp_QLUej9o
Message-ID: <CAH2r5msf5GpS_RV3-apwDGuVMVDWsiWfeKfRy55xnTbjMvPCXw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8ffd015db85fea3e15a77027fda6c02ced4d2444:

  Linux 6.15-rc2 (2025-04-13 11:54:49 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc2-smb3-client-fixes

for you to fetch changes up to 95d2b9f693ff2a1180a23d7d59acc0c4e72f4c41:

  Revert "smb: client: fix TCP timers deadlock after rmmod"
(2025-04-13 17:24:55 -0500)

----------------------------------------------------------------
smb client fixes
- Fix hard link lease key problem when deferred close
- Revert the socket lockdep/refcount workarounds done in cifs.ko now
that fixed at the socket layer
----------------------------------------------------------------
Chunjie Zhu (1):
      smb3 client: fix open hardlink on deferred close file error

Kuniyuki Iwashima (2):
      Revert "smb: client: Fix netns refcount imbalance causing leaks
and use-after-free"
      Revert "smb: client: fix TCP timers deadlock after rmmod"

 fs/smb/client/cifsproto.h |  2 ++
 fs/smb/client/connect.c   | 34 +++++++++-------------------------
 fs/smb/client/file.c      | 28 ++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 25 deletions(-)


-- 
Thanks,

Steve
