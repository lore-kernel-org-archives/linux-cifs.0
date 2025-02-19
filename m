Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C241119A;
	Wed, 19 Feb 2025 11:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739963945; cv=none; b=X4+r6J8WHfDP2mnO5NCAdYC9i3ZsDMu1Ce8bY+uhuODvmIlb0AgNHTwBVeY/WBTNlpHmQu9UB/hzW5FA4SxxMfYgTJvXtDF6mVCACwzBy9TXFSaaCb+n7AYGaLiMVNYIDtW7g0YyKi+NrQYq0sIWj0gyyxGwxKJBi8cD7VV6mZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739963945; c=relaxed/simple;
	bh=mMdbW38/XOc7ricVDrBfRFQJ1TTdT42TWabOMpLqddw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=rYvfULzr2OccdYGFxnDqEpZR/BKmf97Gi4t8Ao8+dcAG0EOPDrtn4sKKAj2jy3qvEjXjb1mYHOdeyuQkCIr7t82TJs0sCwl9mxU6oNN7/SgLamgPylPz+B/T1xSycJpwSlV9CL5PUPH3ljPgn3i100GupB1z62HKJ7wzVDsGYnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1YKKohr; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1YKKohr"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5439a6179a7so856652e87.1;
        Wed, 19 Feb 2025 03:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739963942; x=1740568742; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cd2NCkNZDZjp37qilTmvHMGFP/p5O96SvJn6CIg/Cec=;
        b=L1YKKohrMRrWY3Dl8sci6tuoEEFiN488ymCSkBu0qT/mVBNrFFZMFnPnIGtibd5909
         sGmluLA1hNzP6I+7RzDoCIFYD8qOdj3bpx3cXV2UjushQC88BYA+cNjUll4xhyW7syOT
         P+qT83nuKcwun1WX2rmeQpGkEpBslSWmwwsMcR/dZO+LDXNP394/DTJmwtojADvdE0zo
         DputEcHv0Z8SnCT3rKHcdjZHbSJbMt3//1+nSYUAJtzyQv/fX5AFRyqvfxyepFGEmnAa
         fuFMf/vC2LKsA4ZXiJNGSVF4fnRZll8DW/tbx59OWUJlIsDth4rx4TBrPZQbWfsK74ik
         R/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739963942; x=1740568742;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cd2NCkNZDZjp37qilTmvHMGFP/p5O96SvJn6CIg/Cec=;
        b=f7YZICuToUZkJTdX8LFGjEFgxU0l6i3PfZ8qBW2RbzPjn5ACBixlfWLe01Gu7tLmEz
         adGdMVxrvmBCjf2waD8JRDmm3BuzVmHKHMQRN7+HSk62Yr1IQV+f8p+MxUrImUdQgsOm
         /ebe4vxb53HG2/4P1DXpmJIo9XS71jtrVYRe4sYlexQ1URLY+Yky2NsP+Jy2+51ZQA6z
         e1bKvLU/0AfFrN4kemMYg8XVIu+vMYHcUudMrmH99n+8E/b7vEKBVm3UT9wWnMFp5DkA
         7vTR3AF774f6SXL+mnEx4CYNtnSWg1dymVUjo6CKMz+GmsGox/DnnPCON3Cc//YS30Yw
         tfJg==
X-Forwarded-Encrypted: i=1; AJvYcCVnOUmiy3CQrdTr+f40BV/iwVsgW2CQmBoh4cF+nWjL2ayjzc7DlgGya1RaegZltAr6qNfbzrba0LxEuIGg@vger.kernel.org, AJvYcCVusBzcBptA9mMbgWTvgRQ+Z9hP77+txDp1RVGdgIYD+Cto+oQzcmIrCgQvRCnvVlSaRiBeznRsaxGL@vger.kernel.org
X-Gm-Message-State: AOJu0YzALNswME8lXq11qiq5qSTCaqOHW3aoglFCcORCz1j++YColzXu
	gDW8FUz/et6UQXElf5p4LK/3zRvWiM2SiBKOHJcx7hNm1EWyfuakqvkFNwVSvXEPN4VMbkZDpmy
	Va5wnVBdd0gW7qe1olwe9wp05Pjbs1Z5u
