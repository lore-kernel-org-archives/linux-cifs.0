From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/9] cifs: cork the socket before a send and uncork
 it afterward
Date: Mon, 30 Jul 2012 21:17:53 -0400
Message-ID: <20120730211753.7a22e740@corrin.poochiereds.net>
References: <1343231652-10459-1-git-send-email-jlayton@redhat.com>
	<1343231652-10459-4-git-send-email-jlayton@redhat.com>
	<CAKywueQDJax9SqN95ZKbBmjtxZZs4Y34H5Xi3N3AJtiG09uVpw@mail.gmail.com>
	<20120726213304.1db924f1@corrin.poochiereds.net>
	<CAKywueRYLeMHkVPi+NB_Z0sa3QCbQnnVSUDai8N+omMg2FPDSQ@mail.gmail.com>
	<20120729081309.1cabacf7@tlielax.poochiereds.net>
	<CAKywueS9yo59J_P3JV+NDpWbHg=8Jw=pzKuOn4TKe_fDHf9-EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueS9yo59J_P3JV+NDpWbHg=8Jw=pzKuOn4TKe_fDHf9-EA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 30 Jul 2012 23:11:10 +0200
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2012/7/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Fri, 27 Jul 2012 10:05:32 +0400
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> 2012/7/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >> > On Fri, 27 Jul 2012 03:57:44 +0400
> >> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> 2012/7/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >> >> > We want to send SMBs as "atomically" as possible. Prior to sending any
> >> >> > data on the socket, cork it to make sure that no non-full frames go
> >> >> > out. Afterward, uncork it to make sure all of the data gets pushed out
> >> >> > to the wire.
> >> >> >
> >> >> > Note that this more or less renders the socket=TCP_NODELAY mount option
> >> >> > obsolete. When TCP_CORK and TCP_NODELAY are used on the same socket,
> >> >> > TCP_NODELAY is essentially ignored.
> >> >> >
> >> >> > Acked-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> >> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >> > ---
> >> >> >  fs/cifs/connect.c   |  4 ++++
> >> >> >  fs/cifs/transport.c | 12 ++++++++++++
> >> >> >  2 files changed, 16 insertions(+)
> >> >> >
> >> >> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> >> > index 6df6fa1..a828a8c 100644
> >> >> > --- a/fs/cifs/connect.c
> >> >> > +++ b/fs/cifs/connect.c
> >> >> > @@ -1676,6 +1676,10 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
> >> >> >                         if (string == NULL)
> >> >> >                                 goto out_nomem;
> >> >> >
> >> >> > +                       /*
> >> >> > +                        * FIXME: since we now cork/uncork the socket while
> >> >> > +                        *        sending, should we deprecate this option?
> >> >> > +                        */
> >> >> >                         if (strnicmp(string, "TCP_NODELAY", 11) == 0)
> >> >> >                                 vol->sockopt_tcp_nodelay = 1;
> >> >> >                         break;
> >> >> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> >> > index d93f15d..a3e58b2 100644
> >> >> > --- a/fs/cifs/transport.c
> >> >> > +++ b/fs/cifs/transport.c
> >> >> > @@ -27,6 +27,7 @@
> >> >> >  #include <linux/net.h>
> >> >> >  #include <linux/delay.h>
> >> >> >  #include <linux/freezer.h>
> >> >> > +#include <linux/tcp.h>
> >> >> >  #include <asm/uaccess.h>
> >> >> >  #include <asm/processor.h>
> >> >> >  #include <linux/mempool.h>
> >> >> > @@ -247,12 +248,23 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
> >> >> >         int n_vec = rqst->rq_nvec;
> >> >> >         unsigned int smb_buf_length = get_rfc1002_length(iov[0].iov_base);
> >> >> >         size_t total_len;
> >> >> > +       struct socket *ssocket = server->ssocket;
> >> >> > +       int val = 1;
> >> >> >
> >> >> >         cFYI(1, "Sending smb: smb_len=%u", smb_buf_length);
> >> >> >         dump_smb(iov[0].iov_base, iov[0].iov_len);
> >> >> >
> >> >> > +       /* cork the socket */
> >> >> > +       kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
> >> >> > +                               (char *)&val, sizeof(val));
> >> >> > +
> >> >> >         rc = smb_send_kvec(server, iov, n_vec, &total_len);
> >> >> >
> >> >> > +       /* uncork it */
> >> >> > +       val = 0;
> >> >> > +       kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
> >> >> > +                               (char *)&val, sizeof(val));
> >> >> > +
> >> >> >         if ((total_len > 0) && (total_len != smb_buf_length + 4)) {
> >> >> >                 cFYI(1, "partial send (wanted=%u sent=%zu): terminating "
> >> >> >                         "session", smb_buf_length + 4, total_len);
> >> >> > --
> >> >> > 1.7.11.2
> >> >> >
> >> >> > --
> >> >> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> >> >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >>
> >> >> I tested it with SMB2 against Windows 7 server. When iosize is 64K
> >> >> everything is ok but when we increase iosize to 1M (by using
> >> >> multicredit requests) and the server loses the network connection and
> >> >> only reboot helps.
> >> >>
> >> >> Also if I commented corking/uncorking the socket - everything is ok. I
> >> >> think this change needs some more investigation (how does it deals
> >> >> with 1M iosize on Samba, etc?)
> >> >>
> >> >
> >> > Hmm, haven't seen that with a 1M iosize with smb1 against samba.
> >> >
> >> > I'll see if I can reproduce it.
> >> >
> >> > --
> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>
> >> Forgot to mentioned how I reproduce it - dbench with 5 clients.
> >>
> >
> > Ok, I've built a cifs.ko from your smb2-dev-cifs-3.6 branch. Here are my mount options:
> >
> > //win7.poochiereds.net/export /mnt/win7 cifs rw,relatime,vers=2.1,sec=ntlmsspi,cache=strict,unc=\\win7.poochiereds.net\export,username=testuser,domain=WIN7,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.1.32,file_mode=0755,dir_mode=0755,nounix,serverino,rsize=1048576,wsize=1048576,actimeo=1 0 0
> 
> I don't set rsize and wsize explicitly but I don't think it's related.
> On what connection did you test it? I use 100Mbit LAN.
> 

The clients and servers are both KVM guests. I'll give it a go over a
physical network tomorrow.

> >
> > I'm running dbench against it with 5 clients, but am seeing no hangs. Do I need to do something else to reproduce it?
> >
> > Note that I am seeing a number of these sorts of warning messages:
> >
> > [84306.348564] CIFS VFS: No task to wake, unknown frame received! NumMids 4
> > [84306.353262] Received Data is: : dump of 68 bytes of data at 0xffff88000172aab0
> > [84306.353266]  6c000000 424d53fe 00000040 00000000 . . . l \xfffffffe S M B @ . . . . . . .
> > [84306.353269]  00000012 00000001 00000000 ffffffff . . . . . . . . . . . . \xffffffff \xffffffff \xffffffff \xffffffff
> > [84306.353271]  ffffffff 00000000 00000000 00000000 \xffffffff \xffffffff \xffffffff \xffffffff . . . . . . . . . . . .
> > [84306.353273]  00000000 00000000 00000000 00000000 . . . . . . . . . . . . . . . .
> > [84306.353275]  00000000 . . . .
> > [84307.761162] CIFS VFS: No task to wake, unknown frame received! NumMids 5
> > [84307.764904] Received Data is: : dump of 68 bytes of data at 0xffff88000172aab0
> > [84307.764908]  6c000000 424d53fe 00000040 00000000 . . . l \xfffffffe S M B @ . . . . . . .
> > [84307.764911]  00000012 00000001 00000000 ffffffff . . . . . . . . . . . . \xffffffff \xffffffff \xffffffff \xffffffff
> > [84307.764914]  ffffffff 00000000 00000000 00000000 \xffffffff \xffffffff \xffffffff \xffffffff . . . . . . . . . . . .
> > [84307.764916]  00000000 00000000 00000000 00000000 . . . . . . . . . . . . . . . .
> > [84307.764917]  00000000 . . . .
> > [84311.566786] CIFS VFS: No task to wake, unknown frame received! NumMids 5
> > [84311.570630] Received Data is: : dump of 68 bytes of data at 0xffff8800017a38f0
> > [84311.570634]  6c000000 424d53fe 00000040 00000000 . . . l \xfffffffe S M B @ . . . . . . .
> > [84311.570637]  00000012 00000001 00000000 ffffffff . . . . . . . . . . . . \xffffffff \xffffffff \xffffffff \xffffffff
> > [84311.570639]  ffffffff 00000000 00000000 00000000 \xffffffff \xffffffff \xffffffff \xffffffff . . . . . . . . . . . .
> > [84311.570642]  00000000 00000000 00000000 00000000 . . . . . . . . . . . . . . . .
> > [84311.570643]  00000000 . . . .
> 
> That's why the lease break issue that I mentioned later has been fixed yet.
> 
> 
> >
> > I get the same result whether I use TCP_CORK or not, so I don't think
> > that's related.
> >
> > Also, after running dbench on a vers=2.1 mount and unplugging the kmod,
> > I saw a bunch of these sorts of warnings, indicating memory leaks in
> > the SMB2 code. Those may be related to the warnings above:
> >
> > [84980.135644] =============================================================================
> > [84980.146094] BUG cifs_small_rq (Tainted: G           O): Objects remaining on kmem_cache_close()
> > [84980.156757] -----------------------------------------------------------------------------
> > [84980.156757]
> > [84980.177277] INFO: Slab 0xffffea00003e3d00 objects=19 used=17 fp=0xffff88000f8f6700 flags=0x10000000004080
> > [84980.188416] Pid: 20224, comm: rmmod Tainted: G           O 3.6.0-0.rc0.git2.1.fc18.x86_64 #1
> > [84980.199692] Call Trace:
> > [84980.210231]  [<ffffffff811ac61f>] slab_err+0xaf/0xd0
> > [84980.221112]  [<ffffffff811b1329>] ? kmem_cache_destroy+0x249/0x3d0
> > [84980.232334]  [<ffffffff811b124b>] ? kmem_cache_destroy+0x16b/0x3d0
> > [84980.243424]  [<ffffffff811b126f>] kmem_cache_destroy+0x18f/0x3d0
> > [84980.254653]  [<ffffffff8115dff5>] ? mempool_destroy+0x55/0x60
> > [84980.265816]  [<ffffffffa0357d29>] cifs_destroy_request_bufs+0x39/0x3b [cifs]
> > [84980.277350]  [<ffffffffa0357f4f>] exit_cifs+0x30/0xe1 [cifs]
> > [84980.287385]  [<ffffffff810e1914>] sys_delete_module+0x1a4/0x300
> > [84980.298287]  [<ffffffff816d0795>] ? retint_swapgs+0x13/0x1b
> > [84980.309234]  [<ffffffff811008bc>] ? __audit_syscall_entry+0xcc/0x300
> > [84980.320486]  [<ffffffff8134879e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > [84980.331739]  [<ffffffff816d9269>] system_call_fastpath+0x16/0x1b
> > [84980.342929] INFO: Object 0xffff88000f8f4000 @offset=0
> > [84980.354043] INFO: Allocated in mempool_alloc_slab+0x15/0x20 age=173263 cpu=0 pid=19880
> > [84980.365669]  __slab_alloc+0x422/0x4d2
> > [84980.376882]  kmem_cache_alloc+0x227/0x260
> > [84980.387943]  mempool_alloc_slab+0x15/0x20
> > [84980.398932]  mempool_alloc+0x68/0x180
> > [84980.409688]  cifs_small_buf_get+0x1a/0x30 [cifs]
> > [84980.420650]  cifs_demultiplex_thread+0x405/0x950 [cifs]
> > [84980.431773]  kthread+0xb7/0xc0
> > [84980.442675]  kernel_thread_helper+0x4/0x10
> >
> > That probably needs to be investigated (and fixed) as well...
> 
> I have not seen something like this. Do you mean you load module,
> mount, run dbench with 5 clients, umount share and unload module and
> this errors appeared?
> 

Yes. You may need a kernel with slab debugging enabled.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
