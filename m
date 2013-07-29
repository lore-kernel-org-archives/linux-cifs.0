From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: DFS referrals
Date: Mon, 29 Jul 2013 09:07:59 -0400
Message-ID: <20130729090759.62d15e2e@corrin.poochiereds.net>
References: <51DBD032.10305@gmx.ch>
	<20130709054702.15550964@tlielax.poochiereds.net>
	<51DBDDEA.9040702@gmx.ch>
	<20130709081027.450b1849@corrin.poochiereds.net>
	<51F664FB.5090507@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F664FB.5090507-OI3hZJvNYWs@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I generally don't do 1:1 support unless you're paying me, so cc'ing
linux-cifs ml:

[...]

On Mon, 29 Jul 2013 14:50:03 +0200
Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org> wrote:

> [  124.607810] fs/cifs/cifssmb.c: negprot rc 0
> [  124.607814] fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: -7200
> [  124.607817] fs/cifs/sess.c: sess setup type 4
> [  124.607826] fs/cifs/cifs_spnego.c: key description = ver=0x2;host=d.ethz.ch;ip4=82.130.70.6;sec=krb5;uid=0xaf05;creduid=0xaf05;user=mam4tst;pid=0x61a
> [  124.803185] fs/cifs/sess.c: ssetup freeing small buf ffff88022c31a000
> [  124.803195] CIFS VFS: Send error in SessSetup = -126
> [  124.803203] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 5) rc = -126
> [  124.803212] fs/cifs/fscache.c: cifs_fscache_release_client_cookie: (0xffff88022a1b6000/0xffff88022a6430f0)
> [  124.803368] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 4) rc = -126
> [  124.803374] CIFS VFS: cifs_mount failed w/return code = -126

The only failure I see is the one above, and that's because it failed
to upcall for the correct key. Are you sure you have krb5 creds as that
user?

> [  131.324798] fs/cifs/cifssmb.c: negprot rc 0
> [  131.324804] fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: -7200
> [  131.324808] fs/cifs/sess.c: sess setup type 4
> [  131.324821] fs/cifs/cifs_spnego.c: key description = ver=0x2;host=d.ethz.ch;ip4=172.31.65.62;sec=krb5;uid=0xaf05;creduid=0xaf05;user=mam4tst;pid=0x62c
> [  131.384335] fs/cifs/transport.c: For smb_command 115
> [  131.384344] fs/cifs/transport.c: Sending smb: smb_len=1666
> [  131.387043] fs/cifs/connect.c: RFC1002 header 0xf9
> [  131.387055] fs/cifs/misc.c: checkSMB Length: 0xfd, smb_buf_length: 0xf9
> [  131.387095] fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
> [  131.387100] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release

Here' the upcall for a similar set of creds worked fine. The only thing
that seems to have changed in the key description is the IP address.

Do you have cifs.upcall set up to use the --trust-dns flag? If so, why?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
