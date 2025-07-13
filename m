Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F263211F
	for <linux-cifs@vger.kernel.org>; Sun, 13 Jul 2025 23:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752447941; cv=none; b=TJK0o4jgJGl8K0PFqlLfgtWad3VcFNOem4cly/wZAlwJjbf8wc81H18uYnVzOIKgJfKxm9kTQ1ash7NasoVqB1//aUxZV0WV5UlUz0WPuZPZ1MQG2aHvkyLGZC8Teo6yI8yPt/1ZCcb1ie+rUh3S5EmoSkWCGQoNr3ys7scVXFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752447941; c=relaxed/simple;
	bh=RL02RIaw1vwHuR37IZVbiH2ugiK5ntKyzP/y+MOZRF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VL5cz98aU1yF+l5j4Mw9hhw4CsfNag5/grPdMEyZgZRlIg5e3n7zvwxtMk11QtbKHHLuhr1WHuV3klPlT3jhfXesHJQuaIScs51keGGfuAVRJbAj0eqf8OBEvGmDuDFf+2UsAUW0nufzkeYYn5hSjhkLjs0OnKfVGIZ1E3XqKEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a/++2O02; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a/++2O02"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-700fee04941so37123986d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 13 Jul 2025 16:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752447938; x=1753052738; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pghOaMNTzGLDB+pGIqjlpDyoXu4PVYRYPaX2Vz5N3AQ=;
        b=a/++2O02plgLMYmWpkI96MHqP8OmNpk/kTkcLfNiKCv3Kx9JMdqgO9o/dEhpfLunHR
         6KiUrQJk5E3XqxzEjoXzU5vTIP+dRJ20ks2vqHuys4yaHC97MxlWFv/N7hpYCi+Jn2hx
         Lm+NWh6/f3ehe99Y7ZUSEpKe7bpXSa1HU/rpF6TU8fpyw9c9P3ngSsDxHCJK/m8nrkBt
         m/Fa3uH/bmMdvuO5KYUPL2qCZAbX/QbU80NGdJH0JxXa2e5TnMN3BpIHXl36W70Chyxa
         Esd3amq+n9Y6vcz0PcYZOHA/9wQyPDrvuSHDj5jvR69byBczYn+tZBB1g/x0lVuFVI0f
         /nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752447938; x=1753052738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pghOaMNTzGLDB+pGIqjlpDyoXu4PVYRYPaX2Vz5N3AQ=;
        b=FKrpuF7pxFMLNo3jyLCBDXATaMKcFkJkSNUYHTchROXL9f0YcVRbxyBDneSJ38Vj/K
         XRudPTBijYLwwn29dRGATEYmeFcm3YHavxgQ6eKds4F2bKDB9ynzlgdtn3qsrH1tJkeY
         K2eJLW4Ca5ViWh4izbFA9bzM46UVi74V9AhRxdht7sMFyxklEMp7Fx7+lStNussBGfd9
         Mis1fE+nCMAGfg24NtKmwucBCrMHh09BWQuFwfa2QIWFnc/5cHrThA5ZhXkoKoW94sRa
         gTfJlgXfaHj0+Ksqx9sAdR6mLKj3wE0H/ymEbOXzmu9hecFny+51HnDUbtr5qyoVmXnO
         gDKQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2ab85ErONxkaB4S+23XPLzIENWqSh72WammAfhuQCUXy2+AU90yWaHHBvjPoShB/MjaUAWWZ5vFDX@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0mcpRNDgWqOKUcBQ9fAbKjuaJlltkgDAXXrGNJnC/U7E3ZNJQ
	UbqF/SY02ks+bH6dCHvV+B2euBxkY0wEIU8UFQciKxbN3FsaNiVNd10oEPJM32+nXLMJ94/84/E
	tke7UgImtik3wjyh+ymgCUSVQ2Pxuoh0=
X-Gm-Gg: ASbGncvPRojUdjVmIMdQ5nf1Wj+V04DvDVatVFjjLKOLbbUeHTdOlrMVPZ3oj56QxrO
	bEiHZRWEuS8hn7qX+n4fLL3Sl2bVxTBi6evEIwO/Ec0gDQ47bqcVf8Y2J0GKfQmZSer4ShlZDMD
	D6fDGhdu7dLm6wpCfY1CO+GHjLSBx/hLdgjd77Rz5Y/8Gnu21TrAW2aDprRCaORQ29HFXzyouO0
	BDrjW6ZerlEqW4DTAVP3Jz6Oykqm8exesvYPMFOfd+Vw3tI5wTn
X-Google-Smtp-Source: AGHT+IHc12ZUW2LmyNcGWCXkLrnbQWQvX7+8kndPhxLQslSgebcnquGSpNeEz4tNWW1Pq9AwGR2I2QtbkHYReVlrYJ0=
X-Received: by 2002:a05:6214:2a47:b0:6f8:bfbf:5d47 with SMTP id
 6a1803df08f44-704a38beb6dmr170740766d6.24.1752447938437; Sun, 13 Jul 2025
 16:05:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
In-Reply-To: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 13 Jul 2025 18:05:27 -0500
X-Gm-Features: Ac12FXym8mydveM1sDm1q7OfQg4K3-IMntgjQQkH_AD3HiM7LnzgyhLN7UccTxw
Message-ID: <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
Subject: Re: Samba support for creating special files (via reparse points)
To: samba-technical <samba-technical@lists.samba.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It does look like a change in behavior on the client as well (the
client didn't used to enforce the server correctly setting this flag)
- see below, but it is tricky, because without the check on the client
for that capability flag a server could end up with unusable empty
file on the server if it actually didn't support reparse points.

What is strange is that when I comment out the checks for
FILE_SUPPORTS_REPARSE_POINTS on the client, Samba does seem to allow
creating special files via reparse points, it just doesn't properly
advertise that.

commit 6c06be908ca190e2d8feae1cf452d78598cd0b94
Author: Pali Roh=C3=A1r <pali@kernel.org>
Date:   Sat Oct 19 13:34:18 2024 +0200

    cifs: Check if server supports reparse points before using them

    Do not attempt to query or create reparse point when server fs does not
    support it. This will prevent creating unusable empty object on the ser=
ver.

    Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
    Signed-off-by: Steve French <stfrench@microsoft.com>

On Sun, Jul 13, 2025 at 5:58=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> I was trying to test out creating special files to Samba (with and
> without the SMB3.1.1 POSIX Extensions) and noticed that although Samba
> reports special files properly (as reparse points) it does not allow
> creating them (it does not set the filesystem capability
> FILE_SUPPORTS_REPARSE_POINTS except in a very narrow case for offline
> files, so clients won't attempt to send create requests for special
> files to Samba).
>
> Is this intentional that Samba server does not allow creating special
> files via reparse points?
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
