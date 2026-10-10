Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B437337699;
	Sat, 10 Oct 2026 17:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791651932; cv=none; b=esfE18+SpkLqkt73skByFA+XHbmVoIeCaeos+2chGkhTjpnxMkIOLCGiOX9WpFCWKzQIp2S2ko27dJMRuBdOaKaz1yRfOcLS8a7LxUdO6ZvhoeqAD2RSl3WBgcfwO01OrXMC9gEO5U+sfBuxvnlt+TLGNfOfb9FouztrnCTRzzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791651932; c=relaxed/simple;
	bh=bX69TTLpm2F+KxFhin6mG64NDg6qinxqgsZOLwiteXg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=QB/VDTGzPTeYr8pujRgNalGGe0ZDRKHoaBJwAENLjrTXlwqdjSC2WwnnE9Rl5G+aAZ2boRefrGt/xuHxEAJ+ulfD5h+ZBpXbTObWxMtIFoo8Q5xk7dhGGIpXkHPc7rVUEOz/dxBl0LM8K/pdSNJHtAJKlSs3xsxjJ0Wp3vkS//Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=GBJ5QDBd; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="GBJ5QDBd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7hcF4/ysd3bmWU9fUJN00eTICOOg/RwQsYlRByeFUYA=; b=GBJ5QDBd7r39weyBBEB+qc3wau
	PIV3aEBoowGr9Lka6RXxZVvg6mOTlOnmk9XcZIStaLC9UKJ00KPgb0yqMnwn20BQtsHH6tpyWdyMS
	A//gL9oPwWk8MxpZFSZMd7ZWNVzxPbBcJ/NbLAT8PIYr499ZChqhiG9+wFYosOYVKnP7Ae4DEHA63
	uE2OguOZj97Qc/BLKOoS2dFsLSs+CqbCj9lhDqy5sN3cUYIMhJ82l+XlVVXDmYW6ZvP2lvZhMYFXY
	Me131l0jw2T4BDREyk9kchrN5nc/fvSjheWBi7+kFp4Bv/sYTxNIEH9TiwjVcLEJ+VOvVPSsaobWi
	MjN9M88g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xFaVj-00000003LE6-36l3;
	Sat, 10 Oct 2026 14:05:27 -0300
Message-ID: <de35bcca12facb37a96cf38f328bd82b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Diego Oliva <diego@bynar.io>, Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, Jeff Layton <jlayton@kernel.org>,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] smb: client: fix OOB and use-after-free infoleaks
 in SMB1 FIND responses
In-Reply-To: <20260929091636.2618227-1-diego@bynar.io>
References: <20260929091636.2618227-1-diego@bynar.io>
Date: Sat, 10 Oct 2026 14:05:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Diego Oliva <diego@bynar.io> writes:

