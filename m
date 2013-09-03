From: Jim McDonough <jmcd-R8CIr89TFJeb4NgV8a0/GNi2O/JbrIOy@public.gmane.org>
Subject: [PATCH] readdir cf_nlink initialization
Date: Tue, 3 Sep 2013 11:04:15 -0400
Message-ID: <CAFneQceWVAJZ8_e2Je8R3TZjgS4Mex38EEVsTj8fT81_0nj+RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since we don't get info about the number of links from the readdir
linfo levels, stat() will return 0 for st_nlink, and in particular,
samba re-exported shares will show directories as files (as samba is
keying off st_nlink before evaluating how to set the dos modebits)
when doing a dir or ls.

The following patch just assumes that nlink must be 1 for files, 2 for
directories.

---
 fs/cifs/readdir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -125,9 +125,13 @@ cifs_fill_common_info(struct cifs_fattr
     if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
         fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
         fattr->cf_dtype = DT_DIR;
+        /* Fake nlink as we aren't provided this info */
+        fattr->cf_nlink = 2;
     } else {
         fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
         fattr->cf_dtype = DT_REG;
+        /* Fake nlink as we aren't provided this info */
+        fattr->cf_nlink = 1;
     }

     if (fattr->cf_cifsattrs & ATTR_READONLY)



-- 
Jim McDonough
Samba Team
SUSE labs
jmcd at samba dot org
jmcd at themcdonoughs dot org
