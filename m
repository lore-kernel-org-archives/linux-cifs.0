Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E18137C41;
	Tue, 20 Feb 2024 20:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708460910; cv=none; b=OX6IxapixEfOGJa2oIqkdwQdihgdVE+gnd1zzppHgQ+I2Pg8UTCuG2kSoMdvmW0rFU9aCzy3Yck7dMi0vBwnFTpA4rwN9ZDkhCVxUWkHBjHWMMNkbCeP/5MeXxP1nluUe8ZzRP5Ddlq/E15pWqaGOcHlcwrpl4B4zrN73XnBRCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708460910; c=relaxed/simple;
	bh=g+D4cvKzhs0LhZmRUQl/Jfd1eyNmCdF/RY/cMzTHw4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3NW5ywy1YYfG5LIxDZZAJQcgE7myrGoS1lAbx6q1binJkE+LV2SvhzWhBx2d2OLG5FCwgEG2ZlIzks6/xrq73uK+/47p1/rELjGMJpLQ9oNHYMGwEbxPjtEluUpqW8awcaW0Ro8A11j8wxaHxjL95qmEmEhYdlugpmK72WRJ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koOnALTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koOnALTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F6FC433C7;
	Tue, 20 Feb 2024 20:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708460909;
	bh=g+D4cvKzhs0LhZmRUQl/Jfd1eyNmCdF/RY/cMzTHw4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=koOnALTHzO4aKNyPALWjI2itBGyIBquVeAbQt9XvWEjXqBBKqp430k5C8PAFo2vZW
	 JwPi88CHVtQB9PvbSEHdA47w83TkKNSml8IiUjzD0M+RW96b5hM4sJGe6IXaoEHwyi
	 k0bP3IgLVwcuAHwIdH2yR51hYmXCZ7yKnGUcQ5xU=
Date: Tue, 20 Feb 2024 21:28:26 +0100
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
	"Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
	kovalev@altlinux.org, Paulo Alcantara <pc@manguebit.com>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>,
	"sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Steve French <smfrench@gmail.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <2024022011-afraid-automated-4677@gregkh>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
 <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
 <ZbnpDbgV7ZCRy3TT@eldamar.lan>
 <848c0723a10638fcf293514fab8cfa2e@manguebit.com>
 <3bfc7bc4-05cd-4353-8fca-a391d6cb9bf4@amazon.com>
 <Zb5eL-AKcZpmvYSl@eldamar.lan>
 <61fde07c-f767-42b0-9bfa-ef915b28fb77@oracle.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61fde07c-f767-42b0-9bfa-ef915b28fb77@oracle.com>

On Tue, Feb 06, 2024 at 01:16:01PM +0530, Harshit Mogalapalli wrote:
> Hi Salvatore,
> 
> Adding kovalev here(who backported it to 5.10.y)
> 
> On 03/02/24 9:09 pm, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Thu, Feb 01, 2024 at 12:58:28PM +0000, Mohamed Abuelfotoh, Hazem wrote:
> > > 
> > > On 31/01/2024 17:19, Paulo Alcantara wrote:
> > > > Greg, could you please drop
> > > > 
> > > >           b3632baa5045 ("cifs: fix off-by-one in SMB2_query_info_init()")
> > > > 
> > > > from v5.10.y as suggested by Salvatore?
> > > > 
> > > > Thanks.
> > > 
> > > Are we dropping b3632baa5045 ("cifs: fix off-by-one in
> > > SMB2_query_info_init()") from v5.10.y while keeping it on v5.15.y? if we are
> > > dropping it from v5.15.y as well then we should backport 06aa6eff7b smb3:
> > > Replace smb2pdu 1-element arrays with flex-arrays to v5.15.y I remember
> > > trying to backport this patch on v5.15.y but there were some merge conflicts
> > > there.
> > > 
> > > 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays
> > 
> > While I'm not eligible to say what should be done, my understading is
> > that Greg probably would prefer to have the "backport 06aa6eff7b"
> > version. What we know is that having now both commits in the
> > stable-rc/linux-5.10.y queue breaks  cifs and the backport variants
> > seens to work fine (Paulo Alcantara probably though can comment best).
> > 
> Having both one-liner fix that I have sent and the above commit isn't
> correct.
> 
> > As 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays
> > was backportable to 5.10.y it should now work as well for the upper
> > one 5.15.y.
> 
> Correct, I agree. I had to send one-liner fix as we have the
> backport("06aa6eff7b smb3: Replace smb2pdu 1-element arrays with
> flex-arrays") missing in 5.15.y and when I tried backporting it to 5.15.y I
> saw many conflicts.
> 
> If we have backport for 5.15.y similar to 5.10.y we could ask greg to remove
> one liner fix from both 5.10.y and 5.15.y: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/cifs-fix-off-by-one-in-smb2_query_info_init.patch

Someone needs to tell me what to do, as I'm lost.

thanks,

greg k-h
