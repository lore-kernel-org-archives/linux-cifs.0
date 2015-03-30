From: Sachin Prabhu <sprabhu@redhat.com>
Subject: Re: [PATCH 4/4] [SMB3] Fix coverity warning
Date: Mon, 30 Mar 2015 10:51:53 +0100
Message-ID: <1427709113.14176.5.camel@redhat.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	 <1427434082-4299-5-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427434082-4299-5-git-send-email-smfrench@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 2015-03-27 at 00:28 -0500, Steve French wrote:
> Coverity reports a warning for referencing the beginning of the
> SMB2/SMB3 frame using the ProtocolId field as an array. Although
> it works the same either way, this patch should quiet the warning
> and might be a little clearer.
> 
> Reported by Coverity (CID 741269)
> 
> Signed-off-by: Steve French <smfrench@gmail.com>

Acked-by: Sachin Prabhu <sprabhu@redhat.com>

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
