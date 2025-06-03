Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA0D267F77
	for <linux-cifs@vger.kernel.org>; Tue,  3 Jun 2025 06:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748932547; cv=none; b=QqGmYt8pOPrCwMlU7eeTy+sEIchhNMEdbrWUgo49X5k/aHoC5VeQyOSWXvWO4r3Oe0VbxE+fjniokDj/Mdqm5ejMxnFSpnLaat/6Zpp63yERHHUBFmFvDNTl0MAO3lYWzfb/YuTuxcKpgrRijD+cCnVEfe/8xsdkxm6JBXncrLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748932547; c=relaxed/simple;
	bh=ELnXhJkbJCsKdhfLMVyIVyfsr6F29nMKlm62nLLbzas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D9F01mmzzqVzqQyfbMe2RnM4aG+MgtuWR1ot9w1pkrVjbz8h7gQHoQruikL2hHiOVBAyDHfOpGB4GeYIWpo+tfxZxdUs5xUvGvF0by47ufoFBVCuccTkDpPoUbc+8nZOlCVy8GiWI1XPn3KLFJ5b0YyCRXB6X84+OmFwvI0SKjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnVaBVWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnVaBVWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B392C4CEF4
	for <linux-cifs@vger.kernel.org>; Tue,  3 Jun 2025 06:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748932547;
	bh=ELnXhJkbJCsKdhfLMVyIVyfsr6F29nMKlm62nLLbzas=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FnVaBVWNHFrv13cEZj2iNGw341BDyxB2SbzrK8p7QVbSQ0ozTaLvkHdBO3pWMC/V0
	 5wJZ0ZYhf+IdeleeVyDVsS4gRcQObZa7YP5r7IGdm/ryH7qfnUY4xm/KOwqqAagiEh
	 wObYwS11uZAKrQLJ2Y6I/LjrJX83URwqQekDULseSIpIUc6TzT27Rjqs7q7L+qOhTi
	 Vq1aFPvJTPpiaupUHTslxPs1nymNvVKIGTsavlyAc5FpRZF+WwjSOwuwjicTeafmGc
	 gLBs1Uoj5R/BVzjcfGtTW/HmduNLkjOjhnDOH1fV9m+zennIocDYH6aDAAKIuJAA99
	 HYnUmngAhZ4EQ==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-60462000956so8890828a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 02 Jun 2025 23:35:47 -0700 (PDT)
X-Gm-Message-State: AOJu0YxlkobdT0oLHCQuxif3YzC4nNJAs1s3erCx/1uQhynRmeZu5T+T
	Kkqi7/vnFOij2esXomkufbrvoh0gcD8y4BhvCPGOD+DG7u62Nzc71e1EI9p/UtlHFQdrS2+YcP2
	5KgPtGTQwNXizgDTqmEfhSgdaesZONAE=
X-Google-Smtp-Source: AGHT+IG1EvuO0OBJ8XPzyyHuw2+SWVLx0UK2I3qan17fTY/GuTBa2a6UalEXm9b/PzyRebsoAJn1j6hTUuNrhQHxU/8=
X-Received: by 2002:a17:906:6a1d:b0:ad9:adc3:20d4 with SMTP id
 a640c23a62f3a-adb36b230b5mr1565465266b.4.1748932545654; Mon, 02 Jun 2025
 23:35:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603042958.9862-1-meetakshisetiyaoss@gmail.com>
In-Reply-To: <20250603042958.9862-1-meetakshisetiyaoss@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 3 Jun 2025 15:35:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8LSN6ux1C_kzEaBgN-zA9jF05_BU0gGLQjv=yUBGdGiA@mail.gmail.com>
X-Gm-Features: AX0GCFuivcO6GhGcXHtedICcEwtkluIBopBZZ9hSLhM-RMgvALP6GIB2i-Y1snQ
Message-ID: <CAKYAXd8LSN6ux1C_kzEaBgN-zA9jF05_BU0gGLQjv=yUBGdGiA@mail.gmail.com>
Subject: Re: [PATCH] cifs: add documentation for smbdirect setup
To: meetakshisetiyaoss@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, nspmangalore@gmail.com, 
	bharathsm.hsk@gmail.com, pc@manguebit.com, lsahlber@redhat.com, 
	tom@talpey.com, sfrench@samba.org, metze@samba.org, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 3, 2025 at 1:30=E2=80=AFPM <meetakshisetiyaoss@gmail.com> wrote=
