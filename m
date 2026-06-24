Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5D22D0610;
	Wed, 24 Jun 2026 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308518; cv=none; b=KW6Z/poX84kUht2tYxBVo9Lo6XJCmMyqCYkmKUdgIhkIqgYTCyJzImXFZmX3hnjOluo9ESTpWwwa7n0X3tfwEsWd+Y8RxZTIyFtUsmDSRF8W92i5wfqAKBxfIZjZK7Krt65VB9n7qldwW1YbEPoNuqXms57KCN6JZU4XFq01KCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308518; c=relaxed/simple;
	bh=SheNGxySSZFR34sI69EC4jiPSS+B72Nup1boVnATJt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZdySMQuW++Xq7VArYYAMhyNN1oOZZfewLi5Tebk3wHhiPDYJ/M2mVzEfqgLZdd7I9lgTLn0S2mV7m9NzYa9/xkZNqm168LWeB63uafDGwH57gbqoFE1RoRIFJ0h4WVIVCzeMy7hOIOM86Bl+iOvG46cvD9Q2yPhMLmckVQmbdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KqPZ6YNj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KqPZ6YNj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=H1U0u6SiNgbVgzpzyQOqt4lzeTrARqVNcvD9DmvYoss=; b=KqPZ6YNjk/rvXvQhAse49KYePu
	+cMs3EgDKNHyTN1mvGaII/IfEDegQho04qtvtbrIwHZTL0g2Yu/NO0LWKVesT1jQ7nI2Fi1FeJoIT
	azQTIYshbJf/EnES6ZXJ1u06xUgqIjwP+kLF9HnAACsaJByweDlEQ1qKr8zN82y2/vrwQyX2mjuK/
	MuhSRzc4iq3R2XTV4rjp0Bpt4DjiZBxRMe2wSC/PDt2W6RRfoXMd47OvKRhLzRxvEJUAHNBn1ymG9
	1blLfKtEOKOlLvCD81e10sTjUejaMwDQeyQ07meYXvQibDNKbEXpESRnzmiC+G2wP0z0ul2EM4D2g
	JaneOEag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcNrW-00000007q2F-2klZ;
	Wed, 24 Jun 2026 13:41:54 +0000
Date: Wed, 24 Jun 2026 06:41:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
	Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Mike Marshall <hubcap@omnibond.com>
Subject: Re: [PATCH v2 04/14] iov_iter: Fix potential underflow in
 iov_iter_extract_xarray_pages()
Message-ID: <ajveoo1Z-XdRprS-@infradead.org>
References: <20260624115737.2964520-1-dhowells@redhat.com>
 <20260624115737.2964520-5-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624115737.2964520-5-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

FYI, I'm getting 5 patches out of apparently 14 patch series and no
cover letter the second time now.  No idea who I'm supposed to review
this.

