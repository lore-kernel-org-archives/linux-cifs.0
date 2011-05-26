From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v4 PATCH 4/4] CIFS: Migrate to shared superblock model
Date: Thu, 26 May 2011 11:06:59 -0500
Message-ID: <BANLkTim+a8swvWytQwUQqE+1s+wVnX3gRg@mail.gmail.com>
References: <1306389721-28550-1-git-send-email-piastry@etersoft.ru>
	<1306389721-28550-4-git-send-email-piastry@etersoft.ru>
	<20110526112001.6602ce52@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110526112001.6602ce52-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 26, 2011 at 10:20 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>=
 wrote:
> On Thu, 26 May 2011 10:02:01 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Add cifs_match_super to use in sget to share superblock between moun=
ts
>> that have the same //server/sharename, credentials and mount options=
=2E
>> It helps us to improve performance on work with future SMB2.1 leases=
=2E
<snip>
>> +static int
>> +compare_mount_options(struct super_block *sb, struct cifs_mnt_data =
*mnt_data)
>> +{
>> + =A0 =A0 struct cifs_sb_info *old =3D CIFS_SB(sb);
>> + =A0 =A0 struct cifs_sb_info *new =3D mnt_data->cifs_sb;
>> +
>> + =A0 =A0 if ((sb->s_flags & CIFS_MS_MASK) !=3D (mnt_data->flags & C=
IFS_MS_MASK))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if ((old->mnt_cifs_flags & CIFS_MOUNT_MASK) !=3D
>> + =A0 =A0 =A0 =A0 (new->mnt_cifs_flags & CIFS_MOUNT_MASK))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (old->rsize !=3D new->rsize)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (new->wsize && new->wsize > old->wsize)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>
> ...also I think the above condition should be reversed. We don't want
> to match if new->wsize is smaller than the existing one. Since the
> specified wsize is just a starting point for negotiation, wsize now
> means "any wsize less than or equal to this size". If the old->wsize =
is
> bigger than that, then it's outside that range and we shouldn't match=
=2E

A more important question is whether the user intentionally tried to
specify a wsize.  I don't see a problem matching a new default mount
request (with no wsize specified, using therefore a default wsize)
with an existing mount (with a larger explicitly specified wsize).
If a user explicitly requests to override to a particular wsize on the =
2nd
mount - seems more logical to give them what they ask for if
possible whether larger or smaller.


--=20
Thanks,

Steve
