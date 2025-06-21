Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C82AD51;
	Sat, 21 Jun 2025 16:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750524770; cv=none; b=j5GpcoIWcWEDiSO89vtfYvQtzkJ9j1rL9BMSWglDnNMprm1QPGJ1QyFJKC4QohXULXh2o7DxYP8celknYFpzkIifcQ6qMSdOFhFfibT8QaonsOH4J5oSflvi2ZDevEqqsmA01k2BoiXtMhLqsq8TXJ3RdZoP8XcPjuEvCuhE/os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750524770; c=relaxed/simple;
	bh=C4V6BITK01gKrNQfHEyGf+PpKARDFZa+RaS5xcshGGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAvJd7vJjSKEZ3vFXJNHp5dHiHDUpZvfDc/BqaZuBZPTrCOpJzi4RZpals4kPHVALuzdCyzulRNmgSXRWan7Hq26XyoBab37el1mbsPod/tP+EsQDe3K5GSbn4z+JkedCahkun3WIGQVzuY99ajxEbRdZMKqrBan/4fdySq3LwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAkrmPUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAkrmPUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205F2C4CEE7;
	Sat, 21 Jun 2025 16:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750524769;
	bh=C4V6BITK01gKrNQfHEyGf+PpKARDFZa+RaS5xcshGGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GAkrmPUcKpmJk8j9rJCCiKJ6YC3fSE0fBPWOHMv8vrQdAPW8A5dQGVJl77bdRJOSW
	 ZZbsK7+O+NwI3KeO9TPFnfyKPC80NgNDnfPZePsAEHAFOulHX5H0jzu3Djsv7ipsgU
	 Os6SUp/H/XkyOAB7Dh+zPfDOsAfr9+Gyp2jv8lnhHFQk19+nPBCeqdOUSyoJAHmuHD
	 In63CFQmC8/N79MP40tB+Ff/QX3P/cvDtZfvTlbRcONWbYg2ewnFoOc/noRPkSPG7g
	 /2JHkiWHrOqWZ6JFDFMuBphPaxmCYqI8Nese4h/4qKrzX6aIn7efsvNxgS/2xncxjc
	 tHyWQzbM7d55w==
Received: by pali.im (Postfix)
	id C3674400; Sat, 21 Jun 2025 18:52:46 +0200 (CEST)
Date: Sat, 21 Jun 2025 18:52:46 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Steve French <sfrench@samba.org>, Remy Monsen <monsen@monsen.cc>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix lstat() and AT_SYMLINK_NOFOLLOW to work on
 broken symlink nodes
Message-ID: <20250621165246.5yvdolrrdchrbe22@pali>
References: <20250610213404.16288-1-pali@kernel.org>
 <26e59412fa2c70efad5f9c585bfc198f@manguebit.org>
 <20250621122139.3xq675cbs5kgkd7t@pali>
 <82bf746b2c44f9cccd7e3f4ca349d145@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82bf746b2c44f9cccd7e3f4ca349d145@manguebit.org>
User-Agent: NeoMutt/20180716

On Saturday 21 June 2025 12:38:34 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Friday 20 June 2025 20:44:37 Paulo Alcantara wrote:
> >> Pali Rohár <pali@kernel.org> writes:
> >> 
> >> > Currently Linux SMB client returns EIO for lstat() and AT_SYMLINK_NOFOLLOW
> >> > calls on symlink node when the symlink target location is broken or cannot
> >> > be read or parsed.
> >> >
> >> > Fix this problem by relaxing the errors from various locations which parses
> >> > information about symlink file node (UNIX SMB1, native SMB2+, NFS-style,
> >> > WSL-style) and let readlink() syscall to return EIO when the symlink target
> >> > location is not available.
> >> 
> >> Please, don't.  We still want those validations for the other types of
> >> symlinks.
> >
> > Well, validation was not removed. Validation is still there, just the
> > error is signalled by the readlink() syscall instead of the lstat() or
> > AT_SYMLINK_NOFOLLOW syscalls.
> >
> > My opinion is that the lstat() or AT_SYMLINK_NOFOLLOW should work on
> > symlink node independently of where the symlink points (and whether the
> > symlink target is valid POSIX path or not). That is because the lstat()
> > and AT_SYMLINK_NOFOLLOW says that the symlink target location must not
> > be used and must not be resolved.
> >
> > But still the invalid / incorrect / broken or non-representable symlink
> > target path in POSIX notation should be reported as an issue and the
> > readlink() is the correct syscall which should report these errors.
> 
> The only issue is breaking existing customer or user applications that
> really don't care if cifs.ko could follow those kind of symlinks.
> 
> Samba create symlinks to represent DFS links with targets like
> 'msdfs:srv1\share,srv2\share', which are not valid POSIX paths.  Does
> that mean the filesystem should not allow readlink(2) to succeed just
> because it is not a valid POSIX path?  Is that what you mean?

But this is something totally different thing.

Here you are referring to the behavior of Samba server, which interprets
symlink node stored on local filesystem named e.g. "link1" pointing to
target relative file name 'msdfs:srv1\share,srv2\share' specially.

Calling "ln -s 'msdfs:srv1\share,srv2\share' link1" is perfectly fine on
the ext4 filesystem. It creates a relative symlink to the specified
file.

And if you call "echo test > 'msdfs:srv1\share,srv2\share'" then it would
world correctly and "cat link1" will print "test".

