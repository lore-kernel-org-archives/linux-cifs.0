Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22141259C89;
	Fri, 11 Apr 2025 18:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744395751; cv=none; b=G33xte22i5dmcAXfJvJS5zHRE0teV0nqBYMeA5nyVKQfbj8k32dQYq/aVRNK2/oapynuxwGuAJUThen1LGViQcQQgPZPiv24maLR2kRQvL9q89YVMLZBc/UxSJ5CprdyO5btZRYeE/DN6k2ThFoxWvflVoZ4sC+M6Jm9FTXfcjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744395751; c=relaxed/simple;
	bh=0aVsKpoxDCZEM5foVfloI5xLHyqmA3+Bmu/Ors5sibI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=U157HODrXmZRX6LJ4HFaN1LuyMnw3Wea5UFZF9u0I1JBnCu5srGnhZ2Fxr23i1Ze+hKGwJ1snjWEThWO6XKXc+VG0bvIiy1wVDQCI/8EzwOZ0T2S2MJHgrDGMZEpJWo7xb4Yk153sV0JHo2uMelj9QGBqcIuJotO/oo8OpIHPBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SGfkznTQ; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SGfkznTQ"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-30db1bd3bddso20992321fa.3;
        Fri, 11 Apr 2025 11:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744395748; x=1745000548; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XeW7hlyZxMJKSBIyEyesFMLc+3fEM39C3enTDpu2k/8=;
        b=SGfkznTQ8g+xmMZ+fmfzpzzC8AozpxHIvUvngS2WmfcbcTDOzAHsKGFovlrQW8iTPt
         rBnKb70Q/5+Vss7Aho3MBLtF/txzmfifuF4sSCK1b0qfkjQfShdc3B7+PNM5mekieRdC
         CJajLGy2Ew3YMBt7tAmCVosoHZLdnbhElBtO3EOMl4Z4Ql66cDFOctUU8f9gMBtL3Hjc
         QlkY9nykcRVYL343MNuHYDV9orV0Yp6JB4tHWvLJz1Ygpqxt8P800J1vlj5CWyFN8agI
         Bm8JL818LLQei89vrKlWBRSJiOPDu0gsIi9k24vbLAbVEhFJizA2GOsCoUGzSLUaZP+K
         FMDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744395748; x=1745000548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XeW7hlyZxMJKSBIyEyesFMLc+3fEM39C3enTDpu2k/8=;
        b=aixT1wACWaPEB6HeYP28vR+keKgwDFikZNwq+3tlg169jWmBhOO07xDrSG9UeTiLCw
         Vjur/E6azA/wY2JH+dcClg1Goom7V0rnWcmZuLSQKz3xs5/3/c6QcnzvIHtfvuNu/728
         a0nfgEMoiQtlUJY3E6hwQDu57sSIMp+eYKCCpb5ThPgpD3rEJ6YSNeROgXtz7b5F3aHV
         /KReQ4UmIZi/ZNkq/GWtcxbmr69sYcbR4VO7jmBaqxg+1DSn4MZ4hTFJxycGg3cSqUmY
         VZ2193CanED6D+gYdmeD6VGypDRj+31i9bKhnVnVQVASMy92hNVPvMtG1eWaWywChGvQ
         Eryg==
X-Forwarded-Encrypted: i=1; AJvYcCXISemwcarvOnyQwvsmc8FQ3dnPOA0YLPZlzRdMY0XPBsTw8Ue0iiTnlpxA4sP+DBWxWt55OBY5linyMI0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE+yTN7Y5wpwHP56Sw/98/pATIp6e0bAzspc5864syhOolJkFs
	hohGKQLTl1aUr89w76VxX2TRdXggkHSWv8ptp3MFxYdTAMTPkdOnYRY3nKoWkJ+hPZArV5+zD/O
	4+HURMZ1QGw7hIy9OYUTuCY12AmgzzbEJ
