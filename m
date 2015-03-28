From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH 4/4] [SMB3] Fix coverity warning
Date: Sat, 28 Mar 2015 10:05:41 -0500
Message-ID: <CADT32eJx1eioc_EkH8H1nyjZNkxJSPyRApreU=Sg6X7_oKgbfQ@mail.gmail.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	<1427434082-4299-5-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427434082-4299-5-git-send-email-smfrench@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

On Fri, Mar 27, 2015 at 12:28 AM, Steve French <smfrench@gmail.com> wrote:
> Coverity reports a warning for referencing the beginning of the
> SMB2/SMB3 frame using the ProtocolId field as an array. Although
> it works the same either way, this patch should quiet the warning
> and might be a little clearer.
>
> Reported by Coverity (CID 741269)
>
> Signed-off-by: Steve French <smfrench@gmail.com>
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
>         /* return pointer to beginning of data area, ie offset from SMB start */
>         if ((*off != 0) && (*len != 0))
> -               return hdr->ProtocolId + *off;
> +               return (char *)(&hdr->ProtocolId[0]) + *off;
>         else
>                 return NULL;
>  }
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
