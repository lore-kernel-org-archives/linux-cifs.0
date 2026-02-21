Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00391A256B
	for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 01:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771637641; cv=pass; b=XxiKN7DutES92oS7PAWV3ks7T1A2o6hRh/8cdnULe0uZJbrBXvxCnZy1vHuZ3E1eNnPWWZ5EasyqaVyDNAsWuGR12e6rrgziJfa4Dh18MnOPag64NonKUxBggmx6H/JGV735grJHqsIdPh8JniKgE640MLj/L4oTGuf5OZ9S6LU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771637641; c=relaxed/simple;
	bh=zPafXivFiw8guEjjjhCfWnhC3lzcwTdN3GhnKoPeUtM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ZJAlP6vGyhrB6dxs5c3rXIQQkOvnoYW4djoSpetw67KZXuZza1xXw1tzyaCUDhcLUOsB4HQIVq73e8O3IhhlshlMsWlIAO9yyZKcljdrVpH6tRp7gNyyrqW8SKg/uS+HuuzNrbUy/lyd+0wF7ha1C+YZq7nOO5BbI+3bUrEA9Oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UudpLRtP; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UudpLRtP"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8947ddce09fso22369756d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 20 Feb 2026 17:33:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771637639; cv=none;
        d=google.com; s=arc-20240605;
        b=iFG5AjnWvJc5FU1J+2lCQEKSVx2xYQjXV0Gm4ZcQbbsA5CGyAb9+fTmluN7gJoaABG
         es6NnOn2ZR9TiG9axy2qaU4QnhKKGd30Vpv+WPj+GE7KL3PF5ghm5lT6KhyL2WNMIra6
         AAYWTIzDgkFejKk6/OtGTnLqescKxs7Tv625W6ZABxpJXlfHKa5FShbkJjOoGQ8gGXNT
         nKTGQ2RtoIsDV+BeR03xFiCIAmOt9tHEbSb2St/7+3du45nbwU7ggRhxPDYZjRyH5pgI
         jjgpNZXzUmp7OxfXKvqXSWELzR/ixWWAqS8n03kXy3uLZW+7Fkkd5tdnRUcMyA0Cs4zL
         6QVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=13SiDwv4b16EjFJA9x7SC8NACd/UbA0Xc1s8ZFHqa90=;
        fh=9KZjz6Yo7bx9rcSTJ8uxCPKIa/jYCe6xfJu9dAYq2/0=;
        b=LVxrgHX2w3g2KoSVCcnleOQPQl78KX8vofZPDjmInERRflykrYDe6ZP3x6Qx7Q4IIi
         OnmvqoibnjfmCByzww7cDarABKgt+OuDShz1hDwi172sCh/A5jqoXD8bZOTEBxuzEG1D
         qSXhEz65UhFrrTavJrDq8Z0HJNhvFhjy5vvbdRqOV7AjRYEX612haJb6nJnhmvn7AWMo
         dF7cpglLGvPljrjOV/OTpvjtmTyVb1GjfmL92YLK95FrCPhzpq97KBbkle7loHuQK8PN
         MXfpwJr/DasXPMTB+0RuXXbsHlyqm4XLghkjS4zRX4JMV5TL7cXfJe1R5J1RBxeIyKTT
         MUWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771637639; x=1772242439; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=13SiDwv4b16EjFJA9x7SC8NACd/UbA0Xc1s8ZFHqa90=;
        b=UudpLRtP1kq31stn0IG392TQyVRs+Ve1eyk7E1h6/Jk244QXt7/2GX8gDPgrQGuETZ
         TBJIXCsHeiXFyclizLInndx7U3274gBnHfCHDQ866KqZOj1ktP5IQSiL6BDF8sV6DL7j
         7T3BWHwgqsDgPCkpZMIgISjCQ0CN6+OmnHWHG8PqpDsfNTOu23qXXLtPYyjK1C33NgEU
         qsg7f5VEoyqqoC6YmUUnaPmdZ1Wbh8kj9MGWxwJMEr0EqlE0oPuPgAMiuGYHh1C93axF
         U4PZspRTa2R/PMF9vC909wzol7iBA3qhoSShCIePi56OKSv6vnHKFaaPu6EzX8yZBzZU
         HHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771637639; x=1772242439;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=13SiDwv4b16EjFJA9x7SC8NACd/UbA0Xc1s8ZFHqa90=;
        b=j7JYevvJDFNGaeWcqro00nwdxihfZIVh6dKhsjPLEo39KMH4JREg8IP7TE59nNJrWz
         FdJb/4TtRRIxxhNIASGEQlOWHTjwRUbGcHG2tyMHROm4WLTxHk4zSF20Gg+uy2Erq4Mi
         I4r0QULBRoPEfLzPbjtzU0n9qOtJTttYjV6/VbegBmyNvv3tOT4JZpo5K6HSL2KbeVY1
         rFk4tCTvJhwk/+HGPMQF9MG9ryHpK4Cx0ntFqtxAL+yhMz88ebkopHhRcsSxvMRpCRJa
         9okGWI99PSMiPaLU3NRp+wlzHVrdJWQWNe32iMxm1BN0h4PYLwGe4Kmk1HSgfsEycY7V
         ZQIg==
