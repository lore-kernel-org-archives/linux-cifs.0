Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E024A146A68;
	Fri,  2 May 2025 20:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746217079; cv=none; b=AKrAW4FAToXpC6SaERwMbORX7X/czuQ8e24AfFF5PyZRB6Q+dONyn+ap6pQKqpJJ/q045UkNyqlBdV3ST3xnywiBGqjlix1h2PdxfrZ+dT+4ICaY/4saoKUpePMT1L4OQj8UpCOe2B1l1w7lPvCbqXTYkeslPivQkdjU7YNGlBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746217079; c=relaxed/simple;
	bh=E5gwB1+Hj5oqS1YcS2EpyRAcex38Ij8qcYJuEEvjAHw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=h8E9rM+nuHZWCJ2BnM3id0Ou1vbdzoug3SLiSwbG9MyBs3nc74UlLGqqX35irMh50AhX4oG/ZBe7qt+t9oLBNBwDEwqf4vuxdlghWnB92XQUYKXLNLvMlY8QLqJoKtTW9raYxFULfRIg2ho82PDszxxPishraKDZXMiHVa+k30E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ByyXYM2V; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ByyXYM2V"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30bf3f3539dso25209651fa.1;
        Fri, 02 May 2025 13:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746217076; x=1746821876; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SaIqjq9KpAJ/+nEjnkzbnEUUUTwKcNBa7HBXrlZhXUI=;
        b=ByyXYM2VAKpbeHN0s3yWGbZPFbdS0viJPaMFVdn6VU414szNCJYzxGIFbjjpin9E4g
         7VmODe2GPP748mJCw9/vn2EKpopVq544iXOsnSCWY/npD+6PERg1dQ1MMImQnaPu7+cx
         uJ6SjkxFkNYxv3KB4V88mLC30etXyJVrstRGPjZmEnq9/3eYXcINvB2PrEtyY7aKWx/3
         bfLitrTGOejIX6I05kKdLSqf2hBfwmFR/+FWEyJWdWX+Kve0u+LXh0XvKh/IJ/5+najA
         XbGD4T2/3LCyEO431eN/873oXbTLIEpPOaiUzfDtQ0arU1eWas0N3NJxuC/2hB6RRn5M
         DzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746217076; x=1746821876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SaIqjq9KpAJ/+nEjnkzbnEUUUTwKcNBa7HBXrlZhXUI=;
        b=B0UgX2lzfK8kb7f36C+cZKlfCZ2FkskWPzeOl/zqvIYV5rJtK/Obhk1E4mDGue9JhT
         rRdyr4irW8ZvvOwebgTb5pEoObiVDQnHjR2dH5NP/NS1gJutznKQXkxxO5j3rsWT0ydk
         x+zLZD/fBjBKQ3Xjyq0yTX1Rwcnvu4CgwT0I/2NYegshVbWL/wATosGHoh30BbMYU8O3
         KG8rEJdutyrdQorruxlSoSmgqpbfXZT8XDgHJHX3O/uFEBp/+lZDy+mo9iQ1zrbcGOey
         dAd7KbcVYrmIELEdQymFym0dNowSBE1zzP5x0/+85gkeob2oMuMR+idmtL9/cwvoWwGY
         QIew==
X-Forwarded-Encrypted: i=1; AJvYcCVGFj3+bpqR2mmsglLX5vaO2LroYjemSv3AIQVpqRf9w3m/JXYHsL0ZLn6+cgbmrBcZqZKa5qqbCAGx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2Sd4L2w1/UNev9p8zcGvaCPEC/bVa6YZ1owO6VKpsle/pgcZG
	LtO5GodoZULufmTO0KjwqQljwc61XsTO81Pjy9+mxOkbKbKx1+z6VSJqKaHHR+ZFw+fH/8VfECS
	IFHrkN22wMM5vO5vu/JNCZPL3ZBVAAPdM
X-Gm-Gg: ASbGncsWvL930uCWDj/3fg5ny8AFoqFSfrcH2qGNANlRj7uCwSJLvcMQ1Yn+CfEBQk7
	vIsKsgiFU1L73ZvDdeCwaMwUS/YgpwTURHC0FR9fJdcRgBoj8YaqtX38036KMaU7jOlXDEYkG3g
	IKH4qE1oO2nY31ItfOF5IHlmGmPkafwjqDGZu/azRr3yWLT3u++P0JmV7m
X-Google-Smtp-Source: AGHT+IGUIpUOwOcjH8Jb2We6DvKK+Y9vC3VbvRom4zxzK8kuLQbrpp4eguR5QpLbs6UKaD39zSQNimjKImedo4vnQJ4=
X-Received: by 2002:a2e:bc81:0:b0:30b:aaca:9b2e with SMTP id
 38308e7fff4ca-31fb8f0440bmr23267921fa.0.1746217075658; Fri, 02 May 2025
 13:17:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 2 May 2025 15:17:44 -0500
X-Gm-Features: ATxdqUHhe8LA-u1SUoZI1t1lKuVpSxdtHJ51mjP2n5B4HdsAv7qKe-L79Iba8hs
Message-ID: <CAH2r5mvFmxyPuxTOzGVvDOq1N3nYwh2ogj7yA-rrABdXgGpjbQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
b4432656b36e5cc1d50a1f2dc15357543add530e:

  Linux 6.15-rc4 (2025-04-27 15:19:23 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc4-smb3-client-fixes

for you to fetch changes up to c59f7c9661b9d3ee33a21d7b4f1dd4b77079e3e7:

  smb: client: ensure aligned IO sizes (2025-05-01 08:35:58 -0500)

----------------------------------------------------------------
Four client fixes:
- fix posix mkdir error to ksmbd (also avoids crash in
cifs_destroy_request_bufs)
- two smb1 fixes: fixing querypath info and setpathinfo to old servers
- fix rsize/wsize when not multiple of page size to address DIO reads/write=
s

----------------------------------------------------------------
Jethro Donaldson (1):
      smb: client: fix zero length for mkdir POSIX create context

Pali Roh=C3=A1r (2):
      cifs: Fix and improve cifs_query_path_info() and cifs_query_file_info=
()
      cifs: Fix changing times and read-only attr over SMB1
smb_set_file_info() function

Paulo Alcantara (1):
      smb: client: ensure aligned IO sizes

 fs/smb/client/cifspdu.h    |   5 +-
 fs/smb/client/cifsproto.h  |   4 +
 fs/smb/client/cifssmb.c    |  57 ++++++++++++
 fs/smb/client/connect.c    |  23 +----
 fs/smb/client/file.c       |   6 +-
 fs/smb/client/fs_context.c |  25 ++----
 fs/smb/client/fs_context.h |  47 ++++++++++
 fs/smb/client/smb1ops.c    | 223 +++++++++++++++++++++++++++++++++++++++++=
-----
 fs/smb/client/smb2pdu.c    |   9 +-
 9 files changed, 324 insertions(+), 75 deletions(-)

--=20
Thanks,

Steve
