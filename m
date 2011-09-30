From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS kernel module bug
Date: Fri, 30 Sep 2011 17:20:27 -0500
Message-ID: <CAH2r5ms7Pr41haHJrnFoJLJMQMqP+pGm4ryuicbKch4y2-OV4w@mail.gmail.com>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
	<20110930140409.51c1a94c@tlielax.poochiereds.net>
	<E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E35BF115-B84D-4DB2-BDDC-E356052282F2-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 30, 2011 at 4:30 PM, Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org> w=
rote:
> Hi,
>
> On 30 Sep 2011, at 19:04, Jeff Layton wrote:
>> On Fri, 30 Sep 2011 14:58:58 +0100 Anton Altaparmakov <aia21-ZqumhiR2WNE@public.gmane.org=
uk> wrote:
>>
>>> Hi,
>>>
>>> Looking at the current kernel (in Linus' repository on github) ther=
e is a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_lls=
eek() there is this bit of code:
>>>
>>> =A0 =A0 =A0/*
>>> =A0 =A0 =A0 * origin =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D>=
 we must revalidate
>>> =A0 =A0 =A0 * the cached file length
>>> =A0 =A0 =A0 */
>>> =A0 =A0 =A0if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {
>>>
>>> The logical or should be a logical and, i.e. this should be:
>>>
>>> =A0 =A0 =A0if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR) {
>>>
>>> As the code is at present that line is ALWAYS true because origin i=
s ALWAYS either !=3D SEEK_SET or !=3D SEEK_CUR as if it equals one it c=
annot equal the other and vice versa=85
>>>
>>> So at the moment it always does the revalidation instead of only fo=
r SEEK_END, SEEK_DATA, and SEEK_HOLE.
>>
>> Haha, good catch. Care to roll up a patch to fix that?
>
>
> Yes, I am happy to do that.
>
> Also a question for you: I am up to the neck in having to adapt the C=
IFS module as it doesn't work very well against the Novell Open Enterpr=
ise Server CIFS server (that is why I was looking at the CIFS code and =
noticed this logic bug in the first place).
>
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
>
> I can only assume this is because the CIFS server is an abomination r=
ather than that the CIFS modules is quite that badly broken=85 =A0Anywa=
y, my question is: do you want patches that make the CIFS module work b=
etter with OES CIFS server or do you not care?
>
> For example lots of applications require working hard links so I had =
to port our Virtual Hard Link implementation from NCPfs to CIFS to get =
hard links working which fixed a lot of applications but then we starte=
d hitting real bugs. =A0A few examples:
>
> - llseek(SEEK_END) fails against the OES server with error -EBADF fro=
m the server because the SEEK_END causes file revalidation which ends u=
p calling CIFSSMBQFileInfo() which then results in the -EBADF. =A0I wro=
te a patch to fall back to path based query via CIFSSMBQPathInfo() and =
if that fails via SMBQueryInformation() and now the llseek(SEEK_END) wo=
rks thus applications like Seamonkey actually manage to launch rather t=
han segfaulting.
>
> - mkdir() returns -EACCES when the target exists. =A0Again this is co=
ming from the OES server. =A0I wrote a patch that calls cifs_get_inode_=
info() when CIFSSMBMkDir() returns -EACCES and unix extensions are not =
enabled on the superblock and if the result is success I rewrite the re=
turn code to -EEXIST which fixes the mkdir issue and that fixes loads o=
f Gnome related applications.
>
> - The OES server behaves like NT4 in that it returns success from CIF=
SSMBSetPathInfo() but it actually ignores the call unless the file is o=
pen on the server. =A0But the OES server does not have CIFS_SES_NT4 in =
the session flags thus the work around in the CIFS module does not trig=
ger and thus changing the access times or permissions does not work unl=
ess the file happens to be open which breaks applications like rsync. =A0=
I commented the CIFSSMBSetPathInfo() call completely in a patch so it f=
alls back to the other code which makes it work for us.
>
> And finally the actual question: Are you interested in any of these p=
atches or at least are you interested in fixing these issues in the sta=
ndard CIFS module in which case I can send you my patches or at least g=
ive you detailed descriptions of what is failing and how?

Yes - we are strongly interested in making sure that the cifs module
is stable (always) against all servers (this is much harder than it
sounds) and works well against the major servers.   We travel to the
two major test events each year testing against the major servers (and
NAS).   For less functional servers, we are always interested in
stability fixes and as long as they are not too invasive, will
consider some workaround fixes to deal with server bugs if the patches
aren't high risk.

--=20
Thanks,

Steve
