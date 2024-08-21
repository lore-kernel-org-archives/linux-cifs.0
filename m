Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE21B2ED8
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724263138; cv=none; b=gjDD4AV016bIMiTPQPCnIHiTzyAYIU3Y+BAvwLO0ZmCnngrNsg+CXzJl9/UbFcLkwzbi4HdT2iZeCMZcpty0N9AeEyLAd2fy+fHuB9jdLMHhI6QFFwryB8RNiy9hvU26ZcdDNxJBGOHsZeUgwR3naGKD03AYRzpe4xyxqEMmlfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724263138; c=relaxed/simple;
	bh=zLYVAI0AMx0lOZOwwY6rFfbdy1oZzo2dp9h2GncrmHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rdOb0VLSaKuGTxr43+OJT4UhXOUCvArWrzg7OEyW5lJrXA530ttu+LBcW1zCPFIS72DnzuojjbQMvrnMA1kfkbwE8efkO4zyIdaeybrBq/5mtuRtRFUhA0gSMxox8dqPs4E1F0n4Ga2Sm48l2C3HYjT2pOi9FuI2rfbiGnzI45A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AXLCcOfd; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AXLCcOfd"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53349ee42a9so1207190e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 10:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724263134; x=1724867934; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kEnl5JpwKoLp7CUhLYM7L9M6fvqY0FjR0W3FS/KZxcw=;
        b=AXLCcOfdLZPUogcBMDtGVcNQKVOb9QAMNtm6GMZtgoDBNRKRBvaowH4kvZyba6mh45
         vhEzZG7A9fPd/iDfNgUq7gSGesuF5FpNX8NmwDcdS9JgbtgynD+y/Un/qb9QRuYacJxP
         WqHC/MGOonl6MlJKftbpBtsjtjCrlYJKTskL7hmbB27Kdt3/4wByU7KEl6koW7GX++OA
         vqhmE2dhm4gRfpgD5d/nB6Gn/hipIVKLX7TNZqiUCTvuadSLme71Dsr9+ItLywprVUUa
         syv4A2RsSklarTgQ32S02YqI337XSleI0L31bpFss3zFOkc65RMaXxWIgn7bzL424W9s
         r8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724263134; x=1724867934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kEnl5JpwKoLp7CUhLYM7L9M6fvqY0FjR0W3FS/KZxcw=;
        b=Pp6zKfDGMKpdbjUv0xgTNyp6eJpQYV8CTASR77unmFg4Pzxt6b29/35Y28Vlkitu3/
         /lmUlUKZPc+VB7cIiboSuIyewJ3VfPE02o0LC4248Gotowdj+l7R7Qa6KrLwh4cSg5j4
         YU/x96/fLwOsjk/wbbTYHWQbcNv19jfl7O8B3Jf6GHmyyAcw64KWUSEufTAaXFoXNcOL
         n3mxyBCcPHX+j9SH23FRg96xsLnVjHLBV7+HEVO8gnuoW1UrOXsA4BLgHf/2jQaW8FPu
         6FvsB5otc3mo2s4vYx2UUQxf/B0jmBDWhKWWz+TC1vgHkG9L0GcEmnItM18xGU5cvO87
         /kQw==
X-Forwarded-Encrypted: i=1; AJvYcCUpOozy54WqY7Yae6b9gHL9CUGYL7qjIEuLVaFWPtoqMeegyPu551nuG4NNPDAJUHWIkCGqPyrd7Ckd@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2ACa8OjE4Ykmp/JaEMSjMXFTkmG10lt5snpMiBeOX4+vI7Uyo
	qw+BfElZ0SyLQE0NVTq2ygcGgd9JpYYIFSTmuNVnQk6upTLcve3p/EIWIkCzt0JRQL/oYs9G6Xs
	H8GZoL4K0UAVidWZvhxVN3CT+P0o=
X-Google-Smtp-Source: AGHT+IEkwMjDXCzSH1Q87waUhKLykt2GWifJoUPj5O7ARGzUiE1UCrG0L3arXHpAG0ekmILzUCONXZWKT0wwL0WZsis=
X-Received: by 2002:a05:6512:128b:b0:52c:deba:7e6e with SMTP id
 2adb3069b0e04-533485656ebmr1663383e87.29.1724263134254; Wed, 21 Aug 2024
 10:58:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
 <54a46d0e05c754fbc5643af2b576e876@manguebit.com> <CAMHwNVvAT-qeRvJ0jV2+5byHQnwzW9-YFj13ovXFC+M8hAfmyQ@mail.gmail.com>
 <CAACuyFU2va16OGn7_i-Ur-TEic7AW7pQj3c3xrPT1P2HJts9bg@mail.gmail.com> <CAACuyFWrejfaYiFU8REzj=uTFg88qi7guL1oQg3zqnDWY-vR_w@mail.gmail.com>
