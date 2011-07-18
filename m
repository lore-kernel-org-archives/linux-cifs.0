From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] manpage: corrections and cleanups to the cifsacl option sections
Date: Mon, 18 Jul 2011 11:42:01 -0500
Message-ID: <CADT32eJTVxm5a13+_gO8H-94aX9WZmEb3ZtetDUfRvZgb459Pg@mail.gmail.com>
References: <1311006500-9862-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311006500-9862-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 18, 2011 at 11:28 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> ..also update the part that describes what kernel version this manpag=
e
> is accurate against.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0mount.cifs.8 | =A0 22 +++++++++++-----------
> =A01 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 725e88d..ab525af 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -277,8 +277,8 @@ cifsacl
> =A0This option is used to map CIFS/NTFS ACLs to/from Linux permission=
 bits,
> =A0map SIDs to/from UIDs and GIDs, and get and set Security Descripto=
rs\&.
> =A0.sp
> -See section
> -\fICIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRRIPTORS\fR
> +See sections on
> +\fICIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRIPTORS\fR
> =A0for more information\&.
> =A0.RE
> =A0.PP
> @@ -488,12 +488,12 @@ When Unix Extensions are enabled, we use the ac=
tual inode number provided by the
> =A0When Unix Extensions are disabled and "serverino" mount option is =
enabled there is no way to get the server inode number\&. The client ty=
pically maps the server\-assigned "UniqueID" onto an inode number\&.
> =A0.PP
> =A0Note that the UniqueID is a different value from the server inode =
number\&. The UniqueID value is unique over the scope of the entire ser=
ver and is often greater than 2 power 32\&. This value often makes prog=
rams that are not compiled with LFS (Large File Support), to trigger a =
glibc EOVERFLOW error as this won\'t fit in the target structure field\=
&. It is strongly recommended to compile your programs with LFS support=
 (i\&.e\&. with \-D_FILE_OFFSET_BITS=3D64) to prevent this problem\&. Y=
ou can also use "noserverino" mount option to generate inode numbers sm=
aller than 2 power 32 on the client\&. But you may not be able to detec=
t hardlinks properly\&.
> -.SH CIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRRIPTORS
> +.SH CIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRIPTORS
> =A0This option is used to work with file objects which posses Securit=
y Descriptors and CIFS/NTFS ACL instead of UID, GID, file permission bi=
ts, and POSIX ACL as user authentication model. This is the most common=
 authentication model for CIFS servers and is the one used by Windows.
> =A0.sp
> -It needs both XATTR and CIFS_ACL support in the CIFS configuration o=
ptions when building the cifs module.
> +Support for this requires both XATTR and CIFS_ACL support in the CIF=
S configuration options when building the cifs module.
>
> -A CIFS/NTFS ACL is mapped to file permission bits using an algorithm=
 specified here
> +A CIFS/NTFS ACL is mapped to file permission bits using an algorithm=
 specified in the following Microsoft TechNet document:
> =A0.sp
> =A0.RS 4
> =A0.ie n \{\
> @@ -506,7 +506,7 @@ A CIFS/NTFS ACL is mapped to file permission bits=
 using an algorithm specified h
> =A0http://technet.microsoft.com/en-us/library/bb463216.aspx
> =A0.RE
> =A0.sp
> -Mapping SIDs to/from UIDs and GIDs needs
> +In order to map SIDs to/from UIDs and GIDs, the following is require=
d:
> =A0.sp
> =A0.RS 4
> =A0.ie n \{\
> @@ -516,7 +516,7 @@ Mapping SIDs to/from UIDs and GIDs needs
> =A0.sp -1
> =A0.IP \(bu 2.3
> =A0.\}
> -a kernel upcall to the cifs.idmap utility set up via file /etc/reque=
st-key.conf
> +a kernel upcall to the cifs.idmap utility set up via request-key.con=
f(5)
> =A0.RE
> =A0.sp
> =A0.RS 4
> @@ -527,12 +527,12 @@ a kernel upcall to the cifs.idmap utility set u=
p via file /etc/request-key.conf
> =A0.sp -1
> =A0.IP \(bu 2.3
> =A0.\}
> -winbind configured via files /etc/nsswitch.conf and smb.conf
> +winbind support configured via nsswitch.conf(5) and smb.conf(5)
> =A0.PP
> -Please refer to the respective manpages of cifs.idmap(8) and winbind=
d(8) for usage.
> =A0.RE
> +Please refer to the respective manpages of cifs.idmap(8) and winbind=
d(8) for more information.
>
> -Security Descriptors for a file object can be get and set using exte=
nded attribute named system.cifs_acl. The Security Descriptors are "raw=
" blobs of data and need a userspace utility to either parse and format=
 or to assemble it.
> +Security descriptors for a file object can be retrieved and set dire=
ctly using extended attribute named system.cifs_acl. The security descr=
iptors presented via this interface are "raw" blobs of data and need a =
userspace utility to either parse and format or to assemble it.
>
> =A0Some of the things to consider while using this mount option:
> =A0.sp
> @@ -614,7 +614,7 @@ The credentials file does not handle usernames or=
 passwords with leading space\&
> =A0Note that the typical response to a bug report is a suggestion to =
try the latest version first\&. So please try doing that first, and alw=
ays include which versions you use of relevant software when reporting =
bugs (minimum: mount\&.cifs (try mount\&.cifs \-V), kernel (see /proc/v=
ersion) and server type you are trying to contact\&.
> =A0.SH "VERSION"
> =A0.PP
> -This man page is correct for version 1\&.52 of the cifs vfs filesyst=
em (roughly Linux kernel 2\&.6\&.24)\&.
> +This man page is correct for version 1\&.74 of the cifs vfs filesyst=
em (roughly Linux kernel 3\&.0)\&.
> =A0.SH "SEE ALSO"
> =A0.PP
> =A0Documentation/filesystems/cifs\&.txt and fs/cifs/README in the lin=
ux kernel source tree may contain additional options and information\&.
> --
> 1.7.6
>
>

Looks good.  Only one minor nit/change I would suggest is to change
config option XATTR to CIFS_XATTR.
I was thinking I might need one more iteration and so was going to
include it in that next version.
