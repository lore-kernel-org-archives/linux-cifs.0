Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9242253E4
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 13:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206693; cv=none; b=O2JMJ6neqDOUgFRRiNdchEAPltUZ8iX1idyCPxYSdT4z3fJ4NbymAZ6xUA7xFTsnQ9fnOnkR4u8M+MCpMKYXr42LpezXFlButptHJ1BimtocOZwX1qGqoMRi2JCT7wZUVN6m1XAcVb+D5twXExX20m9DYJLOpPnWAG8bMZ3A9Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206693; c=relaxed/simple;
	bh=AU2wPGZZ5+pgfbiAqkCQeJuw04Py2z0rb0AoQNc2IOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtFgwH/mejhoZvfaBS6OU1vuU7zLff70BCeIDiYOoZVBdfPJ/phC629Jtl156Ycgo6Joi47LRqF64ZK6H6QCfwZhZJl9mLZp++rTJdOG7gJ4hlvUqpPq4TvscBgDyBYXF05FX96aLl1ymOPjF47x5gjxzJKGyRbZCpE/mgTZzSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WoRv/L5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WoRv/L5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD74C4CEE3;
	Wed,  9 Apr 2025 13:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744206691;
	bh=AU2wPGZZ5+pgfbiAqkCQeJuw04Py2z0rb0AoQNc2IOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WoRv/L5qOpBK2pP/hPlyKynJm9ecLLI4l7FmAdDjxCMwTQBJM1p2fnFSit/7GoU+a
	 QJ0xIM7TIJdd37qN1RbV83yLAKb4/VjXikVgryBjWlidNx6RaHlh7nxix8SwhHAIi1
	 ZqWD+PMK/FANrYtmknysgrJ5o/NZy7qbapNBYqAJ2ecnE0TDKVX5uJI5KLrL/REzsA
	 zjDx/5gCKKFNxp7dowgFpt5unR2qVyIzojT5oXy1dWAXc+eUFa6V1g+19U2KrOlgX6
	 rcaenvOLZKmo8xBC4zZ6l0KXIl1ITiluiXShr1iqpmO8lsCoFBWo41F8KH6UYwjoYw
	 nB6azrFqQuuAA==
Received: by pali.im (Postfix)
	id 4BBBD4B3; Wed,  9 Apr 2025 15:51:28 +0200 (CEST)
Date: Wed, 9 Apr 2025 15:51:28 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	Tom Talpey <tom@talpey.com>
Subject: Re: Handling deleted files which are still open on the Linux client
Message-ID: <20250409135128.mzwcyakxg22fk2xw@pali>
References: <CAH2r5muEV7=ygqdCe+mrDgXXXtoEEF69HxgeWkD05Z1KY1jJ-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muEV7=ygqdCe+mrDgXXXtoEEF69HxgeWkD05Z1KY1jJ-A@mail.gmail.com>
User-Agent: NeoMutt/20180716

Hello,

On Wednesday 09 April 2025 08:13:19 Steve French wrote:
> There was a suggestion (see attached patch) to change how we report
> errors on a file which is deleted (usually by the same Linux client)
> but still open (so "STATUS_DELETE_PENDING" if another process or
> client tries to open it).   It can be confusing when an open file is
> deleted to see it in "ls" output (until the file is closed and removed
> from the namespace).   This is not an issue when using the SMB3.1.1
> POSIX/Linux extensions but if the server were e.g. Windows it can be
> confusing.

This is related only to the Windows SMB server (or other servers which
implements only the Windows behavior; not POSIX).

> Currently we return "ENOENT" which is more accurate (since the file
> should not be displayed in directory listings, and attempts to open
> such a file should fail in order to obey POSIX/Linux semantics), but
> the suggestion in attached patch is to change that to "EBUSY" which
> may imply that the file will be accessible in the future (which in
> POSIX/Linux would not be the case so could be confusing).

My point is that the directory entry in the STATUS_DELETE_PENDING state
is not deleted. The directory entry when is in this state it still
exists. And Windows application (or Windows SMB client) can change this
STATUS_DELETE_PENDING state to the normal state at any time. Basically
it is like transaction. After changing directory entry into the
STATUS_DELETE_PENDING you need to either "confirm" this deletion or to
"cancel" it.

The Linux SMB client does not support this "cancel" functionality but
any other clients can support it and Windows one is example.

So in my opinion I think that on Windows the directory entry in the
STATUS_DELETE_PENDING is not removed and hence I think that reporting
"ENOENT" on Linux to userspace is not correct. The entry still exists.

On POSIX/Linux there is unlink syscall which completely removes the
directory entry. This is opposite of the STATUS_DELETE_PENDING which
just puts the directory entry into some temporary / pending state.
The unlink cannot be "cancelled".

> There may be better ways to handle this as well (e.g. simply filter
> out from query dir responses any files which we know are in delete
> pending state - since one common scenario is getting this error when
> doing an ls of a directory which contains an open file which has been
> deleted).

I think that filtering out directory entries which are in
STATUS_DELETE_PENDING from the readdir() is not a good idea. Because in
this case the readdir() on directory which has only STATUS_DELETE_PENDING
children would return empty list of entries, but the rmmdir() would fail
on it with error ENOTEMPTY. This is because entries in
STATUS_DELETE_PENDING still exists in that directory and Windows really
does not allow to remove directory which contain child entries (and it
does not matter if the child entries are in normal state or in
STATUS_DELETE_PENDING state).

So I think it would be very confusing if Linux readdir() would report
that directory is empty but rmdir() will fail with ENOTEMPTY error.
I think that this would be less accurate with POSIX behavior.

> One of my concerns is that with this change "stat
> /mnt/deleted-but-still-open-file" could return EBUSY which implies the
> filename still exists (which violates the whole point of delete in
> POSIX), and a simpler fix is to just make sure we don't show any files
> (e.g. in readdir) in delete pending state and make sure their dentries
> are gone.

My other patches in that series are improving SMB client to allow
calling "stat /mnt/deleted-but-still-open-file" and fill stat buffer
without EBUSY error. Just opening a file for reading or writing would
fail with EBUSY.

On Windows and also over SMB it is possible to do "stat" also for
directory entries which are in STATUS_DELETE_PENDING.

And important is that Windows C stat() function in msvcrt.dll and UCRT
libraries is already allowing it and working fine also with files in
STATUS_DELETE_PENDING.

Note that NFS3 (client) has similar problem. Its unlink syscall is
implemented as silly-rename, it just rename file and disallow opening
it. But the directory entry still exists, other users can call "stat" on
it, just cannot open it.

So I think that returning EBUSY, which implies that the filename still
exists is a correct thing to do. Because the file really still exists.
It was not removed / unlinked from the directory yet. And hence also the
directory cannot be removed yet because it contains child entries.

Note that this whole thing is only for Windows SMB behavior, not the
Samba or other POSIX implementation where the real unlink happens.

> Any thoughts?
> 
> 
> -- 
> Thanks,
> 
> Steve


