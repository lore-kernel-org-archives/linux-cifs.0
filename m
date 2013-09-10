From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: determine if junction for cifs mount of windows on linux?
Date: Tue, 10 Sep 2013 09:40:45 -0700
Message-ID: <CACyXjPzfGYVUpYFap1JOFRhUOG87SMaj=K2sPNWYVMAOO=ksGA@mail.gmail.com>
References: <20130910151535.GA16425@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Matt Garman <matthew.garman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130910151535.GA16425-I16TT/x9nZNuS50hRUqoq4PSFcUTe7XXtbKGnGEFZQw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 10, 2013 at 8:15 AM, Matt Garman <matthew.garman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>
> On Linux, I'm doing a CIFS mount of an entire Windows 7 hard drive
> (aka C$).  My intent is to take regular whole-disk snapshot backups
> of the drive using rsync.
>
> For any "junction" on the Windows drive, I get permission denied on
> the Linux CIFS mount side.  But using "ls", these junctions just
> look like regular directories.  Is there any way to identify them as
> junctions, so that I can exclude them from my rsync backup?  Or even
> better, is there some way to have them not show up at all on the
> CIFS mount?
>
> A good example of this is "C:\Documents and Settings".  This is a
> junction that maps to "C:\Users" on Windows 7.  I get permission
> denied if I try to ls Documends and Settings, but I can ls Users
> without any issue.

So, here's the deal. Changes are likely need to the cifsfs ...

Windows implements junction points, sym links, DFS referrals, etc, as
reparse points.

There are three FIND FIRST/FIND NEXT/FIND info levels that can return
info about them, and when they do, if you are dealing with a reparse
point it returns a bit set in the attributes saying this is a reparse
point and returns the reparse tag in the EA Length field. (I am told
that this last bit is not documented, but I have not verified that
claim myself.)

Thus the CIFS FS can figure out it is dealing with a reparse point and
from the tag what type, and can then open the reparse point if it is
of the right type (there are flags that allow you to follow reparse
points at the server (I believe) or retrieve them or something (over
and above the GET DFS REFERRAL stuff, which does not apply here.)

At the very least, the cifsfs could be configured to not show objects
that are reparse points or something.

> Here's my /etc/fstab entry:
>
> //192.168.185.24/C$ /mnt/windows/matt   cifs //noperm,ro,ignorecase,c=
redentials=3D/root/smb_auth.txt 0 0
>
> Contents of /root/smb_auth.txt:
> # cat /root/smb_auth.txt
> username=3DWindowsUsername
> password=3DWindowsPassword
> domain=3DWindowsDomain
>
> Running the mount command:
>
> # mount -v matt
> domain=3DWindowsDomain
> mount.cifs kernel mount options:
> ip=3D192.168.185.24,unc=3D\\192.168.185.24\C$,noperm,ignorecase,crede=
ntials=3D/root/smb_auth.txt,ver=3D1,user=3DWindowsUsername,domain=3DWin=
dowsDomain,pass=3D********
>
> Contents of /proc/mounts after being mounted:
>
> # cat /proc/mounts | grep matt
> //192.168.185.24/C$/ /mnt/windows/matt cifs ro,relatime,sec=3Dntlm,un=
c=3D\\192.168.185.24\C$,username=3DWindowsUser,domain=3DWindowsDomain,u=
id=3D0,noforceuid,gid=3D0,noforcegid,addr=3D192.168.185.24,file_mode=3D=
0755,dir_mode=3D0755,nocase,serverino,noperm,rsize=3D16384,wsize=3D6553=
6 0 0
>
> Thanks,
> Matt
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
