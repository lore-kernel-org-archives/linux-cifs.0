Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9BA2557A;
	Sat, 19 Jul 2025 04:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752897783; cv=none; b=WFldxXPbxzTGvCsb7CoXj0IzQrbRafRPIPT+QIFYnHg3FaK3n3RDWxYtFNgcQyTyVSGUIELrLbsIO51n/TslAFZhJg9VWJA1P8LAINnOVohWLHvRC8ZD1ApaL7ffewh10KrBuvqm4VRI/hvUxbt1yd3uPHA/XiG11MKCtOmXzQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752897783; c=relaxed/simple;
	bh=QJYtj07mWOU5fCCInMKerzvpfv/eT3lhRd6Pc1iitiw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=k2YVQg2g+AyVEz9TGQ0ig87S3V8fmgxxvm0aju126F8KykoaiavfdZcy5GwWkVgmmRoTBBSMxwMU5mOMZI3wffXwbefR1hzDL40/XqLkMEVPAlp4bIi6Nmsf9p1CojGIzK3309KE76bk3R+7CZDyySya3e2/zC0b9wo0AqmGhFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dPvVftal; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dPvVftal"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-7048d8fec46so38689366d6.0;
        Fri, 18 Jul 2025 21:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752897780; x=1753502580; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0lp1Yf/k8UsFif9a5gBYtii8uEjPKY2WnDmYxFUXzCk=;
        b=dPvVftalN1cGFXdVMgLRbBUGAiqaiDCrFnd3kmFmW2EPZAyxIcRd86QSzhX/kBmXxj
         ZZPAZWrXWDCKJboe306OF6UnrCVP8UHJgxdAQk4UsSQ61LdZLpvAojFz731WiN834m7+
         MzRoncT18suMiQ8ovsEuIv6B00EaSs6SffO3krQp0AZRCqbblr4smmy5Q6rWOce5vWPe
         nEeSrlAPhVjhh4OOzSb5Zz2a8R9awdXa+EnNSqOAymdcz8jP3H1kpoUrH2E7iaVLLLvs
         JLbkal9Py0CgUj8XB2aPyHeprIMkC/kKXyuFCUMkR+k+GYii0n595+g/MSuauUtoOSjM
         rTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752897780; x=1753502580;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0lp1Yf/k8UsFif9a5gBYtii8uEjPKY2WnDmYxFUXzCk=;
        b=JLehSaC/6Ky8ESSqWXPQiVYfENk/WaZr3jLj0wbxJRr62+hXdou//95O7k2BIUGbJQ
         66vDhz9cTzTI3WTV5dDvxck3Rp3V3sdCEvz1V0CrUpk4ZcWFvob7nLeJIUdVfsZrwZZ7
         tQT2YUO57hNRS3nHMUAHh7RlUClJoNNGub2nU1ZgtRVkzGGTHt594G5BZAPYHMfnuor0
         0bKsKAPNyVHAtEeJBv4K/mW0KypYZzIhAQYdLcGmKcHHXJgsqxjvEspTEvXNQ0c67yV+
         aI5nxxovM52Z/1FbqvIZLDCLLFpmVypMFo03GM8YXeuMJYB1A44ByAH4nfZqe2jFLfhv
         4+0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUfqdLLwrujVInmsi3iuOMjvzRw0LZeNTzfJiUhcU2DkSY0WNEC8H6ABzqo6qbLY1awCZo7aEIrS85/+jg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxC9BVg5+Qtq/eVXGsMCjldAuEtU2iy3Wq4be9tW/ILRP+pCK0f
	QOX7fvLolUHThg2p7cUAmmp8jUSIAt6k2r7d5ZEHxrjOKBKC1XNco0QLTaUgTBYpo+GOsR+cIHU
	vmAK/5Cp7bbbPW7ioOfF/lpAxstVb8B11HSVQOGw=
X-Gm-Gg: ASbGncvVtY5E+7AS/DS/zxeptEk847YZj7zUVVItunpIXLpAVslfNdtwmfxqjpPSVX7
	sbCxq+Kp2dD4Sva24+hdpqejGpZmoQDVXnuGwG8ULqKOg34BU9RwgYt1jxOAlYYGFYKfxfz3MWU
	DnI3qJ/W1QpwujO6f/krPN0Mmlu+3yFbGVshoMF/EnvOAi4xWYz7m0L2PTsSFneqj8rqCpPxsVv
	y4vRZHKGI21ymtt130U/0n0ZV/1aCTHGAotrqMJbbK2YJpv9KHS
X-Google-Smtp-Source: AGHT+IFJMI0UsEUNY2xOijhIntoR9+1k7e9BSsCohO8QxvP+Az+D1+KrrZo2a4O3mW2+I4QQtkcrAzhVfDq963K/CeA=
X-Received: by 2002:a05:6214:4e90:b0:702:d756:8a05 with SMTP id
 6a1803df08f44-70515fb2106mr98681536d6.16.1752897780263; Fri, 18 Jul 2025
 21:03:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 18 Jul 2025 23:02:49 -0500
X-Gm-Features: Ac12FXxJe79t-QEO6EFR3pG4uR7-rUMQzVEMT6SmF36jyHT6s_ZuEw-yvLd33YA
Message-ID: <CAH2r5msnypvFXCtKuDuA=kZX6vCTVaXVF3OmvLRTZoWwYGrdOg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
347e9f5043c89695b01e66b3ed111755afcf1911:

  Linux 6.16-rc6 (2025-07-13 14:25:58 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc6-smb3-client-fixes

for you to fetch changes up to 8767cb3fbd514c4cf85b4f516ca30388e846f540:

  Fix SMB311 posix special file creation to servers which do not
advertise reparse support (2025-07-18 12:12:02 -0500)

----------------------------------------------------------------
Four smb3 client fixes
- fix creating special files to Samba when using SMB3.1.1 POSIX Extensions
- fix incorrect caching on new file creation with directory leases enabled
- Two use after free fixes: one in oplock_break and one in async decryption
----------------------------------------------------------------
Bharath SM (1):
      smb: invalidate and close cached directory when creating child entries

Steve French (1):
      Fix SMB311 posix special file creation to servers which do not
advertise reparse support

Wang Zhaolong (2):
      smb: client: fix use-after-free in cifs_oplock_break
      smb: client: fix use-after-free in crypt_message when using async crypto

 fs/smb/client/dir.c       |  6 ++++--
 fs/smb/client/file.c      | 10 +++++++++-
 fs/smb/client/smb2inode.c |  3 ++-
 fs/smb/client/smb2ops.c   | 10 ++++++++--
 4 files changed, 23 insertions(+), 6 deletions(-)


-- 
Thanks,

Steve
