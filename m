Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E672AE8D;
	Sat, 21 Jun 2025 15:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750520321; cv=none; b=cSmFC03Y2kRp/IEgUvHAZbvsNhdha7ei2lrSNRPE22MwlArqE7871Qfn82DaFgU7OXuAOlByuQ9DgT32UCJwTHuv597hrqjgaZBdsvmYClAFUS9NIAp3qXns3ErtznIYsyaJpofetMj9ciRDjMIQni2JrQsAhmM0RuLORVObUX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750520321; c=relaxed/simple;
	bh=LeDpyYSR6p+/K41s/GHHCawtvnbpcs6sOzpl7rZSVfE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=lGtiRFtU97bzFQExLcA/8vswapvpJVRgGYlaDI2b2wEqFqdph6CmygMJZCDHDou6IXptAzHCij0Qfhz/MHwiVcv5P/LnrD2N/40ML4xRdbgwblaMi5QkYOAM9I89dzccZa81IaXLeG1rfsfrvw6aCvhNvsZrcFC+qDdTgb87e5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Y0wTNBvk; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Y0wTNBvk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=U2ZsFZSJxpetuM39KNMl2GJu7AoJ2Q1cr/uPrANJIyo=; b=Y0wTNBvkGB5oRX4OPVlQNf1J/v
	tIyhKnQsiPxkssvSkM/XZTVuOY7v4FOXv/jujcAfLGq6NBfZLo8s0nT+zq2r86EyC1TSKmvXPZl0A
	b98cwFDI23Y6nKNA70Pi1txlytkWA+QgZXngCuAcZCVsZTlstbQQMUZboThGXWMEYkZdHY5BZRRTv
	NIbnMEWyOaIvCAuYCRJ79zEgulAGNf16bbHP/ocbJcO8sIkDuBGzN+w/JPJjNOoojlE0zT+u5sY5O
	Ww9wmxkdQJ9/NGJcGNjtm7hkYMQH/mzbxsSKxtVckTLoc/lpEgBU2UbRObEYz81cJL1m2mnpPANOE
	2SS/p5Aw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uT0Id-00000000NPZ-3kAc;
	Sat, 21 Jun 2025 12:38:35 -0300
Message-ID: <82bf746b2c44f9cccd7e3f4ca349d145@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Remy Monsen <monsen@monsen.cc>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix lstat() and AT_SYMLINK_NOFOLLOW to work on
 broken symlink nodes
In-Reply-To: <20250621122139.3xq675cbs5kgkd7t@pali>
References: <20250610213404.16288-1-pali@kernel.org>
 <26e59412fa2c70efad5f9c585bfc198f@manguebit.org>
 <20250621122139.3xq675cbs5kgkd7t@pali>
Date: Sat, 21 Jun 2025 12:38:34 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Friday 20 June 2025 20:44:37 Paulo Alcantara wrote:
>> Pali Roh=C3=A1r <pali@kernel.org> writes:
>>=20
>> > Currently Linux SMB client returns EIO for lstat() and AT_SYMLINK_NOFO=
LLOW
>> > calls on symlink node when the symlink target location is broken or ca=
nnot
>> > be read or parsed.
>> >
>> > Fix this problem by relaxing the errors from various locations which p=
arses
>> > information about symlink file node (UNIX SMB1, native SMB2+, NFS-styl=
e,
>> > WSL-style) and let readlink() syscall to return EIO when the symlink t=
arget
>> > location is not available.
>>=20
>> Please, don't.  We still want those validations for the other types of
>> symlinks.
>
> Well, validation was not removed. Validation is still there, just the
> error is signalled by the readlink() syscall instead of the lstat() or
> AT_SYMLINK_NOFOLLOW syscalls.
>
> My opinion is that the lstat() or AT_SYMLINK_NOFOLLOW should work on
> symlink node independently of where the symlink points (and whether the
> symlink target is valid POSIX path or not). That is because the lstat()
> and AT_SYMLINK_NOFOLLOW says that the symlink target location must not
> be used and must not be resolved.
>
> But still the invalid / incorrect / broken or non-representable symlink
> target path in POSIX notation should be reported as an issue and the
> readlink() is the correct syscall which should report these errors.

The only issue is breaking existing customer or user applications that
really don't care if cifs.ko could follow those kind of symlinks.

