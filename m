From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/9] cifs: cork the socket before a send and uncork it afterward
Date: Wed, 1 Aug 2012 15:37:57 +0200
Message-ID: <CAKywueSRgfTstMkWNHYqS-OXGF7wSnVwE57zcWasvAiAZTTT3w@mail.gmail.com>
References: <1343231652-10459-1-git-send-email-jlayton@redhat.com>
	<1343231652-10459-4-git-send-email-jlayton@redhat.com>
	<CAKywueQDJax9SqN95ZKbBmjtxZZs4Y34H5Xi3N3AJtiG09uVpw@mail.gmail.com>
	<20120726213304.1db924f1@corrin.poochiereds.net>
	<CAKywueRYLeMHkVPi+NB_Z0sa3QCbQnnVSUDai8N+omMg2FPDSQ@mail.gmail.com>
	<20120729081309.1cabacf7@tlielax.poochiereds.net>
	<CAKywueS9yo59J_P3JV+NDpWbHg=8Jw=pzKuOn4TKe_fDHf9-EA@mail.gmail.com>
	<20120730211753.7a22e740@corrin.poochiereds.net>
	<20120731072414.185b1ff0@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120731072414.185b1ff0-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/31 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Mon, 30 Jul 2012 21:17:53 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Mon, 30 Jul 2012 23:11:10 +0200
