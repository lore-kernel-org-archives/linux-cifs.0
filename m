Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194602DE709
	for <linux-cifs@vger.kernel.org>; Fri,  6 Mar 2026 23:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772839169; cv=none; b=E+hBwUMnONhHr47uIaHKUfe7RM76FFeNxhVC4k2xeRqax9QJLKs2uwketkuNCpUWiEA8I0J04E7kjndOoJkydSJwrg8sL+pvfz+TkAtpwq0dGLsGdVpsJCiaUs4p3l3d+fhyZiANt1C2U3iq8SpSC7zKX9N/9F09K/kuf81Yub8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772839169; c=relaxed/simple;
	bh=YAYoD0H7a954Aykburfksmvuv3y9e9Ggddb3vpcDPWY=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Co7gPwRp85xbxPlZ5GOHVwYwvqEVg9DzDmRv3HdLbWcH93QXRBotHQf3bjUb1Wkjx63nXlCkHv9fUEcrixo4MJVDbI0Gx25sI7vcy1N5fXE9pt5+b9tLpcUWmmkj6BjhIdBQXw948vuMJ1MPRJFgyXoxeoVEri8HPWU5kcD3Ywg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=2BNa2CRf; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="2BNa2CRf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=gBERHn+tGmhGvR2Af8y+Rukm5eKH98W/EJ+FBdQWUq8=; b=2BNa2CRfO2i9oP91/juq2A2FFf
	WlPmOA5FURpna7N7l23EJqPEZPRuBiFFS6fj2ox+yUpit+WxvK/sIi89HPWAFxFu+BXPo/j+fkjGK
	oNcLIV0DemJ49+xYW73AzJjLyO8gLGOV3vLupBIpzrbU0IF+sVxKRXW0aSknjACMyLhVorK4aTmaB
	n/OQVA4VUZ7CpRcvbgFtGPUzF/zbRetdP2oWNiWpqrTQdp0nblIuHAVjuo2PdpTW8GP9ok700+4tb
	WpYa+++AnedugexwyPlT9BvRTaVLLe2UBszcCWUf5J4KieY8PrWoozK2xzk/2PI82Hg5/B9lJrY+0
	XgEd8oJw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vyeS3-00000000PLS-0Pxz;
	Fri, 06 Mar 2026 20:19:23 -0300
Message-ID: <9ef8fa889e302e58846ca6d33957077f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Steve French <smfrench@gmail.com>, Henrique Carvalho
 <henrique.carvalho@suse.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, linux-cifs@vger.kernel.org,
 bharathsm@microsoft.com, dhowells@redhat.com, Shyam Prasad N
 <sprasad@microsoft.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
In-Reply-To: <CAH2r5mt4mDP+o4FWcJLhiXxcnjou7jxzPzUv1RqvmJxb=OSh6A@mail.gmail.com>
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <CANT5p=rk44fGgUL_Swp1pbVUeE80GJS4hxF00U0X4_xUbb-7hw@mail.gmail.com>
 <4rrxsl6mx3lbpt32l4ly6psg3ni5nsfzgfiufzt4xecsbjh22o@z272atyrzzvh>
 <CAH2r5mt4mDP+o4FWcJLhiXxcnjou7jxzPzUv1RqvmJxb=OSh6A@mail.gmail.com>
Date: Fri, 06 Mar 2026 20:19:22 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Steve French <smfrench@gmail.com> writes:

> On Fri, Mar 6, 2026 at 4:45=E2=80=AFPM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
>>
>> On Wed, Mar 04, 2026 at 06:04:05PM +0530, Shyam Prasad N wrote: > On Wed=
, Mar 4, 2026 at 5:59=E2=80=AFPM <nspmangalore@gmail.com> wrote: From: Shya=
m Prasad N <sprasad@microsoft.com>
>> >
>> > A proof-of-concept based on this draft from Bharath.
>> > Looking for comments on how to improve.
>>
>> Looks good.
>>
>> Just one minor thing for now. To me the cifs.ko module version doesn't
>> say much as it seems to be not reliable (apologies if I'm mistaken).
>
> It does get incremented every 10 weeks.
>
>> Also, the same version could have different implementations in different
>> distributions. modinfo -F srcversion cifs is a better way to
>> differentiate cifs versions but not to compare versions. So the solution
>> is either remove this or bump it in every change using X.Y.Z.
>
> We do bump the module version every kernel release, e.g. we are at
> 2.59 in Linux 7.0 (7.0-rc2)
> Would bump it when someone does a 'full backport' of most cifs fixes
> to an earlier kernel.

Who?

>> Further, have you thought about how the client can use this in its favor
>> other than diagnosing/debugging a faulty server?
>
> I thought this was for the reverse - so the server support team can
> get metrics on whether the client is an old client with known bugs

The client version is entirely pointless, especially for distribution
kernels.  The support team can't figure out by just looking at the
client version as the backports are what really matter in terms of a
distro kernel.  Most distro kernels don't even bother backporting those
commits that bump the client version, which makes it even more
inaccurate.

>> I think we need to be clear on what is allowed here, to me it seems
>> quirks, workarounds and perf tuning? Maybe this can be used to improve
>> interaction between linux client and linux server?
>
> presumably primarily for customer support to be able to recognise
> known client problems on clients accessing a server

Neither the client or kernel version will tell you _exactly_ where the
problem is in distro kernels.
