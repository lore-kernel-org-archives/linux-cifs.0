Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9312A41835E;
	Thu, 24 Sep 2026 04:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790223397; cv=none; b=uaWQIIbGGsfI99pYTL5FwBmwQCtcL5G6ACDvtxGEEtHl86MWGTTeruGYHLO+pY6xHcLPEnBw3P9A9mt5QifwbkI6YxIvTV88txi2DUGX4x2Icq7jwsT3ZeTEalaszkceLf9JEkqyfrd0LzEWAEf2liLGP3MlyT4KyS51Ba+bwxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790223397; c=relaxed/simple;
	bh=KLvrM2S4IuFKMwL77r7Q3gG8E8NpdkUdV8oEveYYUdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNMnSIyAd0eVbDH0hQmeemznU8mCo92Un8VSI3Re/rSSQLAUOehrMvxVX4nf4PWnLYETVWmEPgvlpB7MdZlQDT44hE+5A5f6o0/4z7BhaTiGG64ydijL4JbNv9i79yqgQ83TQrxssUs/xP9wQxtz5Cy2NFLOZ3FNE8/537fhPmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W5E7P50V; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W5E7P50V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BdSlsMfkuxhxiJlWuwe1IxzXZwAYvmEuJHQZQQIcCpI=; b=W5E7P50Vm4uHDnzOxK0iApubfC
	lNy7VxKIQOmzGCGTSO87MXxZQskkqcu4kRGLUmBZ52YI3RoW5NoKgupICmRL8nkI0ryo2Mvourbbw
	5nt3pwOpa9T6uiD7avodFkwucJs919MYfo5ezCfZJCJ04s197w1NtheE/uNY5G60jHH1d+07iuDos
	BlGg1I8235Eos8krQ/mG/H/MV1obOmJwo3zcpRL7cqERmXHSdxL5+jWsgDw3kZnPWN9ET5GJ2g9du
	Gq0TCtZnmfzVT+kJ+xQSIUQuHfLGoHvH5zxO2bk8GQdenNxTK2RG1KWLh2cJALQjDHtXkPNVOWxm1
	YMZzGHaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9asl-0000000FNJt-1Vrq;
	Thu, 24 Sep 2026 04:16:27 +0000
Date: Thu, 24 Sep 2026 05:16:27 +0100
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
Message-ID: <arSkGzqebr4ogCZs@casper.infradead.org>
References: <20260921230755.1133425-1-pc@manguebit.org>
 <arHVJ0ihdqmNETMw@casper.infradead.org>
 <b5a645319f7b2475f65306c3445953db@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5a645319f7b2475f65306c3445953db@manguebit.org>

On Wed, Sep 23, 2026 at 08:46:35PM -0300, Paulo Alcantara wrote:
> - netfslib needs to honour NOWAIT, which pagecache_isize_extended()
>   can't do due to filemap_lock_folio() and folio_mkclean().  Besides, we
>   would also need to return -EAGAIN in case the folio is mapped or under
>   writeback.

btw, if IOCB_NOWAIT is important to you, you need to be calling
kiocb_modified() instead of file_remove_privs() and file_update_time()
in netfs_buffered_write_iter_locked().
