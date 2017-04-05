From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] CIFS: queue 'reconnect' thread with a delay
Date: Wed, 05 Apr 2017 19:07:02 +0100
Message-ID: <1491415622.18814.6.camel@redhat.com>
References: <1490743614-5439-2-git-send-email-germano.percossi@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org,
        smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490743614-5439-2-git-send-email-germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2017-03-29 at 00:26 +0100, Germano Percossi wrote:
> All the other threads are queue with a delay, no reason
> why this one need to be so aggressive.

Is there any reason to queue with a delay? Is there a problem with
reconnecting immediately?

Sachin Prabhu

> 
> Signed-off-by: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 7446496..efe167c 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -258,7 +258,7 @@ smb2_reconnect(__le16 smb2_command, struct
> cifs_tcon *tcon)
>  		goto out;
>  
>  	if (smb2_command != SMB2_INTERNAL_CMD)
> -		queue_delayed_work(cifsiod_wq, &server->reconnect,
> 0);
> +		queue_delayed_work(cifsiod_wq, &server->reconnect, 2
> * HZ);
>  
>  	atomic_inc(&tconInfoReconnectCount);
>  out:
> @@ -2231,7 +2231,7 @@ SMB2_echo(struct TCP_Server_Info *server)
>  
>  	if (server->tcpStatus == CifsNeedNegotiate) {
>  		/* No need to send echo on newly established
> connections */
> -		queue_delayed_work(cifsiod_wq, &server->reconnect,
> 0);
> +		queue_delayed_work(cifsiod_wq, &server->reconnect, 2
> * HZ);
>  		return rc;
>  	}
>  
