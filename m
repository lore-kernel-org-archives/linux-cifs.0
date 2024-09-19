Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02474182AE
	for <linux-cifs@vger.kernel.org>; Thu, 19 Sep 2024 01:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726711070; cv=none; b=CmNYxehcfc+yD7T76m++LK00Suo2GSQruPc4aj02YcocB4NwiIIvzgeHqzfmaZhgzeiAm05k8P1pVzyHEtnApHleFfqa6ez6JZ3yfBTE2sDEXQxAOAg1UCbO1kvpmRWktbtk7vQ8eCLpoS9SsgeuSpoke5z6gfBafrcff6RUBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726711070; c=relaxed/simple;
	bh=dj/L1jWj84IbUD6vQzHxRBVS0Jwpf9RhHK3kBHIWB74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uamorYaTROmc9+Y/PihWR0CYsDxc53wT6RTKLbLF2ZuaiIRdy4sb64mco7/n82N/gJlm1L+PfOcwQFxsGFR7dIm57KZxHwRbTmmGezglTrC8OjKJY/myBASD0B0O6lcqArKIupn8gIJBaGIvpdD6S0glEH/RgqVdZ42vNRoT404=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E1taeD5d; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E1taeD5d"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5369f1c7cb8so370298e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 18:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726711067; x=1727315867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dj/L1jWj84IbUD6vQzHxRBVS0Jwpf9RhHK3kBHIWB74=;
        b=E1taeD5dIuGDeBoVsHBDfw80KbCOfrEmyun1VdX9uEHcfbB6XMobjg5p5djH032sts
         blyeNN1oQHzrm6fg9ZEB+Cg5svCDYpuGNYzf6wyIhQZye34qfu9OeCDiu+HkGOVInUm4
         WD9LpM9B6+r/2nsfoX06Csj4knVv63oDRznF4unK9Jsx7yQiT786QBA2EQC0f+fH4S8/
         RUH0QHyaG1D/uFNHU8pOOXeQLx4KBQVKN7EMrHSRYsesLFoLCvRf8f64NADVhyHFvQBH
         iYH0s1Eq5kSUtK/jg9dzvkbMlXvA03/rG8kIGIPitQjGNtlEeiw0eMbWkEUyN7xnFjQV
         9m1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726711067; x=1727315867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dj/L1jWj84IbUD6vQzHxRBVS0Jwpf9RhHK3kBHIWB74=;
        b=dMKvQ8VnoaQn6g0sn1OXDJo6L7eqVDVvWEylToXm/Wl8ZxUqzpdv6JPXQyphoMXi8w
         0qhCfBDm5odsNP10E++d/DnkM4kdg1TDgEOkXvcJH4N4jU/6f633jSgLorhbJaWpMznO
         jbqaiQSPpVuiH8RCHe0BbLDjNPOXtlzUflsITe3A+N+eu1mxdg06U+SfLMtYAa/+PDoL
         KZvrJZ5IOXALB5F+vsthXHkQz+zNbnnyYk8XBcVSg5xnNSBtfisBsJPRCeMGcIpJbREv
         bLmceSFsVWcEHJFGfxouLNmVUQT8E1ULh+cppBdhCc76Z81RBykMvuzCsbwR5aqQsKkx
         /R5A==
X-Forwarded-Encrypted: i=1; AJvYcCVvnIzmpQK+0lMCSrzR9VK15vkvbb8IZJw/rnH5BS+C/zevqfXPHzq/59g0ruIFSuhZonbanhLum4GK@vger.kernel.org
X-Gm-Message-State: AOJu0YzID6Zb+zLvYHd1iyHnfitGBU4u7ngPSMF/m0bba6mGnMTJ4LNF
	NkQp42Nj5OXvURcDkaQuKoUl+AChm/swTAahK90R733rlDhYKd4tKIIBEDEnfP1WODNGA4FBs9e
	Hr8qw5HPdajIeJBYYT+zxI2Df9m0=
X-Google-Smtp-Source: AGHT+IGH9EqfPaaq75md4z9TAGBEdV3v14sBGY8p/6rkMzr4pmAd1oBJIr0/XLSUv0rVFxwa6WaT4gTab7zi3+kBUvk=
X-Received: by 2002:a05:6512:3d8a:b0:535:645b:fb33 with SMTP id
 2adb3069b0e04-5367feb9644mr11052257e87.2.1726711066858; Wed, 18 Sep 2024
 18:57:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKRryJZs-gXnWCYUXhbjV__OM7T85xpKp9nvPOprJzcOJGX9=A@mail.gmail.com>
 <nfqi2vtpgpvmmix4h2fesil2smneezbhciqhz5rj6dxilh5h3l@eoa6hlabnjml>
In-Reply-To: <nfqi2vtpgpvmmix4h2fesil2smneezbhciqhz5rj6dxilh5h3l@eoa6hlabnjml>
From: Steve French <smfrench@gmail.com>
Date: Wed, 18 Sep 2024 20:57:34 -0500
Message-ID: <CAH2r5msihUoK719REbt9Hnv_7b_=2TtMBBvm0paxMHEK4R-jCQ@mail.gmail.com>
Subject: Re: rmdir() fails for a dir w/o write perm
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Maxim Patlasov <mpatlaso@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes - looks like a client bug (fixable by removing the read only dos attrib=
ute)

On Wed, Sep 18, 2024 at 12:54=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Hi,
>
> On Mon, Sep 16, 2024 at 03:43:22PM GMT, Maxim Patlasov wrote:
> > Hi,
> >
> > Is this a bug or well-known issue?
>
> I think this is the expected behavior.
>
> When I try to reproduce this I get a STATUS_CANNOT_DELETE from the
> server.
>
> This is from a MS-SMB2 Normative Reference:
>
> If File.FileAttributes.FILE_ATTRIBUTE_READONLY is TRUE, the
> operation MUST be failed with STATUS_CANNOT_DELETE.
>
> ref.: https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fs=
a/386d9ec5-e0f6-4853-b175-c05be01419e0
>
> --
> Henrique
>


--=20
Thanks,

Steve
