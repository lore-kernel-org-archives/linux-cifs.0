Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08D336F433
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 14:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125519; cv=none; b=rljHAN5+n3ondSZ+2bBljhaBZWCTEuyIjsul2dKjmqTj6mQTjniqTyL5eZpnhO2UQhqbxpjiLdWe8II2FExJ5GIFsu0Xlx1Vinby8yEPfQ20KF5Nlg4fMmT15IWNm6GiAxifDRlE2gEo2CE4Uc5yuJnMGS1Z9z/93VUO4lJnlzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125519; c=relaxed/simple;
	bh=G4nQQmXl8z25z4TY653JugbjdLP4WwD6jndTi4/tAW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7b4XaTZm9AN2uKgVDQf7txsJNqSl70M3l3JUk83ZLCQ80qP63X6+HMmLedr/l0NUSD10DthuTpMihixp9JJcgFi+BSII0V1O86asgswyS092oEqi37e7hmdSd3D5O7bfnp5RAe8KziJ0fRS9AYAu7MNo1MO28dKDq3vPtDBYDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D7K0YDDf; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D7K0YDDf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784125516; x=1815661516;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G4nQQmXl8z25z4TY653JugbjdLP4WwD6jndTi4/tAW0=;
  b=D7K0YDDflR7Cfj6IPIbyJTzLRPx9NrVKGC8n5NuMfAZIdCMvH3TB2jev
   EuYjl/0s0NS3S+vapWauPNQl7dpNBm6+C0L7u7VySvnyWjfxFMDewbJyN
   Fm+HWCl5wFJF9NoRthMbBmUSSO91BlfF9ZH5+qkoxabUEiuw9+qlsyN5w
   Ydfnr+guOg1hdKz+SpLsQExClJ87kS7eK9aEpS3L45eIOIZupdOBvTkjX
   4QhZXLt6zVlq1vYLdWnkb0Yv/53kKW4/vauLqt6PeiZHqtT1VXZ/Uu10K
   kGssHDRm9+nkZWJWyqoh5KrWdr5riaAgC6/BUw+mUN+VZHaLfmrkwfAPu
   g==;
X-CSE-ConnectionGUID: 5ID7FZb3RDGgwPpG5gjUfg==
X-CSE-MsgGUID: cIgrWExgSgCSkhleliNOoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84804024"
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="84804024"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 07:25:15 -0700
X-CSE-ConnectionGUID: pJmiW6XaRb+qy/eeub/pCw==
X-CSE-MsgGUID: 0tRTbj5KQhuhxSN3tl4vUA==
X-ExtLoop1: 1
Received: from mkosciow-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.129])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 07:25:12 -0700
Date: Wed, 15 Jul 2026 17:25:10 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH 1/3] smb/server: fix signing when a response uses more
 than one iov
Message-ID: <aleYRhKFI_cdGkC2@ashevche-desk.local>
References: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
 <20260715135513.667260-2-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715135513.667260-2-chenxiaosong@chenxiaosong.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Jul 15, 2026 at 01:55:11PM +0000, ChenXiaoSong wrote:

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
> +
> +	/*
> +	 * iov[0] has the RFC1002 message length. It is not part of the SMB2
> +	 * message, so do not sign it.
> +	 */

> +	for (i = 1; i <= work->iov_idx; i++) {

	for (int i = 1; i <= work->iov_idx; i++) {

(or even unsigned int). This style is preferred as long as iterator is local
to the loop.

> +		if (work->iov[i].iov_base == hdr) {
> +			*n_vec = work->iov_idx - i + 1;
> +			return &work->iov[i];
> +		}
> +	}
> +
> +	WARN_ON_ONCE(work->iov_idx < 1 ||
> +		     work->iov[work->iov_idx].iov_base != hdr);
> +	*n_vec = 1;
> +	return &work->iov[work->iov_idx];
> +}

-- 
With Best Regards,
Andy Shevchenko


