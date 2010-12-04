From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 08:46:53 -0600
Message-ID: <AANLkTimN0F5KyM7r1+k3Y3Ki+kwQukAr4uXzRJuMVZtX@mail.gmail.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org> <E1POnFL-00BKg9-JW@intern.SerNet.DE>
	<20101204064452.46ac24c7@tlielax.poochiereds.net>
	<AANLkTinsm=b5Pezzo4m6Jbmq96EcYas4Hsw0nhxfb4m6@mail.gmail.com>
	<20101204080942.42be63da@tlielax.poochiereds.net>
	<AANLkTim45G=pLwznde8S_b=FGCnYyO29Tnokghs0qZ-y@mail.gmail.com>
	<20101204092240.4724e1ff@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, "Christopher R. Hertel" <crh@samba.org>,
	Volker.Lendecke@sernet.de, cifs-protocol@samba.org,
	samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20101204092240.4724e1ff@corrin.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Dec 4, 2010 at 8:22 AM, Jeff Layton <jlayton@samba.org> wrote:
> On Sat, 4 Dec 2010 08:06:46 -0600
> Shirish Pargaonkar <shirishpargaonkar@gmail.com> wrote:
>
>> On Sat, Dec 4, 2010 at 7:09 AM, Jeff Layton <jlayton@samba.org> wrote:
>> > On Sat, 4 Dec 2010 06:25:07 -0600
>> > Shirish Pargaonkar <shirishpargaonkar@gmail.com> wrote:
>> >
>> >> On Sat, Dec 4, 2010 at 5:44 AM, Jeff Layton <jlayton@samba.org> wrote=
:
>> >>
>> >> > On Sat, 4 Dec 2010 09:13:21 +0100
>> >> > Volker Lendecke <Volker.Lendecke@SerNet.DE> wrote:
>> >> >
>> >> > > On Fri, Dec 03, 2010 at 09:54:13PM -0600, Christopher R. Hertel w=
rote:
>> >> > > > That may seem to be in the "who cares" category, since those ol=
d
>> >> > transports
>> >> > > > are essentially dead (much more dead than NBT, or even NBF).
>> >> > =A0Unfortunately,
>> >> > > > the code to handle the old transports is still there in Windows=
, so
>> >> > there
>> >> > > > are behaviors -- things like the timeouts you're talking about =
and the
>> >> > weird
>> >> > > > VC=3D0 shutdown behvior -- that exist because of these old disu=
sed
>> >> > transports.
>> >> > >
>> >> > > VC=3D0, how does Windows treat this facing NAT (masquerading)
>> >> > > networks? I've done tests in the past where Windows killed
>> >> > > valid connections from behind a NAT box when a new client
>> >> > > came in.
>> >> > >
>> >> > > Volker
>> >> >
>> >> > It seems like the best way to deal with this on the server side wit=
h
>> >> > direct hosted TCP would be to treat VC=3D0 like any other VC number
>> >> > (MS-CIFS says that this is allowed).
>> >> >
>> >> > Ideally any new connection event from a host however should make th=
e
>> >> > server check the validity of any other connection from the same hos=
t.
>> >> > That way you could release resources held by dead connections in ca=
se
>> >> > the new one is a reconnect and needs to reclaim state.
>> >> >
>> >> > The question is how to check that validity. Unfortunately, the best=
 you
>> >> > can probably do is rely on TCP keepalives.
>> >> >
>> >> > --
>> >> > Jeff Layton <jlayton@samba.org>
>> >> > =A0--
>> >> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
>> >> > the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>> >> >
>> >>
>> >>
>> >> Is SMB Echo command the only way to determine whether to reconnect or=
 not?
>> >> The assumption here is SMB server is unresponsive.
>> >> There could be other circumstances on the server box (or even client =
box)
>> >> that are
>> >> slowing down the SMB server responses such as slow network, slow netw=
ork
>> >> stack,
>> >> memory pressure etc.
>> >> So server could be fine all along and yet client would ask for reconn=
ection!
>> >
>> > I think it's the best mechanism that the protocol has. If we aren't
>> > going to use SMB echoes to detect an unresponsive server, then what
>> > would you suggest? I don't think we can make calls wait indefinitely
>> > for a response without a mechanism to determine when the server is gon=
e
>> > and attempt to reestablish the connection to it.
>> >
>> > --
>> > Jeff Layton <jlayton@samba.org>
>> >
>>
>> I think we should use smb echo command as a means to let users know the
>> state of mount/server and let them decide.
>> If smb echo times out, cifs client should just log it and stop at that a=
nd a
>> very next request that receives a response (if any does) should log that=
 server
>> is responding.
>
> Could you elaborate a bit?
>
> What do you mean by "let them decide" -- what steps would someone take
> if the server stopped responding? Aside from killing the application,
> what recourse would they have?
>
> --
> Jeff Layton <jlayton@samba.org>
>

Jeff, I am not sure.  Basically I am coming from here:

I have a bug open, where an SMB server when slow to respond
(for a cifs client), if cifs client reconnects, causes data corruption
on the server. If left to its own, responses from server eventually
make through (without any intervention) and tests pass.

If an SMB server is unresponsive, how do we know it will respond to
a reconnect or a reconnect will help?  I do not know enough about
SMB servers to describe an unresponsive server i.e. how and when
it came to be unresponsive, how it handles transport layer then,
whether it corrects itself or how to correct it, how it handles
underlying physical file sytem etc..
