From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Indicate reconnect with a parm in read_into_pages
Date: Wed, 9 Jul 2014 09:07:19 -0400
Message-ID: <20140709090719.22dd5a9f@tlielax.poochiereds.net>
References: <1404910127-5249-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404910127-5249-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  9 Jul 2014 16:48:47 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> that lets us not mix EAGAIN error code with reconnect and
> prevent possible errors further.
> 
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |  2 +-
>  fs/cifs/cifsproto.h |  2 +-
>  fs/cifs/cifssmb.c   | 11 ++++++++---
>  fs/cifs/connect.c   | 11 +++++++++--
>  fs/cifs/file.c      | 16 ++++++++++------
>  5 files changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f33ff4c..f57e5bc 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1064,7 +1064,7 @@ struct cifs_readdata {
>  	struct work_struct		work;
>  	int (*read_into_pages)(struct TCP_Server_Info *server,
>  				struct cifs_readdata *rdata,
> -				unsigned int len);
> +				unsigned int len, bool *was_reconnect);
>  	struct kvec			iov;
>  	unsigned int			pagesz;
>  	unsigned int			tailsz;
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index c31ce98..8e4f826 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -184,7 +184,7 @@ extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
>  		     unsigned int to_read);
>  extern int cifs_readv_from_socket(struct TCP_Server_Info *server,
>  		struct kvec *iov_orig, unsigned int nr_segs,
> -		unsigned int to_read);
> +		unsigned int to_read, bool *was_reconnect);
>  extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>  			       struct cifs_sb_info *cifs_sb);
>  extern int cifs_match_super(struct super_block *, void *);
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index e411d2e..6697b78 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1425,6 +1425,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>  	struct cifs_readdata *rdata = mid->callback_data;
>  	char *buf = server->smallbuf;
>  	unsigned int buflen = get_rfc1002_length(buf) + 4;
> +	bool was_reconnect;
>  
>  	cifs_dbg(FYI, "%s: mid=%llu offset=%llu bytes=%u\n",
>  		 __func__, mid->mid, rdata->offset, rdata->bytes);
> @@ -1440,7 +1441,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>  	rdata->iov.iov_base = buf + HEADER_SIZE(server) - 1;
>  	rdata->iov.iov_len = len;
>  
> -	length = cifs_readv_from_socket(server, &rdata->iov, 1, len);
> +	length = cifs_readv_from_socket(server, &rdata->iov, 1, len, NULL);
>  	if (length < 0)
>  		return length;
>  	server->total_read += length;
> @@ -1488,7 +1489,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>  		/* read any junk before data into the rest of smallbuf */
>  		rdata->iov.iov_base = buf + server->total_read;
>  		rdata->iov.iov_len = len;
> -		length = cifs_readv_from_socket(server, &rdata->iov, 1, len);
> +		length = cifs_readv_from_socket(server, &rdata->iov, 1, len,
> +						NULL);
>  		if (length < 0)
>  			return length;
>  		server->total_read += length;
> @@ -1508,7 +1510,10 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>  		return cifs_readv_discard(server, mid);
>  	}
>  
> -	length = rdata->read_into_pages(server, rdata, data_len);
> +	length = rdata->read_into_pages(server, rdata, data_len,
> +					&was_reconnect);
> +	if (was_reconnect)
> +		return -EAGAIN;
>  	if (length < 0)
>  		return length;
>  
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 20d75b8..f6a8107 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -538,13 +538,15 @@ get_server_iovec(struct TCP_Server_Info *server, unsigned int nr_segs)
>  
>  int
>  cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
> -		       unsigned int nr_segs, unsigned int to_read)
> +		       unsigned int nr_segs, unsigned int to_read,
> +		       bool *was_reconnect)
>  {
>  	int length = 0;
>  	int total_read;
>  	unsigned int segs;
>  	struct msghdr smb_msg;
>  	struct kvec *iov;
> +	bool rec = false;
>  
>  	iov = get_server_iovec(server, nr_segs);
>  	if (!iov)
> @@ -557,6 +559,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
>  		try_to_freeze();
>  
>  		if (server_unresponsive(server)) {
> +			rec = true;
>  			total_read = -EAGAIN;
>  			break;
>  		}
> @@ -571,6 +574,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
>  			break;
>  		} else if (server->tcpStatus == CifsNeedReconnect) {
>  			cifs_reconnect(server);
> +			rec = true;
>  			total_read = -EAGAIN;
>  			break;
>  		} else if (length == -ERESTARTSYS ||
> @@ -588,10 +592,13 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
>  			cifs_dbg(FYI, "Received no data or error: expecting %d\n"
>  				 "got %d", to_read, length);
>  			cifs_reconnect(server);
> +			rec = true;
>  			total_read = -EAGAIN;
>  			break;
>  		}
>  	}
> +	if (was_reconnect)
> +		*was_reconnect = rec;
>  	return total_read;
>  }
>  
> @@ -604,7 +611,7 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
>  	iov.iov_base = buf;
>  	iov.iov_len = to_read;
>  
> -	return cifs_readv_from_socket(server, &iov, 1, to_read);
> +	return cifs_readv_from_socket(server, &iov, 1, to_read, NULL);
>  }
>  
>  static bool
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index d5f66ba..d7f5742 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2865,7 +2865,8 @@ cifs_uncached_readv_complete(struct work_struct *work)
>  
>  static int
>  cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
> -			struct cifs_readdata *rdata, unsigned int len)
> +			      struct cifs_readdata *rdata, unsigned int len,
> +			      bool *was_reconnect)
>  {
>  	int total_read = 0, result = 0;
>  	unsigned int i;
> @@ -2900,7 +2901,8 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
>  			continue;
>  		}
>  
> -		result = cifs_readv_from_socket(server, &iov, 1, iov.iov_len);
> +		result = cifs_readv_from_socket(server, &iov, 1, iov.iov_len,
> +						was_reconnect);
>  		kunmap(page);
>  		if (result < 0)
>  			break;
> @@ -2908,7 +2910,7 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
>  		total_read += result;
>  	}
>  
> -	return total_read > 0 && result != -EAGAIN ? total_read : result;
> +	return total_read > 0 ? total_read : result;
>  }
>  
>  static int
> @@ -3287,7 +3289,8 @@ cifs_readv_complete(struct work_struct *work)
>  
>  static int
>  cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
> -			struct cifs_readdata *rdata, unsigned int len)
> +			       struct cifs_readdata *rdata, unsigned int len,
> +			       bool *was_reconnect)
>  {
>  	int total_read = 0, result = 0;
>  	unsigned int i;
> @@ -3350,7 +3353,8 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
>  			continue;
>  		}
>  
> -		result = cifs_readv_from_socket(server, &iov, 1, iov.iov_len);
> +		result = cifs_readv_from_socket(server, &iov, 1, iov.iov_len,
> +						was_reconnect);
>  		kunmap(page);
>  		if (result < 0)
>  			break;
> @@ -3358,7 +3362,7 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
>  		total_read += result;
>  	}
>  
> -	return total_read > 0 && result != -EAGAIN ? total_read : result;
> +	return total_read > 0 ? total_read : result;
>  }
>  
>  static int

Ugh.

It seems like we ought to instead just designate a different error code
than -EAGAIN (-ECONNABORTED?) for the case where a reconnect is needed,
and fix up the callers to handle that appropriately. There aren't that
many callers of cifs_readv_from_socket...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
