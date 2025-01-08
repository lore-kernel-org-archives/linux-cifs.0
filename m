Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5F9202C4F
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jan 2025 22:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736376042; cv=none; b=QCA9BfnnPhZUjYiWOKJxsQqQ53EK+luesbXx1EwLAaNIV4Zc5v2G4dW/PzSd4OPBw8NhunQUSguEkjdJCKL89Ea+uIqy875edyhIPYn95XgXrbLrLMuGdpUrTQ5JTTXmoBzZNLJreX23HzJkzcG1dcpM8MQLR8AR8Q0vj8xPx34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736376042; c=relaxed/simple;
	bh=C3ywzospg9N8GMSGgWsZB8yDQdRpJTdLfKR3t41R184=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AB9+Shbgw1gVNBKUm+Yw5r9pag8oXCdl5nSzHG/+elsJUQzlQsBLkotRxAKjH0d5/dkNDpzI7ydkQXLA5nnUg0TN519tqqXbYxvnTRXdvMKyaJE0uD6esooOznDMYcUxDDOBwwRKg4HyyQjr0qh5Wun79/U+E9VinopIWABFR+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OIRU0Yaj; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OIRU0Yaj"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e46ac799015so347005276.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jan 2025 14:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736376040; x=1736980840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jacN9/9vh+AEjXzs3gn/o60TBVDOA2OKji84lOzBIbY=;
        b=OIRU0Yaj1V572xu1wrqDRM4aPFG4bNJu3lbDhC8aE+6fjL+yVhVU0Hz1Nf1RlJ+I6P
         f/LMG0eO9Hs1mwkP4DCZcvm8YitJd90d9ImUytWuGXVSeEiDiK8XpFEKk7lqU2cYzXS4
         xx486DRMyRvgnS6NanUWVJ51tVHln+U8xGRnpGdbNDy7RTIJPz5KNlAJkPEs/uGZABqA
         obTShvG8k0fIR/ZsgfyhEIfQGCrfGdpR9RffhFZ6GbCOiwovKmCDJwZWA//+q4Waozj6
         VhoVlQIGNpETB9eKe29atxcoT8mgQC/YsMqmHrbpQdXUQ4WBKdPzQTDuPDp527wprSG/
         Y41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736376040; x=1736980840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jacN9/9vh+AEjXzs3gn/o60TBVDOA2OKji84lOzBIbY=;
        b=oAWahqn9hKcwsyf/SlO/vTRjoTRQzP68vq5CNGL4SMjCbR8zN5JnzmaQFQZZjd/mFi
         sEXxx0iuId/B1XNeFCnSAQSlyPbGXrg1l7LmiAjfQJsL6sfFodJFL4iydK+sSLoaNP6U
         NW7qfWmynjIRsNQvPN2RI5JczquDVDAVJJCTipJ9RFXTGb17AbCIkTw4CqwMiG0w+D3O
         MjKXlYD4TB3+ZNcCZ1umxbZWKh/jnv1Ra+Ts2DTaAb/sJpTW2d/XJExNp/mCYtQQ2mzo
         YDaEeh4nTm4L72M0GLSGVNGDudWRl0dyb9ck4R0Q2Y5Bvd1syyezQmWyI9jG0rDc4zld
         dX0g==
X-Forwarded-Encrypted: i=1; AJvYcCX2RvL2n8g3Dr1ZYsH0NbYwuLJHGTm09DvQwHzDk6EysYMEhsGyQMhCJvYTrwgzPZiH27U76O1c0BcP@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6Kf5QOP5FeKnigq3ZrbZeKR2G6n1q286Ppaqy/r4FvSrAAyEe
	Yf3rdEyeUgZ6SQKkvQr2+QprGqMUL6n3K5WfOYIMKCzVWK8XAGXSyoEWNwPIZ1eOVlWodYLRP5l
	vG+NloXGH/tC3ROxYPu9npw4xzmmu1SWRng==
X-Gm-Gg: ASbGncuEUJkGf99yaFBxaTeTj64ttu5qIyZ1/n1Qan2aWq+rP2k4zeo6tN/PtuIEmeS
	fsEOR++Q5FWv0/+ffyuV4EC1+sMKivaXUVXI8OCIMHW3+PSNPdlS4bVn2wNfCgFVMV3d/fg==
