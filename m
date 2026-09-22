Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2AC5616AC;
	Tue, 22 Sep 2026 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083240; cv=none; b=CW+Y0GJNIVfljy71AkCuRFR7IVzebB7E++4B0i+uVBfnjKjl2ugc0bwnMcMHSUh0LcJ/3EetOMT6bSpR4x3KWISN39opoR+ufjgKXQwvVybhGE9AFn0I8FICKdp6yhKgvClkW25aUl3BhjCARVh2nRSDQ5PuO5ycox2YwDfFQ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083240; c=relaxed/simple;
	bh=T1tclQ9s/7HbYf0rJruht+CSkPkjkVagR9FizozQTnQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DqnlJEWWgpQph2nJ5pziXvejwkVKh2M51882Hm3R0Ss0OuJsyz601OJ1XqDF7cu+i8jsFvShQWG3GC6YEJbuqiEPCp3paq1JYMybPrsL4x2W+CrxUjxGqIK7NSloMvT4QcSATj1lgJ4TEw9ZHc6s56mTL3jPl+8Wc+VVcs2vjYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMAoYBw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMAoYBw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFBA1F000FF;
	Tue, 22 Sep 2026 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083239;
	bh=Zph2YYuUDIj2EKmHQ8F9hpiavqYmvebLGa+PNBNMtGo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=WMAoYBw40o04Ggh9YZm3/jb327iZbBqfA0bXHF1Va7uYGGFdumBugZI4spICHb9mW
	 u+RJW1CN+ltpTVGdvEbgqo3X5uXwkbitoDwZCdqGmNjhBls+qYdnouNO3Q81F5wTo1
	 Tpo6jum2VQvg1pdONnrqYQnK66IFsA3aG5LjIWXb8kszem+A8ATGHo2PXZlc2kvByW
	 sqmQIUfwvlYYVRminXvVticQ1XpRcKnlMvB7OkVqZT6g8oP0NzAiH/d69IaZOrzBvr
	 I+shwkNK+P8TSkphK2V7xeBB9StySCwgTM/vIXcnuYevXMcwVGwdYcahxbetV6Aq0x
	 dvi45b0tEXLuA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Ammar Ratnani <ammrat13@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Namjae Jeon <linkinjeon@kernel.org>, 
 Paulo Alcantara <pc@manguebit.org>, Stefan Metzmacher <metze@samba.org>, 
 Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
 Ammar Ratnani <aratnani@nvidia.com>, Kechen Lu <kechenl@nvidia.com>, 
 Mithun Maragiri <mmaragiri@nvidia.com>
In-Reply-To: <20260908154454.10966-1-ammrat13@gmail.com>
References: <20260908154454.10966-1-ammrat13@gmail.com>
Subject: Re: [PATCH 0/2] smbdirect: don't hang on netdev reconfiguration
Message-Id: <179008323615.3241637.14699220932573683495.b4-ty@kernel.org>
Date: Tue, 22 Sep 2026 09:20:36 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 08 Sep 2026 08:44:25 -0700, Ammar Ratnani wrote:
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
> [...]

Applied, thanks!

[1/2] infiniband: force disconnect if DREP and DREQ fail
      https://git.kernel.org/rdma/rdma/c/ba88a28b47a703
[2/2] infiniband: trace force disconnections
      (no commit info)

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

