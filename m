From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: stable page writes: wait_on_page_writeback and packet signing
Date: Wed, 9 Mar 2011 13:44:24 -0600
Message-ID: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Following up on the discussion about how to avoid the copy into a
temporary buffer for the case when a file system has to sign a page
(or list of pages) that is going to be passed in an iovec to be
written to the network or disk, I noticed that a few file systems do
issue wait_on_page_writeback (nfs in nfs_writepages for example).
Apparently some areas are being investigated to add something similar
for ext4 for disk adapters that do crc checks on data being sent down
to the disk.   In the cifs case it looks like cifs_writepages already
does:

if (wbc->sync_mode != WB_SYNC_NONE)
                                wait_on_page_writeback(page);


(before sending the list of pages to CIFSSMBWrite2 in fs/cifs/file.c)
and does the end_page_writeback if the write to the server succeeds.
The problem is that when packet signing is enabled we default to
issuing the older CIFSSMBWrite (which will allocate a temporary
buffer, and copy the pages being written into it to make sure the data
being written is stable while calculating the CRC on the packet, which
hurts performance).  It seems like we can simply move the equivalent
of the following check:

if (pTcon->ses->server->sec_mode &
    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))

to add to the existing check for WB_SYNC
if (wbc->sync_mode != WB_SYNC_NONE)
                                wait_on_page_writeback(page);

We would have to add an end_page_writeback earlier though (after the
network i/o is successfully submitted to the network and sent, not
when the server response is received) to avoid holding up page writes
overly long - but only for the case where WB_SYNC_NONE and signing
enabled/required.

Have alternative approaches, other than using wait_on_page_writeback,
been considered for solving the stable page write problem in similar
cases (since only about 1 out of 5 linux file systems uses this call
today).

-- 
Thanks,

Steve
