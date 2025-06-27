Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B1A28C01A;
	Fri, 27 Jun 2025 22:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751064373; cv=none; b=f6FF7cMZ5nDpbhZQrL/mwoekzQkkQ9hLBdf09q4TmfVLu4sr69c/WOkiSq2cIGXkF8xC3ir26CsB7T1vk38IVOIT1nCLp/vkXzKP4DRNQ+9M9izOA5IsTsAYBTrSUFDcwxKGh7FrGSqBFKXOWuhy+DBaBuBc9Kuxk7pEU4yqWxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751064373; c=relaxed/simple;
	bh=GU55lxD9uzmNJ+AgHy+SlLXDCJeuVoTW/vu46yAsei8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KoiccQ3JC0SpN1pDcQVhs4WNvYHZstIXK+o5xCW4KSN9VHIg//W4u7OjREUufOlyFnReAYHf/EOoBHf/qGFj01JD750macWAACYWEJa2RYHhXvwSO0nKHYaf/s4QM0Y6vtP7W3SmwEW9600yK55wZfXCEbzoifVeHLTqs0FKPqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZsNHF90D; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZsNHF90D"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6facba680a1so3653046d6.3;
        Fri, 27 Jun 2025 15:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751064370; x=1751669170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PNkhiqu6Jzw3ay2jaDRsopeLR/MqOz1ux7VjJwYP5MQ=;
        b=ZsNHF90DHVaHo9dyyLfvRDQyP1Ni1UBzL93owj+AeW3eeDZccY1MaSA/r2A7CjC3aA
         jaNAJR/MXq3ibYfD0BT0beJbqoAR3cAuPwtYo/KMWBefaYjgRa0pdQuz7yeVbradvmtX
         Q0rU1bSVbeiaHr9Pu1RXrtFP7jOzH5NgvIHUwfX3lF8a32E/HdkAJ0MfS8TTAc2CQwgO
         KgTOvI0NbgdG4DWVtf0RkLbTsXZDBxZihlvyfpQE3WIVJHOII/2I1x1ElY3YrmQZazSP
         SgzBaiJXrJWZQtOSFzoyp4knfC8sWlUxXqH7/BJWpOeJVWKN7RMgEy1hR8NYsPItfRvU
         kVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751064370; x=1751669170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PNkhiqu6Jzw3ay2jaDRsopeLR/MqOz1ux7VjJwYP5MQ=;
        b=ElGAd1mK1RNZWkETc+NcEuAcIHjQhUhBFKPhyDzdR5jRMPNHM6y1g8jQ9koHDYsI7X
         IQ8+EsMy/K20u88cFoCZgLdEQL+66olVEchsJ/MLTSKrZ3xneL3S3EPgTvK9v35eGUCP
         SvIvCEq9L7GICqzQahpQSQXNpHJXz/GxRFM9bLdnGYM7D0q97Eo466TulLOz50byBtq3
         tgbVlNqBXw4hAk7e5g7Qxl75ztU6O2PMQvnn890ZvAbb6Q5vGOwz7kNRANabydLtkjwV
         Q0MvYC16jhRf4/rnCfNwn4RPFdW0RO6KpTca7OPUOyfOd6Gsi/5dJJ1x8Lwtc4GYr66a
         OoHg==
X-Forwarded-Encrypted: i=1; AJvYcCWk5UBmH+ZssaqGSSLrTg8a1soveBa8yCZe3Ks8++W28BaybhIChjghq/VkI4IqqOzRt1XLY4SxCBzP@vger.kernel.org, AJvYcCXIUPqQWI1jd1RWKKTko+CZXwaTSnuejesow7QSj023KTTPURG1RBiLXf30O+wSSTqSX7lz8xRv9lWb0WjU@vger.kernel.org
X-Gm-Message-State: AOJu0YyCbHBnxcfTkIcmNIdrgTzeRLKn1jCO8+f7f9brVQDmqcUXmxBw
	6ECitDcWz6jEWNxr4Z1yJ9p1GWkcd+cvMycXV3IarPnBsJSSEnunurtf8P8Ulp7HdT7ox8tssRL
	dxN5QIRyyXfAuSNXhj0IfzQIuKW95upo=
