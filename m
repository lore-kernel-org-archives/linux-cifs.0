From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Sat, 29 Oct 2011 22:48:52 -0400
Message-ID: <20111029224852.15ee6302@corrin.poochiereds.net>
References: <20110927212810.GA12900@elgon.mountain>
	<20111013132755.6c5db87e@barsoom.rdu.redhat.com>
	<CAH2r5mtOF=Ja7_mTK576uEqgZqaVH+8YXtOqmZVknBC81sD=8Q@mail.gmail.com>
	<20111028072019.GA14900@longonot.mountain>
	<CAH2r5msb_+tenSg1kWCn_0xi2EZu6vboqvmbQ17vRBYoqHp2Eg@mail.gmail.com>
	<20111028234406.01fd23ba@corrin.poochiereds.net>
	<CAH2r5mvHF0X6PQ8FyBfVEpQeyWgd7RGkawJykapkKt0K84QTHw@mail.gmail.com>
	<20111029014855.13dd53be@corrin.poochiereds.net>
	<CAH2r5muq4n34Liy_=CQQX-PeTinJFDAPi81fA-eqsTcXw5remQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muq4n34Liy_=CQQX-PeTinJFDAPi81fA-eqsTcXw5remQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 29 Oct 2011 17:03:46 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Oct 29, 2011 at 12:48 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > On Sat, 29 Oct 2011 00:07:12 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Fri, Oct 28, 2011 at 10:44 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =
wrote:
> >> > On Fri, 28 Oct 2011 10:27:04 -0500
> >> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> On Fri, Oct 28, 2011 at 2:20 AM, Dan Carpenter <dan.carpenter@o=
racle.com> wrote:
> >> >> > On Wed, Oct 19, 2011 at 09:14:37PM -0500, Steve French wrote:
> >> >> >> Doesn't this force the create to happen later - rather than
> >> >> >> at lookup time where it belongs?
> >> >> >>
> >> >> >> if the issue is just noperm ... we should let this through i=
f the user
> >> >> >> has local permissions. =C2=A0Doubling the cost of a file cre=
ate to Samba
> >> >> >> seems like a bad idea (ie doing aQueryPathInfo AND an NTCrea=
teX
> >> >> >> doubles the roundrip, doubles the load on the server etc.) -=
 the whole
> >> >> >> point of this is to let us do an "atomic" open or create ope=
ration
> >> >> >> and not have to split it into multiple requests. =C2=A0In an=
y case why would
> >> >> >> we do the open and then follow it with a create?
> >> >> >>
> >> >> >> Can we fix this to (at least) narrow the performance penalty=
=2E
> >> >> >>
> >> >> >
> >> >> > Yes, it does add another back and forth to file create... =C2=
=A0It's hard/
> >> >> > impossible to check the permissions first and then decide whe=
ther to
> >> >> > pass the O_CREAT flag. =C2=A0Maybe we could add an if stateme=
nt to check
> >> >> > whether noperm was used and the noperm version could use the =
create
> >> >> > on lookup.
> >> >>
> >> >> Why is it hard to check local permissions? We have the local mo=
de
> >> >> for the parent.
> >> >>
> >> >> Also note that the "intent" flags and the atomic create is not =
just
> >> >> about performance, but also making it atomic reduces some of th=
e weird
> >> >> failure cases.
> >> >>
> >> >
> >> > We have the local mode for the parent, but we do not have the ow=
nership
> >> > and mode for the file that has not yet been created. Because of =
the
> >> > special (ahem) way that cifs handles permissions, it's easily po=
ssible
> >> > for the ownership of the file not to match the user doing that c=
reate.
> >> > At that point, later operations on the file can easily fail.
> >> >
> >> > This was the primary reason for the multiuser patch series, and =
why I
> >> > still say that doing permissions checking on the client is a bro=
ken
> >> > model.
> >>
> >> We don't have much choice - we have to allow permission
> >> checking on the client when client security context
> >> can't match security context on server - but I would like
> >> to make multiuser the default (especially if we
> >> can figure out a way to integrate winbind-like
> >> upcall for ntlmv2 auth) at least for the future (smb2 etc.)
> >> even if we can't change the default for cifs mounts.
> >>
> >
> > That's fine, but that doesn't solve Dan's immediate problem. We nee=
d to
> > either take his patch or something like it for 3.2 (and probably fo=
r
> > stable as well) or just rip this crap out altogether.
>=20
> The benchmark gains are huge for a couple test cases
> (e.g. creating lots of small files) - doesn't make sense to throw it =
out.
> At worst (I think we can do better) - we only give up on atomic
> open/create for when noperm is not set (we want our users
> to be running noperm or equivalently multiuser).   It is especially
> important since the servers we do best at with create turn out
> to be Linux ( and other Unix which Samba runs on (due to posix extens=
ions)).
>=20

I don't care at all about performance if the behavior is wrong. We need
to worry about correctness first and only then optimize for
performance. The create on lookup code has been the source of many
regressions and I think it's time to pull the plug on it until someone
wants to take the time to do it right.

I think it's obvious that the logic in cifs_lookup makes no sense. I'd
prefer to see that ripped out until someone presents a design for this
that does make sense, but if you want to present code that fixes this
more logically then I'd be happy to look at it.

> If we break create apart as you suggest - we run into
> lookup/getattr/create/open/setattr
> races which are also annoying - we are supposed to send an atomic
> create/open operation
> to minimize strange consequences if the server file changes in betwee=
n
> (the alternative)
> where getattr/create/open/setattr is done.
>=20

We only have to worry about atomicity in the O_EXCL case, and that is
already covered in the earlier check in cifs_lookup.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
