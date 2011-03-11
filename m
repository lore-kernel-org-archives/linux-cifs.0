From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: find_smb_session problem
Date: Fri, 11 Mar 2011 06:33:43 -0500
Message-ID: <20110311063343.2c020b32@tlielax.poochiereds.net>
References: <AANLkTikk0Qef1B4myQwUOnyQLOWsQbebsCkGcgUFFmcY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikk0Qef1B4myQwUOnyQLOWsQbebsCkGcgUFFmcY-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 11 Mar 2011 12:29:17 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Another problem with it will come with SMB2.1 leases. Let's predict
> the situation:
> 1) user1 mounts a remote share
> 2) user2 mounts the same share with the same username and password.
> 
> Both succeed on the same smb connection. Then:
> 3) user1 opens a file and gets Lease for RWH
> 4) user2 opens the same file and again gets Lease for RWH
> 
> because a server thinks that it's the same client and the cache for it
> is the same, but as far as we mounts if into separete directories we
> have them as different inodes and different caches. It will be an
> problem with a data coherency. So, in the case of SMB2.1 we should not
> use existing smb connection (not tcp connection) at all, as I think.
> 
> Your thoughts/comments, please?
> 

It's probably a bug, but it an uncommon configuration and a bit on the
pathological side. Trying to use different SMB connections from the
same user over the same connection will probably confuse some servers.

If you want cache coherency between separate mounts of the same data,
then you probably need to consider moving CIFS to a shared superblock
model like NFS has.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
