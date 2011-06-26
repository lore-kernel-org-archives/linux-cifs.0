From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mounts to Windows XP server do have problems with async write
 due to inFlight > 10
Date: Sun, 26 Jun 2011 08:03:48 -0400
Message-ID: <20110626080348.5006b292@corrin.poochiereds.net>
References: <BANLkTikwtWrQxUD=B4eQedXq9JPy+Ojf0w@mail.gmail.com>
	<BANLkTimp+GQiM8HoXNginYy7kYPhVZiXDQ@mail.gmail.com>
	<20110625062733.75df0f26@tlielax.poochiereds.net>
	<BANLkTinkMJ0Oi_ASMC7f_DsKv_Bo1u5etw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinkMJ0Oi_ASMC7f_DsKv_Bo1u5etw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 25 Jun 2011 14:21:16 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Potential problem writing large files (with the async write support
> which kicks off
> more smbs in parallel)  to systems which set an artificially low limi=
t on maxmpx
> (not to the usual 50, but to e.g. 10 as some WindowsXP does) and enfo=
rce
> the limit strictly by killing the session or throwing away the reques=
t.
>=20
> The patch below did seem to help, but when setting wsize to 8K or 4K
> I still did run into a problem, although
> seemed to be better - so need to debug whether it is an "off by one"
> problem where server (as Chris Hertel suggested) might be setting the
> limit on number of writes in parallel to one less than the mpxcount
> rather than mpxcount (when oplock enabled on the server) or perhaps w=
hether
> we just have too many async write requests blocked and hit some sort
> of memory issue or corruption.
>=20

You may want to look over the patch I originally proposed a couple of
months ago. IIRC, I hit some similar problems when testing but wasn't
able to dig deeply into it at the time.


> On Sat, Jun 25, 2011 at 5:27 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Fri, 24 Jun 2011 20:45:08 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> This seems to be close to what we would want but am not done testi=
ng/debugging:
> >>
> >
> >> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> >> index 1a9fe7f..1957f5d 100644
> >> --- a/fs/cifs/cifssmb.c
> >> +++ b/fs/cifs/cifssmb.c
> >> @@ -453,6 +453,11 @@ CIFSSMBNegotiate(unsigned int xid, struct cif=
s_ses *ses)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->sec_mode =
=3D (__u8)le16_to_cpu(rsp->SecurityMode);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->maxReq =3D=
 le16_to_cpu(rsp->MaxMpxCount);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* maxReq must be at l=
east 2, almost all servers set to 50,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0some old =
non-MS servers set incorrectly so set to default
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(otherwis=
e oplock break e.g. would fail */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (server->maxReq < 2=
)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 server->maxReq =3D CIFS_MAX_REQ; /* 50 */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^
> > Would it be better to set this to the minimum (2 or 3), and possibl=
y
> > warn on the first mount?
>=20
> since the "normal" number used by almost all Windows (and even OS/2)
> is 50, and was the value we have been using for many years, by defaul=
t,
> I thought that defaulting to the "normal" limit on an illegal value (=
which
> means we don't change behavior) is safer.
>=20

While I'm generally loath to suggest mount options, this might be a
case where you'd want one to override what the server sends. Throwing
an error that the maxmpx is illegal and failing the mount would make
the most sense, IMO. The error message could suggest using the maxmpx=3D
mount option to override the failure.

> >
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->maxBuf =3D=
 min((__u32)le16_to_cpu(rsp->MaxBufSize),
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (__u32)CIFSMaxBufSize + MAX_CIFS=
_HDR_SIZE);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->max_vcs =3D=
 le16_to_cpu(rsp->MaxNumberVcs);
> >> @@ -560,6 +565,11 @@ CIFSSMBNegotiate(unsigned int xid, struct cif=
s_ses *ses)
> >> =C2=A0 =C2=A0 =C2=A0 /* one byte, so no need to convert this or En=
cryptionKeyLen from
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0little endian */
> >> =C2=A0 =C2=A0 =C2=A0 server->maxReq =3D le16_to_cpu(pSMBr->MaxMpxC=
ount);
> >> + =C2=A0 =C2=A0 /* maxReq must be at least 2, almost all servers s=
et to 50,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0some old non-MS servers set incorrect=
ly so set to default
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0(otherwise oplock break e.g. would fa=
il */
> >> + =C2=A0 =C2=A0 if (server->maxReq < 2)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->maxReq =3D CIF=
S_MAX_REQ; /* 50 */
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ditto.
> >
> >> =C2=A0 =C2=A0 =C2=A0 /* probably no need to store and check maxvcs=
 */
> >> =C2=A0 =C2=A0 =C2=A0 server->maxBuf =3D min(le32_to_cpu(pSMBr->Max=
BufferSize),
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (__u32) CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index c761935..3f8cf63 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -95,7 +95,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 server->maxBuf =3D 0;
> >>
> >> - =C2=A0 =C2=A0 cFYI(1, "Reconnecting tcp session");
> >> + =C2=A0 =C2=A0 cERROR(1, "Reconnecting tcp session in flight %d",
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^^^
> > I don't think this ought to be a cERROR.
>=20
> Right - that was just a debug statement I threw in there to
> try to figure out what Windows XP was doing to our sessions
> (that line will stay a cFYI)
>=20
> >> atomic_read(&server->inFlight)); =C2=A0/* BB FIXME */
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* before reconnecting the tcp session, mark =
the smb session (uid)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 and the tid bad s=
o they are not used until reconnected */
> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> index 147aa22..11c6585 100644
> >> --- a/fs/cifs/transport.c
> >> +++ b/fs/cifs/transport.c
> >> @@ -264,7 +264,12 @@ static int wait_for_free_request(struct
> >> TCP_Server_Info *server,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 while (1) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (atomic_read(&serve=
r->inFlight) >=3D cifs_max_pending) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* We must check that =
don't exceed maxReq but on SMB Negotiate
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0it is not=
 initted yet (maxReq must be at least two) */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((atomic_read(&serv=
er->inFlight) >=3D cifs_max_pending) ||
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((atomic=
_read(&server->inFlight) >=3D server->maxReq) &&
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (=
server->maxReq > 1))) {
> >
> > Why continue to have a cifs_max_pending limit if you're going to
> > respect maxReq? This should be a per-socket limit only, IMO...
>=20
> Your point makes sense - and the memory usage of these structures
> isn't that great - but it does give us additional control (to shrink
> maxmpx if the server exhibits performance problems or perhaps even
> if the client exhibits memory limits when many, many mounts each
> with lots of pending requests).   My main reason for not wanting
> to touch the cifs_max_pending (and thus not yet removing
> the module_param) is to keep the patch smaller, and not change
> external interfaces this close to release.
>=20

Changing behavior this way for the reasons of expediency only to change
it again later will just add to user confusion. A global limit for this
value makes no sense at all. This limit really needs to be per-socket.

If you want to set a hard cap on the per-socket limit that's less than
what the protocol allows, then that's fine too. You could even fail the
mount in that case as well and suggest use of the mount option to
override it.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
