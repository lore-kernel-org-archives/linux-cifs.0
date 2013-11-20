From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mapchars should be default on smb2 and later mounts
Date: Wed, 20 Nov 2013 15:23:49 -0600
Message-ID: <CAH2r5mu5SK++C4MaK1M-VQTWBk60JE843wWC-sUBWnYxLnHioQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since we don't have posix pathnames in SMB2/SMB3, shouldn't mapchars
be the default if unspecified at mount to smb2/smb3 server?

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8813ff7..cc24459 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1197,6 +1197,7 @@ cifs_parse_mount_options(const char *mountdata,
const char *devname,
     short int override_gid = -1;
     bool uid_specified = false;
     bool gid_specified = false;
+    bool mapchar_specified = false;
     bool sloppy = false;
     char *invalid = NULL;
     char *nodename = utsname()->nodename;
@@ -1339,9 +1340,11 @@ cifs_parse_mount_options(const char *mountdata,
const char *devname,
             break;
         case Opt_mapchars:
             vol->remap = 1;
+            mapchar_specified = true;
             break;
         case Opt_nomapchars:
             vol->remap = 0;
+            mapchar_specified = true;
             break;
         case Opt_sfu:
             vol->sfu_emul = 1;
@@ -1882,6 +1885,10 @@ cifs_parse_mount_options(const char *mountdata,
const char *devname,
         printk(KERN_NOTICE "CIFS: ignoring forcegid mount option "
                    "specified with no gid= option.\n");

+    /* SMB2 and later do not support posix pathnames. default to mapchar */
+    if ((mapchar_specified == false) && (vol->vals != &smb1_values))
+        vol->remap = 1;
+
     kfree(mountdata_copy);
     return 0;

-- 
Thanks,

Steve
