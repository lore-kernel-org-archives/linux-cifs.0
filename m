From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] cifs: don't perform SMB echoes on un-negotiated socket
Date: Mon, 7 Feb 2011 17:59:12 -0600
Message-ID: <AANLkTinqpuyWRTZNn_eJfF0rwU29s7qzKurYGyQE8u3-@mail.gmail.com>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
	<AANLkTi=zs7KZjTnysqxpnGam+2Mv3FRTCKZcY8fB0uFU@mail.gmail.com>
	<20110207132036.7af97f8f@tlielax.poochiereds.net>
	<AANLkTikD-Q9A5VxfkbkL-Yg9CjwCTNSoyA9W2biHCOA2@mail.gmail.com>
	<20110207161414.1694cad0@tlielax.poochiereds.net>
	<AANLkTiktLMYNi=crSh+NaE2=6qfWgw=ohLjKhp77sJt+@mail.gmail.com>
	<20110207165726.7141bb4b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110207165726.7141bb4b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 7, 2011 at 3:57 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 7 Feb 2011 15:29:05 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Feb 7, 2011 at 3:14 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> > On Mon, 7 Feb 2011 12:36:22 -0600
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Mon, Feb 7, 2011 at 12:20 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
>> >> > On Mon, 7 Feb 2011 11:42:05 -0600
>> >> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >
>> >> >> On Mon, Feb 7, 2011 at 7:54 AM, Jeff Layton <jlayton-H+wXaHxf7aJhl2p70BpVqQ@public.gmane.org=
m> wrote:
>> >> >> > Commit 247ec9b4 makes the SMB echo workqueue job skip doing =
echoes
>> >> >> > unless the tcpStatus =3D=3D CifsGood. Problem: tcpStatus =3D=
=3D CifsGood is not
>> >> >> > a reliable indicator of whether the socket has had a NEGOTIA=
TE done on
>> >> >> > it. This fixes that by adding a new tcpStatus of CifsNeedNeg=
otiate that
>> >> >> > indicates this. It also cleans up cifs_reconnect_tcon a bit.
>> >> >> >
>> >> >> > This is not the only way to fix this issue. As Steve pointed=
 out to me,
>> >> >> > we could also check to see whether there's a valid SMB sessi=
on on the
>> >> >> > list as an indicator of whether a NEGOTIATE has been done. I=
 think the
>> >> >> > approach I'm proposing clarifies the code better, but I'm wi=
lling to go
>> >> >> > with his approach if that's the general concensus.
>> >> >>
>> >> >> Jeff may be right that the code is clearer with this approach =
(I may try
>> >> >> to code the alternative to check) but ... we really shouldn't =
be sending
>> >> >> an SMBecho between negprot and sessionsetup anyway (so checkin=
g for
>> >> >> sessionsetup may make sense).
>> >> >> =A0If a negprot times out or
>> >> >> sessionsetup times out we don't need to be sending SMBecho
>> >> >> (on the other hand perhaps a really slow krb5 sessionsetup?)
>> >> >> Once a sessionsetup is sent, SMBechos make more sense.
>> >> >>
>> >> >
>> >> > Why shouldn't we send one between the negotiate and session set=
up? The
>> >> > MS-CIFS spec makes no mention that a session setup is required =
prior to
>> >> > doing an echo. You may be correct, but that's not really what t=
he spec
>> >> > says.
>> >>
>> >> I don't remember ever having seen one between negprot and session=
setup
>> >> from other clients - but the broader point is that an SMBecho doe=
sn't
>> >> serve any purpose in between negprot/sessionsetup (once at least =
one
>> >> session is setup, checking if the server stays up is more interes=
ting)
>> >>
>> >
>> > I'm not sure I agree there. There's nothing that says that the
>> > NEGOTIATE and SESSION_SETUP have to be done within a certain amoun=
t of
>> > time of each other. Checking the validity of the connection there =
seems
>> > reasonable.
>> >
>> > ...but at this point, if you think checking for a valid session is=
 the
>> > best approach then so be it.
>>
>> I am not convinced which way is best and it likely doesn't matter.
>>
>> > Practically, how do you suggest that we check for a valid SMB sess=
ion?
>> > I assume the code will need to walk the smb_ses_list. The ses->sta=
tus
>> > doesn't appear to actually change on reconnect however. It only se=
ts
>> > the "need_reconnect" boolean.
>> >
>> > It appears that the ses->status is set to CifsGood and never chang=
es
>> > after the initial session setup. Perhaps that field should be remo=
ved?
>>
>> aah - that makes it tougher to check. =A0If we don't mark ses->Statu=
s =3D=3D
>> NEED_RECONNECT
>> or something other than CifsGood then your approach is easier.
>>
>
> Well, we do mark a need_reconnect boolean which we could check, but
> what about sessions that are just being established for the first tim=
e?
> They typically don't go on the list until they are established, but I
> don't really want to depend on that since that's really an
> implementation detail.
>
> The ad hoc nature of a lot of this code makes me worry that future
> changes to it could break things. The fields that are intended to tra=
ck
> state are not clearly defined, so it's hard to depend on any of this
> without clearly defining what the states actually represent. The
> locking around the state variables doesn't follow any clear rules
> either.
>
> This code is probably ripe for cleanup, but I'm not going to embark o=
n
> that for 2.6.38. Would it be reasonable to take the patches I've
> already proposed and we can discuss approaches to clean this code up
> when we're at Connectathon in a few weeks?

Yes - I am leaning toward simply merging the (apparently) working patch
(it shouldn't take me long to finish review) -  that makes sense
rather than overoptimizing.   That the tcp connection establishment
follows a different state model than the smb session is ok with me
as long as we don't have old bugs to fix in it.   There are lots
of higher priority things to fix/enhance (including improving uid mappi=
ng
support and enhancing your multiuser code which is turning out
to be useful but has restrictions that make it harder for some
common scenarios).   And of course - the really important things:
1) cifs_readpages and cifs_writepages dispatch of multiple
requests in parallel, asynchronously (which should make cifs
close to optimal for large file copy)
2) smb2:  ... and the only way to get much better performance will be w=
ith
smb2 (where larger i/o sizes, and credits, and a better
oplock model make it better performing)
to get



--=20
Thanks,

Steve
