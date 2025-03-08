Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8568F66;
	Sat,  8 Mar 2025 00:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741394319; cv=none; b=iJSPdIUQJOHDf4bu7G7wXHuR1JsCmJb7uEU1OinF4njltoQVwZlmZJK95GUHNQJB7GrFTFjwOFvzrxEABlPPCg4+8oFKsz9hGCWIsu/VG8YcCsUTHaKr000+Y3ZWenSn/+DC6nnqjIpAl7Wmga0OMNpayYYMmrQNqOpV52PU0Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741394319; c=relaxed/simple;
	bh=rfOEvkpuqKHGflaRaPxkuW+mrOHN7jdwzCFozlhOXPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PHaLfiQ1oAk3t8d+FF8jT+lCA53UnwyW6SGGNN3tyjuaN8mgfU+flFdYq70TnSw50mvkyqhfuPh0pdVmiCK6GvcXzsBSZLFHT42vZVvyeCUE0o2f+xBYTsy+u/E7i9RoIAaOnukmaEyruGDnDY15i75oR9HE5CI2Fk4jEAVzfsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nsgZnJ4J; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nsgZnJ4J"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d43c972616so6907725ab.0;
        Fri, 07 Mar 2025 16:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741394317; x=1741999117; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1CzjouSYYDka7fRSAbop5+QmSJVI7Ib11oVwUZA5sKY=;
        b=nsgZnJ4JX55Ma0fzsw3CwMSZgYovHkPt52cmwOcF584inzHEXLL2ltf3gwdM7Czft7
         LN0xiA3k5Go6lcseec9SavgPnkfKr2Bw6NYjuYIzy3nVodpPHPoqMNNkP0mfehNOMLTu
         wa6nD72jtiuihibnSTEClrqGu3tKjK6NiT0LfqCtVgabCiQAbhlEmYuAX5FpgFFuracM
         P8gDIJm96Bpn3fyRWx+B0Yat9ybCnuoahHFDeBtVRShKnR3verhsTy4viQeUzifqY2DX
         5n5COMf0d4onvLuM0wdvSetemrDlsMkPicA4aLynYC7IHVAreUwEMmNmrkqTo7AyPl85
         Y64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741394317; x=1741999117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CzjouSYYDka7fRSAbop5+QmSJVI7Ib11oVwUZA5sKY=;
        b=jj3kpS7AuLGdk0cHPiLkOnQkgy+glxPs6nL/04syxnDPpj5HlUb2g4kwrdHCQuLdoS
         b8Ei3yFzsaWF6gZTzdf/qZjUIcM/YJ7kqP3PY47OShN5I73ni8/RJyyTwLzKYIdX0FLT
         jVYjEimf575GQfh+Iv0WWeBckOG9Jktx3Q1PopowWv8qWG5kT4HaDtabhZEts2GZuJsF
         YDhnP8in4mEw7rMUXrqWO2zj477gfU311aO5xrpr1LMFBpv6VBKdtoDqrUfjAt5U/JDJ
         GM3agBn4cfgBnWOUxPyg9jDK1KWVAA9yo4WAhivvIE8JbS0hshOiTQkBbbdmX78WGOl3
         doiw==
X-Forwarded-Encrypted: i=1; AJvYcCUx6B+jiYPa9tG2VHszyVb6oogsHyGKggHOdwbt8ho+71B0zj31ZDnNRXxaNgVSPvZDygDuP5z6@vger.kernel.org, AJvYcCWu3xlRE/O/MiMNKFsoj+6fBDXtGVF6EtiK2NeKpxdXuOBMEDsjNr8GhtatYQ5VzN2NTnp8pH4H+bRn@vger.kernel.org
X-Gm-Message-State: AOJu0YxiXzGo5oRhb1g18D/vgoK6KW2KMgXRW2mEM2g+z13yE1bx23fh
	CA9LNnxPuF2w9OldQ55lJetjVnCxWB+UZVGBxqsBCncIRNaHXUy/5Qs94mp7ubArAarBBwC0wNg
	6XE2OvYTEdNWI4UoC0gSUmTXXzjY=
