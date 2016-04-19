From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 6/6] cifs: don't bother with kmap on read_pages side
Date: Tue, 19 Apr 2016 14:24:34 -0400
Message-ID: <1461090274.15135.13.camel@poochiereds.net>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
	 <20160409205304.GL25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160409205304.GL25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2016-04-09 at 21:53 +0100, Al Viro wrote:
> just do ITER_BVEC recvmsg
>=20
> Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
> =C2=A0fs/cifs/cifsproto.h |=C2=A0=C2=A07 +++---
> =C2=A0fs/cifs/connect.c=C2=A0=C2=A0=C2=A0| 65 +++++++++++++++++++++++=
+++++-------------------------
> =C2=A0fs/cifs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 53 ++++++++=
++++++-----------------------------
> =C2=A03 files changed, 55 insertions(+), 70 deletions(-)
>=20
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 7d5f53a..0f9a6bc 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -179,10 +179,9 @@ extern int set_cifs_acl(struct cifs_ntsd *, __u3=
2, struct inode *,
> =C2=A0
> =C2=A0extern void dequeue_mid(struct mid_q_entry *mid, bool malformed=
);
> =C2=A0extern int cifs_read_from_socket(struct TCP_Server_Info *server=
, char *buf,
> -		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int to_read);
> -extern int cifs_readv_from_socket(struct TCP_Server_Info *server,
> -		struct kvec *iov_orig, unsigned int nr_segs,
> -		unsigned int to_read);
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned in=
t to_read);
> +extern int cifs_read_page_from_socket(struct TCP_Server_Info *server=
,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct page *page, unsigned =
int to_read);
> =C2=A0extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct cifs_sb_inf=
o *cifs_sb);
> =C2=A0extern int cifs_match_super(struct super_block *, void *);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index eb42665..e33c5e0 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -501,39 +501,34 @@ server_unresponsive(struct TCP_Server_Info *ser=
ver)
> =C2=A0	return false;
> =C2=A0}
> =C2=A0
> -int
> -cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *=
iov_orig,
> -		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int nr_segs, un=
signed int to_read)
> +static int
> +cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr=
 *smb_msg)
