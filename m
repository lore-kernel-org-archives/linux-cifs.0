Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C4830C354
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 10:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757588035; cv=none; b=QyABiEq8v6mDBDFp5W/kiSiw5aAGb6ajr9LSbp6Lum0kTI0skfCTETP5ZkHrBBVE3dg3pRD++LLxpQGRvLErOXdnJkxIEgfN3W5YsSiQPSt/G3JcILnT7aEd6fxJeMSxRmXUxx2/EHuKz90sl32k4MB7+f/wzJYOs2Mdu6kwkA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757588035; c=relaxed/simple;
	bh=xBgRbcEf1jUGaYUUkkMJ67wiqUV+2ZbF9CIx1xzZxns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=quZTgpH5s2RCa/hGC/MS7mAEkSXV4hBhc5YAtoVE00Go3H+RBoeSmnALBVC00zDN0xk0xI06hEfKvKzG7BdeoyiB5xuJ8FLWuDohrs+sJuOI6Y8xcn4+9pae8XnrbPeYLPymdrY+uhnVmMkjyaIUpMFEsi5H+zfhtBIBjkAf4lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyV/XZMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyV/XZMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876B3C4CEF0;
	Thu, 11 Sep 2025 10:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757588035;
	bh=xBgRbcEf1jUGaYUUkkMJ67wiqUV+2ZbF9CIx1xzZxns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MyV/XZMrhksmwS5oMXrqhYDFnvGlQI8ZexOpN/HVu/eIQnbYN6nSDKuO2uuWm3iuq
	 Ix2q5fc0FnMgCDavVY3lHHWfPGIzlIs24mAuanOfInMqcp+SofPNLGBozhSrxCS8X8
	 JduhNX/+p4Ukzi7sV+ifcNeOlF15Mwtx1ieuNkfg=
Date: Thu, 11 Sep 2025 12:53:52 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: yangerkun <yangerkun@huawei.com>
Cc: sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
	sprasad@microsoft.com, tom@talpey.com, dhowells@redhat.com,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	stable@kernel.org, nspmangalore@gmail.com, ematsumiya@suse.de,
	yangerkun@huaweicloud.com
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
Message-ID: <2025091109-happiness-cussed-d869@gregkh>
References: <20250911030120.1076413-1-yangerkun@huawei.com>
 <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>

On Thu, Sep 11, 2025 at 11:22:57AM +0800, yangerkun wrote:
> Hello,
> 
> In stable version 6.6, IO operations for CIFS cause system memory leaks
> shortly after starting; our test case triggers this issue, and other users
> have reported it as well [1].
> 
> This problem does not occur in the mainline kernel after commit 3ee1a1fc3981
> ("cifs: Cut over to using netfslib") (v6.10-rc1), but backporting this fix
> to stable versions 6.6 through 6.9 is challenging. Therefore, I have decided
> to address the issue with a separate patch.
> 
> Hi Greg,
> 
> I have reviewed [2] to understand the process for submitting patches to
> stable branches. However, this patch may not fit their criteria since it is
> not a backport from mainline. Is there anything else I should do to make
> this patch appear more formal?

Yes, please include the info as to why this is not a backport from
upstream, and why it can only go into this one specific tree and get the
developers involved to agree with this.

But why not submit the upstream changes instead?  That should be much
simpler and is always preferred as that way the code can be maintained
easier over time.  Whenever we have these one-off changes, they are
almost always wrong and incur additional development efforts for future
changes in the same area.

So please, do the backports first.

thanks,

greg k-h
