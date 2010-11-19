From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Make cifsFileInfo_put work with strict cache mode
Date: Fri, 19 Nov 2010 22:31:29 +0300
Message-ID: <AANLkTinR1--V7KL=7nb0VAyjEm=nJDk5n+xU7NcaaxXD@mail.gmail.com>
References: <1289459222-8210-1-git-send-email-piastryyy@gmail.com>
	<20101115073430.2254b19c@tlielax.poochiereds.net>
	<AANLkTi=SDMQfw4+rZSA_nvW-bq8hsH4ycVa6MXU+vSz=@mail.gmail.com>
	<AANLkTi=e=ExtiYwkWm0tNFVFJWT9nv7HZZB_7PphFKLS@mail.gmail.com>
	<AANLkTi=WzPB6o_f0KL2Sxgdv0Ve4jqK22w8qzdSUTfOj@mail.gmail.com>
	<20101119113350.606a4598@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101119113350.606a4598-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 19 Nov 2010 14:55:57 +0300
> I don't think we should apply any patches to fix a problem that we
> don't really understand. If it mostly goes away with cifsFYI turned on
> then it sounds like a race condition of some sort. It looks like
> invalidate_inode_pages2 invalidates locked pages whereas
> invalidate_remote_inode doesn't, so that may be a hint, or it could
> just change the timing of the race.
>
> You'll need to ascertain the nature of the race to ensure that the fix
> is really fixing the problem and not just papering over the bug.
>

I checked all the lock/unlock calls for pages in CIFS code and didn't
find any problem places. I added debug message that shows how many
pages invalidate_remote_inode invalidates and for wrong case it is 0:

 /home/piastry/git/cifs-2.6/fs/cifs/file.c: CIFS VFS: in cifs_close as
Xid: 1922 with uid: 500
 /home/piastry/git/cifs-2.6/fs/cifs/cifssmb.c: In CIFSSMBClose
 /home/piastry/git/cifs-2.6/fs/cifs/transport.c: For smb_command 4
 /home/piastry/git/cifs-2.6/fs/cifs/transport.c: Sending smb:  total_len 45
 /home/piastry/git/cifs-2.6/fs/cifs/connect.c: rfc1002 length 0x27
 /home/piastry/git/cifs-2.6/fs/cifs/file.c: closing last open instance
for inode e2402828
 /home/piastry/git/cifs-2.6/fs/cifs/file.c: CIFS VFS: leaving
cifs_close (xid = 1922) rc = 0
 /home/piastry/git/cifs-2.6/fs/cifs/inode.c: CIFS VFS: in
cifs_revalidate as Xid: 1923 with uid: 500
 /home/piastry/git/cifs-2.6/fs/cifs/inode.c: Revalidate: /_test4321_
inode 0xe2402690 count 1 dentry: 0xf6f0b550 d_time 1962130 jiffies
2313421
 /home/piastry/git/cifs-2.6/fs/cifs/file.c: CIFS VFS: in
cifs_writepages as Xid: 1924 with uid: 500
 /home/piastry/git/cifs-2.6/fs/cifs/file.c: CIFS VFS: leaving
cifs_writepages (xid = 1924) rc = 0
 /home/piastry/git/cifs-2.6/fs/cifs/inode.c: invalidating remote inode
since open detected it changed
 /home/piastry/git/cifs-2.6/fs/cifs/inode.c: invalidate returned: 0
 ^^^
 /home/piastry/git/cifs-2.6/fs/cifs/inode.c: CIFS VFS: leaving
cifs_revalidate (xid = 1923) rc = 0
 /home/piastry/git/cifs-2.6/fs/cifs/file.c: CIFS VFS: in cifs_open as
Xid: 1925 with uid: 500
 /home/piastry/git/cifs-2.6/fs/cifs/file.c: inode = 0xe2402690 file
flags are 0x8000 for /_test4321_

For right cases it is "invalidate returned: 1". This message was taken
from dmesg after a run of my python script I posted before.

So, the page can be locked and then successfully unlocked by VFS
(because invalidate_inode_pages2 locks a page before processing it).
Anyway I think we shouldn't use invalidate_remote_inode at all - we
can miss pages that are under some VFS process. In this case
invalidate_inode_pages2 is ok - I don't think it can break any things.

-- 
Best regards,
Pavel Shilovsky.
