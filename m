From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Map missing in cifs-mount, but available in smbclient
Date: Fri, 10 Jun 2011 09:29:12 -0500
Message-ID: <BANLkTikey8w7Yf_A7hnRdXtN-p34N2U8AA@mail.gmail.com>
References: <loom.20110610T133205-66@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Koen Vermeer <koen-6aKAu+ryoJO2z7vLlVgmTQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110610T133205-66-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Any chance of a wireshark trace so we can see what the server returned?

http://wiki.samba.org/index.php/Capture_Packets

In addition turning on debugging before the problem, reproducing the
problem, saving the dmesg log (see
http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting for
instructions) would allow us to see if there are any errors.

Also would help to know the kernel version.



On Fri, Jun 10, 2011 at 6:39 AM, Koen Vermeer <koen-6aKAu+ryoJO2z7vLlVgmTQ@public.gmane.org> wrote:
> Hi,
>
> I have mounted a share on a Windows-server with a corresponding entry=
 in
> /etc/fstab of:
>
> //san02-a/Data$ /mnt/san02-a/data =A0 =A0 =A0 cifs
> domain=3DMYDOMAIN,user=3DMYUSER,password=3DMYPASSWD,uid=3DMYUID,gid=3D=
MYGID,_netdev
> 0 =A0 =A0 =A0 0
>
> This works reasonably well, except that I'm missing a folder. If I ru=
n 'ls
> /mnt/san02-a/data/Afdeling/ROI/', I get two entries (PRIVATE and PUBL=
IC), but
> one (STUDIES) is missing.
>
> Now, if I run
>
> smbclient -U MYNAME -W MYDOMAIN //san02-a/Data$
>
> and then do 'ls Afdeling\ROI\*', I do get all three directories. Chan=
ging to the
> STUDIES directory also works fine.
>
> Can anyone give me a hint on how to fix this or how to find out what'=
s going on?
>
> Best,
> Koen
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
