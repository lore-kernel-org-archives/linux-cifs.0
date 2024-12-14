Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062C463C
	for <linux-cifs@vger.kernel.org>; Sat, 14 Dec 2024 08:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734163353; cv=none; b=XhgWN0vrAQh9+vOfK3dCnI2AmeynW9i5B8fx4DMPAMZ9OzgerxgRVEGlHX9BG60ti7ENj/EyJ/roqr9jXTwc+MbjGzU7HdHSlW35q4GeRy4OrPCAGsaO1mQbqzr5A232UBk1aStQpC2j6to+cBAMqF+HxnvTzZOkd+E6YAizvB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734163353; c=relaxed/simple;
	bh=vX8LMukglrIiYxVOQe/GEV8A75laW0xasyoy65xfQyE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sf+y/eC9LJmhMxOHKrPvRmW/j/APGnRxNCez3PUbUGBA9cMAFSdehGX1t3KER0ed85H2buKBbJyK1M7aOZMXcPaG9rxo/hBu8Lrj1mwaye+5HSt20Vh698482c6Q6xRT1oZgDg9WICJWgYyKxgYHbERO0dyCHc5XZx8CgXT99Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vghxo40S; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vghxo40S"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e3c8f39cab1so2017217276.0
        for <linux-cifs@vger.kernel.org>; Sat, 14 Dec 2024 00:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734163351; x=1734768151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMYzyKxyfrpF1woNn1Jqd9V81De9sfX51n1YICwtUbM=;
        b=Vghxo40SxXJYlGHbaxvMcGrjVv4qMlB6Ba4XkeAmU7lv39WfyPMxaLGn7xBojf7VHa
         uZYXFwQG8NU7N4PwTq8yL4k215ME9uVwkTHPbRY+GYKbsm0zJ2lyQkrLnpXh6nEKfz9B
         WfQCwVLjAQdwiZjJViHN7OZL36xd2iiZNqx66smoG48/TLBQxv79xQ2v9vt2PYNirLmw
         LAjfEOOTjihFt80foZfjoMna3IjsTHIhqi1mFyRIhbOU4Qz176SLi48raVcerDhXZeA7
         bwEtxlMqisSFWwUOz4B254uTqTid+yDvGMRycUjuQ0fYPyRCUbswW/LjUW6MLOLlp9aA
         bF9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734163351; x=1734768151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zMYzyKxyfrpF1woNn1Jqd9V81De9sfX51n1YICwtUbM=;
        b=xLstTC6wolOhYrSamTHVMO5+8oJXy7L3lgzKBlet3haigV8niAOL0ysXKRK4jfZyrF
         BbBmiR9MSG+uVl3pf2po3yens99yvkjMPO2pzgGqt+s0dPF5KO+V5+dzG9JFQ9vR7Nna
         8I74sUh5kQD+JUESRZ80F32OmfCq25VprLCXR6bQuqJHDfZ4wI4nRdfqXLu6AVS68oQH
         1M3JV57UG99CDl02jNKC+SnRRn7S0DyDwMOglEg8aeTHFpDyQpvd+Rf5s1lpbSTCZH4J
         pGIZencToe4qkWdf9fx7h6ygU6pUaX/x1EiLIBOLIGeW3Ac+G6mRpSaDkBFuaxTKZ+zk
         Kyvg==
X-Forwarded-Encrypted: i=1; AJvYcCUFtLqp9Nc/9tUGczc6OSw+wxKT9yAdaJWSvmXzabcNgbUXZzcEa3CLHoCNOl8JTbitsL1JxIXuA4f/@vger.kernel.org
X-Gm-Message-State: AOJu0YxpbpF2RVNoAaPWVn8tDji2/90vsEXS2zv9uHOGVG5hlsxxrYmh
	vCVH3FKOYoSiFWaz03o1MW9gcsGkgyrg4gSvj4QoDfRNy0HzTMswdTtGWNI4miHcy19hkP2TlUH
	8iZOiICkfIGitLB2OOKuhXKCs8A==
