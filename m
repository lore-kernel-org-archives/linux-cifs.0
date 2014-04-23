From: Mike Pagano <mpagano-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: [PATCH resubmit 1/1] Add additional error text for missing mount.cifs
Date: Wed, 23 Apr 2014 14:40:56 -0400
Message-ID: <20140423184055.GA18378@woodpecker.gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If a cifs mount is attempted without mount.cifs present on the
system the following appears via dmesg:

[   25.949378] CIFS VFS: No username specified

The purpose of this patch is to better inform the user of the
possible cause of the error and show a potential solution.

The output for this error condition will look approximately like this:

[   11.183392] CIFS VFS: No username specified. Could not find 
/sbin/mount.cifs. Please ensure your system has this userspace program
installed.

Signed-off-by: Mike Pagano <mpagano-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
---
 fs/cifs/connect.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8813ff7..2091709 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3359,6 +3359,7 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
            const char *devname)
 {
    int rc = 0;
+   struct path path;

    if (cifs_parse_mount_options(mount_data, devname, volume_info))
        return -EINVAL;
@@ -3371,7 +3372,15 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
        /* BB fixme parse for domain name here */
        cifs_dbg(FYI, "Username: %s\n", volume_info->username);
    } else {
-       cifs_dbg(VFS, "No username specified\n");
+   /* As an extra step, check for missing /sbin/mount.cifs. Append
+      to error message as we cannot guarantee the location of this
+      binary in userspace */
+       if (kern_path("/sbin/mount.cifs", 0, &path)) {
+           cifs_dbg(VFS, "No username specified. Could not find /sbin/mount.cifs. Please ensure your system has this userspace program installed.\n");
+       }
+       else {
+           cifs_dbg(VFS, "No username specified\n");
+       }
    /* In userspace mount helper we can get user name from alternate
       locations such as env variables and files on disk */
        return -EINVAL;
--
1.8.3.2
