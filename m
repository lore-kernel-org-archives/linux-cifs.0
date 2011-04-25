From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Status??
Date: Sun, 24 Apr 2011 21:15:10 -0500
Message-ID: <BANLkTik8OHFYwkEcyAVd01Rob0JWHZo5=w@mail.gmail.com>
References: <BANLkTin2uu-K7qV=b0_sFAnksQDdozGQCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTin2uu-K7qV=b0_sFAnksQDdozGQCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Apr 24, 2011 at 4:09 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> as developer of mount.md5key/fuse-workspace I'm interested in the
> latest changes of cifs-utils.
>
> What is the current status, what are you working on. I see something
> about SID, and mapping to an uid or gid, which is of course a good
> thing.
>
> And I see something about DFS.
>
> Please some info about latest development and/or status.
>
> Thanks in advance,
>
> Stef Bon
> Voorburg
> the Netherlands
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Stef,

This patchset would enable you to map a SID to either an uid or a gid
using services of winbind.

You will need to run winbind (/etc/init.d/winbind script), make changes
to /etc/nsswitch.conf to include winbind in passwd and group databases,
have winbind specific entries in smb.conf and cifs.upcall binary
(/usr/sbin/cifs.upcall) be running.
And you will need to mount the share using mount option  cifsacl.

Basically, map a SID (owner SID, group SID, any SID in the (D)ACL)
to either an uid or a gid using winbind APIs.
If that fails (e.g. because winbind is not installed/running or winbind=
 returns
an error), try to obtain uid of 'nobody' and gid of 'nogroup'.
And if that fails, kernel assigns uid and gid (from mount superblock).

Regards,

Shirish