X-Gm-Gg: ASbGncvZTTneNvwgxsSaPoqgoDz3be1VoDQCsTeQ/Ab0D4Wy+jFcD9E1Ft/KDy1iB4Y
	Bp3fdyHp/uwrc+gFugHrgEL4m5zHDvyWi2YyjJkLdG73lW3Z0c9goU+DW/O3ZfZhQQ0kg4A==
X-Google-Smtp-Source: AGHT+IG5HYAcrWh7k8sNGavJ6sWxgZY15guFYBBzVFhgFK4onbevd7xQVE9Uha2pi48yFLuaevFdkfH3Dj0eCdt/T5o=
X-Received: by 2002:a25:9f02:0:b0:e48:c570:301f with SMTP id
 3f1490d57ef6-e48c570305bmr208847276.4.1734163350882; Sat, 14 Dec 2024
 00:02:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241025072356.56093-1-wenjia@linux.ibm.com> <20241027201857.GA1615717@unreal>
 <8d17b403-aefa-4f36-a913-7ace41cf2551@linux.ibm.com> <20241105112313.GE311159@unreal>
 <20241106102439.4ca5effc.pasic@linux.ibm.com> <20241106135910.GF5006@unreal>
 <20241107125643.04f97394.pasic@linux.ibm.com> <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal> <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com> <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com>
