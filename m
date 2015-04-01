From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 4/4] [SMB3] Fix coverity warning
Date: Tue, 31 Mar 2015 20:38:51 -0400
Message-ID: <20150331203851.26627614@synchrony.poochiereds.net>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	<1427434082-4299-5-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427434082-4299-5-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 Mar 2015 00:28:02 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Coverity reports a warning for referencing the beginning of the
> SMB2/SMB3 frame using the ProtocolId field as an array. Although
> it works the same either way, this patch should quiet the warning
> and might be a little clearer.
> 
> Reported by Coverity (CID 741269)
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/smb2misc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 689f035..22dfdf1 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -322,7 +322,7 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
>  
>  	/* return pointer to beginning of data area, ie offset from SMB start */
>  	if ((*off != 0) && (*len != 0))
> -		return hdr->ProtocolId + *off;
> +		return (char *)(&hdr->ProtocolId[0]) + *off;
>  	else
>  		return NULL;
>  }

Acked-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
