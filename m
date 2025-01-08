Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200782594A2
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jan 2025 09:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736328692; cv=none; b=MWuKIPwSxvQULSaPelXeO8V8DGrwx7Q1+ETYVnAU19fHRdDg9lmpUcdsYa4+wsIX+Ld83oe0JM3mbVH2wjEa4XNNs90a7zoc4LEMbvzFdK+DPVc6IZFpPeLhpfwkulcsozhvUWyxCTA7WEOcwNapZnQ+XY8arnNNnk+jTJAaOwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736328692; c=relaxed/simple;
	bh=qpGUnzUG+z885oeONg8VAy5d+w97ojcOsbG/7+cbdJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGsaX93XkJSg3Vvj9YMeVVKpWrDy/jyAeIOsnUFDtiyKTEUUENcJQkhFeBfpoW6CTA80aRCwlEvV5hwRRx94y6B0qcrc/yq8XF591hC5wZBzUiWO2M9NYWfy5PUumvFZsgSuxhiUrSknRIsWrtZdwLNipqcu8JP3fVVsHi5oCoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rg1zaUtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rg1zaUtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FB4C4CEE2;
	Wed,  8 Jan 2025 09:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736328691;
	bh=qpGUnzUG+z885oeONg8VAy5d+w97ojcOsbG/7+cbdJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rg1zaUtOIr26NsvWpVUJadWxRvGzw+Hz1RwSUWK/CF0L84B2xqQrFYsuA7IwF3mpX
	 Oq7Fk0fOMgNomtGuNnlMsoK6Hv/I9u5tjDJXAo7U055EAv3bMu7rSN1e0N2apWK2EK
	 wWogZPQ77aiR3ObIVdo1/1TNGMq4CqNDRdpsbwUdPDWgZ5nkaORneByZ5hMqqpL9Lh
	 WlQ8ss/V3K08R0B7U7kTELZFYZj5nCX/y8tXp+qe2DDNTuF6GtOJSDiR17ULUt1uzj
	 AN9qt//YFuJxkZUBGIIHoGUEfPKOEteCLfLEoTowAtZm0CzjDRYlZL5f13MAAyrO5e
	 jXMS9NdeO91Ag==
Date: Wed, 8 Jan 2025 11:31:26 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Kangjing Huang <huangkangjing@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using
 ib_device_get_netdev()
Message-ID: <20250108093126.GF87447@unreal>
References: <20241106135910.GF5006@unreal>
 <20241107125643.04f97394.pasic@linux.ibm.com>
 <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal>
 <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
 <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com>
 <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
 <20241219165616.GF82731@unreal>
 <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>

