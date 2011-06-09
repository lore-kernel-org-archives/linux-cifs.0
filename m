From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify cifs_demultiplex_thread
Date: Thu, 9 Jun 2011 07:54:11 -0400
Message-ID: <20110609075411.040bf5d1@corrin.poochiereds.net>
References: <1307609933-5632-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1307609933-5632-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu,  9 Jun 2011 12:58:52 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Move several code blocks to separate functions:
> 1) buffer allocations,
> 2) rfc1002 header check,
> 3) read whole smb message from socket,
> 4) find mid owner.
> 
> Signed-off-by: Pavel Shilovsky <piastry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |    1 -
>  fs/cifs/connect.c    |  440 ++++++++++++++++++++++++++++----------------------
>  2 files changed, 247 insertions(+), 194 deletions(-)
> 

Nice. This is long overdue.

That said, speaking from the experience of having to chase down subtle
bugs in this code before, I think this would be best done as a set of
patches so that we can potentially bisect in case this breaks
something. Maybe break out each function in a separate patch?

The main reason that I've not done this before is that the code doesn't
lend itself well to separate functions. You've "solved" that here with a
lot of pointer passing. That breaks up the code into separate functions
but doesn't really clean up the code. So let's consider this a good
starting point, but more work is really needed here.

> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 2fe3cf1..c4fc68a 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -66,7 +66,6 @@ void cifs_dump_detail(struct smb_hdr *smb)
>  	cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
>  }
>  
> -
>  void cifs_dump_mids(struct TCP_Server_Info *server)
>  {
>  	struct list_head *tmp;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index fb31c2c..23addcb 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -317,24 +317,234 @@ requeue_echo:
>  	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
>  }
>  
> +static struct mid_q_entry *
> +find_cifs_owner(struct TCP_Server_Info *server, struct smb_hdr *buf,
> +		int *length, bool isLargeBuf, bool *isMultiRsp, char **pbigbuf)

This function name seems a little odd. Would find_cifs_mid be better?

Usually when I see a lot of pointer argument passing like this in a
function, that's a red flag to me of a poor design. In this case,
that's not really your fault as this code was already a mess. So, I'm
ok with this in principle as it might make it easier to clean up this
code later.

While we're considering overhauling this code -- perhaps, long-term we
should move this to be a state machine?

> +{
> +	struct list_head *tmp, *tmp2;
> +	struct mid_q_entry *mid_entry = NULL;
> +
> +	spin_lock(&GlobalMid_Lock);
> +	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
> +		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> +
> +		if (mid_entry->mid != buf->Mid ||
> +		    mid_entry->midState != MID_REQUEST_SUBMITTED ||
> +		    mid_entry->command != buf->Command) {
> +			mid_entry = NULL;
> +			continue;
> +		}
> +
> +		if (*length == 0 && check2ndT2(buf, server->maxBuf) > 0) {
> +			/* We have a multipart transact2 resp */
> +			*isMultiRsp = true;
> +			if (mid_entry->resp_buf) {
> +				/* merge response - fix up 1st*/
> +				*length = coalesce_t2(buf, mid_entry->resp_buf);
> +				if (*length > 0) {
> +					*length = 0;
> +					mid_entry->multiRsp = true;
> +					break;
> +				} else {
> +					/* all parts received or
> +					 * packet is malformed
> +					 */
> +					mid_entry->multiEnd = true;
> +					goto multi_t2_fnd;
> +				}
> +			} else {
> +				if (!isLargeBuf) {
> +					/*
> +					 * FIXME: switch to already
> +					 *        allocated largebuf?
> +					 */
> +					cERROR(1, "1st trans2 resp "
> +						  "needs bigbuf");
> +				} else {
> +					/* Have first buffer */
> +					mid_entry->resp_buf = buf;
> +					mid_entry->largeBuf = true;
> +					*pbigbuf = NULL;
> +				}
> +			}
> +			break;
> +		}
> +		mid_entry->resp_buf = buf;
> +		mid_entry->largeBuf = isLargeBuf;
> +multi_t2_fnd:
> +		if (*length == 0)
> +			mid_entry->midState = MID_RESPONSE_RECEIVED;
> +		else
> +			mid_entry->midState = MID_RESPONSE_MALFORMED;
> +#ifdef CONFIG_CIFS_STATS2
> +		mid_entry->when_received = jiffies;
> +#endif
> +		list_del_init(&mid_entry->qhead);
> +		break;
> +	}
> +	spin_unlock(&GlobalMid_Lock);
> +
> +	return mid_entry;
> +}
> +
> +static int
> +check_rfc1002_header(struct TCP_Server_Info *server, char *buf, int length,
> +		     unsigned int pdu_length, struct socket **psocket)

