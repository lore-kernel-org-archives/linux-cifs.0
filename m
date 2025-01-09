Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EAD1714D7
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jan 2025 07:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736409588; cv=none; b=teeCxOmiup9qoJrJHpRfnMCYzTYj9qayOnTzQtiD0YFTMlqglgIru+yowZ69cwqGtrWzbTGqTHokCEoTkAyP2DBcQA8i08+zBkLrV9HHfd8+90dWlARpTpVSWooLxrnS7jlJKjhV+S3zEwX7bvlQ3VEioAvvlNxs46Q8ygRCZRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736409588; c=relaxed/simple;
	bh=X8p6RGeUBff57k1SjWXdYPT5b5n8G221hEvj5eRT56M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1vTH4mjyOdwlyNg7/uYp/2WBFlOi+xee1Cb6/00/hpJ513cDGJgrGSkcviz9yvrQ3yPXgUrw4qqUGO+ouXzLG5QqvbObuCdEkiSJDQPRWVi3Al+woP8ywYmV6cZsSHnNba3L4/TgZ4QC+BeLVCoqcd39e3RfYwwtJp+fOeYctg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQhWmn2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQhWmn2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE69C4CED2;
	Thu,  9 Jan 2025 07:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736409587;
	bh=X8p6RGeUBff57k1SjWXdYPT5b5n8G221hEvj5eRT56M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gQhWmn2ZhgVIS6q+6Bxo/mhAAMI5szAcqPrBAnTpa0Qw6qZ72wY+7rlijScq7zmnM
	 +xwpdHRD5ov8B/b+vIQ1hCvicBVpK7qobVLxYnnBna9vhApqLPw8Keudn5zbGh07Z+
	 FBzyEnhc04Ql0JAUmEDLXONuR9ZM0jSJFAbGM/qxxRivsrU1I9Q57D5fgZjr/mTZ4A
	 5AjHcRxJsmR2OKYFNwPAYAkpvjSAAZ5/VO2I58WbGwH6Jd5QwV43m+VgidyYTMRwET
	 HTMoQ38nbocdMYZB1piGtHmZuImEfUjs9X+UHvhAwnL6rwrwSXTSN1kXm6G5L7KXA3
	 Ro3WnrHLkchlg==
Date: Thu, 9 Jan 2025 09:59:42 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Kangjing Huang <huangkangjing@gmail.com>
Cc: Tom Talpey <tom@talpey.com>, Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using
 ib_device_get_netdev()
Message-ID: <20250109075942.GH87447@unreal>
References: <20241108175906.GB189042@unreal>
 <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
 <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com>
 <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
 <20241219165616.GF82731@unreal>
 <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
 <20250108093126.GF87447@unreal>
 <55aeae3b-826b-4414-936c-26158792aecf@talpey.com>
 <CAPbmFQb9VAt7cw5JUPKLaGwA4L8mUMegokYs5AVyj+wRhkxyiw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPbmFQb9VAt7cw5JUPKLaGwA4L8mUMegokYs5AVyj+wRhkxyiw@mail.gmail.com>

