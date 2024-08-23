Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A366F188A31;
	Fri, 23 Aug 2024 15:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724427634; cv=none; b=gDeAAKt4xYs+IwXOSBU7TcpFbZZyE1K6YKUYAOTk8g73VgvT7nLubfirlfjE9duaXLvUGshntiye3PUCljsrHbyfXCmTdt9Nk0DFJeWfQJZPARLqFDAw8X8JguGMSPKySpVmKEs7xTg9NbIh8o8/lYNafEbDo4k085r4GBDKHk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724427634; c=relaxed/simple;
	bh=EYvc2z4r8KJhwvuvfuWGqLDVrQzw5Yu1hQDrRK9pVEE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=eKOTs4MksvS0jRwYxL4ggDZx4WajUVWkGo22NBgvNZq2hziUx4g1HmVGVGOuisrDZzrQTX971A5nqw5aAOlMMJ0pyGU0FInK9wUymmKz1c4tDSqBzsDTyNfuDVjketiFEuReErJCPEug0ButWjlAXjasw7AAWbDBYHESALzkmyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fqSYtbNP; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fqSYtbNP"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5334c4cc17fso2870359e87.2;
        Fri, 23 Aug 2024 08:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724427631; x=1725032431; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hEQWqn8dp7u94ekJxLvXBoQKV3m1QuVREmUZLs3WBBM=;
        b=fqSYtbNPu/ttthEtDnjCup3QJ36bBD41UpxOKkNRkm7wcJQc9tD5+NUjdl7xrrNtSn
         gVUbK8vqRXP37KBXXzaSW8ocajqi5aiI1DhRgBljgMqnb4Vhv8KyV4CCX3tSynR0R+lJ
         WHjNVnxLnwvZownVLIg+hfoxgz/f/wxf/mF6ofTgWxBRuox3elhpPX7ZGOhOOEYUP7yk
         2vWCLnN/yGpGPzT2AgSEu8Wk7fY1gyd+Czy9VokI3NirNWeKqAhK7Tl8tTAesBDlRZd0
         eE0uJ34ME+BD2c1HXGINi9swCv9DalgJDBqYf7X37bqnEwTM30K5c16t1ueu4dW+ktzZ
         4Pqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724427631; x=1725032431;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hEQWqn8dp7u94ekJxLvXBoQKV3m1QuVREmUZLs3WBBM=;
        b=xLOM2o9JtiJ/OvZOZm5LTxk0KmB53yVpuoy/oU3cjUrE5/v0KHHaRRRP87QigJN0mO
         RnGPUu7E92RaKsSY3W+AaLOT9hzOVqUhjkKK+qY+padhKWcLUhqyeo72mahwZtpeyIng
         T2cuQhPDBDnJrvmz3MsYYqvJo/1oWCBPUNBQs2QayZykwbZA0Q+BuEZ5YjVsXiiMGAFC
         8T02HxNR7cIUzzShq0yB8jxMYs2U4gM/aftEV++TmaXGEzrN7oY/v3k71D+qgEaCwnrK
         qJ0Kp5bOwpO68rqTPI/AUh2QmptXcRoThRUesjoj647wstV3ITvv24OeRNxJulRmPt+q
         Fp+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQKznjhCa20X01iQpQO3g5L/nBFJ4BzDDNyQc3T014UNDaLz5XRlypxgzzLjoEel7tzICTHwcb8CaB@vger.kernel.org
X-Gm-Message-State: AOJu0YyrdraNDdpkPaxDK6LWhDQHY5D6SScMjr/rH8sxBqAS6HS9iNlh
	Wwb4jeKFYnxUNEX+BKpYFkNRTlcJVjj2xMY0n9v4iw7otwydXnLltxV1LSW8FnByisaJ4KUjb+P
	UPdnResfuGtfoIneS7ge9wox9dGA=
X-Google-Smtp-Source: AGHT+IHXgBJIKmGWqRJ6OLaLBSrjtRW1IRK7+JR/h33CfVMHutDvWZaNeElHHORP/C0HxYcY5bHZuZOAz26vnul0DF4=
X-Received: by 2002:a05:6512:10d6:b0:52c:d819:517e with SMTP id
 2adb3069b0e04-53438783b45mr1717743e87.30.1724427630352; Fri, 23 Aug 2024
 08:40:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 23 Aug 2024 10:40:19 -0500
Message-ID: <CAH2r5muykPAu=GaXaHRsfK2nU0jkREv4Pqd6cM5joLDbT+pZTA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc4-client-fixes

for you to fetch changes up to 5e51224d2afbda57f33f47485871ee5532145e18:

  smb/client: fix typo: GlobalMid_Sem -> GlobalMid_Lock (2024-08-22
15:44:19 -0500)

----------------------------------------------------------------
Four cifs.ko client fixes
- fix refcount leak (can cause rmmod fail)
- fix byte range locking problem with cached reads
- fix for mount failure if reparse point unrecognized
- minor typo
----------------------------------------------------------------
ChenXiaoSong (1):
      smb/client: fix typo: GlobalMid_Sem -> GlobalMid_Lock

Paulo Alcantara (1):
      smb: client: ignore unhandled reparse tags

Steve French (2):
      smb3: fix broken cached reads when posix locks
      smb3: fix problem unloading module due to leaked refcount on shutdown

 fs/smb/client/cifsfs.c   |  6 +++---
 fs/smb/client/cifsglob.h |  6 +++---
 fs/smb/client/connect.c  |  3 +++
 fs/smb/client/file.c     |  4 +---
 fs/smb/client/ioctl.c    |  2 ++
 fs/smb/client/link.c     |  1 +
 fs/smb/client/reparse.c  | 11 +++++++----
 7 files changed, 20 insertions(+), 13 deletions(-)

-- 
Thanks,

Steve
