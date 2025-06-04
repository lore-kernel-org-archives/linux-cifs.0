Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A2472601
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 03:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008383; cv=none; b=OJXq/vQkwpJmjzTRkDUxbBW+KwccPrpRqc5wkiJxtyb+9bn7wfdxu1Rk3d272Ra+Kgp9YpPSRn7W1mBZT0raABL7Bbke5V4IUPWATJq2Yxy+2wV9H/uF0jr/0Rd8khJ16FOpFOPCUiSEjhc2SLKdJepkEoaRIPTKim/3mdf6QXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008383; c=relaxed/simple;
	bh=ocnFmj4ccnuhFB/PWBQ+grzXWgtZHlaUM9QXn5evFZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=COtS73sjubJyRPWDMbMRBVuZmCQTjvqBj0KTSWmMkOZZBh8hj0Suep0KhvuL1dQOjr1XLzu7j1VXwJX3UMknLAtuSgfBaEsxH2h9KZiVNjxvKT3ODdqI4j22qscXiNYZ01zmj9NImEcKSSnJmbWWhCKhsperDp9sH8dmEPwzzJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HquEa+eg; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HquEa+eg"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-606b6dbe316so2047721a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Jun 2025 20:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749008380; x=1749613180; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxHhSWI3V11JsYfcFd2h7co8CQI0ir49Vl80qQmLFGU=;
        b=HquEa+eg+wPN0i2llhTJAJEnpvAynRc+gWIcXK6SWqFM576oF++vBp0gnDbEbnAlnv
         s6B4RVpwS+Vyp6AOVEM2S5RpKnE1dQyfQYBDK8uj1BVQVrTpqBdJ31xLrDtJ4rRiqaMn
         pzaeXYriNlHTpX3WjvhIwKwgsgwv1aa1AcnNnw/6BL9nCm73Tg3DzQV8SXLDsdUU2/6S
         PDmf2psFznWv9YwoQGISGcRoo2NSaDqsVMKVyMF6qLD/JHCYTRAmzsmXd9Hcs9dM65X8
         FTIUysq86vOnzcv2vVKQgff/n1LYJJGSzywrqs6a+TZbNzsyUWF2cYUaVlZulFF2ghbd
         7djA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749008380; x=1749613180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rxHhSWI3V11JsYfcFd2h7co8CQI0ir49Vl80qQmLFGU=;
        b=ieu919UtFfULrCNtZ+x3AL8o0mOrSSTuMPDpgS5GzhBzH6JS2ZheIVT0/HzQiaZ2Sr
         YEopcFI12lLCodnYkVixbkNk3JpWoZ09cdNeuw4BOa4MyhAdz0H+x/5Aal7RLOyrdDt7
         Ip4zqpzl1UWC8+aeBSBqNjcmK33+REPMMrv2r1/yRKLLuc76/u53QgiQn5sv3thlng5J
         PeopRzm56S3WEkKFlFkwEqi9WbjwQD4kInvdK5PsBmzK0jLDUEVq0STP8JOPdSER1FHQ
         VjGhYM+qTzYmZ7N/LI1ORhlZho2uQkD2pA1kztmM8cWfKooy3crOn8jOFkYD2GRU9Ez6
         gNdQ==
X-Gm-Message-State: AOJu0Yygt6BNk76bnBqL7fybAXCgnby/miMVacJ5b9MCf4Qol7dMKcpV
	tSrQ+J1/sGNcDtsN77bXAzjhpJUjZwwY4zaIR7d50teLz7+OAoqL3vfwCSsvAInCbZsMFOjbXK5
	L0pGMCHZvCMJi4hEVJlYojd3vZvu5EaE=
X-Gm-Gg: ASbGncuGuLy/6tBxMtQVvOv4zsHYpKab/L+QMwjHEvg2/ibrqBmAUimSb7D1Lz9ba/6
	yHGf6mXsrgJwTuF7sUWUH/h38wXahd9TFNc7hly3icFi0XvSTKz3wuxyAiFJuBSAzvUnYqjacgC
	2tjEItiEOdAf455uYro5R3ufPZBvCcSJD2BtcbJEp2Wmf6Nez5wAPHcZX1NviWysk=
X-Google-Smtp-Source: AGHT+IES1AwBCkGmI/Ar/vAzRUb3nToOuOv7Dr8EEFcBafNGiiIEbmYQJBxINr3Ann5qzGlnMRtJsKE/MBdkSw+Wfm8=
X-Received: by 2002:a17:907:60ca:b0:ad8:89c7:2735 with SMTP id
 a640c23a62f3a-addf8fe2d0bmr96157966b.58.1749008379653; Tue, 03 Jun 2025
 20:39:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603042958.9862-1-meetakshisetiyaoss@gmail.com> <CAKYAXd8LSN6ux1C_kzEaBgN-zA9jF05_BU0gGLQjv=yUBGdGiA@mail.gmail.com>
