Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C383176EF
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 11:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757589465; cv=none; b=oqhOX+9kPqNYFCNTxMW4KAD1VBBhrObjoUePXBm343yfq837isnVo7wO6L1iiq4ET4h2hrI5rg3nJYKUOtvExvDcdSi2P/s00eCRFG83fK5Yea3eOWeQvOD75t4DnINBu99lvWBWU6AUuc2XiDY27OETrcdWAz+4K4zlm4dw7F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757589465; c=relaxed/simple;
	bh=h7ATuwvAVEZXeXxFG4v+dFwyURLgLFmIbitKRlfbcnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VcivXnitT27ZnhPIovgctHAnNIXF1r/XXgEd6QjAunqg2Buk5oQSBeEtVfdEKGytdHRmLbrJp5JaVrttGt5DH6kBqIc0BI4py6W6NJqtDNT8Ql2hzTblRNPBkc8wIb+crny18eDDf3rn8cSah1iI4xAIHOd6UT5npLNJxDld+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CExy9PYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CExy9PYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E57C4CEF0;
	Thu, 11 Sep 2025 11:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757589465;
	bh=h7ATuwvAVEZXeXxFG4v+dFwyURLgLFmIbitKRlfbcnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CExy9PYKYrPq06JYCrSiOu6SZmh+QQZc1qxABh/JEerqfImtkU5jTYKdrWSgj/Y7E
	 8HoeRkP9HPlQOmtt1V6yAsg8ph3bngMWGrRAqYOsN/s0u/y5s/i8TCqc8m4Igy3tyF
	 q9t4wrWWTWvfmBEPKAT6EmHoAg/I4C+23qb64a7I=
Date: Thu, 11 Sep 2025 13:17:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: yangerkun <yangerkun@huawei.com>
Cc: sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
	sprasad@microsoft.com, tom@talpey.com, dhowells@redhat.com,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	stable@kernel.org, nspmangalore@gmail.com, ematsumiya@suse.de,
	yangerkun@huaweicloud.com
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
Message-ID: <2025091157-imply-dugout-3b39@gregkh>
References: <20250911030120.1076413-1-yangerkun@huawei.com>
 <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
 <2025091109-happiness-cussed-d869@gregkh>
 <ff670765-d3e2-bc0a-5cef-c18757fe3ee0@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff670765-d3e2-bc0a-5cef-c18757fe3ee0@huawei.com>

On Thu, Sep 11, 2025 at 07:09:30PM +0800, yangerkun wrote:
> 
> 
> 在 2025/9/11 18:53, Greg KH 写道:
> > On Thu, Sep 11, 2025 at 11:22:57AM +0800, yangerkun wrote:
> > > Hello,
> > > 
> > > In stable version 6.6, IO operations for CIFS cause system memory leaks
> > > shortly after starting; our test case triggers this issue, and other users
> > > have reported it as well [1].
> > > 
> > > This problem does not occur in the mainline kernel after commit 3ee1a1fc3981
> > > ("cifs: Cut over to using netfslib") (v6.10-rc1), but backporting this fix
> > > to stable versions 6.6 through 6.9 is challenging. Therefore, I have decided
> > > to address the issue with a separate patch.
> > > 
> > > Hi Greg,
> > > 
> > > I have reviewed [2] to understand the process for submitting patches to
> > > stable branches. However, this patch may not fit their criteria since it is
> > > not a backport from mainline. Is there anything else I should do to make
> > > this patch appear more formal?
> > 
> > Yes, please include the info as to why this is not a backport from
> > upstream, and why it can only go into this one specific tree and get the
> > developers involved to agree with this.
> 
> Alright, the reason I favor this single patch is that the mainline solution
> involves a major refactor [1] to change the I/O path to netfslib.
> Backporting it would cause many conflicts, and such a large patch set would
> introduce numerous KABI changes. Therefore, this single patch is provided
> here instead...

There is no stable kernel api, sorry, that is not a valid reason.  And
we've taken large patch sets in the past.

But if you can get the maintainers of the code to agree that this is the
best solution, we'll be glad to take it.

thanks,

greg k-h
