From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Sat, 29 Oct 2011 21:53:13 -0500
Message-ID: <CAH2r5msVoEuxo8vGj6sYjjNqjPeo9wxa-r7bAq6Or1_xS9EWFg@mail.gmail.com>
References: <20110927212810.GA12900@elgon.mountain>
	<20111013132755.6c5db87e@barsoom.rdu.redhat.com>
	<CAH2r5mtOF=Ja7_mTK576uEqgZqaVH+8YXtOqmZVknBC81sD=8Q@mail.gmail.com>
	<20111028072019.GA14900@longonot.mountain>
	<CAH2r5msb_+tenSg1kWCn_0xi2EZu6vboqvmbQ17vRBYoqHp2Eg@mail.gmail.com>
	<20111028234406.01fd23ba@corrin.poochiereds.net>
	<CAH2r5mvHF0X6PQ8FyBfVEpQeyWgd7RGkawJykapkKt0K84QTHw@mail.gmail.com>
	<20111029014855.13dd53be@corrin.poochiereds.net>
	<CAH2r5muq4n34Liy_=CQQX-PeTinJFDAPi81fA-eqsTcXw5remQ@mail.gmail.com>
	<20111029224852.15ee6302@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111029224852.15ee6302-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I thought we agreed that (at worst) the logic works for the "noperm"
(no client side enforcement, ie multiuser case).

On Sat, Oct 29, 2011 at 9:48 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sat, 29 Oct 2011 17:03:46 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Sat, Oct 29, 2011 at 12:48 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wr=
ote:
>> > On Sat, 29 Oct 2011 00:07:12 -0500
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Fri, Oct 28, 2011 at 10:44 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>=
 wrote:
>> >> > On Fri, 28 Oct 2011 10:27:04 -0500
>> >> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >
>> >> >> On Fri, Oct 28, 2011 at 2:20 AM, Dan Carpenter <dan.carpenter@=
oracle.com> wrote:
>> >> >> > On Wed, Oct 19, 2011 at 09:14:37PM -0500, Steve French wrote=
:
>> >> >> >> Doesn't this force the create to happen later - rather than
>> >> >> >> at lookup time where it belongs?
>> >> >> >>
>> >> >> >> if the issue is just noperm ... we should let this through =
if the user
>> >> >> >> has local permissions. =A0Doubling the cost of a file creat=
e to Samba
>> >> >> >> seems like a bad idea (ie doing aQueryPathInfo AND an NTCre=
ateX
>> >> >> >> doubles the roundrip, doubles the load on the server etc.) =
- the whole
>> >> >> >> point of this is to let us do an "atomic" open or create op=
eration
>> >> >> >> and not have to split it into multiple requests. =A0In any =
case why would
>> >> >> >> we do the open and then follow it with a create?
>> >> >> >>
>> >> >> >> Can we fix this to (at least) narrow the performance penalt=
y.
>> >> >> >>
>> >> >> >
>> >> >> > Yes, it does add another back and forth to file create... =A0=
It's hard/
>> >> >> > impossible to check the permissions first and then decide wh=
ether to
>> >> >> > pass the O_CREAT flag. =A0Maybe we could add an if statement=
 to check
>> >> >> > whether noperm was used and the noperm version could use the=
 create
>> >> >> > on lookup.
>> >> >>
>> >> >> Why is it hard to check local permissions? We have the local m=
ode
>> >> >> for the parent.
>> >> >>
>> >> >> Also note that the "intent" flags and the atomic create is not=
 just
>> >> >> about performance, but also making it atomic reduces some of t=
he weird
>> >> >> failure cases.
>> >> >>
>> >> >
>> >> > We have the local mode for the parent, but we do not have the o=
wnership
>> >> > and mode for the file that has not yet been created. Because of=
 the
>> >> > special (ahem) way that cifs handles permissions, it's easily p=
ossible
>> >> > for the ownership of the file not to match the user doing that =
create.
>> >> > At that point, later operations on the file can easily fail.
>> >> >
>> >> > This was the primary reason for the multiuser patch series, and=
 why I
>> >> > still say that doing permissions checking on the client is a br=
oken
>> >> > model.
>> >>
>> >> We don't have much choice - we have to allow permission
>> >> checking on the client when client security context
>> >> can't match security context on server - but I would like
>> >> to make multiuser the default (especially if we
>> >> can figure out a way to integrate winbind-like
>> >> upcall for ntlmv2 auth) at least for the future (smb2 etc.)
>> >> even if we can't change the default for cifs mounts.
>> >>
>> >
>> > That's fine, but that doesn't solve Dan's immediate problem. We ne=
ed to
>> > either take his patch or something like it for 3.2 (and probably f=
or
>> > stable as well) or just rip this crap out altogether.
>>
>> The benchmark gains are huge for a couple test cases
>> (e.g. creating lots of small files) - doesn't make sense to throw it=
 out.
>> At worst (I think we can do better) - we only give up on atomic
>> open/create for when noperm is not set (we want our users
>> to be running noperm or equivalently multiuser). =A0 It is especiall=
y
>> important since the servers we do best at with create turn out
>> to be Linux ( and other Unix which Samba runs on (due to posix exten=
sions)).
>>
>
> I don't care at all about performance if the behavior is wrong. We ne=
ed
> to worry about correctness first and only then optimize for
> performance. The create on lookup code has been the source of many
> regressions and I think it's time to pull the plug on it until someon=
e
> wants to take the time to do it right.
>
> I think it's obvious that the logic in cifs_lookup makes no sense. I'=
d
> prefer to see that ripped out until someone presents a design for thi=
s
> that does make sense, but if you want to present code that fixes this
> more logically then I'd be happy to look at it.
>
>> If we break create apart as you suggest - we run into
>> lookup/getattr/create/open/setattr
>> races which are also annoying - we are supposed to send an atomic
>> create/open operation
>> to minimize strange consequences if the server file changes in betwe=
en
>> (the alternative)
>> where getattr/create/open/setattr is done.
>>
>
> We only have to worry about atomicity in the O_EXCL case, and that is
> already covered in the earlier check in cifs_lookup.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>



--=20
Thanks,

Steve
