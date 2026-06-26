Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E829C3CA4BB;
	Fri, 26 Jun 2026 05:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782453032; cv=none; b=RJ3eDjdhhW0uN6Otu8brObQ+vJ01CnG8ddZkHbFKR2arbL7XzF6ofigwFNwFxC6t60rIfFJ0a10MYhdnkRqeMaBW1G3r4Nkwyx7IFOU4pqeV0O13K4LQv+5FAzE3qp4G0ZBkjnXKrMX4OjxGmZKKgGfQl2sA4bIYijGFDM+tsJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782453032; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eA440jayEPi0ugRfwMviKx3bfDjo5KqYitb1iQBgFECXwWH+YJPQNGLFc6xi468UAS1uGiV92kNZl3gNqEeaoxdPDaeWXPBykInfPIVA8AyObW8A0n5GzM+VE/cZ0duh/lkHW8uUbUcdzp4S4/5iXjGmspo+6NNIXjxO/JUGukc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hTtqFe3Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hTtqFe3Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hTtqFe3Z9KJJxasEaPx6P7R9KN
	YpfFj0nZKH9I0UogzFz6WtqzhTUk3FoQgOZHYPXhN92KDNfOZXUn/9O4Q9p9vtaj5GoLw50pt3vyg
	Q5aq4iKSAt5Zu7sjArBNOeVCkLiteC8DkOvb09C19S5qmz5Nsrqd/sIWQe04V7v5RCIZoptQbb2dS
	e2D7wixEntNYqZVkiEOJy9Gc5x3GOFaWlYti5swZJ/sKeTXJonOnSmQ1FOkW8PSRR8QT+dnWSY1xq
	IqC9xRODV5iBoFMkbuREMurKnZFaNaXrzWJr5L0jPYOOideplwElUhILsT3iH7zk3bWXbdlQgKPJ6
	NLgV6CDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wczSP-0000000AXwZ-2VsM;
	Fri, 26 Jun 2026 05:50:29 +0000
Date: Thu, 25 Jun 2026 22:50:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
	Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 07/15] iov_iter: Fix a memory leak in
 iov_iter_extract_user_pages()
Message-ID: <aj4TJQmhwvGsBZvo@infradead.org>
References: <20260625140640.3116900-1-dhowells@redhat.com>
 <20260625140640.3116900-8-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625140640.3116900-8-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

