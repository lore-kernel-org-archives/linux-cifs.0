Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628E718DB29
	for <linux-cifs@vger.kernel.org>; Thu,  3 Apr 2025 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743701571; cv=none; b=FWpc2CGC7dxz8d2hqGnxsxOEr0B/8ZjSPPZm2ZUZ5JBMFxqUD1DPTaN1rxzHYwdhlLWbeNbVqo8hAUGvbk++zAC2j0c5DAyNKDDBJViqxoZAU+APXgYExdeHnzHpEBvXFC9Vme7aZNzpuMX7YST0o9+NLIj/2nuB51Wnyg5Bp20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743701571; c=relaxed/simple;
	bh=MeWJ43p+8Y3FYwWXmIqS3khaPS5QAua2UXeLdhQVp/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ka1mMIBAl3+oMXpxbkHI1JA2O5wOKFqvV7CFqzR4BNy2Q68EIc5OjeFJjJ3BraqBuX+Vc6ZUbuRW1mz63LPfmULctaofpNGSLF2E01Nqa7JuT3Irng5UaJtCXO6SZHbi15J6wAR00f8UiqltxR7yBrOhr6Hoao4wA3us6N6jkzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=afXZpbvP; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="afXZpbvP"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54afb5fcebaso1310457e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 03 Apr 2025 10:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743701567; x=1744306367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcsoXF35i/+hSpm25m6CjBETnlGwcsMcAt4eR6+93r8=;
        b=afXZpbvPggC2kkkUH2x7z5eAV94wH7ZQ8USCEqGIKjGj8kY3rRO6lQOidGaFnUmPoj
         LbdVeiDMeld1CPjIOOwvVGD9As30C/ebtmKZMxBzR9zejnT87t+NwkTjP6M7NtfYVki0
         DVL3omcMznm6gFxqJ2h+qLSe86xERAkv88OPBv2RzJR+Rlb7I2y1RjzfPuPinYYxFH8O
         qWoHbkgMxu2ptop4vWXGj9UqHXourElmuvJSUzjt9DQ7UDp/rDDT1MaoRAcDiP0XTE/m
         wUj/9FgOcqKtMLCyScEeRxW47+xT0UJTsTQuqeZ+5Bh9KLOPRv3gHIpdk2J8vWvJc2hn
         wtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743701567; x=1744306367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GcsoXF35i/+hSpm25m6CjBETnlGwcsMcAt4eR6+93r8=;
        b=iN+H64OnNXTYp2jDQoydUwKx6PTX7TdRs7ixavSafOe6T9PoZpHXkdc62s0UXWLBP4
         QbfiGkz1Se9enOTuSqGWco5YO6WajzTW1YiER+D8q4O7AsYN7rjisK9yAK8Wy/96OIa/
         WKHJv+onVCbAJL0W5hxE2xMSVKZ6To4RThJwcKTlCtuXuNF90D99iTO0ilCCLmiKJ0En
         goDri82Sxw3c4HETs48cj80Y9RjAIg56VVCZ604eI2K/a4tA4DaQSK+W55l/NxjLci4P
         Eem6tQwJ1WtRwxO0nJ01e/ZXVbIDxLaAgpCkEBC8y1ZREX0qbVWylLK9vSIMcVnA0nDG
         IZQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfW+eTzpQktgItLY3SZKFvwHoPRPF+PbXSw5CgLg3j4BqNFaWGCp3OE3fPedVWeS0e7I6iLwFiyAgB@vger.kernel.org
X-Gm-Message-State: AOJu0YzsW80gHuNd2AbjWFvMBH3D/6T2GjZde0SWWnWMJpJ2PXxTL9ZB
	IvLp++P6a1bk99q/ff4KLBh0fuKM993q+jBVD232jhgfOy2FzUk4n2bh+6GAV1XNRu3ity3WXwX
	l70KNqTn6tTBbI/Whu778pb0xS4g=
