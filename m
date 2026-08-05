Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3836F3AAF53
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 07:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785915975; cv=none; b=FdGxAQ2QxagfnzrEI4aVPwSfrESRM1TaxRMxcU8sj6MhEgI4Nq7zTYcg4YClLY1ZYXT86aLPlSpKGPDKpWFcUoolSN04S9wz7kAQbOYxKaDYfTr2BttXdaEqKHrC0X6O8LY6ckFhLwIIU3GisUJIs/R9jKIM6O/VdFcAAWH60+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785915975; c=relaxed/simple;
	bh=ECxIWhNTO8GQc16u12b8/KRqgWV6TnAIzpZTfzKiciY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o6m2l35ei29hlMXM9OJsRMzDqIZBsyWoVsQvjR95bY4ConqzEHfp31JfNiMaxIy6WJUCDIQaVgr7gVrWB9I8plsF50Bwy9vn828iv/NP/ymVlYOJveHAATzS2VRBoOVVL1d/9ryS67dy4qrokH97CGS5U50gv+wWGI1RqxqgAp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V18Wv5F9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V18Wv5F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3551B1F000E9;
	Wed,  5 Aug 2026 07:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785915972;
	bh=4ZI/z31UzXBEH4m76rpPEtyRHyUhGdxreUmhxc4jBpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V18Wv5F92ReAtgop96yB59XFz9i/WGqNrRD9b4aWDXVINswKNr2k/LqOigffx8Etp
	 1huzCvdPMht8PQt51JZXRgW7fAVkhC79OSswfpIr226zI2qUUH5STzLsfG+yhn24zv
	 LakZ65X/JVyMUx9ojObFNsiqZE+hMfbLIYMChcac=
Date: Wed, 5 Aug 2026 09:45:55 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: khj <hj351016@gmail.com>
Cc: CVE Request <CVE-Request@mitre.org>, cve@kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: CVE-2025-38728: Request to add Bugzilla 218602 as a reference
Message-ID: <2026080527-sequel-moonscape-0ac0@gregkh>
References: <CAGr5VtPLAy_N0N4kE5TDndMr3zYukVXDHD49AfToGoa-vMk24A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr5VtPLAy_N0N4kE5TDndMr3zYukVXDHD49AfToGoa-vMk24A@mail.gmail.com>

On Wed, Aug 05, 2026 at 04:30:15PM +0900, khj wrote:
> Hello Linux Kernel CVE Team,

Did you send this twice?

And no need to bother MITRE for normal CNA stuff that we can easily
handle.

> I would like to request a reference update for CVE-2025-38728.
> 
> I am not requesting a new CVE ID, reassignment, or reporter
> attribution. I am only requesting that the following public Linux
> Kernel Bugzilla report be added to the References section of the CVE
> record:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=218602
> 
> Bugzilla 218602 was reported on March 15, 2024. It describes the
> missing bounds validation in parse_server_interfaces(), specifically
> that the server-controlled Next value can exceed bytes_left before the
> pointer is advanced and the value is subtracted.
> 
> The fix associated with CVE-2025-38728 adds the corresponding
> validation that rejects a Next value larger than bytes_left:
> 
> https://git.kernel.org/stable/c/7d34ec36abb84fdfb6632a0f2cbda90379ae21fc
> 
> Could you please review whether Bugzilla 218602 can be added as a
> reference to CVE-2025-38728?

It looks like might be the same issue, but it might not be.  We would
need the cifs maintainers to confirm this or not.

If they do confirm it, great, please send us a patch for the vulns.git
repo on git.kernel.org that adds this as a reference for that CVE entry,
as documented in the cve/schema file.

thanks,

greg k-h
