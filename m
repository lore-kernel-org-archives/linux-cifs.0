Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A3D279336
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 01:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777600700; cv=pass; b=V8lnE5eA5l0kHUIuOrMaaloAkpxwbfrYbgG22YcV/v+frPWXC7RQiqFekiVWXOdUyLQ9F971K9QM0dsEGsTPptQ+5lenmFo8iO3VEzUV3k/D+LvLPV8WDCfzh8eAeu6QDBl8AvqYdQWxmx2JMr53mUBq7NzXgGuClKZb9v1oFYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777600700; c=relaxed/simple;
	bh=4gNGD414tKrTyYKxZRl/pw4/QTgJgA+cz1EwjiBJxvw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jvvly+tfH6xGr1RJR15uxpWj+/bxiQ59M+I2jrNg0XzRvXYD7RkSE47wHTtzyXQ1cWD4GswQJrt9xSXYUUnMvjFPTgduZ3GPrZPv0uk3DG7JUqx8vYTwQfyK76ii9rEkrnJPps+fStEKAY8W7AacKerW6LW9R7N8MgQsSnnWHA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TVhz6o9m; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TVhz6o9m"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b038a00370so14465646d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 18:58:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777600698; cv=none;
        d=google.com; s=arc-20240605;
        b=R0HXx3kYhOgkodK6RslYS3EoSWEIhNjCt3Fd71BCf94/pdSIa9uivVhzIJrJZW4j0D
         HEPTliz52MWlfp7M2FZDP6aCFxDW5xTqmVMtgC2unWDCzluM0uQvbDVGXY9X7lrVWOAH
         q/kAlHbJTulniYJPYUyg/h+G/mAOvPMwUUWnfKNEg78ri4rczJE74t/K/eSexNCF+ete
         rvYTTBgW3AT7Fw2msulFvYi6YZgBFEXunE6BcDd3eP+kBKxR5D2hZbDonluW8VO6iLJW
         c1VsPUexeRCYw7mRf3RD+0Gm9yeygo7j6wL6f3Hb749BY2LHBAp4rWtQdkY95gx3t5Nz
         WTDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=IcRlWDyO12dM1gv8ZUmZOHfElkl54BamF66VIdoyn60=;
        fh=JWcost8KkgSZS/Rmu+2DeDbqWlU0L8rfRUA4WiRGbBU=;
        b=jiavMUQdjedgBQAaFD7JgqXkjM8dTI9thqZ0RbXErjHXQAXubDWq6e2rgJXX59+rdF
         niSPonM7GqDa0IDKXcj8GEbxbExeFA96CjGWcHjKlqCcQzJGRTJuFla6SBbYMUH9ReCt
         2pCQdlAr70rQww5xrNl/OypWL3j/6tvpKivO5vZO4FwJdj/MLmzA6qSsY1PKBazchdxn
         SZS9flvxv61SjYrwMX2PQJAH3hnPHoWbsdoD3IfxDPDTCo6AGS4WEYnYPejMPElCtRCN
         Od/wDkhCPfqN+5zq77PpmSUpix0LRVTa3vXr2iT1v+yj5m2iy409B9CFQzg+t0gKhyac
         78Gw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777600698; x=1778205498; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IcRlWDyO12dM1gv8ZUmZOHfElkl54BamF66VIdoyn60=;
        b=TVhz6o9mxeblOkhsqTsYGMNA13buVPzAl63246Ve9qJqZa+fvHp6buxAMTopPwwbGk
         ZCuVfD5+m4um3L6/fArzc2tnDHfVPJZQsq3Ze870yzJGKoWgsSWe6vxjTXAaQUIkk4rm
         zmu6E0iRextCxwwtH+u6Dso1Yn6AV3+gaLbZ2BCfIs0SNKAozMRChpx1BmCxTEqiA1nJ
         QcnvLm2n41O7oodcKM6XgNmvfUDNr4vjVkaP+cZZqBNEpv7ekP557w3aj/Q9xg9tBfAF
         AMQOAv5M3fpO+1n6i7YXQ3ZYuhcI8Zckh667P7fZodLe9hZWH+SspA/0VW0lmkHncKrl
         Ci1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777600698; x=1778205498;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IcRlWDyO12dM1gv8ZUmZOHfElkl54BamF66VIdoyn60=;
        b=D1hQKN8pZ6iM/4JCI0lv3mLQtpRnGkBpbLTZeCILkUkWkkqqJMqr2uXD76lbG0mDOe
         C8q+DT0DtfEpfERVpb2DGaAJ2+zzZ2halAnWt8LMCfFwvH0D4c95mWGSJzK1A3eE50h7
         pSZo0Mvo6Y3zs/XHJCXLrPVGce5d7r2apqSWsZmeYdhzjL0OqlFsJ2C5uHq+pMXa0iss
         9ZPICCzmQA/1nVvo9Q4jLA/W0Qz/UHfjS9K3PvkpEUc8ARnEhTiQq2d1D5gHt1leHtw0
         /r26qIj3j9lIW8sINGPUA6re93eDdBERaVw3ZpyuxSqre0SlWHVU43VPznel7jTXRzK0
         Z0Rg==