X-Gm-Gg: ASbGncsd4mbrGgac/PZZwqb/O3I/RJ3MNFEun8knDDNGmbRCxp7oDTaSFHMd98frG2i
	Nik7M5Yvzyog6+lKr0+tUNWqikrgxkcNpaF9tBuarLe5SuRxGKIY9gK3iA2UlickohMuu7TSUdD
	yHJVTXkCtNfr8XfLKoTRKuGy+IxGWE5dOwxCLrPe9m/Vnw6NEZiNTfAjg3HbnP
X-Google-Smtp-Source: AGHT+IHEe+uYv1jyrX50uRJRoS27zS+oZLgCijcqp496hedWd3XtoUrXrhlietwX3sqHe/edm9HqLxcqsCYQE1SC6PE=
X-Received: by 2002:a05:6512:39c3:b0:549:4d7d:b61b with SMTP id
 2adb3069b0e04-54c227dc60emr17560e87.35.1743701567095; Thu, 03 Apr 2025
 10:32:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1e95b93f-7632-441a-a4ba-aecd7e640383@huawei.com> <20250403172709.92329-1-kuniyu@amazon.com>
In-Reply-To: <20250403172709.92329-1-kuniyu@amazon.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 3 Apr 2025 12:32:35 -0500
X-Gm-Features: ATxdqUEdkwlaOmIye7bwHb04zWJ1D1SxMn4NKhEDaZnPhFwGHdMaEUROeE9PlVA
Message-ID: <CAH2r5mtvkAAEur6_jPMtvpKa8q9fWufwV7VG+fXkATXs_jZv0w@mail.gmail.com>
Subject: Re: [PATCH 1/2] Revert "smb: client: Fix netns refcount imbalance
 causing leaks and use-after-free"
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: wangzhaolong1@huawei.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	kuni1840@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, samba-technical@lists.samba.org, sfrench@samba.org, 
	sprasad@microsoft.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> What branch should be used to send reverts for -rcX ?

cifs-2.6.git for-next

But probably won't be an issue in a few days (since mainline then will
likely include the conflicting patch - which fortunately is unrelated
to this discussion, just fixes an RFC1001 bug)

On Thu, Apr 3, 2025 at 12:27=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> From: Wang Zhaolong <wangzhaolong1@huawei.com>
> Date: Thu, 3 Apr 2025 17:59:20 +0800
> > Hi Kuniyuki,
> >
> > When testing this patch on the latest mainline, I found that the follow=
ing
> > snippet has a conflict:
>
> I guess it's because I used for-next branch of the cifs.git.
>
> Steve:
>
> What branch should be used to send reverts for -rcX ?
>
>
> >
> >
> > > @@ -3444,6 +3441,9 @@ generic_ip_connect(struct TCP_Server_Info *serv=
er)
> > >         (server->rfc1001_sessinit =3D=3D -1 && sport =3D=3D htons(RFC=
1001_PORT)))
> > >             rc =3D ip_rfc1001_connect(server);
> > >
> > > +   if (rc < 0)
> > > +           put_net(cifs_net_ns(server));
> > > +
> > >     return rc;
> > >   }
> > >
> >
> > Specifically, it is this line:
> >
> > >         (server->rfc1001_sessinit =3D=3D -1 && sport =3D=3D htons(RFC=
1001_PORT)))
> >
> > In my code, it corresponds to the following snippet:
> >
> > ```
> > @@ -3333,10 +3330,13 @@ generic_ip_connect(struct TCP_Server_Info *serv=
er)
> >       }
> >       trace_smb3_connect_done(server->hostname, server->conn_id, &serve=
r->dstaddr);
> >       if (sport =3D=3D htons(RFC1001_PORT))
> >               rc =3D ip_rfc1001_connect(server);
> >
> > +     if (rc < 0)
> > +             put_net(cifs_net_ns(server));
> > +
> >       return rc;
> >   }
> > ```
> >
> > Looks like V3 needs to be sent?
> >
> > Best regards,
> > Wang Zhaolong
>


--=20
Thanks,

Steve
