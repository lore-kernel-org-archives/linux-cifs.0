Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0663A1AF
	for <linux-cifs@vger.kernel.org>; Wed, 21 Feb 2024 06:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708497906; cv=none; b=eg0wPawoiDBZZiv3V3xWOHRMsen3D3R6dOrb0yodjxOOyD5SVUBh+zMPk7KFFYPeCqDuiiG2C/vOZS5Rl+atZedMfe4qxren9ZukHRfOY4bigDDeHnLbSb7zK+OW9IZoMh+HFCcs2MuFG/f+j54No5Ka2nYh9vd87hi7zl1JA1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708497906; c=relaxed/simple;
	bh=C0Pd1UX0l6EZPHw8UP+YPqPfVGj/5GDCMo7+hH4lvQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3V7wi8r1gPxEnrEPG4DvITcZ7efXa7PWliMiq1ovqW2rJ986rOH2kxU9MpJwlAL5QkK2YdyKc4DrkPdWCEPAyiCTp2nImIwsVzSc99ggxFGsBr/HTXnX+jWhyUf9n+fdxcPzg/qiGKCMnRO5Q4fWI5HslIV4kM4IaSTKIGkaV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oRSwPnyQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oRSwPnyQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bfuLot39FvC0uHZFGiANBo74IjL52aF6OIagTgMTddA=; b=oRSwPnyQTv1QzuF90WEpb+aTmr
	EkflVt2+28gCbmEv1bTqtxfSuf4lfhADgsXpGLdJcLkKgeBUDzn/5khtJm42J2erz3g+rdmZFox0d
	Qc9XBHmClDN5OPEH+3bjnR6j4OyfbnOSVamyW4YKqbLnkflh7x8pHYiwl+/eoIcpx4mjwChgB4s6a
	xQDDgRtiCVj8gXjusSH6r4mxX5swoz+Cf69GcIh6jH0e2sAqYkZo3Q4RDAd3VkldUPdtSxQxeRqCo
	wf+IrPz9GPS+3NH+IBH5jtI9xsALCtPqSyfsewDiGj+rD45XhUJjYsgHrxujXgwQdiKL7mZJypliL
	t8OQ3/uw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcgLg-0000000HMoO-3kaU;
	Wed, 21 Feb 2024 06:44:56 +0000
Date: Tue, 20 Feb 2024 22:44:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/2] ksmbd: retrieve number of blocks using vfs_getattr
 in set_file_allocation_info
Message-ID: <ZdWb6AlGj4qqcCHn@infradead.org>
References: <20240220142601.3624584-1-mmakassikis@freebox.fr>
 <20240220142601.3624584-2-mmakassikis@freebox.fr>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220142601.3624584-2-mmakassikis@freebox.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 20, 2024 at 03:26:01PM +0100, Marios Makassikis wrote:
> Use vfs_getattr() as inode->i_blocks may be 0 on some filesystems (XFS
> for example).

Same comment as for patch 1.  The code changes also look good to me.