X-Gm-Gg: ASbGnctxmo22JTIR6nRV/gRlesRuS/45NQ5T3iFUzcRNvrG/MzqE/FXuWCT2f5LgLRe
	LAPerV31iQR4SEYR2WJzhcD+ZA07Vo3PiJT02xjMHWYlCWgROfLkAvtXT66M7DoFxAdFrouN6gz
	0sAwzSK77UezG5RpVP+CqNGQMf/w==
X-Google-Smtp-Source: AGHT+IHYM/Qlg1nUKjuohwFX/f7a9KSc8NsEAec+iIBAQW4nFK5S/30ZBIn4+oslMC1HxbgTUT9icERNZ5V+SOHrvnQ=
X-Received: by 2002:a05:6e02:3907:b0:3d4:2acc:81fa with SMTP id
 e9e14a558f8ab-3d44ae8e21cmr16955875ab.2.1741394316774; Fri, 07 Mar 2025
 16:38:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725935420.git.lucien.xin@gmail.com> <887eb7c776b63c613c6ac270442031be95de62f8.1725935420.git.lucien.xin@gmail.com>
 <20240911170048.4f6d5bd9@kernel.org> <CADvbK_eOW2sFcedQMzqkQ7yhm--zasgVD-uNhtaWJJLS21s_aQ@mail.gmail.com>
 <53728c53-5c1a-4f5d-9862-8369e9b9d8d0@samba.org>
In-Reply-To: <53728c53-5c1a-4f5d-9862-8369e9b9d8d0@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 7 Mar 2025 19:38:25 -0500
X-Gm-Features: AQ5f1Jqv40IxKhhM_ElltElLnY1_jHNT71hYZr2m5ePLJkbNDUZ9Y0WluKCsZn0
Message-ID: <CADvbK_fk=ga-i22LtLZik81S64ur8+gfrjrxAD45W9bF2Aa4gQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: integrate QUIC build configuration into
 Kconfig and Makefile
To: Stefan Metzmacher <metze@samba.org>
Cc: Jakub Kicinski <kuba@kernel.org>, network dev <netdev@vger.kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Moritz Buhl <mbuhl@openbsd.org>, 
	Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 9:42=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Am 12.09.24 um 16:57 schrieb Xin Long:
> > On Wed, Sep 11, 2024 at 8:01=E2=80=AFPM Jakub Kicinski <kuba@kernel.org=
> wrote:
> >>
> >> On Mon,  9 Sep 2024 22:30:19 -0400 Xin Long wrote:
> >>> This commit introduces build configurations for QUIC within the netwo=
rking
> >>> subsystem. The Kconfig and Makefile files in the net directory are up=
dated
> >>> to include options and rules necessary for building QUIC protocol sup=
port.
> >>
> >> Don't split out trivial config changes like this, what's the point.
> >> It just make build testing harder.
> > I will move this to the Patch 3/5.
> >
> >>
> >> Speaking of which, it doesn't build on 32bit:
> >>
> >> ERROR: modpost: "__udivmoddi4" [net/quic/quic.ko] undefined!
> >> ERROR: modpost: "__umoddi3" [net/quic/quic.ko] undefined!
> >> ERROR: modpost: "__udivdi3" [net/quic/quic.ko] undefined!
> > The tests were done on x86_64, aarch64, s390x and ppc64le.
> > Sorry for missing 32bit machines.
> >
> >>
> >> If you repost before 6.12-rc1 please post as RFC, due to LPC / netconf
> >> we won't have enough time to review for 6.12 even if Linus cuts -rc8.
> > Copy that.
>
> I'm seeing some activity in https://github.com/lxin/quic/commits/main/
>
> What's the progress on upstreaming this?
>
> Any chance to get this into 6.15?
>
Hi, Stefan, thank you for reaching out.

If 6.14 is released by the end of March, net-next will be closed very soon.
I think it's very difficult to get it posted and reviewed on time.
I expected to post v3 some time in April.

Thanks.
