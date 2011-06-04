From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounting a CIFS network share on first attempt of access possible?
Date: Sat, 4 Jun 2011 08:44:02 -0500
Message-ID: <BANLkTikezCOGrNaz9r901SOCq_xP=hZxKQ@mail.gmail.com>
References: <4DEA2FF1.4090506@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: beweta-KK0ffGbhmjU@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DEA2FF1.4090506-KK0ffGbhmjU@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Automount may do what you want, but also consider configuring with
DFS.   Mount to a top level directory at boot time, but to access the
other shares - configure DFS on the server to put links to the other
network shares that you want as subdirectories.   Implicit mounts
(tree connections) to those other shares won't be done until they are
first accessed.

On Sat, Jun 4, 2011 at 8:15 AM,  <beweta-KK0ffGbhmjU@public.gmane.org> wrote:
> Hi,
>
> is it possible to mount a CIFS network share on first attempt of acce=
ss
> instead of mounting it on boot by /etc/fstab?
>
>
> Regards,
> Benedikt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
