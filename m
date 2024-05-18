Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03848BEA;
	Sat, 18 May 2024 09:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716026386; cv=none; b=CuX8BfqkcbXs8foueNs+j5uZIrfbGk4yqmUPg5zTgCAKcvZ55tXNFo3k+b1W+zGT0/qJT0GxN3Ebn1XOcOio8lDv8CBQfyQGxyGHJwXlxwbhZTKdw9Q+op/gMaJ/u4Tsb+0e2/sf6lM/dfo/uUx19Lx8KsSIHAg113Om9TBjRGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716026386; c=relaxed/simple;
	bh=L3kPstBMv6aXX21Sgvx9YjumHQMWLBhZbrinVkSwwA0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Th82wVPlmwFlJarOFa9r3zMoZYhza+UFS5MILtSTCgf/9SmwuP2kA/gwhs4r3J8RbIydy1xn9JPD4Y9K0b+rB8fcuMLP39IEzkh57L+wZxlq4/UAcZWIWWKwNE3NFMH0F3j32RwjDCEHBZs2y6N63bHk/S0S1YzywsbnALtCmHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQboQlec; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQboQlec"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-51f99f9e0faso3241231e87.2;
        Sat, 18 May 2024 02:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716026383; x=1716631183; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+H5vJpVIpZOz5Cbd499dwyXdB2lEblIJweWz8Bm/60g=;
        b=lQboQlecR3Pc2FHn+C6Q2mPf33bnpUJy24k+ToYS3a/SdgGNexu0roV5y+3A5T+2z9
         RZ2O4YSsgvEPEe/VLdDsa+ZdE25cC+7+WPR8Xj1AC/LHo9keW8KxvBr+NO+HFzt3W9R7
         MeQz2OtXOJoDnJdtMYz1j17M2Ds0SXyAGUNdznBmnxHISFjgxWTvXxFeS/oNKOlnRzBP
         o6406CYbpkyYsM3BNe+SreiVcugeIeLmlnoC9GCYncT/E75UrlKfK7xXs+Do51DBEVEN
         u+PRWycdMQ4qajT6ve8jneYNuHp98HXSB4SqW1gV/CVmsIM46wrZh7SvBVdPX6hYJlyV
         EMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716026383; x=1716631183;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+H5vJpVIpZOz5Cbd499dwyXdB2lEblIJweWz8Bm/60g=;
        b=i5V93VcEIcHQwezhZJF9+WgPJXxVPFi/fykceVPdjLTGdmy20QaSkyHHF7r9uhPpTp
         h7aI7tQXAiqQjE5T314aD8ilVrAO/o9kN/LGie+j+P/+j4tOxCrqJKgyIY0JSVIYgxQk
         0dOR5PIodoInaDVBVFKgYGAxuHDIXKW5YmEcA3dXRwtnptw9e3MxHm8NSmDbGPBFaoUr
         iLvVCVTkF2UaJANrmVQVcoOxmJcvEyGsErOOVjvRImn4eM0k2l6ILy+UJ0pOLNyAF1TI
         9eAZszDnG0xpOOHwr8fq1/uXGe0zx+FvVVmSQm2C8GdtLctE6iDNHOqqof8/BcjXcyID
         954Q==
X-Forwarded-Encrypted: i=1; AJvYcCWGfUq42ERhyuTTnnPk5T4wYWmDmRbsQTaEY8b6MDDjvhJGX0G79euqGzwIdi40k6onFD7zJ+opt/hD+/cGMw7IvbFq2J8PeusVuvfD
X-Gm-Message-State: AOJu0YyaBcqFojq06EQYCvyGScBNyAg8a61x1WaeP917nEXCSbi3ABv2
	u1yWzbHTpsqqaV4r0FSliHi5Xypa0ABnuRq13FyQL0j8QDMzSRgm1tp11p3OITiIULyRNWViXyL
	oQTTeblo6ZSkCJnVUU1Ge+aSUYpw=
X-Google-Smtp-Source: AGHT+IHzRder/JdbsF4YvrMdFF2L4QMJLhsqGsTOwTU0PZdMHJc/yU7HWTv1mFpKTamXj/z3hRiAHgQeE5LqTTMdrz8=
X-Received: by 2002:a05:6512:32b5:b0:520:76d0:b054 with SMTP id
 2adb3069b0e04-522105845ecmr15504233e87.57.1716026382659; Sat, 18 May 2024
 02:59:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 18 May 2024 04:59:30 -0500
Message-ID: <CAH2r5msmH0Y=iUcu15eX3DiTS=Xdq=v1nqStWR20oVXYhAnFdA@mail.gmail.com>
Subject: [GIT PULL] smb3 fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
1ab1bd2f6a5fd876d1980d6ade74ce5f83807baf:

  Merge tag '6.10-rc-smb3-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2024-05-15 11:37:15 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc-smb-fix

for you to fetch changes up to a395726cf823fe8f62f1b8c3829010e5652ce98c:

  cifs: fix data corruption in read after invalidate (2024-05-15 17:22:59 -0500)

----------------------------------------------------------------
an important fix to address recent netfs regression (data corruption)

----------------------------------------------------------------
Steve French (1):
      cifs: fix data corruption in read after invalidate

 fs/smb/client/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


-- 
Thanks,

Steve
