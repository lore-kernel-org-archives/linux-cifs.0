Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C062812FB1F
	for <linux-cifs@vger.kernel.org>; Thu,  1 Feb 2024 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706810521; cv=none; b=Pzt+oVjtL6RA3m/KgxtEqRv0kd5CcBXxzVtxiPBDyjLa/CpODuCcIFetoSmrKQtd6QYFneDSvSTbdR0fJ8EqHn+v8URl9c5FBxY2KNmug90b9jZVGhe3thhE+ZeXIXgROH48ghxAQiqIx4RHrdcNVo/wd4cGzTIIDk4ZNRRgocg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706810521; c=relaxed/simple;
	bh=TrEuetKSQJ5r5qtP6MiuYxSo6cTt/zNrMR9D9fW4kG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pIfspzNLeqVXDnu+j+W4NBfV0v/vNqf9deLbaioBTJoxgEyp4bDONtampmGEVd1sxbxwgeVxwREZQYIjlAkCgL5y1ytsx52HEkURc0nV7I3aYwwFR4yCATBtNV/+5bGBcvLzZmrpitJzt3LLwDvmwmH9RP2YQDGVrmKv2WoPW0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lPZyHWv8; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lPZyHWv8"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5100cb238bcso2364368e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 01 Feb 2024 10:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706810517; x=1707415317; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XO6MI34sx7y7sKtG0/owVEIu61lP2sL9c6sYjJfuMnM=;
        b=lPZyHWv8gKSpwk4I3FQrMo6wIEmzT85qDRpPQOtksdJ76XIiaE9/pPxwlmwM0kkLDr
         mIFtobg3MHDbh9d1xeStC8XA03Xhsf/Q/gfdmq8zuGjKrG+9vzHFEOrK0gJKowKtSEko
         njVdgcLcK6VuxmtCXDCT7MBrdYu+E/GJbvgip/DpkZnGeiq7VEPQqWk1AYQ2z0naJmv3
         nGgtYQQ+E3RIIYN8JksVDyNMiHIGF9Qu434x9C+SLTZPFYUEGZp6uyUgz1R1pM8pVYa0
         xV4QGl8Je+J1ktxZ9Ab5WMosBUT47gl+DpHiblV/0F8aKS5LyDNWcwS8SswSMUkh91Yr
         HW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706810517; x=1707415317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XO6MI34sx7y7sKtG0/owVEIu61lP2sL9c6sYjJfuMnM=;
        b=ppTGstne1Kzf+1l85Dsy8fpdm1JFxyqdSN73uqlGQ9KfHDERwCyZ8CTBLoyPzjngew
         yulLNg+i4VtC/NjnWDc5M5hTpFFpQfkUJqxWnGPGuFX0RALOGHlbcx+d5PM2tErg444d
         L0tBn6NwbHsLrDnPu8J44jgmcEvPH2V/ZhUkQOpwI0hFAAZb0xc+HKkdJodHfora0Xjm
         UxEe3O8/1gjFrMqxNzTYYhAtrZUfjbEeAMf96CFTZ1yis0JNWvVHW7Y8Hf4ty2j+qyMI
         VL5j3vFI3YhdXsGPVElmS5nIO5tv3Mhoag8nCUqJUFPs8rB47rMq1WciWIvJjcwuHTDr
         CskQ==
X-Gm-Message-State: AOJu0Yy5U27QUaSzWpvid3vsNAgOeVNjJCIHd/KZw20gUY+ECGrqiRyI
	Spgq08QqIpWi6JVJVHTbgEkGc7vxlgWHhKjjIUyM4Il17ZKGeciZtvj3fOK7HC2cTM3ZE1ggmHt
	pE/cUfGded2hCLtd/MT6cuQqxL1RdJn9F
X-Google-Smtp-Source: AGHT+IHuqoNPXgvjEts1kVWihMQu4JBgCDfOEuP3f3vDrRUiz+eDTghA25P/bF2vzA9TqscdoYX0lhuA7pck61vIO68=
X-Received: by 2002:ac2:4579:0:b0:511:33d4:c99b with SMTP id
 k25-20020ac24579000000b0051133d4c99bmr127913lfm.43.1706810517341; Thu, 01 Feb
 2024 10:01:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2c310e00-84ac-49d7-88f4-e742d9170088@lrose.de>
In-Reply-To: <2c310e00-84ac-49d7-88f4-e742d9170088@lrose.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 1 Feb 2024 12:01:45 -0600
Message-ID: <CAH2r5muS+w+pv-32pYhui7yyvitdmCgbkfZdmbTyo3ffOHKpqA@mail.gmail.com>
Subject: Re: State of unix extensions and symlink support
To: LuKaRo <lists@lrose.de>
Cc: samba-technical@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

To clarify, are you asking about symlinks that appear as symlinks both
to the client and the server?

There are many cases where emulated symlinks (that appear as symlinks
to the client, but expose no security risk on the server as they are
emulated) - "mfysmlinks" (also what the Mac client uses) are preferred
to enable.   The Linux client has this mount option so that symlinks
can be emulated without requiring the server to support reparse points
(see Paulo's recent patches for example) which are common for Windows
for symlinks or without requiring the SMB3.1.1 Unix Extensions.

On Thu, Feb 1, 2024 at 10:17=E2=80=AFAM LuKaRo via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Hi everyone,
>
> is it possible to create symbolic links using the Linux cifs client
> within a Samba share on a Linux server? Or is that entirely not possible
> at the moment? I have read that smb3 unix extensions are part of Samba
> 4.18, but only when compiling in developer mode?
>
> Thanks for anyone who can shed some light in this regard,
>
> Lukaro
>
>


--=20
Thanks,

Steve