The 'msdfs:srv1\share,srv2\share' is a valid POSIX path and it is stored
on the local Linux filesystem. So I do not see anything wrong with it or
reason why local filesystem should disallow creating such symlink or why
would realink() should fail on such node.


That example has nothing with symlinks stored on NTFS-compatible
filesystems which has ability to store symlinks pointing to non-POSIX
NT object model paths.

Here the issue is with symlink target locations which are coming from
the remote NT server and are pointing to location which cannot be
directly represented by the Linux system. The translation needs to be
done in both directions and reversible. Otherwise moving the file or
symlink from cifs to ext4 and back would damage the file or symlink.

> >> The problem is just that cifs.ko can't handle absolute
> >> symlink targets in the form of '\??\UNC\srv\share\foo', while Windows
> >> client can.  They are still valid symlink targets, but cifs.ko doesn't
> >> know how to follow them.
> >
> > Windows client can represent and follow such symlink because the symlink
> > is in the NT style format and Windows kernel uses NT style of paths
> > internally. Linux kernel uses POSIX paths and POSIX does not contain any
> > GLOBAL?? namespace for NT object hierarchy.
> >
> > Leaking raw NT object hierarchy from SMB to POSIX userspace via
> > readlink() syscall is a bad idea. Applications are really not expecting
> > that the readlink() syscall will return NT kernel internals (exported
> > over SMB protocol and passed to cifs.ko).
> >
> > For UNC paths encoded in NT object hierarchy, which is just some subset
> > of all possible NT paths, I had an idea that we could convert these
> > paths to some format like:
> >
> >    <prefix>/server/share/path...
> >
> > Where <prefix> would be specified by the string mount option. So user
> > could say that wants all UNC symlinks pointing to /mnt/unc/.
> >
> > And in the same way if user would want to create symlink pointing to
> > /mnt/unc/server/share/path... then cifs.ko will transform it into valid
> > NT UNC path and create a symlink to this location.
> 
> That's really a terrible idea.  The symlink targets in the form of
> '\??\UNC\...' could be resolved by cifs.ko.  The ones that refer to a
> file outside the mounted share, we would set those as automounts.

I agree that above is not the best idea, but I wrote at least something
as an idea as I do not know how it could be solved in better way.

And I do not see how it could be resolved by cifs.ko somehow
automatically. I'm not sure to which you refer how it can be resolved by
cifs.ko. I understood you message as it could automount another share
and do the whole path symlink resolving in cifs.ko.

And I think that this is even worse idea than mine. Because that
automount means that symlinks pointing outside of the share would start
behaving like a mount point. Such thing can cause even a security issues
if not used carefully.

But moreover there is a big difference between symlink and mount point.
Symlinks are not resolved by filesystem itself (but rather by the VFS,
to ensure that all access checks are applied) and also moving the
symlink between filesystems should not break them. In this idea when the
symlink is going to be moved from smb share to e.g. ext4 local fs, then
it would stops working (if the path resolved is in the cifs.ko) as
ext4.ko would not be able to process special cifs.ko symlinks.

> > But this would solve only problem with UNC symlink, not symlinks
> > pointing to NT object hierarchy in general.
> >
> >> The following should do it and then restore old behavior
> >> 
> >> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> >> index bb25e77c5540..11d44288e75a 100644
> >> --- a/fs/smb/client/reparse.c
> >> +++ b/fs/smb/client/reparse.c
> >> @@ -875,15 +875,8 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
> >>  			abs_path += sizeof("\\DosDevices\\")-1;
> >>  		else if (strstarts(abs_path, "\\GLOBAL??\\"))
> >>  			abs_path += sizeof("\\GLOBAL??\\")-1;
> >> -		else {
> >> -			/* Unhandled absolute symlink, points outside of DOS/Win32 */
> >> -			cifs_dbg(VFS,
> >> -				 "absolute symlink '%s' cannot be converted from NT format "
> >> -				 "because points to unknown target\n",
> >> -				 smb_target);
> >> -			rc = -EIO;
> >> -			goto out;
> >> -		}
> >> +		else
> >> +			goto out_unhandled_target;
> >>  
> >>  		/* Sometimes path separator after \?? is double backslash */
> >>  		if (abs_path[0] == '\\')
> >> @@ -910,13 +903,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
> >>  			abs_path++;
> >>  			abs_path[0] = drive_letter;
> >>  		} else {
> >> -			/* Unhandled absolute symlink. Report an error. */
> >> -			cifs_dbg(VFS,
> >> -				 "absolute symlink '%s' cannot be converted from NT format "
> >> -				 "because points to unknown target\n",
> >> -				 smb_target);
> >> -			rc = -EIO;
> >> -			goto out;
> >> +			goto out_unhandled_target;
> >>  		}
> >>  
> >>  		abs_path_len = strlen(abs_path)+1;
> >> @@ -966,6 +953,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
> >>  		 * These paths have same format as Linux symlinks, so no
> >>  		 * conversion is needed.
> >>  		 */
> >> +out_unhandled_target:
> >>  		linux_target = smb_target;
> >>  		smb_target = NULL;
> >>  	}
> >
> > I'm really not sure if removing the messages and error reporting about
> > symlinks which cannot be represented in POSIX system is a good idea.
> 
> Those messages are just useless and noisy.  Do you think it's useful
> printing that message for _every_ symlink when someone is calling
> readdir(2) in a directory that contain such files?

I though that for any debugging purposes these messages are useful.
Now I see that VFS level is printed always, so maybe the FYI level could
be better. Or do you really think that it is useless even for debugging?
