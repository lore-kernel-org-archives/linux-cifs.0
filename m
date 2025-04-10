Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738191E5702
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 16:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744301264; cv=none; b=Zm6WtG8uB1EKqnDMqw1t+mD1RUYAQzNur8cNjRClPzs/EdXjnCqwO+4IZL+P1IbjOrUb0L74OkHdLtMKokv09YwrQZnm8CJ3fOaThY+SheLBKb9tXA1GTwTFQk8+grftH0k+VvOxhTYWZa1MKmDn+NGp/LVjlbRfP8aptRGu6e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744301264; c=relaxed/simple;
	bh=cHSQ8XUpHP4UzHpNX2W1HbttojbwL+CIL15/E5ApSK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scc+FcdlbCOdB9k51+7BOSADiF9a4HarTso+XhODXaGYZocqOfYVCGtM2dBPLg6Fw7TUeFgdFB3BJcy2LGFkV5xbsp7vcWm6kKBeq+ZoXdA+afJHP2xSUHYap1Qr5yfUnaF6oJHzWjx7N6uLjUw/w+WubGoZc+BkxenBIxOK1dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVClqiAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVClqiAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAABAC4CEDD;
	Thu, 10 Apr 2025 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744301263;
	bh=cHSQ8XUpHP4UzHpNX2W1HbttojbwL+CIL15/E5ApSK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KVClqiATAyKVC2UIm2pr9lVAHH3j59u3ukwTj+EPDL1+8I6ViSiGb9yWX/y/Ldm/j
	 NJKbhUZfYL9Z2UXy3YQHrzAVy2v9sD4gF7GcbB2fbDgU7GfXcYCMsIE3IaA2btjqk0
	 m6Zuq7e3jtZrD+dRd90aD67/btZdntUhUhJKDH0/UdET3ZDYLSmepT6tAwCCART0HS
	 q4OQ0hGEQEhTi14dnIt1CP2gKmC/9Ei6X8U/+Khl8eva0palQoGe6dkBZiSBX0t1Z3
	 lrOTSRSx6RqFtuQyoXHisL4JshQoRjdJ2bxZVR26Vsz1FAmH97EfG0W6Sawr1R4NQW
	 UolSiXNF5d6hg==
Received: by pali.im (Postfix)
	id A6409598; Thu, 10 Apr 2025 18:07:40 +0200 (CEST)
Date: Thu, 10 Apr 2025 18:07:40 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
	Tom Talpey <tom@talpey.com>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Handling deleted files which are still open on the Linux client
Message-ID: <20250410160740.nxad4kqwikhsp7xt@pali>
References: <CAH2r5muEV7=ygqdCe+mrDgXXXtoEEF69HxgeWkD05Z1KY1jJ-A@mail.gmail.com>
 <CAN05THQGpzKTLXzFh8sc=h=rFQACBgFDhSzqNacrOp-50vGSOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN05THQGpzKTLXzFh8sc=h=rFQACBgFDhSzqNacrOp-50vGSOA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Thursday 10 April 2025 16:18:17 ronnie sahlberg wrote:
> On Wed, 9 Apr 2025 at 23:14, Steve French via samba-technical <
> samba-technical@lists.samba.org> wrote:
> 
> > There was a suggestion (see attached patch) to change how we report
> > errors on a file which is deleted (usually by the same Linux client)
> > but still open (so "STATUS_DELETE_PENDING" if another process or
> > client tries to open it).   It can be confusing when an open file is
> > deleted to see it in "ls" output (until the file is closed and removed
> > from the namespace).   This is not an issue when using the SMB3.1.1
> > POSIX/Linux extensions but if the server were e.g. Windows it can be
> > confusing.
> >
> > Currently we return "ENOENT" which is more accurate (since the file
> > should not be displayed in directory listings, and attempts to open
> > such a file should fail in order to obey POSIX/Linux semantics), but
> > the suggestion in attached patch is to change that to "EBUSY" which
> > may imply that the file will be accessible in the future (which in
> > POSIX/Linux would not be the case so could be confusing).
> >
> > There may be better ways to handle this as well (e.g. simply filter
> > out from query dir responses any files which we know are in delete
> > pending state - since one common scenario is getting this error when
> > doing an ls of a directory which contains an open file which has been
> > deleted).
> >
> 
> This is an area where it is impossible to match semantics exactly because
> the semantics are just different.
> 
> Filtering the readdir results feels like the wrong thing to do. It is just
> trading one
> bad experience for another.
> For example, if it is filtered out  and a client tries to create a new file
> with the same
> filename,   should they see "EEXIST"?
> According to readdir() the object does not exist but if you try to create
> it you can't because EEXIST.

Exactly, this is another case where the filtering or returning ENOENT is
causing problems.

> IMHO the least bad option is probably to let the object show up in
> readdir() but
> return an error to applications that want to operate on it.
> Maybe consiider such files as having the same behaviour as a "chattr +i"
> file that has mode 0000
> and can not be opened for reading neither data not attributes.

This is what I already suggested. To return EBUSY from open(), instead
of ENOENT. Some other suggestions which I receive was to return ESTALE.

> 
> 
> >
> > One of my concerns is that with this change "stat
> > /mnt/deleted-but-still-open-file" could return EBUSY which implies the
> > filename still exists (which violates the whole point of delete in
> > POSIX), and a simpler fix is to just make sure we don't show any files
> > (e.g. in readdir) in delete pending state and make sure their dentries
> > are gone.
> >
> > Any thoughts?
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >
