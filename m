Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F4086330
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jan 2025 22:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736290298; cv=none; b=Vp/fXlnHDrvh0c6fp30H3WgrftlRSst8YkC2vvMxfyIcLI1Jhx7KS66dyi9sHJDcY2Mbh6BDaZBEuu0UZuKoocH8sYqNeheksscjpXY/lM90v0BElPXmY7v+7kk2aYgxbTqN4xKRWR9QuKlSA5DXMMEdMgE5xK4CzqM0bmWM4nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736290298; c=relaxed/simple;
	bh=CcuvDw/+ojFMbBntNEImm99ZIFDbcih+JXuwG2gTGJs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WEDZoZ38CmW5JlvoPdmakOFGpwdi99YiwofHz5qBEu26qtRPNljAqxPML7e98Ly1Li/O57qt6i2M7720Lsy/fEs/8Y67npAuOXV3PUgElGil1LxNY/a3/40R8Zox/0KSz1g1VDm8ULwE6eyDINh+8XPPLGAX38Gb1l+C1xQpuGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c9JrVp2F; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9JrVp2F"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e549a71dd3dso7353441276.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jan 2025 14:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736290295; x=1736895095; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iKyb8CaMtijrh7ovFxxwvmh5UCrix2b/a3hqNGvpDfM=;
        b=c9JrVp2FJYneqENShlKzfNt9GkIN/43Xjb1tyKZwLnFBg2BT+UycFkvlcZOp2yVpOi
         sYdZxpvKBuGzE/TpxUqSvTsj9CMnGVuAZMJTsqHeK9VwxjX//s/2R2m3vSXvtCOMf/yw
         gMsryxwdMs5DJvHUnCL71zaRGI+hol7isv77Zb2goWyCmKPJ/MVZagDcPWn9uLt7VGse
         YqYUfxZsXYYUGsZRo5wPTQvZxIE6kjo2HC1+o7qZZPmfGplpNcNOyZuWe+hSVw7mJDeL
         BFjE8fy5RuW536Eryki0P2IXzWVja9szazEML8wakLv3ofFSUCuhqHuaqiSi72+ZbhpZ
         aD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736290295; x=1736895095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iKyb8CaMtijrh7ovFxxwvmh5UCrix2b/a3hqNGvpDfM=;
        b=BGnW6QeuEhC68xRCqeY6s4PK7R8pDA6/betkRCiI93KdFulSGT9OcrSeefWPSQSi3U
         WM/o3cZZHDA0/WKzeQbfVTv4gHubeGyhLbBeRpll1Kds4JtxIBbZqMGIgFi10lrZ5Vtq
         ZT9U5NGqdA6LnX3up6BkcLuo3J0aYICWx50/kRECZIDAeFhjK3bbZhPbVz3lL3nTqW5w
         iPXetojrVIHf+Jz4uECT3KergtAnkuxU3z/wIwSfpJ02cPHdQ6vR4yddCHLAPaivy9Rv
         DeqUGPgkUr/0Oh0gQK8bvIbBIgrBOAXMOmMM2bSSeyriflMWTSJLgdSBj/sode+4xcAu
         UvaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWH/UDNXQS7meejdFbsPfrf5hjv1rxJgOVyCNWzGjaC2+fWTsR4mmZ66UdjiplkWTiHiDg0LboZkMPI@vger.kernel.org
X-Gm-Message-State: AOJu0YwScF9BzVanxV0nMaDgyvYdZQ0vSKeM/FQLUNNEvIBjQ3QwQdq1
	JXjJjpk8TyDqRFE6IWZqsR4kyqiCaIobmwDiRFz2fXfPU4crPudTzWC9teu8O7NNKgGwqIo+VMf
	QQ+W2BqOTGgb3SybdTQc9l8bS5LzfX9o=
X-Gm-Gg: ASbGncveY7pl7+NUx+aFiggH/P7bfBuCRwzGieJ/kv2YJs2Lc1cPbK7ufTpKyIjhHQm
	qVynrlVqL/S36lgHF9CxoG7g4J9jfG6uCEBy3AtsC4j8Rn1HSgjQlhuzIsQaxnULQ/qswLQ==
