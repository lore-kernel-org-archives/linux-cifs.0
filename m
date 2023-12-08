Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lBtnJJvZ"
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BDE10C4
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 13:36:18 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-50bfe99b6edso3051958e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 08 Dec 2023 13:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702071376; x=1702676176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHJCl3nDFuly3GMX2Yt7GFyzHFugHTAbl1QraemB6HM=;
        b=lBtnJJvZjibKULia8JB7kvMUQkUfmD4Q7JE/R3oUnx0gl1Ss1PsvsbP2JQafGXGmBY
         lMCOUIL6tWP4xWZFppjtYs8JNNvYybCeE482C2cs5Q71mWuVtO0rn9OsK2vH9hkNHEUy
         NO9EKyNjElh819kV5ISovWstVZxenem7n+d2bdT0WNUv+CdsNpgKwjmT3SPm7OwhBtwq
         P+kg8vtjGIYL+XjH6Zv2zrVx5pHyfXCV4CFKlDN66W9imZBFa1FK/ePYAJy4g3bOb3SZ
         N20+VuzmZZmdGJis9j37vBfb3RPuXfT1WUwkHHxaaWISdKiNQEVIE1qg4ljcurKFVR/W
         FJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702071376; x=1702676176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHJCl3nDFuly3GMX2Yt7GFyzHFugHTAbl1QraemB6HM=;
        b=op8mzJ9E3rKa/V/IR4a7cB/5ezkEK/suT/CplEUZ4lQh18wMpxGu4Ywo02Fd6Cjey1
         YUr4QZQhwDsuxcQ2Kw8cnjas/AEeihztGsIGDFQKry2rKzfd9+3V3lcqrFD6EwZIQYjL
         ZkqQNfJ/yb07OfhAlTp169QgXvhjKi6foE+nYdBWqcYRvF7WIVQm+Hhn7/fZSb2EgR5k
         I+mYtrCeLThE93WB0F0TYrI27YQ0Duib+Y16E4GSvPltkeFunJNhKD5xz80A6/48aiGU
         Foj6dJHeVPPSiIt6/CBKfIb49BHH0mY4hmjynXACR2E1cmsbzOxqEes70KhPgXInAmh/
         jGxw==
X-Gm-Message-State: AOJu0YxrxXCJKHaYXdODaTrME4juCgEcZ1IdNnMGo8cUYvQiAc7IVC32
	XYKAsG2+V/GT5ayZsJ3ACpcSxFteX8EqxFdqVNhw1M8rXI8=
X-Google-Smtp-Source: AGHT+IE4MvXswdqa8bZcx8xbuZsrvK5mMn4Kpa6KWeIHVHRfspV8HFYRQzx83pxar9xpeqWvZPJaaZEQtKI+z7i3LHY=
X-Received: by 2002:ac2:5f91:0:b0:50b:c8a4:a96a with SMTP id
 r17-20020ac25f91000000b0050bc8a4a96amr270522lfe.39.1702071376076; Fri, 08 Dec
 2023 13:36:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtK-JQeH5gLoGjUS5sywfd-KTJhnF_Mf4c+KCoapMEPhQ@mail.gmail.com>
 <2f21c53c-c374-40d3-b9ff-f2af8ec219cb@talpey.com> <ba42bcc91981af579d70a239f18ad810@manguebit.com>
In-Reply-To: <ba42bcc91981af579d70a239f18ad810@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Dec 2023 15:36:03 -0600
Message-ID: <CAH2r5mvJw5PdPi3JByNO3fNKXa-8Z=KRDT2sNw_R62aDXr4HWQ@mail.gmail.com>
Subject: Re: Lease keys and hardlinked files
To: Paulo Alcantara <pc@manguebit.com>
Cc: Tom Talpey <tom@talpey.com>, samba-technical <samba-technical@lists.samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N <nspmangalore@gmail.com>, 
	meetakshisetiyaoss@gmail.com, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 1:07=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Tom Talpey <tom@talpey.com> writes:
>
> > On 12/8/2023 12:01 PM, Steve French wrote:
> >> Following up on a question about hardlinks and caching data remotely,
> >> I tried a simple experiment:
> >>
> >> 1) ln /mnt/hardlink1 /mnt/hardlink2
> >>     then
> >> 2) echo "some data" >> /mnt/hardlink1
> >>     then
> >> 3) echo "more stuff" >> /mnt/hardlink2
> >>
> >> I see the second open (ie the one to hardlink2) fail with
> >> STATUS_INVALID_PARAMETER, presumably due to the lease key being reused
> >> for the second open (for hardlink2) came from the first open (of
> >
> > Ok, so that is a client bug.
>
> I guess Steve forgot to mention that the above only happens with the
> patch applied.

This fails for me with mainline (I hadn't tried it with her patches), so ye=
s
this appears to be a different client bug

--=20
Thanks,

Steve
