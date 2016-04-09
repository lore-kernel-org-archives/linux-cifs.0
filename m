From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: [PATCH 1/6] [net] drop 'size' argument of sock_recvmsg()
Date: Sat, 9 Apr 2016 21:50:29 +0100
Message-ID: <20160409205029.GG25498@ZenIV.linux.org.uk>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160409204301.GF25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

all callers have it equal to msg_data_left(msg).

Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
 drivers/target/iscsi/iscsi_target_util.c |  5 ++---
 include/linux/net.h                      |  3 +--
 net/socket.c                             | 23 ++++++++++-------------
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 428b0d9..5772038 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1283,9 +1283,8 @@ static int iscsit_do_rx_data(
 	iov_iter_kvec(&msg.msg_iter, READ | ITER_KVEC,
 		      count->iov, count->iov_count, data);
 
-	while (total_rx < data) {
-		rx_loop = sock_recvmsg(conn->sock, &msg,
-				      (data - total_rx), MSG_WAITALL);
+	while (msg_data_left(&msg)) {
+		rx_loop = sock_recvmsg(conn->sock, &msg, MSG_WAITALL);
 		if (rx_loop <= 0) {
 			pr_debug("rx_loop: %d total_rx: %d\n",
 				rx_loop, total_rx);
diff --git a/include/linux/net.h b/include/linux/net.h
index 49175e4..72c1e06 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -218,8 +218,7 @@ int sock_create_lite(int family, int type, int proto, struct socket **res);
 struct socket *sock_alloc(void);
 void sock_release(struct socket *sock);
 int sock_sendmsg(struct socket *sock, struct msghdr *msg);
-int sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
-		 int flags);
+int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags);
 struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname);
 struct socket *sockfd_lookup(int fd, int *err);
 struct socket *sock_from_file(struct file *file, int *err);
diff --git a/net/socket.c b/net/socket.c
index 5f77a8e..956426e3 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -709,17 +709,16 @@ void __sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
 EXPORT_SYMBOL_GPL(__sock_recv_ts_and_drops);
 
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
-				     size_t size, int flags)
+				     int flags)
 {
-	return sock->ops->recvmsg(sock, msg, size, flags);
+	return sock->ops->recvmsg(sock, msg, msg_data_left(msg), flags);
 }
 
-int sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
-		 int flags)
+int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags)
 {
-	int err = security_socket_recvmsg(sock, msg, size, flags);
+	int err = security_socket_recvmsg(sock, msg, msg_data_left(msg), flags);
 
-	return err ?: sock_recvmsg_nosec(sock, msg, size, flags);
+	return err ?: sock_recvmsg_nosec(sock, msg, flags);
 }
 EXPORT_SYMBOL(sock_recvmsg);
 
@@ -746,7 +745,7 @@ int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	iov_iter_kvec(&msg->msg_iter, READ | ITER_KVEC, vec, num, size);
 	set_fs(KERNEL_DS);
-	result = sock_recvmsg(sock, msg, size, flags);
+	result = sock_recvmsg(sock, msg, flags);
 	set_fs(oldfs);
 	return result;
 }
@@ -796,7 +795,7 @@ static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!iov_iter_count(to))	/* Match SYS5 behaviour */
 		return 0;
 
-	res = sock_recvmsg(sock, &msg, iov_iter_count(to), msg.msg_flags);
+	res = sock_recvmsg(sock, &msg, msg.msg_flags);
 	*to = msg.msg_iter;
 	return res;
 }
@@ -1696,7 +1695,7 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, ubuf, size_t, size,
 	msg.msg_iocb = NULL;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
-	err = sock_recvmsg(sock, &msg, iov_iter_count(&msg.msg_iter), flags);
+	err = sock_recvmsg(sock, &msg, flags);
 
 	if (err >= 0 && addr != NULL) {
 		err2 = move_addr_to_user(&address,
@@ -2073,7 +2072,7 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 	struct iovec iovstack[UIO_FASTIOV];
 	struct iovec *iov = iovstack;
 	unsigned long cmsg_ptr;
-	int total_len, len;
+	int len;
 	ssize_t err;
 
 	/* kernel mode address */
@@ -2091,7 +2090,6 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 		err = copy_msghdr_from_user(msg_sys, msg, &uaddr, &iov);
 	if (err < 0)
 		return err;
-	total_len = iov_iter_count(&msg_sys->msg_iter);
 
 	cmsg_ptr = (unsigned long)msg_sys->msg_control;
 	msg_sys->msg_flags = flags & (MSG_CMSG_CLOEXEC|MSG_CMSG_COMPAT);
@@ -2101,8 +2099,7 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
-	err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys,
-							  total_len, flags);
+	err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys, flags);
 	if (err < 0)
 		goto out_freeiov;
 	len = err;
-- 
2.8.0.rc3