X-Google-Smtp-Source: AGHT+IER840FtAn5XChTw7qFeDHaYhySLrhWI8yvxV8XBwmmbiLR6qUuN/Whki7xh0YI3kAHvwAuYBxiUv/uEWr9hAo=
X-Received: by 2002:a05:690c:6084:b0:6ef:c487:f401 with SMTP id
 00721157ae682-6f531263321mr5847937b3.25.1736290295411; Tue, 07 Jan 2025
 14:51:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105112313.GE311159@unreal> <20241106102439.4ca5effc.pasic@linux.ibm.com>
 <20241106135910.GF5006@unreal> <20241107125643.04f97394.pasic@linux.ibm.com>
 <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal> <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
 <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com> <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
 <20241219165616.GF82731@unreal>
In-Reply-To: <20241219165616.GF82731@unreal>
From: Kangjing Huang <huangkangjing@gmail.com>
Date: Tue, 7 Jan 2025 22:51:19 +0000
X-Gm-Features: AbW1kvbA39e_IuiEPj-gqjOgrO__5Y1gmpJeGYTo-QqO_cJMPcvSP5z7QO2h5b0
Message-ID: <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using ib_device_get_netdev()
To: Leon Romanovsky <leon@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024 at 4:56=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Sat, Dec 14, 2024 at 08:02:14AM +0000, Kangjing Huang wrote:
> > On Sat, Dec 14, 2024 at 1:06=E2=80=AFAM Leon Romanovsky <leon@kernel.or=
g> wrote:
> > >
> > >
> > >
> > > On Sat, Dec 14, 2024, at 04:33, Namjae Jeon wrote:
> > > > On Fri, Dec 13, 2024 at 8:07=E2=80=AFPM Kangjing Huang <huangkangji=
ng@gmail.com> wrote:
> > > >>
> > > >> Hi there,
> > > >>
> > > >> I am the original author of commit ecce70cf17d9 ("ksmbd: fix missi=
ng
> > > >> RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"=
),
> > > >> as mentioned in the thread.
> > > >>
> > > >> I am working on modifying the patch to take care of the layering
> > > >> violation. The original patch was meant to fix an issue with ksmbd=
,
> > > >> where an IPoIB netdev was not recognized as RDMA-capable. The orig=
inal
> > > >> version of the capability evaluation tries to match each netdev to
> > > >> ib_device by calling get_netdev in ib verbs. However this only wor=
ks
> > > >> in cases where the ib_device is the upper layer of netdev (e.g. Ro=
CE),
> > > >> and since with IPoIB it is the other way around (netdev is the upp=
er
> > > >> layer of ib_device), get_netdev won't work anymore.
> > > >>
> > > >> I tried to replicate the behavior of device matching reversely in =
the
> > > >> original version of my patch using GID, which ended up as the laye=
ring
> > > >> violation. However I am unaware of any exported functions from the
> > > >> IPoIB driver that could do the reverse lookup from netdev to the l=
ower
> > > >> layer ib_device. Actually it seems that the IPoIB driver does not =
have
> > > >> any exported symbols at all.
> > > >>
> > > >> It might be that the device matching in reverse just does not make=
 any
> > > >> sense and does not need to be done at all. As long as it is an IPo=
IB
> > > >> device (netdev->type =3D=3D ARPHRD_INFINIBAND) it might be ok to j=
ust
> > > >> automatically assume it is RDMA-capable. I am not 100% sure about =
this
> > > >> though.
> > > > Why can't we assume RDMA-capable if it's ARPHRD_INFINIBAND type?
> > > > How about assuming it's RDMA-capable and allowing users to turn
> > > > RDMA-capable on/off via sysfs?
> > It does make more sense to me at this point to just broadly assume all
> > ARPHRD_INFINIBAND types to be RDMA-capable, we just need to make sure
> > this assumption indeed holds and figure out to what extent this could
> > involve the same layering violation.
> >
> > >
> > > Any attempt to treat ipoib differently from regular netdevice is wron=
g by definition.
> > >
> > I would agree that the design direction to treat ipoib as a pure
> > regular net_device is the good way to go. But the problem with ksmbd
> > and ipoib devices stems from the SMB protocol itself.
> >
> > In contrast to protocols that focus on certain functionalities like
> > nfs, SMB actually tries to manage network interfaces actively in the
> > protocol itself: SMB protocol's RDMA support (dubbed SMB Direct) is a
> > sub-feature of SMB Multichannel. Multichannel is designed to let
> > client and server find multiple data paths automatically (imagine a
> > pair of hosts with multiple adapters connected by multiple cables) to
> > increase bandwidth. So client can initiate a
> > FSCTL_QUERY_NETWORK_INTERFACE_INFO request and server is expected to
> > respond with NETWORK_INTERFACE_INFO containing _all_ local network
> > interface informations, including their capabilities such as
> > RDMA_CAPABLE (for details see ref [MS-SMB2] 3.3.5.15.11) Only upon
> > seeing the capability flag would a client attempt to initiate a RDMA
> > connection.
> >
> > Reference: [MS-SMB2](https://winprotocoldoc.z19.web.core.windows.net/MS=
-SMB2/%5bMS-SMB2%5d.pdf)
> >
> > TLDR is that the SMB protocol requires the server to enumerate all
> > net_devices and indicate their RDMA capability, and
> > ksmbd_rdma_capable_netdev() is only used in that process. Given such
> > context, I wonder what should be the best way to approach this? Is
> > using ARPHRD_INFINIBAND good enough and acceptable in terms of
> > layering?
>

