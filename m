From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix bad buffer length check in coalesce_t2
Date: Wed, 4 Jan 2012 11:29:12 -0500
Message-ID: <20120104112912.139f9578@tlielax.poochiereds.net>
References: <1325432079-21179-1-git-send-email-jlayton@redhat.com>
	<CADT32eK53tJakiLm5VVE9cY3R6mLkA2PYWxwNG17ybK=u6NYNg@mail.gmail.com>
	<20120104090910.7ed8ff12@tlielax.poochiereds.net>
	<CAH2r5msMJXp_T0tgSaoXWVjbZtscQ1s5L_D2hyxD28=56JDH0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msMJXp_T0tgSaoXWVjbZtscQ1s5L_D2hyxD28=56JDH0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 4 Jan 2012 10:14:25 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> FYI - the patch is merged into cifs git tree but want to wait 24 hour=
s
> for linux-next before sending merge request upstream.
>=20

I wouldn't wait. The 3.2 release is imminent.

> On Wed, Jan 4, 2012 at 8:09 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Tue, 3 Jan 2012 16:46:15 -0600
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Sun, Jan 1, 2012 at 9:34 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> >> > The current check looks to see if the RFC1002 length is larger t=
han
> >> > CIFSMaxBufSize, and fails if it is. The buffer is actually large=
r than
> >> > that by MAX_CIFS_HDR_SIZE.
> >> >
> >> > This bug has been around for a long time, but the fact that we u=
sed to
> >> > cap the clients MaxBufferSize at the same level as the server te=
nded
> >> > to paper over it. Commit c974befa changed that however and cause=
d this
> >> > bug to bite in more cases.
> >> >
> >> > Reported-and-Tested-by: Konstantinos Skarlatos <k.skarlatos@gmai=
l.com>
> >> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> > ---
> >> > =C2=A0fs/cifs/connect.c | =C2=A0 =C2=A02 +-
> >> > =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
> >> >
> >> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> > index 8cd4b52..27c4f25 100644
> >> > --- a/fs/cifs/connect.c
> >> > +++ b/fs/cifs/connect.c
> >> > @@ -282,7 +282,7 @@ static int coalesce_t2(struct smb_hdr *pseco=
nd, struct smb_hdr *pTargetSMB)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0byte_count =3D be32_to_cpu(pTargetSMB=
->smb_buf_length);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0byte_count +=3D total_in_buf2;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* don't allow buffer to overflow */
> >> > - =C2=A0 =C2=A0 =C2=A0 if (byte_count > CIFSMaxBufSize)
> >> > + =C2=A0 =C2=A0 =C2=A0 if (byte_count > CIFSMaxBufSize + MAX_CIF=
S_HDR_SIZE - 4)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -E=
NOBUFS;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pTargetSMB->smb_buf_length =3D cpu_to=
_be32(byte_count);
> >> >
> >> > --
> >> > 1.7.7.4
> >> >
> >>
> >> This looks correct. =C2=A0But the way Windows XP server responds t=
o request
> >> =C2=A0trans2/find_first2/info level is different than how Windows =
2003 Server
> >> and Windows 2008 Server respond.
> >>
> >> So a related concern would be, for a response from Windows XP serv=
er,
> >> this check in function check2ndT2 does not make sense.
> >> =C2=A0if (total_data_size > CIFSMaxBufSize) {
> >>
> >
> > This check looks redundant to me. We could remove it since the chec=
k in
> > coalesce_t2 is more accurate...
> >
> >> It is possible to have large number of entries in a directory such=
 that the
> >> response to a =C2=A0ls =C2=A0command can exceed CIFSMaxBufSize.
> >
> > It shouldn't be possible. The CIFSFindFirst request sends this:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMB->MaxDataCount =3D cpu_to_le16(CIFSM=
axBufSize & 0xFFFFFF00);
> >
> > ...which should ensure that the amount of data in the response is l=
ess
> > than CIFSMaxBufSize. I'm not sure what the point of the mask is the=
re
> > however...
> >
> > In addition, we're also limited by this:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMB->SearchCount =3D cpu_to_le16(CIFSMa=
xBufSize/sizeof(FILE_UNIX_INFO));
> >
> > ...but I think we ought to consider just setting that to 0xffff.
> >
> > Dividing by sizeof(FILE_UNIX_INFO) is clearly wrong for other
> > infolevels. We don't really care how many entries the server sends =
as
> > long as it doesn't exceed the buffer size.
> >
> > Either way, I believe this patch is correct, though we may have som=
e
> > other cleanup work to do in this area.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
