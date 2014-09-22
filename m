From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Accented characters not working with CIFS (but ok with smbclient)
Date: Sun, 21 Sep 2014 22:28:47 -0500
Message-ID: <CAH2r5mvHw=D=sjZr6wDoJndjDuzA41rNudRdtn8N=OjY8kUA=A@mail.gmail.com>
References: <541E0369.8070205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541E0369.8070205-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This seems strange because modern Linux distributions should map UCS-2
(16 bit Unicode characters which cifs servers like Windows and Samba
send over the wire) fine to UTF-8 which is the typical default one for
local.

Does you distro not default to UTF-8 on the client?

Would be helpful to see a wire trace (ethereal or tcpdump) and make
sure the server is sending UCS-2 (Unicode) on the wire.  See
https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

On Sat, Sep 20, 2014 at 5:44 PM, adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> Hy,
>
> I'm not sure of what can be relevant so I'll tell the whole story.
>
> I have a router (that I got from my ISP) which allows the connection =
of a
> pen/HDD by USB. That pen is shared on the network as a Windows Share =
folder.
>
> In Windows 7 I can see all the files name correctly, but when I mount=
 the
> drive in Linux, with the command:
>
> mount -t cifs //<local share ip-address>/<shared-folder> --verbose -o
> user=3Duser,pass=3D"",uid=3D1000,gid=3D1000
>
> (there is no password)
>
> All file names with special characters (like =C3=87=C3=A3=C3=B5=C3=A9=
=2E..) have a question mark
> in place of the accented character and I can't open the file or folde=
r, as
> any command responds the file doesn't exist. This happens in dolphin,=
 thunar
> and in the command line with simple commands like cat.
>
> I tried adding the following option without success
>
> iocharset=3Dutf-8
> iocharset=3Dutf-8,codepage=3Dcp437
> iocharset=3Dutf-8,codepage=3Dcp850
> iocharset=3Diso8859-1
>
> This also happens if I access the share from my android device, so I =
was
> convinced it was a problem related to old firmware (from the router).
>
> However, recently I connected to the drive using smbclient and the fi=
le
> names appeared correctly. I would like to mount this share folder at =
fstab,
> and so smbclient is not a good solution.
>
> I'm using:
> Linux kernel 3.2.0-4-amd64
> (Debian Wheezy)
> mount.cifs version: 5.5
>
> And I get this information from smbclient -L <local share ip address>=
:
> (smbclient version 4.1.11-Debian)
> Server=3D[Samba 2.2.12]
>
> So. Is there something else I can try?
>
> Thanks in advance.
>
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
