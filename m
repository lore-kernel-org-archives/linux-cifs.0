From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: add a note about inclusion of
 keys.dns_resolver program in keyutils
Date: Tue, 26 Jul 2011 10:27:52 -0400
Message-ID: <20110726102752.164892b5@tlielax.poochiereds.net>
References: <1311101647-25555-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311101647-25555-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 19 Jul 2011 14:54:07 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> As of version 1.5, the keyutils package is shipping a generic
> dns_resolver upcall. Add a note to the cifs.upcall manpage that mentions
> this and recommends the use of that program over cifs.upcall.
> 
> Eventually, we may want to be able to conditionally compile out the
> dns_resolver part of the upcall, but it's already pretty small and
> wouldn't save us very much.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  cifs.upcall.8.in |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
> index 920b12a..03842b7 100644
> --- a/cifs.upcall.8.in
> +++ b/cifs.upcall.8.in
> @@ -67,7 +67,7 @@ This keytype is for retrieving kerberos session keys
>  .PP
>  dns_resolver
>  .RS 4
> -This key type is for resolving hostnames into IP addresses
> +This key type is for resolving hostnames into IP addresses. Support for this key type may eventually be deprecated (see below).
>  .RE
>  .PP
>  To make this program useful for CIFS, you\'ll need to set up entries for them in request\-key\&.conf(5)\&. Here\'s an example of an entry for each key type:
> @@ -88,11 +88,14 @@ create      dns_resolver   * * @sbindir@/cifs\&.upcall %k
>  See
>  \fBrequest-key.conf\fR(5)
>  for more info on each field\&.
> +
> +The keyutils package has also started including a dns_resolver handling program as well that is preferred over the one in cifs.upcall. If you are using a keyutils version equal to or greater than 1.5, you should use key.dns_resolver to handle the dns_resolver keytype instead of cifs.upcall. See \fBkey.dns_resolver\fR(8) for more info.
>  .SH "SEE ALSO"
>  .PP
>  
>  \fBrequest-key.conf\fR(5),
> -\fBmount.cifs\fR(8)
> +\fBmount.cifs\fR(8),
> +\fBkey.dns_resolver\fR(8)
>  .SH "AUTHOR"
>  .PP
>  Igor Mammedov wrote the cifs\&.upcall program\&.

Committed...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
