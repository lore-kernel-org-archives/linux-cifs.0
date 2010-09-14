From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix potential double put of TCP session reference
Date: Tue, 14 Sep 2010 10:19:56 -0500
Message-ID: <AANLkTi=RDgXd50Qu1G1ifZOdrzVEz2YC3f0z2pzyhrRn@mail.gmail.com>
References: <1284400930-24134-1-git-send-email-jlayton@redhat.com>
	<4C8F44F0.30803@suse.de>
	<20100914073954.5c818d3c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100914073954.5c818d3c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 14, 2010 at 6:39 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 14 Sep 2010 15:18:32 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>
>> On 09/13/2010 11:32 PM, Jeff Layton wrote:
>> > cifs_get_smb_ses must be called on a server pointer on which it ho=
lds an
>> > active reference. It first does a search for an existing SMB sessi=
on. If
>> > it finds one, it'll put the server reference and then try to ensur=
e that
>> > the negprot is done, etc.
>> >
>> > If it encounters an error at that point then it'll return an error=
=2E
>> > There's a potential problem here though. When cifs_get_smb_ses ret=
urns
>> > an error, the caller will also put the TCP server reference leadin=
g to a
>> > double-put.
>> >
>> > Fix this by having cifs_get_smb_ses only put the server reference =
if
>> > it found an existing session that it could use and isn't returning=
 an
>> > error.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/connect.c | =A0 =A06 +++---
>> > =A01 files changed, 3 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index 67dad54..88c84a3 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -1706,9 +1706,6 @@ cifs_get_smb_ses(struct TCP_Server_Info *ser=
ver, struct smb_vol *volume_info)
>> > =A0 =A0 if (ses) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Existing smb sess found (status=3D=
%d)", ses->status);
>> >
>> > - =A0 =A0 =A0 =A0 =A0 /* existing SMB ses has a server reference a=
lready */
>> > - =A0 =A0 =A0 =A0 =A0 cifs_put_tcp_session(server);
>> > -
>> > =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&ses->session_mutex);
>> > =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_negotiate_protocol(xid, ses);
>> > =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> > @@ -1731,6 +1728,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *ser=
ver, struct smb_vol *volume_info)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ses->session_mutex);
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 /* existing SMB ses has a server reference a=
lready */
>> > + =A0 =A0 =A0 =A0 =A0 cifs_put_tcp_session(server);
>> > =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> > =A0 =A0 =A0 =A0 =A0 =A0 return ses;
>> > =A0 =A0 }
>>
>> Looks correct to me.
>>
>> Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>
> Thanks. In hindsight, I should have probably sent this to stable too.
>
> Steve, would you like me to resend and cc stable? We probably want th=
is
> in 2.6.36 too, if possible.

Yes - I agree makes sense.  Any other candidate patches for 2.6.36?

--=20
Thanks,

Steve
