Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="oHnX8gTA"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DDE10DC
	for <linux-cifs@vger.kernel.org>; Wed, 13 Dec 2023 07:26:08 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702481166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lq1zaP4yt9p3m82QEAooX/C9wqMYNlXD/YQnAJfxE50=;
	b=oHnX8gTAR0OX3NhA0DEUhvKX1OaL4Zspc6+/vvnC+gvyBIpPoBaJmU+GF9/ALXlnyjvY6v
	QYyM9lv9QNZ2qdypP8Dscok+X4t/lksLk4ZK8cSq7D9LlXs9fXtFzH8K5YFbxDdsuEoSop
	KciifYRR8y5kv/E5wP+Tt96WuTsBI7vzml2bwKKBj/igx3sCjreznY6DGcS8tRzTfEAd8Z
	pR1g3isHxvGbcEc0lCnOuXEiaxTlw+20E8aNZD/eHo3y+J5bxhiBFX04SEjYdl/uWCpVaa
	Vsda9CCsH+2ubzylhHFWy1tRQuaa0i8uQ3KG8xFTg7zvf1h7uUCg1237Yr0G/Q==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1702481166; a=rsa-sha256;
	cv=none;
	b=bnjh5pTFpjjG0FYfbm/ka4Bfv5RMNhnRilSwJ2HhMfYFkjPfhredRuUKs+0i5ZiOzJgLZn
	7oVjGPDzqEyLiayzfaIoMrfj5EU+nHM2tXNhDXt+X3VYqUGY7P15AwQq7L2Dl4R5uy1mHx
	8Bp/skkfACZ3cP7lakKpmEv1bbmIX1kROYlyDEEx+AuCrPCoEpCX8NS/5T0T5jZz4cGuO9
	tPZpxciWIlQoyMCXjw7FurNF44AiOyFlIPLrOMTjTS0sSPD6yXhCiEnayNR77ALacAAABm
	BBAWDahINBwZ+8sl8/5uqAE5vN0AlV7xnDzkx/CAj8SgyqqNufel92AjdAheZQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702481166; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=lq1zaP4yt9p3m82QEAooX/C9wqMYNlXD/YQnAJfxE50=;
	b=Sqlr5RYG/QZDrOuwYrBP4q/eL9MpqcUViJJy0NUHeFsS4Yi+4OVLw2v7/9ThwEAuVJm/2r
	oI68aHkntquyIFUws27EeTs/y1wC0KtfwjgjF8pvD6WlbVy0TAJ8p6Aq3QJ2xnfg2KMhOo
	i/aS6K9EzHYhqNXjD8Jo+AsxKt0sX9V6pQTZZt/eChwT/9ngDQ+1V6epZ8mVXflkxjfTXW
	kvT+hJNkxkp2iQ8Tb1ch8+0YSdXWCvi6nnYAL4vqKLI3URTw/6I5hGPe86V/605U3z7zax
	AaokpiATgexkSBH/w/SkhzWTIh2bdAmB6b9l44kn/9pcQfLDU5eN/TRSGxRY6g==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Robert Morris <rtm@csail.mit.edu>
