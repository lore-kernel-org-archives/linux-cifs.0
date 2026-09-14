Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3AE44A3E4;
	Mon, 14 Sep 2026 11:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386391; cv=none; b=qJyNZVICckzeuTXGnGd99nO6eDg5l4RfzNxhmw3YwN3LD2C0CJ7JiBEBzuQ+GtDhVX2gYzTOyqqwz6VIf+3c9zNyueUyiFoDNKli1F+TNip1ITUexUUgYHtEJ9D3CzCbvi83Ar0j1kXCS4IVf3fmeKAVqoXDYZeEk6CbiyQBsK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386391; c=relaxed/simple;
	bh=WVyYhFxfBF5CeK93fvShueptMLap3kBqHbb3B+Pk6JE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDyQ/NivjvA3WjOXlDbfEfnb9QVYN3v/tswL6pZgnbqD7NN82qwb894xGiUMdltpLTkSt/ZGn9bTZPTuq775brESLIfR6KnNhuQdYQy0HxkcYZeQHzE1bqY/Q0/J1qCMhMaiVPyPNTfZ13WDjuh18dDOpoFiv1I7HdCX3eDYahY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gzLlAZ1h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gzLlAZ1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A6F1F000FF;
	Mon, 14 Sep 2026 11:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789386389;
	bh=dWozeo7lPLL6ImVa3Gmj/izpFVE63qbwoUTlKDpp1SY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gzLlAZ1hJ/I+yohyUSEX8z4GEIP1qKfBnXtN88Zznsg2THUZW/fPGRA2g2NXhjKK4
	 Fm8JOkj6dDNdUwweWtG4CRu/cW7XU/4hJbxF70PGYDvMD/oj7QwJKx5VKioqoB946W
	 kG7OambZEEL7QdP2KN4QwQPC5thAQb0C9XicAaD3VHVvPniX29Pa8uisMfY+VkaKGu
	 G9fwbdIbz8mcT3hITGFWKPu0R1KocIxLFGo0ZPe1LA8fJ8cJHVSwUI3bGUdhXfxtuD
	 hPigr+Mh09HPmif/kZ/A1FsBK90TeccLQ/6fOJG8biaAx3hlzFgnfdjRSoV+TDaIfT
	 qYSUggFrUrCTg==
Date: Mon, 14 Sep 2026 14:46:26 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Ammar Ratnani <ammrat13@gmail.com>, linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>, Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, Ammar Ratnani <aratnani@nvidia.com>,
	Kechen Lu <kechenl@nvidia.com>,
	Mithun Maragiri <mmaragiri@nvidia.com>
Subject: Re: [PATCH 0/2] smbdirect: don't hang on netdev reconfiguration
Message-ID: <20260914114626.GX13683@unreal>
References: <20260908154454.10966-1-ammrat13@gmail.com>
 <c46d2974-04fa-4f49-a9ec-43ac8c1dd4db@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c46d2974-04fa-4f49-a9ec-43ac8c1dd4db@samba.org>

On Tue, Sep 08, 2026 at 06:16:21PM +0200, Stefan Metzmacher wrote:
> Hi Ammar,
> 
> thanks for the fixes!
> I let the rdma maintainers comment on the patches in detail,
> but it's good to fix these problems where they happen.

I think that patches are ok.

Thanks
