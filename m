Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E651E04BF;
	Fri, 13 Dec 2024 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734100415; cv=none; b=Gq0JklIqPs46PCLnGfbvLXqChgO21wPR0GxFy9s8BWCBiO7t/2NhFJiYscVKhrZxOFw2nfxkI6s8S986hOI3oeQNzWe0PFwU1Ihxa/0kRF9xEoCIqtm9Jr0SqFjJ7ZCjA/CHskoOYABCis1dAhggbbCzUv9pmocSRHrunrNXhik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734100415; c=relaxed/simple;
	bh=PxRIzyngJAldqq4VCoyyeFAPVgtSl6U/ZhJk5pQ33xA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JjsIW+GwP+dcsPZZDwHz86z+WjZT9ehMlwEqhFVTq1CZBrKsJS+HsDqTk8HYpSO4SFakoaOht5aF/n6LwggsJSW6bzWHB+BTOjeliUMmVY41bwUX7xUyGFSB2nLT62S3IklqKQrujtLyy8bjonanIumKnWB3ReG2cA6FOU/s2sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOt/nXPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOt/nXPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D478C4CED2;
	Fri, 13 Dec 2024 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734100414;
	bh=PxRIzyngJAldqq4VCoyyeFAPVgtSl6U/ZhJk5pQ33xA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YOt/nXPxQgz3yWLmPb1Mu4UWkbSo9EgR71TMdP1Dt9VeiEPbUDOyGFDvt5Dhv7duq
	 6lahiweo04d9zs30z/TNlZNyTal8nLEznFhyFcQG65q1/H3W5yz7oK79m3dn6smqzL
	 0BRKH6AT8GjeHRhMkrBLbJ7c/Ab1KRKXLNSG2Yko=
Date: Fri, 13 Dec 2024 15:33:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Krause <mk@galax.is>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Michael Krause <mk-debian@galax.is>,
	Steve French <stfrench@microsoft.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, linux-cifs@vger.kernel.org
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
Message-ID: <2024121316-refresh-skintight-c338@gregkh>
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
 <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
 <Z08ZdhIQeqHDHvqu@eldamar.lan>
 <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>
 <2024121243-perennial-coveting-b863@gregkh>
 <e9f36681-2d7e-4153-9cdf-cf556e290a53@galax.is>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9f36681-2d7e-4153-9cdf-cf556e290a53@galax.is>

On Thu, Dec 12, 2024 at 10:48:55PM +0100, Michael Krause wrote:
> On 12/12/24 1:26 PM, Greg KH wrote:
> > On Tue, Dec 10, 2024 at 12:05:00AM +0100, Michael Krause wrote:
> > > On 12/3/24 3:45 PM, Salvatore Bonaccorso wrote:
> > > > Paulo,
> > > > 
> > > > On Tue, Dec 03, 2024 at 10:18:25AM -0300, Paulo Alcantara wrote:
> > > > > Michael Krause <mk-debian@galax.is> writes:
> > > > > 
> > > > > > On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
> > > > > > > Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
> > > > > > > in smb2_reconnect_server()") which seems in fact to solve the issue.
> > > > > > > 
> > > > > > > Michael, can you please post your backport here for review from Paulo
> > > > > > > and Steve?
> > > > > > 
> > > > > > Of course, attached.
> > > > > > 
> > > > > > Now I really hope I didn't screw it up :)
> > > > > 
> > > > > LGTM.  Thanks Michael for the backport.
> > > > 
> > > > Thanks a lot for the review. So to get it accepted it needs to be
> > > > brough into the form which Greg can pick up. Michael can you do that
> > > > and add your Signed-off line accordingly?
> > > Happy to. Hope this is in the proper format:
> > 
> > It's corrupted somehow:
> > 
> > patching file fs/smb/client/connect.c
> > patch: **** malformed patch at line 202:  		if (rc)
> > 
> > 
> > Can you resend it or attach it?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Ugh, how embarrassing. I'm sorry, I "fixed" some minor whitespace issue directly in the patch and apparently did something wrong.
> 
> I redid the white space fix before diffing again and attach and inline the new version. The chunks are a bit alternated to the earlier version now unfortunately. This one applies..

Doesn't apply for me:

checking file fs/smb/client/connect.c
Hunk #1 FAILED at 259.
Hunk #2 FAILED at 1977.
Hunk #3 FAILED at 2035.
3 out of 3 hunks FAILED
checking file fs/smb/client/connect.c

Any ideas?

thanks,

greg k-h
