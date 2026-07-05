Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E654D360EC0
	for <linux-cifs@vger.kernel.org>; Sun,  5 Jul 2026 22:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783290254; cv=none; b=C2HrC+Ps7tpucRvXULvKQ0tUpoS3Gmp+h1Ue6iykv/Z9thTcqAQbvLqc+P0G9hi5JdFCcOdRNLiKlCGIuoebEHTPXFeQY7wjU+uJfInkp5m0jE3/SpUudtgo30rr9/+td9q38XjoD8Yfnm6zaiyxIcVDrG40iSLCaGn5/zfEJb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783290254; c=relaxed/simple;
	bh=UqIm0wXLD9z328I8jyhqBB3uWvFhRoOLLz+YK+xY9YM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=QOY1nchBQ9+PT77s55WPemvPNjAY1nNUy5Bum5BD5xx8W2kGn4luj8CBQsK3ed2abNUnbW7zW3IeGJ7ehIfWwzJRlfs/5K+NzZpmefZuAK3V7cuDimwaSscQ6mI+/hz0D+oXnHZaYg+3txSUvZTRRw3WXvIVrWuFE9l0mRcLysg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=ndmT7TuZ; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="ndmT7TuZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QJLsF625xQodBhKLrIRSnA0R/OwRdpfcF8e23Umlrpw=; b=ndmT7TuZK86EvgGw1rtBuhpK7j
	ujAFjMOdErp2EpcAcfHchVJfHD9eTbn44IpPrPhRXCUvozWub0Ftf3YWHUJX7BzRWsxW+g8RW+eCF
	OahGdrzvYQMRoVWHzGs6AcLMVNzznLkW10XJ6Q9CbGE4xQTMREvtrGkHQD7+Al0trWgVNO39xMAME
	wwp49gyJrQ+Pzg7DHLEx4WtmlBcFjadM/7rW0KrGaztj383ws/E9qWopq+hDXtCgETi649m5AaCOg
	PaGStvzhfN58W6NHW8e2ikPybPvgVrQGc6oaFcOEm9lwWS02MRPTOvOqppA3oNUd4BF8X5A1VnuI1
	UfRfx15A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.2)
	id 1wgVFr-00000002jw3-1JSr;
	Sun, 05 Jul 2026 19:24:03 -0300
Message-ID: <63d7c59828d152250b34aaaa73ce56e8@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Cc: Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH v2] smb: client: preserve leading slash for POSIX
 absolute symlink targets
In-Reply-To: <20260705211757.60659-1-stfrench@microsoft.com>
References: <20260705211757.60659-1-stfrench@microsoft.com>
Date: Sun, 05 Jul 2026 19:24:02 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> When creating a native SMB symbolic link (CIFS_SYMLINK_TYPE_NATIVE) whose
> target is an absolute path on a mount that uses POSIX paths, the leading
> path separator was silently dropped from the stored symlink target.
>
> create_native_symlink() converted the target to UTF-16 with
> cifs_convert_path_to_utf16().  That helper is intended for share-relative
> SMB paths and therefore unconditionally strips a leading path separator.
> For an absolute POSIX symlink target the leading '/' is significant, so a
> target of "/foo/bar" was stored - and read back - as "foo/bar", even
> though the reparse point was still flagged as absolute
> (SYMLINK_FLAG_RELATIVE cleared).
>
> On a POSIX paths mount the symlink target is stored verbatim, so convert
> it directly with cifs_strndup_to_utf16() instead.  This preserves the
> leading separator, avoids the leading-backslash stripping that
> cifs_convert_path_to_utf16() also performs (a backslash is a valid POSIX
> filename character), and uses NO_MAP_UNI_RSVD to match the readback path
> in smb2_parse_native_symlink(), which always converts the target with
> cifs_strndup_from_utf16() / NO_MAP_UNI_RSVD.  This mirrors how the NFS and
> WSL reparse symlink creators convert their targets.
>
> The NT-style absolute symlink handling, which needs the "\??\" prefix and
> drive-letter colon preserved, continues to use cifs_convert_path_to_utf16()
> together with the existing masking of those bytes.
>
> Fixes: 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style symlinks")
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/smb/client/reparse.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
