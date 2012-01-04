From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix bad buffer length check in coalesce_t2
Date: Wed, 4 Jan 2012 10:14:25 -0600
Message-ID: <CAH2r5msMJXp_T0tgSaoXWVjbZtscQ1s5L_D2hyxD28=56JDH0w@mail.gmail.com>
References: <1325432079-21179-1-git-send-email-jlayton@redhat.com>
	<CADT32eK53tJakiLm5VVE9cY3R6mLkA2PYWxwNG17ybK=u6NYNg@mail.gmail.com>
	<20120104090910.7ed8ff12@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120104090910.7ed8ff12-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

=46YI - the patch is merged into cifs git tree but want to wait 24 hour=
s
for linux-next before sending merge request upstream.

On Wed, Jan 4, 2012 at 8:09 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 3 Jan 2012 16:46:15 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Sun, Jan 1, 2012 at 9:34 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> > The current check looks to see if the RFC1002 length is larger tha=
n
>> > CIFSMaxBufSize, and fails if it is. The buffer is actually larger =
than
>> > that by MAX_CIFS_HDR_SIZE.
>> >
>> > This bug has been around for a long time, but the fact that we use=
d to
>> > cap the clients MaxBufferSize at the same level as the server tend=
ed
>> > to paper over it. Commit c974befa changed that however and caused =
this
>> > bug to bite in more cases.
>> >
>> > Reported-and-Tested-by: Konstantinos Skarlatos <k.skarlatos@gmail.=
com>
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/connect.c | =A0 =A02 +-
>> > =A01 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index 8cd4b52..27c4f25 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -282,7 +282,7 @@ static int coalesce_t2(struct smb_hdr *psecond=
, struct smb_hdr *pTargetSMB)
>> > =A0 =A0 =A0 =A0byte_count =3D be32_to_cpu(pTargetSMB->smb_buf_leng=
th);
>> > =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
>> > =A0 =A0 =A0 =A0/* don't allow buffer to overflow */
>> > - =A0 =A0 =A0 if (byte_count > CIFSMaxBufSize)
>> > + =A0 =A0 =A0 if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE =
- 4)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOBUFS;
>> > =A0 =A0 =A0 =A0pTargetSMB->smb_buf_length =3D cpu_to_be32(byte_cou=
nt);
>> >
>> > --
>> > 1.7.7.4
>> >
>>
>> This looks correct. =A0But the way Windows XP server responds to req=
uest
>> =A0trans2/find_first2/info level is different than how Windows 2003 =
Server
>> and Windows 2008 Server respond.
>>
>> So a related concern would be, for a response from Windows XP server=
,
>> this check in function check2ndT2 does not make sense.
>> =A0if (total_data_size > CIFSMaxBufSize) {
>>
>
> This check looks redundant to me. We could remove it since the check =
in
> coalesce_t2 is more accurate...
>
>> It is possible to have large number of entries in a directory such t=
hat the
>> response to a =A0ls =A0command can exceed CIFSMaxBufSize.
>
> It shouldn't be possible. The CIFSFindFirst request sends this:
>
> =A0 =A0 =A0 =A0pSMB->MaxDataCount =3D cpu_to_le16(CIFSMaxBufSize & 0x=
=46FFFFF00);
>
> ...which should ensure that the amount of data in the response is les=
s
> than CIFSMaxBufSize. I'm not sure what the point of the mask is there
> however...
>
> In addition, we're also limited by this:
>
> =A0 =A0 =A0 =A0pSMB->SearchCount =3D cpu_to_le16(CIFSMaxBufSize/sizeo=
f(FILE_UNIX_INFO));
>
> ...but I think we ought to consider just setting that to 0xffff.
>
> Dividing by sizeof(FILE_UNIX_INFO) is clearly wrong for other
> infolevels. We don't really care how many entries the server sends as
> long as it doesn't exceed the buffer size.
>
> Either way, I believe this patch is correct, though we may have some
> other cleanup work to do in this area.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Thanks,

Steve