> The SMB1 client parses TRANS2_FIND_FIRST2 and TRANS2_FIND_NEXT2
> responses without checking them against the number of bytes it
> received. A malicious or compromised server can make the client read
> past the end of a response, and past the end of the cifs_request
> buffer holding it, and send what it read back to the server. Both the
> out-of-bounds reads and the use-after-free read are information leaks:
> the bytes leave the machine in the client's next FindNext request,
> from a position the server picks:
>
>  - LastNameOffset, which the client uses to locate the last entry of
>    a response, is only checked against CIFSMaxBufSize, never against
>    the response that was actually received, so psrch_inf->last_entry
>    can be placed past the end of the allocation.
>  - cifs_save_resume_key() parses the entry there without a bound. The
>    name length comes from the entry itself, and for SMB_FIND_FILE_UNIX
>    from a NUL scan of up to PATH_MAX + 1 UTF-16 units. The name is
>    recorded as the resume name of the search, and the next
>    CIFSFindNext() rejects only a recorded length of PATH_MAX or more
>    before copying the name into its request and sending it, so up to
>    4 KiB of memory from beyond the response leaves the machine,
>    together with the resume key read from the same entry.
>  - When the last entry is rejected, and when a search rewind frees
>    the buffer without its FindFirst recording a new name, the resume
>    name keeps pointing into a buffer that has been released, and the
>    next CIFSFindNext() copies it from there.
>  - The response parameters (search handle, entry count, end-of-search
>    flag, LastNameOffset) and the data area are read at offsets that
>    validate_t2() caps at 1024. It bounds the parameter and data
>    counts by the byte count of the response, but nothing ties either
>    area to the bytes that were received, so one can begin or end past
>    them; those reads stay inside the allocation but can return stale
>    bytes.
>
> A FindNext response that reports no entries without ending the search
> is enough to make the client send the resume name, and each further
> response can do the same. Reaching the code needs a malicious or
> compromised server, an explicit vers=1.0 mount of it
> (CONFIG_CIFS_ALLOW_INSECURE_LEGACY, default y) and a directory listing
> on that mount; SMB1 is not negotiated by default. The same code is in
> every maintained stable tree.
>
> Commit f8cf09a53a0d ("smb: client: bound dirent name against end of
> SMB response in cifs_filldir"), in v7.2, bounded the name of the
> entries cifs_readdir() emits, after the parse; the resume-key path was
> left unbounded and the parse itself still ran before any bound.
>
> The fix is one change conceptually, but as a single patch it is well
> over the 100 lines with context that stable-kernel-rules.rst allows,
> so stable could not take it. This series splits it into patches that
> each fix one thing, build and pass checkpatch on their own, and stay
> under that limit.
>
> What each patch fixes, and what to backport:
>
>   1/7 fix use-after-free infoleak via the readdir resume name
>       The use-after-free. It comes first so that the patches after it
>       cannot widen the window it closes. Also resets resume_key with
>       the name and skips the zero-length copy in CIFSFindNext().
>       Tagged Cc: stable.
>   2/7 fix OOB last_entry pointer from unbounded LastNameOffset
>       The out-of-bounds pointer, bounded against the response that
>       was received rather than against the declared data area. It
>       applies on top of 1/7, whose resets sit in its context and
>       which makes the paths this patch sends more responses down
>       safe. Also records the search handle before the last entry is
>       examined, because the new no-entries case would otherwise lose
>       the handle. Cc: stable.
>   3/7 fix OOB read of the resume name sent in TRANS2_FIND_NEXT2
>       Bounds the entry parse in cifs_fill_dirent() for both callers,
>       before anything is read. This is what stops a name from being
>       recorded and sent from past the end of the response.
>       Tagged Cc: stable.
>   4/7 fix OOB read in the SMB_FIND_FILE_UNIX name scan
>       Caps the NUL scan at the response end; without it the scan
>       still runs several KiB past the allocation. Depends on 3/7 for
>       the end of the response. A scan that reaches the end of the
>       response without finding a terminator is rejected; a name
>       longer than the PATH_MAX cap of the scans is still truncated
>       there, as before. Cc: stable.
>   5/7 reject FIND data areas that run past the received response
>       Hardening rather than memory safety: it stops entries being
>       parsed from stale bytes inside the allocation, and bounds the
>       data area that the nxt_dir_entry() walk starts from and that
>       the two query helpers read their entry from. It rejects with
>       -EINVAL, as validate_t2() does, logging with cifs_dbg(), and
>       adds no tracepoint, so it applies to trees before 6.19.
>       Cc: stable.
>   6/7 reject short or out-of-range FIND response parameters
>       The parameters are read inside the allocation, but the stale
>       search handle among them is sent back to the server. Depends on
>       5/7, whose declarations it extends. It returns smb_EIO2() with
>       two new smb_eio_traces values; backports before v6.19 need
>       -EINVAL instead. Cc: stable.
>   7/7 drop the redundant name bounds in cifs_filldir()
>       Cleanup of the two post-parse checks that 3/7 made redundant.
>       Depends on 3/7. Not for stable.
>
> No patch needs one that follows it, so the series can be cut after any
> patch. Patches 1/7 to 4/7 are every out-of-bounds and use-after-free
> fix; 5/7 stands on its own; 6/7 can follow where smb_EIO2() exists.
> Trees before v7.2 need the adjustments noted in the patches that need
> them.
>
> cifs_fill_dirent() is shared with the SMB2 readdir path; 3/7 and 4/7
> add checks there that a valid SMB2 response cannot fail, since
> smb2_parse_query_directory() already walks its entries against the
> end of the response.
>
> Left out on purpose: an entry-size check for cifs_query_path_info()
> and cifs_backup_query_path_info(), which still read one whole entry
> from a data area that 5/7 bounds only as a whole (those reads stay
> inside the allocation); passing the end to posix_info_parse() in
> cifs_fill_dirent_posix(), which only SMB3.1.1 POSIX mounts reach,
> with entries that num_entries() has already validated; and a lower
> bound on ParameterOffset and DataOffset, since reads at a low offset
> stay inside the received response.
>
> Each patch builds with W=1 without warnings and passes checkpatch.
> The out-of-bounds reads and the use-after-free read were reproduced
> against a test server with KASAN enabled, by listing a directory on
> an SMB1 mount; the splats are in 1/7, 2/7, 3/7 and 4/7, all taken on
> the unpatched tree. The one in 4/7 shows the case the preceding
> patches leave open, where the entry starts inside the response and
> the scan still leaves the allocation.
>
> The series is based on cifs-next at commit f14572c203d5 ("Merge tag
> 'cifs-fixes-7.3-rc5' of https://git.manguebit.org/linux"). The files it
> touches are identical there and in v7.3-rc4.
> ...

Applied.
