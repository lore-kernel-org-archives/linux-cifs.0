From: Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Thu, 9 Jun 2016 21:27:34 +0200
Message-ID: <5759C326.5040508@fu-berlin.de>
References: <20160527194346.08416d79@aaptelpc>
 <20160609185027.7349f260@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609185027.7349f260@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hey Aur=C3=A9lien,
with your script I can reproduce the bug locally now.

I can mount the share (which is on a Windows 8.1 vm) with a Windows 7 P=
C
with the restricted user account. (Even in hard mode.)
I can mount the share from Linux-cifs using the admin user but not the
restricted user.

(I noticed though that no user has access to the file in the shared dir=
=2E
But this doesn't really matter for the test.)

Marcus

On 06/09/2016 06:50 PM, Aur=C3=A9lien Aptel wrote:
> Small update: I've written a powershell script to reproduce the probl=
em
> (attached). If you're wondering I'm not using samba see my notes
> about it [1].
>
> On the window server:
> - Edit $Dir (script will create parent dirs)
> - Edit $LimitedUser/$AdminUser to an existing one
> - Run the script as admin
>
> On the linux client:
> - Mount the share sub dir with the limited user credentials:
>   mount //lutze/bug8950/sub/dir' /mnt \
>         -o 'domain=3DLURCH,ip=3D10.160.5.42,username=3Dbill,password=3D=
*****,rw'
>
> My second solution fails for the case when the dir *containing* the
> shared dir restricts the limited user. See "HARD MODE" at the end
> of the script.
>
> 1: http://diobla.info/stuff/bugs/bsc799133/#sec-4
>
