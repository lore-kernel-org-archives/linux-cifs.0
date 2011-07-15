From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: manpages - Add contents for mount option
 cifsacl (try #2)
Date: Fri, 15 Jul 2011 13:15:07 -0500
Message-ID: <CADT32eLeax68-p+wrWR-0kmkN2CTVh0MumN2cLo6M4huHOEx5g@mail.gmail.com>
References: <1310751455-19523-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310751455-19523-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jul 15, 2011 at 12:37 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Manpage contents for cifs mount option =A0cifsacl
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0mount.cifs.8 | =A0 33 +++++++++++++++++++++++++++++++++
> =A01 files changed, 33 insertions(+), 0 deletions(-)
>
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 7e0f117..082adcd 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -272,6 +272,39 @@ Do not allow POSIX ACL operations even if server=
 would support them\&.
> =A0The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to S=
amba servers version 3\&.0\&.10 and later\&. Setting POSIX ACLs require=
s enabling both XATTR and then POSIX support in the CIFS configuration =
options when building the cifs module\&. POSIX ACL support can be disab=
led on a per mount basis by specifying "noacl" on mount\&.
> =A0.RE
> =A0.PP
> +cifsacl
> +.RS 4
> +This option is used to map CIFS/NTFS ACLs to/fro Linux permission bi=
ts,
> +map SIDs to/fro UIDs and GIDs, and get and set Security Descriptors\=
&.
> +.sp
> +This option is used to work with file objects which posses Security =
Descriptor
> +and CIFS/NTFS ACL as user authentication model instead of UID, GID,
> +file permission bits, and POSIX ACL as user authentication model on =
mounted
> +shares exported from servers such as Windows.
> +
> +A CIFS/NTFS ACL is mapped to file permission bits using an algorithm=
 specified here
> +.br
> +\t\- http://technet.microsoft.com/en-us/library/bb463216.aspx
> +
> +Mapping SIDs to/fro UIDs and GIDs needs,
> +.br
> +\t\- a kenrel upcall to cifs.idmap utility set up via file /etc/requ=
est-key.conf
> +.br
> +\t\- winbind configured via files /etc/nsswitch.conf and smb.conf
> +Please refer to the respective manpages of cifs.idmap and winbind fo=
r usage.
> +
> +Security Descriptors for a file object can be get and set using
> +extended attribute named system.cifs_acl.
> +
> +Some of the things to consider while using this mount option:
> +.br
> +\t\- Increased latency when handling metadata due to additional requ=
ests to get and set security descriptors.
> +.br
> +\t\- During CIFS/NTFS ACL mapping to/fro Linux file permission bits,=
 it is possible to loose finer granularity available in CIFS/NTFS ACL.
> +.br
> +\t\- If either upcall to cifs.idmap is not setup correctly or winbin=
d is not configured and running, ID mapping will fail. In that case uid=
 and gids will default to either values of uid and/or gid mount options=
 if specified or credentials of the process that mounted the share.
> +.RE
> +.PP
> =A0nocase
> =A0.RS 4
> =A0Request case insensitive path name matching (case sensitive is the=
 default if the server suports it)\&.
> --
> 1.6.0.2
>
>

I probably ought to mention about config options like it is
currently done under mount option noacl.
