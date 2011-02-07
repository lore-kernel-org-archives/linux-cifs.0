From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] cifs: don't perform SMB echoes on un-negotiated socket
Date: Mon, 7 Feb 2011 15:29:05 -0600
Message-ID: <AANLkTiktLMYNi=crSh+NaE2=6qfWgw=ohLjKhp77sJt+@mail.gmail.com>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
	<AANLkTi=zs7KZjTnysqxpnGam+2Mv3FRTCKZcY8fB0uFU@mail.gmail.com>
	<20110207132036.7af97f8f@tlielax.poochiereds.net>
	<AANLkTikD-Q9A5VxfkbkL-Yg9CjwCTNSoyA9W2biHCOA2@mail.gmail.com>
	<20110207161414.1694cad0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110207161414.1694cad0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 7, 2011 at 3:14 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 7 Feb 2011 12:36:22 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Feb 7, 2011 at 12:20 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Mon, 7 Feb 2011 11:42:05 -0600
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Mon, Feb 7, 2011 at 7:54 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>> >> > Commit 247ec9b4 makes the SMB echo workqueue job skip doing ech=
oes
>> >> > unless the tcpStatus =3D=3D CifsGood. Problem: tcpStatus =3D=3D=
 CifsGood is not
>> >> > a reliable indicator of whether the socket has had a NEGOTIATE =
done on
>> >> > it. This fixes that by adding a new tcpStatus of CifsNeedNegoti=
ate that
>> >> > indicates this. It also cleans up cifs_reconnect_tcon a bit.
>> >> >
>> >> > This is not the only way to fix this issue. As Steve pointed ou=
t to me,
>> >> > we could also check to see whether there's a valid SMB session =
on the
>> >> > list as an indicator of whether a NEGOTIATE has been done. I th=
ink the
>> >> > approach I'm proposing clarifies the code better, but I'm willi=
ng to go
>> >> > with his approach if that's the general concensus.
>> >>
>> >> Jeff may be right that the code is clearer with this approach (I =
may try
>> >> to code the alternative to check) but ... we really shouldn't be =
sending
>> >> an SMBecho between negprot and sessionsetup anyway (so checking f=
or
>> >> sessionsetup may make sense).
>> >> =A0If a negprot times out or
>> >> sessionsetup times out we don't need to be sending SMBecho
>> >> (on the other hand perhaps a really slow krb5 sessionsetup?)
>> >> Once a sessionsetup is sent, SMBechos make more sense.
>> >>
>> >
>> > Why shouldn't we send one between the negotiate and session setup?=
 The
>> > MS-CIFS spec makes no mention that a session setup is required pri=
or to
>> > doing an echo. You may be correct, but that's not really what the =
spec
>> > says.
>>
>> I don't remember ever having seen one between negprot and sessionset=
up
>> from other clients - but the broader point is that an SMBecho doesn'=
t
>> serve any purpose in between negprot/sessionsetup (once at least one
>> session is setup, checking if the server stays up is more interestin=
g)
>>
>
> I'm not sure I agree there. There's nothing that says that the
> NEGOTIATE and SESSION_SETUP have to be done within a certain amount o=
f
> time of each other. Checking the validity of the connection there see=
ms
> reasonable.
>
> ...but at this point, if you think checking for a valid session is th=
e
> best approach then so be it.

I am not convinced which way is best and it likely doesn't matter.

> Practically, how do you suggest that we check for a valid SMB session=
?
> I assume the code will need to walk the smb_ses_list. The ses->status
> doesn't appear to actually change on reconnect however. It only sets
> the "need_reconnect" boolean.
>
> It appears that the ses->status is set to CifsGood and never changes
> after the initial session setup. Perhaps that field should be removed=
?

aah - that makes it tougher to check.  If we don't mark ses->Status =3D=
=3D
NEED_RECONNECT
or something other than CifsGood then your approach is easier.

> We could replace the "need_reconnect" flag with an "established" flag=
,
> that's a clear indicator of whether the session setup conversation is
> complete.
>
> ...or is there a better way to do this?




--=20
Thanks,

Steve
