Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D27223DC9
	for <linux-cifs@vger.kernel.org>; Sun,  8 Mar 2026 03:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772939422; cv=pass; b=kwhUeEqPSycGVCeuhw6MwFrbGa/g88OdDEkz2NYRFD/urbb15s79omqiyg9Z/tHiNbejoZrflPHwNfnTQeXRZtW2Zd8s22uEqkLVuVgMrq/CkZoV78g5LTnY2Ui3QjXqvl2mi/XS5Z346o+Ml8Jsz2jJUZM/lr6SHnIn4Ui8+v4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772939422; c=relaxed/simple;
	bh=FT554hZqAEX8a1kNiFaeC/MQYEtI4TCuMgiCj3Sg9JA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y7V0o3Da9cWropNfoALtdqW+VPv0oILJW35q1eU3XyVe4iKBnxYoGQNnUXxa4raaR78K4EuuW6qaY/uZPvDJSLo9Orbfa5+EQprUI8r0kggfZBC+53PZppp57WznINKR1QwVfH9KIKnM+0zptIoHhsRXqVv+92pz29pKl+XEQb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GKZhgPMb; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKZhgPMb"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-899fc9853b7so95593316d6.2
        for <linux-cifs@vger.kernel.org>; Sat, 07 Mar 2026 19:10:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772939420; cv=none;
        d=google.com; s=arc-20240605;
        b=AocCprJBZpFCyDrFzotwAxevkAqt2Eg7cskGaFW6jhhGbp/GofhEhK7wwpHUA2JOoT
         yyDJwSb7+ZOog4AQwhkH+ZTOQxaLi8cOL2Fg4UJCeX4LrauMJ7LbdT18Og+6lQtpi61M
         5V/2tnTwEd5HCtMNuf7Re53EFXLaxDrVWtE8lK+U/h1Agg3dMOQ6WRlGqNAYz+a5W3Uc
         YwHE+HVbiuEovx5A0UFM15iVhnM9aOJc4/YFKnkcNfGH1ooM6IjBozJB7zswkaxhSxBt
         5x7VjwbAOaOHL7aM5UbSvSOmKUBJ9lxZRTBSCI/NeWFW72em/Lq5TWi9jgqHIGEiRH0B
         +xsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OgjnyeIHMSpKxPO9WM9wRfsRfZIs2A0n5sMLnaHjVxc=;
        fh=zD4B4Pp6pMvoYa+KY7B7OBCQ3aY6+GjZ5ovJiSH2weQ=;
        b=L4fqegKxgjJFvtNgHae1VH8zLeVj+1om+H4DV5wpHO8p+Q1rObjAbPX/P8EiRzN+3Y
         VeMMGdXvZEGIbvafJcRCRN9ri8lGGN+8ZxgyoCwmp0Iwbe0TLVK8wHXSH3HMo10442+f
         HfqkBlcyKrc0wocjlPJvX9OCA+8HLORyA4Ln0qf1l9p/D4w4ZMYXaxOXfeB9O6cpNyGq
         SJ12ZD+KoN3NLhYhKbEoZ/oGPg0RWpHMQLUGWgQN6JDydjK/wc4dG/aAGReTV0BCFMn9
         G48RbWST5qtIfRgHgxigUMl5cwYdXRp2OJWeXJ+v+IxUJEjC8Vpq8HMjtSuPRXtJCtLI
         rLoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772939420; x=1773544220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OgjnyeIHMSpKxPO9WM9wRfsRfZIs2A0n5sMLnaHjVxc=;
        b=GKZhgPMbsgA1F7ktD7DQ8SdC2EWLeIsWEI2X8o5LU9pwRwkr3ESecj1mlPVZA23kVO
         CQBKYhVHSKuceCtPD615JTuqCExer9jvyZ6qu2PTrSwWAJ/ZwVwV1lIE4dMsil3SeQZf
         40SuGfr2d8OtYrF4bgepSS9WVmgxihoXUNZZluHWL8iqQY30jCRvYJ43M4s0R6urHSNh
         VhROTE11VvbjrI6jH+1E3T48dMtdBGP1IuLKTrSuNOFYICZFR6xF17YvD1qX7cmWigKK
         OogiAub2OB5jnT0KUJOnUoQSzGfmG8NuzlEhBQlbqMWW8fBvzs+VYs2isM9OpJni6Sdb
         x+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772939420; x=1773544220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OgjnyeIHMSpKxPO9WM9wRfsRfZIs2A0n5sMLnaHjVxc=;
        b=qQ/s2DAmI+OTmme/GQAKOBRLgvqswcQRmbjzVoQDljINotlL2fPLVB3wgqnBhRAuFE
         QJeon53i5C1w0rHssfnnrNGJdLZU5VOTYZiqyaq9d2WaPYSPADS71+SGHjkSOoO88cnB
         S5gPFdgyTx6GWGRc9ISTD6PW169FvVem1hEBo8axswRfX9qMx7DAOOgc9J5RtVy17g1s
         2zGaFczeFHMXdUxfyrvq44x4K4B/tEdB4Py+SsG09dF9QWBRAzxNNk9ImWZS6CXnAgMD
         wYd1+AyEH7Iy6LuGdp8uhm5flo8QSaM2n1I7SnGY9+h7NxGf9uPBfCAyEMICvs/FThfO
         6Twg==