Subject: [PATCH 1/2] smb: client: fix OOB in cifsd when receiving compounded resps
Date: Wed, 13 Dec 2023 12:25:56 -0300
Message-ID: <20231213152557.6634-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate next header's offset in ->next_header() so that it isn't
smaller than MID_HEADER_SIZE(server) and then standard_receive3() or
->receive() ends up writing off the end of the buffer because
'pdu_length - MID_HEADER_SIZE(server)' wraps up to a huge length:

  BUG: KASAN: slab-out-of-bounds in _copy_to_iter+0x4fc/0x840
  Write of size 701 at addr ffff88800caf407f by task cifsd/1090

  CPU: 0 PID: 1090 Comm: cifsd Not tainted 6.7.0-rc4 #5
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4a/0x80
   print_report+0xcf/0x650
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __phys_addr+0x46/0x90
   kasan_report+0xd8/0x110
   ? _copy_to_iter+0x4fc/0x840
   ? _copy_to_iter+0x4fc/0x840
   kasan_check_range+0x105/0x1b0
   __asan_memcpy+0x3c/0x60
   _copy_to_iter+0x4fc/0x840
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? hlock_class+0x32/0xc0
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __pfx__copy_to_iter+0x10/0x10
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? lock_is_held_type+0x90/0x100
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __might_resched+0x278/0x360
   ? __pfx___might_resched+0x10/0x10
   ? srso_alias_return_thunk+0x5/0xfbef5
   __skb_datagram_iter+0x2c2/0x460
   ? __pfx_simple_copy_to_iter+0x10/0x10
   skb_copy_datagram_iter+0x6c/0x110
   tcp_recvmsg_locked+0x9be/0xf40
   ? __pfx_tcp_recvmsg_locked+0x10/0x10
   ? mark_held_locks+0x5d/0x90
   ? srso_alias_return_thunk+0x5/0xfbef5
   tcp_recvmsg+0xe2/0x310
   ? __pfx_tcp_recvmsg+0x10/0x10
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? lock_acquire+0x14a/0x3a0
   ? srso_alias_return_thunk+0x5/0xfbef5
   inet_recvmsg+0xd0/0x370
   ? __pfx_inet_recvmsg+0x10/0x10
   ? __pfx_lock_release+0x10/0x10
   ? do_raw_spin_trylock+0xd1/0x120
   sock_recvmsg+0x10d/0x150
   cifs_readv_from_socket+0x25a/0x490 [cifs]
   ? __pfx_cifs_readv_from_socket+0x10/0x10 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   cifs_read_from_socket+0xb5/0x100 [cifs]
   ? __pfx_cifs_read_from_socket+0x10/0x10 [cifs]
   ? __pfx_lock_release+0x10/0x10
   ? do_raw_spin_trylock+0xd1/0x120
   ? _raw_spin_unlock+0x23/0x40
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __smb2_find_mid+0x126/0x230 [cifs]
   cifs_demultiplex_thread+0xd39/0x1270 [cifs]
   ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
   ? __pfx_lock_release+0x10/0x10
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? mark_held_locks+0x1a/0x90
   ? lockdep_hardirqs_on_prepare+0x136/0x210
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __kthread_parkme+0xce/0xf0
   ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
   kthread+0x18d/0x1d0
   ? kthread+0xdb/0x1d0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x34/0x60
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1b/0x30
   </TASK>

Fixes: 8ce79ec359ad ("cifs: update multiplex loop to handle compounded responses")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h |  3 ++-
 fs/smb/client/connect.c  |  7 ++++++-
 fs/smb/client/smb2ops.c  | 19 ++++++++++++-------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7558167f603c..55b3ce944022 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -532,7 +532,8 @@ struct smb_version_operations {
 				 struct mid_q_entry **, char **, int *);
 	enum securityEnum (*select_sectype)(struct TCP_Server_Info *,
 			    enum securityEnum);
-	int (*next_header)(char *);
+	int (*next_header)(struct TCP_Server_Info *server, char *buf,
+			   unsigned int *noff);
 	/* ioctl passthrough for query_info */
 	int (*ioctl_query_info)(const unsigned int xid,
 				struct cifs_tcon *tcon,
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 9dc6dc2754c2..dd2a1fb65e71 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1201,7 +1201,12 @@ cifs_demultiplex_thread(void *p)
 		server->total_read += length;
 
 		if (server->ops->next_header) {
-			next_offset = server->ops->next_header(buf);
+			if (server->ops->next_header(server, buf, &next_offset)) {
+				cifs_dbg(VFS, "%s: malformed response (next_offset=%u)\n",
+					 __func__, next_offset);
+				cifs_reconnect(server, true);
+				continue;
+			}
 			if (next_offset)
 				server->pdu_size = next_offset;
 		}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 8f6f0a38b886..62b0a8df867b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5074,17 +5074,22 @@ smb3_handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 				NULL, 0, false);
 }
 
-static int
-smb2_next_header(char *buf)
+static int smb2_next_header(struct TCP_Server_Info *server, char *buf,
+			    unsigned int *noff)
 {
 	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
 	struct smb2_transform_hdr *t_hdr = (struct smb2_transform_hdr *)buf;
 
-	if (hdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM)
-		return sizeof(struct smb2_transform_hdr) +
-		  le32_to_cpu(t_hdr->OriginalMessageSize);
-
-	return le32_to_cpu(hdr->NextCommand);
+	if (hdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
+		*noff = le32_to_cpu(t_hdr->OriginalMessageSize);
+		if (unlikely(check_add_overflow(*noff, sizeof(*t_hdr), noff)))
+			return -EINVAL;
+	} else {
+		*noff = le32_to_cpu(hdr->NextCommand);
+	}
+	if (unlikely(*noff && *noff < MID_HEADER_SIZE(server)))
+		return -EINVAL;
+	return 0;
 }
 
 int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
-- 
2.43.0

