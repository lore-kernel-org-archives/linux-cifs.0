Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6598D37F00A
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125626; cv=none; b=Zn+3FCDyaAfaxAwIUPg2G6vDF3TwJymJrRqav3usvrvBhKlazBERXwPbm0VK/oymOlRmS4JSghKspeGOXWnWhz5yVciey9Qg75Kn1SXNdn5z3siBZ4F1AAkx/q/9L+Qhv1y1smTrq6cV5dWp+3iyOaIENCM+oXr1nx82nAgeJIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125626; c=relaxed/simple;
	bh=L9Dczkb0mAYvE1jAmUs6Ae9DFXEroYEEY6hMZ9fnRBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9AaSlJWtoQM+90WiISYyD7n4nYTw0OVRIELdh/TNZm8934QFJaatZQe6PlsCCSbBRnzBysldzq/6h3FhYHAC6cejNruX9DM/BGllm13A6PwUR4arEo5P4HAhAUz0onpH33ACloUbCeQFXgQVMBSYsIhJfvw1h71tvAxVL5jZn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hsMM6xdw; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hsMM6xdw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784125625; x=1815661625;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L9Dczkb0mAYvE1jAmUs6Ae9DFXEroYEEY6hMZ9fnRBM=;
  b=hsMM6xdwx9tEfe5ENmDvYp/uB4zalCefPycR/Qp1VgVUcqL6jsY5BN/c
   sZVLr+mqL+TohvDBfBBCw+xXmfpXAic9rR/5f9F3w5nG0NhWyHolIhgtT
   V5rTst1jiJdn0LOS+8GzV17kV283a42pMLEA1x/4LhZ5D2IyBw3Zx0by0
   QQEVPi03yVgJjy34Pm3AbK/u2Bn7tLjID2Poun/Kqs7kr/JknbPE+YGE+
   nBWYF4hWeHRK+90WEZAy/SeFCpb2LJHV3eEUqX7x5DE8+4uOwXZek9M1q
   wyG54aQw01A89N8LGJDkmE5KIYJS0mvg36dvP/I6oBipANORcg7mLeuJB
   A==;
X-CSE-ConnectionGUID: I68tCFJrSU+2EQurDOlvZQ==
X-CSE-MsgGUID: mRioTibiQQmP36Y3a/ZWfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="88592158"
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="88592158"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 07:27:05 -0700
X-CSE-ConnectionGUID: qlfiLvjVQequMd68ftprrA==
X-CSE-MsgGUID: l+qBwBPHTtqhbkl5I3fyWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="260505821"
Received: from mkosciow-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.129])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 07:27:01 -0700
Date: Wed, 15 Jul 2026 17:26:59 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH 2/3] smb/server: cancel async requests when closing
 connection
Message-ID: <aleYs2SlElRCfEMO@ashevche-desk.local>
References: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
 <20260715135513.667260-3-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715135513.667260-3-chenxiaosong@chenxiaosong.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Jul 15, 2026 at 01:55:12PM +0000, ChenXiaoSong wrote:

> An async request may still be waiting when a connection is closed.
> This can stop the connection from closing.
> 
> Cancel active async requests before waiting for them to finish.

...

> +static void ksmbd_conn_cancel_async_requests(struct ksmbd_conn *conn)
> +{
> +	struct ksmbd_work *work;
> +
> +	ksmbd_debug(CONN, "Cancel pending async requests on releasing connection\n");
> +	spin_lock(&conn->request_lock);

> +	list_for_each_entry(work, &conn->async_requests,
> +			    async_request_entry) {

It's perfectly a single line. Note, the strict mode is 80 characters
(inclusive), this line even one less, id est 79 characters.

> +		if (work->state != KSMBD_WORK_ACTIVE)
> +			continue;
> +
> +		ksmbd_debug(CONN, "Cancel async request id %d\n",
> +			    work->async_id);
> +		work->state = KSMBD_WORK_CANCELLED;
> +		if (work->cancel_fn)
> +			work->cancel_fn(work->cancel_argv);
> +	}
> +	spin_unlock(&conn->request_lock);
> +}

-- 
With Best Regards,
Andy Shevchenko


