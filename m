Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507A213CF82
	for <linux-cifs@vger.kernel.org>; Sat, 14 Dec 2024 06:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734156395; cv=none; b=s43camnnyFBX1XP8Mw3b+Hn0UzzfwAcIluU8lpSe6jem5kJ9VazW+Voo1FpdECRtQ1LxCSgTHDHGX1RsAOl3dx4+5CVycN3uLEplS7pkEHWy8TjEROympKRePzYVnUVbUmo3k9L0DqZ3EAs0ZWYRmVMJkVU5s5ChWprXKsO6Bpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734156395; c=relaxed/simple;
	bh=1HUS2P90SdOed6IMXX2NLPMvgTK50IOTGS/TeVsC00M=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=N9L+UQyGLmkOlrg3A1AYPN+wUa01BV4BnrK0VAAc3gsBGuGQw8xuysdp/6tfkAgcHtBwZjgp126dFJaw5eW0YfqyxWqUvmNadQHr33nGYyx8fHEMxUw9kfomWvOWfMN5psMpR+ZDh0vSPu70HHcM+GKUcGu1q7h3JBnd24l/BTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/9T0IQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/9T0IQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C2CC4CED4
	for <linux-cifs@vger.kernel.org>; Sat, 14 Dec 2024 06:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734156394;
	bh=1HUS2P90SdOed6IMXX2NLPMvgTK50IOTGS/TeVsC00M=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Q/9T0IQcORLbq2KzxwG+LF/GWEEVxhKaAk00j+90x9B3tErofIvuQKoyta62ZCAf/
	 Jzo6YlkNT+/FBamaDD02HcY1XnxQc3pysMUBLJYI8sjMe5lSV6g5SzwpoVJlsXEq14
	 Xal827xJ8mLcSJ9KEbZD86WgJOAeSj5Xmm7eVRYqAI8pUkI4k7nkKZV7FmF5OkXSEY
	 ytCyV4uK7kSMpJoHqFc5bOQ8W4uYrIAor6N2z9SORJjpUnEPl0q46/K6LDjooP9ktU
	 wzk1EALBJcNHdac1NJL9P3RfcBNaAzGQbn2t9cvcExfEX81ek3CYKsxiLIBCTuT+ZC
	 k0YasR8TLWbXg==
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id A57381200043;
	Sat, 14 Dec 2024 01:06:33 -0500 (EST)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-03.internal (MEProxy); Sat, 14 Dec 2024 01:06:33 -0500
X-ME-Sender: <xms:aSBdZwZFAJaDLXoHUln7v_wq4mUfA82os0Gu41QWj_OkG9BG7klJfw>
    <xme:aSBdZ7bjnjk3SIswDyHOVectIykTcBooz49YabcnZvXcXz09FSzhDlKjPEHNb8ztN
    bC5caybl1xB3_ZlVPU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkeekgdeltdcutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:aSBdZ6_QZAAR226658Rpzn229j9mnterXmNrsrXjoAJwD4uRVEGBjg>
    <xmx:aSBdZ6qAoSZ1DQMLEuMIQiHg2vRm8AiiK6_fSUNvw8R0xJwu253pIw>
    <xmx:aSBdZ7pIWNEaWDTHfpCFd-iPlv188WKhoNrmKNFfdxG-9Gc1tOAjmA>
    <xmx:aSBdZ4SvTExG3wCTQDPQVokjuIeThjliE3MZRRntjrdpNiI7jfIK_w>
    <xmx:aSBdZ7rkpBpR22WHa0A9eivivurH1J7o133J2ofhPVDiiG9mmVK7CAL0>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7C7FC1C20066; Sat, 14 Dec 2024 01:06:33 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 14 Dec 2024 08:06:02 +0200
From: "Leon Romanovsky" <leon@kernel.org>
To: "Namjae Jeon" <linkinjeon@kernel.org>,
 "Kangjing Huang" <huangkangjing@gmail.com>
Cc: linux-cifs@vger.kernel.org
Message-Id: <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com>
In-Reply-To: 
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
References: <20241025072356.56093-1-wenjia@linux.ibm.com>
 <20241027201857.GA1615717@unreal>
 <8d17b403-aefa-4f36-a913-7ace41cf2551@linux.ibm.com>
 <20241105112313.GE311159@unreal>
 <20241106102439.4ca5effc.pasic@linux.ibm.com> <20241106135910.GF5006@unreal>
 <20241107125643.04f97394.pasic@linux.ibm.com>
 <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal>
 <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using ib_device_get_netdev()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Sat, Dec 14, 2024, at 04:33, Namjae Jeon wrote:
