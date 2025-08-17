Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AC21ADFE4;
	Sun, 17 Aug 2025 10:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755424842; cv=none; b=eXPOWWLOb+JH1tCMOF8463aiVZT2Z5q5jDJBlLno++vv8HBCOYsKkLtJB7GFhteKGbWfqjjkvnzfOhwJ6znAMu6C4zephQ6EoQdjOQJhCUUtYeCoP7biEefiC4Ts4VoB9+fLlqG8Q1Ij15plOm2CLkLwgMorZsSKd3s8bz2o9L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755424842; c=relaxed/simple;
	bh=lSiCBzBEvtd04BW3HYknPJpAutHVmPwDd22OHkFFny0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+oc3QtMYynPLJA0TfMcqb5sza/lKNJ4NaM6dqFyDTVZm1Nv2EGDpcLoPD6zOmjrKPXduJxPMBfTg9t6B5xn9ejlCNegyOWVbnmerTMNvJVQPU6/uXVTiu/DmsbWSbaasUDajOiaW4RB9TJPMwbs+nxDRG7lzEJsNzH7RsLHg2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9wy2Jba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9wy2Jba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EF2C4CEEB;
	Sun, 17 Aug 2025 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755424841;
	bh=lSiCBzBEvtd04BW3HYknPJpAutHVmPwDd22OHkFFny0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T9wy2Jbaghanj4R+70yLqB4uLPg2UJW6RBfW0whiB6UAdJFi/rSwM+AitkUJzhP9t
	 aOmvLwnKoDje2FR6cmvAkXPld+UUyD+reMawmznB2O04C6sJYJuycpnMdmMWFY11Ae
	 du2m3KFTgpuVlgWtVeWUwKaHhA7JgjeBdM4AQlTM=
Date: Sun, 17 Aug 2025 12:00:25 +0200
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
Message-ID: <2025081719-parcel-oblong-5ffd@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173453.306156678@linuxfoundation.org>
 <527dc1db-762e-4aa0-82a2-f147a76f8133@samba.org>
 <2025081325-movable-popcorn-4eb8@gregkh>
 <6acc8228-da51-4528-87c4-4cb2c96d3e8a@samba.org>
 <2025081301-carpool-gully-cbfc@gregkh>
 <c582ccee-9425-4f4e-a04a-c86e9992e917@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c582ccee-9425-4f4e-a04a-c86e9992e917@samba.org>

On Sun, Aug 17, 2025 at 11:45:31AM +0200, Stefan Metzmacher wrote:
> Hi Greg,
> 
> > > > > Am 12.08.25 um 19:34 schrieb Greg Kroah-Hartman:
> > > > > > 6.16-stable review patch.  If anyone has any objections, please let me know.
> > > > > > 
> > > > > > ------------------
> > > > > > 
> > > > > > From: Stefan Metzmacher <metze@samba.org>
> > > > > > 
> > > > > > [ Upstream commit 5349ae5e05fa37409fd48a1eb483b199c32c889b ]
> > > > > 
> > > > > This needs this patch
> > > > > https://lore.kernel.org/linux-cifs/20250812164506.29170-1-metze@samba.org/T/#u
> > > > > as follow up fix that is not yet upstream.
> > > > > 
> > > > > The same applies to all other branches (6.15, 6.12, 6.6, ...)
> > > > 
> > > > Thanks, now queued up.
> > > 
> > > Even if it's not upstream yet?
> > > I thought the policy is that upstream is required first...
> > > 
> > > It's only here
> > > https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next
> > > as
> > > https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commitdiff;h=8b2b8a6a5827848250c0caf075b23256bab4ac88
> > > 
> > > But that commit hash can change on rebase.
> > 
> > Ah, I thought since this was in linux-next it would not rebase.  Having
> > public trees that rebase is dangerous...
> > 
> > Anyway, I'll go drop both of these now, please let us know when you want
> > these added back.
> 
> It landed as 8c48e1c7520321cc87ff651e96093e2f412785fb, so
> 5349ae5e05fa37409fd48a1eb483b199c32c889b can be backported
> with 8c48e1c7520321cc87ff651e96093e2f412785fb being the fixup.

Now queued up, thanks.

greg k-h
