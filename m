Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DCD202984;
	Sat, 21 Jun 2025 12:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750508503; cv=none; b=BP3amhBqKQzFjNoC0bNvSOvZP/hNacIROVfctze+6YS3iUHCBDDSYmPiCVJEgTsF8YTLAXhNrJpz+YZEQYSSaw58P+BTyA2cAaAWu4VGh7CJx2CAraD1Dk2aycvSGxTnB8nCkBhUOuAsLefS1O3QrgwLjldlZaZqcAPPnoxYZjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750508503; c=relaxed/simple;
	bh=bCXTNJFcuWJBhQPSMtN4ZX7UKwXQjfj35CtPr9jKOqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jFZFVU33vJpnMZ9NEjSM3wBfVdEaZrEBJC6CZp8bFbiYPIYgtNvapqsUPe4Acf41wCzhHpKr90ibe+MlOcGj/UzolyNVXIR0Cmrg1FlIFszJUWGPFQDaNiEQb6pexUE48u1Ylfn6zzrDNOFqzZ2cFKjnmx/cpP3Y2eo5nDuTFP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayZRG9S6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayZRG9S6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA27C4CEE7;
	Sat, 21 Jun 2025 12:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750508502;
	bh=bCXTNJFcuWJBhQPSMtN4ZX7UKwXQjfj35CtPr9jKOqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ayZRG9S6pP2L6sR2ryTFXX6BpMhybkfKb/gETZJZmi5xivacmFCxLXIVnn64H3nT8
	 YPZL15zbwt5fl9/RVcvroT7HaIFKjlGlC5mbbzwiNqPQr3zfRd5Wdzls2HuxPVi4DS
	 9MnUC5iTTGCBH1tOjDaIWd1aTsHeIZaH8psfTDghMq4k1nu7sLJRvu4P/RWUBR9/2i
	 arZb2xw5XFMPYdo/kk9J2F7mPanI7Zzbw06lOqauOjlfEra+ZNkzsHn6R7rCdwKWlW
	 vyHlZwnTSeVOGCazoa7OAHX8YZJOb0IW6PnNYjJE3GAFVrRGTmnRZ8io1D0L6O7n3O
	 B6lF61kpayVnA==
Received: by pali.im (Postfix)
	id 95CEA3D2; Sat, 21 Jun 2025 14:21:39 +0200 (CEST)
Date: Sat, 21 Jun 2025 14:21:39 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Steve French <sfrench@samba.org>, Remy Monsen <monsen@monsen.cc>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix lstat() and AT_SYMLINK_NOFOLLOW to work on
 broken symlink nodes
Message-ID: <20250621122139.3xq675cbs5kgkd7t@pali>
References: <20250610213404.16288-1-pali@kernel.org>
 <26e59412fa2c70efad5f9c585bfc198f@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26e59412fa2c70efad5f9c585bfc198f@manguebit.org>
User-Agent: NeoMutt/20180716

On Friday 20 June 2025 20:44:37 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > Currently Linux SMB client returns EIO for lstat() and AT_SYMLINK_NOFOLLOW
> > calls on symlink node when the symlink target location is broken or cannot
> > be read or parsed.
> >
> > Fix this problem by relaxing the errors from various locations which parses
> > information about symlink file node (UNIX SMB1, native SMB2+, NFS-style,
> > WSL-style) and let readlink() syscall to return EIO when the symlink target
> > location is not available.
> 
> Please, don't.  We still want those validations for the other types of
> symlinks.

Well, validation was not removed. Validation is still there, just the
error is signalled by the readlink() syscall instead of the lstat() or
AT_SYMLINK_NOFOLLOW syscalls.

My opinion is that the lstat() or AT_SYMLINK_NOFOLLOW should work on
symlink node independently of where the symlink points (and whether the
symlink target is valid POSIX path or not). That is because the lstat()
and AT_SYMLINK_NOFOLLOW says that the symlink target location must not
be used and must not be resolved.

But still the invalid / incorrect / broken or non-representable symlink
target path in POSIX notation should be reported as an issue and the
readlink() is the correct syscall which should report these errors.

> The problem is just that cifs.ko can't handle absolute
> symlink targets in the form of '\??\UNC\srv\share\foo', while Windows
> client can.  They are still valid symlink targets, but cifs.ko doesn't
> know how to follow them.

Windows client can represent and follow such symlink because the symlink
is in the NT style format and Windows kernel uses NT style of paths
internally. Linux kernel uses POSIX paths and POSIX does not contain any
GLOBAL?? namespace for NT object hierarchy.

Leaking raw NT object hierarchy from SMB to POSIX userspace via
readlink() syscall is a bad idea. Applications are really not expecting
that the readlink() syscall will return NT kernel internals (exported
over SMB protocol and passed to cifs.ko).

For UNC paths encoded in NT object hierarchy, which is just some subset
of all possible NT paths, I had an idea that we could convert these
paths to some format like:

   <prefix>/server/share/path...

Where <prefix> would be specified by the string mount option. So user
could say that wants all UNC symlinks pointing to /mnt/unc/.

And in the same way if user would want to create symlink pointing to
/mnt/unc/server/share/path... then cifs.ko will transform it into valid
NT UNC path and create a symlink to this location.

But this would solve only problem with UNC symlink, not symlinks
pointing to NT object hierarchy in general.

> The following should do it and then restore old behavior
> 
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index bb25e77c5540..11d44288e75a 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -875,15 +875,8 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
>  			abs_path += sizeof("\\DosDevices\\")-1;
>  		else if (strstarts(abs_path, "\\GLOBAL??\\"))
>  			abs_path += sizeof("\\GLOBAL??\\")-1;
> -		else {
> -			/* Unhandled absolute symlink, points outside of DOS/Win32 */
> -			cifs_dbg(VFS,
> -				 "absolute symlink '%s' cannot be converted from NT format "
> -				 "because points to unknown target\n",
> -				 smb_target);
> -			rc = -EIO;
> -			goto out;
> -		}
> +		else
> +			goto out_unhandled_target;
>  
>  		/* Sometimes path separator after \?? is double backslash */
>  		if (abs_path[0] == '\\')
> @@ -910,13 +903,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
>  			abs_path++;
>  			abs_path[0] = drive_letter;
>  		} else {
> -			/* Unhandled absolute symlink. Report an error. */
> -			cifs_dbg(VFS,
> -				 "absolute symlink '%s' cannot be converted from NT format "
> -				 "because points to unknown target\n",
> -				 smb_target);
> -			rc = -EIO;
> -			goto out;
> +			goto out_unhandled_target;
>  		}
>  
>  		abs_path_len = strlen(abs_path)+1;
> @@ -966,6 +953,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
>  		 * These paths have same format as Linux symlinks, so no
>  		 * conversion is needed.
>  		 */
> +out_unhandled_target:
>  		linux_target = smb_target;
>  		smb_target = NULL;
>  	}

I'm really not sure if removing the messages and error reporting about
symlinks which cannot be represented in POSIX system is a good idea.