X-Gm-Gg: ASbGncuuOmr7q3b2rSPiSaiTxXdbdnRkiCQ+GCOH46yKdYHgXGJnVQnaEiC9x6tnEyW
	So+yzXjo8EeSXTweuaZdjlBGepJLUJ9LPwtfDK06pNL+9gRzXlrBSv7jb/+xvD5BXSX2ztypTn3
	CN9BPNLC1AsJvcqYWhdtnm430/YrrczjxJ1uKMVYHhoilDrPdTYGn7k4i+rYZZvZ+ehiTdIo25R
	flO
X-Google-Smtp-Source: AGHT+IGFNQzwynjMtkt48Yw2DxxGLD78zPRilcYBpFHDBpckvEqXf4/o+Vne0gRco4JopG9AvipDEs1/aOSym/ARt5I=
X-Received: by 2002:a05:6214:3008:b0:6f8:b7cd:984f with SMTP id
 6a1803df08f44-70013d52bd7mr72454136d6.30.1751064369613; Fri, 27 Jun 2025
 15:46:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250610213404.16288-1-pali@kernel.org> <26e59412fa2c70efad5f9c585bfc198f@manguebit.org>
 <20250621122139.3xq675cbs5kgkd7t@pali> <82bf746b2c44f9cccd7e3f4ca349d145@manguebit.org>
 <20250621165246.5yvdolrrdchrbe22@pali> <20250627210331.qpp7bmpjnux63eow@pali>
In-Reply-To: <20250627210331.qpp7bmpjnux63eow@pali>
From: Steve French <smfrench@gmail.com>
Date: Fri, 27 Jun 2025 17:45:58 -0500
X-Gm-Features: Ac12FXxHd1zwNyeeyMeL1w-mdhTzW6E4T0u_I6okD7G4h9Eqdpo3LBgPWiNoTLs
Message-ID: <CAH2r5mveXNenpP48_8Joer2u1R14-z2-rY03guGZpoc6D9QviA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix lstat() and AT_SYMLINK_NOFOLLOW to work on
 broken symlink nodes
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Remy Monsen <monsen@monsen.cc>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks like Paulo's fix ("smb: client: fix regression with native SMB
symlinks") which has been in for-next for a while with no issues in
testing etc. does fix the regression.

I did verify that the simple act of creating symlink (e.g. to some UNC
name) on Windows and trying to do an "ls -l" or "stat" or "cp" does
regress without his patch and with his patch behaves as expected (e.g.
if you went to linux and created a symlink to "filethatdoesnotexist"
then with his patch the behavior for stat, cp, cp --no-dereference and
ls -l is the same for bad target on ext4 mounts locally as it is for
bad target on smb3 mount to Windows)

There may be ways to address corner cases in the future - but it does
clearly address the regression, and for those four operations (stat,
cp, cp --no-dereference and ls -l) now behaves as expected when you
have an unresolvable target path of a symlink.

Don't mind discussing a followon patch to address more corner cases
but his patch looks fine and multiple people have tried it and looked
at (not just me) so should be upstream soon

On Fri, Jun 27, 2025 at 4:03=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> So what would be the next steps here?
>
> On Saturday 21 June 2025 18:52:46 Pali Roh=C3=A1r wrote:
> > On Saturday 21 June 2025 12:38:34 Paulo Alcantara wrote:
> > > Pali Roh=C3=A1r <pali@kernel.org> writes:
> > >
> > > > On Friday 20 June 2025 20:44:37 Paulo Alcantara wrote:
> > > >> Pali Roh=C3=A1r <pali@kernel.org> writes:
> > > >>
> > > >> > Currently Linux SMB client returns EIO for lstat() and AT_SYMLIN=
K_NOFOLLOW
> > > >> > calls on symlink node when the symlink target location is broken=
 or cannot
> > > >> > be read or parsed.
> > > >> >
> > > >> > Fix this problem by relaxing the errors from various locations w=
hich parses
> > > >> > information about symlink file node (UNIX SMB1, native SMB2+, NF=
S-style,
> > > >> > WSL-style) and let readlink() syscall to return EIO when the sym=
link target
> > > >> > location is not available.
> > > >>
> > > >> Please, don't.  We still want those validations for the other type=
s of
> > > >> symlinks.
> > > >
> > > > Well, validation was not removed. Validation is still there, just t=
he
> > > > error is signalled by the readlink() syscall instead of the lstat()=
 or
