Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A254D22423A
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 00:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785198952; cv=pass; b=AyADaBiH1XxYF8KHyvW/LlbPy5UalR/Jp0wjVbqRnEsHtE7D1ZpsqBkCnc0Ori05nm4Pt4K9cOhEbt5t/Xgr+nvB182YrmTHAR4pa5vKPkeLUUQAZTuLqQp9e4BwAvaQtHvPbWH8lZAazrEC3Ksc1D604mErksFtKVYxA34FC6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785198952; c=relaxed/simple;
	bh=zUJuophaqxjUH3qjmwMk+elm2KfCFvUbVWjhOJUs7mA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xq9xi+0vmgMUlzYN/LWeWTcjsUzJv6poJSFadSCCBIi8AY+9d92xugBZJfzulWDKuZxj61SpCSu0l0E2MJREJ15JhZ+6jrrMesCX+jbHlzlbLhfsQzTywvt1/TJ62N0zQw+uhk4ye9lvpfIfX5yrzvuqsbYfOI9WuL5OmxA+jxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kLca0Nqc; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kLca0Nqc"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8ff20870ac7so27381976d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 17:35:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785198949; cv=none;
        d=google.com; s=arc-20260327;
        b=abQKvXdFSjBGXBZvLGDSeY+Its/YQIajf1B/eDsm3FJInjspcj8nfcdQH1UkokW1rg
         lFoEeFL8dlnHuVgn8yb3hsA8f7NOM+JmmsHK4E0NNBs2//ooL52pIm3wuO93aDPIN+29
         WDCx+HVt5j7eK/8Gx6ZRRwZxwDinqA4yxIBFtQKaRzzRmCS5ogcvHlk2mUcdSGoWEF4h
         6CtoWq5sUY44z021LMYo3cwd6Eix3bHhKJg1HpXZqtMlAHhRMUpPbGycY5tPJdfj+8Wg
         q0qwmwMujxe8Lw1B+ybQTXHAj2F2+xCKzXUrDhO9wIzMhP3LE95OOniWONRlF4btLd2j
         ebdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qyYm8NBWE700lkT15FYT55AaF8aOFQvJDrc4XGPLKp4=;
        fh=pEg8WyODZIw7mNXfnvwUlV4pAu53dCpuZqY6WpN7v9c=;
        b=PwstuOqjMExrSZsI590rIs1yyseE3w/rT/jicRTfvFcSEzBUY1zHnVEMG+EoW02piV
         GaMWusnpikpXEa1TsjWuv7xQu7vRVDQ9NpByL087rGFs6UZbiaCduUUv+5lRevqx0dDQ
         WKPsm+m8kdn1oHU6zDJPGKFAx4yJsWM9+cOZTCYqCAOyln3OBkZDcLvM/z5uiKvMOvRX
         lL/wHhZxTXv9BhmZdETx0IIilOh44gSRuOtPJWZQstJiNYI0C+p/0oB1PQ7hOrzWU858
         vxIiJW9XvZTqGVWVKwufOzOd88cKfb05ugyrMSm2YboMGB9+/WZDzCehUTq4na5Zk1c2
         hnnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785198949; x=1785803749; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qyYm8NBWE700lkT15FYT55AaF8aOFQvJDrc4XGPLKp4=;
        b=kLca0NqcvlklcpyAge5tIwasy2f3mQmCBM0lU2x9Rslhi9XsF4S7HRmZXcdzpyzX4S
         88VBBXTrRvde21ctD3sM2Q1ULr1Dtbx95p9Xf50hG+X3ylyuVHSL9z/EW41ddNkEcxUx
         tev5amMHJ7JWTHCoye/czr2Y3OpLdSSmpEy0l6i9waZ19FUbHi1QpYwLhnwcvg1LFjoI
         WFKUnT0nWx3BI3PuVOC1oA/SqeGUZSgFvyD+1bZiMsiDa0gU6BXBtJXwYoD+NwLq20A2
         FQCZjrI9SN8F8ulXnMQAGaG7ZRQ+Bf1nj63SPEEzJ0GBCYQHud3Amyw2vhEYsJRAgRa/
         i//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785198949; x=1785803749;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qyYm8NBWE700lkT15FYT55AaF8aOFQvJDrc4XGPLKp4=;
        b=U+ZiE3YRO6wZzRRaSyT5do8rUCzU8TkXD4UFcEWbCp/dnZJJeGZKr5z5BE8ZT+1hrf
         v6xOPFQVVRIxdVD1Yk1yFUMyQeYGQHHpj21J5g0q6o0Eq8DyoPNEZUQbGOPM/0FxdYec
         CWsykMF840mju/W3lDbWkxfixb5tXu5NlMJN/7l9s/BWKCh1+U7FyGwo5xYkBqJxNbmK
         rrhkJ9LnhtCbx5s6p+FOlpYoP1MZaGQNbM0z8XLXRiA9GYP9Qo67JNnlQveknfj5Ki5I
         /eEiXrNEbOCD3X1nQj3Hv04vycACWNZFcuEAAtyTZUSe+lo8PlnNu1YedfTRq/3yAxn/
         95NA==
