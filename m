From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH v2 02/24] CIFS: Rename 7 error codes to NT_ style
Date: Wed, 20 Jun 2012 18:00:28 -0700
Message-ID: <20120620180028.052b33ac@corrin.poochiereds.net>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
	<1340202664-28696-3-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-3-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 20 Jun 2012 18:30:42 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> and consider such codes as CIFS errors.
> 
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/nterr.c |    6 +++---
>  fs/cifs/nterr.h |   26 ++++++++++++++------------
>  2 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/cifs/nterr.c b/fs/cifs/nterr.c
> index 819fd99..908a3c7 100644
> --- a/fs/cifs/nterr.c
> +++ b/fs/cifs/nterr.c
> @@ -31,7 +31,7 @@ const struct nt_err_code_struct nt_errs[] = {
>  	{"NT_STATUS_INVALID_INFO_CLASS", NT_STATUS_INVALID_INFO_CLASS},
>  	{"NT_STATUS_INFO_LENGTH_MISMATCH", NT_STATUS_INFO_LENGTH_MISMATCH},
>  	{"NT_STATUS_ACCESS_VIOLATION", NT_STATUS_ACCESS_VIOLATION},
> -	{"STATUS_BUFFER_OVERFLOW", STATUS_BUFFER_OVERFLOW},
> +	{"STATUS_BUFFER_OVERFLOW", NT_STATUS_BUFFER_OVERFLOW},

Should you also change the text version of these names? Since we print
those when debugging, then it might be nice to have them match the
actual #define names.

>  	{"NT_STATUS_IN_PAGE_ERROR", NT_STATUS_IN_PAGE_ERROR},
>  	{"NT_STATUS_PAGEFILE_QUOTA", NT_STATUS_PAGEFILE_QUOTA},
>  	{"NT_STATUS_INVALID_HANDLE", NT_STATUS_INVALID_HANDLE},
> @@ -681,7 +681,7 @@ const struct nt_err_code_struct nt_errs[] = {
>  	 NT_STATUS_QUOTA_LIST_INCONSISTENT},
>  	{"NT_STATUS_FILE_IS_OFFLINE", NT_STATUS_FILE_IS_OFFLINE},
>  	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
> -	{"STATUS_MORE_ENTRIES", STATUS_MORE_ENTRIES},
> -	{"STATUS_SOME_UNMAPPED", STATUS_SOME_UNMAPPED},
> +	{"STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
> +	{"STATUS_SOME_UNMAPPED", NT_STATUS_SOME_UNMAPPED},
>  	{NULL, 0}
>  };
> diff --git a/fs/cifs/nterr.h b/fs/cifs/nterr.h
> index 2572673..7a0eae5 100644
> --- a/fs/cifs/nterr.h
> +++ b/fs/cifs/nterr.h
> @@ -35,18 +35,20 @@ struct nt_err_code_struct {
>  extern const struct nt_err_code_struct nt_errs[];
>  
>  /* Win32 Status codes. */
> -#define STATUS_MORE_ENTRIES               0x0105
> -#define ERROR_INVALID_PARAMETER		  0x0057
> -#define ERROR_INSUFFICIENT_BUFFER	  0x007a
> -#define STATUS_1804	                  0x070c
> -#define STATUS_NOTIFY_ENUM_DIR            0x010c
> +#define NT_STATUS_MORE_ENTRIES         0x0105
> +#define NT_ERROR_INVALID_PARAMETER     0x0057
> +#define NT_ERROR_INSUFFICIENT_BUFFER   0x007a
> +#define NT_STATUS_1804                 0x070c
> +#define NT_STATUS_NOTIFY_ENUM_DIR      0x010c
>  
> -/* Win32 Error codes extracted using a loop in smbclient then printing a
> -   netmon sniff to a file. */
> +/*
> + * Win32 Error codes extracted using a loop in smbclient then printing a netmon
> + * sniff to a file.
> + */
>  
> -#define NT_STATUS_OK 0x0000
> -#define STATUS_SOME_UNMAPPED       0x0107
> -#define STATUS_BUFFER_OVERFLOW     0x80000005
> +#define NT_STATUS_OK                   0x0000
> +#define NT_STATUS_SOME_UNMAPPED        0x0107
> +#define NT_STATUS_BUFFER_OVERFLOW  0x80000005
>  #define NT_STATUS_NO_MORE_ENTRIES  0x8000001a
>  #define NT_STATUS_MEDIA_CHANGED    0x8000001c
>  #define NT_STATUS_END_OF_MEDIA     0x8000001e


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
