Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3B9314A98;
	Wed, 23 Sep 2026 23:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790207206; cv=none; b=BTl9dE9sc1b0XgOrFVybTpjAnRVfC/1AqKgNRh3ZppWM1XN4wSz7Q1PKMkgrWRa+Q/MZie+KnvhlwWeb3fS+GpDIF/GC2dud/bC09JaFcvl5zgDAcEX4E/lwWgV62hUTfXn4ja3TTZPosO9yV0m3A1CK897UNdfOo7FidCW9Bh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790207206; c=relaxed/simple;
	bh=yNpiPqdLp3R+R3L6kkyskUDkI/XsTX/Rq6jb0UkleLk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=feHhbwzVNG4TyUZuR2vVpL1pQ0Qsqv+ZOY6Z5Z97sVCYKC41sZjYrE8AIuQ2CXul6Aru8xWsKsyAlTQtNGNZqPogTHMAiS4dwFxB3HGgeEj954KN7BO3XqLg7wjw/CST7tq5LB0r/CeIeoiDKLzZLrDDNtF+nzyCPm0CGLBPlcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=q4B/HmFP; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="q4B/HmFP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EqQ40mnOXqnZL0TEZ9hopQUSh3U92S6ROmEtqwgnXfE=; b=q4B/HmFPQOCFsCoIEV52J13/Zp
	MP7rB3E0JczlfiVfPo3hJfF4kWN9EZn1Nt1dMYaQbKNMOfY/LbkjPfAmrkz93y3anGmjWHMjUvAyT
	bx5UJ2XL5GPhSjWypNkm8wfu0MA61ujspYEkuSvUL19FJerdJWI0LMvHBN//rReE4p+H0XJ3n/xSw
	5lbNm0BK2YRe1aUVJBN73m70KCRBBvqVj88VgLYxHe0HUd9iYH+VPv9pLRGc4psoZ/q1Ux0EtofOu
	E1Nv33gH21eYusV5SNvdmFbbDaBkwiUL9kQ0fbyUq/kfQZf7cv3sjfAUWlCtQh8tvWmu0Ux75JiNs
	oIhG9bgQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x9Wfc-000000028kw-1045;
	Wed, 23 Sep 2026 20:46:36 -0300
Message-ID: <b5a645319f7b2475f65306c3445953db@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-cifs@vger.kernel.org, netfs@lists.linux.dev, David Howells
 <dhowells@redhat.com>, Christian Brauner <brauner@kernel.org>, Namjae Jeon
 <linkinjeon@kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] netfs: clear post-EOF pagecache when extending a
 file via write
In-Reply-To: <arHVJ0ihdqmNETMw@casper.infradead.org>
References: <20260921230755.1133425-1-pc@manguebit.org>
 <arHVJ0ihdqmNETMw@casper.infradead.org>
Date: Wed, 23 Sep 2026 20:46:35 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Matthew Wilcox <willy@infradead.org> writes:

> On Mon, Sep 21, 2026 at 08:07:51PM -0300, Paulo Alcantara wrote:
>> +	int netfs_clear_stale_post_eof(struct inode *inode, unsigned long long from,
>> +				       unsigned long long to, bool nowait);
>
> Should this be uoff_t?  Or even loff_t?

uoff_t.

>
>> +int netfs_clear_stale_post_eof(struct inode *inode, unsigned long long from,
>> +			       unsigned long long to, bool nowait)
>> +{
>> +	struct address_space *mapping = inode->i_mapping;
>> +	fgf_t fgp = FGP_LOCK;
>> +	struct folio *folio;
>> +
>> +	if (from >= to)
>> +		return 0;
>> +
>> +	if (nowait)
>> +		fgp |= FGP_NOWAIT;
>> +
>> +	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT, fgp, 0);
>> +	if (IS_ERR(folio))
>> +		return PTR_ERR(folio) == -EAGAIN ? -EAGAIN : 0;
>> +
>> +	if (folio_mkclean(folio))
>> +		folio_mark_dirty(folio);
>> +
>> +	if (folio_test_uptodate(folio)) {
>> +		size_t end = umin(to - folio_pos(folio), folio_size(folio));
>> +		size_t offset = offset_in_folio(folio, from);
>> +
>> +		folio_zero_segment(folio, offset, end);
>> +	}
>> +
>> +	folio_unlock(folio);
>> +	folio_put(folio);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(netfs_clear_stale_post_eof);
>
> This looks suspiciously similar to pagecache_isize_extended() but does
> not mention it.  So any updates to that function will probably imss this
> one.  That's not great.

True.  Sorry about that.

There are some reasons that I ended up with our own helper:

- The block size checks make no sense for CIFS, as reads and writes will
  be byte aligned.  For instance, CIFS and AFS set block size to >=
  PAGE_SIZE, therefore calling pagecache_isize_extended() is a no-op for
  them.

- netfslib needs to honour NOWAIT, which pagecache_isize_extended()
  can't do due to filemap_lock_folio() and folio_mkclean().  Besides, we
  would also need to return -EAGAIN in case the folio is mapped or under
  writeback.

- netfs_clear_stale_post_eof() will be called before i_size is updated,
  so we re-check i_size after acquiring the folio lock.  It runs with
  i_rwsem held shared in both the buffered and unbuffered/DIO paths, so
  extending writers might concurrently change i_size while we run.
  pagecache_isize_extended() can't also be used as it requires to be
  called after i_size is updated, therefore hitting WARN_ON(to >
  inode->i_size).

NFS also has its own helper (nfs_truncate_last_folio), but couldn't
re-use it due to above reasons.

Please let me know if you have any ideas.

This is what I currently have for new helper (trying to address some
issues found out by sashiko as well):

int netfs_clear_stale_post_eof(struct inode *inode,
			       uoff_t from, uoff_t to, bool nowait)
{
	struct address_space *mapping = inode->i_mapping;
	fgf_t fgp = FGP_LOCK;
	struct folio *folio;
	int ret;

	if (from >= to)
		return 0;

	if (nowait)
		fgp |= FGP_NOWAIT;

	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT, fgp, 0);
	if (IS_ERR(folio))
		return PTR_ERR(folio) == -EAGAIN ? -EAGAIN : 0;

	ret = 0;
	if (nowait && (folio_mapped(folio) || folio_test_writeback(folio))) {
		ret = -EAGAIN;
		goto out;
	}

	folio_wait_writeback(folio);

	if (folio_mkclean(folio))
		folio_mark_dirty(folio);

	if (folio_test_uptodate(folio)) {
		uoff_t fpos = folio_pos(folio);

		from = umax(from, i_size_read(inode));
		if (from < to && from < fpos + folio_size(folio)) {
			size_t end = umin(to - fpos, folio_size(folio));
			size_t offset = from - fpos;

			folio_zero_segment(folio, offset, end);
		}
	}
out:
	folio_unlock(folio);
	folio_put(folio);
	return ret;
}
