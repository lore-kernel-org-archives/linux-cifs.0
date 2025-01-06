Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C762D600;
	Mon,  6 Jan 2025 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736148026; cv=none; b=muHx0XCXvCMuc427Rd3TyEyF3PoD5/W7R/ti+jjtEPVLzZJttIbznfsDEikUw/e6XmaIrw2XqY0kIVZLvbspVBwlbFzzu/UVp+PDrfn+peLjpEeNInmU5ik+22xH4loCHAKBDf9GTfF8n5xfByu4QKStMm8TV3WuSjaR+oqMfhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736148026; c=relaxed/simple;
	bh=kTdW82KceLUTOgNYaoGPbkHA7WjfDp+EMoSxq8n/HRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YknXueTY+xxnN8E5UPRy+M57G/MatDRLCbTK8h/DGwfQ9i+ROvSJqWg8Myq6IWKk0jccR8aGRs2T6cTjpZzUGH06g354MMA4p7lNI872zGF+/kqJj5h5MOZEX2mLQ/uMaPaG4Vt4FEuPX1Chai2JquXrVxtx1ghGtdkNemJYnt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WK5VqBxI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WK5VqBxI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fmt8qYME6/9w9R8bbYrO57pxWUiLXsFoyO6fNt5bpLg=; b=WK5VqBxIPQkHZEzwkVc5VI4bQ7
	t7SxkA8xtNog9Uh+/UnZTvEJCwdFX7jhlGs+ZRcwN5NsgNuVx1UJbMEnndpM+D64wrQ3KUMWH/7hp
	R06Qp+FYa0T3T+NU03ww95Gy3xjbp5lV42u1FBY0v5FFKlZtSEC3LjvouJcpGqCyWhilI7r4c23Zv
	fnNwTIh54oeDCK4QQG30/m/1mEtdLCmi3G/csyQ7jAXeWQtyz53qm4eIUtABZaRj2SW1sbMhdd1Qr
	F16qvQlbx1+SVLceIWDt6nZ81nN32dDYZ39zcXYIoVpXJmPNfct4THXXPYa926NMUzFYk8aJmswNA
	Msw0YQ7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tUhPR-00000000OAK-1uPR;
	Mon, 06 Jan 2025 07:20:21 +0000
Date: Sun, 5 Jan 2025 23:20:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: nicolas.baranger@3xo.fr
Cc: linux-cifs@vger.kernel.org, netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Subject: Re: Losetup Direct I/O breaks BACK-FILE filesystem on CIFS share
 (Appears in Linux 6.10 and reproduced on mainline)
Message-ID: <Z3uENYsAlKhUdQgY@infradead.org>
References: <669f22fc89e45dd4e56d75876dc8f2bf@3xo.fr>
 <fedd8a40d54b2969097ffa4507979858@3xo.fr>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fedd8a40d54b2969097ffa4507979858@3xo.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 01, 2025 at 07:00:58PM +0100, nicolas.baranger@3xo.fr wrote:
> 
> Dear mainteners
> 
> Don't know if it's the right place to contact kernel developers but today I
> did report the following bug which appears in Linux 6.10 and I'm able to
> reproduce from Linux 6.10 to mainline
> 
> I think the new way CIFS is using NETFS could be one of the cause of the
> issue, as doing :

The poblem is that netfs_extract_user_iter rejects iter types other than
ubuf and iovec, which breaks loop which is using bvec iters.  It would
also break other things like io_uring pre-registered buffers, and all
of these are regressions compared to the old cifs code.

