From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/5] CIFS: Move protocol specific demultiplex thread
 calls to ops struct
Date: Wed, 23 May 2012 10:10:01 -0400
Message-ID: <20120523101001.652b0724@corrin.poochiereds.net>
References: <1337760406-3015-1-git-send-email-piastry@etersoft.ru>
	<1337760406-3015-5-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337760406-3015-5-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 23 May 2012 12:06:45 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |    6 ++++--
>  fs/cifs/cifs_debug.h |    4 ++--
>  fs/cifs/cifsglob.h   |    6 ++++++
>  fs/cifs/connect.c    |   27 ++++-----------------------
>  fs/cifs/smb1ops.c    |   23 +++++++++++++++++++++++
>  5 files changed, 39 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 8aae8e2..e814052 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -57,19 +57,21 @@ cifs_dump_mem(char *label, void *data, int length)
>  	}
>  }
>  
> -#ifdef CONFIG_CIFS_DEBUG2
>  void cifs_dump_detail(void *buf)
>  {
> +#ifdef CONFIG_CIFS_DEBUG2
>  	struct smb_hdr *smb = (struct smb_hdr *)buf;
>  
>  	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
>  		  smb->Command, smb->Status.CifsError,
>  		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
>  	cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
> +#endif /* CONFIG_CIFS_DEBUG2 */
>  }
>  
>  void cifs_dump_mids(struct TCP_Server_Info *server)
>  {
> +#ifdef CONFIG_CIFS_DEBUG2
>  	struct list_head *tmp;
>  	struct mid_q_entry *mid_entry;
>  
> @@ -102,8 +104,8 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
>  		}
>  	}
>  	spin_unlock(&GlobalMid_Lock);
> -}
>  #endif /* CONFIG_CIFS_DEBUG2 */
> +}
>  
>  #ifdef CONFIG_PROC_FS
>  static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> index 566e0ae..c0c68bb 100644
> --- a/fs/cifs/cifs_debug.h
> +++ b/fs/cifs/cifs_debug.h
> @@ -24,10 +24,10 @@
>  #define _H_CIFS_DEBUG
>  
>  void cifs_dump_mem(char *label, void *data, int length);
> -#ifdef CONFIG_CIFS_DEBUG2
> -#define DBG2 2
>  void cifs_dump_detail(void *);
>  void cifs_dump_mids(struct TCP_Server_Info *);
> +#ifdef CONFIG_CIFS_DEBUG2
> +#define DBG2 2
>  #else
>  #define DBG2 0
>  #endif
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 8251401..1001924 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -175,6 +175,12 @@ struct smb_version_operations {
>  	unsigned int (*read_data_length)(char *);
>  	/* map smb to linux error */
>  	int (*map_error)(char *, bool);
> +	/* find mid corresponding to the response message */
> +	struct mid_q_entry * (*find_mid)(struct TCP_Server_Info *, char *);
> +	void (*dump_detail)(void *);
> +	/* verify the message */
> +	int (*check_message)(char *, unsigned int);
> +	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
>  };
>  
>  struct smb_version_values {
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 65ec6ef..ce033d7 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -783,25 +783,6 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
>  	return false;
>  }
>  
> -static struct mid_q_entry *
> -find_mid(struct TCP_Server_Info *server, char *buffer)
> -{
> -	struct smb_hdr *buf = (struct smb_hdr *)buffer;
> -	struct mid_q_entry *mid;
> -
> -	spin_lock(&GlobalMid_Lock);
> -	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
> -		if (mid->mid == buf->Mid &&
> -		    mid->mid_state == MID_REQUEST_SUBMITTED &&
> -		    le16_to_cpu(mid->command) == buf->Command) {
> -			spin_unlock(&GlobalMid_Lock);
> -			return mid;
> -		}
> -	}
> -	spin_unlock(&GlobalMid_Lock);
> -	return NULL;
> -}
> -
>  void
>  dequeue_mid(struct mid_q_entry *mid, bool malformed)
>  {
> @@ -986,7 +967,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>  	 * 48 bytes is enough to display the header and a little bit
>  	 * into the payload for debugging purposes.
>  	 */
> -	length = checkSMB(buf, server->total_read);
> +	length = server->ops->check_message(buf, server->total_read);
>  	if (length != 0)
>  		cifs_dump_mem("Bad SMB: ", buf,
>  			min_t(unsigned int, server->total_read, 48));
> @@ -1059,7 +1040,7 @@ cifs_demultiplex_thread(void *p)
>  			continue;
>  		server->total_read += length;
>  
> -		mid_entry = find_mid(server, buf);
> +		mid_entry = server->ops->find_mid(server, buf);
>  
>  		if (!mid_entry || !mid_entry->receive)
>  			length = standard_receive3(server, mid_entry);
> @@ -1076,13 +1057,13 @@ cifs_demultiplex_thread(void *p)
>  		if (mid_entry != NULL) {
>  			if (!mid_entry->multiRsp || mid_entry->multiEnd)
>  				mid_entry->callback(mid_entry);
> -		} else if (!is_valid_oplock_break(buf, server)) {
> +		} else if (!server->ops->is_oplock_break(buf, server)) {
>  			cERROR(1, "No task to wake, unknown frame received! "
>  				   "NumMids %d", atomic_read(&midCount));
>  			cifs_dump_mem("Received Data is: ", buf,
>  				      HEADER_SIZE(server));
>  #ifdef CONFIG_CIFS_DEBUG2
> -			cifs_dump_detail(buf);
> +			server->ops->dump_detail(buf);
>  			cifs_dump_mids(server);
>  #endif /* CIFS_DEBUG2 */
>  
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index daa2ede..ddc8ca6 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -81,6 +81,25 @@ cifs_read_data_length(char *buf)
>  	       le16_to_cpu(rsp->DataLength);
>  }
>  
> +static struct mid_q_entry *
> +cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
> +{
> +	struct smb_hdr *buf = (struct smb_hdr *)buffer;
> +	struct mid_q_entry *mid;
> +
> +	spin_lock(&GlobalMid_Lock);
> +	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
> +		if (mid->mid == buf->Mid &&
> +		    mid->mid_state == MID_REQUEST_SUBMITTED &&
> +		    le16_to_cpu(mid->command) == buf->Command) {
> +			spin_unlock(&GlobalMid_Lock);
> +			return mid;
> +		}
> +	}
> +	spin_unlock(&GlobalMid_Lock);
> +	return NULL;
> +}
> +
>  struct smb_version_operations smb1_operations = {
>  	.send_cancel = send_nt_cancel,
>  	.compare_fids = cifs_compare_fids,
> @@ -89,6 +108,10 @@ struct smb_version_operations smb1_operations = {
>  	.read_data_offset = cifs_read_data_offset,
>  	.read_data_length = cifs_read_data_length,
>  	.map_error = map_smb_to_linux_error,
> +	.find_mid = cifs_find_mid,
> +	.check_message = checkSMB,
> +	.dump_detail = cifs_dump_detail,
> +	.is_oplock_break = is_valid_oplock_break,
>  };
>  
>  struct smb_version_values smb1_values = {

Looks fine. I think we could do some more to reduce the amount of
#ifdef crud in this code, but this is ok for now...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
