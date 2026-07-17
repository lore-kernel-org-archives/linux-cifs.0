Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891993E0096
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 08:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275439; cv=none; b=TpcblEgija4ctW6R5zDxmQ8T5ondFLiXKg9Vj4NfP/0Gq2zfeliiOf0gnKcyHEStciGPCsoSH3ERe3LJeVc6A2S+Fc+RlUh57e584hDtffPqUn7LSDFFAu21qWRVbFVgiH3hmIc7dptxjDHah/P1d/twbdB+/fVg9j4aqK5zXZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275439; c=relaxed/simple;
	bh=lM2psiKjy8oyGaTS0jYydwdkpBQWiitwcmwk1Mzw1io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bS0VxTlXdB0Ibh3zIgwcQCPI1iD3FljNa9ebAqC9LTGHQuWvQqtCpYFTFC1ygSE8TNpZfGFNg2roQIC+fR34K3gBiaImnjz5q49SL9CvXx2WKsRNTvp7WsCQ4KHegK8EtWI/E8/s2U7Dr74EiMfpZ0//2Uxxv64TUf5SiZL4qBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X4diXLhH; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X4diXLhH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784275437; x=1815811437;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=lM2psiKjy8oyGaTS0jYydwdkpBQWiitwcmwk1Mzw1io=;
  b=X4diXLhHMgjMlcuuet3XwzVmWRuU8sCrjIVgAHL47cQQIP9BU9thBcsT
   KMLBPw5Sv/S7RC1TbwQDevD+FhwMqUf410zu6/ksq9zqOSbuORUOsqIYe
   0CGg1f6tC4ONMtqVyJ7YIwhwyj/k6v0C5OQJFUQCvuexgm4v1IUNHKFp4
   W5zU7heGiMp5vDnYwwUCK3v8B63V5p/cYW7Lw//mP4ai5fz3Jsh3VBaRA
   h0tZUAxQgSJn1HcrmiOLuhXJeujdgYWIRQISyglDyuTEeOM2PrTedkqNg
   W6PRgL6lb8R/YenltvJj+ffttD8cgcI2mm7N7LpZRV9zwjPSTYS7o3AOT
   w==;
X-CSE-ConnectionGUID: 8xJuIGqdR26gZFV/bNripQ==
X-CSE-MsgGUID: jqGe+NjCSayDF1V9kTfQEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="95544385"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="95544385"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 01:03:56 -0700
X-CSE-ConnectionGUID: MPZHt2VzRWmAXUDWWjje9A==
X-CSE-MsgGUID: g0C7ZLN7SjiFoqcf59Yd3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="261008309"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.143])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 01:03:54 -0700
Date: Fri, 17 Jul 2026 11:03:51 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, metze@samba.org, gael.blivet@gmail.com,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] smb/server: fix signing when a response uses more
 than one iov
Message-ID: <alnh59UIBda8vwPp@ashevche-desk.local>
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
 <20260716001156.671587-2-chenxiaosong@chenxiaosong.com>
 <alk9-WOWQeHaq0wV@ashevche-desk.local>
 <7d806e83-2535-433d-8aa3-f8b452ecbb83@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d806e83-2535-433d-8aa3-f8b452ecbb83@chenxiaosong.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Jul 17, 2026 at 07:43:15AM +0800, ChenXiaoSong wrote:
> The warning is triggered only when invalid arguments are passed.

Can you elaborate? The second part is the same check as it's done in
the for-loop body. The first part checks if we ever go into that loop,
so the logic here is either we have an invalid input (we skip the loop)
or always true due to repetition of the check inside, meaning that
the loop passed without finding the match.

So, what's the point?

> 在 2026/7/17 4:24, Andy Shevchenko 写道:
> > > +	WARN_ON_ONCE(work->iov_idx < 1 ||
> > > +		     work->iov[work->iov_idx].iov_base != hdr);
> > The second part of this check is basically always true. What's the point?

-- 
With Best Regards,
Andy Shevchenko