>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > 2012/7/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > > On Fri, 27 Jul 2012 10:05:32 +0400
>> > > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > >
>> > >> 2012/7/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > >> > On Fri, 27 Jul 2012 03:57:44 +0400
>> > >> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > >> >
>> > >> >> 2012/7/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > >> >> > We want to send SMBs as "atomically" as possible. Prior to sending any
>> > >> >> > data on the socket, cork it to make sure that no non-full frames go
>> > >> >> > out. Afterward, uncork it to make sure all of the data gets pushed out
>> > >> >> > to the wire.
>> > >> >> >
>> > >> >> > Note that this more or less renders the socket=TCP_NODELAY mount option
>> > >> >> > obsolete. When TCP_CORK and TCP_NODELAY are used on the same socket,
>> > >> >> > TCP_NODELAY is essentially ignored.
>> > >> >> >
>> > >> >> > Acked-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> > >> >> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > >> >> > ---
>> > >> >> >  fs/cifs/connect.c   |  4 ++++
>> > >> >> >  fs/cifs/transport.c | 12 ++++++++++++
>> > >> >> >  2 files changed, 16 insertions(+)
>> > >> >> >
>> > >> >> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > >> >> > index 6df6fa1..a828a8c 100644
>> > >> >> > --- a/fs/cifs/connect.c
>> > >> >> > +++ b/fs/cifs/connect.c
>> > >> >> > @@ -1676,6 +1676,10 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>> > >> >> >                         if (string == NULL)
>> > >> >> >                                 goto out_nomem;
>> > >> >> >
>> > >> >> > +                       /*
>> > >> >> > +                        * FIXME: since we now cork/uncork the socket while
>> > >> >> > +                        *        sending, should we deprecate this option?
>> > >> >> > +                        */
>> > >> >> >                         if (strnicmp(string, "TCP_NODELAY", 11) == 0)
>> > >> >> >                                 vol->sockopt_tcp_nodelay = 1;
>> > >> >> >                         break;
>> > >> >> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> > >> >> > index d93f15d..a3e58b2 100644
>> > >> >> > --- a/fs/cifs/transport.c
>> > >> >> > +++ b/fs/cifs/transport.c
>> > >> >> > @@ -27,6 +27,7 @@
>> > >> >> >  #include <linux/net.h>
>> > >> >> >  #include <linux/delay.h>
>> > >> >> >  #include <linux/freezer.h>
>> > >> >> > +#include <linux/tcp.h>
>> > >> >> >  #include <asm/uaccess.h>
>> > >> >> >  #include <asm/processor.h>
>> > >> >> >  #include <linux/mempool.h>
>> > >> >> > @@ -247,12 +248,23 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
>> > >> >> >         int n_vec = rqst->rq_nvec;
>> > >> >> >         unsigned int smb_buf_length = get_rfc1002_length(iov[0].iov_base);
>> > >> >> >         size_t total_len;
>> > >> >> > +       struct socket *ssocket = server->ssocket;
>> > >> >> > +       int val = 1;
>> > >> >> >
>> > >> >> >         cFYI(1, "Sending smb: smb_len=%u", smb_buf_length);
>> > >> >> >         dump_smb(iov[0].iov_base, iov[0].iov_len);
>> > >> >> >
>> > >> >> > +       /* cork the socket */
>> > >> >> > +       kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
>> > >> >> > +                               (char *)&val, sizeof(val));
>> > >> >> > +
>> > >> >> >         rc = smb_send_kvec(server, iov, n_vec, &total_len);
>> > >> >> >
>> > >> >> > +       /* uncork it */
>> > >> >> > +       val = 0;
>> > >> >> > +       kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
>> > >> >> > +                               (char *)&val, sizeof(val));
>> > >> >> > +
>> > >> >> >         if ((total_len > 0) && (total_len != smb_buf_length + 4)) {
>> > >> >> >                 cFYI(1, "partial send (wanted=%u sent=%zu): terminating "
>> > >> >> >                         "session", smb_buf_length + 4, total_len);
>> > >> >> > --
>> > >> >> > 1.7.11.2
>> > >> >> >
>> > >> >> > --
>> > >> >> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> > >> >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > >> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > >> >>
>> > >> >> I tested it with SMB2 against Windows 7 server. When iosize is 64K
>> > >> >> everything is ok but when we increase iosize to 1M (by using
>> > >> >> multicredit requests) and the server loses the network connection and
>> > >> >> only reboot helps.
>> > >> >>
>> > >> >> Also if I commented corking/uncorking the socket - everything is ok. I
>> > >> >> think this change needs some more investigation (how does it deals
>> > >> >> with 1M iosize on Samba, etc?)
>> > >> >>
>> > >> >
>> > >> > Hmm, haven't seen that with a 1M iosize with smb1 against samba.
>> > >> >
>> > >> > I'll see if I can reproduce it.
>> > >> >
>> > >> > --
>> > >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > >>
>> > >> Forgot to mentioned how I reproduce it - dbench with 5 clients.
>> > >>
>> > >
>> > > Ok, I've built a cifs.ko from your smb2-dev-cifs-3.6 branch. Here are my mount options:
>> > >
>> > > //win7.poochiereds.net/export /mnt/win7 cifs rw,relatime,vers=2.1,sec=ntlmsspi,cache=strict,unc=\\win7.poochiereds.net\export,username=testuser,domain=WIN7,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.1.32,file_mode=0755,dir_mode=0755,nounix,serverino,rsize=1048576,wsize=1048576,actimeo=1 0 0
>> >
>> > I don't set rsize and wsize explicitly but I don't think it's related.
>> > On what connection did you test it? I use 100Mbit LAN.
>> >
>>
>> The clients and servers are both KVM guests. I'll give it a go over a
>> physical network tomorrow.
>>
>
> Ok, ran it with client as a KVM guest and the server as win7 running on
> bare metal over a gigE network. It still ran just fine.
>
> So what are the symptoms that you see here? Does dbench just hang? If
> so, could you collect /proc/<pid>/stack from the hung process(es)?
> Maybe that would tell us what's going on...

Windows 7 server doesn't response to packets after some time running
dbench. Also, I even can't ping google.com from this Windows machine.
It seems that everything ok with dbench and Linux machine.

So, it looks like Windows server problem on my configuration but of
course seems very strage. I will try this patch with Samba server
further.

This patch doesn't break things with Windows untill we use multicredit
requests (more than 64K, that are not targeted to 3.6 kernel). But I
am going to target multicredit requests feature for 3.7. May be we
should make cork/nodelay switchable? Or just merge the patchset
without this patch for 3.6 and delay this patch for 3.7 - we will have
much time to investigate this strange behavior?

Thoughts?

-- 
Best regards,
Pavel Shilovsky.
