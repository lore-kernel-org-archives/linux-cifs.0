From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Fixes to cifs_show_options
Date: Tue, 24 Apr 2012 15:27:46 +0100
Message-ID: <1335277666.3604.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	smfrench <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

/proc/mounts does not show the mount options backupuid/backupgid for
cifs shares mounted with those options. 

While adding the backupuid/backupgid options to cifs_show_options, I
noticed that we incorrectly use %d instead of %u for the unsigned
variables used to denote uid, gid, rsize and wsize. This is fixed
by the second patch

Sachin Prabhu (2):
  CIFS: Show backupuid/gid in /proc/mounts
  Use correct conversion specifiers in cifs_show_options

 fs/cifs/cifsfs.c  |   12 ++++++++----
 fs/cifs/connect.c |   12 ++++++------
 2 files changed, 14 insertions(+), 10 deletions(-)

-- 
1.7.7.6
