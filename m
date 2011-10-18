From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Add mount options for backup intent and
 their manpages (try #7)
Date: Tue, 18 Oct 2011 07:29:53 -0400
Message-ID: <20111018072953.1620c71f@corrin.poochiereds.net>
References: <1318106385-8247-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318106385-8247-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat,  8 Oct 2011 15:39:45 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add mount options backupuid and backugid and their manpage contents.
> Check for either a valid uid/gid or valid user/group name.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mount.cifs.8 |   40 ++++++++++++++++++++++++++++
>  mount.cifs.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 120 insertions(+), 2 deletions(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 81ebdbe..9391294 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -282,6 +282,20 @@ See sections on
>  for more information\&.
>  .RE
>  .PP
> +backupuid

Also, the manpage should make this clear that you need to provide an argument here. IOW, "backupuid=arg" 

> +.RS 4
> +Restrict access to files, with the backup intent, to a user\&.
> +.sp
> +See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more details
> +.RE
> +.PP
> +backupgid

...and here...

> +.RS 4
> +Restrict Allow access to files, with the backup intent, to a group\&.
> +.sp
> +See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more details
> +.RE
> +.PP

[...]
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
