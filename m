Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A22205ABE;
	Thu, 12 Dec 2024 12:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734006368; cv=none; b=uIFozlpEcHh8vCzNEldgU6e56sSm5Ko2dYxMAnLAy6gpF2gkYhyM5PSPxyTnkXnYqhCFnUV1M3sW963PZB+fg/SR2zKTB4LyU0gGyrWMzlE0icgzjq9tCZtenE4KCki4mvZLhxinVrCHgQ0jeufzetsqm+amNBL330xPHoamNNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734006368; c=relaxed/simple;
	bh=MmkLc+wLgGzfL5jADllXW0wGKX7TMcrw2DyU6I663SY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnVz+9VAWvgss5WUMEsAWb6nZS3fvGWB4OQE+4vO2waRQ2OjEKenrIrt/uXArvGdmswd+G8q7kAbWVL2+aABVnyz/B9mfCHKMW7W4CMPUlA77AUtbOX0kqIpl8637n+puxmbU+TYbYzIQVyhE4QlEg8fGAbFYuE1t1nOtNmzSlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8ihqCP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8ihqCP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47280C4CED0;
	Thu, 12 Dec 2024 12:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734006367;
	bh=MmkLc+wLgGzfL5jADllXW0wGKX7TMcrw2DyU6I663SY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h8ihqCP41LrGa4AVn2jVkV924E1ysXLY99gT5FqMf40Hj4EhPthUoCvk7L5qNJqKD
	 3+lZG9nkn2iPeLutIuWq5ZBQOLXK8keWUmQQe570jFzVv6GDLmHj6v9CIVpW7bRhHB
	 DRnrTAPJxh9t519FHwSXrVwW7x48POTxSL/dn9Tg=
Date: Thu, 12 Dec 2024 13:26:04 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Krause <mk@galax.is>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Michael Krause <mk-debian@galax.is>,
	Steve French <stfrench@microsoft.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, linux-cifs@vger.kernel.org
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
Message-ID: <2024121243-perennial-coveting-b863@gregkh>
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
 <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
 <Z08ZdhIQeqHDHvqu@eldamar.lan>
 <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>

On Tue, Dec 10, 2024 at 12:05:00AM +0100, Michael Krause wrote:
> On 12/3/24 3:45 PM, Salvatore Bonaccorso wrote:
> > Paulo,
> > 
> > On Tue, Dec 03, 2024 at 10:18:25AM -0300, Paulo Alcantara wrote:
> > > Michael Krause <mk-debian@galax.is> writes:
> > > 
> > > > On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
> > > > > Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
> > > > > in smb2_reconnect_server()") which seems in fact to solve the issue.
> > > > > 
> > > > > Michael, can you please post your backport here for review from Paulo
> > > > > and Steve?
> > > > 
> > > > Of course, attached.
> > > > 
> > > > Now I really hope I didn't screw it up :)
> > > 
> > > LGTM.  Thanks Michael for the backport.
> > 
> > Thanks a lot for the review. So to get it accepted it needs to be
> > brough into the form which Greg can pick up. Michael can you do that
> > and add your Signed-off line accordingly?
> Happy to. Hope this is in the proper format:

It's corrupted somehow:

patching file fs/smb/client/connect.c
patch: **** malformed patch at line 202:  		if (rc)


Can you resend it or attach it?

thanks,

greg k-h