In-Reply-To: <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com>
From: Kangjing Huang <huangkangjing@gmail.com>
Date: Sat, 14 Dec 2024 08:02:14 +0000
Message-ID: <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using ib_device_get_netdev()
To: Leon Romanovsky <leon@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 14, 2024 at 1:06=E2=80=AFAM Leon Romanovsky <leon@kernel.org> w=
rote:
>
>
>
> On Sat, Dec 14, 2024, at 04:33, Namjae Jeon wrote:
> > On Fri, Dec 13, 2024 at 8:07=E2=80=AFPM Kangjing Huang <huangkangjing@g=
mail.com> wrote:
> >>
> >> Hi there,
> >>
> >> I am the original author of commit ecce70cf17d9 ("ksmbd: fix missing
> >> RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"),
> >> as mentioned in the thread.
> >>
> >> I am working on modifying the patch to take care of the layering
> >> violation. The original patch was meant to fix an issue with ksmbd,
> >> where an IPoIB netdev was not recognized as RDMA-capable. The original
> >> version of the capability evaluation tries to match each netdev to
> >> ib_device by calling get_netdev in ib verbs. However this only works
> >> in cases where the ib_device is the upper layer of netdev (e.g. RoCE),
> >> and since with IPoIB it is the other way around (netdev is the upper
> >> layer of ib_device), get_netdev won't work anymore.
> >>
> >> I tried to replicate the behavior of device matching reversely in the
> >> original version of my patch using GID, which ended up as the layering
> >> violation. However I am unaware of any exported functions from the
> >> IPoIB driver that could do the reverse lookup from netdev to the lower
> >> layer ib_device. Actually it seems that the IPoIB driver does not have
> >> any exported symbols at all.
> >>
> >> It might be that the device matching in reverse just does not make any
> >> sense and does not need to be done at all. As long as it is an IPoIB
> >> device (netdev->type =3D=3D ARPHRD_INFINIBAND) it might be ok to just
> >> automatically assume it is RDMA-capable. I am not 100% sure about this
> >> though.
> > Why can't we assume RDMA-capable if it's ARPHRD_INFINIBAND type?
> > How about assuming it's RDMA-capable and allowing users to turn
> > RDMA-capable on/off via sysfs?
It does make more sense to me at this point to just broadly assume all
ARPHRD_INFINIBAND types to be RDMA-capable, we just need to make sure
this assumption indeed holds and figure out to what extent this could
involve the same layering violation.

>
> Any attempt to treat ipoib differently from regular netdevice is wrong by=
 definition.
>
I would agree that the design direction to treat ipoib as a pure
regular net_device is the good way to go. But the problem with ksmbd
and ipoib devices stems from the SMB protocol itself.

In contrast to protocols that focus on certain functionalities like
nfs, SMB actually tries to manage network interfaces actively in the
protocol itself: SMB protocol's RDMA support (dubbed SMB Direct) is a
sub-feature of SMB Multichannel. Multichannel is designed to let
client and server find multiple data paths automatically (imagine a
pair of hosts with multiple adapters connected by multiple cables) to
increase bandwidth. So client can initiate a
FSCTL_QUERY_NETWORK_INTERFACE_INFO request and server is expected to
respond with NETWORK_INTERFACE_INFO containing _all_ local network
interface informations, including their capabilities such as
RDMA_CAPABLE (for details see ref [MS-SMB2] 3.3.5.15.11) Only upon
seeing the capability flag would a client attempt to initiate a RDMA
connection.

Reference: [MS-SMB2](https://winprotocoldoc.z19.web.core.windows.net/MS-SMB=
2/%5bMS-SMB2%5d.pdf)

TLDR is that the SMB protocol requires the server to enumerate all
net_devices and indicate their RDMA capability, and
ksmbd_rdma_capable_netdev() is only used in that process. Given such
context, I wonder what should be the best way to approach this? Is
using ARPHRD_INFINIBAND good enough and acceptable in terms of
layering?

> >
> > Thanks!
> >>
> >> I am uncertain about how to proceed at this point and would like to
> >> know your thoughts and opinions on this.
> >>
> >> Thanks,
> >> Kangjing
> >>
> >> On Fri, Nov 8, 2024 at 5:59=E2=80=AFPM Leon Romanovsky <leon@kernel.or=
g> wrote:
> >> >
> >> > On Fri, Nov 08, 2024 at 08:40:40AM +0900, Namjae Jeon wrote:
> >> > > On Thu, Nov 7, 2024 at 9:00=E2=80=AFPM Halil Pasic <pasic@linux.ib=
m.com> wrote:
> >> > > >
> >> > > > On Wed, 6 Nov 2024 15:59:10 +0200
> >> > > > Leon Romanovsky <leon@kernel.org> wrote:
> >> > > >
> >> > > > > > Does  fs/smb/server/transport_rdma.c qualify as inside of RD=
MA core code?
> >> > > > >
> >> > > > > RDMA core code is drivers/infiniband/core/*.
> >> > > >
> >> > > > Understood. So this is a violation of the no direct access to th=
e
> >> > > > callbacks rule.
> >> > > >
> >> > > > >
> >> > > > > > I would guess it is not, and I would not actually mind sendi=
ng a patch
> >> > > > > > but I have trouble figuring out the logic behind  commit ecc=
e70cf17d9
> >> > > > > > ("ksmbd: fix missing RDMA-capable flag for IPoIB device in
> >> > > > > > ksmbd_rdma_capable_netdev()").
> >> > > > >
> >> > > > > It is strange version of RDMA-CM. All other ULPs use RDMA-CM t=
o avoid
> >> > > > > GID, netdev and fabric complexity.
> >> > > >
> >> > > > I'm not familiar enough with either of the subsystems. Based on =
your
> >> > > > answer my guess is that it ain't outright bugous but still a lay=
ering
> >> > > > violation. Copying linux-cifs@vger.kernel.org so that
> >> > > > the smb are aware.
> >> > > Could you please elaborate what the violation is ?
> >> >
> >> > There are many, but the most screaming is that ksmbd has logic to
> >> > differentiate IPoIB devices. These devices are pure netdev devices
> >> > and should be treated like that. ULPs should treat them exactly
> >> > as they treat netdev devices.
> >> >
> >> > > I would also appreciate it if you could suggest to me how to fix t=
his.
> >> > >
> >> > > Thanks.
> >> > > >
> >> > > > Thank you very much for all the explanations!
> >> > > >
> >> > > > Regards,
> >> > > > Halil
> >> > > >
> >>
> >>
> >>
> >> --
> >> Kangjing "Chaser" Huang



--
Kangjing "Chaser" Huang
