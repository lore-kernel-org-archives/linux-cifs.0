From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: lockdep pops with -rc5 kernel
Date: Tue, 1 May 2012 21:57:09 -0500
Message-ID: <CAH2r5muR3sQq8M2X1wHkY+uh_9eG5gGEqbKAcZt9t-G=-_J1Eg@mail.gmail.com>
References: <20120501172220.4d34b839@tlielax.poochiereds.net>
	<20120501174029.1da84b19@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120501174029.1da84b19-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, May 1, 2012 at 4:40 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On Tue, 1 May 2012 17:22:20 -0400
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
> > I'm still seeing this lockdep pop with -rc5 kernel. I thought Pavel=
 had
> > fixed this, but maybe his patch hasn't been merged yet? Or am I
> > mistaken? In any case, it looks like it just needs some lockdep
> > annotation and we probably want this fixed before 3.4 ships...
> >
> > [ =A0 55.218753] INFO: trying to register non-static key.
> > [ =A0 55.219396] the code is fine but needs lockdep annotation.
> > [ =A0 55.219396] turning off the locking correctness validator.
> > [ =A0 55.219396] Pid: 855, comm: mount.cifs Not tainted 3.4.0-rc5+ =
#15
> > [ =A0 55.219396] Call Trace:
> > [ =A0 55.219396] =A0[<ffffffff810cd7b6>] __lock_acquire+0x1306/0x1a=
d0
> > [ =A0 55.219396] =A0[<ffffffff810ccbe3>] ? __lock_acquire+0x733/0x1=
ad0
> > [ =A0 55.219396] =A0[<ffffffff810cf2ad>] ? trace_hardirqs_on+0xd/0x=
10
> > [ =A0 55.219396] =A0[<ffffffff8132ff8d>] ? pointer.isra.11+0x1fd/0x=
2d0
> > [ =A0 55.219396] =A0[<ffffffff810ce661>] lock_acquire+0xa1/0x1f0
> > [ =A0 55.219396] =A0[<ffffffffa00f96fe>] ? cifs_set_credits+0x2e/0x=
70 [cifs]
> > [ =A0 55.219396] =A0[<ffffffffa00e8ca0>] ? cifs_get_smb_ses+0x160/0=
x4c0 [cifs]
> > [ =A0 55.219396] =A0[<ffffffff816ad646>] _raw_spin_lock+0x46/0x80
> > [ =A0 55.219396] =A0[<ffffffffa00f96fe>] ? cifs_set_credits+0x2e/0x=
70 [cifs]
> > [ =A0 55.219396] =A0[<ffffffff816aa323>] ? mutex_lock_nested+0x2c3/=
0x390
> > [ =A0 55.219396] =A0[<ffffffffa00f96fe>] cifs_set_credits+0x2e/0x70=
 [cifs]
> > [ =A0 55.219396] =A0[<ffffffffa00e88ad>] cifs_negotiate_protocol+0x=
4d/0xe0 [cifs]
> > [ =A0 55.219396] =A0[<ffffffffa00e8cab>] cifs_get_smb_ses+0x16b/0x4=
c0 [cifs]
> > [ =A0 55.219396] =A0[<ffffffffa00e9099>] cifs_mount+0x99/0x6f0 [cif=
s]
> > [ =A0 55.219396] =A0[<ffffffffa00d6efc>] cifs_do_mount+0xac/0x4d0 [=
cifs]
> > [ =A0 55.219396] =A0[<ffffffff811c28b3>] mount_fs+0x43/0x1b0
> > [ =A0 55.219396] =A0[<ffffffff811df38f>] vfs_kern_mount+0x6f/0x100
> > [ =A0 55.219396] =A0[<ffffffff811dff14>] do_kern_mount+0x54/0x110
> > [ =A0 55.219396] =A0[<ffffffff811e177a>] do_mount+0x26a/0x840
> > [ =A0 55.219396] =A0[<ffffffff81155324>] ? __get_free_pages+0x14/0x=
50
> > [ =A0 55.219396] =A0[<ffffffff811e137a>] ? copy_mount_options+0x3a/=
0x180
> > [ =A0 55.219396] =A0[<ffffffff811e1e8d>] sys_mount+0x8d/0xe0
> > [ =A0 55.219396] =A0[<ffffffff816b6f29>] system_call_fastpath+0x16/=
0x1b
> >
>
> Ok, I think I've found the problem. The req_lock wasn't being
> initialized (ouch). I've just sent a patch that I think is pretty
> obvious.
>
> Steve, that should be pushed to Linus ASAP...
>

agreed.

--
Thanks,

Steve
