From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Recvfile patch used for Samba.
Date: Mon, 22 Jul 2013 14:57:38 -0700
Message-ID: <20130722215738.GB20647@samba2>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Cc: jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steve and Jeff (and others).

Here is a patch that Samba vendors have been using
to implement recvfile (copy directly from socket
to file). It can improve write performance on boxes
by a significant amount (10% or more).

I'm not qualified to evaluate this code, can someone
who is (hi there Steve and Jeff :-) take a look at
this and see if it's work shepherding into the kernel ?

Cheers,

	Jeremy.

--Dxnq1zWXvFF0Q93v
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="splice-from-socket-to-file-2.6.37.patch"

diff -urp linux-2.6.37-rc5.orig/fs/splice.c linux-2.6.37-rc5/fs/splice.c
--- linux-2.6.37-rc5.orig/fs/splice.c	2010-12-06 20:09:04.000000000 -0800
+++ linux-2.6.37-rc5/fs/splice.c	2010-12-07 16:16:48.000000000 -0800
@@ -31,6 +31,7 @@
 #include <linux/uio.h>
 #include <linux/security.h>
 #include <linux/gfp.h>
+#include <net/sock.h>
 
 /*
  * Attempt to steal a page from a pipe buffer. This should perhaps go into
@@ -1387,6 +1388,141 @@ static long do_splice(struct file *in, l
 	return -EINVAL;
 }
 
+static ssize_t do_splice_from_socket(struct file *file, struct socket *sock,
+				     loff_t __user *ppos, size_t count)
+{		
+	struct address_space *mapping = file->f_mapping;
+	struct inode	*inode = mapping->host;
+	loff_t pos;
+	int count_tmp;
+	int err = 0;
+	int cPagePtr = 0;		
+	int cPagesAllocated = 0;
+	struct recvfile_ctl_blk rv_cb[MAX_PAGES_PER_RECVFILE];
+	struct kvec iov[MAX_PAGES_PER_RECVFILE];
+	struct msghdr msg;
+	long rcvtimeo;
+	int ret;
+
+	if(copy_from_user(&pos, ppos, sizeof(loff_t)))
+		return -EFAULT;
+
+	if(count > MAX_PAGES_PER_RECVFILE * PAGE_SIZE) {
+		printk("%s: count(%u) exceeds maxinum\n", __func__, count);
+		return -EINVAL;
+	}    
+	mutex_lock(&inode->i_mutex);
+
+	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+
+	/* We can write back this queue in page reclaim */
+	current->backing_dev_info = mapping->backing_dev_info;
+
+	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
+	if (err != 0 || count == 0)
+		goto done;
+
+	file_remove_suid(file);
+	file_update_time(file);	
+
+	count_tmp = count;
+	do {
+		unsigned long bytes;	/* Bytes to write to page */
+		unsigned long offset;	/* Offset into pagecache page */
+		struct page *pageP;
+		void *fsdata;
+
+		offset = (pos & (PAGE_CACHE_SIZE - 1));
+		bytes = PAGE_CACHE_SIZE - offset;
+		if (bytes > count_tmp)
+			bytes = count_tmp;
+		ret = mapping->a_ops->write_begin(file, mapping, pos, bytes,
+						  AOP_FLAG_UNINTERRUPTIBLE,
+						  &pageP, &fsdata);
+
+		if (unlikely(ret)) {
+			err = ret;
+			for(cPagePtr = 0; cPagePtr < cPagesAllocated; cPagePtr++) {
+				kunmap(rv_cb[cPagePtr].rv_page);
+				ret = mapping->a_ops->write_end(file, mapping,
+								rv_cb[cPagePtr].rv_pos,
+								rv_cb[cPagePtr].rv_count,
+								rv_cb[cPagePtr].rv_count,
+								rv_cb[cPagePtr].rv_page,
+								rv_cb[cPagePtr].rv_fsdata);
+			}
+			goto done;
+		}
+		rv_cb[cPagesAllocated].rv_page = pageP;
+		rv_cb[cPagesAllocated].rv_pos = pos;
+		rv_cb[cPagesAllocated].rv_count = bytes;
+		rv_cb[cPagesAllocated].rv_fsdata = fsdata;
+		iov[cPagesAllocated].iov_base = kmap(pageP) + offset;
+		iov[cPagesAllocated].iov_len = bytes;
+		cPagesAllocated++;
+		count_tmp -= bytes;
+		pos += bytes;
+	} while (count_tmp);
+
+	/* IOV is ready, receive the date from socket now */
+	msg.msg_name = NULL;
+	msg.msg_namelen = 0;
+	msg.msg_iov = (struct iovec *)&iov[0];
+	msg.msg_iovlen = cPagesAllocated ;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_flags = MSG_KERNSPACE;
+	rcvtimeo = sock->sk->sk_rcvtimeo;    
+	sock->sk->sk_rcvtimeo = 8 * HZ;
+
+	ret = kernel_recvmsg(sock, &msg, &iov[0], cPagesAllocated, count,
+			     MSG_WAITALL | MSG_NOCATCHSIG);
+
+	sock->sk->sk_rcvtimeo = rcvtimeo;
+	if(ret != count)
+		err = -EPIPE;
+	else
+		err = 0;
+
+	if (unlikely(err < 0)) {
+		for(cPagePtr = 0; cPagePtr < cPagesAllocated; cPagePtr++) {
+			kunmap(rv_cb[cPagePtr].rv_page);
+			ret = mapping->a_ops->write_end(file, mapping,
+							rv_cb[cPagePtr].rv_pos,
+							rv_cb[cPagePtr].rv_count,
+							rv_cb[cPagePtr].rv_count,
+							rv_cb[cPagePtr].rv_page,
+							rv_cb[cPagePtr].rv_fsdata);
+		}
+		goto done;
+	}
+
+	for(cPagePtr=0,count=0;cPagePtr < cPagesAllocated;cPagePtr++) {
+		//flush_dcache_page(pageP);
+		kunmap(rv_cb[cPagePtr].rv_page);
+		ret = mapping->a_ops->write_end(file, mapping,
+						rv_cb[cPagePtr].rv_pos,
+						rv_cb[cPagePtr].rv_count,
+						rv_cb[cPagePtr].rv_count,
+						rv_cb[cPagePtr].rv_page,
+						rv_cb[cPagePtr].rv_fsdata);
+		if (unlikely(ret < 0))
+			printk("%s: write_end fail,ret = %d\n", __func__, ret);
+		count += rv_cb[cPagePtr].rv_count;
+		//cond_resched();
+	}
+	balance_dirty_pages_ratelimited_nr(mapping, cPagesAllocated);
+	copy_to_user(ppos,&pos,sizeof(loff_t));
+    
+done:
+	current->backing_dev_info = NULL;    
+	mutex_unlock(&inode->i_mutex);
+	if(err)
+		return err;
+	else 
+		return count;
+}
+
 /*
  * Map an iov into an array of pages and offset/length tupples. With the
  * partial_page structure, we can map several non-contiguous ranges into
@@ -1698,11 +1834,33 @@ SYSCALL_DEFINE6(splice, int, fd_in, loff
 	long error;
 	struct file *in, *out;
 	int fput_in, fput_out;
+	struct socket *sock = NULL;
 
 	if (unlikely(!len))
 		return 0;
 
 	error = -EBADF;
+
+	/* check if fd_in is a socket */
+	sock = sockfd_lookup(fd_in, &error);
+	if (sock) {
+		out = NULL;
+		if (!sock->sk)
+			goto done;
+		out = fget_light(fd_out, &fput_out);
+        
+		if (out) {
+			if (!(out->f_mode & FMODE_WRITE))
+				goto done;
+			error = do_splice_from_socket(out, sock, off_out, len);
+		}       
+done:
+		if(out)
+			fput_light(out, fput_out);      
+		fput(sock->file);
+		return error;
+	}
+
 	in = fget_light(fd_in, &fput_in);
 	if (in) {
 		if (in->f_mode & FMODE_READ) {
diff -urp linux-2.6.37-rc5.orig/include/linux/fs.h linux-2.6.37-rc5/include/linux/fs.h
--- linux-2.6.37-rc5.orig/include/linux/fs.h	2010-12-06 20:09:04.000000000 -0800
+++ linux-2.6.37-rc5/include/linux/fs.h	2010-12-07 15:58:26.000000000 -0800
@@ -372,6 +372,8 @@ struct inodes_stat_t {
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
+#define MAX_PAGES_PER_RECVFILE		32
+
 #ifdef __KERNEL__
 
 #include <linux/linkage.h>
diff -urp linux-2.6.37-rc5.orig/include/linux/skbuff.h linux-2.6.37-rc5/include/linux/skbuff.h
--- linux-2.6.37-rc5.orig/include/linux/skbuff.h	2010-12-06 20:09:04.000000000 -0800
+++ linux-2.6.37-rc5/include/linux/skbuff.h	2010-12-07 15:31:43.000000000 -0800
@@ -1817,6 +1817,9 @@ extern unsigned int    datagram_poll(str
 extern int	       skb_copy_datagram_iovec(const struct sk_buff *from,
 					       int offset, struct iovec *to,
 					       int size);
+extern int	       skb_copy_datagram_to_kernel_iovec(const struct sk_buff *from,
+					       int offset, struct iovec *to,
+					       int size);
 extern int	       skb_copy_and_csum_datagram_iovec(struct sk_buff *skb,
 							int hlen,
 							struct iovec *iov);
diff -urp linux-2.6.37-rc5.orig/include/linux/socket.h linux-2.6.37-rc5/include/linux/socket.h
--- linux-2.6.37-rc5.orig/include/linux/socket.h	2010-12-06 20:09:04.000000000 -0800
+++ linux-2.6.37-rc5/include/linux/socket.h	2010-12-07 15:33:52.000000000 -0800
@@ -261,6 +261,8 @@ struct ucred {
 #define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
 #define MSG_MORE	0x8000	/* Sender will send more */
 #define MSG_WAITFORONE	0x10000	/* recvmmsg(): block until 1+ packets avail */
+#define MSG_KERNSPACE	0x20000
+#define MSG_NOCATCHSIG	0x40000
 
 #define MSG_EOF         MSG_FIN
 
@@ -326,6 +328,7 @@ extern int verify_iovec(struct msghdr *m
 extern int memcpy_toiovec(struct iovec *v, unsigned char *kdata, int len);
 extern int memcpy_toiovecend(const struct iovec *v, unsigned char *kdata,
 			     int offset, int len);
+extern void memcpy_tokerneliovec(struct iovec *iov, unsigned char *kdata, int len);
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr *kaddr);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
diff -urp linux-2.6.37-rc5.orig/include/linux/splice.h linux-2.6.37-rc5/include/linux/splice.h
--- linux-2.6.37-rc5.orig/include/linux/splice.h	2010-12-06 20:09:04.000000000 -0800
+++ linux-2.6.37-rc5/include/linux/splice.h	2010-12-07 15:46:44.000000000 -0800
@@ -57,6 +57,14 @@ struct splice_pipe_desc {
 	void (*spd_release)(struct splice_pipe_desc *, unsigned int);
 };
 
+struct recvfile_ctl_blk
+{
+	struct page *rv_page;
+	loff_t rv_pos;
+	size_t rv_count;
+	void *rv_fsdata;
+};
+
 typedef int (splice_actor)(struct pipe_inode_info *, struct pipe_buffer *,
 			   struct splice_desc *);
 typedef int (splice_direct_actor)(struct pipe_inode_info *,
diff -urp linux-2.6.37-rc5.orig/net/core/datagram.c linux-2.6.37-rc5/net/core/datagram.c
--- linux-2.6.37-rc5.orig/net/core/datagram.c	2010-12-06 20:09:04.000000000 -0800
+++ linux-2.6.37-rc5/net/core/datagram.c	2010-12-07 16:01:36.000000000 -0800
@@ -128,6 +128,65 @@ out_noerr:
 	goto out;
 }
 
+/*
+ *	skb_copy_datagram_to_kernel_iovec - Copy a datagram to a kernel iovec structure.
+ *	@skb: buffer to copy
+ *	@offset: offset in the buffer to start copying from
+ *	@to: io vector to copy to
+ *	@len: amount of data to copy from buffer to iovec
+ *
+ *	Note: the iovec is modified during the copy.
+ */
+int skb_copy_datagram_to_kernel_iovec(const struct sk_buff *skb, int offset,
+				      struct iovec *to, int len)
+{
+	int i, fraglen, end = 0;
+	struct sk_buff *next = skb_shinfo(skb)->frag_list;
+
+	if (!len)
+		return 0;
+
+next_skb:
+	fraglen = skb_headlen(skb);
+	i = -1;
+
+	while (1) {
+		int start = end;
+
+		if ((end += fraglen) > offset) {
+			int copy = end - offset;
+			int o = offset - start;
+
+			if (copy > len)
+				copy = len;
+			if (i == -1)
+				memcpy_tokerneliovec(to, skb->data + o, copy);
+			else {
+				skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+				struct page *page = frag->page;
+				void *p = kmap(page) + frag->page_offset + o;
+				memcpy_tokerneliovec(to, p, copy);
+				kunmap(page);
+			}
+
+			if (!(len -= copy))
+				return 0;
+			offset += copy;
+		}
+		if (++i >= skb_shinfo(skb)->nr_frags)
+			break;
+		fraglen = skb_shinfo(skb)->frags[i].size;
+	}
+	if (next) {
+		skb = next;
+		BUG_ON(skb_shinfo(skb)->frag_list);
+		next = skb->next;
+		goto next_skb;
+	}
+
+	return -EFAULT;
+}
+
 /**
  *	__skb_recv_datagram - Receive a datagram skbuff
  *	@sk: socket
diff -urp linux-2.6.37-rc5.orig/net/core/iovec.c linux-2.6.37-rc5/net/core/iovec.c
--- linux-2.6.37-rc5.orig/net/core/iovec.c	2010-12-06 20:09:04.000000000 -0800
+++ linux-2.6.37-rc5/net/core/iovec.c	2010-12-07 16:03:46.000000000 -0800
@@ -124,6 +124,30 @@ int memcpy_toiovecend(const struct iovec
 }
 EXPORT_SYMBOL(memcpy_toiovecend);
 
+/* This was removed in 2.6. Re-add it for splice from socket to file. */
+/*
+ *	In kernel copy to iovec. Returns -EFAULT on error.
+ *
+ *	Note: this modifies the original iovec.
+ */
+ 
+void memcpy_tokerneliovec(struct iovec *iov, unsigned char *kdata, int len)
+{
+	while(len>0)
+	{
+		if(iov->iov_len)
+		{
+			int copy = min_t(unsigned int, iov->iov_len, len);
+			memcpy(iov->iov_base, kdata, copy);
+			len -= copy;
+			kdata += copy;
+			iov->iov_base += copy;
+			iov->iov_len -= copy;
+		}
+		iov++;
+	}
+}
+
 /*
  *	Copy iovec to kernel. Returns -EFAULT on error.
  *
diff -urp linux-2.6.37-rc5.orig/net/ipv4/tcp.c linux-2.6.37-rc5/net/ipv4/tcp.c
--- linux-2.6.37-rc5.orig/net/ipv4/tcp.c	2010-12-06 20:09:04.000000000 -0800
+++ linux-2.6.37-rc5/net/ipv4/tcp.c	2010-12-07 15:49:35.000000000 -0800
@@ -1460,8 +1460,23 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 	do {
 		u32 offset;
 
+		if (flags & MSG_NOCATCHSIG) {
+			if (signal_pending(current)) {
+				if (sigismember(&current->pending.signal, SIGQUIT) || 
+				    sigismember(&current->pending.signal, SIGABRT) ||
+				    sigismember(&current->pending.signal, SIGKILL) ||
+				    sigismember(&current->pending.signal, SIGTERM) ||
+				    sigismember(&current->pending.signal, SIGSTOP)) {
+
+					if (copied)
+						break;
+					copied = timeo ? sock_intr_errno(timeo) : -EAGAIN;
+					break;
+				}
+			}
+		}
 		/* Are we at urgent data? Stop if we have read anything or have SIGURG pending. */
-		if (tp->urg_data && tp->urg_seq == *seq) {
+		else if (tp->urg_data && tp->urg_seq == *seq) {
 			if (copied)
 				break;
 			if (signal_pending(current)) {
@@ -1690,8 +1705,12 @@ do_prequeue:
 			} else
 #endif
 			{
-				err = skb_copy_datagram_iovec(skb, offset,
-						msg->msg_iov, used);
+				if(msg->msg_flags & MSG_KERNSPACE)
+					err = skb_copy_datagram_to_kernel_iovec(skb,
+							offset, msg->msg_iov, used);
+				else
+					err = skb_copy_datagram_iovec(skb, offset,
+							msg->msg_iov, used);
 				if (err) {
 					/* Exception. Bailout! */
 					if (!copied)

--Dxnq1zWXvFF0Q93v--
