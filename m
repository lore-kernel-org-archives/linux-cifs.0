From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: eliminate CONFIG_CIFS_WEAK_PW_HASH
Date: Fri, 27 Apr 2012 11:14:51 -0400
Message-ID: <20120427111451.3f7eda84@corrin.poochiereds.net>
References: <1327091153-22391-1-git-send-email-jlayton@redhat.com>
	<CAH2r5msOk=4rz_XUGi+GitzVGyJrSo9B1iGXdjz0Bnymzt0NyQ@mail.gmail.com>
	<20120120153856.6ded308a@tlielax.poochiereds.net>
	<CAH2r5ms6YbZp+erat9RQw7-vMxem6vLWp72Yaf=Z8d4p=4+BBQ@mail.gmail.com>
	<1327118615.7985.5.camel@ruth>
	<20120121073720.3cf546fc@tlielax.poochiereds.net>
	<1327166803.2908.761.camel@pico.li.ssimo.org>
	<20120427071548.4843f5cb@corrin.poochiereds.net>
	<CAH2r5msLTZeYQQRN=YdBBOSXu=FRphP0L_3XuofmtDi80e+hQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, simo <idra@samba.org>,
	samba-technical <samba-technical@lists.samba.org>,
	Andrew Bartlett <abartlet@samba.org>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5msLTZeYQQRN=YdBBOSXu=FRphP0L_3XuofmtDi80e+hQQ@mail.gmail.com>
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

On Fri, 27 Apr 2012 08:58:55 -0500
Steve French <smfrench@gmail.com> wrote:

> On Fri, Apr 27, 2012 at 6:15 AM, Jeff Layton <jlayton@redhat.com> wrote:
> > On Sat, 21 Jan 2012 12:26:43 -0500
> > simo <idra@samba.org> wrote:
> >
> >> On Sat, 2012-01-21 at 07:37 -0500, Jeff Layton wrote:
> >> > On Sat, 21 Jan 2012 15:03:31 +1100
> >> > Andrew Bartlett <abartlet@samba.org> wrote:
> >> >
> >> > > On Fri, 2012-01-20 at 14:45 -0600, Steve French wrote:
> >> > > > My general thinking on this is as follows:
> >> > > >
> >> > > > If the kernel is distributed to all the workstations in an organ=
ization
> >> > > > with this Kconfig option disabled, it makes it harder for indivi=
dual users
> >> > > > to make the mistake of enabling lanman (sec=3Dlanman, or the Kco=
nfig
> >> > > > option) on a public network and thus send weak password hashes
> >> > > > which could be discovered simply. =C2=A0 Most distros make the c=
hoice
> >> > > > of enabling broader compatibility with old pre-1997 servers but
> >> > > > it is a very small set of servers who would require lanman suppo=
rt,
> >> > > > and a large number of potential attackers who could benefit if
> >> > > > users enable lanman on a public network. =C2=A0I suspect that th=
ere
> >> > > > are environments where removing code (via Kconfig) is preferred
> >> > > > to trusting all owners of all workstations running that organiza=
tions
> >> > > > standard linux to never enable lanman at runtime.
> >> > > >
> >> > > > But ... the opinion of security specialists on this would be wel=
come.
> >> > >
> >> > > We have been though some of this with the kerberos libs, which now=
 allow
> >> > > (default?) to not even compile with weak crypto. =C2=A0If the weak=
 crypto is
> >> > > not compiled in, it can therefore be asserted that the weak crypto
> >> > > cannot be used, and this makes it easier to comply with security
> >> > > audits/certification etc.
> >> > >
> >> > > I don't want to make your code more complex than it needs to be, b=
ut LM
> >> > > encryption really, really needs to go away. =C2=A0If it is not a m=
ajor
> >> > > bother, I would like to make it easier for that to happen if possi=
ble.
> >> > >
> >> >
> >> > The only way for it to go away completely is for all servers that
> >> > support only that encryption to go away completely. Unfortunately,
> >> > that's a tall order -- there are still at least some in the field and
> >> > people need to get at data on them.
> >>
> >> Jeff, can you identify them ?
> >>
> >> LM only servers means pre Win 95 machines, I'd be curious to know what
> >> servers are there that really support only LM hashes and not NT hashes.
> >>
> >
> > Sorry for the long delay in responding here. Yes, mostly pre-win95
> > machines. We occasionally get reports from people using OS/2 and I'm
> > pretty sure it's LM-only.
> >
> > Steve, in any case...shall I consider this patch NAK'ed for now? I was
> > carrying it in my tree for 3.5, but it seems like there's resistance to
> > removing this option and I'm not particularly religious on the matter.
>=20
> I don't think it is worth changing - I prefer to build with
> WEAK_PS_HASH disabled.
>=20

Alrighty then, dropped...

--=20
Jeff Layton <jlayton@redhat.com>