X-Forwarded-Encrypted: i=1; AHgh+RqwQORdehUCSJC+N+CF74VLq5l5Hp2FXC+pAkq/meYcPob+YWinaobclQYjv10IOg0z+0QMHLJYjqRD@vger.kernel.org
X-Gm-Message-State: AOJu0YyDwcHNZWC5rbsC65ah7Y+WIpI3CfTnYxfjawEgFSN7GS4W1WCd
	eZ1AdWD3Mf2jwOsXVmy5lo29EWgy6jnVh2PtCDnM/HhX/okH3JbI376evlwaK4heTtzs0x41nfF
	gDq3Svy0/mbVYKikar5UIXsKPsDoHSS8=
X-Gm-Gg: AR+sD12FtNpP7dCoVQfpIZTCql7cQiCJZLrEFXR6rBfAVDv/5yQ07d4GiEjc2/RvqhQ
	+LabkwCUqVZCbausXu6LcPj3oLXTE6kpP8ZMM1vJCm/HHjPKLOQfX4e2hSPPxeDK9bNO6Mo2EVE
	8ckmhJTr/KBe5tAbIsHLG/o5UYDY5G2qSy6gV1B7vok7/AF+YgYYK5gIjDk8SRmPIh4zCgg++To
	EQlHiEkl/yKIcvM7Ak/A8s7DcCR5lvsd+LT+ZS42iqn3nFyHoipRPlsvxDWE4YNLAuWwgYzdWaz
	umwOMr2lpEV2j+ccOSYRoTiEgTlQ8IPYzIe1LicgM75xKj0cpDm22m551vYPKY7Kzj+fm2AayRb
	NE+gdmq/AXMvY7WLH9DhpwwLkwLk5a3dEF+N6aEwEab//321daPMVMJQ=
X-Received: by 2002:a05:6214:1c85:b0:8eb:eb8f:a37b with SMTP id
 6a1803df08f44-90817088987mr2006346d6.24.1785198949463; Mon, 27 Jul 2026
 17:35:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784888897.git.tanze@kylinos.cn> <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn> <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
In-Reply-To: <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 27 Jul 2026 19:35:37 -0500
X-Gm-Features: AUfX_myWv9xPg2dV5EGBNEPM9_UXp7jqbUZcU8xx6kGgic4HIUB5MVRM3h7xbcU
Message-ID: <CAH2r5mu7Ra8vxkR4sNUy560FX5=R7pMzA-7k19p1j5bV28V-+w@mail.gmail.com>
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Ralph Boehme <slow@samba.org>
Cc: tanze <tanze@kylinos.cn>, Steve French <sfrench@samba.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>, Jeremy Allison <jra@samba.org>, 
	tom@talpey.com, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	Stefan Metzmacher <metze@samba.org>, "vl@samba.org" <vl@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

What other protocol improvements should go into the new version of the prot=
ocol?

On Sat, Jul 25, 2026 at 3:24=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote=
:
>
> Hi Ze,
>
> On 7/25/26 8:56 AM, tanze wrote:
> > For a handle opened with an SMB3 POSIX create context, the mapping in
> > this series is:
> >
> >      Client-visible xattr        Protocol EA name        Server xattr
> > -----------------------------------------------------------------------
> >      user.foo                    foo                     user.foo
> >      security.capability         security.capability  security.capabili=
ty
> >      security.xfstests           security.xfstests  security.xfstests
> >      trusted.foo                 trusted.foo  trusted.foo
> thanks!
>
> I'm personally strongly leaning towards having a protocol design that
> carries the namespace for *all* namespaces including user. Special
> casing the user namespace just for the sake of avoiding a clean design
> with a protocol version bump should be avoided.
>
> As said before, I'm happy to help and work on the protocol spec and
> documentation side of things.
>
> I suggest we wait for more feedback on the design from others,
> particularly Volker, metze, Jeremy and Tom.
>
> Thanks!
> -slow



--=20
Thanks,

Steve
