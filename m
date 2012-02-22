From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 04/11] CIFS: Delete echo_retries module parm
Date: Wed, 22 Feb 2012 11:23:23 -0500
Message-ID: <20120222112323.3d1afe4b@tlielax.poochiereds.net>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-5-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329895984-9251-5-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 22 Feb 2012 10:32:57 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> It's the essential step before respecting MaxMpxCount value during
> negotiating because we will keep only one extra slot for sending
> echo requests. If there is no response for echo message - reconnect
> the tcp session.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/README     |    6 +-----
>  fs/cifs/cifsfs.c   |    5 -----
>  fs/cifs/cifsglob.h |    3 ---
>  fs/cifs/connect.c  |    7 +++----
>  4 files changed, 4 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/cifs/README b/fs/cifs/README
> index 895da1d..b7d782b 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -753,10 +753,6 @@ module loading or during the runtime by using the interface
>  
>  i.e. echo "value" > /sys/module/cifs/parameters/<param>
>  
> -1. echo_retries - The number of echo attempts before giving up and
> -		  reconnecting to the server. The default is 5. The value 0
> -		  means never reconnect.
> -
> -2. enable_oplocks - Enable or disable oplocks. Oplocks are enabled by default.
> +1. enable_oplocks - Enable or disable oplocks. Oplocks are enabled by default.
>  		    [Y/y/1]. To disable use any of [N/n/0].
>  
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index b1fd382..e1ce1ca 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -77,11 +77,6 @@ unsigned int cifs_max_pending = CIFS_MAX_REQ;
>  module_param(cifs_max_pending, int, 0444);
>  MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
>  				   "Default: 50 Range: 2 to 256");
> -unsigned short echo_retries = 5;
> -module_param(echo_retries, ushort, 0644);
> -MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
> -			       "reconnecting server. Default: 5. 0 means "
> -			       "never reconnect.");
>  module_param(enable_oplocks, bool, 0644);
>  MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool). Default:"
>  				 "y/Y/1");
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 600d61c..674792e 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1049,9 +1049,6 @@ GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
>  GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
>  GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
>  
> -/* reconnect after this many failed echo attempts */
> -GLOBAL_EXTERN unsigned short echo_retries;
> -
>  #ifdef CONFIG_CIFS_ACL
>  GLOBAL_EXTERN struct rb_root uidtree;
>  GLOBAL_EXTERN struct rb_root gidtree;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 673813f..86d7a40 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -373,12 +373,11 @@ allocate_buffers(struct TCP_Server_Info *server)
>  static bool
>  server_unresponsive(struct TCP_Server_Info *server)
>  {
> -	if (echo_retries > 0 && server->tcpStatus == CifsGood &&
> -	    time_after(jiffies, server->lstrp +
> -				(echo_retries * SMB_ECHO_INTERVAL))) {
> +	if (server->tcpStatus == CifsGood &&
> +	    time_after(jiffies, server->lstrp + SMB_ECHO_INTERVAL)) {
>  		cERROR(1, "Server %s has not responded in %d seconds. "
>  			  "Reconnecting...", server->hostname,
> -			  (echo_retries * SMB_ECHO_INTERVAL / HZ));
> +			  SMB_ECHO_INTERVAL / HZ);

This will be a problem since we skip sending an echo when the client
has gotten a response recently (within the last echo interval).

Consider:

1s	client sends a normal smb request
2s	client gets a response
30s	echo workqueue job pops, and decides we got a response
	recently and don't need to send another
...
65s	kernel_recvmsg times out, and we see that we haven't gotten
	a response in >60s

...I think you'll probably want to only reconnect when we haven't
gotten a response in 2 echo intervals? Or maybe there's a better way?

>  		cifs_reconnect(server);
>  		wake_up(&server->response_q);
>  		return true;


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
