Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A337615853B;
	Tue, 22 Sep 2026 00:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790035726; cv=none; b=M1cv37i9dXh5vpWihy5Bc+ntW/hUAGkwgOLcsvGo0q4rTsL1MwJHtUwVwzwqHWLyT7Gm/V/MDlYGif0HPECSLRnzefj1Sg6AV2yO3DpSAc6AzBXiaFEUtGgOj2E1lkmDhUh3OMZVV5yIv1wUfzRQsMCR5jjrG2thr993k3BNLDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790035726; c=relaxed/simple;
	bh=DO2V5+LLTrkiqPU3Wrsivq+GGROQ1iHrXV8FjdPAfvw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ZnuJqiu8DZEpvGlOg0Ksr0zuzEdlLg2tyfkIYBlHBYZobRSeQSMed3OfZ2SV45PD2Y/rnxito/qSJd5EPusc9S+2wmQrbdCP0s6uZkyEwmIOe+v+lD+QveBObOPxToDsT2LWEJTMFP3yue6WEAO41Vnpxykr1oJ3irvcoP6Qzhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=qIddQro0; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="qIddQro0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n1AskZANSm/yAz8phwt1hROkRfK1YxbS6Gbz0rWf784=; b=qIddQro0AVIGAz7Z1LIv+Zpyx2
	K9bpxs3WoFFtS/QHBQkPqwpkqQ5TFlWzVemU80xTO0o57Ze+yReLksOLmHv/soamxT4MssEszOtqN
	KFg3Ev7fecq3BRa/q31FcvLzAOODyZ/JqlJABwsGDKHQ1NJztz1CIxfUABqp2n22Lc/2hZ1sT4ioJ
	C4kUW7WcfLisv61+k6d85N4SJX8ErEeVnRSpkKEzMZ6qgnFhUtfwofpBisRnV+sxpxnRuccfj0xVJ
	l2vnQNNq+mvzx/PduDXT2O27Xx2hwogRBViwt1Bt4S6TOAd3o1WXAWCjs3XTatjWg8DpNG59YWSdu
	fx5xoTFg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8o3s-00000001y4A-2tBy;
	Mon, 21 Sep 2026 21:08:40 -0300
Message-ID: <242c19b39a3f30b93bdfa6574e99eb5a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org, netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>, Christian Brauner
 <brauner@kernel.org>, Matthew Wilcox <willy@infradead.org>, Namjae Jeon
 <linkinjeon@kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] netfs: clear post-EOF pagecache when extending a
 file via write
In-Reply-To: <20260921230755.1133425-1-pc@manguebit.org>
References: <20260921230755.1133425-1-pc@manguebit.org>
Date: Mon, 21 Sep 2026 21:08:40 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> Fix netfs to erase the contents of a hole created after the EOF by an
> ordinary write if dirty data has been previously left there by writes
> through an mmapped region.  Neither the buffered nor the unbuffered/DIO
> write path clears that stale pagecache.
>
> Zero the tail of the folio straddling the EOF before an extending
> write.  That is the only folio that can hold data written past the EOF
> through an mmap, as pages wholly beyond the EOF can't be faulted in.
> The folio is zeroed rather than dropped so a concurrent extending write
> can't lose data.
>
> truncate_pagecache() can't be used here: it must be called with the
> i_rwsem held exclusively, but these write paths only hold it shared,
> and it would block unconditionally, breaking IOCB_NOWAIT.
>
> Export the helper so filesystems can clear the same stale data from
> their own truncate paths.
>
> Closes: https://sashiko.dev/#/patchset/20260921154957.903891-1-pc%40manguebit.org
> Fixes: 938e13a73b24 ("netfs: Implement buffered write API")
> Fixes: 153a9961b551 ("netfs: Implement unbuffered/DIO write support")
> Reviewed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>  Documentation/filesystems/netfs_library.rst | 18 ++++++++
>  fs/netfs/buffered_write.c                   |  9 ++++
>  fs/netfs/direct_write.c                     |  9 ++++
>  fs/netfs/misc.c                             | 51 +++++++++++++++++++++
>  include/linux/netfs.h                       |  2 +
>  5 files changed, 89 insertions(+)

Will address more Sashiko comments in next version.  Please ignore this
one.
