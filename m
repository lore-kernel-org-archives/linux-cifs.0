From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Display strictcache mount option in /proc/mounts
Date: Mon, 17 Oct 2011 15:29:14 +0100
Message-ID: <1318861755.30821.27.camel@sprabhu.fab.redhat.com>
References: <1318337032.3659.65.camel@sprabhu.fab.redhat.com>
	 <CAH2r5ms0Udg87PTi9sRZsWbp3+SvCOKScHg3nWh6OtjKFNALqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms0Udg87PTi9sRZsWbp3+SvCOKScHg3nWh6OtjKFNALqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2011-10-11 at 12:40 -0500, Steve French wrote:
> Looks reasonable - are we missing any more from the list of mount
> options that might matter to display?
> 
When comparing the options parsed in cifs_parse_mount_options() and ones
shown in cifs_show_options(), there seems to be a few which are
missing. 

A quick list made by comparing the options parsed and displayed..
sign 
nostrictsync/strictsync
noperm/perm
iocharset
locallease
netbiosname
noautotune
noblocksnd
nodfs
port
prefixpath
sec
servern
sockopt

Below is a simple patch which also includes the nostrictsync and noperm
mount options.

Sachin Prabhu
--

Show nostrictsync and noperm mount options in /proc/mounts

Add support to print nostrictsync and noperm mount options in /proc/mounts for shares mounted with these options.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 54b8f1e..eb6e8bf 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -432,6 +432,10 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 		seq_printf(s, ",mfsymlinks");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
 		seq_printf(s, ",fsc");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
+		seq_printf(s, ",nostrictsync");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+		seq_printf(s, ",noperm");
 
 	seq_printf(s, ",rsize=%d", cifs_sb->rsize);
 	seq_printf(s, ",wsize=%d", cifs_sb->wsize);
