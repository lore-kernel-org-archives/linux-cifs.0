Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861A03ABD8C;
	Sun, 30 Aug 2026 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788108214; cv=none; b=HWCUq2mGEtl+EXvMFqfoIXd9lzTTvqnAb4uuvBM23GuNee7uyowMoFIBp1YQ7/UsbGWBpMY625tZAGXCEMpvctNGzEdTSr83wp5s/y/ddcXmEl/Y+K9pUGDs/S8k3Kmalv7f33HUCbromOGnhe6q+ftATAr3C/JjGdcQXtHFUTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788108214; c=relaxed/simple;
	bh=n1VIXRT5kMAu/lEFCvWRouqB562i/b/HNLGNbEbiVJU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ugIxbIEUAtxB6cqpDwXjaYGrZHWBv5icVRvjnSKWlrbjq6GFL4U+102c0K7zVSQ9wxaXxWwPq1/qy5Yp9uDNBPU2VhuXLWwrKhgyDLn+30VpbLbZayujgRZN3NQlHfs0SDyfcjVvBlBBAjwUnwVEoWtHAVW0HY7Lt2OJJ7ZmxoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=wqS+j5o6; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="wqS+j5o6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P0tW1e8GwbwOkhYw1Z1mpZXZXlBkdgxh2sfIe+IYW5s=; b=wqS+j5o6vpr//jmpRSWrrULc9x
	pVaUJVepYU9BfoGIwas9gJ4xzEXRYKEM1WoPvV5V0+lGNTHaX7AET9sKzzvk7cwjCuSUwtf+NA6O9
	mlBDHckZZ0sDOsgW5OprClURyOclvBDQnj8weWhb0o53EmtUfgIXZaDnl2LRYiID59QGG+UlJ65vK
	nmZi2GDgRu2xFVFMyzvmbflzXynrTDnZHA1Ov9ef/95AjMPYMf+c8LPyt+DpKuMv3agNYqhaNVrYb
	P2h3G5dv8YW2PV4F7It/SdZyy2sYDw7ANAKvz02ZxrYzljNpXermD0pL4Dqwy2klRYLhnzb2WP4kT
	urZaphdw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x0ics-00000000HXK-4Aw3;
	Sun, 30 Aug 2026 13:43:22 -0300
Message-ID: <ff527b2379048e28e0b2e66abdeb1aba@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix data corruption with concurrent writes
 and O_TRUNC
In-Reply-To: <CAKYAXd_cR_WAd-3iRW_KJRmSBKxNiSuGvjNXXk33pG3Z_2dBvA@mail.gmail.com>
References: <20260828231211.252093-1-pc@manguebit.org>
 <CAKYAXd_cR_WAd-3iRW_KJRmSBKxNiSuGvjNXXk33pG3Z_2dBvA@mail.gmail.com>
Date: Sun, 30 Aug 2026 13:43:22 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Namjae Jeon <linkinjeon@kernel.org> writes:

> Should we also take filemap_invalidate_lock_shared() in the
> page_mkwrite path to serialize mmap writes with this truncate path?

I don't think so.  It's serialised by the folio lock that
netfs_page_mkwrite() and truncate_inode_pages() take.  Also, if a new
writable page was added between the first unmap and
truncate_inode_pages(), or if a new page is about to be become writable,
both paths should go through filemap_fault(), which takes
invalidate_lock shared, so they will both serialise with invalidate_lock
exclusive in cifs_do_truncate().