On Wed, Jan 08, 2025 at 10:40:22PM +0000, Kangjing Huang wrote:
> On Wed, Jan 8, 2025 at 5:27 PM Tom Talpey <tom@talpey.com> wrote:
> >
> > On 1/8/2025 4:31 AM, Leon Romanovsky wrote:
> > > On Tue, Jan 07, 2025 at 10:51:19PM +0000, Kangjing Huang wrote:
> > >> On Thu, Dec 19, 2024 at 4:56 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >>>
> > >>> On Sat, Dec 14, 2024 at 08:02:14AM +0000, Kangjing Huang wrote:
> > >>>> On Sat, Dec 14, 2024 at 1:06 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >>>>>
> > >>>>>
> > >>>>>
> > >>>>> On Sat, Dec 14, 2024, at 04:33, Namjae Jeon wrote:
> > >>>>>> On Fri, Dec 13, 2024 at 8:07 PM Kangjing Huang <huangkangjing@gmail.com> wrote:
> > >>>>>>>
> > >>>>>>> Hi there,
> > >>>>>>>
> > >>>>>>> I am the original author of commit ecce70cf17d9 ("ksmbd: fix missing
> > >>>>>>> RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"),
> > >>>>>>> as mentioned in the thread.
> > >>>>>>>
> > >>>>>>> I am working on modifying the patch to take care of the layering
> > >>>>>>> violation. The original patch was meant to fix an issue with ksmbd,
> > >>>>>>> where an IPoIB netdev was not recognized as RDMA-capable. The original
> > >>>>>>> version of the capability evaluation tries to match each netdev to
> > >>>>>>> ib_device by calling get_netdev in ib verbs. However this only works
> > >>>>>>> in cases where the ib_device is the upper layer of netdev (e.g. RoCE),
> > >>>>>>> and since with IPoIB it is the other way around (netdev is the upper
> > >>>>>>> layer of ib_device), get_netdev won't work anymore.
> > >>>>>>>
> > >>>>>>> I tried to replicate the behavior of device matching reversely in the
> > >>>>>>> original version of my patch using GID, which ended up as the layering
> > >>>>>>> violation. However I am unaware of any exported functions from the
> > >>>>>>> IPoIB driver that could do the reverse lookup from netdev to the lower
> > >>>>>>> layer ib_device. Actually it seems that the IPoIB driver does not have
> > >>>>>>> any exported symbols at all.
> > >>>>>>>
> > >>>>>>> It might be that the device matching in reverse just does not make any
> > >>>>>>> sense and does not need to be done at all. As long as it is an IPoIB
> > >>>>>>> device (netdev->type == ARPHRD_INFINIBAND) it might be ok to just
> > >>>>>>> automatically assume it is RDMA-capable. I am not 100% sure about this
> > >>>>>>> though.
> > >>>>>> Why can't we assume RDMA-capable if it's ARPHRD_INFINIBAND type?
> > >>>>>> How about assuming it's RDMA-capable and allowing users to turn
> > >>>>>> RDMA-capable on/off via sysfs?
> > >>>> It does make more sense to me at this point to just broadly assume all
> > >>>> ARPHRD_INFINIBAND types to be RDMA-capable, we just need to make sure
> > >>>> this assumption indeed holds and figure out to what extent this could
> > >>>> involve the same layering violation.
> > >>>>
> > >>>>>
> > >>>>> Any attempt to treat ipoib differently from regular netdevice is wrong by definition.
> > >>>>>
> > >>>> I would agree that the design direction to treat ipoib as a pure
> > >>>> regular net_device is the good way to go. But the problem with ksmbd
> > >>>> and ipoib devices stems from the SMB protocol itself.
> > >>>>
> > >>>> In contrast to protocols that focus on certain functionalities like
> > >>>> nfs, SMB actually tries to manage network interfaces actively in the
> > >>>> protocol itself: SMB protocol's RDMA support (dubbed SMB Direct) is a
> > >>>> sub-feature of SMB Multichannel. Multichannel is designed to let
> > >>>> client and server find multiple data paths automatically (imagine a
> > >>>> pair of hosts with multiple adapters connected by multiple cables) to
> > >>>> increase bandwidth. So client can initiate a
> > >>>> FSCTL_QUERY_NETWORK_INTERFACE_INFO request and server is expected to
> > >>>> respond with NETWORK_INTERFACE_INFO containing _all_ local network
> > >>>> interface informations, including their capabilities such as
> > >>>> RDMA_CAPABLE (for details see ref [MS-SMB2] 3.3.5.15.11) Only upon
> > >>>> seeing the capability flag would a client attempt to initiate a RDMA
> > >>>> connection.
> > >>>>
> > >>>> Reference: [MS-SMB2](https://winprotocoldoc.z19.web.core.windows.net/MS-SMB2/%5bMS-SMB2%5d.pdf)
> > >>>>
> > >>>> TLDR is that the SMB protocol requires the server to enumerate all
> > >>>> net_devices and indicate their RDMA capability, and
> > >>>> ksmbd_rdma_capable_netdev() is only used in that process. Given such
> > >>>> context, I wonder what should be the best way to approach this? Is
> > >>>> using ARPHRD_INFINIBAND good enough and acceptable in terms of
> > >>>> layering?
> > >>>
> > >>
> > >>> The thing is that ARPHRD_INFINIBAND indeed represent IPoIB and it is
> > >>> right check if netdev is IPoIB or not. The layering problem is that
> > >>> upper layers (ULPs) should use it as regular netdevice.
> > >>
> > >> This is good to know. However, since the SMB protocol explicitly calls
> > >> for enumeration of all network interfaces on the server host,
> > >> including their RDMA capabilities, I believe this is a sensible
> > >> exception to the layering rule. Or is there anyway else to do this
> > >> enumeration from the kernel space?
> > >>
> > >> Or we can give up implementing the full spec of the SMB protocol and
> > >> call for explicit configuration from user space on how to respond to
> > >> the IOCTL requests in question. Which one looks more sensible to you?
> > >
> > > My preference is to have same IPoIB treatment for all ULPs, including SMB.
> 
> If that is the case, then we don't really have many options left but
> to expose the advertisement of rdma-capable flags as a configurable
> option from the user space (maybe via sysfs). I am not sure if this
> will allow the user to mark an interface as RDMA-capable despite its
> incapability, or would the capability check be allowed to be made from
> the configuration validation site?

Except SMB spec, why do you need to provide "RDMA-capable" information?
Is it must? What will it give to the users? Why can't you treat IPoIB
like any other netdevice?

> 
> > >
> > > My GUESS is that SMB specification authors didn't take into account HW and
> > > Linux SW development around IPoIB and weren't aware of IPoIB offload which
> > > is implemented and enabled by default in all modern IB NICs and Linux OSes.
> >
> > The SMB3 specification is completely unconcerned with IPoIB and any
> > other layer-2 or layer-3 implementation details. It merely discusses
> > an exchange of network interface capabilities such as link speed and
> > RDMA support. The SMB3 client uses this list to implement multichannel.
> >
> > I totally agree that inspecting ARPHRD_INFINIBAND is an incorrect method
> > of building this list. Just because an interface supports IPoIB does not
> > mean it also exposes RDMA, especially in-kernel. And that ignores any
> > non-IB transport too of course.
> 
> I see, so if I understand this argument correctly, the point is that
> even if an IPoIB device *is* guaranteed to have some RDMA support in
> the stack (since IPoIB is ULP of an IB device, which always supports
> RDMA), it does not necessarily want to expose that capability to its
> own ULP in the stacks above, right? However if this is the case, then
> what would be the correct way to determine the capability flag from a
> ULP?

Let's start with an answer to more simple question: "why do you need
this capability flag?"

> 
> >
> > Kangjing, please educate me if I'm confused here, but doesn't the
> > code in ksmbd_rdma_capable_netdev() look up the ib_device anyway, at
> > the end of the function?
> >
> > >       if (rdma_capable == false) {
> > >               struct ib_device *ibdev;
> > >
> > >               ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
> > >               if (ibdev) {
> > >                       if (rdma_frwr_is_supported(&ibdev->attrs))
> > >                               rdma_capable = true;
> > >                       ib_device_put(ibdev);
> > >               }
> > >       }
> > >
> > >       return rdma_capable;
> >
> > So, why is the code concerned at all with ARPHRD_INFINIBAND just a few
> > lines above?
> 
> This check does not work with IPoIB devices. For IPoIB devices
> ib_device_get_by_netdev would just return null.
> 
> Correct me if I am wrong but I think this API is intended to work with
> RDMA/IB transport as ULP of a normal netdev transport (e.g. RoCE,
> iWARP). It essentially only performs a lookup of the devices up the
> stack, not down the stack, thus not working for IPoIB devices. I feel
> this is somehow intended as well since it works inline with the
> principle that IPoIB devices should just be treated like a normal
> netdev.
> 
> This is probably true for the get_netdev verb on ib_device, and the
> ib_device_get_netdev API, they are just performing the lookup in
> reverse direction.

Yes, ib_device_get_by_netdev and get_netdev are intended to perform
lookup of ib device based on underlying netdev, but in IPoIB case you
are interested in ib device based on upper netdev.

So this leads to another question, if user didn't ask to connect SMB to
IB device and chose netdevice (IPoIB) instead, why are you still forcing
him to take IB path? If it is not user's decision and you are choosing
devices from the list, you already have in your list the IB device which
is connected to IPoIB.

Thanks