X-Forwarded-Encrypted: i=1; AFNElJ8kNCrJjiB4Tzyi4XzWVXuznfb+m0HDUjqOSG74qBLBF7ygniNSd+rAYZtr0C6EV4DB7IWdQ0J2/XwN@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1Jz6n3QjhenagvAzBmT07j4hYICu69jp019q082uFFMQBOOx9
	+dwMpdJa7JOG4QL/RPYnsdsUKBupAt0k8J3jvQxWJcCl/kFR1EF15dVeI2vCkwLiP/WzbWaoV1K
	+ceb75pKBE8quPbHapi0128yrnQMu9CU=
X-Gm-Gg: AeBDieuvGAzb9LdDP0bHY8/5Dg2bNMdzvwRhy9sCQ9YoLsxEy1iTWVIE3R7kcNMq7Lu
	1FoM2I1qfghlq1dTSYviyJCvYfWR91OWj7HvfMP6J2wVr4VqAkz9q6CWpezbwq2xcg9dCDkyLZS
	SzylYBE1vHNSxeYWXhJRLuLfYaoqqFDyoyIFGpP2XIV2x8Rh74CcFNkgJIAevUavXNJ5XBk+B5D
	cCbdGz9prc6E9P2pXUfb09FxA5h/eF/MSpY+x960xtKzn1XT3NYGUlu6iHFuGO7tx6naEYXu1Kl
	Uy0K/stiV1TOFy7EczplUhOXOgVkcldaCngYhawSu9FVX0eisNDLLgK685p7Z67HdhEY2sDIdeK
	Ce2DJKM2g+JaesrPRHniddKxOgTn24NnoS9oHyC+w8gHTvuNGe3PuwMO6mICVFQQnr6T+pyY=
X-Received: by 2002:a05:6214:300f:b0:8ac:a9f1:6cf4 with SMTP id
 6a1803df08f44-8b5475f9eb8mr17707656d6.37.1777600697765; Thu, 30 Apr 2026
 18:58:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 30 Apr 2026 20:58:06 -0500
X-Gm-Features: AVHnY4LrAFRsVRwciW8IDHmgnzdwttKqNxsUwE7s3SIycng1zIyVkAlyX5zeNts
Message-ID: <CAH2r5mvWVFyYF0szBX0aqOjFViPq7f9QEyF=UagFASZqVkqtxA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.1-rc2-ksmbd-server-fixes

for you to fetch changes up to c444139cb747bf6de1922b39900fdf02281490f4:

  ksmbd: rewrite stop_sessions() with restartable iteration
(2026-04-29 10:25:37 -0500)

----------------------------------------------------------------
Two ksmbd server fixes
- Fix shutdown (stop sessions)
- Fix readdir unsupported info level
----------------------------------------------------------------
DaeMyung Kang (1):
      ksmbd: rewrite stop_sessions() with restartable iteration

Marios Makassikis (1):
      smb: server: handle readdir_info_level_struct_sz() error

 fs/smb/server/connection.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 fs/smb/server/connection.h |  1 +
 fs/smb/server/smb2pdu.c    |  8 +++++++-
 3 files changed, 46 insertions(+), 9 deletions(-)

-- 
Thanks,

Steve
