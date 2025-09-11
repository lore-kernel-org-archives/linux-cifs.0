Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9E52EC563
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757610624; cv=none; b=foM2bgrml6npVu/NzbdCJbUTzhu4UF1qZP7XcTA14Rqb8/wwwntpqwocEUInvscV5UAa2PJAFmiHB5QzuHf6yJBtoWRCTCijaBN24r1LzQhzIoGFMkU9Sc40OY8ehjM0VrReXybyJyWcr34rIvO3FX27VE/VmJTtJ99dSXxVLM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757610624; c=relaxed/simple;
	bh=xq6AVdMXIhTiXemcve1QB9d+vkHdIgJznN8RyqEEpHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUtzGUWBq2xZtAe4HZr7kIcgHURe80kSnOmEhBnqs58QRrZ7vw+xU+oOYOJ/IK4hlqwxdMAvRqmCokpv0fgzy8ZZsGqQMLzp9UYk2fd9Lif+ELaLOvNlyT6cfG5kkDj3dHsOmAHldZtV/qLmQAuODkvPGIzAlu2r+PMtyN65xrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikDgTG8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikDgTG8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF29C4CEF0;
	Thu, 11 Sep 2025 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757610622;
	bh=xq6AVdMXIhTiXemcve1QB9d+vkHdIgJznN8RyqEEpHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ikDgTG8Hv2c0H/Zy/gf3akavF158UB+0YK2E0QqD7c/TFCi45AwmnDtSow6RVz2Eo
	 jerJWUZLeATXv6PKKxp99bpYwWIa7gS1pvSW/YTFwZKLXKmrmZvQ6gc93RJ7X4tSaS
	 MToo1K0plfOwpRNYb9uqctobrn4SMzdTHgnpSu9k=
Date: Thu, 11 Sep 2025 19:10:20 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Steve French <smfrench@gmail.com>
Cc: yangerkun <yangerkun@huawei.com>, sfrench@samba.org, pc@manguebit.com,
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
	dhowells@redhat.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, stable@kernel.org,
	nspmangalore@gmail.com, ematsumiya@suse.de,
	yangerkun@huaweicloud.com
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
Message-ID: <2025091157-shallot-destruct-e20d@gregkh>
References: <20250911030120.1076413-1-yangerkun@huawei.com>
 <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
 <2025091109-happiness-cussed-d869@gregkh>
 <ff670765-d3e2-bc0a-5cef-c18757fe3ee0@huawei.com>
 <2025091157-imply-dugout-3b39@gregkh>
 <CAH2r5msDcEnbkGT3y7--Dbk5pWWyTnDg2PLO_R4WderLfC9Nnw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msDcEnbkGT3y7--Dbk5pWWyTnDg2PLO_R4WderLfC9Nnw@mail.gmail.com>

On Thu, Sep 11, 2025 at 11:40:08AM -0500, Steve French wrote:
> David and I discussed this today and this patch is MUCH safer than
> backporting the later (6.10) netfs changes which would be much larger
> and riskier to include (and presumably could affect code outside
> cifs.ko as well where this patch is narrowly targeted).
> 
> I am fine with this patch.from Yang for 6.6 stable

Great, thanks for reviewing this.  Yang, can you resubmit this with the
additional information so we can apply it?

thanks,

greg k-h