I don't think you really need psocket here. That should just be
server->ssocket. For that matter, pdu_length should be readable from
buf, and "length" is always going to be 4 anyway, right?

> +{
> +	char temp = *buf;
> +
> +	/*
> +	 * The first byte big endian of the length field,
> +	 * is actually not part of the length but the type
> +	 * with the most common, zero, as regular data.
> +	 */
> +	if (temp == (char) RFC1002_SESSION_KEEP_ALIVE) {
> +		return 1;
> +	} else if (temp == (char)RFC1002_POSITIVE_SESSION_RESPONSE) {
> +		cFYI(1, "Good RFC 1002 session rsp");
> +		return 1;
> +	} else if (temp == (char)RFC1002_NEGATIVE_SESSION_RESPONSE) {
> +		/* we get this from Windows 98 instead of
> +		   an error on SMB negprot response */
> +		cFYI(1, "Negative RFC1002 Session Response Error 0x%x)",
> +			pdu_length);
> +		/* give server a second to clean up  */
> +		msleep(1000);
> +		/* always try 445 first on reconnect since we get NACK
> +		 * on some if we ever connected to port 139 (the NACK
> +		 * is since we do not begin with RFC1001 session
> +		 * initialize frame)
> +		 */
> +		cifs_set_port((struct sockaddr *)
> +				&server->dstaddr, CIFS_PORT);
> +		cifs_reconnect(server);
> +		*psocket = server->ssocket;
> +		wake_up(&server->response_q);
> +		return 1;
> +	} else if (temp != (char) 0) {
> +		cERROR(1, "Unknown RFC 1002 frame");
> +		cifs_dump_mem(" Received Data: ", buf, length);
> +		cifs_reconnect(server);
> +		*psocket = server->ssocket;
> +		return 1;
> +	}
> +
> +	/* else we have an SMB response */
> +	if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) ||
> +	    (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
> +		cERROR(1, "Invalid size SMB length %d pdu_length %d",
> +		       length, pdu_length+4);
> +		cifs_reconnect(server);
> +		*psocket = server->ssocket;
> +		wake_up(&server->response_q);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +allocate_bufs(char **pbigbuf, char **psmallbuf, unsigned int size,
> +	      bool isLargeBuf)
   ^^^
nit: This can probably be a bool return.

> +{
> +	char *bigbuf = *pbigbuf, *smallbuf = *psmallbuf;
> +
> +	if (bigbuf == NULL) {
> +		bigbuf = (char *)cifs_buf_get();
> +		if (!bigbuf) {
> +			cERROR(1, "No memory for large SMB response");
> +			msleep(3000);
> +			/* retry will check if exiting */
> +			return 1;
> +		}
> +	} else if (isLargeBuf) {
> +		/* we are reusing a dirty large buf, clear its start */
> +		memset(bigbuf, 0, size);
> +	}
> +
> +	if (smallbuf == NULL) {
> +		smallbuf = (char *)cifs_small_buf_get();
> +		if (!smallbuf) {
> +			cERROR(1, "No memory for SMB response");
> +			msleep(1000);
> +			/* retry will check if exiting */
> +			return 1;
> +		}
> +		/* beginning of smb buffer is cleared in our buf_get */
> +	} else /* if existing small buf clear beginning */
> +		memset(smallbuf, 0, size);
> +
> +	*pbigbuf = bigbuf;
> +	*psmallbuf = smallbuf;
> +
> +	return 0;
> +}
> +
	^^^
The buffer handling could really stand to be redesigned, but splitting
it out into a separate function is a decent start.

> +static int
> +read_from_socket(struct TCP_Server_Info *server, unsigned int pdu_length,
> +		 struct socket **psocket, struct msghdr *smb_msg,
> +		 struct kvec *iov, unsigned int *ptotal_read)
> +{
> +	int length, rc = 0;
> +	unsigned int total_read;
> +
> +	for (total_read = 0; total_read < pdu_length;
> +	     total_read += length) {
> +		length = kernel_recvmsg(*psocket, smb_msg, iov, 1,
> +					pdu_length - total_read, 0);
> +		if (server->tcpStatus == CifsExiting) {
> +			/* then will exit */
> +			rc = 2;
> +			break;
> +		} else if (server->tcpStatus == CifsNeedReconnect) {
> +			cifs_reconnect(server);
> +			*psocket = server->ssocket;
> +			/* Reconnect wakes up rspns q */
> +			/* Now we will reread sock */
> +			rc = 1;
> +			break;
> +		} else if (length == -ERESTARTSYS ||
> +			   length == -EAGAIN ||
> +			   length == -EINTR) {
> +			/*
> +			 * Minimum sleep to prevent looping,
> +			 * allowing socket to clear and app
> +			 * threads to set tcpStatus
> +			 * CifsNeedReconnect if server hung.
> +			 */
> +			usleep_range(1000, 2000);
> +			length = 0;
> +			continue;
> +		} else if (length <= 0) {
> +			cERROR(1, "Received no data, expecting %d",
> +				      pdu_length - total_read);
> +			cifs_reconnect(server);
> +			*psocket = server->ssocket;
> +			rc = 1;
> +			break;
> +		}
> +	}
> +
> +	*ptotal_read = total_read;
> +	return 0;
> +}
> +
>  static int
>  cifs_demultiplex_thread(struct TCP_Server_Info *server)
>  {
>  	int length;
>  	unsigned int pdu_length, total_read;
> +	char *buf = NULL, *smallbuf = NULL, *bigbuf = NULL;
>  	struct smb_hdr *smb_buffer = NULL;
> -	struct smb_hdr *bigbuf = NULL;
> -	struct smb_hdr *smallbuf = NULL;
>  	struct msghdr smb_msg;
>  	struct kvec iov;
>  	struct socket *csocket = server->ssocket;
>  	struct list_head *tmp, *tmp2;
>  	struct task_struct *task_to_wake = NULL;
>  	struct mid_q_entry *mid_entry;
> -	char temp;
>  	bool isLargeBuf = false;
>  	bool isMultiRsp;
> -	int reconnect;
> +	int rc;
>  
>  	current->flags |= PF_MEMALLOC;
>  	cFYI(1, "Demultiplex PID: %d", task_pid_nr(current));
> @@ -348,35 +558,17 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
>  	while (server->tcpStatus != CifsExiting) {
>  		if (try_to_freeze())
>  			continue;
> -		if (bigbuf == NULL) {
> -			bigbuf = cifs_buf_get();
> -			if (!bigbuf) {
> -				cERROR(1, "No memory for large SMB response");
> -				msleep(3000);
> -				/* retry will check if exiting */
> -				continue;
> -			}
> -		} else if (isLargeBuf) {
> -			/* we are reusing a dirty large buf, clear its start */
> -			memset(bigbuf, 0, sizeof(struct smb_hdr));
> -		}
>  
> -		if (smallbuf == NULL) {
> -			smallbuf = cifs_small_buf_get();
> -			if (!smallbuf) {
> -				cERROR(1, "No memory for SMB response");
> -				msleep(1000);
> -				/* retry will check if exiting */
> -				continue;
> -			}
> -			/* beginning of smb buffer is cleared in our buf_get */
> -		} else /* if existing small buf clear beginning */
> -			memset(smallbuf, 0, sizeof(struct smb_hdr));
> +		rc = allocate_bufs(&bigbuf, &smallbuf, sizeof(struct smb_hdr),
> +				   isLargeBuf);
> +		if (rc)
> +			continue;
>  
>  		isLargeBuf = false;
>  		isMultiRsp = false;
> -		smb_buffer = smallbuf;
> -		iov.iov_base = smb_buffer;
> +		smb_buffer = (struct smb_hdr *)smallbuf;
> +		buf = smallbuf;
> +		iov.iov_base = smallbuf;
>  		iov.iov_len = 4;
>  		smb_msg.msg_control = NULL;
>  		smb_msg.msg_controllen = 0;
> @@ -414,8 +606,7 @@ incomplete_rcv:
>  				allowing socket to clear and app threads to set
>  				tcpStatus CifsNeedReconnect if server hung */
>  			if (pdu_length < 4) {
> -				iov.iov_base = (4 - pdu_length) +
> -							(char *)smb_buffer;
> +				iov.iov_base = (4 - pdu_length) + buf;
>  				iov.iov_len = pdu_length;
>  				smb_msg.msg_control = NULL;
>  				smb_msg.msg_controllen = 0;

		Should the above code be using read_from_socket() as
		well? It would be nice if we had a single function that
		we always called to do reads off the socket and simply
		check the return value from that. That may be reasonable
		for a later patch.

> @@ -440,114 +631,42 @@ incomplete_rcv:
>  		/* The right amount was read from socket - 4 bytes */
>  		/* so we can now interpret the length field */
>  
> -		/* the first byte big endian of the length field,
> -		is actually not part of the length but the type
> -		with the most common, zero, as regular data */
> -		temp = *((char *) smb_buffer);
> -
> -		/* Note that FC 1001 length is big endian on the wire,
> -		but we convert it here so it is always manipulated
> -		as host byte order */
> +		/*
> +		 * Note that FC 1001 length is big endian on the wire,
			    ^^^
			nit: might as well add the missing "R" here
> +		 * but we convert it here so it is always manipulated
> +		 * as host byte order
> +		 */
>  		pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
> -
> -		cFYI(1, "rfc1002 length 0x%x", pdu_length+4);
> -
> -		if (temp == (char) RFC1002_SESSION_KEEP_ALIVE) {
> -			continue;
> -		} else if (temp == (char)RFC1002_POSITIVE_SESSION_RESPONSE) {
> -			cFYI(1, "Good RFC 1002 session rsp");
> -			continue;
> -		} else if (temp == (char)RFC1002_NEGATIVE_SESSION_RESPONSE) {
> -			/* we get this from Windows 98 instead of
> -			   an error on SMB negprot response */
> -			cFYI(1, "Negative RFC1002 Session Response Error 0x%x)",
> -				pdu_length);
> -			/* give server a second to clean up  */
> -			msleep(1000);
> -			/* always try 445 first on reconnect since we get NACK
> -			 * on some if we ever connected to port 139 (the NACK
> -			 * is since we do not begin with RFC1001 session
> -			 * initialize frame)
> -			 */
> -			cifs_set_port((struct sockaddr *)
> -					&server->dstaddr, CIFS_PORT);
> -			cifs_reconnect(server);
> -			csocket = server->ssocket;
> -			wake_up(&server->response_q);
> -			continue;
> -		} else if (temp != (char) 0) {
> -			cERROR(1, "Unknown RFC 1002 frame");
> -			cifs_dump_mem(" Received Data: ", (char *)smb_buffer,
> -				      length);
> -			cifs_reconnect(server);
> -			csocket = server->ssocket;
> -			continue;
> -		}
> -
> -		/* else we have an SMB response */
> -		if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) ||
> -			    (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
> -			cERROR(1, "Invalid size SMB length %d pdu_length %d",
> -					length, pdu_length+4);
> -			cifs_reconnect(server);
> -			csocket = server->ssocket;
> -			wake_up(&server->response_q);
> +		rc = check_rfc1002_header(server, buf, length, pdu_length,
> +					  &csocket);
> +		if (rc)
>  			continue;
> -		}
>  
> -		/* else length ok */
> -		reconnect = 0;
> +		cFYI(1, "rfc1002 length 0x%x", pdu_length+4);
>  
>  		if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
>  			isLargeBuf = true;
>  			memcpy(bigbuf, smallbuf, 4);
> -			smb_buffer = bigbuf;
> +			smb_buffer = (struct smb_hdr *)bigbuf;
> +			buf = bigbuf;
>  		}
> -		length = 0;
> -		iov.iov_base = 4 + (char *)smb_buffer;
> +
> +		iov.iov_base = 4 + buf;
>  		iov.iov_len = pdu_length;
> -		for (total_read = 0; total_read < pdu_length;
> -		     total_read += length) {
> -			length = kernel_recvmsg(csocket, &smb_msg, &iov, 1,
> -						pdu_length - total_read, 0);
> -			if (server->tcpStatus == CifsExiting) {
> -				/* then will exit */
> -				reconnect = 2;
> -				break;
> -			} else if (server->tcpStatus == CifsNeedReconnect) {
> -				cifs_reconnect(server);
> -				csocket = server->ssocket;
> -				/* Reconnect wakes up rspns q */
> -				/* Now we will reread sock */
> -				reconnect = 1;
> -				break;
> -			} else if (length == -ERESTARTSYS ||
> -				   length == -EAGAIN ||
> -				   length == -EINTR) {
> -				msleep(1); /* minimum sleep to prevent looping,
> -					      allowing socket to clear and app
> -					      threads to set tcpStatus
> -					      CifsNeedReconnect if server hung*/
> -				length = 0;
> -				continue;
> -			} else if (length <= 0) {
> -				cERROR(1, "Received no data, expecting %d",
> -					      pdu_length - total_read);
> -				cifs_reconnect(server);
> -				csocket = server->ssocket;
> -				reconnect = 1;
> -				break;
> -			}
> -		}
> -		if (reconnect == 2)
> +		rc = read_from_socket(server, pdu_length, &csocket, &smb_msg,
> +				      &iov, &total_read);
> +		if (rc == 2)
>  			break;
> -		else if (reconnect == 1)
> +		else if (rc == 1)
>  			continue;
>  
>  		total_read += 4; /* account for rfc1002 hdr */
>  
>  		dump_smb(smb_buffer, total_read);
>  
> +		server->lstrp = jiffies;
> +		length = 0;
> +
>  		/*
>  		 * We know that we received enough to get to the MID as we
>  		 * checked the pdu_length earlier. Now check to see
> @@ -559,75 +678,11 @@ incomplete_rcv:
>  		 */
>  		length = checkSMB(smb_buffer, smb_buffer->Mid, total_read);
>  		if (length != 0)
> -			cifs_dump_mem("Bad SMB: ", smb_buffer,
> -					min_t(unsigned int, total_read, 48));
> -
> -		mid_entry = NULL;
> -		server->lstrp = jiffies;
> -
> -		spin_lock(&GlobalMid_Lock);
> -		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
> -			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> -
> -			if (mid_entry->mid != smb_buffer->Mid ||
> -			    mid_entry->midState != MID_REQUEST_SUBMITTED ||
> -			    mid_entry->command != smb_buffer->Command) {
> -				mid_entry = NULL;
> -				continue;
> -			}
> -
> -			if (length == 0 &&
> -			    check2ndT2(smb_buffer, server->maxBuf) > 0) {
> -				/* We have a multipart transact2 resp */
> -				isMultiRsp = true;
> -				if (mid_entry->resp_buf) {
> -					/* merge response - fix up 1st*/
> -					length = coalesce_t2(smb_buffer,
> -							mid_entry->resp_buf);
> -					if (length > 0) {
> -						length = 0;
> -						mid_entry->multiRsp = true;
> -						break;
> -					} else {
> -						/* all parts received or
> -						 * packet is malformed
> -						 */
> -						mid_entry->multiEnd = true;
> -						goto multi_t2_fnd;
> -					}
> -				} else {
> -					if (!isLargeBuf) {
> -						/*
> -						 * FIXME: switch to already
> -						 *        allocated largebuf?
> -						 */
> -						cERROR(1, "1st trans2 resp "
> -							  "needs bigbuf");
> -					} else {
> -						/* Have first buffer */
> -						mid_entry->resp_buf =
> -							 smb_buffer;
> -						mid_entry->largeBuf = true;
> -						bigbuf = NULL;
> -					}
> -				}
> -				break;
> -			}
> -			mid_entry->resp_buf = smb_buffer;
> -			mid_entry->largeBuf = isLargeBuf;
> -multi_t2_fnd:
> -			if (length == 0)
> -				mid_entry->midState = MID_RESPONSE_RECEIVED;
> -			else
> -				mid_entry->midState = MID_RESPONSE_MALFORMED;
> -#ifdef CONFIG_CIFS_STATS2
> -			mid_entry->when_received = jiffies;
> -#endif
> -			list_del_init(&mid_entry->qhead);
> -			break;
> -		}
> -		spin_unlock(&GlobalMid_Lock);
> +			cifs_dump_mem("Bad SMB: ", buf,
> +				      min_t(unsigned int, total_read, 48));
>  
> +		mid_entry = find_cifs_owner(server, smb_buffer, &length,
> +					    isLargeBuf, &isMultiRsp, &bigbuf);
>  		if (mid_entry != NULL) {
>  			mid_entry->callback(mid_entry);
>  			/* Was previous buf put in mpx struct for multi-rsp? */
> @@ -645,13 +700,12 @@ multi_t2_fnd:
>  			   !isMultiRsp) {
>  			cERROR(1, "No task to wake, unknown frame received! "
>  				   "NumMids %d", atomic_read(&midCount));
> -			cifs_dump_mem("Received Data is: ", (char *)smb_buffer,
> +			cifs_dump_mem("Received Data is: ", buf,
>  				      sizeof(struct smb_hdr));
>  #ifdef CONFIG_CIFS_DEBUG2
>  			cifs_dump_detail(smb_buffer);
>  			cifs_dump_mids(server);
>  #endif /* CIFS_DEBUG2 */
> -
>  		}
>  	} /* end while !EXITING */
>  

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