In-Reply-To: <CAACuyFWrejfaYiFU8REzj=uTFg88qi7guL1oQg3zqnDWY-vR_w@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 21 Aug 2024 12:58:43 -0500
Message-ID: <CAH2r5mv-V=H0QF205oZTc0Y3yfUchEyk4Y-QqFvVJgpJhxPWRw@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Anthony Nandaa <profnandaa@gmail.com>
Cc: Marc <1marc1@gmail.com>, Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

thx for testing this.  Have added your tested-by.  Let me know if any
followon patches or issues.

On Wed, Aug 21, 2024 at 12:43=E2=80=AFPM Anthony Nandaa <profnandaa@gmail.c=
om> wrote:
>
> I have now tested the patch.
>
> On Wed, 21 Aug 2024 at 18:55, Anthony Nandaa <profnandaa@gmail.com> wrote=
:
> >
> > I can help with this. Marc, if you can help me with the minimal repro s=
teps, is OneDrive needed?
> >
> >
> > On Wed, Aug 21, 2024, 15:15 Marc <1marc1@gmail.com> wrote:
> >>
> >> Happy to help and assist where I can, but I have no idea how I would
> >> try this updated code. I think it involves compiling a kernel and
> >> applying the patch to it. This is not something I have ever done or
> >> have an idea on how to go about it.
> >>
> >>
> >> Op wo 21 aug 2024 om 09:45 schreef Paulo Alcantara <pc@manguebit.com>:
> >> >
> >> > Marc <1marc1@gmail.com> writes:
> >> >
> >> > > This has been working great for many years. Yesterday, this stoppe=
d
> >> > > working. When I tried mounting the share, I would get the followin=
g
> >> > > error: "mount error(95): Operation not supported". In dmesg I see:
> >> > > "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" and
> >> > > "VFS: cifs_read_super: get root inode failed".
> >> >
> >> > Can you try the following changes?  Thanks.
> >> >
> I see that the patch is in
> for-next@80dd92d6ac7d1bc4b95d0a9f4d7730fe5ee42162, so I have just used
> that to build a new module.
>
> I created a share from one of the directories in my OneDrive:
>
>     sudo mount -t cifs //WIN-31GSG2M9E6N/Users/Usa/OneDrive/Shuttle
> /mnt/shuttle -o username=3D...,password=3D...
>
> Before the patch, the mounting was failing but after building with the
> patch, it mounted successfully.
>
> Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: parse_reparse_point:
> unhandled reparse tag: 0x9000601a
> Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: cifs_read_super: get
> root inode failed <~~~~ FAIL
> ...
> Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: Attempting to mount
> //WIN-31GSG2M9E6N/Users/Administrator/OneDrive/Shuttle
> ...
> Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: VFS:
> \\WIN-31GSG2M9E6N\Users unhandled reparse tag: 0x9000601a
> ^^^ SUCCESS.
>
> >> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> >> > index 689d8a506d45..48c27581ec51 100644
> >> > --- a/fs/smb/client/reparse.c
> >> > +++ b/fs/smb/client/reparse.c
> >> > @@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_data_buff=
er *buf,
> >> >                         u32 plen, struct cifs_sb_info *cifs_sb,
> >> >                         bool unicode, struct cifs_open_info_data *da=
ta)
> >> >  {
> >> > +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> >> > +
> >> >         data->reparse.buf =3D buf;
> >> >
> >> >         /* See MS-FSCC 2.1.2 */
> >> > @@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_data_bu=
ffer *buf,
> >> >         case IO_REPARSE_TAG_LX_FIFO:
> >> >         case IO_REPARSE_TAG_LX_CHR:
> >> >         case IO_REPARSE_TAG_LX_BLK:
> >> > -               return 0;
> >> > +               break;
> >> >         default:
> >> > -               cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%08x\n",
> >> > -                        __func__, le32_to_cpu(buf->ReparseTag));
> >> > -               return -EOPNOTSUPP;
> >> > +               cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x=
%08x\n",
> >> > +                             le32_to_cpu(buf->ReparseTag));
> >> > +               break;
> >> >         }
> >> > +       return 0;
> >> >  }
> >> >
> >> >  int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
> >>
>
>
> --
> ___
> Nandaa Anthony
>


--=20
Thanks,

Steve
