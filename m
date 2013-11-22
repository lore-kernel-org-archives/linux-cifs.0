From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/9] add struct FILE_STANDARD_INFO
Date: Fri, 22 Nov 2013 09:15:05 -0500
Message-ID: <20131122091505.3c642cc5@tlielax.poochiereds.net>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
	<1385116018-14068-1-git-send-email-gbeck@sernet.de>
	<1385116018-14068-2-git-send-email-gbeck@sernet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-2-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Nov 2013 11:26:50 +0100
Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:

> ---
>  cifspdu.h |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/cifspdu.h b/cifspdu.h
> index 11ca24a..89aa1f2 100644
> --- a/cifspdu.h
> +++ b/cifspdu.h
> @@ -2233,6 +2233,16 @@ typedef struct { /* data block encoding of response to level 263 QPathInfo */
>  	char FileName[1];
>  } __attribute__((packed)) FILE_ALL_INFO;	/* level 0x107 QPathInfo */
>  
> +typedef struct {
> +	__le64 AllocationSize;
> +	__le64 EndOfFile;	/* size ie offset to first free byte in file */
> +	__le32 NumberOfLinks;	/* hard links */
> +	__u8 DeletePending;
> +	__u8 Directory;
> +	__u16 Pad;
> +} __attribute__((packed)) FILE_STANDARD_INFO;	/* level 0x102 QPathInfo */
> +
> +
>  /* defines for enumerating possible values of the Unix type field below */
>  #define UNIX_FILE      0
>  #define UNIX_DIR       1

Looks correct...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
