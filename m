Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4123A1A2
	for <linux-cifs@vger.kernel.org>; Wed, 21 Feb 2024 06:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708497872; cv=none; b=HjUXz2lpzvKOHs0boXFLUKN20uyVoyq4yvYJhVfUQ8phzMJBbxT6zi4hbLFUnkErcZV49S4zE7zCuDRBvEZ4xcJX3MH54XYOvQpCYqrEIB5sbzIfo9AoAKExr7LYjb3FrYhuII8z1bS428F09s++3nfPVdfRmuJefPWe1NATWjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708497872; c=relaxed/simple;
	bh=QKVvTgHIxkiut4H3YUnebGlJKJAV21vFUQ4LN4MaJ88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpneoF8PTU6gwwm+dcbEm6T0u/RT2gvH3w4umGpx8uTVqhyWrC5aibLtLs2LTPwJPHVLvzUQqNZ4A6YX7+2M8qnUAWoFHMbDd5VZZlZV0ltipEcWROZsFky26xZhebXIdEEWbKYC8+S1Sm9Si6e989TLvIluCA9GI9NfShoLHPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i+QORqq+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i+QORqq+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZNe5UYtEAKaOyQgx0D9ol8UHBXigCfNJnCbnwQvRoYI=; b=i+QORqq+LynV7pwvO6WT8UUzCq
	nCGVjPK02tr9UKgAwkmO4NBdQGRQe9sfQd+GnmufqBuJk2t1OFIJj15ka85WPRQIvcYYKeBjGEvyn
	RjB2/RG+jT9xo1mjWbC4X051e53OwCIjd9MpIn6hEr3e8cymaX4b89DRJXuLbWGjhKK+BqeVYS5bv
	3Ua+H0uo/FwaFCPmZtfTgLk4SQc37QVnActI6+iZc0U8jIWF3cVRibnGwmP9H/g/qhgrtFWitZMXq
	QwqpswoY+lYCcPKAAKjoFPCQgN4Og1dH2S5GZtlCETGj0qTd237CQfcgBGswRr06GHIRnOQpqDMin
	BT+ea/1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcgLG-0000000HMlB-1WP2;
	Wed, 21 Feb 2024 06:44:30 +0000
Date: Tue, 20 Feb 2024 22:44:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] ksmbd: replace generic_fillattr with vfs_getattr
Message-ID: <ZdWbzllIWD0zmzB5@infradead.org>
References: <20240220142601.3624584-1-mmakassikis@freebox.fr>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220142601.3624584-1-mmakassikis@freebox.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 20, 2024 at 03:26:00PM +0100, Marios Makassikis wrote:
> Use vfs_getattr instead of generic_fillattr in order to call the
> fs-specific ->getattr if it exists.
> vfs_getattr can return an error, so adapt functions to return the
> error to the caller.
> 
> This fixes incorrectly filled AllocationSize field in SMB responses
> for files on XFS-backed shares.

Nothing XFS-specific here.  Using generic_fillattr outside of a
->getattr implementation is simply wrong and code must use
->getattr to retrieve stat information from outside the file system.

The code changes looks good to me.
