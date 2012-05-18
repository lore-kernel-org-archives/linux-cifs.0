From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Move protocol specific part from SendReceive2
 to ops struct
Date: Fri, 18 May 2012 12:35:59 -0400
Message-ID: <20120518123559.208d4730@corrin.poochiereds.net>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
	<1337269424-9494-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337269424-9494-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 17 May 2012 19:43:40 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |    5 +++++
>  fs/cifs/cifsproto.h |    2 ++
>  fs/cifs/smb1ops.c   |    3 +++
>  fs/cifs/transport.c |    7 ++++---
>  4 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index b6e97f8..ff06211 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -157,11 +157,16 @@ enum smb_version {
>  struct mid_q_entry;
>  struct TCP_Server_Info;
>  struct cifsFileInfo;
> +struct cifs_ses;
>  
>  struct smb_version_operations {
>  	int (*send_cancel)(struct TCP_Server_Info *, void *,
>  			   struct mid_q_entry *);
>  	bool (*compare_fids)(struct cifsFileInfo *, struct cifsFileInfo *);
> +	int (*setup_request)(struct cifs_ses *, struct kvec *, unsigned int,
> +			     struct mid_q_entry **);
> +	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
> +			     bool);
>  };
>  
>  struct smb_version_values {
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 0a3fa96..57af642 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -78,6 +78,8 @@ extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
>  			int * /* bytes returned */ , const int long_op);
>  extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
>  			    char *in_buf, int flags);
> +extern int cifs_setup_request(struct cifs_ses *, struct kvec *, unsigned int,
> +			      struct mid_q_entry **);
>  extern int cifs_check_receive(struct mid_q_entry *mid,
>  			struct TCP_Server_Info *server, bool log_error);
>  extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index ce27f86..3b7cf89 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -21,6 +21,7 @@
>  #include "cifsproto.h"
>  #include "cifs_debug.h"
>  #include "cifspdu.h"
> +#include "cifsproto.h"

	^^^^
Holy double-includes, batman! Please fix this before merging.

>  
>  /*
>   * An NT cancel request header looks just like the original request except:
> @@ -69,6 +70,8 @@ cifs_compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob2)
>  struct smb_version_operations smb1_operations = {
>  	.send_cancel = send_nt_cancel,
>  	.compare_fids = cifs_compare_fids,
> +	.setup_request = cifs_setup_request,
> +	.check_receive = cifs_check_receive,
>  };
>  
>  struct smb_version_values smb1_values = {
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 269a5a7..87bd998 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -514,7 +514,7 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>  	return map_smb_to_linux_error(mid->resp_buf, log_error);
>  }
>  
> -static int
> +int
>  cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
>  		   unsigned int nvec, struct mid_q_entry **ret_mid)
>  {
> @@ -577,7 +577,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
>  
>  	mutex_lock(&ses->server->srv_mutex);
>  
> -	rc = cifs_setup_request(ses, iov, n_vec, &midQ);
> +	rc = ses->server->ops->setup_request(ses, iov, n_vec, &midQ);
>  	if (rc) {
>  		mutex_unlock(&ses->server->srv_mutex);
>  		cifs_small_buf_release(buf);
> @@ -640,7 +640,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
>  	else
>  		*pRespBufType = CIFS_SMALL_BUFFER;
>  
> -	rc = cifs_check_receive(midQ, ses->server, flags & CIFS_LOG_ERROR);
> +	rc = ses->server->ops->check_receive(midQ, ses->server,
> +					     flags & CIFS_LOG_ERROR);
>  
>  	/* mark it so buf will not be freed by delete_mid */
>  	if ((flags & CIFS_NO_RESP) == 0)

Looks fine otherwise -- if you just remove the unneeded #include
addition, you can add my:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
