From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: find_smb_session problem
Date: Fri, 11 Mar 2011 12:29:17 +0300
Message-ID: <AANLkTikk0Qef1B4myQwUOnyQLOWsQbebsCkGcgUFFmcY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi to all!

I faced with such a problem:
1) user1 mounts a remote share with user=guest,pass=231
2) user2 mounts the same share with user=guest,pass=222(wrong
password) and succeed (!).

The problem is that user2 doesn't know a true password of the share
but can mount it if user1 successfully mounted it with the true
password.

Looking through the code I noticed that we don't have any checks in
find_smb_session for passwords - only username check. I think it's a
big security issue.

Another problem with it will come with SMB2.1 leases. Let's predict
the situation:
1) user1 mounts a remote share
2) user2 mounts the same share with the same username and password.

Both succeed on the same smb connection. Then:
3) user1 opens a file and gets Lease for RWH
4) user2 opens the same file and again gets Lease for RWH

because a server thinks that it's the same client and the cache for it
is the same, but as far as we mounts if into separete directories we
have them as different inodes and different caches. It will be an
problem with a data coherency. So, in the case of SMB2.1 we should not
use existing smb connection (not tcp connection) at all, as I think.

Your thoughts/comments, please?

-- 
Best regards,
Pavel Shilovsky.
