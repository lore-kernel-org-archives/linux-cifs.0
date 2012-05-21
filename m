From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: document the cache= option and mark strictcache and directio as being deprecated
Date: Mon, 21 May 2012 09:14:53 -0400
Message-ID: <1337606093-5742-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...also add a CACHE COHERENCY section so that we can explain cifs' behavior
in detail.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index cbf2e76..f6a66bf 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -220,14 +220,58 @@ dynperm
 Instructs the server to maintain ownership and permissions in memory that can\'t be stored on the server\&. This information can disappear at any time (whenever the inode is flushed from the cache), so while this may help make some applications work, it\'s behavior is somewhat unreliable\&. See the section below on FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS for more information\&.
 .RE
 .PP
+cache=
+.RS 4
+Cache mode\&. See the section below on CACHE COHERENCY for details. Allowed values are:
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+none: do not cache file data at all
+.RE
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+strict: follow the CIFS/SMB2 protocol strictly
+.RE
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+loose: allow loose caching semantics
+.RE
+.PP
+The default in kernels prior to 3.7 was "loose". As of kernel 3.7 the default is "strict".
+.RE
+.PP
 directio
 .RS 4
 Do not do inode data caching on files opened on this mount\&. This precludes mmaping files on this mount\&. In some cases with fast networks and little or no caching benefits on the client (e\&.g\&. when the application is doing large sequential reads bigger than page size without rereading the same data) this can provide better performance than the default behavior which caches reads (readahead) and writes (writebehind) through the local Linux client pagecache if oplock (caching token) is granted and held\&. Note that direct allows write operations larger than page size to be sent to the server\&. On some kernels this requires the cifs\&.ko module to be built with the CIFS_EXPERIMENTAL configure option\&.
+.PP
+This option is will be deprecated in 3.7. Users should use cache=none instead on more recent kernels.
 .RE
 .PP
 strictcache
 .RS 4
 Use for switching on strict cache mode\&. In this mode the client reads from the cache all the time it has Oplock Level II, otherwise - read from the server\&. As for write - the client stores a data in the cache in Exclusive Oplock case, otherwise - write directly to the server\&.
+.PP
+This option is will be deprecated in 3.7. Users should use cache=strict instead on more recent kernels.
 .RE
 .PP
 rwpidforward
@@ -531,6 +575,62 @@ When Unix Extensions are enabled, we use the actual inode number provided by the
 When Unix Extensions are disabled and "serverino" mount option is enabled there is no way to get the server inode number\&. The client typically maps the server\-assigned "UniqueID" onto an inode number\&.
 .PP
 Note that the UniqueID is a different value from the server inode number\&. The UniqueID value is unique over the scope of the entire server and is often greater than 2 power 32\&. This value often makes programs that are not compiled with LFS (Large File Support), to trigger a glibc EOVERFLOW error as this won\'t fit in the target structure field\&. It is strongly recommended to compile your programs with LFS support (i\&.e\&. with \-D_FILE_OFFSET_BITS=64) to prevent this problem\&. You can also use "noserverino" mount option to generate inode numbers smaller than 2 power 32 on the client\&. But you may not be able to detect hardlinks properly\&.
+.SH CACHE COHERENCY
+With a network filesystem such as CIFS or NFS, the client must contend with
+the fact that activity on other clients or the server could change the contents
+or attributes of a file without the client being aware of it. One way to deal
+with such a problem is to mandate that all file accesses go to the server
+directly. This is performance prohibitive however, so most protocols have some
+mechanism to allow the client to cache data locally.
+.PP
+The CIFS protocol mandates (in effect) that the client should not cache file
+data unless it holds an opportunistic lock (aka oplock) or a lease. Both of
+these entities allow the client to guarantee certain types of exclusive access
+to a file so that it can access its contents without needing to continually
+interact with the server. The server will call back the client when it needs to
+revoke either of them and allow the client a certain amount of time to flush
+any cached data.
+.PP
+The cifs client uses the kernel's pagecache to cache file data. Any I/O that's
+done through the pagecache is generally page-aligned. This can be problematic
+when combined with byte-range locks as Windows' locking is mandatory and can
+block reads and writes from occurring.
+.PP
+cache=none means that the client never utilizes the cache for normal reads and
+writes. It always accesses the server directly to satisfy a read or write request.
+.PP
+cache=strict means that the client will attempt to follow the CIFS/SMB2
+protocol strictly. That is, the cache is only trusted when the client holds
+an oplock. When the client does not hold an oplock, then the client bypasses
+the cache and accesses the server directly to satisfy a read or write request. By
+doing this, the client avoids problems with byte range locks. Additionally, byte
+range locks are cached on the client when it holds an oplock and are "pushed" to
+the server when that oplock is recalled.
+.PP
+cache=loose allows the client to use looser protocol semantics which can sometimes
+provide better performance at the expense of cache coherency. File access always
+involves the pagecache. When an oplock or lease is not held, then the client will
+attempt to flush the cache soon after a write to a file. Note that that flush
+does not necessarily occur before a write system call returns.
+.PP
+In the case of a read without holding an oplock, the client will attempt to
+periodically check the attributes of the file in order to ascertain whether it
+has changed and the cache might no longer be valid. This mechanism is much like
+the one that NFSv2/3 use for cache coherency, but it particularly problematic
+with CIFS. Windows is quite "lazy" with respect to updating the "LastWriteTime"
+field that the client uses to verify this. The effect is that cache=loose can
+cause data corruption when multiple readers and writers are working on the
+same files.
+.PP
+Because of this, when multiple clients are accessing the same set of files, then
+cache=strict is recommended. That helps eliminate problems with cache coherency by
+following the CIFS/SMB2 protocols more strictly.
+.PP
+Note too that no matter what caching model is used, the client will always use
+the pagecache to handle mmap'ed files. Writes to mmap'ed files are only guaranteed
+to be flushed to the server when msync() is called, or on close().
+.PP
+The default in kernels prior to 3.7 was "loose". As of 3.7, the default is "strict".
 .SH CIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRIPTORS
 This option is used to work with file objects which posses Security Descriptors and CIFS/NTFS ACL instead of UID, GID, file permission bits, and POSIX ACL as user authentication model. This is the most common authentication model for CIFS servers and is the one used by Windows.
 .sp
-- 
1.7.7.6
