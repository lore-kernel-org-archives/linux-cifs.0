Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262351C3BF3
	for <linux-cifs@vger.kernel.org>; Fri, 13 Dec 2024 12:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734092131; cv=none; b=noGRt70H/gLoNuG1wo1u+C8lVE6v4h+ct00cf/4JObjKUeyvdBJq432a0V9Ov60hW4x2+BGoqJ82GWs/dPlfe0+hAzNeF4e9QqwKC42VoxBQDHR05IFwjxeJb29AOsZ/X0IjPmt2Xt6mzUY9lcgyBc2lmWaNXr1LhuOG0EYhsSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734092131; c=relaxed/simple;
	bh=UxkjqmX7/jNNu+BoQosntWYEiJJKcJInDyj3dU/txIA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=h1CvMhrKKkQ3JDbpiW8ENQ5aCOCDZAFZCRwvuyx/0QbdPFROJ2lFqWXMNRreLGvN2tA29uxbC+DUywHHH0e60akyVWkIM3M+t3xsR2LHIu4jYY1TR7InySFxY48wGzptz5qgv+tvyMKNSNrZgK3gLCl/WuGWp4DTSIhs1//Oj5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4M1BRuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4M1BRuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0846C4CED4
	for <linux-cifs@vger.kernel.org>; Fri, 13 Dec 2024 12:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734092130;
	bh=UxkjqmX7/jNNu+BoQosntWYEiJJKcJInDyj3dU/txIA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=n4M1BRuocXeW8+Wo4RG1iyuJGdMxXiUKmVazMN8kOhExTxoSZZF7vvRWv+thHJNmN
	 QRoKFq1IEieL+nN6fH/f6FRGW88JauGeJam2bv5hDNzLJsplfrJqVFmqfSpQ1u6m5U
	 v0vJqSL3SI4XMTeygT7Qa7m6rYkWqarwOF1RPZpGCLg/zYq7JBEfV358w8J6wrGr2N
	 JPxyQDvH6qKar6yVkHcVGMFoWR/MI2Ds23QTHflkfKGh2HM0RQKrrG5BvZ/EVvn0yG
	 CM3N1Ls+BuYplfTUsLoazxSS4Jqm/vIiaAjnIe9IMSEZFrqGG9EfhssqJT7c2p/53j
	 aG/Zqw7ysdLzQ==
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 952371200043;
	Fri, 13 Dec 2024 07:15:29 -0500 (EST)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-03.internal (MEProxy); Fri, 13 Dec 2024 07:15:29 -0500
X-ME-Sender: <xms:YSVcZ14LIF9HatqNwXFaajw9wwEvOMGdUC1IhSD-BT--zt1EF5mDPQ>
    <xme:YSVcZy5neZGXYW3Ho4ey5JU_g0d-pvsdMoTRy_Cc6AgovoEzjckkI_SWVe4kHC-eI
    0QEh0ihQi7wCYGDlck>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkeejgdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeen
    ucfhrhhomhepfdfnvghonhcutfhomhgrnhhovhhskhihfdcuoehlvghonheskhgvrhhnvg
    hlrdhorhhgqeenucggtffrrghtthgvrhhnpeetgedugfeuleeufefgffevgfelteetkeeg
    hedtlefgffeivefgueetjefhteehgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehlvghonhdomhgvshhmthhprghuthhhphgvrhhsohhnrghl
    ihhthidquddvfedtheefleekgedqvdejjeeljeejvdekqdhlvghonheppehkvghrnhgvlh
    drohhrgheslhgvohhnrdhnuhdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtohephhhurghnghhkrghnghhjihhnghesghhmrghilhdrtghomhdprh
    gtphhtthhopehlihhnkhhinhhjvghonheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqtghifhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:YSVcZ8eaLP0iRlbhNPJfoYBMeDSLkgnmyYkTkqOArujOs8ELuvlOqg>
    <xmx:YSVcZ-IcZGWl7KYxpTFuaZDcBU1hr86My9w6fSDK9f9jzciHPPiPhA>
    <xmx:YSVcZ5IcL_YoOKjeVfCgdjn4FG5HQj5s-5Ekb4NSpLp8O72TuCKhlA>
    <xmx:YSVcZ3zyOJlZgTYvsF6p1ovxd8LhPeZkhj8vOcCffP54y9cbAPawjg>
    <xmx:YSVcZ1I4COxT1sSq5JNDjUJBHgVgg1bXEaorMACuEAuwUNG_Im5bEMF0>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6347C1C20065; Fri, 13 Dec 2024 07:15:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 13 Dec 2024 14:15:09 +0200
