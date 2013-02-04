From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Mount failure due to restricted access to a point along the mount
 path
Date: Mon, 04 Feb 2013 21:04:21 +0530
Message-ID: <510FD4FD.3010001@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

I have been looking at the $SUBJECT. And there is already a bug reported
in the samba.org bugzilla

https://bugzilla.samba.org/show_bug.cgi?id=8950

cifs gets "Access denied" while trying to get the root inode. Suppose if
you are trying to mount /share/dir/subdir and if the user doesn't have
access to any of point along the path ie. /share or /dir, mount will fail.

As noted by Jeff Layton in the bug report, this seems to be a known
problem since we started using the shared superblock model. Though we
can work around this problem by providing neccessary permissions for the
entire path, users consider this as a regression. I tend to agree with
them and think that may be we should have addressed this problem before
pushing the shared superblock changes.

>From the changelog it appears that this results in better performance
when we use SMB2.1 leases. How much better performance we are seeing?
Is that worth living with this regression?

Does this affect the CIFS users who are not using SMB2.1 in anyway?


Thanks

-- 
Suresh Jayaraman
