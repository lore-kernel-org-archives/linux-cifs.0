Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9B719ADBA
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625773; cv=none; b=VfbNZIigLxQYShKC67YRiQ1TCzgT3DDOINsKzXW4MsRSrL8wSaQDGqHGGo+eFSyX/ChJlCTR4a4xJbi0M4A23sMzzQMYAOri4Q+faCAv0G+/kcYFm517la7Qr9D4PhAnw3RW5UdZttu7fOCw/YyMIBgrqwq51C07FWVY7wDXudk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625773; c=relaxed/simple;
	bh=ZPjUommKJztOBHxthEBJJTdyLZRsZCkBgHvr26AmOpQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=YBaO364vOd2ooexBCRQGLHmkjTICDb35JPSuEXgQBRM7pgqApg79ktXJmXv+omXNIZqiSlChWFYkYEbBlpk0FwP5yIk/qlDlfupQslRcQhbTa3e+U9GwGQC+rGJ6XTc00jR/fEq2+AwY5jkFyx87BIUSCHHckxFJFUoRNl4Kr/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GWSuzOqw; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWSuzOqw"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8823dfa84c5so5130756d6.3
        for <linux-cifs@vger.kernel.org>; Sat, 08 Nov 2025 10:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762625768; x=1763230568; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YpuhHnfYFh1OuHtBlzws854zn4cGJNw7nQ8ETfR9Qm0=;
        b=GWSuzOqwPE6UOysr5mvSmCbyswU+rS6V+E0gxmI1HcGsVqPz5918Z3tfY7Zlk/nyyC
         4EDmKYa4w6pg6QL4OTPg6hQpBvyGrup7N1eaVM4C59YlkX2F3P2I5mmX1QyfCiUl6o7U
         z9Q2ZJxO4uj3q4W6NvVFBWEdzutfqlb86ClDFgBntq3ZGFwffXJNA0J1FNHFIPvdHoUU
         aJ9oinGf8ffhCp+Xsi9aiFqyeMvZNcenszGrCzQ3315ovYZHDsvG9Tt7daAGij7/CyxK
         iKu7jiVuY2YkLLRNPbxysGKbGMkCOOgIzMEb5TDVMl0KPORpA0UDWGh3sz+f+Lry2ruC
         70Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762625768; x=1763230568;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YpuhHnfYFh1OuHtBlzws854zn4cGJNw7nQ8ETfR9Qm0=;
        b=lkutXrnnlQQsgCkuAv2+YhDj7ptbe0j93iNqh+us2KllWjNu9ysnCBvifRl9VezgdH
         UPTZzKv2cjQwTka6RjE6GqPRDibEwX6K1yyosjdhNP3LBcTeTYjxtcXS6XNRd3nmorKs
         TKevhVXEyqBFkXLxx3y+CZLgn7opzXpIFAm0WcXtPfEMXfJnT+uvwHflRTKpHTj4bVTA
         PXlN922yFGdvDxzhQq4zeieUMCwrKpF2PSVd6L7zB70nBcyrOmiUKb4iaDJa932elNqe
         L6wgIaJaS9vzB6ixc07aaB4OTsD7bV6CS5Z2lV7GZhO+W4rKD/NqbPsBNiEaIA35nSuS
         EEmA==
X-Gm-Message-State: AOJu0Yxtm0blm0bYfx/5Wfj4QptFdIZcDvjOSYOhV5UeImhYXipx5nCn
	HqPKVVO6vYM77IcXm979xLFRBCO1VqjsQtSRkhndlGhbbBS6bMJAO1PLwjXa7K9ugiKWGd0CyFj
	Ka5FqH53uGW+HrNblRG1SovkkqR7eeY2Iq3bYYvI=
X-Gm-Gg: ASbGncvioVfgTn3erTYtJpGc9oPqc3vgBsNVt3QOWUPKOe9x4GnbUvlusihqkYmLDHv
	RoUNJDjKk8srAkFYjvYvJUaZ0osp+eiwdc8wW/RncMyP5yOOlJWOvNgbxLdBRBtONsCtNyNcM9h
	oBQxycaeGZ0+PJGojJlSfgHVIXIQyGXHRUvZeIxj69QK+gevlRfu+110XYdvDRsEdehTLrKlnQY
	MQJPsHikgJcVbT2LTNjXWatGLSIWcRdND8QwqAgrE/J0A4JMXqH98COJzrgHI3FL1dTu11Py1wO
	XvNRHiOi9b8aoJci2GmTjJJxKKXQ2cBFXYwbSk62HdeIXn3cV9JP0ZVGjgFY7HWl4mWTYi3y4TP
	Zzg1y6lNXYFo+lSaXWLN3n6xLuSgqRpTE3FDVKA/CHcbjCWeJg7TjQhfGJ3rpBh1fuG43Gjgy2E
	tFNHB8EzwPwg==
X-Google-Smtp-Source: AGHT+IGLP0vr9cIpKSHIEVh6wrvBWb8spM4WCyR4eNF9QEi5QisAGLNnyJVPq9/v7x8n7gYND2116ms7uTu+TimR9ko=
X-Received: by 2002:a05:6214:124f:b0:880:5813:1551 with SMTP id
 6a1803df08f44-8823861233bmr45789156d6.30.1762625768425; Sat, 08 Nov 2025
 10:16:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 8 Nov 2025 12:15:57 -0600
X-Gm-Features: AWmQ_bnbraTGx_UJWPW4eq7AIIrgXBSBIEm2hU6QEBHRT6GLGfANddX7Us_1WdE
Message-ID: <CAH2r5ms=O10HuH9SvW59h=J50dmLUsqYTKoD8jqAvcn16aergw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
6146a0f1dfae5d37442a9ddcba012add260bceb0:

  Linux 6.18-rc4 (2025-11-02 11:28:02 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18rc4-SMB-client-fixes

for you to fetch changes up to 4012abe8a78fbb8869634130024266eaef7081fe:

  smb: client: validate change notify buffer before copy (2025-11-07
10:15:43 -0600)

----------------------------------------------------------------
Three smb client fixes
- Fix change notify packet validation check
- Refcount fix (e.g. rename error paths)
- Fix potential UAF due to missing locks on directory lease refcount
----------------------------------------------------------------
Henrique Carvalho (1):
      smb: client: fix potential UAF in smb2_close_cached_fid()

Joshua Rogers (1):
      smb: client: validate change notify buffer before copy

Shuhao Fu (1):
      smb: client: fix refcount leak in smb2_set_path_attr

 fs/smb/client/cached_dir.c | 16 +++++++++-------
 fs/smb/client/smb2inode.c  |  2 ++
 fs/smb/client/smb2pdu.c    |  7 +++++--
 3 files changed, 16 insertions(+), 9 deletions(-)

-- 
Thanks,

Steve
