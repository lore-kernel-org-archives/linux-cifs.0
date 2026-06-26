Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB7E3C9ECF;
	Fri, 26 Jun 2026 05:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782453006; cv=none; b=L5JugQr4FzAfUKkmxP5ZyCdz4tkuheXBXAdvVyp4pPThSnVK18KjiNteg7fI0zw+n8peLjzghTTzEHR2jNo375xdMZMQq2cYpSUxAo+keiTeuJeMhOwLYxqUeL8xJaqDbs+b0NGeXHQeYZwq7Hd1n7MA9LkycZbBi8KeUKUUhqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782453006; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oHwdiGfIrahtqIkEPmtVzRXgjYygFyRSVJeQabohVMspzOk80l6MgxWnarcGJpHjYXCpQs4Epudxn+vMr2AJk84CwNYPPO94Nq+qNS9F21uq0pCVeQ2AWzWcm6++/ekeVFvgfk5rNy3DHRGGFnk3XgCpa9xoEPFT6RxXFsfV5pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o46oXw7V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o46oXw7V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=o46oXw7VeFZfhwuo+lEZRhasMj
	SKkyr/ET6qe/d0LfansBQSGNfUpw2eKhdMYIsQV74WE9if3NE2ogoNkhwkO8l8/Oqhmi19DM3iDmt
	/DoKKS/slHwdUNi6SW11wLDWbgV7+SMLsLJngI9DjjzjvKQNOSvW7y3wWs77rOD+ofjf53+cwJxCD
	0Pl+zVAcvai6J+mcKbDciuaLxIARmItwFVib9JeL1FHTf06zE5Eo2eVnS6wv+D9QL1mVSY+gCgu/X
	VNCS+tmWNKlrmPq6qWDO6utqlDZuQLMe7SjC1r4+5RJ3C7E01mpwhMeZo925UDViqy8ah3iKw8HHy
	TYpA/c+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wczRy-0000000AXt6-1YeK;
	Fri, 26 Jun 2026 05:50:02 +0000
Date: Thu, 25 Jun 2026 22:50:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
	Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 06/15] iov_iter: Fix missing alloc fail check in
 iov_iter_extract_bvec_pages()
Message-ID: <aj4TCqhu2RPN1Fdr@infradead.org>
References: <20260625140640.3116900-1-dhowells@redhat.com>
 <20260625140640.3116900-7-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625140640.3116900-7-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

