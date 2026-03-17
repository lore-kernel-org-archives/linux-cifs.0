Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD5E35CB7C;
	Tue, 17 Mar 2026 09:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773738857; cv=none; b=TeXRv+etojWGSqkWM5J3Zi+KIihLsMDtF+aHSlIeb3WNcY17xe2Ew97b/fVOleaqO1+4e6q5qYwGuDf0aq/V71LCRb22dSt+6Icr9eU348UlociuXgFZVv0jEh3ujTPpmI5HZVdnThQZlfeaOyUIH0k9wYyzC9gkXG3ZsS0hop4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773738857; c=relaxed/simple;
	bh=VqaxHKKej1VPNV8dxEaXOdj9pYOUPcwOgCKCVcNAmMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+w9ywUJYisoJ+bQZEOhuvinjKlipVFntneZ8+CU+pfkXNMlpzRjn+ojEFMUT/3hbYyhoaAJwXAfVqs6/sSLVOfGKduiIrxZZ7rkzGbzb+mwkR0PLfVmdKoi4Vy1B8gu+4BfZZRUNyN7or2sMIoQ9Wd5+VeZMKZrYkc0PFrcj+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2rc01gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2rc01gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69EEC4CEF7;
	Tue, 17 Mar 2026 09:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773738856;
	bh=VqaxHKKej1VPNV8dxEaXOdj9pYOUPcwOgCKCVcNAmMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2rc01guiw9Cpys9eOyvTfYMYhUXyqWFR22DiHTmUiGXY0YS9Z2+lIoJQzFsPuGYc
	 6ssP+5IMaxl0RfuzBfH4ByEZVINpBQ2amGQu+pv3jPhUOjGgEHA6t/PNDhRPBH+kYd
	 QheyiFU22YkTa24E3P/SZVbV8+zz+KPyqDx4Od6WnTYDcA6ZsLU+wka2TEZqle54iG
	 V2Oa43NXgpUNu6F8Fap2EQVbCm17uGiW5pPfHjn/SORnHV4mHj5DTyT5HjHWzqfCoR
	 EXxotjwvhj9jPx1jdoKv3QF6pn/kHi1GDuRFwb9E793qc14KYZv8aTVX6KzBXDJOp8
	 w0Dy0QKxcnasQ==
Date: Tue, 17 Mar 2026 11:14:11 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yury Norov <yury.norov@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-spi@vger.kernel.org, linux-hyperv@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Mark Brown <broonie@kernel.org>, Steve French <sfrench@samba.org>,
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [PATCH] lib: count_zeros: fix 32/64-bit inconsistency in
 count_trailing_zeros()
Message-ID: <20260317091411.GQ61385@unreal>
References: <20260312230817.372878-1-ynorov@nvidia.com>
 <20260313171855.GA1744604@nvidia.com>
 <abRUGVW6ZuGioa4Z@yury>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abRUGVW6ZuGioa4Z@yury>

On Fri, Mar 13, 2026 at 02:14:49PM -0400, Yury Norov wrote:
> On Fri, Mar 13, 2026 at 02:18:55PM -0300, Jason Gunthorpe wrote:
> > On Thu, Mar 12, 2026 at 07:08:16PM -0400, Yury Norov wrote:
> > > Based on 'sizeof(x) == 4' condition, in 32-bit case the function is wired
> > > to ffs(), while in 64-bit case to __ffs(). The difference is substantial:
> > > ffs(x) == __ffs(x) + 1. Also, ffs(0) == 0, while __ffs(0) is undefined.
> > > 
> > > The 32-bit behaviour is inconsistent with the function description, so it
> > > needs to get fixed.
> > > 
> > > There are 9 individual users for the function in 6 different subsystems.
> > > Some arches and drivers are 64-bit only:
> > >  - arch/loongarch/kvm/intc/eiointc.c;
> > >  - drivers/hv/mshv_vtl_main.c;
> > >  - kernel/liveupdate/kexec_handover.c;
> > > 
> > > The others are:
> > >  - ib_umem_find_best_pgsz(): as per comment, __ffs() should be correct;
> > 
> > So long as 32 bit works the same as 64 bit it is correct for ib
> 
> This is what the patch does, except that it doesn't account for the
> word length. In you case, 'mask' is dma_addr_t, which is u32 or u64
> depending ARCH_DMA_ADDR_T_64BIT.
> 
> This config is:
> 
>         config ARCH_DMA_ADDR_T_64BIT
>                 def_bool 64BIT || PHYS_ADDR_T_64BIT
> 
> And PHYS_ADDR_T_64BIT is simply def_bool 64BIT. So, at least now
> dma_addr_t simply follows unsigned long, and thus, the patch is
> correct. But IDK what's the history behind this configurations.
> 
> Anyways, the patch aligns 32-bit count_trailing_zeros() with the
> 64-bit one. If you OK with that, as you said, can you please send
> an explicit ack?

I can do that, 32 bits architectures are rarely used in the IB world.

Thanks,
Acked-by: Leon Romanovsky <leon@kernel.org>
