From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] Samba 3.5 & CIFS mounts - long standing issue...
Date: Fri, 3 Feb 2012 08:44:15 -0600
Message-ID: <CADT32eJPbBo8m0k-L-eZaKgcfOa2jibd6ggz82OC47MEJ82T0Q@mail.gmail.com>
References: <4F2BCF5E.8090109@srce.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jakov Sosic <jakov.sosic-+qQlAQxGOKU@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F2BCF5E.8090109-+qQlAQxGOKU@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Feb 3, 2012 at 6:13 AM, Jakov Sosic <jakov.sosic-+qQlAQxGOKU@public.gmane.org> wrote=
:
> Hi.
>
> I can see that this is a long long standing issue... Apparently thing=
s
> changed in Windows 2008 R2, and after upgrade of domain from R1 to R2=
 cifs
> mounts don't work anymore between Linux servers. Windows can see Samb=
a
> shares and mount them, but CIFS on another Linux box cannot...
>
> Here is a thread with explanation in lenght:
> http://ubuntuforums.org/showthread.php?t=3D1178484
>
> I get the exact same logs and errors... I've tested with smbclient an=
d
> everything works but with CIFS - no way :(
>
> Has anybody succeded in solving this one?
>
>
> Mount with CIFS:
> # =A0mount -t cifs //server/share /mnt -o
> username=3Djakov.sosic,password=3D*******,domain=3Dmydomain -v
>
> mount.cifs kernel mount options:
> unc=3D//server\share,ver=3D1,username=3Djakov.sosic,domain=3Dmydomain=
,ip=3Dxxx.xxx.xxx.xxx,pass=3D********
> mount error(13): Permission denied
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
>
> Login with smbclient:
>
> # smbclient -U jakov.sosic //server/share
> Enter Administrator's password:
> Domain=3D[MYDOMAIN] OS=3D[Unix] Server=3D[Samba 3.5.4-0.83.el5_7.2]
> smb: \>
>
>
> I've tried adding various mount parameters like sec=3Dntlmv2,
> credentials=3D/path/to/file, but every attempt fails.
>
> Any ideas?!?!!
>
>
> Samba is version 3.5.4 on CentOS 5.7 on both Linux machines.
>
>
> --
> Jakov Sosic
> www.srce.unizg.hr
> --
> To unsubscribe from this list go to the following URL and read the
> instructions: =A0https://lists.samba.org/mailman/options/samba

What is the version of cifs module? (modinfo cifs will tell).