X-Google-Smtp-Source: AGHT+IFpsvkuTwrJgUrsQ2FGYV9QR2kcRWNoE/2ErLtwT1ijE7ODJtI9PRZo99SoU4864loOUpSvQjblbkIOXXTxEtc=
X-Received: by 2002:a05:690c:ecd:b0:6f2:773b:dfab with SMTP id
 00721157ae682-6f53124c6edmr35252547b3.22.1736376039688; Wed, 08 Jan 2025
 14:40:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106135910.GF5006@unreal> <20241107125643.04f97394.pasic@linux.ibm.com>
 <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal> <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
 <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com> <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
 <20241219165616.GF82731@unreal> <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
 <20250108093126.GF87447@unreal> <55aeae3b-826b-4414-936c-26158792aecf@talpey.com>
In-Reply-To: <55aeae3b-826b-4414-936c-26158792aecf@talpey.com>
From: Kangjing Huang <huangkangjing@gmail.com>
Date: Wed, 8 Jan 2025 22:40:22 +0000
X-Gm-Features: AbW1kvbbJ2Ldg2iPkJqPy4UDx6PQg7e-RfT21_HVmxrhRBU_u6kGn2JGCsTBnQ0
Message-ID: <CAPbmFQb9VAt7cw5JUPKLaGwA4L8mUMegokYs5AVyj+wRhkxyiw@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using ib_device_get_netdev()
To: Tom Talpey <tom@talpey.com>, Leon Romanovsky <leon@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 5:27=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 1/8/2025 4:31 AM, Leon Romanovsky wrote:
> > On Tue, Jan 07, 2025 at 10:51:19PM +0000, Kangjing Huang wrote:
> >> On Thu, Dec 19, 2024 at 4:56=E2=80=AFPM Leon Romanovsky <leon@kernel.o=
rg> wrote:
> >>>
> >>> On Sat, Dec 14, 2024 at 08:02:14AM +0000, Kangjing Huang wrote:
> >>>> On Sat, Dec 14, 2024 at 1:06=E2=80=AFAM Leon Romanovsky <leon@kernel=
.org> wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>> On Sat, Dec 14, 2024, at 04:33, Namjae Jeon wrote:
> >>>>>> On Fri, Dec 13, 2024 at 8:07=E2=80=AFPM Kangjing Huang <huangkangj=
ing@gmail.com> wrote:
> >>>>>>>
> >>>>>>> Hi there,
> >>>>>>>
> >>>>>>> I am the original author of commit ecce70cf17d9 ("ksmbd: fix miss=
ing
> >>>>>>> RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()=
"),
> >>>>>>> as mentioned in the thread.
> >>>>>>>
> >>>>>>> I am working on modifying the patch to take care of the layering
> >>>>>>> violation. The original patch was meant to fix an issue with ksmb=
d,
> >>>>>>> where an IPoIB netdev was not recognized as RDMA-capable. The ori=
ginal
> >>>>>>> version of the capability evaluation tries to match each netdev t=
o
> >>>>>>> ib_device by calling get_netdev in ib verbs. However this only wo=
rks
> >>>>>>> in cases where the ib_device is the upper layer of netdev (e.g. R=
oCE),
> >>>>>>> and since with IPoIB it is the other way around (netdev is the up=
per
> >>>>>>> layer of ib_device), get_netdev won't work anymore.
> >>>>>>>
> >>>>>>> I tried to replicate the behavior of device matching reversely in=
 the
> >>>>>>> original version of my patch using GID, which ended up as the lay=
ering
> >>>>>>> violation. However I am unaware of any exported functions from th=
e
> >>>>>>> IPoIB driver that could do the reverse lookup from netdev to the =
lower
> >>>>>>> layer ib_device. Actually it seems that the IPoIB driver does not=
 have
> >>>>>>> any exported symbols at all.
> >>>>>>>
> >>>>>>> It might be that the device matching in reverse just does not mak=
e any
> >>>>>>> sense and does not need to be done at all. As long as it is an IP=
oIB
> >>>>>>> device (netdev->type =3D=3D ARPHRD_INFINIBAND) it might be ok to =
just
> >>>>>>> automatically assume it is RDMA-capable. I am not 100% sure about=
 this
> >>>>>>> though.
> >>>>>> Why can't we assume RDMA-capable if it's ARPHRD_INFINIBAND type?
> >>>>>> How about assuming it's RDMA-capable and allowing users to turn
> >>>>>> RDMA-capable on/off via sysfs?
> >>>> It does make more sense to me at this point to just broadly assume a=
ll
> >>>> ARPHRD_INFINIBAND types to be RDMA-capable, we just need to make sur=
e
> >>>> this assumption indeed holds and figure out to what extent this coul=
d
> >>>> involve the same layering violation.
> >>>>
> >>>>>
> >>>>> Any attempt to treat ipoib differently from regular netdevice is wr=
ong by definition.
> >>>>>
> >>>> I would agree that the design direction to treat ipoib as a pure
> >>>> regular net_device is the good way to go. But the problem with ksmbd
> >>>> and ipoib devices stems from the SMB protocol itself.
> >>>>
> >>>> In contrast to protocols that focus on certain functionalities like
> >>>> nfs, SMB actually tries to manage network interfaces actively in the
> >>>> protocol itself: SMB protocol's RDMA support (dubbed SMB Direct) is =
a
> >>>> sub-feature of SMB Multichannel. Multichannel is designed to let
> >>>> client and server find multiple data paths automatically (imagine a
> >>>> pair of hosts with multiple adapters connected by multiple cables) t=
o
> >>>> increase bandwidth. So client can initiate a
> >>>> FSCTL_QUERY_NETWORK_INTERFACE_INFO request and server is expected to
> >>>> respond with NETWORK_INTERFACE_INFO containing _all_ local network
> >>>> interface informations, including their capabilities such as
> >>>> RDMA_CAPABLE (for details see ref [MS-SMB2] 3.3.5.15.11) Only upon
> >>>> seeing the capability flag would a client attempt to initiate a RDMA
> >>>> connection.
> >>>>
> >>>> Reference: [MS-SMB2](https://winprotocoldoc.z19.web.core.windows.net=
/MS-SMB2/%5bMS-SMB2%5d.pdf)
> >>>>
> >>>> TLDR is that the SMB protocol requires the server to enumerate all
> >>>> net_devices and indicate their RDMA capability, and
> >>>> ksmbd_rdma_capable_netdev() is only used in that process. Given such
> >>>> context, I wonder what should be the best way to approach this? Is
> >>>> using ARPHRD_INFINIBAND good enough and acceptable in terms of
> >>>> layering?
> >>>
> >>
> >>> The thing is that ARPHRD_INFINIBAND indeed represent IPoIB and it is
> >>> right check if netdev is IPoIB or not. The layering problem is that
> >>> upper layers (ULPs) should use it as regular netdevice.
> >>
> >> This is good to know. However, since the SMB protocol explicitly calls
> >> for enumeration of all network interfaces on the server host,
> >> including their RDMA capabilities, I believe this is a sensible
> >> exception to the layering rule. Or is there anyway else to do this
> >> enumeration from the kernel space?
> >>
> >> Or we can give up implementing the full spec of the SMB protocol and
> >> call for explicit configuration from user space on how to respond to
> >> the IOCTL requests in question. Which one looks more sensible to you?
> >
> > My preference is to have same IPoIB treatment for all ULPs, including S=
MB.

If that is the case, then we don't really have many options left but
to expose the advertisement of rdma-capable flags as a configurable
option from the user space (maybe via sysfs). I am not sure if this
will allow the user to mark an interface as RDMA-capable despite its
incapability, or would the capability check be allowed to be made from
the configuration validation site?

> >
> > My GUESS is that SMB specification authors didn't take into account HW =
and
> > Linux SW development around IPoIB and weren't aware of IPoIB offload wh=
ich
> > is implemented and enabled by default in all modern IB NICs and Linux O=
Ses.
>
> The SMB3 specification is completely unconcerned with IPoIB and any
> other layer-2 or layer-3 implementation details. It merely discusses
> an exchange of network interface capabilities such as link speed and
> RDMA support. The SMB3 client uses this list to implement multichannel.
>
> I totally agree that inspecting ARPHRD_INFINIBAND is an incorrect method
> of building this list. Just because an interface supports IPoIB does not
> mean it also exposes RDMA, especially in-kernel. And that ignores any
> non-IB transport too of course.

I see, so if I understand this argument correctly, the point is that
even if an IPoIB device *is* guaranteed to have some RDMA support in
the stack (since IPoIB is ULP of an IB device, which always supports
RDMA), it does not necessarily want to expose that capability to its
own ULP in the stacks above, right? However if this is the case, then
what would be the correct way to determine the capability flag from a
ULP?

>
> Kangjing, please educate me if I'm confused here, but doesn't the
> code in ksmbd_rdma_capable_netdev() look up the ib_device anyway, at
> the end of the function?
>
> >       if (rdma_capable =3D=3D false) {
> >               struct ib_device *ibdev;
> >
> >               ibdev =3D ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNK=
NOWN);
> >               if (ibdev) {
> >                       if (rdma_frwr_is_supported(&ibdev->attrs))
> >                               rdma_capable =3D true;
> >                       ib_device_put(ibdev);
> >               }
> >       }
> >
> >       return rdma_capable;
>
> So, why is the code concerned at all with ARPHRD_INFINIBAND just a few
> lines above?

