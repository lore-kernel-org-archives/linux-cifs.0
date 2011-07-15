From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: manpages - Add contents for mount option
 cifsacl (try #2)
Date: Fri, 15 Jul 2011 14:30:55 -0400
Message-ID: <20110715143055.22a44fc5@tlielax.poochiereds.net>
References: <1310751455-19523-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310751455-19523-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 15 Jul 2011 12:37:35 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Manpage contents for cifs mount option  cifsacl
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mount.cifs.8 |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 7e0f117..082adcd 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -272,6 +272,39 @@ Do not allow POSIX ACL operations even if server would support them\&.
>  The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to Samba servers version 3\&.0\&.10 and later\&. Setting POSIX ACLs requires enabling both XATTR and then POSIX support in the CIFS configuration options when building the cifs module\&. POSIX ACL support can be disabled on a per mount basis by specifying "noacl" on mount\&.
>  .RE
>  .PP
> +cifsacl
> +.RS 4
> +This option is used to map CIFS/NTFS ACLs to/fro Linux permission bits,
					     ^^^^^^
					     to/from ... ditto for the other places in this entry

> +map SIDs to/fro UIDs and GIDs, and get and set Security Descriptors\&.
> +.sp
> +This option is used to work with file objects which posses Security Descriptor
> +and CIFS/NTFS ACL as user authentication model instead of UID, GID,
> +file permission bits, and POSIX ACL as user authentication model on mounted
> +shares exported from servers such as Windows.

^^^ Awkward sentence, how about:

  "This option is used to work with file objects which posses Security Descriptors
  and CIFS/NTFS ACL instead of UID, GID, file permission bits, and POSIX ACL as user
  authentication model. This is the most common authentication model for CIFS servers
  and is the one used by Windows."

> +
> +A CIFS/NTFS ACL is mapped to file permission bits using an algorithm specified here
> +.br
> +\t\- http://technet.microsoft.com/en-us/library/bb463216.aspx
> +

It would be good to mimic the bullets used in the sec= option for consistency's sake.

> +Mapping SIDs to/fro UIDs and GIDs needs,
> +.br
> +\t\- a kenrel upcall to cifs.idmap utility set up via file /etc/request-key.conf
	  ^^^^^^					 ^^^^
	  kernel				"set up for use by request-key(8)"

> +.br
> +\t\- winbind configured via files /etc/nsswitch.conf and smb.conf
> +Please refer to the respective manpages of cifs.idmap and winbind for usage.
> +

When referencing other manpages, you should provide their sections.

> +Security Descriptors for a file object can be get and set using
> +extended attribute named system.cifs_acl.
> +

You might want to mention that those are "raw" ACLs, and require a
userspace program to translate (which doesn't actually exist at this
point in time).

> +Some of the things to consider while using this mount option:
> +.br
> +\t\- Increased latency when handling metadata due to additional requests to get and set security

	"There may be increased latency..."
> descriptors.
> +.br
> +\t\- During CIFS/NTFS ACL mapping to/fro Linux file permission bits, it is possible to loose finer
> granularity available in CIFS/NTFS ACL.

- The mapping between a CIFS/NTFS ACL and POSIX file permission bits is imperfect and some ACL information may be lost in the translation

> +.br
> +\t\- If either upcall to cifs.idmap is not setup correctly or winbind is not configured and running, ID mapping will fail. In that case uid and gids will default to either values of uid and/or gid mount options if specified or credentials of the process that mounted the share.
	^^^^^^^^^^^
How do I know which I will get? Maybe just say that it will default to the default ownership on the share, and refer to the uid= and gid= mount options.

> +.RE
> +.PP
>  nocase
>  .RS 4
>  Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.

This option entry is rather long and it seems like we're probably
omitting some info in order to try and keep it brief. It may be better
to put most of this info into its own section entitled something like
"ACL AND UID/GID MAPPING SUPPORT". Then you can add a smaller entry for
"cifsacl" that says that it enables this support and refers the reader
to your other section for details on what it does.
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