X-Forwarded-Encrypted: i=1; AJvYcCXasd7h3bT4/9mmGgxm3DtwRrNsFsB9gG/XguJeuqAWHMnfmWl36ZrHZ+ZafnndQoEbFpTWFiLp+6Y9@vger.kernel.org
X-Gm-Message-State: AOJu0YyPESHnZZ3nBZUfRF7FQ76EC1P5qXndDSwU4NVo649srkMQlG48
	h+pEqQL2mvtUwTF1ZrcByOjXAdbT5mzB/hecQsv/ZwkSStcJr7VZ87nYYXsDlULYKCNrYeQe3i8
	tF/KZNSBDWy+hgfmNG4Nds9K4btSRmHs9Px9T
X-Gm-Gg: AZuq6aJRfhWv+v+IQaJNlbtVgAE7c8JHjrXpBsBHM56khqcdf/JcSlVyfTRsqGAljGE
	q2xKRwIx6jeLRPo7fVtVo6pQayHA7cjFHmaHW4zQvRsi0mD1xo8bgwb5ZIuI2+At2v+2owHV5pN
	IbngMO9pldYw6bdCtFSwxH3Rc7JW4/Tda4zXgX7gyqiKWjDjwXAgUDexd1RAmqLxnSlYIFHlLiZ
	AAuy6ir08suBegMwYyEciGjklQQV1DIoWokFjhuzVHgoEoX6sncULawzvMRZ/x5IoIaJlGTcQbn
	b7cEcw3MWVZ7tQ/UCuWYpHM90LhkabkvUvFuqoFYOd4PwQKGg/d+rf69MkhuvFy149OTHp/EYNY
	veawjTxrepGBIGVef0OAYLvDVSOWgMb/TvKTnqRhxL/53/Ha7ffMoRTSuzhDJVd36I8BCgM/m7D
	Q92L3Z8W+nSOim6sKV9/MM
X-Received: by 2002:ad4:574d:0:b0:896:6be5:b467 with SMTP id
 6a1803df08f44-89979c70e27mr30321126d6.19.1771637638753; Fri, 20 Feb 2026
 17:33:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 20 Feb 2026 19:33:47 -0600
X-Gm-Features: AaiRm53bVSLkm5SsVUSSwQT2x6YE0G9cxQz3HGSGcksDY4g6QKcuH1y81xGJ5Ms
Message-ID: <CAH2r5mv80H+O0VYjCuUk6ipVTMOiESAiMpZ-rYffnc=szacFfg@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
d53f4d93f3d686fd64513abb3977c9116bbfdaf8:

  Merge tag 'v7.0-rc-part1-ksmbd-and-smbdirect-fixes' of
git://git.samba.org/ksmbd (2026-02-12 08:31:12 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.0-rc-part2-ksmbd-server-fixes

for you to fetch changes up to a09dc10d1353f0e92c21eae2a79af1c2b1ddcde8:

  ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths
(2026-02-14 19:26:26 -0600)

----------------------------------------------------------------
two small server fixes
- fix potential deadlock
- minor cleanup
----------------------------------------------------------------
Chen Ni (1):
      smb: server: Remove duplicate include of misc.h

Fedor Pchelkin (1):
      ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths

 fs/smb/server/server.c  | 1 -
 fs/smb/server/smb2pdu.c | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
Thanks,

Steve
