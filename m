Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BF61D8E1D;
	Mon,  6 Jan 2025 09:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736154976; cv=none; b=b8dYsnxRZBHqDOApT5Vf7XW8n1xLQqLgmpuYhNhPtFkS6ACAmoiwQpu/X3dTLQz4OB8CypC2UN0bozkDgqOPXG0mxQ6A93iweYkbsliiozXtvN3BPT/pDL0OCX6FyX5k5WbTOM/RVNJegJgdKLOTz0u2TQPVQHZOdcDrt3t8nyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736154976; c=relaxed/simple;
	bh=4/8XWjin8gUiHFiWrCvFm8Wj00zGliS766CAAY7K3hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr9diS4hc75YFsVRFGwgxswFla1rEJ9wh2pAZBE6IVCZK9tkJMF3zkqy/n15yrP/6bSBTEw118LzUh1vLp8hA0hcRGFw7rVzUpd5eWK+V056GTs3EfvabRXJBozXQr1hh60jigD+QGv5E94tlJ5QRSirNwoSJvLVnBwLaSJjl1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=utfQ3GLh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="utfQ3GLh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8SM31yDesgM1eYl6Lj1y750DwKgjbTFkgesdYsVjfLE=; b=utfQ3GLhAdlXYnK2/WQV0arUmG
	ylQTqZHzMm6m0hQa5gxCYi3m179bOe3II5UI9/gndzFDAUJiq32MSxj317p4UQtGBKrC77Ne+WRjW
	vJhOueoFbPzHW7mpngZutz5qkUkAVNPw8N9Ly2ESqj3Y8n7N+8LqJ4BaW+0ADWPQPeJXa/rk8cfda
	DBA4WZOdtSSEh0h/AvucYHKH1kjBwauh9WeDAxprALfxBR4N7Hw9oVGrrkmNMGC/DWl52+ONCYkLU
	E2pwK5Fyk2u67nPjxYQ+g8ozk6Diu+iGzbkmSYqD9HPh4mR9OUkt3PqjeTIzexBpwI3HCQnaD0IBD
	XxhT8owQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjDY-00000000dYn-19s1;
	Mon, 06 Jan 2025 09:16:12 +0000
Date: Mon, 6 Jan 2025 01:16:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, nicolas.baranger@3xo.fr,
	linux-cifs@vger.kernel.org, netfs@lists.linux.dev
Subject: Re: Losetup Direct I/O breaks BACK-FILE filesystem on CIFS share
 (Appears in Linux 6.10 and reproduced on mainline)
Message-ID: <Z3ufXFZziHGYpBsO@infradead.org>
References: <Z3uENYsAlKhUdQgY@infradead.org>
 <669f22fc89e45dd4e56d75876dc8f2bf@3xo.fr>
 <fedd8a40d54b2969097ffa4507979858@3xo.fr>
 <278655.1736154782@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <278655.1736154782@warthog.procyon.org.uk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 06, 2025 at 09:13:02AM +0000, David Howells wrote:
> Okay, I can reproduce it trivially.  Question is, do I need to copy the
> bio_vec array (or kvec array or folio_queue list) or can I rely on that being
> maintained till the end of the op?  (Obviously, I can't rely on the iov_iter
> struct itself being maintained).  I think I have to copy the contents, just in
> case.

The bio_vec array can't be freed while I/O is in progress.  Take a look
at the iov_iter_is_bvec case in bio_iov_iter_get_pages for how simple
ITER_BVEC handling can be.