X-Gm-Gg: ASbGncvmQsToC7qbNwg75LLVylwuKjYXXVhF9DQ6ioNfJcqTCAvm8z4ITAQ58o31ofS
	dL7wrIU6GAFDZBASs6x+gnnQ5XBeRmSEfmuFK6JtwrN37nCfdFjULeD5u2dWuI+C+bXZGOGwu+n
	OFkbmHHZWf9LHjPyNQLIwpj5jgLFroj7/pYwwA7HOm7BvovqQc7AnNjgk=
X-Google-Smtp-Source: AGHT+IGkgUc+FUWwSvhlSUCCf/WHhHkZZi+0GHVG+rtMmrS04/by7xP3X3TDVgvsJz5oj2NXB8I0w6e2J98ZF/8QTuk=
X-Received: by 2002:a05:651c:2103:b0:30d:e104:a495 with SMTP id
 38308e7fff4ca-31049a8d431mr12975411fa.39.1744395747864; Fri, 11 Apr 2025
 11:22:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 11 Apr 2025 13:22:15 -0500
X-Gm-Features: ATxdqUEmWaeZmX4NtJh-6MQgiXMqQcJfhu3zk89v0ROZnNogICWYXAMNxnDcnq4
Message-ID: <CAH2r5mt3CCXVEwdsrqPe1VE+xebPSh2k4Wg5Zqqp_OCm+m7cPQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
0af2f6be1b4281385b618cb86ad946eded089ac8:

  Linux 6.15-rc1 (2025-04-06 13:11:33 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.15-rc1-smb3-client-fixes

for you to fetch changes up to 56c283b9e001098362c76547cfaae022d48549c8:

  smb3: Add defines for two new FileSystemAttributes (2025-04-09 23:42:16 -=
0500)

----------------------------------------------------------------
10 smb3/cifs client fixes
- FIx multichannel decryption UAF
- Fix regression mounting to onedrive shares
- Fix missing mount option check for posix vs. noposix
- Fix version field in WSL symlinks
- Three minor cleanup to reparse point handling
- SMB1 fix for WSL special files
- SMB1 Kerberos fix
- Add SMB3 defines for two new FS attributes

----------------------------------------------------------------
Pali Roh=C3=A1r (7):
      cifs: Ensure that all non-client-specific reparse points are
processed by the server
      cifs: Fix support for WSL-style symlinks
      cifs: Fix encoding of SMB1 Session Setup Kerberos Request in
non-UNICODE mode
      cifs: Remove explicit handling of IO_REPARSE_TAG_MOUNT_POINT in inode=
.c
      cifs: Improve handling of name surrogate reparse points in reparse.c
      cifs: Split parse_reparse_point callback to functions: get
buffer and parse buffer
      cifs: Fix querying of WSL CHR and BLK reparse points over SMB1

Paulo Alcantara (1):
      smb: client: fix UAF in decryption with multichannel

Steve French (2):
      smb311 client: fix missing tcon check when mounting with
linux/posix extensions
      smb3: Add defines for two new FileSystemAttributes

 fs/smb/client/cifsencrypt.c | 16 ++++-------
 fs/smb/client/cifsglob.h    |  6 ++---
 fs/smb/client/cifspdu.h     |  2 ++
 fs/smb/client/connect.c     |  2 ++
 fs/smb/client/inode.c       | 25 ++++++++++++------
 fs/smb/client/reparse.c     | 63 ++++++++++++++++++++---------------------=
---
 fs/smb/client/reparse.h     |  5 +---
 fs/smb/client/sess.c        | 60 +++++++++++++++++++++++++++--------------
 fs/smb/client/smb1ops.c     | 53 +++++++++++++++++++++++++++++--------
 fs/smb/client/smb2ops.c     | 14 +++++-----
 fs/smb/client/smb2pdu.c     | 11 ++------
 fs/smb/common/smb2pdu.h     |  6 ++---
 fs/smb/server/smb_common.h  |  2 ++
 13 files changed, 154 insertions(+), 111 deletions(-)

--=20
Thanks,

Steve
