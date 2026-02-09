Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CED258ED4
	for <linux-cifs@vger.kernel.org>; Mon,  9 Feb 2026 03:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770607587; cv=pass; b=aGsnbsSzvX+1dDyuT7VdUUt4Of0+dnpm6M9PaCrj4rJ1ShEZe2qRYIyOXlLrawGViz1FkaEMY4CO9CpRqPa9q5Q2b2LMf1ArZy51miJUrC8P8hEFWbS+DoLikC5/lBp5VqCIl/4sB+6p+Q0XZN+6XhoG+hfKa2p/XrSvi0dZHEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770607587; c=relaxed/simple;
	bh=cH8thlY8x5N+XtWIPtOgRwfEUG2YEJfyZvmzDl8qvQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=deaAIhcepGEFXSlBGXcwtklITofcivHSdWSg6lNbh5xl3nnHYd87s/TB+S3+tBJB0u7HQXPju7Jmi+/WRtkJnF9VmNKBCns1Dd22a2+gaQ1yZBnwm6PU+jM1wtWnoaCONbg9Imx3UIRSkFDiFVAj+UnnafoSYizzGCpIvx2KQo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mjFDOh7A; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mjFDOh7A"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-896ff127650so8714066d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 08 Feb 2026 19:26:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770607586; cv=none;
        d=google.com; s=arc-20240605;
        b=C8mVwFSav3zOKzp7lgl1K+q3OUVIoUzVnRfjXfmI0ZuLvnuj7mJa1N/RIbUBe2ZH/X
         MJbOkTGJNz5oCvi7chj31bKgPMNKkr3++C7L+jEaBCBna5BRO2meXUteLK8twffx0EyD
         rdVkbzRk7io2KKd2VJrOeNyEgN06FMWbvX3JK2S2uBsAtD0l2Y9SjmTgG5TYrZ+vhKZZ
         ksK51fcLZp675YcdfxpjUDVyGWEUxDGum7dvUtcMUNJBYyoP2JTU1UT0WylGxM0Fz2qr
         0aipQxMg3loX3gp2OJ6Ia0yrgatB7d47m8OGXA2VrcSC0JWKnLKxajuzG1B589grsplX
         hAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BVOGAEoRh8URqwq/lTuJfeFTDGD1m59Hd43YdVMFCz4=;
        fh=SX+rpnh0N+16T25E6nRF4BAvRCLnuEzjWPXH3d31UTI=;
        b=NXlnwJR/KbfL66bmU5zaOdm96OP/AlN9yx3leQWYZ+eixh2VYAmj/Qlid6shB+M3Gs
         ieJJJPAUqk0z2RlqdBwFVKzVMRKuESSqZwGyd1tTwrdFOKnYGmvU9/crOYNG9TgcGCKH
         Hpux9kqdNAZrRUoDMXXi3neeYFl8rX5LAnvnVOlepeKU9ZTjhrTmlAXlOfgOodtlPSi5
         kI6jrwZYej0FwUjW0eViMwCzfli1PS1thzg3Vc4GSrvEBqgWmIjvi0x71u+/e55X9BBe
         0Ihwi06zWRit8bY8PNTygtCqqcFkca9NljtzjM8QsLiXYiwrrJSEKSRafytyXR1HmGJj
         thOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770607586; x=1771212386; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVOGAEoRh8URqwq/lTuJfeFTDGD1m59Hd43YdVMFCz4=;
        b=mjFDOh7AiEv9yz2Gn6q1CCPzclv/9vyeTsqU5OGQHT+ilcjms3EWQyIkwHggsru2OJ
         ncPwlmz+JoF+XHvAX7tcylnVx2HLZwZfVfb1/sB+X5EH9774jIwdZ0afAGD8Xtok+ymV
         +anWTS2tlfpo8uoeSlWMRo5tJykZSPDNXKT4aYKrrY3XEuPJiA39UWYlihZZO8sCBGw+
         J/TWItAU+fjy7/BiQolOhXkMtBhGzwtztCAMVc5HitnO8m4eLJLpdJqZZErk2iEUTQds
         hKoCq9H4365vHF/UbWGBSeYU981szIML25KIMdNOoSfmrz131lhpCT8xyjvrjaEMEAhQ
         p7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770607586; x=1771212386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BVOGAEoRh8URqwq/lTuJfeFTDGD1m59Hd43YdVMFCz4=;
        b=Jez1favXZUzNsSBduVI+y8cebDANhLgvI3rmi+yljQpM+IAmCrJa5v6XBO2sE1gi7h
         iE0tT9XKmFyzAOa8vVAaeMF3S0ebqWeX9VwPbYkzwdmWCAW2y8IosLuBPgMZ4nrYNhxU
         wotKykqhEZ2AbI8JLpM+jakIdmpUN43DFW7R+xSPD/oYG6x+/DyI0GUIGt25YKsg9BBs
         FRd/0Ly1CLy/Skkn6i/yD4+b36JkIf0Tn+ptQkyyus7rPOEr5uMS5GoFFSd9uuNz5hSV
         Fo3dsKCPX4EgLJd7dGqMIJb8/IOui5WSPzVjM331pu8IR0EKdl6P+Gn6wNb6joGLlDvN
         hmlg==
