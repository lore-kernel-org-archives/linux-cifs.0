Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E49C35E944;
	Tue, 22 Sep 2026 01:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039344; cv=none; b=fVYp95JQ91iIL9c4zr5mp+3RwooRcwMsF4fEPolIbIgTJNRapTkYem1QLlKNG4VrwRVw9uqOjITGhTUxJSVSM9YABZxY+h/4uUBJO4n5UN10y/BqWXlac388JbvI0Hq6U6CsmuNN/Y3ja7tDnCCQzpMA695vN/BfARvjN+XOAa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039344; c=relaxed/simple;
	bh=+T9Q7RwOxM2zptYVqVHezzfN0lntVw4DJDzJ2tMG5Hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNXJTlc7UBlQYUj4rbNBzqvFqpUkeyAoiKeudvTnInQ0CnZwf5yYWeLOb0EmE08CZgbyx8raKG282zMlEqoIipx4ZyceIdHTZBRs1SVrxc+lq/aT95jmwcuQ9cruVJMPe8aMeuWp9PcxYDxNafaOXSm1j+jktXPH28e7GrzSEnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GlCICAe5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GlCICAe5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IO9qHF4pmh8ostFd9DZGvaInm6a5xDRfY+VE/K4jZpI=; b=GlCICAe5hDZolvSOSYHe8wdESs
	nuWvrV8qmnQOgXSNcqVR82Jc7JVyrcYexeG9iGmCmDbgAul4uEQArwlKOa5KsTkz1SbZlLxhS/8hi
	drqSPVHQ40bY913VJz6iRgE435460loPLgGKuIlUzNYb8WWPWwNClitXIIJgvXDR8TaCoyLYyZ8MJ
	1LgDCQ71S7vPW3r5zOlGfqanMlGSTs1O7cxLoN0qSrqaTxWNAmoxd/Bh5W8+KKjWTbg7kHZBR0VG6
	TEEtgy0/UcHmBE+PsllRwl3aJZjHu1gbY6O/b9vwAVTVkDqlmwleSlsMYQ84kGn6THN83cSMzelMX
	rNcrtV1Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8p0B-00000006D7B-1Gmk;
	Tue, 22 Sep 2026 01:08:55 +0000
Date: Tue, 22 Sep 2026 02:08:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] netfs: clear post-EOF pagecache when extending a
 file via write
Message-ID: <arHVJ0ihdqmNETMw@casper.infradead.org>
References: <20260921230755.1133425-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921230755.1133425-1-pc@manguebit.org>

On Mon, Sep 21, 2026 at 08:07:51PM -0300, Paulo Alcantara wrote:
> +	int netfs_clear_stale_post_eof(struct inode *inode, unsigned long long from,
> +				       unsigned long long to, bool nowait);

Should this be uoff_t?  Or even loff_t?

> +int netfs_clear_stale_post_eof(struct inode *inode, unsigned long long from,
> +			       unsigned long long to, bool nowait)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	fgf_t fgp = FGP_LOCK;
> +	struct folio *folio;
> +
> +	if (from >= to)
> +		return 0;
> +
> +	if (nowait)
> +		fgp |= FGP_NOWAIT;
> +
> +	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT, fgp, 0);
> +	if (IS_ERR(folio))
> +		return PTR_ERR(folio) == -EAGAIN ? -EAGAIN : 0;
> +
> +	if (folio_mkclean(folio))
> +		folio_mark_dirty(folio);
> +
> +	if (folio_test_uptodate(folio)) {
> +		size_t end = umin(to - folio_pos(folio), folio_size(folio));
> +		size_t offset = offset_in_folio(folio, from);
> +
> +		folio_zero_segment(folio, offset, end);
> +	}
> +
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	return 0;
> +}
> +EXPORT_SYMBOL(netfs_clear_stale_post_eof);

This looks suspiciously similar to pagecache_isize_extended() but does
not mention it.  So any updates to that function will probably imss this
one.  That's not great.