> =C2=A0{
> =C2=A0	int length =3D 0;
> =C2=A0	int total_read;
> -	struct msghdr smb_msg;
> =C2=A0
> -	smb_msg.msg_control =3D NULL;
> -	smb_msg.msg_controllen =3D 0;
> -	iov_iter_kvec(&smb_msg.msg_iter, READ | ITER_KVEC,
> -		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iov_orig, nr_segs, to_read);
> +	smb_msg->msg_control =3D NULL;
> +	smb_msg->msg_controllen =3D 0;
> =C2=A0
> -	for (total_read =3D 0; msg_data_left(&smb_msg); total_read +=3D len=
gth) {
> +	for (total_read =3D 0; msg_data_left(smb_msg); total_read +=3D leng=
th) {
> =C2=A0		try_to_freeze();
> =C2=A0
> -		if (server_unresponsive(server)) {
> -			total_read =3D -ECONNABORTED;
> -			break;
> -		}
> +		if (server_unresponsive(server))
> +			return -ECONNABORTED;
> =C2=A0
> -		length =3D sock_recvmsg(server->ssocket, &smb_msg, 0);
> +		length =3D sock_recvmsg(server->ssocket, smb_msg, 0);
> =C2=A0
> -		if (server->tcpStatus =3D=3D CifsExiting) {
> -			total_read =3D -ESHUTDOWN;
> -			break;
> -		} else if (server->tcpStatus =3D=3D CifsNeedReconnect) {
> +		if (server->tcpStatus =3D=3D CifsExiting)
> +			return -ESHUTDOWN;
> +
> +		if (server->tcpStatus =3D=3D CifsNeedReconnect) {
> =C2=A0			cifs_reconnect(server);
> -			total_read =3D -ECONNABORTED;
> -			break;
> -		} else if (length =3D=3D -ERESTARTSYS ||
> -			=C2=A0=C2=A0=C2=A0length =3D=3D -EAGAIN ||
> -			=C2=A0=C2=A0=C2=A0length =3D=3D -EINTR) {
> +			return -ECONNABORTED;
> +		}
> +
> +		if (length =3D=3D -ERESTARTSYS ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0length =3D=3D -EAGAIN ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0length =3D=3D -EINTR) {
> =C2=A0			/*
> =C2=A0			=C2=A0* Minimum sleep to prevent looping, allowing socket
> =C2=A0			=C2=A0* to clear and app threads to set tcpStatus
> @@ -542,11 +537,12 @@ cifs_readv_from_socket(struct TCP_Server_Info *=
server, struct kvec *iov_orig,
> =C2=A0			usleep_range(1000, 2000);
> =C2=A0			length =3D 0;
> =C2=A0			continue;
> -		} else if (length <=3D 0) {
> +		}
> +
> +		if (length <=3D 0) {
> =C2=A0			cifs_dbg(FYI, "Received no data or error: %d\n", length);
> =C2=A0			cifs_reconnect(server);
> -			total_read =3D -ECONNABORTED;
> -			break;
> +			return -ECONNABORTED;
> =C2=A0		}
> =C2=A0	}
> =C2=A0	return total_read;
> @@ -556,12 +552,21 @@ int
> =C2=A0cifs_read_from_socket(struct TCP_Server_Info *server, char *buf=
,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int to_read)
> =C2=A0{
> -	struct kvec iov;
> +	struct msghdr smb_msg;
> +	struct kvec iov =3D {.iov_base =3D buf, .iov_len =3D to_read};
> +	iov_iter_kvec(&smb_msg.msg_iter, READ | ITER_KVEC, &iov, 1, to_read=
);
> =C2=A0
> -	iov.iov_base =3D buf;
> -	iov.iov_len =3D to_read;
> +	return cifs_readv_from_socket(server, &smb_msg);
> +}
> =C2=A0
> -	return cifs_readv_from_socket(server, &iov, 1, to_read);
> +int
> +cifs_read_page_from_socket(struct TCP_Server_Info *server, struct pa=
ge *page,
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int to_read)
> +{
> +	struct msghdr smb_msg;
> +	struct bio_vec bv =3D {.bv_page =3D page, .bv_len =3D to_read};
> +	iov_iter_bvec(&smb_msg.msg_iter, READ | ITER_BVEC, &bv, 1, to_read)=
;
> +	return cifs_readv_from_socket(server, &smb_msg);
> =C2=A0}
> =C2=A0
> =C2=A0static bool
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index ff882ae..0f71867 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2855,39 +2855,31 @@ cifs_uncached_read_into_pages(struct TCP_Serv=
er_Info *server,
> =C2=A0	int result =3D 0;
> =C2=A0	unsigned int i;
> =C2=A0	unsigned int nr_pages =3D rdata->nr_pages;
> -	struct kvec iov;
> =C2=A0
> =C2=A0	rdata->got_bytes =3D 0;
> =C2=A0	rdata->tailsz =3D PAGE_SIZE;
> =C2=A0	for (i =3D 0; i < nr_pages; i++) {
> =C2=A0		struct page *page =3D rdata->pages[i];
> +		size_t n;
> =C2=A0
> -		if (len >=3D PAGE_SIZE) {
> -			/* enough data to fill the page */
> -			iov.iov_base =3D kmap(page);
> -			iov.iov_len =3D PAGE_SIZE;
> -			cifs_dbg(FYI, "%u: iov_base=3D%p iov_len=3D%zu\n",
> -				=C2=A0i, iov.iov_base, iov.iov_len);
> -			len -=3D PAGE_SIZE;
> -		} else if (len > 0) {
> -			/* enough for partial page, fill and zero the rest */
> -			iov.iov_base =3D kmap(page);
> -			iov.iov_len =3D len;
> -			cifs_dbg(FYI, "%u: iov_base=3D%p iov_len=3D%zu\n",
> -				=C2=A0i, iov.iov_base, iov.iov_len);
> -			memset(iov.iov_base + len, '\0', PAGE_SIZE - len);
> -			rdata->tailsz =3D len;
> -			len =3D 0;
> -		} else {
> +		if (len <=3D 0) {
> =C2=A0			/* no need to hold page hostage */
> =C2=A0			rdata->pages[i] =3D NULL;
> =C2=A0			rdata->nr_pages--;
> =C2=A0			put_page(page);
> =C2=A0			continue;
> =C2=A0		}
> -
> -		result =3D cifs_readv_from_socket(server, &iov, 1, iov.iov_len);
> -		kunmap(page);
> +		n =3D len;
> +		if (len >=3D PAGE_SIZE) {
> +			/* enough data to fill the page */
> +			n =3D PAGE_SIZE;
> +			len -=3D n;
> +		} else {
> +			zero_user(page, len, PAGE_SIZE - len);
> +			rdata->tailsz =3D len;
> +			len =3D 0;
> +		}
> +		result =3D cifs_read_page_from_socket(server, page, n);
> =C2=A0		if (result < 0)
> =C2=A0			break;
> =C2=A0
> @@ -3303,7 +3295,6 @@ cifs_readpages_read_into_pages(struct TCP_Serve=
r_Info *server,
> =C2=A0	u64 eof;
> =C2=A0	pgoff_t eof_index;
> =C2=A0	unsigned int nr_pages =3D rdata->nr_pages;
> -	struct kvec iov;
> =C2=A0
> =C2=A0	/* determine the eof that the server (probably) has */
> =C2=A0	eof =3D CIFS_I(rdata->mapping->host)->server_eof;
> @@ -3314,23 +3305,14 @@ cifs_readpages_read_into_pages(struct TCP_Ser=
ver_Info *server,
> =C2=A0	rdata->tailsz =3D PAGE_CACHE_SIZE;
> =C2=A0	for (i =3D 0; i < nr_pages; i++) {
> =C2=A0		struct page *page =3D rdata->pages[i];
> +		size_t n =3D PAGE_CACHE_SIZE;
> =C2=A0
> =C2=A0		if (len >=3D PAGE_CACHE_SIZE) {
> -			/* enough data to fill the page */
> -			iov.iov_base =3D kmap(page);
> -			iov.iov_len =3D PAGE_CACHE_SIZE;
> -			cifs_dbg(FYI, "%u: idx=3D%lu iov_base=3D%p iov_len=3D%zu\n",
> -				=C2=A0i, page->index, iov.iov_base, iov.iov_len);
> =C2=A0			len -=3D PAGE_CACHE_SIZE;
> =C2=A0		} else if (len > 0) {
> =C2=A0			/* enough for partial page, fill and zero the rest */
> -			iov.iov_base =3D kmap(page);
> -			iov.iov_len =3D len;
> -			cifs_dbg(FYI, "%u: idx=3D%lu iov_base=3D%p iov_len=3D%zu\n",
> -				=C2=A0i, page->index, iov.iov_base, iov.iov_len);
> -			memset(iov.iov_base + len,
> -				'\0', PAGE_CACHE_SIZE - len);
> -			rdata->tailsz =3D len;
> +			zero_user(page, len, PAGE_CACHE_SIZE - len);
> +			n =3D rdata->tailsz =3D len;
> =C2=A0			len =3D 0;
> =C2=A0		} else if (page->index > eof_index) {
> =C2=A0			/*
> @@ -3360,8 +3342,7 @@ cifs_readpages_read_into_pages(struct TCP_Serve=
r_Info *server,
> =C2=A0			continue;
> =C2=A0		}
> =C2=A0
> -		result =3D cifs_readv_from_socket(server, &iov, 1, iov.iov_len);
> -		kunmap(page);
> +		result =3D cifs_read_page_from_socket(server, page, n);
> =C2=A0		if (result < 0)
> =C2=A0			break;
> =C2=A0

Reviewed-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
