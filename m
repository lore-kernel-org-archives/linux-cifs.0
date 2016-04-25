From: Eric Engestrom <eric@engestrom.ch>
Subject: [PATCH 25/41] Documentation: filesystems: fix spelling mistakes
Date: Mon, 25 Apr 2016 01:24:22 +0100
Message-ID: <1461543878-3639-26-git-send-email-eric@engestrom.ch>
References: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
Cc: Eric Engestrom <eric@engestrom.ch>,
	Jonathan Corbet <corbet@lwn.net>,
	Steve French <sfrench@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
	Minchan Kim <minchan@kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Jerome Marchand <jmarchan@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Thomas de Beauchene <thomas.chauvot-de-beauchene@epitech.eu>,
	linux-doc@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Signed-off-by: Eric Engestrom <eric@engestrom.ch>
---
 Documentation/filesystems/autofs4.txt  | 6 +++---
 Documentation/filesystems/cifs/CHANGES | 2 +-
 Documentation/filesystems/proc.txt     | 4 ++--
 Documentation/filesystems/vfs.txt      | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/autofs4.txt b/Documentation/filesystems/autofs4.txt
index 39d02e1..25fe9db 100644
--- a/Documentation/filesystems/autofs4.txt
+++ b/Documentation/filesystems/autofs4.txt
@@ -225,7 +225,7 @@ unmount any filesystems mounted on the autofs filesystem or remove any
 symbolic links or empty directories any time it likes.  If the unmount
 or removal is successful the filesystem will be returned to the state
 it was before the mount or creation, so that any access of the name
-will trigger normal auto-mount processing.  In particlar, `rmdir` and
+will trigger normal auto-mount processing.  In particular, `rmdir` and
 `unlink` do not leave negative entries in the dcache as a normal
 filesystem would, so an attempt to access a recently-removed object is
 passed to autofs for handling.
@@ -242,7 +242,7 @@ time stamp on each directory or symlink.  For symlinks it genuinely
 does record the last time the symlink was "used" or followed to find
 out where it points to.  For directories the field is a slight
 misnomer.  It actually records the last time that autofs checked if
-the directory or one of its descendents was busy and found that it
+the directory or one of its descendants was busy and found that it
 was.  This is just as useful and doesn't require updating the field so
 often.
 
@@ -255,7 +255,7 @@ up.
 
 There is an option with indirect mounts to consider each of the leaves
 that has been mounted on instead of considering the top-level names.
-This is intended for compatability with version 4 of autofs and should
+This is intended for compatibility with version 4 of autofs and should
 be considered as deprecated.
 
 When autofs considers a directory it checks the `last_used` time and
diff --git a/Documentation/filesystems/cifs/CHANGES b/Documentation/filesystems/cifs/CHANGES
index bc0025c..fe8f1ed 100644
--- a/Documentation/filesystems/cifs/CHANGES
+++ b/Documentation/filesystems/cifs/CHANGES
@@ -455,7 +455,7 @@ Fix internationalization problem in cifs readdir with filenames that map to
 longer UTF-8 strings than the string on the wire was in Unicode.  Add workaround
 for readdir to netapp servers. Fix search rewind (seek into readdir to return 
 non-consecutive entries).  Do not do readdir when server negotiates 
-buffer size to small to fit filename. Add support for reading POSIX ACLs from
+buffer size too small to fit filename. Add support for reading POSIX ACLs from
 the server (add also acl and noacl mount options).
 
 Version 1.24
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 7f5607a..03b6019 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -462,7 +462,7 @@ accessed.
 "Anonymous" shows the amount of memory that does not belong to any file.  Even
 a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
 and a page is modified, the file page is replaced by a private anonymous copy.
-"AnonHugePages" shows the ammount of memory backed by transparent hugepage.
+"AnonHugePages" shows the amount of memory backed by transparent hugepage.
 "Shared_Hugetlb" and "Private_Hugetlb" show the ammounts of memory backed by
 hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
 reasons. And these are not included in {Shared,Private}_{Clean,Dirty} field.
@@ -1899,7 +1899,7 @@ hidepid=1 means users may not access any /proc/<pid>/ directories but their
 own.  Sensitive files like cmdline, sched*, status are now protected against
 other users.  This makes it impossible to learn whether any user runs
 specific program (given the program doesn't reveal itself by its behaviour).
-As an additional bonus, as /proc/<pid>/cmdline is unaccessible for other users,
+As an additional bonus, as /proc/<pid>/cmdline is inaccessible for other users,
 poorly written programs passing sensitive information via program arguments are
 now protected against local eavesdroppers.
 
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 4164bd6..ec67866 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -1014,7 +1014,7 @@ struct dentry_operations {
 	Useful for some pseudo filesystems (sockfs, pipefs, ...) to delay
 	pathname generation. (Instead of doing it when dentry is created,
 	it's done only when the path is needed.). Real filesystems probably
-	dont want to use it, because their dentries are present in global
+	don't want to use it, because their dentries are present in global
 	dcache hash, so their hash should be an invariant. As no lock is
 	held, d_dname() should not try to modify the dentry itself, unless
 	appropriate SMP safety is used. CAUTION : d_path() logic is quite
-- 
2.8.0

