From: Jeremy Allison <jra@samba.org>
Subject: Re: CIFS  kernel module bug
Date: Fri, 30 Sep 2011 16:47:11 -0700
Message-ID: <20110930234711.GD14147@samba2>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
	<20110930140409.51c1a94c@tlielax.poochiereds.net>
	<E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	LKML <linux-kernel@vger.kernel.org>, PWF Linux <pwf-linux@ucs.cam.ac.uk>,
	Steve French <sfrench@samba.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
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

On Fri, Sep 30, 2011 at 10:30:47PM +0100, Anton Altaparmakov wrote:
>=20
> Yes, I am happy to do that.
>=20
> Also a question for you: I am up to the neck in having to adapt the CIF=
S module as it doesn't work very well against the Novell Open Enterprise =
Server CIFS server (that is why I was looking at the CIFS code and notice=
d this logic bug in the first place).
>=20
> A bit of background: the home directories for our (i.e. University of C=
ambridge Computing Service) Linux distribution "MCS Linux" which runs on =
about a thousand workstations and a handfull of remote access servers use=
d to be on Netware and were moved to OES Linux recently and the ncpfs ker=
nel module really fell over in a heap when running against the OES NCP se=
rver so we had to switch to CIFS in a hurry and whilst it does not fall o=
ver in a heap like ncpfs does and we now have working reconnects when the=
 home directory server is rebooted (home directories magically start work=
ing again after the reboot which is brilliant!) many applications do not =
work.
>=20
> I can only assume this is because the CIFS server is an abomination rat=
her than that the CIFS modules is quite that badly broken=E2=80=A6  Anywa=
y, my question is: do you want patches that make the CIFS module work bet=
ter with OES CIFS server or do you not care?
>=20
> For example lots of applications require working hard links so I had to=
 port our Virtual Hard Link implementation from NCPfs to CIFS to get hard=
 links working which fixed a lot of applications but then we started hitt=
ing real bugs.  A few examples:
>=20
> - llseek(SEEK_END) fails against the OES server with error -EBADF from =
the server because the SEEK_END causes file revalidation which ends up ca=
lling CIFSSMBQFileInfo() which then results in the -EBADF.  I wrote a pat=
ch to fall back to path based query via CIFSSMBQPathInfo() and if that fa=
ils via SMBQueryInformation() and now the llseek(SEEK_END) works thus app=
lications like Seamonkey actually manage to launch rather than segfaultin=
g.
>=20
> - mkdir() returns -EACCES when the target exists.  Again this is coming=
 from the OES server.  I wrote a patch that calls cifs_get_inode_info() w=
hen CIFSSMBMkDir() returns -EACCES and unix extensions are not enabled on=
 the superblock and if the result is success I rewrite the return code to=
 -EEXIST which fixes the mkdir issue and that fixes loads of Gnome relate=
d applications.
>=20
> - The OES server behaves like NT4 in that it returns success from CIFSS=
MBSetPathInfo() but it actually ignores the call unless the file is open =
on the server.  But the OES server does not have CIFS_SES_NT4 in the sess=
ion flags thus the work around in the CIFS module does not trigger and th=
us changing the access times or permissions does not work unless the file=
 happens to be open which breaks applications like rsync.  I commented th=
e CIFSSMBSetPathInfo() call completely in a patch so it falls back to the=
 other code which makes it work for us.
>=20
> And finally the actual question: Are you interested in any of these pat=
ches or at least are you interested in fixing these issues in the standar=
d CIFS module in which case I can send you my patches or at least give yo=
u detailed descriptions of what is failing and how?

What server code is the OES CIFS server running ? I thought Novell CIFS
services were all Samba based.

Jeremy.