X-Gm-Gg: ASbGnctP/JYs0Lr3wwo+vaRYB8Ex789sa5qtza7DrQJ05i4Ry/2w8oO0ZnzFZ6QQYT9
	ABGkECvI5KeiHe1gxNREWBRfG9Jx0eVg4OM/FLxY3/GwCCMptrF23hl4Sh6OAJisWZw3CVT6uqA
	==
X-Google-Smtp-Source: AGHT+IE9pC7u6KFftCvbxSDZkvobXZDix534fzLwzUy6vJpZs0x418N/e34LzILF8rTI8dPZQjIQmrmXrkHKIA7NRi0=
X-Received: by 2002:a05:6512:2252:b0:545:ec1:9fd3 with SMTP id
 2adb3069b0e04-5462eaa6becmr1281833e87.9.1739963941605; Wed, 19 Feb 2025
 03:19:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPhCUnV5ocw5HfW+jNRaRPgntoM4uXeHNcC03XL00wLZjSm1Vw@mail.gmail.com>
 <CAH2r5muHVDfWM6vmRx85S2zfgh6v7mjc-ekOpkqJaLFvV9x1mA@mail.gmail.com>
In-Reply-To: <CAH2r5muHVDfWM6vmRx85S2zfgh6v7mjc-ekOpkqJaLFvV9x1mA@mail.gmail.com>
From: Oleh Nykyforchyn <oleh.nyk@gmail.com>
Date: Wed, 19 Feb 2025 13:22:23 +0200
X-Gm-Features: AWEUYZm_fU5RELTePp3rvmtSAETkzfjkTbqdRsDTdB55mmsqH4wmIDdPn_La3Aw
Message-ID: <CAPhCUnU67i9caSS5E3vimEEaAVwyd5eSn7uZfL059aReTR98=g@mail.gmail.com>
Subject: Re: Bug in getting file attributes with SMB3.1.1 and posix
To: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I confirm that the patch works flawlessly with samba-4.19.5 AND
4.22.0rc2 (the latest) but NOT with samba-4.21.2 (mounting shares with
ver=3D3.1.1, posix fails with rc=3D-32). I was to upgrade samba on all my
computers.
As for me, the issue is resolved.

Best regards

Oleh


=D0=BF=D0=BD, 17 =D0=BB=D1=8E=D1=82. 2025=E2=80=AF=D1=80. =D0=BE 06:26 Stev=
e French <smfrench@gmail.com> =D0=BF=D0=B8=D1=88=D0=B5:
>
> Oleh,
> Good catch, and sorry about the delay (email had gotten missed).
>
> Here is a fix (see attached) for the problem you reported.  Let me
> know if it also works for you or if you see any problems with it.
>
> This is important fix for SMB3.1.1 POSIX Extensions client implementation=
.
>
>
> On Wed, Jan 1, 2025 at 11:05=E2=80=AFAM Oleh Nykyforchyn <oleh.nyk@gmail.=
com> wrote:
> >
> > Hello,
> >
> > I encountered a funny bug when a share is mounted with vers=3D3.1.1, po=
six,... If a file size has bits 0x410 =3D ATTR_DIRECTORY | ATTR_REPARSE =3D=
 1040 set, then the file is regarded as a directory and its open fails. A s=
implest test example is any file 1040 bytes long.
> >
> > The cause of this bug is that Attributes field in smb2_file_all_info st=
ruct occupies the same place that EndOfFile field in smb311_posix_qinfo, an=
d sometimes the latter struct is incorrectly processed as if it was the fir=
st one. I attach an example patch that solves the problem for me, obviously=
 not ready for submission, but just to show which places in the code are su=
bject to problems. The patch is against linux-6.12.6 kernel, but, AFAICS, n=
othing has changed since then in relevant places. If I have guessed more or=
 less correctly what the intended functionality is, please feel free to use=
 my patch as a basis for corrections.
> >
> > Best regards
> >
> > Olen Nykyforchyn
>
>
>
> --
> Thanks,
>
> Steve
