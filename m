From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] manpage: correct typos and spelling mistakes
Date: Wed, 15 Feb 2017 18:10:09 +0100
Message-ID: <20170215171009.30337-1-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 mount.cifs.8 | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 01579f6..9104fae 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -324,7 +324,7 @@ See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more details
 .PP
 nocase
 .RS 4
-Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.
+Request case insensitive path name matching (case sensitive is the default if the server supports it)\&.
 .RE
 .PP
 ignorecase
@@ -457,7 +457,7 @@ Enable support for Minshall+French symlinks(see http://wiki.samba.org/index.php/
 .PP
 serverino
 .RS 4
-Use inode numbers (unique persistent file identifiers) returned by the server instead of automatically generating temporary inode numbers on the client\&. Although server inode numbers make it easier to spot hardlinked files (as they will have the same inode numbers) and inode numbers may be persistent (which is userful for some sofware), the server does not guarantee that the inode numbers are unique if multiple server side mounts are exported under a single share (since inode numbers on the servers might not be unique if multiple filesystems are mounted under the same shared higher level directory)\&. Note that not all servers support returning server inode numbers, although those that support the CIFS Unix Extensions, and Windows 2000 and later servers typically do support this (althou
 gh not necessarily on every local server filesystem)\&. Parameter has no effect if the server lacks support for returning inode numbers or equivalent\&. This behavior is enabled by default\&.
+Use inode numbers (unique persistent file identifiers) returned by the server instead of automatically generating temporary inode numbers on the client\&. Although server inode numbers make it easier to spot hardlinked files (as they will have the same inode numbers) and inode numbers may be persistent (which is useful for some software), the server does not guarantee that the inode numbers are unique if multiple server side mounts are exported under a single share (since inode numbers on the servers might not be unique if multiple filesystems are mounted under the same shared higher level directory)\&. Note that not all servers support returning server inode numbers, although those that support the CIFS Unix Extensions, and Windows 2000 and later servers typically do support this (althou
 gh not necessarily on every local server filesystem)\&. Parameter has no effect if the server lacks support for returning inode numbers or equivalent\&. This behavior is enabled by default\&.
 .RE
 .PP
 noserverino
@@ -485,7 +485,7 @@ Do not allow getfattr/setfattr to get/set xattrs, even if server would support i
 .PP
 rsize=\fIbytes\fR
 .RS 4
-Maximum amount of data that the kernel will request in a read request in bytes. Prior to kernel 3.2.0, the default was 16k, and the maximum size was limited by the CIFSMaxBufSize module parameter. As of kernel 3.2.0, the behavior varies according to whether POSIX extensions are enabled on the mount and the server supports large POSIX reads. If they are, then the default is 1M, and the maxmimum is 16M. If they are not supported by the server, then the default is 60k and the maximum is around 127k. The reason for the 60k is because it's the maximum size read that windows servers can fill. Note that this value is a maximum, and the client may settle on a smaller size to accomodate what the server supports. In kernels prior to 3.2.0, no negotiation is performed.
+Maximum amount of data that the kernel will request in a read request in bytes. Prior to kernel 3.2.0, the default was 16k, and the maximum size was limited by the CIFSMaxBufSize module parameter. As of kernel 3.2.0, the behavior varies according to whether POSIX extensions are enabled on the mount and the server supports large POSIX reads. If they are, then the default is 1M, and the maximum is 16M. If they are not supported by the server, then the default is 60k and the maximum is around 127k. The reason for the 60k is because it's the maximum size read that windows servers can fill. Note that this value is a maximum, and the client may settle on a smaller size to accommodate what the server supports. In kernels prior to 3.2.0, no negotiation is performed.
 .RE
 .PP
 wsize=\fIbytes\fR
@@ -506,7 +506,7 @@ multiuser
 .RS 4
 Map user accesses to individual credentials when accessing the server\&. By default, CIFS mounts only use a single set of user credentials (the mount credentials) when accessing a share\&. With this option, the client instead creates a new session with the server using the user's credentials whenever a new user accesses the mount. Further accesses by that user will also use those credentials\&. Because the kernel cannot prompt for passwords, multiuser mounts are limited to mounts using sec= options that don't require passwords.
 .sp
-With this change, it's feasible for the server to handle permissions enforcement, so this option also implies "noperm"\&. Furthermore, when unix extensions aren't in use and the administrator has not overriden ownership using the uid= or gid= options, ownership of files is presented as the current user accessing the share\&.
+With this change, it's feasible for the server to handle permissions enforcement, so this option also implies "noperm"\&. Furthermore, when unix extensions aren't in use and the administrator has not overridden ownership using the uid= or gid= options, ownership of files is presented as the current user accessing the share\&.
 .RE
 .PP
 actimeo=\fIarg\fR
@@ -605,7 +605,7 @@ mount \-t cifs //server/share /mnt \-\-verbose \-o user=username
 .RE
 .SH "SERVICE FORMATTING AND DELIMITERS"
 .PP
-It\'s generally preferred to use forward slashes (/) as a delimiter in service names\&. They are considered to be the "universal delimiter" since they are generally not allowed to be embedded within path components on Windows machines and the client can convert them to blackslashes (\e) unconditionally\&. Conversely, backslash characters are allowed by POSIX to be part of a path component, and can\'t be automatically converted in the same way\&.
+It\'s generally preferred to use forward slashes (/) as a delimiter in service names\&. They are considered to be the "universal delimiter" since they are generally not allowed to be embedded within path components on Windows machines and the client can convert them to backslashes (\e) unconditionally\&. Conversely, backslash characters are allowed by POSIX to be part of a path component, and can\'t be automatically converted in the same way\&.
 .PP
 mount\&.cifs will attempt to convert backslashes to forward slashes where it\'s able to do so, but it cannot do so in any path component following the sharename\&.
 .SH "INODE NUMBERS"
@@ -753,7 +753,7 @@ If either upcall to cifs.idmap is not setup correctly or winbind is not configur
 .RE
 .SH "ACCESSING FILES WITH BACKUP INTENT"
 .PP
-For an user on the server, desired access to a file is determined by the permissions and rights associated with that file.  This is typically accomplished using owenrship and ACL.  For a user who does not have access rights to a file, it is still possible to access that file for a specific or a targeted purpose by granting special rights.  One of the specific purposes is to access a file with the intent to either backup or restore i.e. backup intent.  The right to access a file with the backup intent can typically be granted by making that user a part of the built-in group Backup Operators.  Thus, when this user attempts to open a file with the backup intent, open request is sent by setting the bit FILE_OPEN_FOR_BACKUP_INTENT as one of the CreateOptions.
+For an user on the server, desired access to a file is determined by the permissions and rights associated with that file.  This is typically accomplished using ownership and ACL.  For a user who does not have access rights to a file, it is still possible to access that file for a specific or a targeted purpose by granting special rights.  One of the specific purposes is to access a file with the intent to either backup or restore i.e. backup intent.  The right to access a file with the backup intent can typically be granted by making that user a part of the built-in group Backup Operators.  Thus, when this user attempts to open a file with the backup intent, open request is sent by setting the bit FILE_OPEN_FOR_BACKUP_INTENT as one of the CreateOptions.
 
 As an example, on a Windows server, a user named testuser, cannot open this file with such a security descriptor.
 .PP
@@ -772,7 +772,7 @@ But the user testuser, if it becomes part of the group Backup Operators, can ope
 Any user on the client side who can authenticate as such a user on the server,
 can access the files with the backup intent. But it is desirable and preferable for security reasons amongst many, to restrict this special right.
 
-The mount option backupuid is used to restrict this special right to a user which is specified by either a name or an id. The mount option backupgid is used to restrict this special right to the users in a group which is specified by either a name or an id. Only users maching either backupuid or backupgid shall attempt to access files with backup intent. These two mount options can be used together.
+The mount option backupuid is used to restrict this special right to a user which is specified by either a name or an id. The mount option backupgid is used to restrict this special right to the users in a group which is specified by either a name or an id. Only users matching either backupuid or backupgid shall attempt to access files with backup intent. These two mount options can be used together.
 .SH "FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS"
 .PP
 The core CIFS protocol does not provide unix ownership information or mode for files and directories\&. Because of this, files and directories will generally appear to be owned by whatever values the uid= or gid= options are set, and will have permissions set to the default file_mode and dir_mode for the mount\&. Attempting to change these values via chmod/chown will return success but have no effect\&.
@@ -783,7 +783,7 @@ If the uid\'s and gid\'s being used do not match on the client and server, the f
 .PP
 When unix extensions are not negotiated, it\'s also possible to emulate them locally on the server using the "dynperm" mount option\&. When this mount option is in effect, newly created files and directories will receive what appear to be proper permissions\&. These permissions are not stored on the server however and can disappear at any time in the future (subject to the whims of the kernel flushing out the inode cache)\&. In general, this mount option is discouraged\&.
 .PP
-It\'s also possible to override permission checking on the client altogether via the noperm option\&. Server\-side permission checks cannot be overriden\&. The permission checks done by the server will always correspond to the credentials used to mount the share, and not necessarily to the user who is accessing the share\&.
+It\'s also possible to override permission checking on the client altogether via the noperm option\&. Server\-side permission checks cannot be overridden\&. The permission checks done by the server will always correspond to the credentials used to mount the share, and not necessarily to the user who is accessing the share\&.
 .SH "ENVIRONMENT VARIABLES"
 .PP
 The variable
@@ -799,7 +799,7 @@ The variable
 may contain the pathname of a file to read the password from\&. A single line of input is read and used as the password\&.
 .SH "NOTES"
 .PP
-This command may be used only by root, unless installed setuid, in which case the noeexec and nosuid mount flags are enabled\&. When installed as a setuid program, the program follows the conventions set forth by the mount program for user mounts, with the added restriction that users must be able to chdir() into the
+This command may be used only by root, unless installed setuid, in which case the noexec and nosuid mount flags are enabled\&. When installed as a setuid program, the program follows the conventions set forth by the mount program for user mounts, with the added restriction that users must be able to chdir() into the
 mountpoint prior to the mount in order to be able to mount onto it.
 .PP
 Some samba client tools like smbclient(8) honour client\-side configuration parameters present in smb\&.conf\&. Unlike those client tools,
-- 
2.10.2
