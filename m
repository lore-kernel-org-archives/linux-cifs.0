From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS  kernel module bug
Date: Mon, 3 Oct 2011 07:17:36 -0400
Message-ID: <20111003071736.42ceec02@tlielax.poochiereds.net>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
	<20110930140409.51c1a94c@tlielax.poochiereds.net>
	<E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E35BF115-B84D-4DB2-BDDC-E356052282F2-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 30 Sep 2011 22:30:47 +0100
Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org> wrote:

> Hi,
>=20
> On 30 Sep 2011, at 19:04, Jeff Layton wrote:
> > On Fri, 30 Sep 2011 14:58:58 +0100 Anton Altaparmakov <aia21-LQ8pvt1md3o@public.gmane.org=
=2Euk> wrote:
> >=20
> >> Hi,
> >>=20
> >> Looking at the current kernel (in Linus' repository on github) the=
re is a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_ll=
seek() there is this bit of code:
> >>=20
> >> 	/*
> >> 	 * origin =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D> we must =
revalidate
> >> 	 * the cached file length
> >> 	 */
> >> 	if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {
> >>=20
> >> The logical or should be a logical and, i.e. this should be:
> >>=20
> >> 	if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR) {
> >>=20
> >> As the code is at present that line is ALWAYS true because origin =
is ALWAYS either !=3D SEEK_SET or !=3D SEEK_CUR as if it equals one it =
cannot equal the other and vice versa=E2=80=A6
> >>=20
> >> So at the moment it always does the revalidation instead of only f=
or SEEK_END, SEEK_DATA, and SEEK_HOLE.
> >=20
> > Haha, good catch. Care to roll up a patch to fix that?
>=20
>=20
> Yes, I am happy to do that.
>=20
> Also a question for you: I am up to the neck in having to adapt the C=
IFS module as it doesn't work very well against the Novell Open Enterpr=
ise Server CIFS server (that is why I was looking at the CIFS code and =
noticed this logic bug in the first place).
>=20
> A bit of background: the home directories for our (i.e. University of=
 Cambridge Computing Service) Linux distribution "MCS Linux" which runs=
 on about a thousand workstations and a handfull of remote access serve=
rs used to be on Netware and were moved to OES Linux recently and the n=
cpfs kernel module really fell over in a heap when running against the =
OES NCP server so we had to switch to CIFS in a hurry and whilst it doe=
s not fall over in a heap like ncpfs does and we now have working recon=
nects when the home directory server is rebooted (home directories magi=
cally start working again after the reboot which is brilliant!) many ap=
plications do not work.
>=20
> I can only assume this is because the CIFS server is an abomination r=
ather than that the CIFS modules is quite that badly broken=E2=80=A6  A=
nyway, my question is: do you want patches that make the CIFS module wo=
rk better with OES CIFS server or do you not care?
>=20
> For example lots of applications require working hard links so I had =
to port our Virtual Hard Link implementation from NCPfs to CIFS to get =
hard links working which fixed a lot of applications but then we starte=
d hitting real bugs.  A few examples:
>=20
> - llseek(SEEK_END) fails against the OES server with error -EBADF fro=
m the server because the SEEK_END causes file revalidation which ends u=
p calling CIFSSMBQFileInfo() which then results in the -EBADF.  I wrote=
 a patch to fall back to path based query via CIFSSMBQPathInfo() and if=
 that fails via SMBQueryInformation() and now the llseek(SEEK_END) work=
s thus applications like Seamonkey actually manage to launch rather tha=
n segfaulting.
>=20

Yeah, that sounds like a server bug, but maybe it's not expected to
support QUERY_FILE_INFO calls for some reason? Some network traces
might help clarify the issue here.

> - mkdir() returns -EACCES when the target exists.  Again this is comi=
ng from the OES server.  I wrote a patch that calls cifs_get_inode_info=
() when CIFSSMBMkDir() returns -EACCES and unix extensions are not enab=
led on the superblock and if the result is success I rewrite the return=
 code to -EEXIST which fixes the mkdir issue and that fixes loads of Gn=
ome related applications.
>=20

Probably this is a bad mapping of this error in cifs.ko. Again, a
network trace might be helpful.

> - The OES server behaves like NT4 in that it returns success from CIF=
SSMBSetPathInfo() but it actually ignores the call unless the file is o=
pen on the server.  But the OES server does not have CIFS_SES_NT4 in th=
e session flags thus the work around in the CIFS module does not trigge=
r and thus changing the access times or permissions does not work unles=
s the file happens to be open which breaks applications like rsync.  I =
commented the CIFSSMBSetPathInfo() call completely in a patch so it fal=
ls back to the other code which makes it work for us.
>=20

We probably can't take this patch as-is, but it's possible you could
try to enable this workaround via some other mechanism too.

> And finally the actual question: Are you interested in any of these p=
atches or at least are you interested in fixing these issues in the sta=
ndard CIFS module in which case I can send you my patches or at least g=
ive you detailed descriptions of what is failing and how?
>=20


Yes, it wouldn't hurt to send them to the list so we can debate them.
We certainly are not opposed to adding reasonable workarounds for
problem servers.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
