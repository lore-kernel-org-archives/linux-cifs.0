From: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: CIFS  kernel module bug
Date: Fri, 30 Sep 2011 22:30:47 +0100
Message-ID: <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk> <20110930140409.51c1a94c@tlielax.poochiereds.net>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110930140409.51c1a94c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On 30 Sep 2011, at 19:04, Jeff Layton wrote:
> On Fri, 30 Sep 2011 14:58:58 +0100 Anton Altaparmakov <aia21-KWPb1pKIrII@public.gmane.org=
k> wrote:
>=20
>> Hi,
>>=20
>> Looking at the current kernel (in Linus' repository on github) there=
 is a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_llse=
ek() there is this bit of code:
>>=20
>> 	/*
>> 	 * origin =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D> we must re=
validate
>> 	 * the cached file length
>> 	 */
>> 	if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {
>>=20
>> The logical or should be a logical and, i.e. this should be:
>>=20
>> 	if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR) {
>>=20
>> As the code is at present that line is ALWAYS true because origin is=
 ALWAYS either !=3D SEEK_SET or !=3D SEEK_CUR as if it equals one it ca=
nnot equal the other and vice versa=85
>>=20
>> So at the moment it always does the revalidation instead of only for=
 SEEK_END, SEEK_DATA, and SEEK_HOLE.
>=20
> Haha, good catch. Care to roll up a patch to fix that?


Yes, I am happy to do that.

Also a question for you: I am up to the neck in having to adapt the CIF=
S module as it doesn't work very well against the Novell Open Enterpris=
e Server CIFS server (that is why I was looking at the CIFS code and no=
ticed this logic bug in the first place).

A bit of background: the home directories for our (i.e. University of C=
ambridge Computing Service) Linux distribution "MCS Linux" which runs o=
n about a thousand workstations and a handfull of remote access servers=
 used to be on Netware and were moved to OES Linux recently and the ncp=
fs kernel module really fell over in a heap when running against the OE=
S NCP server so we had to switch to CIFS in a hurry and whilst it does =
not fall over in a heap like ncpfs does and we now have working reconne=
cts when the home directory server is rebooted (home directories magica=
lly start working again after the reboot which is brilliant!) many appl=
ications do not work.

I can only assume this is because the CIFS server is an abomination rat=
her than that the CIFS modules is quite that badly broken=85  Anyway, m=
y question is: do you want patches that make the CIFS module work bette=
r with OES CIFS server or do you not care?

=46or example lots of applications require working hard links so I had =
to port our Virtual Hard Link implementation from NCPfs to CIFS to get =
hard links working which fixed a lot of applications but then we starte=
d hitting real bugs.  A few examples:

- llseek(SEEK_END) fails against the OES server with error -EBADF from =
the server because the SEEK_END causes file revalidation which ends up =
calling CIFSSMBQFileInfo() which then results in the -EBADF.  I wrote a=
 patch to fall back to path based query via CIFSSMBQPathInfo() and if t=
hat fails via SMBQueryInformation() and now the llseek(SEEK_END) works =
thus applications like Seamonkey actually manage to launch rather than =
segfaulting.

- mkdir() returns -EACCES when the target exists.  Again this is coming=
 from the OES server.  I wrote a patch that calls cifs_get_inode_info()=
 when CIFSSMBMkDir() returns -EACCES and unix extensions are not enable=
d on the superblock and if the result is success I rewrite the return c=
ode to -EEXIST which fixes the mkdir issue and that fixes loads of Gnom=
e related applications.

- The OES server behaves like NT4 in that it returns success from CIFSS=
MBSetPathInfo() but it actually ignores the call unless the file is ope=
n on the server.  But the OES server does not have CIFS_SES_NT4 in the =
session flags thus the work around in the CIFS module does not trigger =
and thus changing the access times or permissions does not work unless =
the file happens to be open which breaks applications like rsync.  I co=
mmented the CIFSSMBSetPathInfo() call completely in a patch so it falls=
 back to the other code which makes it work for us.

And finally the actual question: Are you interested in any of these pat=
ches or at least are you interested in fixing these issues in the stand=
ard CIFS module in which case I can send you my patches or at least giv=
e you detailed descriptions of what is failing and how?

Best regards,

	Anton
--=20
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
