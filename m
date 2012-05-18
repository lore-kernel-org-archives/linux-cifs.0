From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: Move protocol specific demultiplex thread
 calls to ops struct
Date: Fri, 18 May 2012 12:51:53 -0400
Message-ID: <20120518125153.03c3ab34@corrin.poochiereds.net>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
	<1337269424-9494-5-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337269424-9494-5-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 17 May 2012 19:43:43 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    6 ++++++
>  fs/cifs/connect.c  |   27 ++++-----------------------
>  fs/cifs/smb1ops.c  |   26 ++++++++++++++++++++++++++
>  3 files changed, 36 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 080dd86..7b3e8fe 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -170,6 +170,12 @@ struct smb_version_operations {
>  	unsigned int (*read_data_offset)(char *);
>  	unsigned int (*read_data_length)(char *);
>  	int (*map_error)(char *, bool);
> +	struct mid_q_entry * (*find_mid)(struct TCP_Server_Info *, char *);
> +#ifdef CONFIG_CIFS_DEBUG2
> +	void (*dump_detail)(void *);
> +#endif
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


Hmmm, might it be cleaner to unconditionally add the dump_detail
operation to smb_version_operations, and only set it when
CONFIG_CIFS_DEBUG2 is enabled?

With that, you could get rid of the #ifdef clutter in the code above...


> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 31a6111..8a0b35b 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -22,6 +22,7 @@
>  #include "cifs_debug.h"
>  #include "cifspdu.h"
>  #include "cifsproto.h"
> +#include "cifs_debug.h"
>  
>  /*
>   * An NT cancel request header looks just like the original request except:
> @@ -82,6 +83,25 @@ cifs_read_data_length(char *buf)
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
> @@ -90,6 +110,12 @@ struct smb_version_operations smb1_operations = {
>  	.read_data_offset = cifs_read_data_offset,
>  	.read_data_length = cifs_read_data_length,
>  	.map_error = map_smb_to_linux_error,
> +	.find_mid = cifs_find_mid,
> +	.check_message = checkSMB,
> +#ifdef CONFIG_CIFS_DEBUG2
> +	.dump_detail = cifs_dump_detail,
> +#endif
> +	.is_oplock_break = is_valid_oplock_break,
>  };
>  
>  struct smb_version_values smb1_values = {


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