> > > > AT_SYMLINK_NOFOLLOW syscalls.
> > > >
> > > > My opinion is that the lstat() or AT_SYMLINK_NOFOLLOW should work o=
n
> > > > symlink node independently of where the symlink points (and whether=
 the
> > > > symlink target is valid POSIX path or not). That is because the lst=
at()
> > > > and AT_SYMLINK_NOFOLLOW says that the symlink target location must =
not
> > > > be used and must not be resolved.
> > > >
> > > > But still the invalid / incorrect / broken or non-representable sym=
link
> > > > target path in POSIX notation should be reported as an issue and th=
e
> > > > readlink() is the correct syscall which should report these errors.
> > >
> > > The only issue is breaking existing customer or user applications tha=
t
> > > really don't care if cifs.ko could follow those kind of symlinks.
> > >
> > > Samba create symlinks to represent DFS links with targets like
> > > 'msdfs:srv1\share,srv2\share', which are not valid POSIX paths.  Does
> > > that mean the filesystem should not allow readlink(2) to succeed just
> > > because it is not a valid POSIX path?  Is that what you mean?
> >
> > But this is something totally different thing.
> >
> > Here you are referring to the behavior of Samba server, which interpret=
s
> > symlink node stored on local filesystem named e.g. "link1" pointing to
> > target relative file name 'msdfs:srv1\share,srv2\share' specially.
> >
> > Calling "ln -s 'msdfs:srv1\share,srv2\share' link1" is perfectly fine o=
n
> > the ext4 filesystem. It creates a relative symlink to the specified
> > file.
> >
> > And if you call "echo test > 'msdfs:srv1\share,srv2\share'" then it wou=
ld
> > world correctly and "cat link1" will print "test".
> >
> > The 'msdfs:srv1\share,srv2\share' is a valid POSIX path and it is store=
d
> > on the local Linux filesystem. So I do not see anything wrong with it o=
r
> > reason why local filesystem should disallow creating such symlink or wh=
y
> > would realink() should fail on such node.
> >
> >
> > That example has nothing with symlinks stored on NTFS-compatible
> > filesystems which has ability to store symlinks pointing to non-POSIX
> > NT object model paths.
> >
> > Here the issue is with symlink target locations which are coming from
> > the remote NT server and are pointing to location which cannot be
> > directly represented by the Linux system. The translation needs to be
> > done in both directions and reversible. Otherwise moving the file or
> > symlink from cifs to ext4 and back would damage the file or symlink.
> >
> > > >> The problem is just that cifs.ko can't handle absolute
> > > >> symlink targets in the form of '\??\UNC\srv\share\foo', while Wind=
ows
> > > >> client can.  They are still valid symlink targets, but cifs.ko doe=
sn't
> > > >> know how to follow them.
> > > >
> > > > Windows client can represent and follow such symlink because the sy=
mlink
> > > > is in the NT style format and Windows kernel uses NT style of paths
> > > > internally. Linux kernel uses POSIX paths and POSIX does not contai=
n any
> > > > GLOBAL?? namespace for NT object hierarchy.
> > > >
> > > > Leaking raw NT object hierarchy from SMB to POSIX userspace via
> > > > readlink() syscall is a bad idea. Applications are really not expec=
ting
> > > > that the readlink() syscall will return NT kernel internals (export=
ed
> > > > over SMB protocol and passed to cifs.ko).
> > > >
> > > > For UNC paths encoded in NT object hierarchy, which is just some su=
bset
> > > > of all possible NT paths, I had an idea that we could convert these
> > > > paths to some format like:
> > > >
> > > >    <prefix>/server/share/path...
> > > >
> > > > Where <prefix> would be specified by the string mount option. So us=
er
> > > > could say that wants all UNC symlinks pointing to /mnt/unc/.
> > > >
> > > > And in the same way if user would want to create symlink pointing t=
o
> > > > /mnt/unc/server/share/path... then cifs.ko will transform it into v=
alid
> > > > NT UNC path and create a symlink to this location.
> > >
> > > That's really a terrible idea.  The symlink targets in the form of
> > > '\??\UNC\...' could be resolved by cifs.ko.  The ones that refer to a
> > > file outside the mounted share, we would set those as automounts.
> >
> > I agree that above is not the best idea, but I wrote at least something
> > as an idea as I do not know how it could be solved in better way.
> >
> > And I do not see how it could be resolved by cifs.ko somehow
> > automatically. I'm not sure to which you refer how it can be resolved b=
y
> > cifs.ko. I understood you message as it could automount another share
> > and do the whole path symlink resolving in cifs.ko.
> >
> > And I think that this is even worse idea than mine. Because that
> > automount means that symlinks pointing outside of the share would start
> > behaving like a mount point. Such thing can cause even a security issue=
s
> > if not used carefully.
> >
> > But moreover there is a big difference between symlink and mount point.
> > Symlinks are not resolved by filesystem itself (but rather by the VFS,
> > to ensure that all access checks are applied) and also moving the
> > symlink between filesystems should not break them. In this idea when th=
e
> > symlink is going to be moved from smb share to e.g. ext4 local fs, then
> > it would stops working (if the path resolved is in the cifs.ko) as
> > ext4.ko would not be able to process special cifs.ko symlinks.
> >
> > > > But this would solve only problem with UNC symlink, not symlinks
> > > > pointing to NT object hierarchy in general.
> > > >
> > > >> The following should do it and then restore old behavior
> > > >>
> > > >> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > >> index bb25e77c5540..11d44288e75a 100644
> > > >> --- a/fs/smb/client/reparse.c
> > > >> +++ b/fs/smb/client/reparse.c
> > > >> @@ -875,15 +875,8 @@ int smb2_parse_native_symlink(char **target, =
const char *buf, unsigned int len,
> > > >>                          abs_path +=3D sizeof("\\DosDevices\\")-1;
> > > >>                  else if (strstarts(abs_path, "\\GLOBAL??\\"))
> > > >>                          abs_path +=3D sizeof("\\GLOBAL??\\")-1;
> > > >> -                else {
> > > >> -                        /* Unhandled absolute symlink, points out=
side of DOS/Win32 */
> > > >> -                        cifs_dbg(VFS,
> > > >> -                                 "absolute symlink '%s' cannot be=
 converted from NT format "
> > > >> -                                 "because points to unknown targe=
t\n",
> > > >> -                                 smb_target);
> > > >> -                        rc =3D -EIO;
> > > >> -                        goto out;
> > > >> -                }
> > > >> +                else
> > > >> +                        goto out_unhandled_target;
> > > >>
> > > >>                  /* Sometimes path separator after \?? is double b=
ackslash */
> > > >>                  if (abs_path[0] =3D=3D '\\')
> > > >> @@ -910,13 +903,7 @@ int smb2_parse_native_symlink(char **target, =
const char *buf, unsigned int len,
> > > >>                          abs_path++;
> > > >>                          abs_path[0] =3D drive_letter;
> > > >>                  } else {
> > > >> -                        /* Unhandled absolute symlink. Report an =
error. */
> > > >> -                        cifs_dbg(VFS,
> > > >> -                                 "absolute symlink '%s' cannot be=
 converted from NT format "
> > > >> -                                 "because points to unknown targe=
t\n",
> > > >> -                                 smb_target);
> > > >> -                        rc =3D -EIO;
> > > >> -                        goto out;
> > > >> +                        goto out_unhandled_target;
> > > >>                  }
> > > >>
> > > >>                  abs_path_len =3D strlen(abs_path)+1;
> > > >> @@ -966,6 +953,7 @@ int smb2_parse_native_symlink(char **target, c=
onst char *buf, unsigned int len,
> > > >>                   * These paths have same format as Linux symlinks=
, so no
> > > >>                   * conversion is needed.
> > > >>                   */
> > > >> +out_unhandled_target:
> > > >>                  linux_target =3D smb_target;
> > > >>                  smb_target =3D NULL;
> > > >>          }
> > > >
> > > > I'm really not sure if removing the messages and error reporting ab=
out
> > > > symlinks which cannot be represented in POSIX system is a good idea=
.
> > >
> > > Those messages are just useless and noisy.  Do you think it's useful
> > > printing that message for _every_ symlink when someone is calling
> > > readdir(2) in a directory that contain such files?
> >
> > I though that for any debugging purposes these messages are useful.
> > Now I see that VFS level is printed always, so maybe the FYI level coul=
d
> > be better. Or do you really think that it is useless even for debugging=
?
>


--=20
Thanks,

Steve