From: "Leon Romanovsky" <leon@kernel.org>
To: "Kangjing Huang" <huangkangjing@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Message-Id: <41b8eb22-069b-4670-86ce-cadc545454da@app.fastmail.com>
In-Reply-To: 
 <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
References: <20241025072356.56093-1-wenjia@linux.ibm.com>
 <20241027201857.GA1615717@unreal>
 <8d17b403-aefa-4f36-a913-7ace41cf2551@linux.ibm.com>
 <20241105112313.GE311159@unreal>
 <20241106102439.4ca5effc.pasic@linux.ibm.com> <20241106135910.GF5006@unreal>
 <20241107125643.04f97394.pasic@linux.ibm.com>
 <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal>
 <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using ib_device_get_netdev()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Fri, Dec 13, 2024, at 13:07, Kangjing Huang wrote:
> Hi there,
>
> I am the original author of commit ecce70cf17d9 ("ksmbd: fix missing
> RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"),
> as mentioned in the thread.
>
> I am working on modifying the patch to take care of the layering
> violation. The original patch was meant to fix an issue with ksmbd,
> where an IPoIB netdev was not recognized as RDMA-capable.

This is exactly the purpose and design of IPoIB, to present regular netd=
ev to the users and hide IB layer from them.

> The original
> version of the capability evaluation tries to match each netdev to
> ib_device by calling get_netdev in ib verbs. However this only works
> in cases where the ib_device is the upper layer of netdev (e.g. RoCE),
> and since with IPoIB it is the other way around (netdev is the upper
> layer of ib_device), get_netdev won't work anymore.
>
> I tried to replicate the behavior of device matching reversely in the
> original version of my patch using GID, which ended up as the layering
> violation. However I am unaware of any exported functions from the
> IPoIB driver that could do the reverse lookup from netdev to the lower
> layer ib_device. Actually it seems that the IPoIB driver does not have
> any exported symbols at all.
>
> It might be that the device matching in reverse just does not make any
> sense and does not need to be done at all. As long as it is an IPoIB
> device (netdev->type =3D=3D ARPHRD_INFINIBAND) it might be ok to just
> automatically assume it is RDMA-capable. I am not 100% sure about this
> though.
>
> I am uncertain about how to proceed at this point and would like to
> know your thoughts and opinions on this.

Delete this code completely and make sure that ksmbd has two paths only.=
 One for netdevs and one for ib_devices. It is upto users to decide on w=
hich interface to run.

Thanks=20

>
> Thanks,
> Kangjing
>
> On Fri, Nov 8, 2024 at 5:59=E2=80=AFPM Leon Romanovsky <leon@kernel.or=
g> wrote:
>>
>> On Fri, Nov 08, 2024 at 08:40:40AM +0900, Namjae Jeon wrote:
>> > On Thu, Nov 7, 2024 at 9:00=E2=80=AFPM Halil Pasic <pasic@linux.ibm=
.com> wrote:
>> > >
>> > > On Wed, 6 Nov 2024 15:59:10 +0200
>> > > Leon Romanovsky <leon@kernel.org> wrote:
>> > >
>> > > > > Does  fs/smb/server/transport_rdma.c qualify as inside of RDM=
A core code?
>> > > >
>> > > > RDMA core code is drivers/infiniband/core/*.
>> > >
>> > > Understood. So this is a violation of the no direct access to the
>> > > callbacks rule.
>> > >
>> > > >
>> > > > > I would guess it is not, and I would not actually mind sendin=
g a patch
>> > > > > but I have trouble figuring out the logic behind  commit ecce=
70cf17d9
>> > > > > ("ksmbd: fix missing RDMA-capable flag for IPoIB device in
>> > > > > ksmbd_rdma_capable_netdev()").
>> > > >
>> > > > It is strange version of RDMA-CM. All other ULPs use RDMA-CM to=
 avoid
>> > > > GID, netdev and fabric complexity.
>> > >
>> > > I'm not familiar enough with either of the subsystems. Based on y=
our
>> > > answer my guess is that it ain't outright bugous but still a laye=
ring
>> > > violation. Copying linux-cifs@vger.kernel.org so that
>> > > the smb are aware.
>> > Could you please elaborate what the violation is ?
>>
>> There are many, but the most screaming is that ksmbd has logic to
>> differentiate IPoIB devices. These devices are pure netdev devices
>> and should be treated like that. ULPs should treat them exactly
>> as they treat netdev devices.
>>
>> > I would also appreciate it if you could suggest to me how to fix th=
is.
>> >
>> > Thanks.
>> > >
>> > > Thank you very much for all the explanations!
>> > >
>> > > Regards,
>> > > Halil
>> > >
>
>
>
> --=20
> Kangjing "Chaser" Huang
