From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 1/6] [net] drop 'size' argument of sock_recvmsg()
Date: Tue, 19 Apr 2016 12:03:27 -0400
Message-ID: <1461081807.15135.3.camel@poochiereds.net>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
	 <20160409205029.GG25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160409205029.GG25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2016-04-09 at 21:50 +0100, Al Viro wrote:
> all callers have it equal to msg_data_left(msg).
>=20
> Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
> =C2=A0drivers/target/iscsi/iscsi_target_util.c |=C2=A0=C2=A05 ++---
> =C2=A0include/linux/net.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A03 +--
> =C2=A0net/socket.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 23 ++++++++++-----=
--------
> =C2=A03 files changed, 13 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/targe=
t/iscsi/iscsi_target_util.c
> index 428b0d9..5772038 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -1283,9 +1283,8 @@ static int iscsit_do_rx_data(
> =C2=A0	iov_iter_kvec(&msg.msg_iter, READ | ITER_KVEC,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0count->iov, count->iov_co=
unt, data);
> =C2=A0
> -	while (total_rx < data) {
> -		rx_loop =3D sock_recvmsg(conn->sock, &msg,
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(data - total_rx), MSG_WAITA=
LL);
> +	while (msg_data_left(&msg)) {
> +		rx_loop =3D sock_recvmsg(conn->sock, &msg, MSG_WAITALL);
> =C2=A0		if (rx_loop <=3D 0) {
> =C2=A0			pr_debug("rx_loop: %d total_rx: %d\n",
> =C2=A0				rx_loop, total_rx);
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 49175e4..72c1e06 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -218,8 +218,7 @@ int sock_create_lite(int family, int type, int pr=
oto, struct socket **res);
> =C2=A0struct socket *sock_alloc(void);
> =C2=A0void sock_release(struct socket *sock);
> =C2=A0int sock_sendmsg(struct socket *sock, struct msghdr *msg);
> -int sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t siz=
e,
> -		=C2=A0int flags);
> +int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags)=
;
> =C2=A0struct file *sock_alloc_file(struct socket *sock, int flags, co=
nst char *dname);
> =C2=A0struct socket *sockfd_lookup(int fd, int *err);
> =C2=A0struct socket *sock_from_file(struct file *file, int *err);
> diff --git a/net/socket.c b/net/socket.c
> index 5f77a8e..956426e3 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -709,17 +709,16 @@ void __sock_recv_ts_and_drops(struct msghdr *ms=
g, struct sock *sk,
> =C2=A0EXPORT_SYMBOL_GPL(__sock_recv_ts_and_drops);
> =C2=A0
> =C2=A0static inline int sock_recvmsg_nosec(struct socket *sock, struc=
t msghdr *msg,
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0size_t size, int flags)
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int flags)
> =C2=A0{
> -	return sock->ops->recvmsg(sock, msg, size, flags);
> +	return sock->ops->recvmsg(sock, msg, msg_data_left(msg), flags);
> =C2=A0}
> =C2=A0
> -int sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t siz=
e,
> -		=C2=A0int flags)
> +int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags)
> =C2=A0{
> -	int err =3D security_socket_recvmsg(sock, msg, size, flags);
> +	int err =3D security_socket_recvmsg(sock, msg, msg_data_left(msg), =
flags);
> =C2=A0
> -	return err ?: sock_recvmsg_nosec(sock, msg, size, flags);
> +	return err ?: sock_recvmsg_nosec(sock, msg, flags);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(sock_recvmsg);
> =C2=A0
> @@ -746,7 +745,7 @@ int kernel_recvmsg(struct socket *sock, struct ms=
ghdr *msg,
> =C2=A0
> =C2=A0	iov_iter_kvec(&msg->msg_iter, READ | ITER_KVEC, vec, num, size=
);
> =C2=A0	set_fs(KERNEL_DS);
> -	result =3D sock_recvmsg(sock, msg, size, flags);
> +	result =3D sock_recvmsg(sock, msg, flags);
> =C2=A0	set_fs(oldfs);
> =C2=A0	return result;
> =C2=A0}
> @@ -796,7 +795,7 @@ static ssize_t sock_read_iter(struct kiocb *iocb,=
 struct iov_iter *to)
> =C2=A0	if (!iov_iter_count(to))	/* Match SYS5 behaviour */
> =C2=A0		return 0;
> =C2=A0
> -	res =3D sock_recvmsg(sock, &msg, iov_iter_count(to), msg.msg_flags)=
;
> +	res =3D sock_recvmsg(sock, &msg, msg.msg_flags);
> =C2=A0	*to =3D msg.msg_iter;
> =C2=A0	return res;
> =C2=A0}
> @@ -1696,7 +1695,7 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void __user =
*, ubuf, size_t, size,
> =C2=A0	msg.msg_iocb =3D NULL;
> =C2=A0	if (sock->file->f_flags & O_NONBLOCK)
> =C2=A0		flags |=3D MSG_DONTWAIT;
> -	err =3D sock_recvmsg(sock, &msg, iov_iter_count(&msg.msg_iter), fla=
gs);
> +	err =3D sock_recvmsg(sock, &msg, flags);
> =C2=A0
> =C2=A0	if (err >=3D 0 && addr !=3D NULL) {
> =C2=A0		err2 =3D move_addr_to_user(&address,
> @@ -2073,7 +2072,7 @@ static int ___sys_recvmsg(struct socket *sock, =
struct user_msghdr __user *msg,
> =C2=A0	struct iovec iovstack[UIO_FASTIOV];
> =C2=A0	struct iovec *iov =3D iovstack;
> =C2=A0	unsigned long cmsg_ptr;
> -	int total_len, len;
> +	int len;
> =C2=A0	ssize_t err;
> =C2=A0
> =C2=A0	/* kernel mode address */
> @@ -2091,7 +2090,6 @@ static int ___sys_recvmsg(struct socket *sock, =
struct user_msghdr __user *msg,
> =C2=A0		err =3D copy_msghdr_from_user(msg_sys, msg, &uaddr, &iov);
> =C2=A0	if (err < 0)
> =C2=A0		return err;
> -	total_len =3D iov_iter_count(&msg_sys->msg_iter);
> =C2=A0
> =C2=A0	cmsg_ptr =3D (unsigned long)msg_sys->msg_control;
> =C2=A0	msg_sys->msg_flags =3D flags & (MSG_CMSG_CLOEXEC|MSG_CMSG_COMP=
AT);
> @@ -2101,8 +2099,7 @@ static int ___sys_recvmsg(struct socket *sock, =
struct user_msghdr __user *msg,
> =C2=A0
> =C2=A0	if (sock->file->f_flags & O_NONBLOCK)
> =C2=A0		flags |=3D MSG_DONTWAIT;
> -	err =3D (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys,
> -							=C2=A0=C2=A0total_len, flags);
> +	err =3D (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys, =
flags);
> =C2=A0	if (err < 0)
> =C2=A0		goto out_freeiov;
> =C2=A0	len =3D err;

Looks good. Assuming that the corresponding change to sock_recvmsg is
merged.

Reviewed-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
