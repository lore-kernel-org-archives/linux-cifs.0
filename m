From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: long cifs timeout when share becomes unavailable
Date: Fri, 25 May 2012 08:26:04 -0400
Message-ID: <20120525082604.16fd27f1@tlielax.poochiereds.net>
References: <4FBDD189.6040402@telros.ru>
	<20120524063131.5bc93ecf@tlielax.poochiereds.net>
	<3b8a8049f2d724bdd621aa5e624d4047@telros.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sergey Urushkin <urushkin-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3b8a8049f2d724bdd621aa5e624d4047-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 24 May 2012 16:44:58 +0400
Sergey Urushkin <urushkin-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org> wrote:

> Jeff Layton =D0=BF=D0=B8=D1=81=D0=B0=D0=BB 24.05.2012 14:31:
> > On Thu, 24 May 2012 10:13:29 +0400
> > Sergey Urushkin <urushkin-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org> wrote:
> >>
> >>  And I can not see any timeout options for mount.cifs (except acl=20
> >> timeout).
> >> So, the actual questions are: 1) is there a way to avoid these han=
gs
> >> (analog of 'intr'?) and 2) how can I reduce this unreachable-host=20
> >> timeout
> >> (analog of 'timeo'?)? Maybe there are some variables in the source=
s?
> >
> > You can try setting the echo_retries kernel module parameter to 1,
> > which should cut down the wait time to 60s. In 3.4, we've removed
> > that parm and it's now set to 1 always. The timeout between echo
> > requests (which is how we detect whether the server is still
> > responding) is not currently tunable.
>=20
> That works like a charm, 60s is much better than 5m, thanks a lot. Fr=
om=20
> documentation (for kernels before 3.4) it isn't clear what behavior t=
his=20
> parm changes, maybe docs should be fixed some way?

Well, this parm has gone away now in recent kernels so I'm not inclined
to bother with documenting it. If you'd wish to do, maybe write up a
section for the manpage on the socket and reconnect behavior?

> Could you explain to me why SMB_ECHO_INTERVAL is so big by default?

We don't really want to spam the server with a ton of these requests.
The idea is that we wait a while for a response and then check with the
server to see if it's still alive before timing out the packet. Most
servers will respond to most calls within this time period and it's on
par with the default timeo=3D value for NFS over TCP.

Some calls however can take a very long time (minutes) writes long past
the end of the file, for instance. NTFS doesn't do sparse files so it
has to zero-fill them and that can take a long time on slow storage.

The echo is primarily to allow us to distinguish between servers that
are just slow to respond to certain calls, and those that are truly
unreachable.

> Is=20
> there any side effect of changing it to, for example, "30"? Does this=
=20
> change means that every 30 secs (twice more often) client will send=20
> special packets to the server (even in the case mounted share isn't u=
sed=20
> by any application at the moment)?

Yes, reducing that interval will make it send SMB echoes to the server
more frequently.

Will that have any side effects? Probably not, but I've not
experimented with it. I don't see a lot of value in making this tunable
since this is an error condition.

> What's about my first question? Could I make ls-like applications=20
> interruptible somehow?
>=20

Most of these sleeps are TASK_KILLABLE, so they should respond to fatal
signals (SIGKILL).

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