On Tue, Jan 07, 2025 at 10:51:19PM +0000, Kangjing Huang wrote:
> On Thu, Dec 19, 2024 at 4:56 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Sat, Dec 14, 2024 at 08:02:14AM +0000, Kangjing Huang wrote:
> > > On Sat, Dec 14, 2024 at 1:06 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > >
> > > >
> > > > On Sat, Dec 14, 2024, at 04:33, Namjae Jeon wrote:
> > > > > On Fri, Dec 13, 2024 at 8:07 PM Kangjing Huang <huangkangjing@gmail.com> wrote:
> > > > >>
> > > > >> Hi there,
> > > > >>
> > > > >> I am the original author of commit ecce70cf17d9 ("ksmbd: fix missing
> > > > >> RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"),
> > > > >> as mentioned in the thread.
> > > > >>
> > > > >> I am working on modifying the patch to take care of the layering
> > > > >> violation. The original patch was meant to fix an issue with ksmbd,
> > > > >> where an IPoIB netdev was not recognized as RDMA-capable. The original
> > > > >> version of the capability evaluation tries to match each netdev to
> > > > >> ib_device by calling get_netdev in ib verbs. However this only works
> > > > >> in cases where the ib_device is the upper layer of netdev (e.g. RoCE),
> > > > >> and since with IPoIB it is the other way around (netdev is the upper
> > > > >> layer of ib_device), get_netdev won't work anymore.
> > > > >>
> > > > >> I tried to replicate the behavior of device matching reversely in the
> > > > >> original version of my patch using GID, which ended up as the layering
> > > > >> violation. However I am unaware of any exported functions from the
> > > > >> IPoIB driver that could do the reverse lookup from netdev to the lower
> > > > >> layer ib_device. Actually it seems that the IPoIB driver does not have
> > > > >> any exported symbols at all.
> > > > >>
> > > > >> It might be that the device matching in reverse just does not make any
> > > > >> sense and does not need to be done at all. As long as it is an IPoIB
> > > > >> device (netdev->type == ARPHRD_INFINIBAND) it might be ok to just
> > > > >> automatically assume it is RDMA-capable. I am not 100% sure about this
> > > > >> though.
> > > > > Why can't we assume RDMA-capable if it's ARPHRD_INFINIBAND type?
> > > > > How about assuming it's RDMA-capable and allowing users to turn
> > > > > RDMA-capable on/off via sysfs?
> > > It does make more sense to me at this point to just broadly assume all
> > > ARPHRD_INFINIBAND types to be RDMA-capable, we just need to make sure
> > > this assumption indeed holds and figure out to what extent this could
> > > involve the same layering violation.
> > >
> > > >
> > > > Any attempt to treat ipoib differently from regular netdevice is wrong by definition.
> > > >
> > > I would agree that the design direction to treat ipoib as a pure
> > > regular net_device is the good way to go. But the problem with ksmbd
> > > and ipoib devices stems from the SMB protocol itself.
> > >
> > > In contrast to protocols that focus on certain functionalities like
> > > nfs, SMB actually tries to manage network interfaces actively in the
> > > protocol itself: SMB protocol's RDMA support (dubbed SMB Direct) is a
> > > sub-feature of SMB Multichannel. Multichannel is designed to let
> > > client and server find multiple data paths automatically (imagine a
> > > pair of hosts with multiple adapters connected by multiple cables) to
> > > increase bandwidth. So client can initiate a
> > > FSCTL_QUERY_NETWORK_INTERFACE_INFO request and server is expected to
> > > respond with NETWORK_INTERFACE_INFO containing _all_ local network
> > > interface informations, including their capabilities such as
> > > RDMA_CAPABLE (for details see ref [MS-SMB2] 3.3.5.15.11) Only upon
> > > seeing the capability flag would a client attempt to initiate a RDMA
> > > connection.
> > >
> > > Reference: [MS-SMB2](https://winprotocoldoc.z19.web.core.windows.net/MS-SMB2/%5bMS-SMB2%5d.pdf)
> > >
> > > TLDR is that the SMB protocol requires the server to enumerate all
> > > net_devices and indicate their RDMA capability, and
> > > ksmbd_rdma_capable_netdev() is only used in that process. Given such
> > > context, I wonder what should be the best way to approach this? Is
> > > using ARPHRD_INFINIBAND good enough and acceptable in terms of
> > > layering?
> >
> 
> > The thing is that ARPHRD_INFINIBAND indeed represent IPoIB and it is
> > right check if netdev is IPoIB or not. The layering problem is that
> > upper layers (ULPs) should use it as regular netdevice.
> 
> This is good to know. However, since the SMB protocol explicitly calls
> for enumeration of all network interfaces on the server host,
> including their RDMA capabilities, I believe this is a sensible
> exception to the layering rule. Or is there anyway else to do this
> enumeration from the kernel space?
> 
> Or we can give up implementing the full spec of the SMB protocol and
> call for explicit configuration from user space on how to respond to
> the IOCTL requests in question. Which one looks more sensible to you?

My preference is to have same IPoIB treatment for all ULPs, including SMB.

My GUESS is that SMB specification authors didn't take into account HW and
Linux SW development around IPoIB and weren't aware of IPoIB offload which
is implemented and enabled by default in all modern IB NICs and Linux OSes.

That offload allows line-rate for IPoIB, something that is not possible
for SW IPoIB.

Thanks

> 
> Thanks
> 
> >
> > Thanks
> >
> > >
> > > > >
> > > > > Thanks!
> > > > >>
> > > > >> I am uncertain about how to proceed at this point and would like to
> > > > >> know your thoughts and opinions on this.
> > > > >>
> > > > >> Thanks,
> > > > >> Kangjing
> > > > >>
> > > > >> On Fri, Nov 8, 2024 at 5:59 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >> >
> > > > >> > On Fri, Nov 08, 2024 at 08:40:40AM +0900, Namjae Jeon wrote:
> > > > >> > > On Thu, Nov 7, 2024 at 9:00 PM Halil Pasic <pasic@linux.ibm.com> wrote:
> > > > >> > > >
> > > > >> > > > On Wed, 6 Nov 2024 15:59:10 +0200
> > > > >> > > > Leon Romanovsky <leon@kernel.org> wrote:
> > > > >> > > >
> > > > >> > > > > > Does  fs/smb/server/transport_rdma.c qualify as inside of RDMA core code?
> > > > >> > > > >
> > > > >> > > > > RDMA core code is drivers/infiniband/core/*.
> > > > >> > > >
> > > > >> > > > Understood. So this is a violation of the no direct access to the
> > > > >> > > > callbacks rule.
> > > > >> > > >
> > > > >> > > > >
> > > > >> > > > > > I would guess it is not, and I would not actually mind sending a patch
> > > > >> > > > > > but I have trouble figuring out the logic behind  commit ecce70cf17d9
> > > > >> > > > > > ("ksmbd: fix missing RDMA-capable flag for IPoIB device in
> > > > >> > > > > > ksmbd_rdma_capable_netdev()").
> > > > >> > > > >
> > > > >> > > > > It is strange version of RDMA-CM. All other ULPs use RDMA-CM to avoid
> > > > >> > > > > GID, netdev and fabric complexity.
> > > > >> > > >
> > > > >> > > > I'm not familiar enough with either of the subsystems. Based on your
> > > > >> > > > answer my guess is that it ain't outright bugous but still a layering
> > > > >> > > > violation. Copying linux-cifs@vger.kernel.org so that
> > > > >> > > > the smb are aware.
> > > > >> > > Could you please elaborate what the violation is ?
> > > > >> >
> > > > >> > There are many, but the most screaming is that ksmbd has logic to
> > > > >> > differentiate IPoIB devices. These devices are pure netdev devices
> > > > >> > and should be treated like that. ULPs should treat them exactly
> > > > >> > as they treat netdev devices.
> > > > >> >
> > > > >> > > I would also appreciate it if you could suggest to me how to fix this.
> > > > >> > >
> > > > >> > > Thanks.
> > > > >> > > >
> > > > >> > > > Thank you very much for all the explanations!
> > > > >> > > >
> > > > >> > > > Regards,
> > > > >> > > > Halil
> > > > >> > > >
> > > > >>
> > > > >>
> > > > >>
> > > > >> --
> > > > >> Kangjing "Chaser" Huang
> > >
> > >
> > >
> > > --
> > > Kangjing "Chaser" Huang
> 
> 
> 
> -- 
> Kangjing "Chaser" Huang
