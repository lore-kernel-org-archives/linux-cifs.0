From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 4/6] cifs: no need to wank with copying and advancing
 iovec on recvmsg side either
Date: Tue, 19 Apr 2016 13:55:11 -0400
Message-ID: <1461088511.15135.11.camel@poochiereds.net>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
	 <20160409205210.GJ25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160409205210.GJ25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2016-04-09 at 21:52 +0100, Al Viro wrote:
> Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
> =C2=A0fs/cifs/cifsglob.h |=C2=A0=C2=A02 --
> =C2=A0fs/cifs/connect.c=C2=A0=C2=A0| 72 ++++-------------------------=
-------------------------
> =C2=A02 files changed, 5 insertions(+), 69 deletions(-)
>=20
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index d21da9f..df03c5e 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -615,8 +615,6 @@ struct TCP_Server_Info {
> =C2=A0	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
> =C2=A0	bool	large_buf;		/* is current buffer large? */
> =C2=A0	struct delayed_work	echo; /* echo ping workqueue job */
> -	struct kvec *iov;	/* reusable kvec array for receives */
> -	unsigned int nr_iov;	/* number of kvecs in array */
> =C2=A0	char	*smallbuf;	/* pointer to current "small" buffer */
> =C2=A0	char	*bigbuf;	/* pointer to current "big" buffer */
> =C2=A0	unsigned int total_read; /* total amount of data read in this =
pass */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a763cd3..eb42665 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -501,77 +501,20 @@ server_unresponsive(struct TCP_Server_Info *ser=
ver)
> =C2=A0	return false;
> =C2=A0}
> =C2=A0
> -/*
> - * kvec_array_init - clone a kvec array, and advance into it
> - * @new:	pointer to memory for cloned array
> - * @iov:	pointer to original array
> - * @nr_segs:	number of members in original array
> - * @bytes:	number of bytes to advance into the cloned array
> - *
> - * This function will copy the array provided in iov to a section of=
 memory
> - * and advance the specified number of bytes into the new array. It =
returns
> - * the number of segments in the new array. "new" must be at least a=
s big as
> - * the original iov array.
> - */
> -static unsigned int
> -kvec_array_init(struct kvec *new, struct kvec *iov, unsigned int nr_=
segs,
> -		size_t bytes)
> -{
> -	size_t base =3D 0;
> -
> -	while (bytes || !iov->iov_len) {
> -		int copy =3D min(bytes, iov->iov_len);
> -
> -		bytes -=3D copy;
> -		base +=3D copy;
> -		if (iov->iov_len =3D=3D base) {
> -			iov++;
> -			nr_segs--;
> -			base =3D 0;
> -		}
> -	}
> -	memcpy(new, iov, sizeof(*iov) * nr_segs);
> -	new->iov_base +=3D base;
> -	new->iov_len -=3D base;
> -	return nr_segs;
> -}
> -
> -static struct kvec *
> -get_server_iovec(struct TCP_Server_Info *server, unsigned int nr_seg=
s)
> -{
> -	struct kvec *new_iov;
> -
> -	if (server->iov && nr_segs <=3D server->nr_iov)
> -		return server->iov;
> -
> -	/* not big enough -- allocate a new one and release the old */
> -	new_iov =3D kmalloc(sizeof(*new_iov) * nr_segs, GFP_NOFS);
> -	if (new_iov) {
> -		kfree(server->iov);
> -		server->iov =3D new_iov;
> -		server->nr_iov =3D nr_segs;
> -	}
> -	return new_iov;
> -}
> -
> =C2=A0int
> =C2=A0cifs_readv_from_socket(struct TCP_Server_Info *server, struct k=
vec *iov_orig,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int nr_seg=
s, unsigned int to_read)
> =C2=A0{
> =C2=A0	int length =3D 0;
> =C2=A0	int total_read;
> -	unsigned int segs;
> =C2=A0	struct msghdr smb_msg;
> -	struct kvec *iov;
> -
> -	iov =3D get_server_iovec(server, nr_segs);
> -	if (!iov)
> -		return -ENOMEM;
> =C2=A0
> =C2=A0	smb_msg.msg_control =3D NULL;
> =C2=A0	smb_msg.msg_controllen =3D 0;
> +	iov_iter_kvec(&smb_msg.msg_iter, READ | ITER_KVEC,
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iov_orig, nr_segs, to_read);
> =C2=A0
> -	for (total_read =3D 0; to_read; total_read +=3D length, to_read -=3D=
 length) {
> +	for (total_read =3D 0; msg_data_left(&smb_msg); total_read +=3D len=
gth) {
> =C2=A0		try_to_freeze();
> =C2=A0
> =C2=A0		if (server_unresponsive(server)) {
> @@ -579,10 +522,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *s=
erver, struct kvec *iov_orig,
> =C2=A0			break;
> =C2=A0		}
> =C2=A0
> -		segs =3D kvec_array_init(iov, iov_orig, nr_segs, total_read);
> -
> -		length =3D kernel_recvmsg(server->ssocket, &smb_msg,
> -					iov, segs, to_read, 0);
> +		length =3D sock_recvmsg(server->ssocket, &smb_msg, 0);
> =C2=A0
> =C2=A0		if (server->tcpStatus =3D=3D CifsExiting) {
> =C2=A0			total_read =3D -ESHUTDOWN;
> @@ -603,8 +543,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *se=
rver, struct kvec *iov_orig,
> =C2=A0			length =3D 0;
> =C2=A0			continue;
> =C2=A0		} else if (length <=3D 0) {
> -			cifs_dbg(FYI, "Received no data or error: expecting %d\n"
> -				=C2=A0"got %d", to_read, length);
> +			cifs_dbg(FYI, "Received no data or error: %d\n", length);
> =C2=A0			cifs_reconnect(server);
> =C2=A0			total_read =3D -ECONNABORTED;
> =C2=A0			break;
> @@ -783,7 +722,6 @@ static void clean_demultiplex_info(struct TCP_Ser=
ver_Info *server)
> =C2=A0	}
> =C2=A0
> =C2=A0	kfree(server->hostname);
> -	kfree(server->iov);
> =C2=A0	kfree(server);
> =C2=A0
> =C2=A0	length =3D atomic_dec_return(&tcpSesAllocCount);

Good riddance.

Reviewed-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
