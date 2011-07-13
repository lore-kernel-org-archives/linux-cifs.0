From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: manpages - Add contents for mount option
 cifsacl
Date: Wed, 13 Jul 2011 12:50:42 -0400
Message-ID: <20110713125042.58af30f3@tlielax.poochiereds.net>
References: <1310574875-22079-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310574875-22079-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 13 Jul 2011 11:34:35 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Manpage contents for cifs mount option  cifsacl
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mount.cifs.8 |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 7e0f117..6c67b4a 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -272,6 +272,25 @@ Do not allow POSIX ACL operations even if server would support them\&.
>  The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to Samba servers version 3\&.0\&.10 and later\&. Setting POSIX ACLs requires enabling both XATTR and then POSIX support in the CIFS configuration options when building the cifs module\&. POSIX ACL support can be disabled on a per mount basis by specifying "noacl" on mount\&.
>  .RE
>  .PP
> +cifsacl
> +.RS 4
> +Allow operations with file objects which posses CIFS/NTFS ACL and Security Descriptors\&.
> +.sp
> +This option is used to work with file objects which posses CIFS/NTFS ACL
> +instead of POSIX ACL and Security Descriptors on shares mounted from
> +servers such as Windows which do not support unix extensions.
> +

This seems rather vague. Maybe something like:

"This option allows the client to map CIFS/NTFS ACLs to permission mode bits."

Then later, you can specify that if the upcall is properly configured
that it will also map SIDs to UIDs for ownership purposes.

Note that the goal here is to describe this such that someone can
reasonably predict what happens when they turn this on, and make an
informed decision about whether they should do this. It should also
mention the drawbacks of turning it on (increased latency when fetching
metadata, etc). If it's not reasonable to fit this in a synopsis for
the mount option, consider adding a new section (like the "INODE
NUMBERS" section).


> +It is used in conjuction with files /etc/nsswitch.conf and smb.conf
> +and utilities cifs.idmap and winbindd.  Please refer to the manpages
> +for utilities cifs.idmap and winbindd for the usage.
> +

How is it used in conjunction with this? What happens if I enable this
option and don't set up cifs.idmap?

> +For commands which either display or modify unix mode and permissions
> +such as ls, stat, and chmod or commands which modify owner and group
> +such as chown and chgrp, to work on file system objects that belong
> +to shares mounted from servers such as Windows, this mount option
> +is necessary.

Holy run-on-sentences, Batman! Maybe break that up a little?


> +.RE
> +.PP
>  nocase
>  .RS 4
>  Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
