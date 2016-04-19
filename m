From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 3/6] cifs: quit playing games with draining iovecs
Date: Tue, 19 Apr 2016 13:53:17 -0400
Message-ID: <1461088397.15135.9.camel@poochiereds.net>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
	 <20160409205129.GI25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160409205129.GI25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2016-04-09 at 21:51 +0100, Al Viro wrote:
> ... and use ITER_BVEC for the page part of request to send
>=20
> Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
> =C2=A0fs/cifs/cifsproto.h |=C2=A0=C2=A0=C2=A02 -
> =C2=A0fs/cifs/transport.c | 141 +++++++++++++++----------------------=
-----
> ----------
> =C2=A02 files changed, 41 insertions(+), 102 deletions(-)
>=20
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index d9b4f44..7d5f53a 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -37,8 +37,6 @@ extern void cifs_buf_release(void *);
> =C2=A0extern struct smb_hdr *cifs_small_buf_get(void);
> =C2=A0extern void cifs_small_buf_release(void *);
> =C2=A0extern void free_rsp_buf(int, void *);
> -extern void cifs_rqst_page_to_kvec(struct smb_rqst *rqst, unsigned
> int idx,
> -					struct kvec *iov);
> =C2=A0extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
> =C2=A0			unsigned int /* length */);
> =C2=A0extern unsigned int _get_xid(void);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 87abe8e..206a597 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -124,41 +124,32 @@ cifs_delete_mid(struct mid_q_entry *mid)
> =C2=A0/*
> =C2=A0 * smb_send_kvec - send an array of kvecs to the server
> =C2=A0 * @server:	Server to send the data to
> - * @iov:	Pointer to array of kvecs
> - * @n_vec:	length of kvec array
> + * @smb_msg:	Message to send
> =C2=A0 * @sent:	amount of data sent on socket is stored here
> =C2=A0 *
> =C2=A0 * Our basic "send data to server" function. Should be called w=
ith
> srv_mutex
> =C2=A0 * held. The caller is responsible for handling the results.
> =C2=A0 */
> =C2=A0static int
> -smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov,
> size_t n_vec,
> -		size_t *sent)
> +smb_send_kvec(struct TCP_Server_Info *server, struct msghdr
> *smb_msg,
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0size_t *sent)
> =C2=A0{
> =C2=A0	int rc =3D 0;
> -	int i =3D 0;
> -	struct msghdr smb_msg;
> -	unsigned int remaining;
> -	size_t first_vec =3D 0;
> +	int retries =3D 0;
> =C2=A0	struct socket *ssocket =3D server->ssocket;
> =C2=A0
> =C2=A0	*sent =3D 0;
> =C2=A0
> -	smb_msg.msg_name =3D (struct sockaddr *) &server->dstaddr;
> -	smb_msg.msg_namelen =3D sizeof(struct sockaddr);
> -	smb_msg.msg_control =3D NULL;
> -	smb_msg.msg_controllen =3D 0;
> +	smb_msg->msg_name =3D (struct sockaddr *) &server->dstaddr;
> +	smb_msg->msg_namelen =3D sizeof(struct sockaddr);
> +	smb_msg->msg_control =3D NULL;
> +	smb_msg->msg_controllen =3D 0;
> =C2=A0	if (server->noblocksnd)
> -		smb_msg.msg_flags =3D MSG_DONTWAIT + MSG_NOSIGNAL;
> +		smb_msg->msg_flags =3D MSG_DONTWAIT + MSG_NOSIGNAL;
> =C2=A0	else
> -		smb_msg.msg_flags =3D MSG_NOSIGNAL;
> -
> -	remaining =3D 0;
> -	for (i =3D 0; i < n_vec; i++)
> -		remaining +=3D iov[i].iov_len;
> +		smb_msg->msg_flags =3D MSG_NOSIGNAL;
> =C2=A0
> -	i =3D 0;
> -	while (remaining) {
> +	while (msg_data_left(smb_msg)) {
> =C2=A0		/*
> =C2=A0		=C2=A0* If blocking send, we try 3 times, since each can
> block
> =C2=A0		=C2=A0* for 5 seconds. For nonblocking=C2=A0=C2=A0we have to =
try
> more
> @@ -177,35 +168,21 @@ smb_send_kvec(struct TCP_Server_Info *server,
> struct kvec *iov, size_t n_vec,
> =C2=A0		=C2=A0* after the retries we will kill the socket and
> =C2=A0		=C2=A0* reconnect which may clear the network problem.
> =C2=A0		=C2=A0*/
> -		rc =3D kernel_sendmsg(ssocket, &smb_msg,
> &iov[first_vec],
> -				=C2=A0=C2=A0=C2=A0=C2=A0n_vec - first_vec, remaining);
> +		rc =3D sock_sendmsg(ssocket, smb_msg);
> =C2=A0		if (rc =3D=3D -EAGAIN) {
> -			i++;
> -			if (i >=3D 14 || (!server->noblocksnd && (i >
> 2))) {
> +			retries++;
> +			if (retries >=3D 14 ||
> +			=C2=A0=C2=A0=C2=A0=C2=A0(!server->noblocksnd && (retries > 2)))
> {
> =C2=A0				cifs_dbg(VFS, "sends on sock %p
> stuck for 15 seconds\n",
> =C2=A0					=C2=A0ssocket);
> -				rc =3D -EAGAIN;
> -				break;
> +				return -EAGAIN;
> =C2=A0			}
> -			msleep(1 << i);
> +			msleep(1 << retries);
> =C2=A0			continue;
> =C2=A0		}
> =C2=A0
> =C2=A0		if (rc < 0)
> -			break;
> -
> -		/* send was at least partially successful */
> -		*sent +=3D rc;
> -
> -		if (rc =3D=3D remaining) {
> -			remaining =3D 0;
> -			break;
> -		}
> -
> -		if (rc > remaining) {
> -			cifs_dbg(VFS, "sent %d requested %d\n", rc,
> remaining);
> -			break;
> -		}
> +			return rc;
> =C2=A0
> =C2=A0		if (rc =3D=3D 0) {
> =C2=A0			/* should never happen, letting socket clear
> before
> @@ -215,59 +192,11 @@ smb_send_kvec(struct TCP_Server_Info *server,
> struct kvec *iov, size_t n_vec,
> =C2=A0			continue;
> =C2=A0		}
> =C2=A0
> -		remaining -=3D rc;
> -
> -		/* the line below resets i */
> -		for (i =3D first_vec; i < n_vec; i++) {
> -			if (iov[i].iov_len) {
> -				if (rc > iov[i].iov_len) {
> -					rc -=3D iov[i].iov_len;
> -					iov[i].iov_len =3D 0;
> -				} else {
> -					iov[i].iov_base +=3D rc;
> -					iov[i].iov_len -=3D rc;
> -					first_vec =3D i;
> -					break;
> -				}
> -			}
> -		}
> -
> -		i =3D 0; /* in case we get ENOSPC on the next send */
> -		rc =3D 0;
> +		/* send was at least partially successful */
> +		*sent +=3D rc;
> +		retries =3D 0; /* in case we get ENOSPC on the next
> send */
> =C2=A0	}
> -	return rc;
> -}
> -
> -/**
> - * rqst_page_to_kvec - Turn a slot in the smb_rqst page array into a
> kvec
> - * @rqst: pointer to smb_rqst
> - * @idx: index into the array of the page
> - * @iov: pointer to struct kvec that will hold the result
> - *
> - * Helper function to convert a slot in the rqst->rq_pages array
> into a kvec.
> - * The page will be kmapped and the address placed into iov_base.
> The length
> - * will then be adjusted according to the ptailoff.
> - */
> -void
> -cifs_rqst_page_to_kvec(struct smb_rqst *rqst, unsigned int idx,
> -			struct kvec *iov)
> -{
> -	/*
> -	=C2=A0* FIXME: We could avoid this kmap altogether if we used
> -	=C2=A0* kernel_sendpage instead of kernel_sendmsg. That will only
> -	=C2=A0* work if signing is disabled though as sendpage inlines
> the
> -	=C2=A0* page directly into the fraglist. If userspace modifies
> the
> -	=C2=A0* page after we calculate the signature, then the server
> will
> -	=C2=A0* reject it and may break the connection. kernel_sendmsg
> does
> -	=C2=A0* an extra copy of the data and avoids that issue.
> -	=C2=A0*/
> -	iov->iov_base =3D kmap(rqst->rq_pages[idx]);
> -
> -	/* if last page, don't send beyond this offset into page */
> -	if (idx =3D=3D (rqst->rq_npages - 1))
> -		iov->iov_len =3D rqst->rq_tailsz;
> -	else
> -		iov->iov_len =3D rqst->rq_pagesz;
> +	return 0;
> =C2=A0}
> =C2=A0
> =C2=A0static unsigned long
> @@ -299,8 +228,9 @@ smb_send_rqst(struct TCP_Server_Info *server,
> struct smb_rqst *rqst)
> =C2=A0	unsigned int smb_buf_length =3D
> get_rfc1002_length(iov[0].iov_base);
> =C2=A0	unsigned long send_length;
> =C2=A0	unsigned int i;
> -	size_t total_len =3D 0, sent;
> +	size_t total_len =3D 0, sent, size;
> =C2=A0	struct socket *ssocket =3D server->ssocket;
> +	struct msghdr smb_msg;
> =C2=A0	int val =3D 1;
> =C2=A0
> =C2=A0	if (ssocket =3D=3D NULL)
> @@ -321,7 +251,13 @@ smb_send_rqst(struct TCP_Server_Info *server,
> struct smb_rqst *rqst)
> =C2=A0	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
> =C2=A0				(char *)&val, sizeof(val));
> =C2=A0
> -	rc =3D smb_send_kvec(server, iov, n_vec, &sent);
> +	size =3D 0;
> +	for (i =3D 0; i < n_vec; i++)
> +		size +=3D iov[i].iov_len;
> +
> +	iov_iter_kvec(&smb_msg.msg_iter, WRITE | ITER_KVEC, iov,
> n_vec, size);
> +
> +	rc =3D smb_send_kvec(server, &smb_msg, &sent);
> =C2=A0	if (rc < 0)
> =C2=A0		goto uncork;
> =C2=A0
> @@ -329,11 +265,16 @@ smb_send_rqst(struct TCP_Server_Info *server,
> struct smb_rqst *rqst)
> =C2=A0
> =C2=A0	/* now walk the page array and send each page in it */
> =C2=A0	for (i =3D 0; i < rqst->rq_npages; i++) {
> -		struct kvec p_iov;
> -
> -		cifs_rqst_page_to_kvec(rqst, i, &p_iov);
> -		rc =3D smb_send_kvec(server, &p_iov, 1, &sent);
> -		kunmap(rqst->rq_pages[i]);
> +		size_t len =3D i =3D=3D rqst->rq_npages - 1
> +				? rqst->rq_tailsz
> +				: rqst->rq_pagesz;
> +		struct bio_vec bvec =3D {
> +			.bv_page =3D rqst->rq_pages[i],
> +			.bv_len =3D len
> +		};
> +		iov_iter_bvec(&smb_msg.msg_iter, WRITE | ITER_BVEC,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&bvec, 1, len);
> +		rc =3D smb_send_kvec(server, &smb_msg, &sent);
> =C2=A0		if (rc < 0)
> =C2=A0			break;
> =C2=A0

What's the advantage of using iov_iter_bvec over iov_iter_kvec ?

That said...

Acked-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
