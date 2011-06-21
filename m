From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix wsize negotiation to respect max buffer size
 and active signing
Date: Tue, 21 Jun 2011 11:24:12 -0500
Message-ID: <BANLkTik=QLv-=mynGjxe+8Bp7GCpuhwt8Q@mail.gmail.com>
References: <1308658097-14805-1-git-send-email-jlayton@redhat.com>
	<20110621113327.6df5fdd4@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110621113327.6df5fdd4-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yep - makes sense - I will plan on merging the respun patch.

Opinions about the rsize equivalent of this going in quickly as well?

On Tue, Jun 21, 2011 at 10:33 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Tue, 21 Jun 2011 08:08:17 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> According to Hongwei Sun's blog posting here:
>>
>> =A0 =A0 http://blogs.msdn.com/b/openspecification/archive/2009/04/10=
/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx
>>
>> CAP_LARGE_WRITEX is ignored when signing is active. Also, the maximu=
m
>> size for a write without CAP_LARGE_WRITEX should be the maxBuf that
>> the server sent in the NEGOTIATE request.
>>
>> Fix the wsize negotiation to take this into account. While we're at =
it,
>> alter the other wsize definitions to use sizeof(WRITE_REQ) to allow =
for
>> slightly larger amounts of data to potentially be written per reques=
t.
>>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/connect.c | =A0 24 +++++++++++++++---------
>> =A01 files changed, 15 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index b15b5b0..f9a59b8 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2754,21 +2754,21 @@ void cifs_setup_cifs_sb(struct smb_vol *pvol=
ume_info,
>>
>> =A0/*
>> =A0 * When the server supports very large writes via POSIX extension=
s, we can
>> - * allow up to 2^24 - PAGE_CACHE_SIZE.
>> + * allow up to 2^24 (16M) minus the size of a WRITE_AND_X header no=
t including
>> + * the RFC1001 length.
>> =A0 *
>> =A0 * Note that this might make for "interesting" allocation problem=
s during
>> =A0 * writeback however (as we have to allocate an array of pointers=
 for the
>> =A0 * pages). A 16M write means ~32kb page array with PAGE_CACHE_SIZ=
E =3D=3D 4096.
>> =A0 */
>> -#define CIFS_MAX_WSIZE ((1<<24) - PAGE_CACHE_SIZE)
>> +#define CIFS_MAX_WSIZE ((1<<24) - sizeof(WRITE_REQ) + 4)
>>
>> =A0/*
>> =A0 * When the server doesn't allow large posix writes, default to a=
 wsize of
>> - * 128k - PAGE_CACHE_SIZE -- one page less than the largest frame s=
ize
>> - * described in RFC1001. This allows space for the header without g=
oing over
>> - * that by default.
>> + * 128k minus the size of the WRITE_AND_X header. That allows for a=
 write up
>> + * to the maximum size described by RFC1001.
>> =A0 */
>> -#define CIFS_MAX_RFC1001_WSIZE (128 * 1024 - PAGE_CACHE_SIZE)
>> +#define CIFS_MAX_RFC1001_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
>>
>> =A0/*
>> =A0 * The default wsize is 1M. find_get_pages seems to return a maxi=
mum of 256
>> @@ -2789,9 +2789,15 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, =
struct smb_vol *pvolume_info)
>> =A0 =A0 =A0 if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRIT=
E_CAP))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize, CIF=
S_MAX_RFC1001_WSIZE);
>>
>> - =A0 =A0 /* no CAP_LARGE_WRITE_X? Limit it to 16 bits */
>> - =A0 =A0 if (!(server->capabilities & CAP_LARGE_WRITE_X))
>> - =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize, USHRT=
_MAX);
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* no CAP_LARGE_WRITE_X or signing enabled? Limit to max=
 buffer
>> + =A0 =A0 =A0* offered by the server, minus the size of the WRITEX h=
eader, not
>> + =A0 =A0 =A0* including the 4 byte RFC1001 length.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
>> + =A0 =A0 =A0 =A0 (server->sec_mode & (SECMODE_SIGN_ENABLED|SECMODE_=
SIGN_REQUIRED)))
>> + =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->ma=
xBuf - sizeof(WRITE_REQ) + 4);
>>
>> =A0 =A0 =A0 /* hard limit of CIFS_MAX_WSIZE */
>> =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
>
> One problem with this patch. We probably shouldn't negotiate down the
> wsize when signing is enabled and unix extensions are in force
> (according to George Colley). Let me respin the patch to add that che=
ck
> as well.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
