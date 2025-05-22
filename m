Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE51A1D86D6;
	Thu, 22 May 2025 18:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747939382; cv=none; b=ruKqEd9BQMNJHKLZuqfZBM8gd5oVd8UimJHk0aGLjyk/EckjQjt7aFLRlVuP5rxmN9y2+1SctQLHKRtwCleHYsCWzFWaX36Vm8t1rtQvTF7A3Y1zOJj9q9oKJNYpjJ5YUcJjHx/TTuWsWALv/yAfXs01RL4EjZEBaY9NxiMqGUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747939382; c=relaxed/simple;
	bh=ZkJEJGa6FXALiA4X2OLwZ2QNA/cqpUan1XjXOQf6OSs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=SO1JZmpRfNd2xLc7oLz+OnDviv9YYpjpdhRPHckszQJRyp4ZQWuDh+bF6z5wIbxN3VsJBQ7DBWWSLoOv5Mv8dBYFNRGXFhLwq6iU9fY3WOH/tZleoZ0VRGbRNJvjei7LE8IZg9hUAosR0e8ez+7p0Q/S5wq8V9mRVyKZTVSWsn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CvoFGs93; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CvoFGs93"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-32925727810so37798031fa.0;
        Thu, 22 May 2025 11:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747939379; x=1748544179; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ANyAXegvaMs+K+iayy0voxCwU2HFvk5vXonKcxX/jac=;
        b=CvoFGs93VaZVDFSM31vZ2YrA3j1iQCFSlgyrV45V+yQkqdWFPV3ps5ByJoA5ZCrreC
         mVpTr4SNLossetjDlMPL1/7uXx1A4jhiG0XFv0g25HVPopFeqtkvAdselxZAyAtEujy+
         kehpCwubm5Ut4OpXhC5hTiCyVGNs/UPGEQzXiCQsdsoA+lAmYhaYWNAMHP3QaJYiVF31
         FfGohqph/l07OcA5mXwYvwb9pqLimjoI2OwFd1pzV1+XMoZNCYvXb0EeDvaSgQpdR+hP
         2tx9YlbUBZp0Lz6WYiy3tHm8/KS399FNhS4Nn86ZhKRoQbD0X3UXEH9tGeVYvmtsAh4j
         XOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747939379; x=1748544179;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ANyAXegvaMs+K+iayy0voxCwU2HFvk5vXonKcxX/jac=;
        b=d0EuGgMrca5E0UnX0FYvYjs1v7OMuNWfWqIrsoZcfphsajqkrmAyGDoCoUuvHlQBUk
         0vBd9lje6byigTxrm3eXoWFsz6xg0jYQRehZmbdKPcAWlSOsZueCzeSQUuA8RWM34hub
         1/rYdWF6iE7wexwcquAnJSa1wgdfDm0LgiC8KTlY6yyIPb2Hm6U/u0eUIx6PO67ikVkn
         pxAqTGVp5fmDue/af47WFN93ug5c86nSRuM7Rh7HCiulxiz9nmjnlwlADvP7cCM8c4y0
         YUfLIVUcy6B+xXsm5llMx1/yq8aZ2xCu7l5eCDR11HpdzRSH2NkFuMRm8+zsDlGFqwlg
         qTrw==
X-Forwarded-Encrypted: i=1; AJvYcCVxjuh7O1ZYNUflCk6ibpjJdlQdPf68Pom9AiuP1mRFagXUdmI9wwdYKXedazLSQre9U98BHSbczFxT@vger.kernel.org
X-Gm-Message-State: AOJu0YxU31tNIbLFmBsbY0PelzdBlO927C8wCbTUcGGdxdXndhLDJ0ZT
	bDre9gsy9ocTy/Y38vfXANQmNRK8RczdEIgwlY24mutr6Ma8j55pLcfA1Ul40ahdrjo/SdIeepx
	KCHWZAE57nSxE9IbZsiN9Vph2tp7pgaf2JKh7
X-Gm-Gg: ASbGnct9UfYMpGKYt9Qy3mWlgfOVkvzq3XQFKhrsRHhZB8rq8c+NZ1FAXMw73+KfGUV
	LTHuLNXyiihrkon1Vi8iK0Vrhl8GjZHl6BMaSPT54LE0jiLE9h5Cjf2qCPPAjZR7A+MsrfJG94s
	fskAS58016os/PQewCYIi2878paGejVlHTSksly668xMfgfx9rk+fVm+goim3zMmrLHig=
X-Google-Smtp-Source: AGHT+IGCW8CQC8kMeFroE4B+niY7i6MyD4gT3eCZN0EagioH1W7me5Q0QvjXw5SEujnZ3rq+L55yKj/JNhiWp7lFBww=
X-Received: by 2002:a05:651c:111a:b0:30d:b31e:262d with SMTP id
 38308e7fff4ca-328076ef608mr77337051fa.8.1747939378510; Thu, 22 May 2025
 11:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 22 May 2025 13:42:47 -0500
X-Gm-Features: AX0GCFsfauaBHhe4ZCaKvOUrTyOD2UBtiWE3Vc2lo0ULc7CfRHrfKHkTDg0G3qA
Message-ID: <CAH2r5mvC+E8L719+MGf1C+mj0One1kn=VZbSAiF2mGCqgPvqYQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
a5806cd506af5a7c19bcd596e4708b5c464bfd21:

  Linux 6.15-rc7 (2025-05-18 13:57:29 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc8-smb3-client-fixes

for you to fetch changes up to e48f9d849bfdec276eebf782a84fd4dfbe1c14c0:

  smb: client: Reset all search buffer pointers when releasing buffer
(2025-05-19 20:29:06 -0500)

----------------------------------------------------------------
Two smb3 client fixes
- Two fixes for use after free in readdir code paths
----------------------------------------------------------------
Wang Zhaolong (2):
      smb: client: Fix use-after-free in cifs_fill_dirent
      smb: client: Reset all search buffer pointers when releasing buffer

 fs/smb/client/readdir.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
Thanks,

Steve
