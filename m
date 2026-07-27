Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58962338910
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 18:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785176321; cv=none; b=qqsp73rCRTwifBQYLXYksoEqoTNzNYBcHrm35qewyFvCy3Iz5/MQ+cEh/3IAcBof+4MRvepMnaAoBZSJp7WfLsulEGUY+As12xCJykdC9dLmXwnK6qumkQePge8CV83ZDnie1RGzahsR1jLN79KGtn1Le1FQX8kiM9NiX0ro12I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785176321; c=relaxed/simple;
	bh=iPZXiWJxfplbr/eUXAGfIPqtKGMl33vrCxegLxUvFKI=;
	h=Message-ID:From:To:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=MKSiJcji23OXHn9if688KD4HM+5sBFge9u8UyEDw+HTwknkNRF9h8K7z+bGtFkmwYhD266QQKZEvNVmyrJ7wSI2JzBDqxAhRDQHxy6vcMfAZj+Qi6QeZ1f48aIR52aNWT8RKQsEOpP4259rlwGZWin2YrsXmlMTtlBTpE9YU/P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=rj0d6Up6; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="rj0d6Up6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:To:From:Message-ID:Sender:Cc:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bf5D/tQxGS997w2P7wKnM9VARqbvG5eps0EHkowqKXk=; b=rj0d6Up6lPvSpXTgz0B+iHCd6D
	b32Lx5JOiEAeaS9CpWOGq7pv5owBHFj1nJYoyp5lSvKB+TocE8P5Ny5JwIS0srr3UMx5B/mNmP8Zr
	yHBjK8F2CDjL/rvV6iHvCAT9BRNcAGAgHBGSLOAgKoUXaZXaHQUnEuQwlpiVqE0Kl2CH22AckFhWv
	WYnGHUHKqb1xsJOTCj6WfvGsfTaXg7jutpRVib1gd0HMbCHFNElohaaLVP2saBYHrCrtbzIxhIZNg
	q8+y4FntopE64x/5clx2Op/zByKXJaf3YLVb9zvoeiEqhCzjfhdBM/vm47HRy+1IQgF6XfRVQkRCw
	7JVy6fUw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.4)
	id 1woPuH-000000006mn-2pCs;
	Mon, 27 Jul 2026 15:18:29 -0300
Message-ID: <2ff7ecbb966ccaa5dd3768b0fdf38d39@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org,
 stfrench@microsoft.com
Subject: Re: [PATCH 0/2] cifs: follow-on fixes to time_last_write mechanism
In-Reply-To: <20260724163036.2670328-1-sorenson@redhat.com>
References: <20260724163036.2670328-1-sorenson@redhat.com>
Date: Mon, 27 Jul 2026 15:18:29 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> This series addresses two correctness issues in commit e8a8d54c2d50
> ("cifs: prevent readdir from changing file size due to stale directory
> metadata"), which introduced the time_last_write field to protect cached
> file sizes from stale Windows Server directory enumeration metadata.
>
> Patch 1 consolidates the time_last_write stamp into _cifsFileInfo_put().
> The original commit scattered the stamp across cifs_close(),
> smb2_deferred_work_close(), and three deferred-close drain functions in
> misc.c.  This missed the case where background I/O holds the final file
> reference after userspace close() returns -- the stamp was anchored to
> the earlier userspace-close time rather than the actual server close,
> allowing the protection window to expire before the handle was removed
> from openFileList.  Moving the stamp into _cifsFileInfo_put() under
> open_file_lock provides a single canonical location that covers all close
> paths and uses the spinlock's store-release/load-acquire pairing with
> is_inode_writable() for correct memory ordering.
>
> Patch 2 fixes the stamp placement in the setattr/truncate paths.
> cifs_file_set_size() calls cifs_setsize() on success, which calls
> i_size_write() and updates i_size.  The subsequent check
> attrs->ia_size != i_size_read() therefore always evaluates false after a
> successful cifs_file_set_size(), making the stamp dead code -- the
> truncate path was completely unprotected.  The fix moves the stamp to
> before the RPC call, guarded by attrs->ia_size != i_size_read() to
> exclude no-op same-size ftruncate(2) calls.  On failure the stamp is
> left in place rather than restored: restoring a stale snapshot (prev_tlw)
> could silently erase a concurrent _cifsFileInfo_put() close stamp if that
> close arrived between the READ_ONCE and the smp_store_release.  readdir
> is suppressed until the stamp expires; stat() is unaffected because
> cifs_revalidate_dentry_attr() uses from_readdir=false, bypassing the
> time_last_write check entirely and always returning an authoritative
> QUERY_INFO result.
>
> Frank Sorenson (2):
>   cifs: consolidate time_last_write stamp into _cifsFileInfo_put()
>   cifs: fix time_last_write stamp placement in setattr/truncate paths

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
