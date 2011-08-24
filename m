From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] ls on mounts to WindowsCE failing with invalid
 level message
Date: Wed, 24 Aug 2011 14:15:05 -0500
Message-ID: <CAH2r5mtMNGTPHhCpfZAL3tjpsisxBejzwMJcSd8wLd4qLQbtWA@mail.gmail.com>
References: <CAH2r5mvmVNySCiSMc9Bz=yi4Zhzg=sYwxLSpiwapAyn6-HEqDQ@mail.gmail.com>
	<20110824150852.5a9f911f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110824150852.5a9f911f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Will fix the style comment - but on the fall back to lowest common
denominator ... it won't work.
=46or this server you have to fall back to 260 (then old servers fall
back to 1).  Interestingly this server seemed to have problems with
the default level and with level 1 ... so I don't see a choice to
having two fall backs (but could remove one of the three obviously).

On Wed, Aug 24, 2011 at 2:08 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 23 Aug 2011 22:16:54 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> From 9b7b518633fd3187c7efe260fe20a0961e4a5f0b Mon Sep 17 00:00:00 20=
01
>> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>> Date: Tue, 23 Aug 2011 22:00:26 -0500
>> Subject: [CIFS] ls on mounts to WindowsCE failing with invalid level=
 message
>>
>> Mount succeeds to WindowsCE but when user tries
>> to access the contents of the directory gets "NT Status:
>> STATUS_INVALID_LEVEL" according to wireshark.
>>
>> This server does not support the common windows
>> readdir (Findfirst) level 257 nor level 258, so "fall back"
>> to level 260 if get an EOPNOTSUPP on level FIND_FILE_DIRECTORY_INFO
>> and while we are at it fall back to level 1 (FILE_INFO_STANDARD)
>> for very old servers if we get an EOPNOTSUPP on level 260.
>> (Note that the server returned errors on queries for inode
>> numbers via QueryPathInfo so we don't use the infolevel
>> SMB_FIND_FILE_ID_FULL_DIR_INFO)
>>
>> Reported-and-tested-by: Bryan James <Bryan.James.Krone-EXT-zES+1Ur7hjI@public.gmane.org>
>> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/readdir.c | =A0 17 +++++++++++++++++
>> =A01 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
>> index 5de03ec..ed29706 100644
>> --- a/fs/cifs/readdir.c
>> +++ b/fs/cifs/readdir.c
>> @@ -270,6 +270,7 @@ ffirst_retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFile->srch_inf.info_level =3D SMB_FI=
ND_FILE_DIRECTORY_INFO;
>> =A0 =A0 =A0 }
>>
>> +ffirst_retry_with_std_level:
>> =A0 =A0 =A0 rc =3D CIFSFindFirst(xid, pTcon, full_path, cifs_sb->loc=
al_nls,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cifsFile->netfid, &cifsFile->srch_inf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags &
>> @@ -283,7 +284,23 @@ ffirst_retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SE=
RVER_INUM)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags &=3D ~CIFS_MOUNT=
_SERVER_INUM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ffirst_retry;
>> + =A0 =A0 } else if ((rc =3D=3D -EOPNOTSUPP) && (cifsFile->srch_inf.=
info_level =3D=3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 SMB_FIND_FILE_DIRECTORY_INFO)) {
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^ there's no need for the extra set=
s of parenthesis
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0here. That violates kernel coding conv=
entions and makes this
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0harder to read.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Windows CE can return EOPNOTSUPP on FIL=
E_DIRECTORY_INFO */
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifsFile->srch_inf.info_level =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMB_FIND_F=
ILE_BOTH_DIRECTORY_INFO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0The code doesn't curre=
ntly use
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BOTH_DIRECTORY_INFO an=
ywhere. Would it be
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0better to skip this st=
ep?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto ffirst_retry_with_std_level;
>> + =A0 =A0 } else if ((rc =3D=3D -EOPNOTSUPP) && (cifsFile->srch_inf.=
info_level =3D=3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 SMB_FIND_FILE_BOTH_DIRECTORY_INFO)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifsFile->srch_inf.info_level =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMB_FIND_F=
ILE_FULL_DIRECTORY_INFO;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Ditto here. Would it b=
e best to just fall back
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0to the lowest common d=
enominator here? I'm not sure
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0I see a lot of benefit=
 in using any of these
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0other infolevels. We'l=
l basically get the same
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0info out of SMB_FIND_F=
ILE_INFO_STANDARD and it's
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0more widely supported.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto ffirst_retry_with_std_level;
>> + =A0 =A0 } else if ((rc =3D=3D -EOPNOTSUPP) && (cifsFile->srch_inf.=
info_level =3D=3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 SMB_FIND_FILE_FULL_DIRECTORY_INFO)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifsFile->srch_inf.info_level =3D SMB_FIND=
_FILE_INFO_STANDARD;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto ffirst_retry_with_std_level;
>> =A0 =A0 =A0 }
>> +
>> =A0error_exit:
>> =A0 =A0 =A0 kfree(full_path);
>> =A0 =A0 =A0 cifs_put_tlink(tlink);
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
