From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 08:06:46 -0600
Message-ID: <AANLkTim45G=pLwznde8S_b=FGCnYyO29Tnokghs0qZ-y@mail.gmail.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org>
	<E1POnFL-00BKg9-JW@intern.SerNet.DE>
	<20101204064452.46ac24c7@tlielax.poochiereds.net>
	<AANLkTinsm=b5Pezzo4m6Jbmq96EcYas4Hsw0nhxfb4m6@mail.gmail.com>
	<20101204080942.42be63da@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101204080942.42be63da-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Dec 4, 2010 at 7:09 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sat, 4 Dec 2010 06:25:07 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Sat, Dec 4, 2010 at 5:44 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
>>
>> > On Sat, 4 Dec 2010 09:13:21 +0100
>> > Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org> wrote:
>> >
>> > > On Fri, Dec 03, 2010 at 09:54:13PM -0600, Christopher R. Hertel =
wrote:
>> > > > That may seem to be in the "who cares" category, since those o=
ld
>> > transports
>> > > > are essentially dead (much more dead than NBT, or even NBF).
>> > =A0Unfortunately,
>> > > > the code to handle the old transports is still there in Window=
s, so
>> > there
>> > > > are behaviors -- things like the timeouts you're talking about=
 and the
>> > weird
>> > > > VC=3D0 shutdown behvior -- that exist because of these old dis=
used
>> > transports.
>> > >
>> > > VC=3D0, how does Windows treat this facing NAT (masquerading)
>> > > networks? I've done tests in the past where Windows killed
>> > > valid connections from behind a NAT box when a new client
>> > > came in.
>> > >
>> > > Volker
>> >
>> > It seems like the best way to deal with this on the server side wi=
th
>> > direct hosted TCP would be to treat VC=3D0 like any other VC numbe=
r
>> > (MS-CIFS says that this is allowed).
>> >
>> > Ideally any new connection event from a host however should make t=
he
>> > server check the validity of any other connection from the same ho=
st.
>> > That way you could release resources held by dead connections in c=
ase
>> > the new one is a reconnect and needs to reclaim state.
>> >
>> > The question is how to check that validity. Unfortunately, the bes=
t you
>> > can probably do is rely on TCP keepalives.
>> >
>> > --
>> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> > =A0--
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>>
>> Is SMB Echo command the only way to determine whether to reconnect o=
r not?
>> The assumption here is SMB server is unresponsive.
>> There could be other circumstances on the server box (or even client=
 box)
>> that are
>> slowing down the SMB server responses such as slow network, slow net=
work
>> stack,
>> memory pressure etc.
>> So server could be fine all along and yet client would ask for recon=
nection!
>
> I think it's the best mechanism that the protocol has. If we aren't
> going to use SMB echoes to detect an unresponsive server, then what
> would you suggest? I don't think we can make calls wait indefinitely
> for a response without a mechanism to determine when the server is go=
ne
> and attempt to reestablish the connection to it.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

I think we should use smb echo command as a means to let users know the
state of mount/server and let them decide.
If smb echo times out, cifs client should just log it and stop at that =
and a
very next request that receives a response (if any does) should log tha=
t server
is responding.
