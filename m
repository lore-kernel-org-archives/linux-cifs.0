Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4A81BBBE4
	for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2024 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731682000; cv=none; b=qaw30Du2VRU4s6rvraC3XgAim1yI17Ip4iLGEwtSEUao/c8eA3WU3SLmCVje+4J6KR6khw5A2nMNNkvwEzLWyQp5DzUUsekHu8XEE2yBU3hZTHh311aoxICUDU4M8C35Xj80p37WFnH0CEvVG38bOPuqRFutMOrgzZ8CrrzS+3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731682000; c=relaxed/simple;
	bh=8MCo1pMqzmkyXC6Gcpj60rKMJDdXgPpXO2BSqq49slo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cucfM3xgDxM3D5KuQJXuV8RVzS0oCKX3lTMLBcJcnCV5ylO3+/LBKm0BJA0dWhbUn2zieMuhWK9rk/DdIGBf39PgZBhHil/DP8C8db70/oaW7I4DkqJ9VUuVX3VCAiH8c9XF49r0nanJLBIIw9mE0We3czpfl8k1nwqp1nuGX/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pQ3SV+ys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pQ3SV+ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7A3C4CECF;
	Fri, 15 Nov 2024 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731681999;
	bh=8MCo1pMqzmkyXC6Gcpj60rKMJDdXgPpXO2BSqq49slo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pQ3SV+ys20co/LIwz/c71gkjdzoJEr/t2aUWFb++/LO4ksjkHsnveup9zgyLqR0v9
	 lWz0Qasnpc4/9MaXdAfkp3FRO9z/d7LGUG/QB0wp4Z/am7C1idMAMRXp/zCmo7CBL9
	 31xRSQ1ZBMGTY2eeGW3KkhulYkh9HXOY23YRJLqXkAPnFwWbR+mluguOdKlMAKpbpO
	 Xx4Kguu9yecJeZnqmUl9M5iJbjZyrbjLlkgNe3Y4Z5JbSoKE7jN5LX+/hCTGvB12Sx
	 wY/jatDP7P6dbiYkwSFq+ZF5fs98zYCmlH2TQiZgS1qLZrXCQLvgGxW2OdUJm4snt4
	 Hd154aunRroSQ==
Received: by pali.im (Postfix)
	id 509859F1; Fri, 15 Nov 2024 15:46:31 +0100 (CET)
Date: Fri, 15 Nov 2024 15:46:31 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Ralph Boehme <slow@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	Steven French <Steven.French@microsoft.com>,
	Paulo Alcantara <pc@manguebit.com>, paalcant@redhat.com
Subject: Re: Using file type information from POSIX mode
Message-ID: <20241115144631.qkteeweaz44knr4c@pali>
References: <7ef51654-5fa7-4333-8922-40bae24b18bc@samba.org>
 <af3dab52-562c-439a-abca-b3d742d2716a@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3dab52-562c-439a-abca-b3d742d2716a@samba.org>
User-Agent: NeoMutt/20180716

Hello,

I would like to point out about one comment which I already discussed
with Ralph privately.

Mode as defined in that spec in section "2.1.1 posix mode" is _not_
compatible/same as the UNIX mode used by the Linux, BSD and other UNIX
systems.

The reason is that S_IFREG / S_IFDIR / S_IFLNK / S_IFCHR / S_IFBLK /
S_IFIFO / S_IFSOCK constants does not match with the values defined in
that SMB extension "2.1.1 posix mode".

This SMB extension defines type mask in 32-bit mode via bits 12-14 as:

0 - S_IFREG - regular file
1 - S_IFDIR - directory
2 - S_IFLNK - symlink
3 - S_IFCHR - character device
4 - S_IFBLK - block device
5 - S_IFIFO - FIFO
6 - S_IFSOCK - socket

And UNIX systems including Linux and BSD defines type mask in mode via
bits 12-16 as:

1  - S_IFIFO - FIFO
2  - S_IFCHR - character device
4  - S_IFDIR - directory
6  - S_IFBLK - block device
8  - S_IFREG - regular file
10 - S_IFLNK - symlink
12 - S_IFSOCK - socket

BSD additionally supports also:

14 - S_IFWHT - whiteout

Linux represents whiteout file as char device with both major and minor
numbers set to zero (and so this can be created by non-root user too).

Why where are "holes" in these ranges? This is because other UNIX V7
systems support also other file types. Whole list can be found for
example in extended Ubuntu xenial stat manpage, in section CONFORMING TO
in part "Other systems", which is available online at:
https://manpages.ubuntu.com/manpages/xenial/en/man2/stat.2.html

For completeness those types are:
0  - SCO out-of-service
3  - S_IFMPC - multiplexed character special
5  - S_IFNAM - XENIX named special file
7  - S_IFMPB - multiplexed block special
9  - S_IFCMP / S_IFNWK - VxFS compressed OR network special
11 - S_IFSHAD - Solaris shadow inode for ACL
13 - S_IFDOOR - Solaris door

I just wanted to highlight also for other developers that this SMB POSIX
spec that is not compatible with file type bits used in existing UNIX
systems. So if you are going to implement it, beware of it.

For me it looks very pity if a new spec is saying that is for POSIX
systems but is not compatible with existing UNIX / POSIX systems. But
well, I quite understand that Ralph wanted to do cleanup and remove
something which is not used anymore (like SCO or XENIX stuff; but I'm
not sure about Solaris, this is still used, also there is illumos).

Pali

On Tuesday 12 November 2024 10:30:21 Ralph Boehme wrote:
> ...resending to the right cifs list...
> 
> Folks?
> 
> -------- Forwarded Message --------
> Subject: Using file type information from POSIX mode
> Date: Sat, 9 Nov 2024 10:51:47 +0100
> From: Ralph Boehme <slow@samba.org>
> To: Steven French <Steven.French@microsoft.com>, Paulo Alcantara
> <palcantara@samba.org>
> CC: cifs-protocol@lists.samba.org <cifs-protocol@lists.samba.org>
> 
> Steve, Paulo,
> 
> it seems kernel client doesn't yet implement using file type information
> from the updated POSIX mode as discussed at SDC:
> 
> <https://www.samba.org/~slow/SMB3_POSIX/fscc_posix_extensions.html#posix-file-type-definition>
> 
> Any plans? Samba already implements this.
> 
> Thanks!
> -slow
