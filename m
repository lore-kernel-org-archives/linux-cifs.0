Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF0F330D34
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 20:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784233473; cv=none; b=KCdzSgaTTZNbMw1VO//KlfSiXPwYKf9umxD6t2we0cGA7nzg22+1US6l3tpvFmigsnuEzU0DK5jzqGL2kiHB/O02ZVAKlMPVJ7gaqDYYBMpJNEmisaTxjGZP9VBaKMeV63WyMK5ZP7l/MF37n8TNiJkd1dCacxzD4nzJCuFY7M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784233473; c=relaxed/simple;
	bh=08CGPI/5kIcllDq0Kq72++xeicSn1hZcZgUCquRhsEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdeSoF7V8rrp/NbZE2QcAcRia/RCjTW/1sVz2imSOE+nQlkB1QUg4785fSO9MjgCnh2gfdXePNGnD29EkZQ94oKML047coUW9++uq7kqoUWl3G95fXOs1KbJCmK2mBM6Fg/1e/Vd/C8O6CuzAAHilsdjQB9NtdEdhgL7B46pp6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RcB19yfn; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RcB19yfn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784233472; x=1815769472;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=08CGPI/5kIcllDq0Kq72++xeicSn1hZcZgUCquRhsEY=;
  b=RcB19yfnLzLOQru7VexsNDc5ES+1bSxZ/5HieekZmdh8YNND/Mdr3XMe
   YwiUq9WmZC/AhZ25HhBuhEgEzLxG515jPGlU424hJYPj6BMAGoevMiBSi
   /U15qEqxXlO7Nrngyil8KNIS2V/pBdFModcrFeSQH+ig9Vp1UIur5n6/R
   Z2cHklA6KMntGPmzpW+iguvzcjMxQF8rlODnrgpQfXL9urPNC81OmlcQH
   aov6nctuBqBC7HYRMs6S1/VZ5aT9umd/PUX7l3uXEwWIt7SxuF4iuG00s
   OkS/rcakW4gk2BBOE/9f5WiWw0y7A8oT7xSpKhnsonWgXWDwVzmDotgJ0
   g==;
X-CSE-ConnectionGUID: LyppIYvOSqSTNN9BCLstnw==
X-CSE-MsgGUID: QeyGhiN3SP6CuFgVb2S0vA==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84949299"
X-IronPort-AV: E=Sophos;i="6.25,168,1779174000"; 
   d="scan'208";a="84949299"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 13:24:31 -0700
X-CSE-ConnectionGUID: fWtSydooR+WhQ2NttFxGmw==
X-CSE-MsgGUID: YsHZs7F7TCWyjx9ZNKY6mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,168,1779174000"; 
   d="scan'208";a="260895121"
Received: from conormcd-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.245.26])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 13:24:28 -0700
Date: Thu, 16 Jul 2026 23:24:25 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, metze@samba.org, gael.blivet@gmail.com,
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v2 1/3] smb/server: fix signing when a response uses more
 than one iov
Message-ID: <alk9-WOWQeHaq0wV@ashevche-desk.local>
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
 <20260716001156.671587-2-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716001156.671587-2-chenxiaosong@chenxiaosong.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Jul 16, 2026 at 12:11:54AM +0000, ChenXiaoSong wrote:

> Some SMB responses keep their data in another buffer. The SMB header
> and the data are then in different iovs.
> 
> The old code only handled this for SMB2 READ. For other commands, it
> signed only the last iov. QUERY_INFO and CHANGE_NOTIFY can also use
> another iov for their data. Their SMB header was not signed, so Windows
> will client rejected the response.
> 
> Find the iov that starts with the current SMB header. Sign this iov and
> all iovs after it.

...

> +static struct kvec *smb2_get_sign_rsp_iov(struct ksmbd_work *work,
> +					   struct smb2_hdr *hdr, int *n_vec)
> +{

> +	int i;

This is not addressed, why?

> +	/*
> +	 * iov[0] has the RFC1002 message length. It is not part of the SMB2
> +	 * message, so do not sign it.
> +	 */
> +	for (i = 1; i <= work->iov_idx; i++) {
> +		if (work->iov[i].iov_base == hdr) {
> +			*n_vec = work->iov_idx - i + 1;
> +			return &work->iov[i];
> +		}
> +	}
> +
> +	WARN_ON_ONCE(work->iov_idx < 1 ||
> +		     work->iov[work->iov_idx].iov_base != hdr);

The second part of this check is basically always true. What's the point?

> +	*n_vec = 1;
> +	return &work->iov[work->iov_idx];
> +}

-- 
With Best Regards,
Andy Shevchenko


