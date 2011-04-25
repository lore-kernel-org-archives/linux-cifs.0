From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Status??
Date: Mon, 25 Apr 2011 10:10:00 +0200
Message-ID: <BANLkTim+q6oBRc3MGhjuPnQZ-VDieanVwQ@mail.gmail.com>
References: <BANLkTin2uu-K7qV=b0_sFAnksQDdozGQCQ@mail.gmail.com>
	<BANLkTik8OHFYwkEcyAVd01Rob0JWHZo5=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTik8OHFYwkEcyAVd01Rob0JWHZo5=w@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Aha, thanks a lot!

I was already wondering how the matching goes.

Using winbind for that is logical. I hope it does not cause too much
delay, and that winbind is "smart" (caching and not doing lookups for
standard SID's like ....-513).

Do you maybe know the fuse ntfs-3g fuse fs to mount ntfs?? They are
also using a mapping... using a special file.

Stef

>
>
> Stef,
>
> This patchset would enable you to map a SID to either an uid or a gid
> using services of winbind.
>
> You will need to run winbind (/etc/init.d/winbind script), make chang=
es
> to /etc/nsswitch.conf to include winbind in passwd and group database=
s,
> have winbind specific entries in smb.conf and cifs.upcall binary
> (/usr/sbin/cifs.upcall) be running.
> And you will need to mount the share using mount option =C2=A0cifsacl=
=2E
>
> Basically, map a SID (owner SID, group SID, any SID in the (D)ACL)
> to either an uid or a gid using winbind APIs.
> If that fails (e.g. because winbind is not installed/running or winbi=
nd returns
> an error), try to obtain uid of 'nobody' and gid of 'nogroup'.
> And if that fails, kernel assigns uid and gid (from mount superblock)=
=2E
>
> Regards,
>
> Shirish
>
