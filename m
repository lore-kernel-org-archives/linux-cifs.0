From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] CIFS: Move add/set_credits and get_credits_field to
 ops structure
Date: Fri, 18 May 2012 12:54:39 -0400
Message-ID: <20120518125439.23525985@corrin.poochiereds.net>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
	<1337269424-9494-6-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337269424-9494-6-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 17 May 2012 19:43:44 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |   25 +++++++++++++++----------
>  fs/cifs/cifsproto.h |    3 ---
>  fs/cifs/misc.c      |   19 -------------------
>  fs/cifs/smb1ops.c   |   28 ++++++++++++++++++++++++++++
>  fs/cifs/transport.c |    3 ++-
>  5 files changed, 45 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 7b3e8fe..d17db87 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -167,6 +167,9 @@ struct smb_version_operations {
>  			     struct mid_q_entry **);
>  	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
>  			     bool);
> +	void (*add_credits)(struct TCP_Server_Info *, const unsigned int);
> +	void (*set_credits)(struct TCP_Server_Info *, const int);
> +	int * (*get_credits_field)(struct TCP_Server_Info *);
>  	unsigned int (*read_data_offset)(char *);
>  	unsigned int (*read_data_length)(char *);
>  	int (*map_error)(char *, bool);
> @@ -367,16 +370,6 @@ in_flight(struct TCP_Server_Info *server)
>  	return num;
>  }
>  
> -static inline int*
> -get_credits_field(struct TCP_Server_Info *server)
> -{
> -	/*
> -	 * This will change to switch statement when we reserve slots for echos
> -	 * and oplock breaks.
> -	 */
> -	return &server->credits;
> -}
> -
>  static inline bool
>  has_credits(struct TCP_Server_Info *server, int *credits)
>  {
> @@ -387,6 +380,18 @@ has_credits(struct TCP_Server_Info *server, int *credits)
>  	return num > 0;
>  }
>  
> +static inline void
> +cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add)
> +{
> +	server->ops->add_credits(server, add);
> +}
> +
> +static inline void
> +cifs_set_credits(struct TCP_Server_Info *server, const int val)
> +{
> +	server->ops->set_credits(server, val);
> +}
> +

nit: maybe call these "add_credits and set_credits" and get rid of the
leading '_' on the SMB1 functions below?

>  /*
>   * Macros to allow the TCP_Server_Info->net field and related code to drop out
>   * when CONFIG_NET_NS isn't set.
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 57af642..5ec21ec 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -90,9 +90,6 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
>  			struct smb_hdr *in_buf ,
>  			struct smb_hdr *out_buf,
>  			int *bytes_returned);
> -extern void cifs_add_credits(struct TCP_Server_Info *server,
> -			     const unsigned int add);
> -extern void cifs_set_credits(struct TCP_Server_Info *server, const int val);
>  extern int checkSMB(char *buf, unsigned int length);
>  extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
>  extern bool backup_cred(struct cifs_sb_info *);
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index d2bb1e7..e2552d2 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -653,22 +653,3 @@ backup_cred(struct cifs_sb_info *cifs_sb)
>  
>  	return false;
>  }
> -
> -void
> -cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add)
> -{
> -	spin_lock(&server->req_lock);
> -	server->credits += add;
> -	server->in_flight--;
> -	spin_unlock(&server->req_lock);
> -	wake_up(&server->request_q);
> -}
> -
> -void
> -cifs_set_credits(struct TCP_Server_Info *server, const int val)
> -{
> -	spin_lock(&server->req_lock);
> -	server->credits = val;
> -	server->oplocks = val > 1 ? enable_oplocks : false;
> -	spin_unlock(&server->req_lock);
> -}
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 8a0b35b..17a69ed 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -102,11 +102,39 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
>  	return NULL;
>  }
>  
> +static void
> +_cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add)
> +{
> +	spin_lock(&server->req_lock);
> +	server->credits += add;
> +	server->in_flight--;
> +	spin_unlock(&server->req_lock);
> +	wake_up(&server->request_q);
> +}
> +
> +static void
> +_cifs_set_credits(struct TCP_Server_Info *server, const int val)
> +{
> +	spin_lock(&server->req_lock);
> +	server->credits = val;
> +	server->oplocks = val > 1 ? enable_oplocks : false;
> +	spin_unlock(&server->req_lock);
> +}
> +
> +static int *
> +cifs_get_credits_field(struct TCP_Server_Info *server)
> +{
> +	return &server->credits;
> +}
> +
>  struct smb_version_operations smb1_operations = {
>  	.send_cancel = send_nt_cancel,
>  	.compare_fids = cifs_compare_fids,
>  	.setup_request = cifs_setup_request,
>  	.check_receive = cifs_check_receive,
> +	.add_credits = _cifs_add_credits,
> +	.set_credits = _cifs_set_credits,
> +	.get_credits_field = cifs_get_credits_field,
>  	.read_data_offset = cifs_read_data_offset,
>  	.read_data_length = cifs_read_data_length,
>  	.map_error = map_smb_to_linux_error,
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 87bd998..64c35fd 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -304,7 +304,8 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int optype,
>  static int
>  wait_for_free_request(struct TCP_Server_Info *server, const int optype)
>  {
> -	return wait_for_free_credits(server, optype, get_credits_field(server));
> +	return wait_for_free_credits(server, optype,
> +				     server->ops->get_credits_field(server));
>  }
>  
>  static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,

Other than the minor nit above, this looks fine:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