In-Reply-To: <CAKYAXd8LSN6ux1C_kzEaBgN-zA9jF05_BU0gGLQjv=yUBGdGiA@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Wed, 4 Jun 2025 09:09:27 +0530
X-Gm-Features: AX0GCFssN8CXLZ-wSWO51g6NyngI65SY5o4Duev_b7Uc_l9h1Ao5Ozve2Neig4E
Message-ID: <CAFTVevUpjG0uQXs4Stj2OggqfGoc8X_6iLgzaVf2V6oTa8eqTA@mail.gmail.com>
Subject: Re: [PATCH] cifs: add documentation for smbdirect setup
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, nspmangalore@gmail.com, 
	bharathsm.hsk@gmail.com, pc@manguebit.com, lsahlber@redhat.com, 
	tom@talpey.com, sfrench@samba.org, metze@samba.org, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Namjae,

Thanks for the review. Sending an updated patch.

On Tue, Jun 3, 2025 at 12:05=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Tue, Jun 3, 2025 at 1:30=E2=80=AFPM <meetakshisetiyaoss@gmail.com> wro=
te:
> >
> > From: Meetakshi Setiya <msetiya@microsoft.com>
> >
> > Document steps to use SMB over RDMA using the linux SMB client and
> > KSMBD server
> >
> > Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> > ---
> >  Documentation/filesystems/smb/smbdirect.rst | 91 +++++++++++++++++++++
> >  1 file changed, 91 insertions(+)
> >  create mode 100644 Documentation/filesystems/smb/smbdirect.rst
> >
> > diff --git a/Documentation/filesystems/smb/smbdirect.rst b/Documentatio=
n/filesystems/smb/smbdirect.rst
> > new file mode 100644
> > index 000000000000..98dec004a058
> > --- /dev/null
> > +++ b/Documentation/filesystems/smb/smbdirect.rst
> > @@ -0,0 +1,91 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > +SMB Direct - SMB3 over RDMA
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > +
> > +This document describes how to set up the Linux SMB client and server =
to
> > +use RDMA.
> > +
> > +Overview
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +The Linux SMB kernel client supports SMB Direct, which is a transport
> > +scheme for SMB3 that uses RDMA (Remote Direct Memory Access) to provid=
e
> > +high throughput and low latencies by bypassing the traditional TCP/IP
> > +stack.
> > +SMB Direct on the Linux SMB client can be tested against KSMBD - a
> > +kernel-space SMB server.
> > +
> > +Installation
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +- Install an RDMA device. As long as the RDMA device driver is support=
ed
> > +  by the kernel, it should work. This includes both software emulators=
 (soft
> > +  RoCE, soft iWARP) and hardware devices (InfiniBand, RoCE, iWARP).
> > +
> > +- Install a kernel with SMB Direct support. The first kernel release t=
o
> > +  support SMB Direct on both the client and server side is 5.15. There=
fore,
> > +  a distribution compatible with kernel 5.15 or later is required.
> > +
> > +- Install cifs-utils, which provides the `mount.cifs` command to mount=
 SMB
> > +  shares.
> > +
> > +- Configure the RDMA stack
> > +
> > +  Make sure that your kernel configuration has RDMA support enabled. U=
nder
> > +  Device Drivers -> Infiniband support, update the kernel configuratio=
n to
> > +  enable Infiniband support.
> Hi Meetakshi,
>
> Looks good:)
> > +
> > +  Enable the appropriate IB HCA support or iWARP adapter support,
> > +  depending on your setup.
> You can refer to nfs rdma setup wiki for soft iWARP.
>
> https://wiki.linux-nfs.org/wiki/index.php/NFS_over_soft_iWARP_setup
> > +
> > +  If you are using InfiniBand, enable IP-over-InfiniBand support.
> > +
> > +- Enable SMB Direct support for both the server and the client in the
> > +  kernel configuration.
> > +
> > +    Server Setup
> > +
> > +    .. code-block:: text
> > +
> > +        Network File Systems  --->
> > +            <M> SMB3 server support
> > +                [*] Support for SMB Direct protocol
> > +
> > +    Client Setup
> > +
> > +    .. code-block:: text
> > +
> > +        Network File Systems  --->
> > +            <M> SMB3 and CIFS support (advanced network filesystem)
> > +                [*] SMB Direct support
> > +
> > +- Build and install the kernel. SMB Direct support will be enabled in =
the
> > +  cifs.ko and ksmbd.ko modules.
> > +
> > +Setup and Usage
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +- Set up and start a KSMBD server as described in the `KSMBD documenta=
tion
> > +  <https://www.kernel.org/doc/Documentation/filesystems/smb/ksmbd.rst>=
`_.
> We need to add "server multi channel support =3D yes" parameter to ksmbd.=
conf.
> Could you please mention this?
>
> Thanks!
> > +
> > +- On the client, mount the share with `rdma` mount option to use SMB D=
irect
> > +  (specify a SMB version 3.0 or higher using `vers`).
> > +
> > +  For example:
> > +
> > +    .. code-block:: bash
> > +
> > +        mount -t cifs //server/share /mnt/point -o vers=3D3.1.1,rdma
> > +
> > +- To verify that the mount is using SMB Direct, you can check dmesg fo=
r the
> > +  following log line after mounting:
> > +
> > +    .. code-block:: text
> > +
> > +        CIFS: VFS: RDMA transport established
> > +
> > +  Or, verify `rdma` mount option for the share in `/proc/mounts`:
> > +
> > +    .. code-block:: bash
> > +
> > +        cat /proc/mounts | grep cifs
> > --
> > 2.46.0.46.g406f326d27
> >
