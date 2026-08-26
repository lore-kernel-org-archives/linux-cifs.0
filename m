Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93D53B71BF;
	Wed, 26 Aug 2026 08:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731480; cv=none; b=sPhit1+/NzfgKRVmeb2h4whSFMFoJj+JO47KNQz+TuoVy63GgeLmI9y5xK0P/z2usZffDzB0PG+VfK2YWF9EzlQ76YI1Bni0phgKEBKCF91K6Wwpf+86/sZxKrm6xH4xV1GW4RAPA4reh0OzWlLASNUOUu7Ieu3bum8VNbUXbCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731480; c=relaxed/simple;
	bh=YmqmX2qMmPG5Lciiv5scl4kEAFR+9aeuet0FeP9XUq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azqf6plxS+aFmB+M18v0opJC/e6p5iyHts7y3A81nObNYbrlHuzavWYLvCMFboAWcUkaTHbz4RzeWhiKqva4Lomwou8zC1PYiTPJeYv+zAOFa2BxAchkaU7KepzyLNAZEko2gGpjQ5V54O+x4VV9kH/vsjcBq0fuVSdJUycKyK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GlsOUfYD; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GlsOUfYD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787731479; x=1819267479;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YmqmX2qMmPG5Lciiv5scl4kEAFR+9aeuet0FeP9XUq4=;
  b=GlsOUfYDCuPj8ogUrMIvWkGUJa5oHDaLYRv40wdm5nfgE/9W9/otlNkG
   eUkUW5UN7FzNbPE49L0zVBoFIYd/2+aWNP+io9acf3WKBvRE9nMbuM/Cm
   M6ea/1GH47NhBtWdy+cDxWOktRH1A4bienhx5UfB2C1re1QjDDhZUIBPJ
   VRTV2fjggtzk4EdHXZFhnHH3BfLKVMARc5szcBtAI4C5t4X73SQTnT0Xh
   ekNZtqu3wJrsi94/+aA46UVg4oHN7ZztA1mphDtToBEKiSrFjyTauofDE
   kHlLkvHKrbqdxX0l+KcWorRgsH+AZSEYenUL+BRk7CzeqfIeMQWbowTrR
   Q==;
X-CSE-ConnectionGUID: aELCjd5oRfOL2wnPfmsdEw==
X-CSE-MsgGUID: KS7KNeN6TCWZRW76dsXShg==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="90718786"
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="90718786"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:04:38 -0700
X-CSE-ConnectionGUID: MOXUMmuWRVW9k2FUTJb6UQ==
X-CSE-MsgGUID: 1DuVP3lUTaigZomO4X0Deg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="272764400"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.235])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:04:35 -0700
Date: Wed, 26 Aug 2026 11:04:32 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Yunseong Kim <yunseong.kim@est.tech>
Cc: Steve French <stfrench@microsoft.com>,
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH v1 1/1] smb: client: transport: Fix debug printing in
 __release_mid()
Message-ID: <ao6eEMYe1l0vFYZE@ashevche-desk.local>
References: <20260825083043.4037868-1-andriy.shevchenko@linux.intel.com>
 <20260825233419.762040-1-yunseong.kim@est.tech>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825233419.762040-1-yunseong.kim@est.tech>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Aug 26, 2026 at 01:34:06AM +0200, Yunseong Kim wrote:
> On Tue, 25 Aug 2026 10:30:43 +0200 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

...

> > -			cifs_info("A: 0x%lx S: 0x%lx R: 0x%lx\n",
> > -				  now - midEntry->when_alloc,
> > -				  now - midEntry->when_sent,
> > -				  now - midEntry->when_received);
> > +			pr_debug("slow rsp: cmd %d mid %llu A: 0x%lx S: 0x%lx R: 0x%lx\n",
> > +				 midEntry->command, midEntry->mid,
> 
> The change looks correct to me.
> 
> One minor suggestion: could the format string be split using adjacent
> string literals to avoid the long source line?
> 
>     pr_debug("slow rsp: cmd %d mid %llu "
>              "A: 0x%lx S: 0x%lx R: 0x%lx\n",
>              ...);

No, the idea is to have long string literals. This was exceptionally done
somewhat 15+ years ago.

See f4c014c0dede ("checkpatch: allow printk strings to exceed 80 characters to
maintain their searchability") as the result of the discussion started here:
https://lore.kernel.org/lkml/20080222132612.GA11717@basil.nowhere.org/

> > +				 now - midEntry->when_alloc,
> > +				 now - midEntry->when_sent,
> > +				 now - midEntry->when_received);

-- 
With Best Regards,
Andy Shevchenko


