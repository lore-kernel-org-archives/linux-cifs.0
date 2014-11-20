From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unexpected folder mode when unix extensions are enabled
Date: Thu, 20 Nov 2014 11:12:31 -0600
Message-ID: <CAH2r5msgF-M7mUKqhRp1yPLAKwpNJkk+Y0BV7Oy3KocnHw3Bxw@mail.gmail.com>
References: <546E1A8F.3060104@naturescapelawncare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Kerrigan Joseph <kerrigan-unDuD2xQE4RCRbd0KW1xqSWTkRzJkiQl@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546E1A8F.3060104-unDuD2xQE4RCRbd0KW1xqSWTkRzJkiQl@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The handling of the three "special" mode bits ("sticky bit" and setuid
and setgid) can be confusing (the 07000 bits from the 07777 that you
are setting).   See e.g.
http://www.techrepublic.com/blog/it-security/understand-the-setuid-and-=
setgid-permissions-to-improve-security/
 I wouldn't be surprised if the top 3 bits (sticky/setuid/setgid) are
masked off by Samba - but I don't remember what old versions of Samba
do.

Also remember to check what bits are masked off locally on your client
(type "umask" on your client to see) - the mode may be getting to the
server as 0775 not 0777

In any case, I wouldn't be concerned that the sticky and setuid and
setgid bits are masked off - do you really need them on your client?
You can mount with "noperm" to make sure all enforcement is (only) at
the server instead of on both client and server - if they really get
in the way of something.


On Thu, Nov 20, 2014 at 10:45 AM, Kerrigan Joseph
<kerrigan-unDuD2xQE4RCRbd0KW1xqSWTkRzJkiQl@public.gmane.org> wrote:
> Hello, first time on this mailing list, so any etiquette tips are
> appreciated!
>
> I'm using Samba 3 on a file server at work, and I've noticed some app=
arent
> quirks in permissions handling for Linux clients. I've tried to isola=
te the
> issues to a small set of variables, and I'll describe this limited ca=
se
> below.
>
> To summarize, when I use mount.cifs to access a share with
> 1. unix extensions enabled on the server, and
> 2. Samba mask/mode settings that should affect the first
> (setuid/setgid/sticky)
> octal bit,
> the mask/mode settings for the first octal bit are ignored for folder=
s, but
> preserved for files.
>
> In other words, if my Samba share has all of the *mask and *mode opti=
ons set
> to 7777, and I mount that share with unix extensions enabled, files t=
hat I
> create will be give a mode of 7777, but folders will be given a mode =
of
> 1777.
> This behavior is not present when I mount the share with the unix ext=
ensions
> disabled, or when I access the share using smbclient.
>
> I would much prefer to operate with the unix extensions enabled, as i=
t
> allows
> the client to accurately reflect the permissions present on the serve=
r, but
> I
> can't for the life of me figure out how to make the client obey the s=
erver's
> mode/mask directives!
>
> It should go without saying, but I'm not actually trying to use these
> particular modes in production. I ran into this issue when trying to =
enforce
> more sane permissions, but my example that follows uses these modes t=
o
> illustrate the issue I'm experiencing.
>
> Below you will find a (fairly) detailed example that I ran to illustr=
ate
> this
> problem. I'm sorry it is so long, but I wanted to give as much detail=
 in
