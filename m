From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: smb2 and shared superblock model
Date: Sat, 26 Mar 2011 16:12:03 +0300
Message-ID: <AANLkTikvUqYG5GnOkYnrb67B1PJa7yrhzHiWT8+KxEPO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!

Today I investigated a bit about how to insert sharedblock model into
cifs and get it work correctly with smb2.1 leases. Now we have the
following archtecture:
inode -> superblock -> tlink -> tcon -> sess -> srv - so we can
definitely say what ses id and tree id we should use for a requested
inode. It's from the one hand.

>From another hand, we should share cached data between several
sessions from the same client (according to SMB2 spec we should have
one global file table). And everything is good if we will share
superblock between several mounts that uses the same sess id and tcon
id. But if these are different sessions that's brings a problem. A
superblock is linked to only one tcon id and sess id but we need to
share it between completely different sessions. So, it seems to me
that according to nowadays situation we can't share the same data
between different sessions.

So, now I suggest to share a superblock only between different mounts
of the same sess id and tcon id. And every time we negotiate a
different session (e.x. from another username) we should change
ClientGUID. It causes the server to think that these are different
clients and it won't grant leases on parallel opens from these
sessions. So, in this case we solve data coherency problem but, of
course, miss some advantages of SMB2 protocol.

Your comments/thoughts?

-- 
Best regards,
Pavel Shilovsky.
