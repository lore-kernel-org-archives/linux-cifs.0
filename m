From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] manpage: add mount.cifs manpage entry for "multiuser"
 option
Date: Tue, 12 Oct 2010 08:53:33 -0400
Message-ID: <20101012085333.5fc3a9b7@corrin.poochiereds.net>
References: <1286565306-32035-1-git-send-email-jlayton@samba.org>
	<1286565306-32035-2-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286565306-32035-2-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  8 Oct 2010 15:15:06 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.8 |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index d01f2a3..7d2bf69 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -396,6 +396,13 @@ Enable local disk caching using FS-Cache for CIFS\&. This option could be useful
>  NOTE: This feature is available only in the recent kernels that have been built with the kernel config option CONFIG_CIFS_FSCACHE. You also need to have cachefilesd daemon installed and running to make the cache operational\&.
>  .RE
>  .PP
> +multiuser
> +.RS 4
> +Map user accesses to individual credentials when accessing the server\&. By default, CIFS mounts only use a single set of user credentials (the mount credentials) when accessing a share\&. With this option, the client instead creates a new session with the server using the user's credentials whenever a new user accesses the mount. Further accesses by that user will also use those credentials\&. Because the kernel cannot prompt for passwords, multiuser mounts are limited to mounts using sec= options that don't require passwords.
> +.sp
> +With this change, it's feasible for the server to handle permissions enforcement, so this option also implies "noperm"\&. Furthermore, when unix extensions aren't in use and the administrator has not overriden ownership using the uid= or gid= options, ownership of files is presented as the current user accessing the share\&.
> +.RE
> +.PP
>  \-\-verbose
>  .RS 4
>  Print additional debugging information for the mount\&. Note that this parameter must be specified before the \-o\&. For example:

Committed...

I'll probably wait a few days to see if any more patches turn up and
then do a new release later this week or next. Post 'em if you've got
'em.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