X-Forwarded-Encrypted: i=1; AJvYcCXkP05ZMomivXdqawsHx1gYwYxSIrCQ+mtUgxIo0pO/xAvV6b1KUN4IEGNedP/tM4OY0u/7aDafxfDm@vger.kernel.org
X-Gm-Message-State: AOJu0YwaylzzwK/nfn1z4SUMznga3z0nSXK3yNXtWSz9sStda0B+Zzhk
	LAyuE9vmnVJwnfrzoVphjblaGjGn3UyqbL0GYR6L3Q0CXqqYo+SlrvRMGfWp2zYqBL9iBVur7eY
	6Qzn6DjP7hpQHnerv4ls+PT+l4PuzFBI=
X-Gm-Gg: ATEYQzzFSs9SgdrLoJnC7ECYDjRI8krFwjtLwrKxCKq1U9quUxfDbNMngNzW5wjkJDp
	c2p0iVqCWNir1Wh+qN+10rVG/gmubWId1qta6q2n4EvuLcM0xmhQLIBUPK2ZfcGQsYD1xiGOV8b
	cV6zFvqfdV/Jz86ilI0/eYC+mkAJDB5GA+3ks+Hhm0EFhle7FeGGRiEqgjP+wiKNrSg/k3E/ZdM
	w5xC7LHmAxdCvcwi8c3Bmjo1TjQziOCjSHuAquBssjfgVYUCRp86ERWCc6DCrDlxZLp/xOdXPpi
	Pn+vZ1ED552WwBlganjNPJj/m+QEM0ii24XI2pz+QolZNwXEtkhAyjV5ToDa1raMwe89Dpy+/is
	v/h33u1Cw7cuW8FJYEWKcd4yMZaLC4XuiKHAQGtz46U7/1Q1n90cL5r7jifqLGS/WkUKcLhFU1G
	Ym4ii9mFZVwONwn9GQQomn7wEARi7Yd+eW
X-Received: by 2002:a05:6214:242a:b0:899:e621:eac8 with SMTP id
 6a1803df08f44-89a30ad1c83mr102051066d6.39.1772939420246; Sat, 07 Mar 2026
 19:10:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306144415.3402532-1-arnd@kernel.org> <a3f513c1-a7ad-422b-8fd8-145b222f77e7@samba.org>
In-Reply-To: <a3f513c1-a7ad-422b-8fd8-145b222f77e7@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 7 Mar 2026 21:10:02 -0600
X-Gm-Features: AaiRm52jmPl2rVUqNIVvceJ7sK2VDP5cs_yQY_38-2rrCEVZNv15gs8OCp__Il8
Message-ID: <CAH2r5msdOcLdxPhihu5b3er4Dv=CxdOMHSCwsCrXzh2EHzsK6w@mail.gmail.com>
Subject: Re: [PATCH] smb: fix smbdirect link failure
To: Stefan Metzmacher <metze@samba.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Steve French <sfrench@samba.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, Arnd Bergmann <arnd@arndb.de>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bharath SM <bharathsm@microsoft.com>, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added the acked-by and merged into ksmbd-for-next

On Fri, Mar 6, 2026 at 9:30=E2=80=AFAM Stefan Metzmacher via samba-technica=
l
<samba-technical@lists.samba.org> wrote:
>
> Hi Arnd,
>
> > When CONFIG_INFINIBAND is set to =3Dm, it is not possible to have SMBDI=
RECT
> > built-in, and it turns into a loadable module, but this does not preven=
t
> > CIFS and SMB_SERVER from being built-in, which in turn causes this
> > link error:
> >
> > ld.lld-22: error: undefined symbol: smbdirect_socket_release
> >>>> referenced by smbdirect.c:212 (fs/smb/client/smbdirect.c:212)
> >>>>                fs/smb/client/smbdirect.o:(smbd_destroy) in archive v=
mlinux.a
> >>>> referenced by smbdirect.c:212 (fs/smb/client/smbdirect.c:212)
> >>>>                fs/smb/client/smbdirect.o:(smbd_reconnect) in archive=
 vmlinux.a
> >>>> referenced by smbdirect.c:338 (fs/smb/client/smbdirect.c:338)
> >>>>                fs/smb/client/smbdirect.o:(smbd_get_connection) in ar=
chive vmlinux.a
> >
> > Enforce the dependency at Kconfig level, so that the respective smpdire=
ct
> > options are only offered if it's possible to link against the common
> > module and infiniband.
> >
> > Fixes: 28504d6ee127 ("smb: client: make use of smbdirect.ko")
>
> Thanks for the fix!
>
> Steve can you put that an top of ksmbd-for-next for the moment.
> Then I'll squash the hunks in the correct patch and provide
> a new branch, as the 2nd would have:
>
> Fixes: 30807ad55601 ("smb: server: make use of smbdirect.ko")
>
> But both hashes are unlikely be the ones landing upstream,
> so as we do rebase anyway I'd squash them, but maybe
> I'll have time for the rebase after -rc4.
>
> So we should take it as is for now, but maybe without the
> Fixes tag, but acked by me.
>
> Thanks!
> metze
>


--=20
Thanks,

Steve
