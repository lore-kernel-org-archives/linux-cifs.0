Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A8F3CCFD2;
	Fri, 26 Jun 2026 05:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782453092; cv=none; b=W5ruqo2fjYO0JaWMZMoa18l2jwioTHnS66pneMS2FigzNcNMDSiCAjIFBnD4NeSt+N/e7ZYl6oKENkSr/j6zwZDyEKFKiUU/PRF0JxL2dmLfoWvjWBRZmvVTboTFVON4Em8UGmTah04nF63SZRUQtC0+rsGq+nEmLMOAK8yXdx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782453092; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNAuzVAaTthP665NnkHBP91Y9xXIyjOwpbl0fAZadjaxdRTRoRnwX9yTrlLFG9JXsgdlx1KcX4MkdHW3BBVvFJK0D61cwQwfaMLkLjk3lTMyoFasq8wrZkSnCi2HO9LRGemH/3MLPVsFF0vUbAtTv3ilUBheJfxwGIwh/Vlfi1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0ZHC0+B+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0ZHC0+B+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0ZHC0+B+lPjN88YhavswidF6bT
	NIyI6YBd0C1pRtoNxaGgbOTNnMdVPVvsjikn5dyUz5ADCOjsyCgErIa8W9B5tEp3hpnxgb7Ye/LDl
	K/OLAJF0rsgFwJ8zN3sUUGIvrf5DxrfQw2kkaXyXSnjy+IXOiXuv3jtt7iW/uGzXb1IiUcF6lpfR2
	qIEc80y4LyEbgA+ya+/tyZy737Fswi4puDqlGS5ABNtyoi4K6xfBnmUwH6PFQWe1xLAvUqYSMFnAo
	G7xbAGpXjZcqQ0hmO5oa9lVAqv/wPbius4fFkRwRNKNM6U+lMSANrld8fWdIQsaZaroMRlEv5DPBc
	PXixwTpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wczTN-0000000AYFs-11kz;
	Fri, 26 Jun 2026 05:51:29 +0000
Date: Thu, 25 Jun 2026 22:51:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
	Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>, Mike Marshall <hubcap@omnibond.com>
Subject: Re: [PATCH v3 09/15] scatterlist: Fix offset in folio calc in
 extract_xarray_to_sg()
Message-ID: <aj4TYWMW2axUtruM@infradead.org>
References: <20260625140640.3116900-1-dhowells@redhat.com>
 <20260625140640.3116900-10-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625140640.3116900-10-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

