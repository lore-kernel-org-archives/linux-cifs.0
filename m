From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: eliminate CONFIG_CIFS_WEAK_PW_HASH
Date: Fri, 27 Apr 2012 08:58:55 -0500
Message-ID: <CAH2r5msLTZeYQQRN=YdBBOSXu=FRphP0L_3XuofmtDi80e+hQQ@mail.gmail.com>
References: <1327091153-22391-1-git-send-email-jlayton@redhat.com>
	<CAH2r5msOk=4rz_XUGi+GitzVGyJrSo9B1iGXdjz0Bnymzt0NyQ@mail.gmail.com>
	<20120120153856.6ded308a@tlielax.poochiereds.net>
	<CAH2r5ms6YbZp+erat9RQw7-vMxem6vLWp72Yaf=Z8d4p=4+BBQ@mail.gmail.com>
	<1327118615.7985.5.camel@ruth>
	<20120121073720.3cf546fc@tlielax.poochiereds.net>
	<1327166803.2908.761.camel@pico.li.ssimo.org>
	<20120427071548.4843f5cb@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120427071548.4843f5cb-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Apr 27, 2012 at 6:15 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Sat, 21 Jan 2012 12:26:43 -0500
> simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> On Sat, 2012-01-21 at 07:37 -0500, Jeff Layton wrote:
>> > On Sat, 21 Jan 2012 15:03:31 +1100
>> > Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> >
>> > > On Fri, 2012-01-20 at 14:45 -0600, Steve French wrote:
>> > > > My general thinking on this is as follows:
>> > > >
>> > > > If the kernel is distributed to all the workstations in an org=
anization
>> > > > with this Kconfig option disabled, it makes it harder for indi=
vidual users
>> > > > to make the mistake of enabling lanman (sec=3Dlanman, or the K=
config
>> > > > option) on a public network and thus send weak password hashes
>> > > > which could be discovered simply. =A0 Most distros make the ch=
oice
>> > > > of enabling broader compatibility with old pre-1997 servers bu=
t
>> > > > it is a very small set of servers who would require lanman sup=
port,
>> > > > and a large number of potential attackers who could benefit if
>> > > > users enable lanman on a public network. =A0I suspect that the=
re
>> > > > are environments where removing code (via Kconfig) is preferre=
d
>> > > > to trusting all owners of all workstations running that organi=
zations
>> > > > standard linux to never enable lanman at runtime.
>> > > >
>> > > > But ... the opinion of security specialists on this would be w=
elcome.
>> > >
>> > > We have been though some of this with the kerberos libs, which n=
ow allow
>> > > (default?) to not even compile with weak crypto. =A0If the weak =
crypto is
>> > > not compiled in, it can therefore be asserted that the weak cryp=
to
>> > > cannot be used, and this makes it easier to comply with security
>> > > audits/certification etc.
>> > >
>> > > I don't want to make your code more complex than it needs to be,=
 but LM
>> > > encryption really, really needs to go away. =A0If it is not a ma=
jor
>> > > bother, I would like to make it easier for that to happen if pos=
sible.
>> > >
>> >
>> > The only way for it to go away completely is for all servers that
>> > support only that encryption to go away completely. Unfortunately,
>> > that's a tall order -- there are still at least some in the field =
and
>> > people need to get at data on them.
>>
>> Jeff, can you identify them ?
>>
>> LM only servers means pre Win 95 machines, I'd be curious to know wh=
at
>> servers are there that really support only LM hashes and not NT hash=
es.
>>
>
> Sorry for the long delay in responding here. Yes, mostly pre-win95
> machines. We occasionally get reports from people using OS/2 and I'm
> pretty sure it's LM-only.
>
> Steve, in any case...shall I consider this patch NAK'ed for now? I wa=
s
> carrying it in my tree for 3.5, but it seems like there's resistance =
to
> removing this option and I'm not particularly religious on the matter=
=2E

I don't think it is worth changing - I prefer to build with
WEAK_PS_HASH disabled.

--=20
Thanks,

Steve