X-Forwarded-Encrypted: i=1; AJvYcCU6dF0idRA9BYpFzO2f2QkLP+yvUPicS6eS3lBSqKgGt7GFuo13CIVW4vEPU9UkhmWP2bD8wMG125Na@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3SvtCXxq38RELsFVf0qeEXV6OiHmUdmlgixds2wvXbWkmLZKL
	LuUaAvlTgGd6I1x+cRR0ZqqtQUM/YJ9EkCk+VWXEmL9yMcvLwrHtqlArfhZ6oCYecZuTPX2Idpi
	FMjVFxsYpqi/twKv3xLEtVyjXFqz7QBg=
X-Gm-Gg: AZuq6aKhXnAq0JGOM6zq4+R8trIC9bZhCZraOmoKNaBDXyncAW1lAWqvydV6oIr+Qqd
	0AtYh0UbheWqcCNheM0Ftjfpb7Dl8r+pswhMB6LPnxLO2n72W5ofe1l8/5YZddqaG7qrBcgZXxf
	kETdnHsiBl/5oPUQZPU0swBpHW9cXgG9scyKJ50nQEH+N3b2dhjk2KkJVlvgbEE2tZw4H79SKTt
	WAjkVAX+Dx/iVGhaBLzdCeGaS3xynggVVedxJYFDxQwrKEUHDPQim2/NerKZrth2VD18EE34Fvw
	+HLxfSku2SwwcBQG6YDzdWdNatVlvRIHszp0MOIwL4bMMivEM21gjK706Lc7xhgNhB+PSCA6fF2
	NubObHrKJDuGcFoBUFT4m3q2i07+Tf51CqSwJPwKOIEy3B5CBLSI=
X-Received: by 2002:a0c:eac2:0:b0:895:46a4:c88a with SMTP id
 6a1803df08f44-89546a4cab3mr88198986d6.39.1770607585968; Sun, 08 Feb 2026
 19:26:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e2726e90-3645-44ef-9af8-2d390c4d5bc6@samba.org>
 <20260203152012.914137-1-metze@samba.org> <68046261-f2d9-49a2-92ea-9c7abb97cd5e@samba.org>
 <46c9afa7-7834-4ac4-8509-b7087f358c96@samba.org> <2901815.1770327095@warthog.procyon.org.uk>
 <11ef6c9e-01f3-4c09-b16d-5e652624c257@samba.org> <CAH2r5mv6xVwX0Ar4ObzQ+2zcou2-KhYcWhjT_aGfeZnOD8FLCg@mail.gmail.com>
 <72494b19-1ca7-41f6-a80a-26a819ebb89d@samba.org>
In-Reply-To: <72494b19-1ca7-41f6-a80a-26a819ebb89d@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 8 Feb 2026 21:26:14 -0600
X-Gm-Features: AZwV_Qi7gXaSUL8wM1BEljZaHkR189Gpo_DwZAoixX6ywBieRbuJlslEI6Afqp4
Message-ID: <CAH2r5muv6uQYtgmQgLm3kEPL0VArn7EELgJ_wyQSxh-_gCuNTQ@mail.gmail.com>
Subject: Re: [PATCH] smb: common: add header guards to fs/smb/common/smb2status.h
To: Stefan Metzmacher <metze@samba.org>
Cc: David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 8, 2026 at 2:39=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Am 07.02.26 um 04:41 schrieb Steve French:
> > updated the patch with your suggestion in cifs-2.6.git for-next (see
> > attached).  Let me know if any objections or if you spot any problems.
> >
> >
> > On Fri, Feb 6, 2026 at 3:42=E2=80=AFAM Stefan Metzmacher <metze@samba.o=
rg> wrote:
> >>
> >> Am 05.02.26 um 22:31 schrieb David Howells:
> >>> Stefan Metzmacher <metze@samba.org> wrote:
> >>>
> >>>> diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
> >>>> index 802dec276e15..3abd357d6df6 100644
> >>>> --- a/fs/smb/client/Makefile
> >>>> +++ b/fs/smb/client/Makefile
> >>>> @@ -47,7 +47,7 @@ cifs-$(CONFIG_CIFS_COMPRESSION) +=3D compress.o co=
mpress/lz77.o
> >>>>    #
> >>>>    # Build the SMB2 error mapping table from smb2status.h
> >>>>    #
> >>>> -$(obj)/smb2_mapping_table.c: $(srctree)/fs/smb/common/smb2status.h =
\
> >>>> +$(obj)/smb2_mapping_table.c: $(src)/../common/smb2status.h \
> >>>>                               $(src)/gen_smb2_mapping
> >>>>           $(call cmd,gen_smb2_mapping)
> >>>
> >>> That looks reasonable.  Do you have a patch for it, if so, you can ad=
d:
> >>>
> >>>        Reviewed-by: David Howells <dhowells@redhat.com>
> >>
> >> I'd propose that Steve just squashes this into your commit
> >> cifs: Autogenerate SMB2 error mapping table
>
> The attached patch has this
>
> +$(obj)/smb2_mapping_table.c: $(src)/fs/smb/common/smb2status.h \
> +                           $(src)/gen_smb2_mapping
> +       $(call cmd,gen_smb2_mapping)
>
> Which is even worse, it has to be
>
> $(src)/../common/smb2status.h
>
> metze

thx - I fixed up the patch and updated cifs-2.6.git for-next

--=20
Thanks,

Steve
