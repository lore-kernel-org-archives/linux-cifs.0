Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8802B204086
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 22:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739400223; cv=none; b=jdZOj+tkD2tfo4IWQz3x/Ta2vlh5/nogyMBD6KOT1WXQ15CMoaz+BEZdFk8OxuNl1tKKsIb2hmY+B0vkBpsqaUz4l1MSQfnQpbXe5tbWTKvXE6WWLpWJ+GddeFTT1hhjbelX0RpTA0ITeOFhxv/nGsebMLzQ3n3poTLvovnpts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739400223; c=relaxed/simple;
	bh=WnPNHj55/0y1VyyZtv8JwRW+YEFYDn6di+Z6cUreZdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Br96LzfTADn0jFThNUgUWBQqxBUIHoLu2A+ybfPRhiuZ8HH3o8dB3i0pBPL9MGvjHyVUzU/bkirmXbaFRET0a5ZNSm8KripCFQY6exCiLWAMfXeYABvmep6VbHaWaQZJ9XI6T9Mqop0Z2/Sp8efONTiyE0gxN786cNqIB9pBjJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuH5iz6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuH5iz6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7273C4CEDF;
	Wed, 12 Feb 2025 22:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739400223;
	bh=WnPNHj55/0y1VyyZtv8JwRW+YEFYDn6di+Z6cUreZdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MuH5iz6SGY47edqnCnRUB6dEw4Lf846DMN1nwWp++PyGfp6den92XhamD/kvG/PuB
	 X+of6Xj+NRAWlMsEOlO2/liFL5lv8TfWqMm+vztSZgUr+kyUsUodLZbG3kBAkXFzYi
	 weX+VWuDWQqsTqYkBK/K06KQexvDbAs8P5DDA1Vl0Ef/AflzIv3qhbmDy069PSqKRP
	 fS5neT4+r4Ej77WgK83iBC5lzZA5xYAhjpK6oeWbV1rsAbOYe7GpiQ+oBlT4I5fJmE
	 V/KhrMTKHtbIhdOg0NuCWmrafg8+ecf/aCLAPRiGNTVxz3i8PW/AUUGMz3KF+GH1mU
	 7cmLMx8YaZwEw==
Received: by pali.im (Postfix)
	id 7975E40E; Wed, 12 Feb 2025 23:43:30 +0100 (CET)
Date: Wed, 12 Feb 2025 23:43:30 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
Message-ID: <20250212224330.g7wmpd225fripkit@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92b554876923f730500a4dc734ef8e77@manguebit.com>
User-Agent: NeoMutt/20180716

On Wednesday 12 February 2025 19:19:00 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
> >> Steve,
> >> 
> >> The commit 438e2116d7bd ("cifs: Change translation of
> >> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) because it
> >> expects -EIO to be returned from getxattr(2) when the client can't read
> >> system.cifs_ntsd_full attribute and then fall back to system.cifs_acl
> >> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but that's a
> >> different problem, though.
> >> 
> >> Reproduced against samba-4.22 server.
> >
> > That is bad. I can prepare a fix for cifs.ko getxattr syscall to
> > translate -EPERM to -EIO. This will ensure that getcifsacl will work as
> > before as it would still see -EIO error.
> 
> Sounds good.
> 
> > But as discussed before, we need to distinguish between
> > privilege/permission error and other generic errors (access/io).
> > So I think that we need 438e2116d7bd commit.
> 
> OK.
> 
> > Based on linux-fsdevel discussion it is a good idea to distinguish
> > between errors by mapping status codes to appropriate posix errno, and
> > then updating linux syscall manpages.
> 
> Either way, we shouldn't be leaking -EIO or -EPERM to userland from
> getxattr(2).  By looking at the man pages, -ENODATA seems to be the
> appropriate error to return instead.

It looks like there are missing error codes for getxattr. Because any
path based syscall can return -EACCES if trying to open path to which
calling process does not have access.

And EACCES is not mentioned nor documented in getxattr(2). Same applies
for listxattr(2). Now I have tried listxattr() and it really returns
EACCES for /root/file called by nobody.

-EIO is generic I/O error. And I think that this error code could be
returned by any I/O syscall when unknown I/O error occurs.

Returning -ENODATA for generic or unknown I/O error is a bad idea
because ENODATA (= ENOATTR) has already specific meaning when attribute
does not exists at all (or process does not have access to it).

For me it makes sense to return -EIO and -EPERM by those syscalls. But
for getxattr() we cannot do it due that backward compatibility needed by
getcifsacl application.
