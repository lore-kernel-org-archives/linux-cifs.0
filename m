Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59FC5625FF;
	Tue, 22 Sep 2026 13:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083337; cv=none; b=Ng82AGNbxlhG1vaMSXHpnoPyvFbXdlSoUcNhG4GLmNXV+szvgry4pv06DN9wqSkEHSxlIyLkFRe/dBuQCV1op2F6ZIkH/nHlCdP5LgoeiQV2A1nM0gfYWN6D8vKlqYliWfexQpwtUfobdcg7qO5QDjxvG35Z7FREtRMWP+uo9eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083337; c=relaxed/simple;
	bh=sK8BnE3OVUa3qcEA4w6XLPX3ICDTz3CLRhUFPO/Xmo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCfEwvbeW4N5aSor1qSaKL4AK2OBJ18Ug6GwVV+OB0B4UQ8KKM/MDpGUYcfYNIQRGG3gZm6zyfzucPLifvyuvYOiPrnBaP+yiuI53VVrrnfO9myC+rjoxrZI0UHQu2oNh1/RUnGkwliAaDvlGhX81wg9InLYhC8EHFbA52JhptI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DaRB1lGh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DaRB1lGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E221A1F00893;
	Tue, 22 Sep 2026 13:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083334;
	bh=GfF8dRc2sKVUnBKfYNuG6L9N9wEZjzkAOGMMFnSAzCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DaRB1lGhiLSSe5W1fpYBzLdg73B/4vy2V01aBrToXztlIslYWIvfB8lbQIxSKkU5L
	 p+ujmKWKKkQtRvYFFSk9PD+DqqVIJB4temNjfY/czhPzle4BFacLAZnSHq3/TCgiWs
	 H84azRT9Sg6JIvhczIBWBBzl8Fjmyv5DaA8rKCTcb9uaauXkF0Ak1RBtdTIorZXOX5
	 8YQRVxppRhdxfbubvO3VizxqE09oczYIKk5lUHNnABf4ueIeh78sb0B0FayzCjFMxU
	 77OjjUC/n/tHzFUQVx6kocj9rLY0kdy1DGwrVMbknr+2EBXOUmUccPx6Dtjpby1ZS4
	 ZupgZtznXiiQQ==
Date: Tue, 22 Sep 2026 16:22:09 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Ammar Ratnani <ammrat13@gmail.com>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Stefan Metzmacher <metze@samba.org>, Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, Ammar Ratnani <aratnani@nvidia.com>,
	Kechen Lu <kechenl@nvidia.com>,
	Mithun Maragiri <mmaragiri@nvidia.com>
Subject: Re: [PATCH 0/2] smbdirect: don't hang on netdev reconfiguration
Message-ID: <20260922132209.GI563127@unreal>
References: <20260908154454.10966-1-ammrat13@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908154454.10966-1-ammrat13@gmail.com>

On Tue, Sep 08, 2026 at 08:44:25AM -0700, Ammar Ratnani wrote:
> When I mount a CIFS share using SMB Direct over RoCEv2, I observe a kernel
> thread hang if I "configure" its slave network device by taking its link
> down and bringing it back up. Attempting to just `ls` the mount point in
> this state gives EHOSTDOWN.
> 
> I believe the following is the root-cause of the hang: When the link is
> taken down, the corresponding GID Table Entry is marked as pending deletion
> and has its slave ndev set to NULL. All sends on RDMA connections still
> using that GID Table Entry fail at MAD creation. SMB Direct eventually
> detects this and tries to disconnect / reconnect to recover. Unfortunately,
> disconnecting requires successfully sending either a DREQ or a DREP. Since
> neither of them even post, the connection remains in the RDMA_CM_CONNECT
> state, and no callback moves it out. The SMB Direct layer never gets the
> RDMA_CM_EVENT_DISCONNECTED it's waiting for, and hangs.
> 
> Fix this in the CMA. If we call `rdma_disconnect` on a connected connection
> and we fail to send both a DREP and a DREQ; disconnect, and thereby send
> the `RDMA_CM_EVENT_DISCONNECTED` event to SMB Direct.
> 
> I tested this change in QEMU using RXE. I ran Ubuntu 26.04.1 with a
> mainline kernel. On commit 9f0346dcbea3 ("Merge tag 'driver-core-7.3-rc2'
> of git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core"),
> I reproduce the hang. With this patch applied, SMB Direct immediately
> disconnects and reconnects when the slave device is brought down then up.
> Listing and reading files from the mount point also work afterwards.
> 
> Artifacts for reproducing the hang and testing my fix are available at
> 
>     https://github.com/ammrat13/linux-cifs
> 
> There, you can find: logs from the "bad" and "good" kernels, the kernel
> configuration, the VMs' configuration, and a playbook to trigger the hang.
> 
> Ammar Ratnani (2):
>   infiniband: force disconnect if DREP and DREQ fail
>   infiniband: trace force disconnections

I squashed the second patch into the first one, fixed the subject, removed
the useless AI-generated comments, placed trace call into right place, and
pushed the result.

Thanks

> 
>  drivers/infiniband/core/cma.c       | 41 ++++++++++++++++++++++++++---
>  drivers/infiniband/core/cma_trace.h |  1 +
>  2 files changed, 38 insertions(+), 4 deletions(-)
> 
> -- 
> 2.55.0
