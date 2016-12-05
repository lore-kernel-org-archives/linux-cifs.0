From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] CIFS: Fix missing nls unload in smb2_reconnect()
Date: Mon, 05 Dec 2016 12:18:26 +0530
Message-ID: <1480920506.3464.3.camel@redhat.com>
References: <1480467416-13636-1-git-send-email-pshilov@microsoft.com>
         <1480467416-13636-3-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480467416-13636-3-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2016-11-29 at 16:56 -0800, Pavel Shilovsky wrote:
> Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Acked-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 5ca5ea46..730d57b 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -280,7 +280,7 @@ smb2_reconnect(__le16 smb2_command, struct
> cifs_tcon *tcon)
>  	case SMB2_CHANGE_NOTIFY:
>  	case SMB2_QUERY_INFO:
>  	case SMB2_SET_INFO:
> -		return -EAGAIN;
> +		rc = -EAGAIN;
>  	}
>  	unload_nls(nls_codepage);
>  	return rc;
