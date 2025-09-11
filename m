Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E496311C2E
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608740; cv=none; b=KB+/g5VYDwoWIW8ZQQUouMXVLU7qi0a/KG+NSKSF2yOfh3okannSs3RaDAHXVPnY+FYZEnsGQNvKgikJw4/tpSxhlsZkoqrXt9/yKEYoLvZ+AGl9WwEUsm/bH/zN+qjlKLvZxceb6BLG9guhYjNmA9pBMU2GgeZJyYP34RqUy/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608740; c=relaxed/simple;
	bh=jabD4evrIVNHDgvxkAG/fGajnn05guxDQTab6p3HNG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/X579t7WX97kpU1g9vnB5JIIVhnCKGQgAwFRFq1NhrcjpLPlT4EwbK5lGP2x3ZC4fJ4+bB6AafG11LhpDJ+s2KSHLrnCFRM4ixpVr7e59jpiHnE4pMKfz6eVkSqfPkv8wv2tUOfGI1vv8kHbxowibk+dQX6Cba+1/Az9AF05Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0qpKMT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0qpKMT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5DCC4CEF5;
	Thu, 11 Sep 2025 16:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757608739;
	bh=jabD4evrIVNHDgvxkAG/fGajnn05guxDQTab6p3HNG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k0qpKMT1Zv0kn315eevQKSgyVOgdlmXRr3TRj+ucVk6+Jg1OMvQQRiggrDCPdQOEl
	 ABtYJxvrfrqeUdACMw+PoX4qdgdJ9I8lpDMPGd7akIiSVRoz85mkmgjMmeJsDg7wL7
	 wkCZEzYYHVEFaI/zDqbY81Zm1Vnp1SXjiTQ1yfWY=
Date: Thu, 11 Sep 2025 18:38:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: yangerkun <yangerkun@huawei.com>, sfrench@samba.org, pc@manguebit.com,
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	stable@kernel.org, nspmangalore@gmail.com, ematsumiya@suse.de,
	yangerkun@huaweicloud.com
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
Message-ID: <2025091139-control-reshape-638a@gregkh>
References: <2025091109-happiness-cussed-d869@gregkh>
 <20250911030120.1076413-1-yangerkun@huawei.com>
 <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
 <1955891.1757608316@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1955891.1757608316@warthog.procyon.org.uk>

On Thu, Sep 11, 2025 at 05:31:56PM +0100, David Howells wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > Yes, please include the info as to why this is not a backport from
> > upstream, and why it can only go into this one specific tree and get the
> > developers involved to agree with this.
> 
> Backporting the massive amount of changes to netfslib, fscache, cifs, afs, 9p,
> ceph and nfs would kind of diminish the notion that this is a stable
> kernel;-).

Ok, then that's a good reason why, let's document that!
