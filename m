From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 06:25:07 -0600
Message-ID: <AANLkTinsm=b5Pezzo4m6Jbmq96EcYas4Hsw0nhxfb4m6@mail.gmail.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org> <E1POnFL-00BKg9-JW@intern.SerNet.DE>
	<20101204064452.46ac24c7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org, "Christopher R. Hertel" <crh@samba.org>,
	Volker.Lendecke@sernet.de, cifs-protocol@samba.org,
	samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20101204064452.46ac24c7@tlielax.poochiereds.net>
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

On Sat, Dec 4, 2010 at 5:44 AM, Jeff Layton <jlayton@samba.org> wrote:

> On Sat, 4 Dec 2010 09:13:21 +0100
> Volker Lendecke <Volker.Lendecke@SerNet.DE> wrote:
>
> > On Fri, Dec 03, 2010 at 09:54:13PM -0600, Christopher R. Hertel wrote:
> > > That may seem to be in the "who cares" category, since those old
> transports
> > > are essentially dead (much more dead than NBT, or even NBF).
>  Unfortunately,
> > > the code to handle the old transports is still there in Windows, so
> there
> > > are behaviors -- things like the timeouts you're talking about and the
> weird
> > > VC=0 shutdown behvior -- that exist because of these old disused
> transports.
> >
> > VC=0, how does Windows treat this facing NAT (masquerading)
> > networks? I've done tests in the past where Windows killed
> > valid connections from behind a NAT box when a new client
> > came in.
> >
> > Volker
>
> It seems like the best way to deal with this on the server side with
> direct hosted TCP would be to treat VC=0 like any other VC number
> (MS-CIFS says that this is allowed).
>
> Ideally any new connection event from a host however should make the
> server check the validity of any other connection from the same host.
> That way you could release resources held by dead connections in case
> the new one is a reconnect and needs to reclaim state.
>
> The question is how to check that validity. Unfortunately, the best you
> can probably do is rely on TCP keepalives.
>
> --
> Jeff Layton <jlayton@samba.org>
>  --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


Is SMB Echo command the only way to determine whether to reconnect or not?
The assumption here is SMB server is unresponsive.
There could be other circumstances on the server box (or even client box)
that are
slowing down the SMB server responses such as slow network, slow network
stack,
memory pressure etc.
So server could be fine all along and yet client would ask for reconnection!
