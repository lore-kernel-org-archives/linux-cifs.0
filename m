From: Steve French <smfrench@gmail.com>
Subject: Which lsattr / chattr can be reported for cifs/smb2/smb3 (and NTFS etc.)
Date: Wed, 25 Sep 2013 19:20:41 -0500
Message-ID: <CAH2r5mvjx0rVYCHOAPt61qU3UP6sHNz=HQjhvzvoNRU9OkeocQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Some of the attributes returnable by lsattr have equivalents in
cifs/smb2/smb3 (and NTFS).  I just finished coding and testing (in
cifs.ko) "setattr +c" (and lsattr) to enable marking a file as
compressed over smb3.  David Disseldorp also has been testing patches
for Samba server to support this (setting a flag as compressed) on
btrfs.   In Windows, it is trivial (very easy for users) in the file
manager to mark a file as compressed so it will be useful to support
in Samba server.

The obvious question to ask now is what other file or directory flags
can we report in lsattr (and change in chattr) via smb3 (and
presumably NTFS) besides whether the file is compressed.   Reporting
that a file is immutable could presumably be done by reading the ACL
and ensuring that no one has any of the write permissions.
Similarly reporting that a file is append only may be equivalent to
the case where a  files ACL has no write permissions except
FILE_APPEND_DATA among all of the ACEs.

Any thoughts on reporting FS_IMMUTABLE_FL or FS_APPEND_FL or ideas on
how to report any of the other (except compression) flags over
CIFS/SMB2/SMB3 (or in Linux NTFS file system).  Here is the complete
list from fs.h

/*
 * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
 */
#define FS_SECRM_FL 0x00000001 /* Secure deletion */
#define FS_UNRM_FL 0x00000002 /* Undelete */
#define FS_COMPR_FL 0x00000004 /* Compress file */
#define FS_SYNC_FL 0x00000008 /* Synchronous updates */
#define FS_IMMUTABLE_FL 0x00000010 /* Immutable file */
#define FS_APPEND_FL 0x00000020 /* writes to file may only append */
#define FS_NODUMP_FL 0x00000040 /* do not dump file */
#define FS_NOATIME_FL 0x00000080 /* do not update atime */
/* Reserved for compression usage... */
#define FS_DIRTY_FL 0x00000100
#define FS_COMPRBLK_FL 0x00000200 /* One or more compressed clusters */
#define FS_NOCOMP_FL 0x00000400 /* Don't compress */
#define FS_ECOMPR_FL 0x00000800 /* Compression error */
/* End compression flags --- maybe not all used */
#define FS_BTREE_FL 0x00001000 /* btree format dir */
#define FS_INDEX_FL 0x00001000 /* hash-indexed directory */
#define FS_IMAGIC_FL 0x00002000 /* AFS directory */
#define FS_JOURNAL_DATA_FL 0x00004000 /* Reserved for ext3 */
#define FS_NOTAIL_FL 0x00008000 /* file tail should not be merged */
#define FS_DIRSYNC_FL 0x00010000 /* dirsync behaviour (directories only) */
#define FS_TOPDIR_FL 0x00020000 /* Top of directory hierarchies*/
#define FS_EXTENT_FL 0x00080000 /* Extents */
#define FS_DIRECTIO_FL 0x00100000 /* Use direct i/o */
#define FS_NOCOW_FL 0x00800000 /* Do not cow file */
#define FS_RESERVED_FL 0x80000000 /* reserved for ext2 lib */

#define FS_FL_USER_VISIBLE 0x0003DFFF /* User visible flags */
#define FS_FL_USER_MODIFIABLE 0x000380FF /* User modifiable flags */

-- 
Thanks,

Steve
