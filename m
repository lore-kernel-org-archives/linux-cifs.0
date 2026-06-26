Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BBE3CAA25;
	Fri, 26 Jun 2026 05:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782452977; cv=none; b=RliLwvDmBjl0HCRAqcTfE6Xg2vD5ZkLttw8Nhhlt9TzzY6RrKmVqyUcn+1LVj6nucbSADy9W/nx1ZEZfUxVTtRal6mDpmHTQv+94GZQxfjjpZmEi1I2IT4gXt/0WaNYVSUugwHqTL2p/8twfQRS+i6VlRMQeeXommzCSORmRaJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782452977; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJ14yahKRUrLTZA/B8i28hO9+dkNLXF9l2hdqXuN0e3FaI7G3riJyCEVLySA0FQDbiGUx/PAKU/Tvdb0Qp+qzMZEIJ8qGIIqdLKimZMsdlr/gQkL5lxGCvZ0yYVZWsCGqr4j5g3mfd6XHbHVgT5+2e2QbfhAjEKx3c/hGIlA4+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yPgc2cGE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yPgc2cGE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yPgc2cGELvOZET5vzxbs6+qnES
	sVPEnos9GQnDV4B7hMB1IBz3ZR1vHa6tqxXZ1kOEbhx29tiVGhZhe/bznnGOFrJWmCjkuDVYv1Z05
	C8hTGKc4UWRXp/H9gvTAGDY7Z4wG1dWihWWry3jpamycSDp36H/MhyabPkndxA4ou1+EOCDAOQDTt
	WLxRmbvNSnAlzbyExD9Ip0FP6F1Lbe359fcOX9iscgZFVmFCC8Qml59r1j5Yxmjo1vv+wcGRh0aNZ
	Lii5Y7jRdCH5dB1UYPycGBqgB5lZBaO+M9RCqzMVvEqnEngSKgYUkc0AA+19sJ93sbloUoNOs9eAy
	K2PJGidA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wczRR-0000000AXpI-2Kgp;
	Fri, 26 Jun 2026 05:49:29 +0000
Date: Thu, 25 Jun 2026 22:49:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
	Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>, Mike Marshall <hubcap@omnibond.com>
Subject: Re: [PATCH v3 05/15] iov_iter: Fix potential underflow in
 iov_iter_extract_xarray_pages()
Message-ID: <aj4S6Xyep3JIzokh@infradead.org>
References: <20260625140640.3116900-1-dhowells@redhat.com>
 <20260625140640.3116900-6-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625140640.3116900-6-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
