Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57183D974;
	Wed, 21 Feb 2024 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708513775; cv=none; b=jyENHPwfSDETieIgDd9edBh3OoqlfDzMWP3cGw2DZRidag9M5CgOjDz4K6t0/tV77rdKm9hpXvut61HseCBjeLpFeMAImpDhDD7LurO/a4i2u4wQtsqwXrSiqs1hOwHB3cetlKaXWH472Q8HDOXg7y4CPip9ZzCXKpv0nd1koog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708513775; c=relaxed/simple;
	bh=l36lmROJDFuaUSlP+aiyXsQa6pysXONN+AvGtdZsAxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=awXvZyGBYs4gfexIR9Xkccqp99mrLh7PScFcrbqrUVbQdsUERpK10QKA4+6sQf3bjslEgKkENJO6gDq49P90pdzfwZRurWpDG1o3PkvCTth/EmNDvFLt5svtrfqu7nhZxdjKl39vkoUSfKlLXf5bV3P02THCvxxobHK4gFeBYaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUAHlgOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUAHlgOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01B3C433F1;
	Wed, 21 Feb 2024 11:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708513773;
	bh=l36lmROJDFuaUSlP+aiyXsQa6pysXONN+AvGtdZsAxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nUAHlgOOL62EKreVx2YYstTfj2GkRXUN24dGs0LXm4y6N+Rd5l1OrpV8JGvhU+y3m
	 ZqhxOjNocAmnf2WQMdLGqAavWrHAY836jf9RneqsPo+WS1htEvDbL/i3TGghLhLg2D
	 JHvjyLFcICdi5JLtCBYSEmlSm1MBOPUZkadio6Mk=
Date: Wed, 21 Feb 2024 12:09:30 +0100
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: kovalev@altlinux.org, Salvatore Bonaccorso <carnil@debian.org>,
	"Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
	Paulo Alcantara <pc@manguebit.com>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>,
	"sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Steve French <smfrench@gmail.com>,
	Darren Kenny <darren.kenny@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <2024022108-polo-storeroom-5c04@gregkh>
References: <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
 <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
 <ZbnpDbgV7ZCRy3TT@eldamar.lan>
 <848c0723a10638fcf293514fab8cfa2e@manguebit.com>
 <3bfc7bc4-05cd-4353-8fca-a391d6cb9bf4@amazon.com>
 <Zb5eL-AKcZpmvYSl@eldamar.lan>
 <61fde07c-f767-42b0-9bfa-ef915b28fb77@oracle.com>
 <2024022011-afraid-automated-4677@gregkh>
 <eb90696f-58db-4b28-a75a-7388c1e16a54@oracle.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb90696f-58db-4b28-a75a-7388c1e16a54@oracle.com>

On Wed, Feb 21, 2024 at 07:56:01AM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 21/02/24 01:58, gregkh@linuxfoundation.org wrote:
> > On Tue, Feb 06, 2024 at 01:16:01PM +0530, Harshit Mogalapalli wrote:
> > > Hi Salvatore,
> > > 
> > > Adding kovalev here(who backported it to 5.10.y)
> > > 
> > > On 03/02/24 9:09 pm, Salvatore Bonaccorso wrote:
> > > > Hi,
> > > > 
> > > > On Thu, Feb 01, 2024 at 12:58:28PM +0000, Mohamed Abuelfotoh, Hazem wrote:
> > > > > 
> > > > > On 31/01/2024 17:19, Paulo Alcantara wrote:
> > > > > > Greg, could you please drop
> > > > > > 
> > > > > >            b3632baa5045 ("cifs: fix off-by-one in SMB2_query_info_init()")
> > > > > > 
> > > > > > from v5.10.y as suggested by Salvatore?
> > > > > > 
> > > > > > Thanks.
> > > > > 
> > > > > Are we dropping b3632baa5045 ("cifs: fix off-by-one in
> > > > > SMB2_query_info_init()") from v5.10.y while keeping it on v5.15.y? if we are
> > > > > dropping it from v5.15.y as well then we should backport 06aa6eff7b smb3:
> > > > > Replace smb2pdu 1-element arrays with flex-arrays to v5.15.y I remember
> > > > > trying to backport this patch on v5.15.y but there were some merge conflicts
> > > > > there.
> > > > > 
> > > > > 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays
> > > > 
> > > > While I'm not eligible to say what should be done, my understading is
> > > > that Greg probably would prefer to have the "backport 06aa6eff7b"
> > > > version. What we know is that having now both commits in the
> > > > stable-rc/linux-5.10.y queue breaks  cifs and the backport variants
> > > > seens to work fine (Paulo Alcantara probably though can comment best).
> > > > 
> > > Having both one-liner fix that I have sent and the above commit isn't
> > > correct.
> > > 
> > > > As 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays
> > > > was backportable to 5.10.y it should now work as well for the upper
> > > > one 5.15.y.
> > > 
> > > Correct, I agree. I had to send one-liner fix as we have the
> > > backport("06aa6eff7b smb3: Replace smb2pdu 1-element arrays with
> > > flex-arrays") missing in 5.15.y and when I tried backporting it to 5.15.y I
> > > saw many conflicts.
> > > 
> > > If we have backport for 5.15.y similar to 5.10.y we could ask greg to remove
> > > one liner fix from both 5.10.y and 5.15.y: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/cifs-fix-off-by-one-in-smb2_query_info_init.patch
> > 
> > Someone needs to tell me what to do, as I'm lost.
> > 
> 
> For 5.15.y:
> 
> 1. Remove this patch from the queue:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.15/cifs-fix-off-by-one-in-smb2_query_info_init.patch
> 2. Add this patch(kovalev's backport) to queue:
> https://lore.kernel.org/lkml/20240206161111.454699-1-kovalev@altlinux.org/T/#u

Now done.

> For 5.10.y:
> 
> 1. Remove this patch from the queue:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/cifs-fix-off-by-one-in-smb2_query_info_init.patch
> 
> (kovalev's backport is already in queue[1], so nothing to add here like '2'
> in 5.15.y)

Now done.

Ok, I think we are good.  I'll push out -rc kernels soon for people to
test with.

thanks,

greg k-h
