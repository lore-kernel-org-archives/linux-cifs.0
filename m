From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/1] mount.cifs: document SMBv3.1.1 and new seal
 option
Date: Sat, 22 Apr 2017 10:07:23 -0400
Message-ID: <1492870043.2762.0.camel@redhat.com>
References: <20170421145950.18641-1-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170421145950.18641-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2017-04-21 at 16:59 +0200, Aurelien Aptel wrote:
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  mount.cifs.8 | 16 ++++++++++++++++
>  mount.cifs.c |  2 +-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 9104fae..ab35448 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -440,6 +440,11 @@ The default in mainline kernel versions prior to v3.8 was sec=ntlm. In v3.8, the
>  If the server requires signing during protocol negotiation, then it may be enabled automatically. Packet signing may also be enabled automatically if it's enabled in /proc/fs/cifs/SecurityFlags.
>  .RE
>  .PP
> +seal
> +.RS 4
> +Request encryption at the SMB layer. Encryption is only supported in SMBv3 and above. The encryption algorithm used is AES-128-CCM.
> +.RE
> +.PP
>  nobrl
>  .RS 4
>  Do not send byte range lock requests to the server\&. This is necessary for certain applications that break with cifs style mandatory byte range locks (and most cifs servers do not yet support requesting advisory byte range locks)\&.
> @@ -593,6 +598,17 @@ SMB protocol version. Allowed values are:
>  .\}
>  3.0 - The SMBv3.0 protocol that was introduced in Microsoft Windows 8 and Windows Server 2012.
>  .RE
> +.sp
> +.RS 4
> +.ie n \{\
> +\h'-04'\(bu\h'+03'\c
> +.\}
> +.el \{\
> +.sp -1
> +.IP \(bu 2.3
> +.\}
> +3.1.1 or 3.11 - The SMBv3.1.1 protocol that was introduced in Microsoft Windows Server 2016.
> +.RE
>  .PP
>  Note too that while this option governs the protocol version used, not all features of each version are available.
>  .RE
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 2612feb..8ca848d 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -269,7 +269,7 @@ static int mount_usage(FILE * stream)
>  	fprintf(stream,
>  		"\n\tmapchars,nomapchars,nolock,servernetbiosname=<SRV_RFC1001NAME>");
>  	fprintf(stream,
> -		"\n\tdirectio,nounix,cifsacl,sec=<authentication mechanism>,sign,fsc");
> +		"\n\tdirectio,nounix,cifsacl,sec=<authentication mechanism>,sign,seal,fsc");
>  	fprintf(stream,
>  		"\n\nOptions not needed for servers supporting CIFS Unix extensions");
>  	fprintf(stream,

Thanks! Merged...
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