:
>
> From: Meetakshi Setiya <msetiya@microsoft.com>
>
> Document steps to use SMB over RDMA using the linux SMB client and
> KSMBD server
>
> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  Documentation/filesystems/smb/smbdirect.rst | 91 +++++++++++++++++++++
>  1 file changed, 91 insertions(+)
>  create mode 100644 Documentation/filesystems/smb/smbdirect.rst
>
> diff --git a/Documentation/filesystems/smb/smbdirect.rst b/Documentation/=
filesystems/smb/smbdirect.rst
> new file mode 100644
> index 000000000000..98dec004a058
> --- /dev/null
> +++ b/Documentation/filesystems/smb/smbdirect.rst
> @@ -0,0 +1,91 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +SMB Direct - SMB3 over RDMA
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +
> +This document describes how to set up the Linux SMB client and server to
> +use RDMA.
> +
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +The Linux SMB kernel client supports SMB Direct, which is a transport
> +scheme for SMB3 that uses RDMA (Remote Direct Memory Access) to provide
> +high throughput and low latencies by bypassing the traditional TCP/IP
> +stack.
> +SMB Direct on the Linux SMB client can be tested against KSMBD - a
> +kernel-space SMB server.
> +
> +Installation
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +- Install an RDMA device. As long as the RDMA device driver is supported
> +  by the kernel, it should work. This includes both software emulators (=
soft
> +  RoCE, soft iWARP) and hardware devices (InfiniBand, RoCE, iWARP).
> +
> +- Install a kernel with SMB Direct support. The first kernel release to
> +  support SMB Direct on both the client and server side is 5.15. Therefo=
re,
> +  a distribution compatible with kernel 5.15 or later is required.
> +
> +- Install cifs-utils, which provides the `mount.cifs` command to mount S=
MB
> +  shares.
> +
> +- Configure the RDMA stack
> +
> +  Make sure that your kernel configuration has RDMA support enabled. Und=
er
> +  Device Drivers -> Infiniband support, update the kernel configuration =
to
> +  enable Infiniband support.
Hi Meetakshi,

Looks good:)
> +
> +  Enable the appropriate IB HCA support or iWARP adapter support,
> +  depending on your setup.
You can refer to nfs rdma setup wiki for soft iWARP.

https://wiki.linux-nfs.org/wiki/index.php/NFS_over_soft_iWARP_setup
> +
> +  If you are using InfiniBand, enable IP-over-InfiniBand support.
> +
> +- Enable SMB Direct support for both the server and the client in the
> +  kernel configuration.
> +
> +    Server Setup
> +
> +    .. code-block:: text
> +
> +        Network File Systems  --->
> +            <M> SMB3 server support
> +                [*] Support for SMB Direct protocol
> +
> +    Client Setup
> +
> +    .. code-block:: text
> +
> +        Network File Systems  --->
> +            <M> SMB3 and CIFS support (advanced network filesystem)
> +                [*] SMB Direct support
> +
> +- Build and install the kernel. SMB Direct support will be enabled in th=
e
> +  cifs.ko and ksmbd.ko modules.
> +
> +Setup and Usage
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +- Set up and start a KSMBD server as described in the `KSMBD documentati=
on
> +  <https://www.kernel.org/doc/Documentation/filesystems/smb/ksmbd.rst>`_=
.
We need to add "server multi channel support =3D yes" parameter to ksmbd.co=
nf.
Could you please mention this?

Thanks!
> +
> +- On the client, mount the share with `rdma` mount option to use SMB Dir=
ect
> +  (specify a SMB version 3.0 or higher using `vers`).
> +
> +  For example:
> +
> +    .. code-block:: bash
> +
> +        mount -t cifs //server/share /mnt/point -o vers=3D3.1.1,rdma
> +
> +- To verify that the mount is using SMB Direct, you can check dmesg for =
the
> +  following log line after mounting:
> +
> +    .. code-block:: text
> +
> +        CIFS: VFS: RDMA transport established
> +
> +  Or, verify `rdma` mount option for the share in `/proc/mounts`:
> +
> +    .. code-block:: bash
> +
> +        cat /proc/mounts | grep cifs
> --
> 2.46.0.46.g406f326d27
>
