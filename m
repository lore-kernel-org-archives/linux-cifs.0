From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Fixes to cifs_show_options
Date: Tue, 24 Apr 2012 11:37:58 -0500
Message-ID: <CAH2r5mtVR9ve4bki6=JcWFzodXWnw_0Ykqp8e047ziHtd2XXKA@mail.gmail.com>
References: <1335277666.3604.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335277666.3604.7.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Tue, Apr 24, 2012 at 9:27 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> /proc/mounts does not show the mount options backupuid/backupgid for
> cifs shares mounted with those options.
>
> While adding the backupuid/backupgid options to cifs_show_options, I
> noticed that we incorrectly use %d instead of %u for the unsigned
> variables used to denote uid, gid, rsize and wsize. This is fixed
> by the second patch
>
> Sachin Prabhu (2):
> =A0CIFS: Show backupuid/gid in /proc/mounts
> =A0Use correct conversion specifiers in cifs_show_options
>
> =A0fs/cifs/cifsfs.c =A0| =A0 12 ++++++++----
> =A0fs/cifs/connect.c | =A0 12 ++++++------
> =A02 files changed, 14 insertions(+), 10 deletions(-)
>
> --
> 1.7.7.6
>
>



--=20
Thanks,

Steve
