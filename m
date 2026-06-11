Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290042EEE76;
	Thu, 11 Jun 2026 16:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781195864; cv=none; b=r+TvMUW6KkSyU7CpmOil/2ND06AJ5LVNNACitMPM3WmaeAYJgNNDyFEppNcBobE1GrDMd3fgXlG+ftU0j0GTSDkBNCHv7QgbTL9MCcrj1wTWldwYZoSkXDw7Nv5QfN5o4rzqsNgcwelARp0I9FOOR5w4QV3ihb80ISZF88LqtMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781195864; c=relaxed/simple;
	bh=EX/srIKOg+Hk1+KF2S5xseAjGQf+OJxX7IWergv49ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7/adRa+zg/uxWumN7B3YJJBYyCMi2ncu64YlumeH4Yv39LnSQb5JsE8NmyyJHlYwZX/8DAFsNbCB++7rhrIhrCIcnLKPn6ABXnL4GrShrrQSvFKG8sSnwIKni6CGjKgKYZpSZp+Iz2GCccKhS1qAPE+i6Qvd5XF9KHj+QI+eAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Ec1680Jc; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Ec1680Jc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RQdjEqQFdXM28Z7LFRzPSwwRncXEeuLQgbmf3ywKZHk=; b=Ec1680Jclw2zxeno1f1AyL5IEp
	lUiDxh8AVXRLOMdmcmZrhpE5XvolyCFWLW+oi1Gtfw9Ca3CpFxxJ2W33I8JKeIU+KPKtQk5fiFE8I
	gw00HBGjA1ZBeYpWA/wNcVdpceZiUGPHD/P2kYBblSxWrp9UKszWv6hN/OyNFIXvSDS9kVYMXql1N
	7Akn+WbZkE2EG9yqxS3FG/1N2yWY1o5c+n6oHuhPo3H8Zi5XwHlI07ek0o2PswTSrshTRiLHVFd+Z
	R0t7kO6uiZ7nRFl8/66g/0bu/Cz3CNsgBSetsMv3E2SWpmfZljlQS1jxDRMCQL4dczAaYh1i4Jrjm
	6IIFGRmA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiPQ-00000006laO-0Jll;
	Thu, 11 Jun 2026 16:37:36 +0000
Date: Thu, 11 Jun 2026 17:37:36 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>,
	NeilBrown <neil@brown.name>, Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
Message-ID: <20260611163736.GM2636677@ZenIV>
References: <20260611145733.43776-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611145733.43776-1-jkoolstra@xs4all.nl>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Thu, Jun 11, 2026 at 04:57:06PM +0200, Jori Koolstra wrote:
> There is a comment in vfs_prepare_mode() that says:
> 
>   Note that it's currently valid for @type to be 0 if a directory is
>   created. Filesystems raise that flag individually and we need to check
>   whether each filesystem can deal with receiving S_IFDIR from the vfs
>   before we enforce a non-zero type.
> 
> This is a bit challenging since there are many filesystems. Claude Opus
> 4.8 was used to generate the context for each mkdir implementation from
> which it can be judged whether passing S_IFDIR is safe. The result was
> then verified by hand by looking at how the mode argument is used in
> each case. To check whether all mkdir implementations are convered,
> 'rg "\.mkdir" ' was used and checked against the list of uses Claude
> found.
> 
> The only mkdir implementation that I am not as sure of is
> cifs_mkdir(). So this goes cc to the cifs people. But of course, I might
> have made errors in other places (except probably not for the A list as
> those are all just mode | S_IFDIR cases without other uses of mode
> besides logging)

There's a missing bit here: what's the point?
