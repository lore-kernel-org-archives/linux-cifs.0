Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A85266568;
	Wed, 13 Aug 2025 08:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755072627; cv=none; b=fnReFLM9nYBwNtZJUCDwDCgqi6DLSiUV7OCtz3IzOWPJLZcNDt7YNjbOYgSbwIFwlMA6yrXDYc13Q762H/wCYZ+CJdfkxr3m8B+ih0Cc8sGSqOaB0uhOwMpIWCUxRj7SXTK+vfBWdWROoiCeg1MhYly9lbVqL6VQ+lgeMD9DYig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755072627; c=relaxed/simple;
	bh=4Yo8/z18pw2CnP4EQiwpVhH0nR9vayws6O8QPv70pAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfVpO64EpAM6vf0k3EMxpmZzaBL63wQUMmGWEcNsrByGK3DMgfCfns8ov7bXCtdqBc5IlOWAfjxM4KkwjhdesoHyYbVUla1l5keqpkWYwStfRCNvZl9Z3kMT0CvV50/Wt7ZLh52F2Q494gvd6fhxCt4VxQIfrWQQv0qaQCr9+AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mfb5ie4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mfb5ie4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24284C4CEF7;
	Wed, 13 Aug 2025 08:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755072626;
	bh=4Yo8/z18pw2CnP4EQiwpVhH0nR9vayws6O8QPv70pAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mfb5ie4MU5HVRPlPNskOMyQMsUoPxehGGy1cOa+Dp0GgPo/pn4+R8001wuuRjCbmw
	 dZe9r5g+zU7SKM5cWw+6n/T8b06BVxwCK6eq5Lq9w7/ldW2HjVpW/HbS+x+HuSwQJ6
	 rIet3LcUR3DhWRUS7EeJ0OHc/Kqt0nWrkStND4iY=
Date: Wed, 13 Aug 2025 10:10:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 563/627] smb: client: let send_done() cleanup before
 calling smbd_disconnect_rdma_connection()
Message-ID: <2025081301-carpool-gully-cbfc@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173453.306156678@linuxfoundation.org>
 <527dc1db-762e-4aa0-82a2-f147a76f8133@samba.org>
 <2025081325-movable-popcorn-4eb8@gregkh>
 <6acc8228-da51-4528-87c4-4cb2c96d3e8a@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6acc8228-da51-4528-87c4-4cb2c96d3e8a@samba.org>

On Wed, Aug 13, 2025 at 10:04:11AM +0200, Stefan Metzmacher wrote:
> Am 13.08.25 um 09:59 schrieb Greg Kroah-Hartman:
> > On Wed, Aug 13, 2025 at 08:17:53AM +0200, Stefan Metzmacher wrote:
> > > Hi Greg,
> > > 
> > > Am 12.08.25 um 19:34 schrieb Greg Kroah-Hartman:
> > > > 6.16-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Stefan Metzmacher <metze@samba.org>
> > > > 
> > > > [ Upstream commit 5349ae5e05fa37409fd48a1eb483b199c32c889b ]
> > > 
> > > This needs this patch
> > > https://lore.kernel.org/linux-cifs/20250812164506.29170-1-metze@samba.org/T/#u
> > > as follow up fix that is not yet upstream.
> > > 
> > > The same applies to all other branches (6.15, 6.12, 6.6, ...)
> > 
> > Thanks, now queued up.
> 
> Even if it's not upstream yet?
> I thought the policy is that upstream is required first...
> 
> It's only here
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next
> as
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commitdiff;h=8b2b8a6a5827848250c0caf075b23256bab4ac88
> 
> But that commit hash can change on rebase.

Ah, I thought since this was in linux-next it would not rebase.  Having
public trees that rebase is dangerous...

Anyway, I'll go drop both of these now, please let us know when you want
these added back.

thanks,

greg k-h