> On Fri, Dec 13, 2024 at 8:07=E2=80=AFPM Kangjing Huang <huangkangjing@=
gmail.com> wrote:
>>
>> Hi there,
>>
>> I am the original author of commit ecce70cf17d9 ("ksmbd: fix missing
>> RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"),
>> as mentioned in the thread.
>>
>> I am working on modifying the patch to take care of the layering
>> violation. The original patch was meant to fix an issue with ksmbd,
>> where an IPoIB netdev was not recognized as RDMA-capable. The original
>> version of the capability evaluation tries to match each netdev to
>> ib_device by calling get_netdev in ib verbs. However this only works
>> in cases where the ib_device is the upper layer of netdev (e.g. RoCE),
>> and since with IPoIB it is the other way around (netdev is the upper
>> layer of ib_device), get_netdev won't work anymore.
>>
>> I tried to replicate the behavior of device matching reversely in the
>> original version of my patch using GID, which ended up as the layering
>> violation. However I am unaware of any exported functions from the
>> IPoIB driver that could do the reverse lookup from netdev to the lower
>> layer ib_device. Actually it seems that the IPoIB driver does not have
>> any exported symbols at all.
>>
>> It might be that the device matching in reverse just does not make any
>> sense and does not need to be done at all. As long as it is an IPoIB
>> device (netdev->type =3D=3D ARPHRD_INFINIBAND) it might be ok to just
>> automatically assume it is RDMA-capable. I am not 100% sure about this
>> though.
> Why can't we assume RDMA-capable if it's ARPHRD_INFINIBAND type?
> How about assuming it's RDMA-capable and allowing users to turn
> RDMA-capable on/off via sysfs?

Any attempt to treat ipoib differently from regular netdevice is wrong b=
y definition.

>
> Thanks!
>>
>> I am uncertain about how to proceed at this point and would like to
>> know your thoughts and opinions on this.
>>
>> Thanks,
>> Kangjing
>>
>> On Fri, Nov 8, 2024 at 5:59=E2=80=AFPM Leon Romanovsky <leon@kernel.o=
rg> wrote:
>> >
>> > On Fri, Nov 08, 2024 at 08:40:40AM +0900, Namjae Jeon wrote:
>> > > On Thu, Nov 7, 2024 at 9:00=E2=80=AFPM Halil Pasic <pasic@linux.i=
bm.com> wrote:
>> > > >
>> > > > On Wed, 6 Nov 2024 15:59:10 +0200
>> > > > Leon Romanovsky <leon@kernel.org> wrote:
>> > > >
>> > > > > > Does  fs/smb/server/transport_rdma.c qualify as inside of R=
DMA core code?
>> > > > >
>> > > > > RDMA core code is drivers/infiniband/core/*.
>> > > >
>> > > > Understood. So this is a violation of the no direct access to t=
he
>> > > > callbacks rule.
>> > > >
>> > > > >
>> > > > > > I would guess it is not, and I would not actually mind send=
ing a patch
>> > > > > > but I have trouble figuring out the logic behind  commit ec=
ce70cf17d9
>> > > > > > ("ksmbd: fix missing RDMA-capable flag for IPoIB device in
>> > > > > > ksmbd_rdma_capable_netdev()").
>> > > > >
>> > > > > It is strange version of RDMA-CM. All other ULPs use RDMA-CM =
to avoid
>> > > > > GID, netdev and fabric complexity.
>> > > >
>> > > > I'm not familiar enough with either of the subsystems. Based on=
 your
>> > > > answer my guess is that it ain't outright bugous but still a la=
yering
>> > > > violation. Copying linux-cifs@vger.kernel.org so that
>> > > > the smb are aware.
>> > > Could you please elaborate what the violation is ?
>> >
>> > There are many, but the most screaming is that ksmbd has logic to
>> > differentiate IPoIB devices. These devices are pure netdev devices
>> > and should be treated like that. ULPs should treat them exactly
>> > as they treat netdev devices.
>> >
>> > > I would also appreciate it if you could suggest to me how to fix =
this.
>> > >
>> > > Thanks.
>> > > >
>> > > > Thank you very much for all the explanations!
>> > > >
>> > > > Regards,
>> > > > Halil
>> > > >
>>
>>
>>
>> --
>> Kangjing "Chaser" Huang
