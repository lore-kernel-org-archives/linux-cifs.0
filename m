From: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Correct comment about domainname length
Date: Fri, 26 Jul 2013 08:40:04 +0800
Message-ID: <51F1C564.5070006@asianux.com>
References: <1374777285-25639-1-git-send-email-scott.lovenberg@gmail.com> <1374777285-25639-2-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374777285-25639-2-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/26/2013 02:34 AM, scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> CIFS_MAX_DOMAINNAME_LEN is the max length for a domain name, not a fully qualified domain name.
> 
> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  include/uapi/linux/cifs/cifs_mount.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/cifs/cifs_mount.h b/include/uapi/linux/cifs/cifs_mount.h
> index a58fc6e..d2408ec 100644
> --- a/include/uapi/linux/cifs/cifs_mount.h
> +++ b/include/uapi/linux/cifs/cifs_mount.h
> @@ -17,7 +17,7 @@
>  #define _CIFS_MOUNT_H
>  
>  /* Max string lengths for cifs mounting options. */
> -#define CIFS_MAX_DOMAINNAME_LEN 256 /* max fully qualified domain name */
> +#define CIFS_MAX_DOMAINNAME_LEN 256 /* max domain name length */
>  #define CIFS_MAX_USERNAME_LEN   256 /* reasonable max for current servers */
>  #define CIFS_MAX_PASSWORD_LEN   512 /* Windows max seems to be 256 wide chars */
>  #define CIFS_MAX_SHARE_LEN      256 /* reasonable max share name length */
> 

For our kernel implementation:

  for 'CIFS_MAX_DOMAINNAME_LEN', it counts 255 + '\0',
  for 'CIFS_MAX_USERNAME_LEN', it counts 256 (may add additional '\0'),

And original mail said about 'CIFS_MAX_DOMAINNAME_LEN':

  "The maximum length of ... the fully qualified domain name (FQDN) is
  63 octets per label and 255 bytes per FQDN. This maximum includes 254
  bytes for the FQDN and one byte for the ending dot."

And excuse me, I do not know what 'CIFS_MAX_USERNAME_LEN' should be.

Do we also need consider about it in our definition comments ?


Thanks.
-- 
Chen Gang