This check does not work with IPoIB devices. For IPoIB devices
ib_device_get_by_netdev would just return null.

Correct me if I am wrong but I think this API is intended to work with
RDMA/IB transport as ULP of a normal netdev transport (e.g. RoCE,
iWARP). It essentially only performs a lookup of the devices up the
stack, not down the stack, thus not working for IPoIB devices. I feel
this is somehow intended as well since it works inline with the
principle that IPoIB devices should just be treated like a normal
netdev.

This is probably true for the get_netdev verb on ib_device, and the
ib_device_get_netdev API, they are just performing the lookup in
reverse direction.

> And why does it look in the smb_direct_device_list first?

I don't know - this section of code is already here before my patch,
and it confuses me a lot too. It is actually doing the lookup in one
direction and then doing it again in the other direction, probably on
the same mapping. I just left it there during initial patch
submission, just in fear of breaking any strange corner cases.

Thanks,
Kangjing


>
> Tom.
>
> >
> > That offload allows line-rate for IPoIB, something that is not possible
> > for SW IPoIB.
> >
> > Thanks
> >
> >>
> >> Thanks
> >>
> >>>
> >>> Thanks
> >>>
> >>>>
> >>>>>>
> >>>>>> Thanks!
> >>>>>>>
> >>>>>>> I am uncertain about how to proceed at this point and would like =
to
> >>>>>>> know your thoughts and opinions on this.
> >>>>>>>
> >>>>>>> Thanks,
> >>>>>>> Kangjing
> >>>>>>>
> >>>>>>> On Fri, Nov 8, 2024 at 5:59=E2=80=AFPM Leon Romanovsky <leon@kern=
el.org> wrote:
> >>>>>>>>
> >>>>>>>> On Fri, Nov 08, 2024 at 08:40:40AM +0900, Namjae Jeon wrote:
> >>>>>>>>> On Thu, Nov 7, 2024 at 9:00=E2=80=AFPM Halil Pasic <pasic@linux=
.ibm.com> wrote:
> >>>>>>>>>>
> >>>>>>>>>> On Wed, 6 Nov 2024 15:59:10 +0200
> >>>>>>>>>> Leon Romanovsky <leon@kernel.org> wrote:
> >>>>>>>>>>
> >>>>>>>>>>>> Does  fs/smb/server/transport_rdma.c qualify as inside of RD=
MA core code?
> >>>>>>>>>>>
> >>>>>>>>>>> RDMA core code is drivers/infiniband/core/*.
> >>>>>>>>>>
> >>>>>>>>>> Understood. So this is a violation of the no direct access to =
the
> >>>>>>>>>> callbacks rule.
> >>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>>> I would guess it is not, and I would not actually mind sendi=
ng a patch
> >>>>>>>>>>>> but I have trouble figuring out the logic behind  commit ecc=
e70cf17d9
> >>>>>>>>>>>> ("ksmbd: fix missing RDMA-capable flag for IPoIB device in
> >>>>>>>>>>>> ksmbd_rdma_capable_netdev()").
> >>>>>>>>>>>
> >>>>>>>>>>> It is strange version of RDMA-CM. All other ULPs use RDMA-CM =
to avoid
> >>>>>>>>>>> GID, netdev and fabric complexity.
> >>>>>>>>>>
> >>>>>>>>>> I'm not familiar enough with either of the subsystems. Based o=
n your
> >>>>>>>>>> answer my guess is that it ain't outright bugous but still a l=
ayering
> >>>>>>>>>> violation. Copying linux-cifs@vger.kernel.org so that
> >>>>>>>>>> the smb are aware.
> >>>>>>>>> Could you please elaborate what the violation is ?
> >>>>>>>>
> >>>>>>>> There are many, but the most screaming is that ksmbd has logic t=
o
> >>>>>>>> differentiate IPoIB devices. These devices are pure netdev devic=
es
> >>>>>>>> and should be treated like that. ULPs should treat them exactly
> >>>>>>>> as they treat netdev devices.
> >>>>>>>>
> >>>>>>>>> I would also appreciate it if you could suggest to me how to fi=
x this.
> >>>>>>>>>
> >>>>>>>>> Thanks.
> >>>>>>>>>>
> >>>>>>>>>> Thank you very much for all the explanations!
> >>>>>>>>>>
> >>>>>>>>>> Regards,
> >>>>>>>>>> Halil
> >>>>>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>> --
> >>>>>>> Kangjing "Chaser" Huang
> >>>>
> >>>>
> >>>>
> >>>> --
> >>>> Kangjing "Chaser" Huang
> >>
> >>
> >>
> >> --
> >> Kangjing "Chaser" Huang
> >
> >
>


--
Kangjing "Chaser" Huang
