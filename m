From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Reconnect expired SMB sessions
Date: Mon, 10 Jul 2017 15:04:25 +0100
Message-ID: <7ee806d6-9d74-4c13-65f3-e23097211b19@citrix.com>
References: <1499549520-113585-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499549520-113585-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Content-Language: en-CA
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Pavel,

I have one comment/question.

On 07/08/2017 10:32 PM, Pavel Shilovsky wrote:
> According to the MS-SMB2 spec (3.2.5.1.6) once the client receives
> STATUS_NETWORK_SESSION_EXPIRED error code from a server it should
> reconnect the current SMB session. Currently the client doesn't do
> that. This can result in subsequent client requests failing by
> the server. The patch adds an additional logic to the demultiplex
> thread to identify expired sessions and reconnect them.
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |  2 ++
>  fs/cifs/cifssmb.c  |  7 +++++++
>  fs/cifs/connect.c  |  7 +++++++
>  fs/cifs/smb2ops.c  | 23 +++++++++++++++++++++++
>  4 files changed, 39 insertions(+)
> 
[cut]
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index fbb0d4c..72a53bd 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1460,6 +1460,13 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>  		return length;
>  	server->total_read += length;
>  
> +	if (server->ops->is_session_expired &&
> +	    server->ops->is_session_expired(buf)) {
> +		cifs_reconnect(server);
> +		wake_up(&server->response_q);
> +		return -1;
> +	}
> +

Here (but the same applied to the other similar code blocks), as soon as
the session is found expired, there is an attempt to reconnect and -1 is
returned, regardless of the reconnect outcome.

However, according to the specs, if the re-authentication attempt fails
the client must fail the operation and terminate the session.
Is the latter done implicitly, because I cannot see it?

Cheers,
Germano