> The thing is that ARPHRD_INFINIBAND indeed represent IPoIB and it is
> right check if netdev is IPoIB or not. The layering problem is that
> upper layers (ULPs) should use it as regular netdevice.

This is good to know. However, since the SMB protocol explicitly calls
for enumeration of all network interfaces on the server host,
including their RDMA capabilities, I believe this is a sensible
exception to the layering rule. Or is there anyway else to do this
enumeration from the kernel space?

Or we can give up implementing the full spec of the SMB protocol and
call for explicit configuration from user space on how to respond to
the IOCTL requests in question. Which one looks more sensible to you?

Thanks

>
> Thanks
>
> >
> > > >
> > > > Thanks!
> > > >>
> > > >> I am uncertain about how to proceed at this point and would like t=
o
> > > >> know your thoughts and opinions on this.
> > > >>
> > > >> Thanks,
> > > >> Kangjing
> > > >>
> > > >> On Fri, Nov 8, 2024 at 5:59=E2=80=AFPM Leon Romanovsky <leon@kerne=
l.org> wrote:
> > > >> >
> > > >> > On Fri, Nov 08, 2024 at 08:40:40AM +0900, Namjae Jeon wrote:
> > > >> > > On Thu, Nov 7, 2024 at 9:00=E2=80=AFPM Halil Pasic <pasic@linu=
x.ibm.com> wrote:
> > > >> > > >
> > > >> > > > On Wed, 6 Nov 2024 15:59:10 +0200
> > > >> > > > Leon Romanovsky <leon@kernel.org> wrote:
> > > >> > > >
> > > >> > > > > > Does  fs/smb/server/transport_rdma.c qualify as inside o=
f RDMA core code?
> > > >> > > > >
> > > >> > > > > RDMA core code is drivers/infiniband/core/*.
> > > >> > > >
> > > >> > > > Understood. So this is a violation of the no direct access t=
o the
> > > >> > > > callbacks rule.
> > > >> > > >
> > > >> > > > >
> > > >> > > > > > I would guess it is not, and I would not actually mind s=
ending a patch
> > > >> > > > > > but I have trouble figuring out the logic behind  commit=
 ecce70cf17d9
> > > >> > > > > > ("ksmbd: fix missing RDMA-capable flag for IPoIB device =
in
> > > >> > > > > > ksmbd_rdma_capable_netdev()").
> > > >> > > > >
> > > >> > > > > It is strange version of RDMA-CM. All other ULPs use RDMA-=
CM to avoid
> > > >> > > > > GID, netdev and fabric complexity.
> > > >> > > >
> > > >> > > > I'm not familiar enough with either of the subsystems. Based=
 on your
> > > >> > > > answer my guess is that it ain't outright bugous but still a=
 layering
> > > >> > > > violation. Copying linux-cifs@vger.kernel.org so that
> > > >> > > > the smb are aware.
> > > >> > > Could you please elaborate what the violation is ?
> > > >> >
> > > >> > There are many, but the most screaming is that ksmbd has logic t=
o
> > > >> > differentiate IPoIB devices. These devices are pure netdev devic=
es
> > > >> > and should be treated like that. ULPs should treat them exactly
> > > >> > as they treat netdev devices.
> > > >> >
> > > >> > > I would also appreciate it if you could suggest to me how to f=
ix this.
> > > >> > >
> > > >> > > Thanks.
> > > >> > > >
> > > >> > > > Thank you very much for all the explanations!
> > > >> > > >
> > > >> > > > Regards,
> > > >> > > > Halil
> > > >> > > >
> > > >>
> > > >>
> > > >>
> > > >> --
> > > >> Kangjing "Chaser" Huang
> >
> >
> >
> > --
> > Kangjing "Chaser" Huang



--=20
Kangjing "Chaser" Huang
