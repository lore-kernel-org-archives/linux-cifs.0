Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3143939B8;
	Thu, 26 Feb 2026 10:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772100573; cv=none; b=OXSTytWiako47w/fsnBvPg5TsPVCOPIpzrNllXFn5CIL6czj1g5bWzBvcS0GBGS1BD9XNIymiGyzpbMsdYVUdYO70hM3rZcBugs8IfAt1T+4uS79aM0xgeaA4YMpbeW4dbB3mij1RtpmRdDJeJenqV7gFe6pLiRlDelQ92b5AkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772100573; c=relaxed/simple;
	bh=/L7uHnYfyLDUJuVq/AVODK8KpxBgs9ylCdKPc23e5jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWW33gE1pvf7LFDPtddl1riLNtgrKP65uN+SgQa8IIjtsor63KPpjbpK4VXPWA5QJqrlWm/YUAKGtK46PJCk4bOkASbimnKGGvWAmOgzgjHUicBN91swKjuoSjhIZeN7ymLSzj99zeeNAE4d2N2FQNRMQJhGfloroUeOuPcXW3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHMSzxOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHMSzxOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63488C19422;
	Thu, 26 Feb 2026 10:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100573;
	bh=/L7uHnYfyLDUJuVq/AVODK8KpxBgs9ylCdKPc23e5jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jHMSzxOonARmEsjVDNeo+/Q+Z5Y6USNxYuVTWTWnSvhMDZWSjVqiQB00VBO3W9elL
	 cEg4fMbD2AM+VppJ45UORI7TIYRmYeSD0q1Bom13OWLiFkj+8yWLlbxe+Wq/DbHQId
	 NxePysbFQJdMXkmYAQmlrmbYIscMZ9cL3Ya+7E49NiKwabdoIbs3W98sxR6ErUUhc7
	 PXqxiXI/feUlQIjLCnjx6k5FbY/DPHzkiFIqs2kqTl65PUIRqgmQy1J2Qkg8c52HH4
	 2sR/VzIhACqP4uSpbFLiIntGGAeoM65gAqHtsBfeJBa3UUbB0qS8JIqICTQIob6bvv
	 ehGOek0CryxvQ==
Date: Thu, 26 Feb 2026 12:09:29 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH] RDMA/core: check id_priv->restricted_node_type in
 cma_listen_on_dev()
Message-ID: <20260226100929.GI12611@unreal>
References: <20260224165951.3582093-2-metze@samba.org>
 <20260225125211.GE9541@unreal>
 <a8d20762-e4f7-41fd-b67e-803858655aad@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8d20762-e4f7-41fd-b67e-803858655aad@samba.org>

On Thu, Feb 26, 2026 at 10:32:27AM +0100, Stefan Metzmacher wrote:
> Am 25.02.26 um 13:52 schrieb Leon Romanovsky:
> > On Tue, Feb 24, 2026 at 05:59:52PM +0100, Stefan Metzmacher wrote:
> > > When listening on wildcard addresses we have a global list for
> > > the application layer rdma_cm_id and for any existing
> > > device or any device added in future we try to listen
> > > on any wildcard listener.
> > > 
> > > When the listener has a restricted_node_type we
> > > should prevent listening on devices with a different
> > > node type.
> > > 
> > > While there fix the documentation comment of
> > > rdma_restrict_node_type() to include rdma_resolve_addr()
> > > instead of having rdma_bind_addr() twice.
> > > 
> > > Fixes: a760e80e90f5 ("RDMA/core: introduce rdma_restrict_node_type()")
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > Cc: Leon Romanovsky <leon@kernel.org>
> > > Cc: Steve French <smfrench@gmail.com>
> > > Cc: Namjae Jeon <linkinjeon@kernel.org>
> > > Cc: Tom Talpey <tom@talpey.com>
> > > Cc: Long Li <longli@microsoft.com>
> > > Cc: linux-rdma@vger.kernel.org
> > > Cc: linux-cifs@vger.kernel.org
> > > Cc: samba-technical@lists.samba.org
> > > Signed-off-by: Stefan Metzmacher <metze@samba.org>
> > > ---
> > >   drivers/infiniband/core/cma.c | 6 +++++-
> > >   include/rdma/rdma_cm.h        | 2 +-
> > >   2 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > Applied, thanks.
> 
> Great!
> 
> Will this be scheduled for rc2?

I hope so, rdma-rc has a compilation fix which I would like to see in
Linus's master as soon as possible.

> Would be great as it fixes a regression in ksmbd
> with iwarp.

Thanks

> 
> Thanks!
> metze
