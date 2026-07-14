Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE8332B981;
	Tue, 14 Jul 2026 13:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035675; cv=none; b=KMZBM0Nn0zeQRLNb4ko/JI8/Nx3nedea3hNOqQ4pIh8iyJqCGXWCofZg5jsUSyR2crpYFASzreInY6yqtumpAirHXHw5+chcsIv08vmzor4d9ftQWkO89yLG+8lXJlpETVooF5X6A1H+XYybASlkJ5hl9Pypu4NtvaIT+3/4mVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035675; c=relaxed/simple;
	bh=xHRY+V+D2I980wEHRlXjSFVevdDJlaT2wsxknD6SGe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PlYhqUNgwgnkn5g8TKmBpNhVkoWZl5UJokHd86AlANUadEY9ljwzw4Xo/p0bbdZuSsSrPt6U9bhYfY4kfopopOkmsvPVK5EWjm9ikmSCTEIQYnWYl2FHnMfVgnRj4Yfu8UFrXKm1XC2wAbf8hpVs18WBd+Y7aQL6WpeEsbvt72Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kXNQN0RR; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kXNQN0RR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784035673; x=1815571673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xHRY+V+D2I980wEHRlXjSFVevdDJlaT2wsxknD6SGe0=;
  b=kXNQN0RRdysPv3pLEXtHziWD/lDOQoVAT7XwLKFqHdrZaXl+xULL1jZX
   rgT88o+5RhBELACG+3YJwoQ3FLWMCHmF+Rqagc8aqIPanWFRw93ppc5hC
   XEwMh4IaGiNYK2GMoHC7ov8BFmCDU82zwCzL57bvBoLeF/mDfpv5WYOF4
   R26O0mAuqSh3l2hpuHdTbPfra+fHu8nTcQt9+vpB8oOljsql1Yk/3BfU2
   YeKpeb/bTvINXKclgz6H1nBbVLOR0epuCysv4sv/GSVTKprcRS+JcpV8P
   k+BCkOzLePlerfuzv59L571aYgG8nnp9ssdkHsyCLCREezOLvNtyqGCjC
   A==;
X-CSE-ConnectionGUID: T5XSkzUbSOOCQbBml401vg==
X-CSE-MsgGUID: WfQBWk8cTmmx1WLdAn7hxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88556923"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88556923"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 06:27:52 -0700
X-CSE-ConnectionGUID: IlqVCs/zQUWZEpQ74bjmtw==
X-CSE-MsgGUID: vpMnZA/+THy1xmhThyh3zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="255905367"
Received: from kniemiec-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.189])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 06:27:49 -0700
Date: Tue, 14 Jul 2026 16:27:47 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Steve French <stfrench@microsoft.com>,
	Youling Tang <tangyouling@kylinos.cn>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH v1 1/1] smb/client: Use EXPORT_SYMBOL_IF_KUNIT() to
 export symbols
Message-ID: <alY5UyI6SiGYJG2S@ashevche-desk.local>
References: <20260714122120.743185-1-andriy.shevchenko@linux.intel.com>
 <755b2ab6-8aee-49e4-89b0-a05589f0b64b@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <755b2ab6-8aee-49e4-89b0-a05589f0b64b@chenxiaosong.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jul 14, 2026 at 08:35:16PM +0800, ChenXiaoSong wrote:
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

Thanks!

> Andy, could you also submit a patch to update fs/smb/client/smb2maperror.c
> as well?

Sure.

> 在 2026/7/14 20:21, Andy Shevchenko 写道:
> > Replace EXPORT_SYMBOL_FOR_MODULES() with EXPORT_SYMBOL_IF_KUNIT()
> > to mark the symbols as visible only if CONFIG_KUNIT is enabled.
> > 
> > Kunit test should import the namespace EXPORTED_FOR_KUNIT_TESTING to
> > use these marked symbols. This is the standard way for all KUnit
> > tests.

-- 
With Best Regards,
Andy Shevchenko


