From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] manpage: add some missing options to mount.cifs.8
Date: Tue, 12 Jul 2011 08:22:38 -0400
Message-ID: <20110712082238.39f6178a@tlielax.poochiereds.net>
References: <1310410636-17505-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310410636-17505-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Jul 2011 14:57:16 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Clarify servernetbiosname parameter name, add mention of ignorecase, and
> add a section on noposixpaths.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.8 |   26 +++++++++++++++++++++++++-
>  1 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 0615c3a..7e0f117 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -140,11 +140,16 @@ port=\fIarg\fR
>  sets the port number on which the client will attempt to contact the CIFS server\&. If this value is specified, look for an existing connection with this port, and use that if one exists\&. If one doesn't exist, try to create a new connection on that port\&. If that connection fails, return an error\&. If this value isn't specified, look for an existing connection on port 445 or 139\&. If no such connection exists, try to connect on port 445 first and then port 139 if that fails\&. Return an error if both fail\&.
>  .RE
>  .PP
> -servern=\fIarg\fR
> +servernetbiosname=\fIarg\fR
>  .RS 4
>  Specify the server netbios name (RFC1001 name) to use when attempting to setup a session to the server\&. Although rarely needed for mounting to newer servers, this option is needed for mounting to some older servers (such as OS/2 or Windows 98 and Windows ME) since when connecting over port 139 they, unlike most newer servers, do not support a default server name\&. A server name can be up to 15 characters long and is usually uppercased\&.
>  .RE
>  .PP
> +servern=\fIarg\fR
> +.RS 4
> +Synonym for \fIservernetbiosname\fR.
> +.RE
> +.PP
>  netbiosname=\fIarg\fR
>  .RS 4
>  When mounting to servers via port 139, specifies the RFC1001 source name to use to represent the client netbios machine name when doing the RFC1001 netbios session initialize\&.
> @@ -272,6 +277,11 @@ nocase
>  Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.
>  .RE
>  .PP
> +ignorecase
> +.RS 4
> +Synonym for \fInocase\fR.
> +.RE
> +.PP
>  sec=
>  .RS 4
>  Security mode\&. Allowed values are:
> @@ -436,6 +446,20 @@ positive integer that can hold values between 0 and a maximum value of
>  2^30 * HZ (frequency of timer interrupt) setting\&.
>  .RE
>  .PP
> +noposixpaths
> +.RS 4
> +If unix extensions are enabled on a share, then the client will typically allow
> +filenames to include any character besides '/' in a pathname component, and
> +will use forward slashes as a pathname delimiter. This option prevents the
> +client from attempting to negotiate the use of posix-style pathnames to the
> +server.
> +.RE
> +.PP
> +posixpaths
> +.RS 4
> +Inverse of \fInoposixpaths\fR.
> +.RE
> +.PP
>  \-\-verbose
>  .RS 4
>  Print additional debugging information for the mount\&. Note that this parameter must be specified before the \-o\&. For example:

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
