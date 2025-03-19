Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FDA20AF6C;
	Wed, 19 Mar 2025 19:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742412627; cv=none; b=UfTOgSJ2eTF854xZzOqTwHd9hlZqzAPrred3/OgnsjUhIEKj8NNm5Z94cnNA4J0ka879zUyS2JlbAszEJnl634IbdyRrZi3qIDy34/KTWvJNp9YLEvsDIBIOmCZoI9b5o1AOVDDjew2ZlMr1B17aHhTpJLiYsKXLVdPOu4Rs7gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742412627; c=relaxed/simple;
	bh=yuVdpLtsC60x+P5yXiu7LI/XprDS4+SULd/2llLIKxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QwJ8xdhn+J7SBMTJgPptgKC83QumHRgITlnR78jQVwydfIBKvGIWVm3JM1saFxoBBX79I+kxh5dBfBChuyyRmkZE1erNkyCLaquNWZVR987/Gi3afo2vvTejUBSMIkj+ilUf6t0nfopm1yttYcDCbrnItXMyLLh22YY34vsmKRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HOQcU7I2; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HOQcU7I2"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5497590ffbbso62011e87.1;
        Wed, 19 Mar 2025 12:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742412623; x=1743017423; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CjPdZUk4Nt9PEx4A+1SO/010u3e1pVDr5a3dUVLO0X0=;
        b=HOQcU7I2Wd1nm0P/EntmCkdRM0W3WdYphMILkhReK3wg5gfioCIV8CM6paCTIaeXD0
         mwaupTmFon86a7CfkQV3ptxPJF1P4cJuu22Eq5wHn5GJlIEzp2V41lHlQzFC71Ye+wjM
         LJuX1y/7oIlvTZAzbeZzPRMt0AAnLzhWZ6WwpXn+1dAZQwP4jmI5u/1NREKuxSIDk9RT
         FiXMfz3p/kMWOOnhAnVN7S2GjOKmiw7u3hctWtbbV7juVwnng5Qk4w70vjDgfHPVX1NC
         LlLKtK44rej/ynjtxxco1Fk/WfiuEAGAVo1SHrcM0WIc+xbv0C3eGnr+8nDPUESPJflA
         gSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742412623; x=1743017423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CjPdZUk4Nt9PEx4A+1SO/010u3e1pVDr5a3dUVLO0X0=;
        b=GKu+wUjBUU73aLqhjIaIt26UANqRuly5lUjD4/qrPChGmibZms1UOY9uN3q3flsRad
         cC7iJAmiPz2cXgfckMe5zE91rH3JEWKDV05xU3AVnluOMwTcHSLLvA8vPBDaPAL+EtUg
         e/nRqu6w4XGH8joiN52SSbY/490rZUiqfs9vRNShfnzh0/iPEws8xc/zmNGLD16Jo+Jj
         uYMH4RYmwM3i2CelVYe9VcSLjgVARB7Xi6MKSwNUH89ep3qfY8tndoKvotxk5j5riXxi
         HJGGl7/ncy89NO2f81UZOWw2xO03YaM09zr9KssYTh/A8ng1Ehriu3kDx1aD4Tvl673z
         KE9g==
X-Forwarded-Encrypted: i=1; AJvYcCUpakTK45H2VDXJ96Pr6ENJua6Y7tFENhyfkykbU7Mv1+7eCPIZGSzllJuKyHIVTVN+t53BPNzzRl7iWrCa@vger.kernel.org, AJvYcCVYujSKVI39JdA+dBD0ZqyWjaCk0jzRvtyAP1kj524NwB/tAydm4+XQqN+BnOUvjOaTDA1vG9SavH53@vger.kernel.org
X-Gm-Message-State: AOJu0Yy69B1SBwkpiScL0hOJD2rPZNsf6+sRJFepJUgcp0b89Kp2qANa
	6qYqB8i2yb99iXwBndQB/k/xN3jN7ThpHJDOo1azMC5+W5bpLnkHO6WMavECFT0oS0+R3D667LY
	CYM85fOBIcKE3dxQ8ptYuuOJpYZ6Y8A==
