Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF791096A;
	Thu, 28 Dec 2023 22:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPel9GsK"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ccabf5a4beso50675181fa.2;
        Thu, 28 Dec 2023 14:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703801380; x=1704406180; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MuNkt2PB+Z062eBAg21yz2J6ycJCgagCNtoRGXOXMpA=;
        b=CPel9GsK3m3ZFosGQ6tUsiSqA4GgAvh8G+lluYZqzKXXCpWxv2bEvocKQfnXVQPmh0
         8QFwyDF09pvvdLIVLeW1BmfZcPVz0eJg+CLeY6pa00QLTQ2FaAYtJkEPGKiANhMehLVV
         dvL8m49Tpbna8BFNRvLspwVzF2SUbXLHY3pa2GszrxxqW8Y6DjN4OpArzQ2aGht3sYpa
         9dpYzT0kv/3mEsrNvhunLbl/l8F5/EC1kPyTiUGFdIdkZNSxQHJ3Y9L6fask7UiGgPTG
         0KFcL8lUCPr4oD2Dmzvp/2XSVmbGYLcmj9uox7cJWraNAUGIlNzRPqyR+VjS1CeeN6a+
         u6+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703801380; x=1704406180;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MuNkt2PB+Z062eBAg21yz2J6ycJCgagCNtoRGXOXMpA=;
        b=ExVTWlKIZRkQo7uwgc2N5XioRyuBSiX09crjVCIsvMxolZoHmRljGLC0M4ictCGV/1
         RDhK9CG4xtzcPCcvx4A37yg22e2Y714JSf3upYqJOo5tX7GoN48e1AhWbnP25Qt41JmJ
         3q5XpicidLxfM2N4ocloOqqiyI/sO9lFkSX/YWDgsvzmkUvlcHFjXd5BHiMcEZ/oeRea
         2PqzNY+gMRWPLXaut0XLHhKdEQ4bX4D7URPVhzPAFi+Es0XlF+8Qm8Ppj9dA0PRJqrR1
         8xpMXjXBulvMH3SyOjMgRr4sPvMbKw7oDGj2ci+cT3mMP6RHKhgmoI8joYUWw4e0IFEK
         ujEg==
X-Gm-Message-State: AOJu0YxrMwJSGZcGYozvr0o7XD8pfis/Crsaq+vLinoL4Rdh1Pp9ipsp
	jEk3quKDlocBswb2OOY78K47x75E/wPMpo9DcJM=
X-Google-Smtp-Source: AGHT+IGEyl0Mtl9HJ4bO8JI/BbyhwfKXLqzO5WlKp4E/jZf2T6ZAlaDT1C0o4AtB08bJVkEURCgyjFQ8P1ruKciqDjc=
X-Received: by 2002:a2e:8883:0:b0:2cc:a532:a6e3 with SMTP id
 k3-20020a2e8883000000b002cca532a6e3mr2278203lji.15.1703801380097; Thu, 28 Dec
 2023 14:09:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 28 Dec 2023 16:09:28 -0600
Message-ID: <CAH2r5msxiNuCoXCvEF0X=7gdxD4-_X=E0b8mE_k7e=8HHz-VpQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
ceb6a6f023fd3e8b07761ed900352ef574010bcb:

  Linux 6.7-rc6 (2023-12-17 15:19:28 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.7rc7-smb3-srv-fix

for you to fetch changes up to d10c77873ba1e9e6b91905018e29e196fd5f863d:

  ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
(2023-12-27 22:55:36 -0600)

----------------------------------------------------------------
ksmbd server fix, also for stable
 - address possible slab out of bounds in parsing of open requests
----------------------------------------------------------------
Namjae Jeon (1):
      ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()

 fs/smb/server/smb2misc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)


-- 
Thanks,

Steve
