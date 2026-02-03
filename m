Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BDB318B9E;
	Tue,  3 Feb 2026 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770137978; cv=none; b=KMv2sIMBPen1IJgjLHJA3R3FTrLRH5yyq7Ln1NVvEWfOkua8FaTyycV5FW/EifqhW2wdE7KJE8EvtKaHvgCokwBc8uXExgBdPZCPlMbZhJxsUea8WoTVDfN0gBl1bYhg1ycVSVum57u7c3neUep7/wNGl6o2NPnDgZiriOS2zgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770137978; c=relaxed/simple;
	bh=KImTS7b/Fu7xAROhPakM7CeUqqHbeINsLNbTUxNpotU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IhmWYbXHjXStltQVNGdQZrXEjg+pGy4Y78/Nv5j8Nlvr5i7zRigDNVwp9ToC/C4LhKNsbRfc2KK2qej28YgWkg5ycmFUOcj3ZKI0opwobWZnfaMwX8P2HDldFekKvZbnh//Y1eWL8IuZ55oRdElq1tz6j5YdJpNQwAo8/1UNMlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z83NletI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z83NletI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6BBC116D0;
	Tue,  3 Feb 2026 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770137978;
	bh=KImTS7b/Fu7xAROhPakM7CeUqqHbeINsLNbTUxNpotU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z83NletI7cJ0Ati86UimqngvvU890iOkxnW1jKfdwR0FVGAn4Ql0JOVvtRhUKFt5v
	 NTe9WgaxxC/MHseDvihF7hS087R8SJANUUQ/E0BtsSuyvL3E6GGWCLee7CQnQf0xdD
	 VyucZpa5W4iUaNrK+NPRA8rOP5rQaxqoibi3SvygNcSppVWh1anXhOh9P0mThbOd9L
	 04DjRy5r4xyADTl1emtVTY+LwPoZFsPLCuwZDSTsZPDeTLu4Ok1HcH2WZ2mhfh3WKt
	 tuqM9qRJXUnaisExuXjWbggNlCt9yPFft4nsc3tmdPB0s3ZNV33UmUeBVW7og2b2Rz
	 Rsi7QxO5xwJEg==
Date: Tue, 3 Feb 2026 18:59:32 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-rdma@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, Jason Gunthorpe <jgg@ziepe.ca>,
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [RFC PATCH 1/3] RDMA/core: introduce rdma_restrict_node_type()
Message-ID: <20260203165932.GY34749@unreal>
References: <cover.1769025321.git.metze@samba.org>
 <21c111d5f87f539bdb4d19714c375aefcffae7e3.1769025321.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21c111d5f87f539bdb4d19714c375aefcffae7e3.1769025321.git.metze@samba.org>

On Wed, Jan 21, 2026 at 09:07:11PM +0100, Stefan Metzmacher wrote:
> For smbdirect it required to use different ports depending
> on the RDMA protocol. E.g. for iWarp 5445 is needed
> (as tcp port 445 already used by the raw tcp transport for SMB),
> while InfiniBand, RoCEv1 and RoCEv2 use port 445, as they
> use an independent port range (even for RoCEv2, which uses udp
> port 4791 itself).
> 
> Currently ksmbd is not able to function correctly at
> all if the system has iWarp (RDMA_NODE_RNIC) interface(s)
> and any InfiniBand, RoCEv1 and/or RoCEv2 interface(s)
> at the same time.
> 
> And cifs.ko uses 5445 with a fallback to 445, which
> means depending on the available interfaces, it tries
> 5445 in the RoCE range or may tries iWarp with 445
> as a fallback. This leads to strange error messages
> and strange network captures.
> 
> To avoid these problems they will be able to
> use rdma_restrict_node_type(RDMA_NODE_RNIC) before
> trying port 5445 and rdma_restrict_node_type(RDMA_NODE_IB_CA)
> before trying port 445. It means we'll get early
> -ENODEV early from rdma_resolve_addr() without any
> network traffic and timeouts.
> 
> This is designed to be called before calling any
> of rdma_bind_addr(), rdma_resolve_addr() or rdma_listen().
> 
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  drivers/infiniband/core/cma.c      | 30 ++++++++++++++++++++++++++++++
>  drivers/infiniband/core/cma_priv.h |  1 +
>  include/rdma/rdma_cm.h             | 17 +++++++++++++++++
>  3 files changed, 48 insertions(+)

Thanks,
Acked-by: Leon Romanovsky <leon@kernel.org>