> this
> first message as possible.
>
> Thanks!
>
> Kerrigan Joseph
>
>
> # where are we? #
>
> ## server ##
> $ whoami
> jt
>
> $ hostname
> ws073
>
> $ uname -a
> Linux ws073 3.11.0-12-generic #19-Ubuntu SMP Wed Oct 9 16:20:46 UTC 2=
013
> x86_64 x86_64 x86_64 GNU/Linux
>
> $ lsb_release -a
> No LSB modules are available.
> Distributor ID: LinuxMint
> Description: Linux Mint 16 Petra
> Release: 16
> Codename: petra
>
> $ smbd --version
> Version 3.6.18
>
> $ cat /etc/samba/smb.conf
> [global]
> workgroup =3D WORKGROUP
> server string =3D %h server (Samba, Linux Mint)
> dns proxy =3D no
> log file =3D /var/log/samba/log.%m
> max log size =3D 1000
> syslog =3D 0
> panic action =3D /usr/share/samba/panic-action %d
> encrypt passwords =3D true
> passdb backend =3D tdbsam
> obey pam restrictions =3D yes
> unix password sync =3D yes
> passwd program =3D /usr/bin/passwd %u
> passwd chat =3D *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spass=
word:*
> %n\n *password\supdated\ssuccessfully* .
> pam password change =3D yes
> map to guest =3D bad user
> usershare allow guests =3D yes
> unix extensions =3D yes
>
> [test]
> comment =3D Test Share
> path =3D /home/jt/mnt/sambatest
> valid users =3D @jt
> public =3D no
> writable =3D yes
> browseable =3D no
> create mask =3D 7777
> force create mode =3D 7777
> security mask =3D 7777
> force security mode =3D 7777
> directory mask =3D 7777
> force directory mode =3D 7777
> directory security mask =3D 7777
> force directory security mode =3D 7777
>
> $ cd ~/mnt/sambatest && pwd
> /home/jt/mnt/sambatest
>
> $ stat .
> File: =E2=80=98.=E2=80=99
> Size: 4096 Blocks: 8 IO Block: 4096 directory
> Device: 801h/2049d Inode: 5245516 Links: 2
> Access: (0777/drwxrwxrwx) Uid: ( 1000/ jt) Gid: ( 1000/ jt)
> Access: 2014-11-20 09:37:24.018014130 -0600
> Modify: 2014-11-20 09:37:23.458014110 -0600
> Change: 2014-11-20 09:37:23.458014110 -0600
> Birth: -
>
> $ sudo service smbd restart
> smbd stop/waiting
> smbd start/running, process 26535
>
>
> ## client ##
> $ whoami
> kerrigan
>
> $ hostname
> ws093
>
> $ uname -a
> Linux ws093 3.11.0-12-generic #19-Ubuntu SMP Wed Oct 9 16:20:46 UTC 2=
013
> x86_64 x86_64 x86_64 GNU/Linux
>
> $ lsb_release -a
> No LSB modules are available.
> Distributor ID: LinuxMint
> Description: Linux Mint 16 Petra
> Release: 16
> Codename: petra
>
> $ mount.cifs --version
> mount.cifs version: 6.0
>
> $ smbclient --version
> Version 3.6.18
>
> $ cd ~/sambatest && pwd
> /home/kerrigan/sambatest
>
> $ stat .
> File: =E2=80=98.=E2=80=99
> Size: 4096 Blocks: 8 IO Block: 4096 directory
> Device: 801h/2049d Inode: 923915 Links: 2
> Access: (0755/drwxr-xr-x) Uid: ( 1000/kerrigan) Gid: ( 1000/kerrigan)
> Access: 2014-11-20 09:48:51.449875086 -0600
> Modify: 2014-11-20 09:48:51.449875086 -0600
> Change: 2014-11-20 09:48:51.449875086 -0600
> Birth: -
>
>
> # mount it on the client with the default of unix extensions enabled =
#
> $ cd ..
> $ sudo mount.cifs -o user=3Djt,uid=3Dkerrigan,gid=3Dkerrigan //ws073/=
test
> sambatest
> Password for jt@//ws073/test: <entered password>
> $ cd sambatest
>
> $ mount | grep ws073
> //ws073/test on /home/kerrigan/sambatest type cifs (rw)
>
> $ touch file1 && mkdir folder1 && ls -l
>
> $ stat file1 | grep Uid
> Access: (7777/-rwsrwsrwt) Uid: ( 1000/kerrigan) Gid: ( 1000/kerrigan)
>
> $ stat folder1 | grep Uid # look at octal mode!
> Access: (1777/drwxrwxrwt) Uid: ( 1000/kerrigan) Gid: ( 1000/kerrigan)
>
>
> # look at the files on the server #
> $ pwd
> /home/jt/mnt/sambatest
>
> $ ls -l
> total 4
> -rwsrwsrwt 1 jt jt 0 Nov 20 09:59 file1
> drwxrwxrwt 2 jt jt 4096 Nov 20 09:58 folder1
>
> $ stat file1 | grep Uid
> Access: (7777/-rwsrwsrwt) Uid: ( 1000/ jt) Gid: ( 1000/ jt)
>
> $ stat folder1 | grep Uid # look at the octal mode
> Access: (1777/drwxrwxrwt) Uid: ( 1000/ jt) Gid: ( 1000/ jt)
>
>
> # mount on the client with nounix disabling unix extensions #
> $ cd ..
> $ sudo umount sambatest
> $ sudo mount.cifs -o user=3Djt,uid=3Dkerrigan,gid=3Dkerrigan,nounix /=
/ws073/test
> sambatest
> Password for jt@//ws073/test: <entered password>
> $ cd sambatest
>
> $ ls -l
> total 0
> -rwxr-xr-x 0 kerrigan kerrigan 0 Nov 20 09:59 file1
> drwxr-xr-x 0 kerrigan kerrigan 0 Nov 20 09:58 folder1
>
> $ touch file2 && mkdir folder2 && ls -l
> total 0
> -rwxr-xr-x 0 kerrigan kerrigan 0 Nov 20 09:59 file1
> -rwxr-xr-x 0 kerrigan kerrigan 0 Nov 20 10:06 file2
> drwxr-xr-x 0 kerrigan kerrigan 0 Nov 20 09:58 folder1
> drwxr-xr-x 0 kerrigan kerrigan 0 Nov 20 10:05 folder2
>
>
> # look at files on the server #
> $ stat file2 | grep Uid
> Access: (7777/-rwsrwsrwt) Uid: ( 1000/ jt) Gid: ( 1000/ jt)
>
> $ stat folder2 | grep Uid # look at the octal mode now
> Access: (7777/drwsrwsrwt) Uid: ( 1000/ jt) Gid: ( 1000/ jt)
>
>
> # make a directory on the client using smbclient #
> $ cd .. && sudo umount sambatest
>
> $ smbclient //ws073/test --user=3Djt
> Enter jt's password: <entered password>
> Domain=3D[WORKGROUP] OS=3D[Unix] Server=3D[Samba 3.6.18]
> smb: \> mkdir folder3
> smb: \> exit
>
>
> # on the server #
> $ stat folder3 | grep Uid # same octal mode as with nounix
> Access: (7777/drwsrwsrwt) Uid: ( 1000/ jt) Gid: ( 1000/ jt)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
