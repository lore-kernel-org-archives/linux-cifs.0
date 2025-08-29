Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E7D273800;
	Fri, 29 Aug 2025 14:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756476099; cv=none; b=u4iDQ0rm/JYgQyAoc73PUTldJNw1Ek02jWoOazmp2biwksVu0UK5P9IXCX5ExiPCY/Y3Tvh3UZsVL3kxFajIBzmFqhlHHVxRWK8JVp50B80UulsluSSLSEeTu/tJKTW/uN9/WAfnyQKcMh0NqFp+JodXOJPOpV+Pk3PXPAdEpGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756476099; c=relaxed/simple;
	bh=S+f7bjMSJ6cH6GXdyXwQ/0KEPGSbaOnqko7y4xJFJ7s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Fsv1HVfUjjVcTLKMq0pJ5ZD4n4THybbCtYvJ5/EQ09aNb9ZHCiNtg/rMvGWLwXCnunHnp7bjGbqpgHJrSSDJgSPFUsf1USLcHKZBdAXOfpM5ijMVuKR3j2+BX0EycRAE63fCjuyaXW6mV7z3Lss+CTFdOIkXfacatIB0qKnZEzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IdkEcwst; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IdkEcwst"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-70ddadde494so18105766d6.1;
        Fri, 29 Aug 2025 07:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756476096; x=1757080896; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4lOdWyVg9el4e3f96sl922Opfq9i8gxq6BU3ptDNPzI=;
        b=IdkEcwstrtdfJfSNH2NR7WkZaxVkxIx0jSYLQ93bqg2iCGfKeCiSP4theQn1VGmarV
         ZjZjpf16TNudNpV/T1/z5UuPekfGUocJC1Mxd93DnqaXNkoTPRySeXva1qgH0HsmMS/B
         X5IiKM7+owUx3U4cfYM07gMvqGC4VHXkppVrP4XjdUs0+jqN0Z/UEvPQoptsS2t+cw05
         ncFqnqHTauJTHBGP4g6YhSluOw11IRbD55ydVhc852/8nuMfI8O0q4ZWG2y7jr6oMrnL
         ncTSttCmWFU+7HuMNyq4Vjb7AczzR0TEXAfn4NX9mfVL9lJ4w8E72B4R8GE9Nj93g3Ma
         Bsiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756476096; x=1757080896;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4lOdWyVg9el4e3f96sl922Opfq9i8gxq6BU3ptDNPzI=;
        b=MsOGsfN70FXKQiTlX1MkcnNo9Lhvj3WxMHW+68mzx7QNY5zzH6lNeA50KPw9KyGIvU
         xmsxROUjYeIyeEKrAkTVsOMnBy+YssLqM6ckrHOjuUlfSnuuIzeAiy+/Ya7ZcLnAcNmH
         nE5omWdq7M4o9jOCs1mKQUEELQPcjTdMvCjyFxnFKYLHiBJahrkOY58YMZpXo6D9Eqkh
         bGaHmy6gYPYsfBAtSlKTqV8qyaPggtQyg5kBso4hEKrOhWjOPDNqHEwfRWg4luuAW9JF
         79MB45UYTI6fJ2iP5snTNGvnmJ/LCUkPA+W/C96mt1UX6aSZcAJIklNBAkd7frlatlAu
         rBzA==
X-Forwarded-Encrypted: i=1; AJvYcCVObTt+fpUU9jbWtNYoIit2DupIYC6mXN9GichGki8VjcsCNPPqGU6O01fxuxos5MYWb79tNsfknPs4@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf3kFPtWxazVdlJgTPczzOdsEgaUXPsvdbfR3/SMESpZCBi475
	Xtw1/r94NP/W3EEXQTcQBQPu6A8nz303FrHN67CGNRAJ0UFMqQCOrzvSUH5jx44LVPT7Oufit24
	XCpbMVIGoP8dI0Hpe9Gy+SRHiP0mor2UJBQ==
X-Gm-Gg: ASbGncuQ4mA6jY3BuTtVpR84SPD0lBYF5PwNq2Oa8ndowk65mXQ0p1wJr4PulgwtbXX
	HqM7KYwFTFyLdtqGl66Ucq+LWvIiWMK9H/NUwsRojO+VZ4C1cSaYxhkNYpW6/kCC0E7HaXrTAlI
	o6zjZXCwBc+UkBavW3tBSpGLO0Qoc0zpNLVj+12t1nkTp3zRcNY4vl6ckiCHIfZ/Gthmr21JKLF
	o78ZPa9dFM2rTtTBQJ0ITzthE6U3SJ6hC1hs21hkGrOwSzjNdgENw8xFR4YMQBhq7R3nUBsAYl4
	6Y/bRX+iKTocjTCS3v7Yhg==
X-Google-Smtp-Source: AGHT+IH7v/8xvmVrJq36sX5xYfiEuPF9UXagF3uyrjA8NdOdl97k6GmF2dzbtzN/YlDOD438ofRlHD8zdYXHPLCLm2k=
X-Received: by 2002:a05:6214:2345:b0:70d:f7ce:fe5b with SMTP id
 6a1803df08f44-70df7cf02d3mr61191166d6.57.1756476095674; Fri, 29 Aug 2025
 07:01:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 29 Aug 2025 09:01:24 -0500
X-Gm-Features: Ac12FXw9hiNrAj6fVYKlliy6nhmnyL6mW3iO4ZOjKNlkMGGC2OigUgoyJHobOZI
Message-ID: <CAH2r5mvT2dSmW_pvop2A2GKYBRdXzyHGomg3dFEhF2n1N_XCHA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
1b237f190eb3d36f52dffe07a40b5eb210280e00:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17-rc3-smb3-client-fixes

for you to fetch changes up to ab529e6ca1f67bcf31f3ea80c72bffde2e9e053e:

  fs/smb: Fix inconsistent refcnt update (2025-08-27 14:59:06 -0500)

----------------------------------------------------------------
Two smb3 client fixes, both also for stable
- Fix possible refcount leak in compound operations
- Fix remap_file_range() return code mapping, found by generic/157
----------------------------------------------------------------
Shuhao Fu (1):
      fs/smb: Fix inconsistent refcnt update

Steve French (1):
      smb3 client: fix return code mapping of remap_file_range

 fs/smb/client/cifsfs.c    | 14 ++++++++++++++
 fs/smb/client/smb2inode.c |  7 +++++--
 2 files changed, 19 insertions(+), 2 deletions(-)


--
Thanks,

Steve
