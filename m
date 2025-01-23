Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618FD1D5CD4;
	Thu, 23 Jan 2025 06:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737615212; cv=none; b=DNGRgjXGAEzbclXrnd0J2iodS/HpnGKpUpkvM9p9lBuOT69pjIFgJAhZp1U9ab+lUphCtRO4PkXQd14rn1zFcFcb5ajPxZ4iutUbvAsYTUuTbPJs72Bs+iOvhUPiy5e6gSbriYdhDfuROhqqjkbAhi3+NGi9zULPdYyxc2l9sHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737615212; c=relaxed/simple;
	bh=iBgkSky6fnbO1cLUZmadGZMAMVeosWRZe+rHHOBMW2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/f5VoY+QcOGuzW5N2nO4xr79dUtHlOvYiqCIt4VJlN/tFyjcia/buczCzkOG6OC3sdwFMoV5FVaVW7K9pKvzKraFL9gs8Vr8dPsi8/WJRssTRfLub8oqTNSsACjwiDBo28i8PMdZT6nWnxHgjg2QxBjauw4Jq4CeRUHa7tuBxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VghAnNyr; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VghAnNyr"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54298ec925bso691284e87.3;
        Wed, 22 Jan 2025 22:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737615208; x=1738220008; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wnPSsUQ0qfEEwNc+lgHzstM/XyUR94iwMM2Qt9glQkQ=;
        b=VghAnNyrYxo012hnauL8CcyQH7DndCJIfiTgXP+5LCOqyKzuibrqVIAPOkJNPWFh8b
         5c/DrkRwCPTuoY0uWxi3rvQN55G2ZQ2AX3w+RoVZVyIInM13phrXErXBpNGEJAoeZH6W
         oAOT50QT6NmgUt4L6d3ajEWa7FQKBcKc9j8VceucsQtn6LE8ZcGWu5RmSAwR+HZeU6P3
         Fqtvg2FMx9/SUr5XyIfQuSfASX13dwokBi5BJz7CV6RNz+m/s7B60bDs5wLbz1hAkoCI
         sB0/rGsbSzNt+n54XfTT+WysTc9+hDLF9fNnaqJSo7MeuJXyjXDu9C9rA/Jw3W/gVygM
         51IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737615208; x=1738220008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wnPSsUQ0qfEEwNc+lgHzstM/XyUR94iwMM2Qt9glQkQ=;
        b=coUOLLDgLF1qDQXnzopOJ/O9KeFLSNCQ1hN9cB8z1397pnx1jYoCR2B6astHXhKGhi
         raSOhGGBtRbqnioZJTAkxKhtJixEehxS6FzwYp0hHAssAwcWR1967LUf7VOEQjzH5l+3
         8DvWpKVy50+EKozjy6fA7yozpPcZCzkEnVKkFagKXkYYkBQlDQQn053EzbLGulm/5giG
         1oXMLpci3DSSnj3ldP6UCwZ7rY6Xo4tsBWSTLJha6SubTW0hd5hAnkubPPSkNmZ1MJyb
         PZLsg3J4fIR3oMLuHDNxAAzBe/opQK0a6A+Vzu9k+jL9yTyi48j5ga7ca7m6nmiL2GX/
         5BZw==
X-Forwarded-Encrypted: i=1; AJvYcCWkAygvlSHjbKKUg9IcTdlu4TbYUO2X4LCgLLeqtY9xUKT9ZRZtOhIDsG4DLVVEsF/lo6gIJCDCD0jbZ8k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye/L012lZe9Usz5UqWFXBdYGGONSlRTXSWhcdPiuiDI52dJpmt
	bWZ7GYoBOLYJ08GAzLawvYoldbcRxyp/JOEv8x9DYqW0YWPhUMoJhuvxIch8AqCNBY++6iCqJtR
	MMUyXCNI95NTAZmgrnH4tBdyUyG4=
X-Gm-Gg: ASbGncvn1RUIwiWU8X+MJ8pjySj/k+FVuYkBiOOc1fOqsM66VcVPf2ueIlyyeuKhnD5
	FPdZr+JXFOsiR/wAlyvd/g4Ibc4VmQNSiNNZBl7u3C0IjGu0jz8+maphclJC6yw==
X-Google-Smtp-Source: AGHT+IF8F07w0S0sNsKmMQTjAGqMV/xLgynuZ15VSkL7CPlZiC5SxcV4sPjb04nOxtNKsI/+PwthkxBiomhSagY93N0=
X-Received: by 2002:ac2:4acb:0:b0:540:1a0c:9ba6 with SMTP id
 2adb3069b0e04-5439c282d2bmr7418190e87.34.1737615208148; Wed, 22 Jan 2025
 22:53:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPhCUnV5ocw5HfW+jNRaRPgntoM4uXeHNcC03XL00wLZjSm1Vw@mail.gmail.com>
In-Reply-To: <CAPhCUnV5ocw5HfW+jNRaRPgntoM4uXeHNcC03XL00wLZjSm1Vw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Jan 2025 00:53:15 -0600
X-Gm-Features: AWEUYZlkHdaogeFWJ5rINa9Cu5aEXC5ApYuu6eDIXGV-Oh5qK9nKcO8dQpdqLcg
Message-ID: <CAH2r5mvnJ6SLtHM_PWOQZ9dTsDd1BaQbOK2UBi9-AxRzt4sJpg@mail.gmail.com>
Subject: Re: Bug in getting file attributes with SMB3.1.1 and posix
To: Oleh Nykyforchyn <oleh.nyk@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Very good catch - sorry for the delay.   I can now reproduce the
problem.  Looking into it now.  Thanks for pointing this out

On Wed, Jan 1, 2025 at 11:05=E2=80=AFAM Oleh Nykyforchyn <oleh.nyk@gmail.co=
m> wrote:
>
> Hello,
>
> I encountered a funny bug when a share is mounted with vers=3D3.1.1, posi=
x,... If a file size has bits 0x410 =3D ATTR_DIRECTORY | ATTR_REPARSE =3D 1=
040 set, then the file is regarded as a directory and its open fails. A sim=
plest test example is any file 1040 bytes long.
>
> The cause of this bug is that Attributes field in smb2_file_all_info stru=
ct occupies the same place that EndOfFile field in smb311_posix_qinfo, and =
sometimes the latter struct is incorrectly processed as if it was the first=
 one. I attach an example patch that solves the problem for me, obviously n=
ot ready for submission, but just to show which places in the code are subj=
ect to problems. The patch is against linux-6.12.6 kernel, but, AFAICS, not=
hing has changed since then in relevant places. If I have guessed more or l=
ess correctly what the intended functionality is, please feel free to use m=
y patch as a basis for corrections.
>
> Best regards
>
> Olen Nykyforchyn



--=20
Thanks,

Steve