X-Gm-Gg: ASbGncsdB7suxinbft0xacpDRrETOc53fd5Qa9T2zaK0tw8aLBGgNHPAYhiSHOHwVZ/
	r2gkj9+/bvWRPsJs152QNoAPZfl9pVwiBLy1hOL/AoCsXXmvZm1z5w4BHrE6NgdUImZZTKhJgf5
	+lMsBwic1FMWNvdEosLz0VSe7E8CWRHdwzt51nyxx7Z3wQU8861OkuEXphq+v92q49XAWGTH8=
X-Google-Smtp-Source: AGHT+IGNmednv6g3WBsP6ygVOMceOxWwcUpi3FGO7Rvzn3j0b+dP4eq642X+94uECeHnq1fFOmasbAUrs3O4JAvrnUo=
X-Received: by 2002:a05:6512:234c:b0:549:7145:5d25 with SMTP id
 2adb3069b0e04-54ad067861fmr84418e87.34.1742412622784; Wed, 19 Mar 2025
 12:30:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250319123110.21814-1-adiupina@astralinux.ru>
 <ci4fhara55ka4mh65zn7x5vp3zjcqcytghupjzz2izudvjjejn@6qggfqf2qsxc> <6249e342-f379-4257-8a19-52b888e02c09@astralinux.ru>
In-Reply-To: <6249e342-f379-4257-8a19-52b888e02c09@astralinux.ru>
From: Steve French <smfrench@gmail.com>
Date: Wed, 19 Mar 2025 14:30:10 -0500
X-Gm-Features: AQ5f1JoRrz5Nk1_H_FVmMQADeFbuF158bvWZ_f9-0tI7AoJZYN1WrJOk2nP-bvU
Message-ID: <CAH2r5muCakSQSh_Epm5eFDPnFu=_Ayc-wwd7a7t+FrKxziz5DA@mail.gmail.com>
Subject: Re: [lvc-project] [PATCH] cifs: avoid NULL pointer dereference in dbg call
To: Alexandra Diupina <adiupina@astralinux.ru>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, samba-technical@lists.samba.org, 
	Aurelien Aptel <aaptel@suse.com>, linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Pavel Shilovsky <pshilov@microsoft.com>, lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I don't mind if you also send patches as attachments (or with pointer
to git or github commit link), especially if your email is corrupting
whitespace

On Wed, Mar 19, 2025 at 9:33=E2=80=AFAM Alexandra Diupina
<adiupina@astralinux.ru> wrote:
>
>
>
>
> 19/03/25 16:20, Fedor Pchelkin =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Wed, 19. Mar 15:31, Alexandra Diupina wrote:
> >> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> >> index f3c4b70b77b9..c02aab58aade 100644
> >> --- a/fs/smb/client/smb2misc.c
> >> +++ b/fs/smb/client/smb2misc.c
> >> @@ -816,11 +816,12 @@ smb2_handle_cancelled_close(struct cifs_tcon *tc=
on, __u64 persistent_fid,
> >>              WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative"=
);
> >>              spin_unlock(&cifs_tcp_ses_lock);
> >>
> >> -            if (tcon->ses)
> >> +            if (tcon->ses) {
> >>                      server =3D tcon->ses->server;
> >> -
> >> -            cifs_server_dbg(FYI, "tid=3D0x%x: tcon is closing, skippi=
ng async close retry of fid %llu %llu\n",
> >> -                            tcon->tid, persistent_fid, volatile_fid);
> >> +                    cifs_server_dbg(FYI,
> >> +                                                    "tid=3D0x%x: tcon=
 is closing, skipping async close retry of fid %llu %llu\n",
> >> +                                                    tcon->tid, persis=
tent_fid, volatile_fid);
> >> +            }
> > Something is wrong with the indentation. Usually scripts/checkpatch.pl
> > can give some feedback on this, too.
> >
> > CHECK: Alignment should match open parenthesis
> > #32: FILE: fs/smb/client/smb2misc.c:822:
> > +                     cifs_server_dbg(FYI,
> > +                                                     "tid=3D0x%x: tcon=
 is closing, skipping async close retry of fid %llu %llu\n",
>
> In the *.patch file, everything was fine with indents,
> so the checkpatch.pl script completed without errors.
> But when sending, the indents got corrupted for some
> reason. I'll send the second version
> >
> >>
> >>              return 0;
> >>      }
> >> --
> >> 2.30.2
>
>


--=20
Thanks,

Steve
