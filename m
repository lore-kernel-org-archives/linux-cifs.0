From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cifs: make OplockEnabled a module parameter
Date: Tue, 11 Oct 2011 11:38:30 -0400
Message-ID: <20111011113830.0d04dd73@corrin.poochiereds.net>
References: <4E940E2B.4050705@suse.de>
	<20111011063236.3fb399e0@tlielax.poochiereds.net>
	<4E942399.8050807@suse.de>
	<CAH2r5muJ6xiW5iPALmdaSxh=vYKGfq6SdWoRcf7YFGDFnxnDWw@mail.gmail.com>
	<20111011111228.7de52ca4@corrin.poochiereds.net>
	<CAH2r5mubs3wpz=RU9SNRcsRHB=fD+7E8MHQiBW3VnZ79_6rNUA@mail.gmail.com>
	<20111011112420.679251a3@corrin.poochiereds.net>
	<CAH2r5mt8fzUzS=Jeb+uHm1sE1HB9rAM77eDW=0tpBQiTuXsLFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt8fzUzS=Jeb+uHm1sE1HB9rAM77eDW=0tpBQiTuXsLFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Oct 2011 10:35:07 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Oct 11, 2011 at 10:24 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Tue, 11 Oct 2011 10:21:21 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Tue, Oct 11, 2011 at 10:12 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
> >> > On Tue, 11 Oct 2011 10:03:31 -0500
> >> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> On Tue, Oct 11, 2011 at 6:08 AM, Suresh Jayaraman <sjayaraman@s=
use.de> wrote:
> >> >> > On 10/11/2011 04:02 PM, Jeff Layton wrote:
> >> >> >> On Tue, 11 Oct 2011 15:06:43 +0530
> >> >> >> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> >> >> >>
> >> >> >>> Thus spake Jeff Layton:
> >> >> >>>
> >> >> >>> "Making that a module parm would allow you to set that para=
meter at boot
> >> >> >>> time without needing to add special startup scripts. IMO, a=
ll of the
> >> >> >>> procfile "switches" under /proc/fs/cifs should be module pa=
rms
> >> >> >>> instead."
> >> >> >>>
> >> >> >>> This seems reasonable so this patch makes OplockEnabled a m=
odule
> >> >> >>> parameter and rename it to enable_oplocks to comply with th=
e coding
> >> >> >>> conventions. This patch removes the proc file handling pert=
aining to
> >> >> >>> /proc/fs/cifs/OplockEnabled which would no longer be requir=
ed if this
> >> >> >>> patch gets accepted.
> >> >> >>>
> >> >> >>> This patch doesn't alter the default behavior (Oplocks enab=
led by
> >> >> >>> default). To disable oplocks when loading the module, use
> >> >> >>>
> >> >> >>> =C2=A0 =C2=A0modprobe cifs enable_oplocks=3D0
> >> >> >>>
> >> >> >>> Note:
> >> >> >>> (a) I'm little worried about eliminating an already known i=
nterace to
> >> >> >>> =C2=A0 =C2=A0 enable/disable Oplocks. An update to README f=
ile mentioning this info
> >> >> >>> =C2=A0 =C2=A0 is planned. Do we need to warn users before p=
ulling it off? Any
> >> >> >>> =C2=A0 =C2=A0 suggestions on how we could do this?
> >> >> >>> (b) Most of the /proc/fs/cifs switches could be converted t=
o a module
> >> >> >>> =C2=A0 =C2=A0 param for e.g. LookupCacheEnabled, LinuxExten=
sionsEnabled,
> >> >> >>> =C2=A0 =C2=A0 MultiuserMount etc. I'll post further patches=
 once this gets
> >> >> >>> =C2=A0 =C2=A0 accepted.
> >> >> >>>
> >> >> >>
> >> >> >> Yeah, I don't think we ought to just rip out these interface=
s
> >> >> >> unannounced. What should probably happen is this:
> >> >> >>
> >> >> >> Add the new module parms, and a patch that makes a printk po=
p when the
> >> >> >> old interfaces are used. The printk should announce somethin=
g like:
> >> >> >>
> >> >> >> "The /proc/fs/cifs/foo interface will be removed in kernel v=
ersion 3.x.
> >> >> >> Please migrate to using the 'enable_foo' module parameter in=
 cifs.ko."
> >> >> >>
> >> >> >> Make the 3.x version be 2 releases out. Then have patches re=
ady to go
> >> >> >> to remove those interfaces when the 3.x merge window opens.
> >> >> I don't mind adding a module parm to change the default but it =
seems
> >> >> odd, and removing the ability to temporarily turn off oplock se=
ems to
> >> >> make things worse not better. =C2=A0But I am not convinced of a=
 good use
> >> >> case for disabling oplocks on module load (rather than the more
> >> >> granular "forcedirectio" on mount, or the temporary ie at runti=
me via
> >> >> /proc). =C2=A0 If oplock/caching on the client were broken, the=
n we would
> >> >> fix the bug rather than ask users to load with oplock off, if o=
plock
> >> >> were broken on a server, we would not want to disable it for mo=
unts to
> >> >> all servers (as would a module parm) but just to workaround the=
 broken
> >> >> server.
> >> >>
> >> >
> >> > This doesn't prevent you from changing this setting after the mo=
dule is
> >> > loaded. It just moves the control to a more standard location
> >> > (/sys/module/cifs/parameters).
> >>
> >> If "echo 1 > /sys/module/cifs/parameters/oplock_enabled" would wor=
k at runtime,
> >> then I fine with the change. =C2=A0 We could leave them both in fo=
r one release,
> >> and throw a onetime syslog message if you use the one in /proc/fs/=
cifs/ (so
> >> that users know that the old interface is going away)??
> >>
> >>
> >
> > Yes, that will work at runtime.
> >
> > I suggest leaving the old control in for 2 releases since that's th=
e
> > kernel "standard" for user-visible changes. There's no rush to
> > deprecate the old code, so we should err on the side of caution.
>=20
> Next obvious question - do we have other module parameters that
> need to be changed to make config possible runtime.  Today only
> echo_retries is configurable that way. The only other possible one
> I see is cifs_max_pending (whose meaning will change in any case
> when the maxmpx patch is merged - with the patch the upper limit will
> be the minimum of cifs_max_pending and the server's returned
> maxmpx rather than simply using cifs_max_pending).
>=20
> There are six other parms (besides OplockEnabled) in /proc/fs/cifs
> but I doubt that it is worth the trouble and confusion to change any
> of them (although security flags is one that is more likely to want t=
o be
> changed at module install time)

I think it would be best to move most or all of the controls
under /proc/fs/cifs to module parms. It really doesn't make much sense
to users for us to present these controls in different places. Module
parms have distinct advantages over files in /proc/fs/cifs so that
seems like the best place for them.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
