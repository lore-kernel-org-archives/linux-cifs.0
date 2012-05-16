From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SLUB cifs_request: kmem_cache_destroy called for cache that still
 has objects.
Date: Tue, 15 May 2012 23:00:51 -0500
Message-ID: <CAH2r5muoDPbWv5jpK7hkyVAV_EOGoAVUccz86nZsxPy6WyahpQ@mail.gmail.com>
References: <20120515204642.1a5bedee@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120515204642.1a5bedee-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I don't see that on my rc7 system and I have slub debugging and
various other debugging options on in my rc7 config.  Let me know if
you find a way to reproduce it or want me to try with your config.

On Tue, May 15, 2012 at 7:46 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> I saw this today when unplugging cifs.ko in a stock -rc7 kernel. I
> never mounted any cifs mounts, so this is entirely due to module
> initialization as far as I can tell:
>
> [ =A0464.776843] SLUB cifs_request: kmem_cache_destroy called for cac=
he that still has objects.
> [ =A0464.779071] Pid: 4738, comm: rmmod Not tainted 3.4.0-0.rc7.git0.=
1.fc18.x86_64 #1
> [ =A0464.780243] Call Trace:
> [ =A0464.780433] =A0[<ffffffff8116b53a>] kmem_cache_destroy+0x2ba/0x3=
60
> [ =A0464.780870] =A0[<ffffffffa00d6469>] cifs_destroy_request_bufs+0x=
21/0x3b [cifs]
> [ =A0464.781397] =A0[<ffffffffa00d66a6>] exit_cifs+0x30/0x98a [cifs]
> [ =A0464.781944] =A0[<ffffffff810b4a3e>] sys_delete_module+0x16e/0x2d=
0
> [ =A0464.782482] =A0[<ffffffff8117c186>] ? filp_close+0x66/0xa0
> [ =A0464.782903] =A0[<ffffffff81603769>] system_call_fastpath+0x16/0x=
1b
>
> ...any ideas?
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