Samba create symlinks to represent DFS links with targets like
'msdfs:srv1\share,srv2\share', which are not valid POSIX paths.  Does
that mean the filesystem should not allow readlink(2) to succeed just
because it is not a valid POSIX path?  Is that what you mean?

>> The problem is just that cifs.ko can't handle absolute
>> symlink targets in the form of '\??\UNC\srv\share\foo', while Windows
>> client can.  They are still valid symlink targets, but cifs.ko doesn't
>> know how to follow them.
>
> Windows client can represent and follow such symlink because the symlink
> is in the NT style format and Windows kernel uses NT style of paths
> internally. Linux kernel uses POSIX paths and POSIX does not contain any
> GLOBAL?? namespace for NT object hierarchy.
>
> Leaking raw NT object hierarchy from SMB to POSIX userspace via
> readlink() syscall is a bad idea. Applications are really not expecting
> that the readlink() syscall will return NT kernel internals (exported
> over SMB protocol and passed to cifs.ko).
>
> For UNC paths encoded in NT object hierarchy, which is just some subset
> of all possible NT paths, I had an idea that we could convert these
> paths to some format like:
>
>    <prefix>/server/share/path...
>
> Where <prefix> would be specified by the string mount option. So user
> could say that wants all UNC symlinks pointing to /mnt/unc/.
>
> And in the same way if user would want to create symlink pointing to
> /mnt/unc/server/share/path... then cifs.ko will transform it into valid
> NT UNC path and create a symlink to this location.

That's really a terrible idea.  The symlink targets in the form of
'\??\UNC\...' could be resolved by cifs.ko.  The ones that refer to a
file outside the mounted share, we would set those as automounts.

> But this would solve only problem with UNC symlink, not symlinks
> pointing to NT object hierarchy in general.
>
>> The following should do it and then restore old behavior
>>=20
>> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
>> index bb25e77c5540..11d44288e75a 100644
>> --- a/fs/smb/client/reparse.c
>> +++ b/fs/smb/client/reparse.c
>> @@ -875,15 +875,8 @@ int smb2_parse_native_symlink(char **target, const =
char *buf, unsigned int len,
>>  			abs_path +=3D sizeof("\\DosDevices\\")-1;
>>  		else if (strstarts(abs_path, "\\GLOBAL??\\"))
>>  			abs_path +=3D sizeof("\\GLOBAL??\\")-1;
>> -		else {
>> -			/* Unhandled absolute symlink, points outside of DOS/Win32 */
>> -			cifs_dbg(VFS,
>> -				 "absolute symlink '%s' cannot be converted from NT format "
>> -				 "because points to unknown target\n",
>> -				 smb_target);
>> -			rc =3D -EIO;
>> -			goto out;
>> -		}
>> +		else
>> +			goto out_unhandled_target;
>>=20=20
>>  		/* Sometimes path separator after \?? is double backslash */
>>  		if (abs_path[0] =3D=3D '\\')
>> @@ -910,13 +903,7 @@ int smb2_parse_native_symlink(char **target, const =
char *buf, unsigned int len,
>>  			abs_path++;
>>  			abs_path[0] =3D drive_letter;
>>  		} else {
>> -			/* Unhandled absolute symlink. Report an error. */
>> -			cifs_dbg(VFS,
>> -				 "absolute symlink '%s' cannot be converted from NT format "
>> -				 "because points to unknown target\n",
>> -				 smb_target);
>> -			rc =3D -EIO;
>> -			goto out;
>> +			goto out_unhandled_target;
>>  		}
>>=20=20
>>  		abs_path_len =3D strlen(abs_path)+1;
>> @@ -966,6 +953,7 @@ int smb2_parse_native_symlink(char **target, const c=
har *buf, unsigned int len,
>>  		 * These paths have same format as Linux symlinks, so no
>>  		 * conversion is needed.
>>  		 */
>> +out_unhandled_target:
>>  		linux_target =3D smb_target;
>>  		smb_target =3D NULL;
>>  	}
>
> I'm really not sure if removing the messages and error reporting about
> symlinks which cannot be represented in POSIX system is a good idea.

Those messages are just useless and noisy.  Do you think it's useful
printing that message for _every_ symlink when someone is calling
readdir(2) in a directory that contain such files?
