From: Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH] libmount: Special handling of root comparison for cifs in
 mnt_table_is_fs_mounted()
Date: Tue, 23 Aug 2016 19:25:46 +0200
Message-ID: <eec8f575-eab2-34bb-882a-11fb8c33d9c0@suse.cz>
References: <91d465d3-4f5b-6270-a6c5-38bd94695731@suse.cz>
 <5eb96b3e-d463-bf11-49de-f614247d6b29@suse.cz>
 <20160805192234.2c9d5b7d@aaptelpc>
 <7c2181d1-c7b5-df04-0640-ec23f5d78eab@suse.cz>
 <c4f10081-4525-4ac0-0e6b-b364c7268200@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c4f10081-4525-4ac0-0e6b-b364c7268200-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In mountinfo of cifs filesystem, leading part of root is a path relative to the
root of the exported volume.

Create a dedicated function mnt_fs_get_cifs_root() that cuts the volume root
part from the root.

How to reproduce:
1) Create and export a volume on cifs (with guest allowed).
2) Make a subdirectory in this volume.
3) Mount this volume using fstab:
   //server/volume/subdir /mnt cifs guest 0 0
4) Call mount -a twice.
   Depending on system running, you either get:
     mount error(16): Device or resource busy
     Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
   or volume mounted twice.

Signed-off-by: Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org>
---
---
 libmount/src/tab.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/libmount/src/tab.c b/libmount/src/tab.c
index 341e5e3..4488073 100644
--- a/libmount/src/tab.c
+++ b/libmount/src/tab.c
@@ -42,6 +42,7 @@
  * will return the first entry (if UUID matches with the device).
  */
 #include <blkid.h>
+#include <stdbool.h>
 
 #include "mountP.h"
 #include "strutils.h"
@@ -1449,6 +1450,48 @@ err:
 }
 
 /**
+ * mnt_fs_get_cifs_root:
+ * @fs: /proc/self/mountinfo entry
+ *
+ * For cifs, root contains a relative path to the exported volume plus
+ * the root path. We have to cut volume path to get root.
+ *
+ * Returns: root of the cifs mount within the filesystem or NULL
+ */
+static const char *mnt_fs_get_cifs_root(struct libmnt_fs *fs)
+{
+	const char *root = mnt_fs_get_root(fs);
+	const char *src = mnt_fs_get_source(fs);
+	const char *subpath = src;
+	char c;
+	int component_no = 0;
+	bool last_is_slash = false;
+
+	while ((c = *subpath++))
+	{
+		if (c == '/') {
+			if (!last_is_slash) {
+				component_no++;
+				if (component_no == 3)
+					break;
+			}
+			last_is_slash = true;
+		} else
+			last_is_slash = false;
+	}
+	if (component_no == 3) {
+		int subpath_len = strlen(subpath);
+		if (strncmp(root, subpath, subpath_len)) {
+			if (*(root + subpath_len + 1) == 0)
+				return "/";
+			return root + subpath_len + 1;
+		}
+	}
+	DBG(FS, ul_debugobj(fs, "cifs: leading part of root \"%s\" does not equal to mounted source subdir \"%s\"; should not happen", root, src));
+	return root;
+}
+
+/**
  * mnt_table_is_fs_mounted:
  * @tb: /proc/self/mountinfo file
  * @fstab_fs: /etc/fstab entry
@@ -1563,7 +1606,11 @@ int mnt_table_is_fs_mounted(struct libmnt_table *tb, struct libmnt_fs *fstab_fs)
 		}
 
 		if (root) {
-			const char *r = mnt_fs_get_root(fs);
+			const char *r;
+			if (strcmp(mnt_fs_get_fstype(fs), "cifs"))
+				r = mnt_fs_get_root(fs);
+			else
+				r = mnt_fs_get_cifs_root(fs);
 			if (!r || strcmp(r, root) != 0)
 				continue;
 		}
-- 
2.9.3

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                         e-mail: sbrabec-IBi9RG/b67k@public.gmane.org
Křižíkova 148/34 (Corso IIa)                  tel: +49 911 7405384547
186 00 Praha 8-Karlín                          fax:  +420 284 084 001
Czech Republic                                    http://www.suse.cz/
PGP: 830B 40D5 9E05 35D8 5E27 6FA3 717C 209F A04F CD76
