From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: lower default wsize when unix extensions are not used
Date: Wed, 9 Nov 2011 14:55:36 -0600
Message-ID: <CAH2r5mtmboSEMHbj6ixh6UGSgiTFz1Mn=ZU6fkQaCSu7n6h=EQ@mail.gmail.com>
References: <1320863843-29406-1-git-send-email-jlayton@redhat.com>
	<20111109134140.2105ed9e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org,
	piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111109134140.2105ed9e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

How much of a performance hit does this make?  I would expect that
dropping the writesize by more than 50% to most non-Samba servers to
work around a bug in Solaris seems extreme.  If this hurts our
performance measurably, it may be more pragmatic to limit the wsize
change to a subset of these (e.g. based on server type) - seems more
fair to not punish other servers for a Solaris bug.

On Wed, Nov 9, 2011 at 12:41 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, =A09 Nov 2011 13:37:23 -0500
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> We've had some reports of servers (namely, the Solaris in-kernel CIF=
S
>> server) that don't deal properly with writes that are "too large" ev=
en
>> though they set CAP_LARGE_WRITE_ANDX. Change the default to better
>> mirror what windows clients do.
>>
>> Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> Reported-by: Nick Davis <phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/connect.c | =A0 23 +++++++++++++++++++----
>> =A01 files changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index d6a972d..bf82f88 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2912,18 +2912,33 @@ void cifs_setup_cifs_sb(struct smb_vol *pvol=
ume_info,
>> =A0#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
>>
>> =A0/*
>> - * Windows only supports a max of 60k reads. Default to that when p=
osix
>> - * extensions aren't in force.
>> + * Windows only supports a max of 60kb reads and 65535 byte writes.=
 Default to
>> + * those values when posix extensions aren't in force. In actuality=
 here, we
>> + * use 65536 to allow for a write that is a multiple of 4k. Most se=
rvers seem
>> + * to be ok with the extra byte even though Windows doesn't send wr=
ites that
>> + * are that large.
>> + *
>> + * Citation:
>> + *
>> + * http://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb=
-maximum-transmit-buffer-size-and-performance-tuning.aspx
>> =A0 */
>> =A0#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
>> +#define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
>>
>> =A0static unsigned int
>> =A0cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvol=
ume_info)
>> =A0{
>> =A0 =A0 =A0 __u64 unix_cap =3D le64_to_cpu(tcon->fsUnixInfo.Capabili=
ty);
>> =A0 =A0 =A0 struct TCP_Server_Info *server =3D tcon->ses->server;
>> - =A0 =A0 unsigned int wsize =3D pvolume_info->wsize ? pvolume_info-=
>wsize :
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_DEFAU=
LT_IOSIZE;
>> + =A0 =A0 unsigned int wsize;
>> +
>> + =A0 =A0 /* start with specified wsize, or default */
>> + =A0 =A0 if (pvolume_info->wsize)
>> + =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D pvolume_info->wsize;
>> + =A0 =A0 else if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_WRI=
TE_CAP))
>> + =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D CIFS_DEFAULT_IOSIZE;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D CIFS_DEFAULT_NON_POSIX_WSIZE;
>>
>> =A0 =A0 =A0 /* can server support 24-bit write sizes? (via UNIX exte=
nsions) */
>> =A0 =A0 =A0 if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRIT=
E_CAP))
>
>
> I should also mention that I suspect that this will fix this bug
> without needing extra options:
>
> =A0 =A0https://bugzilla.samba.org/show_bug.cgi?id=3D8559
>
> If it looks acceptable, this might be suitable for stable too.
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
