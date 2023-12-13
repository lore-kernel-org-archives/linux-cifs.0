Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="pKbXJl5l"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE90D1721
	for <linux-cifs@vger.kernel.org>; Wed, 13 Dec 2023 07:26:10 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702481169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbTFtpPCzSE0WYe6J1ZwMzq/NEjRYLyb0YdqIcLH/5I=;
	b=pKbXJl5l9Ot0yVuTMqsZi14xq2mMrIaW+vhHcDv80mk518HyXAUj5EaUgXau+MjSpXlop6
	BdUTViySP8CHQ6FY+iJRDH9A5rAKf9KiP+iiuhGeX7IGY3xzuXLO8JYvw8jSpUb1sWzpyf
	nIhInii6AIoOWtsvZMxVaw07E7xPlDZvJYhnbhby/kQlW8jWjFYpCz7dD0KjE/chnVRE5n
	OTuhEpiAY7eSGSk24eHDndktMuovfj28kpqoPfkLoPnUiHzua3Eco5UcAODjC5LEQAShvK
	wA0MyHb7gbnoUJhTbdREFCsYDRqca1z7BMOA+DAe9hfMYOMbKPYav8cIX5AOWA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1702481169; a=rsa-sha256;
	cv=none;
	b=nfIHH0ATCqQ0LwIijC4vOuDUGB8hE0IeCKsfcJKTqPMtDgB9tkguOzK6YbVCr+I73VG3+l
	YT3gp+DhqDM6nPeYwo1ZuuEReHBlKU4gIVEET1jCMjtsgKfSTUDJLmYThMO/zabgtmzmTL
	YUIJ/eJ4eJgya8iEAVJeS383pZHAI56l97OdtjJAQl0ZwBQeNeHOukd5ROdO0tB2gl+/+k
	eGjHMIzuE7j0h+4Fs9QGfWDxfHQbARSHjuGhy/qk6Qloc+/BJL9o9q5aj+Uaf+RAZ1vTOG
	auorfYKjKXYUcRKR/mLoiUTruOuHfO6zfh5+C82CEpO9mwWvevAscRDJ1Cpc3Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702481169; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbTFtpPCzSE0WYe6J1ZwMzq/NEjRYLyb0YdqIcLH/5I=;
	b=LCQCq/OdQzhC8Ug2i1HAXAkA9BHnoHaEFyRAVEDzp3WskIap6FsuC4y1yr0rRV+3w5Mkk1
	7YOILEFcc5ZLYok1KMs+e1pV9so7EAS5JhXcNi6dSkQRrAOPtONUhQNGk6aQXnVzWdnnJp
	tHGtSlMIJfWUac3Uz4enZ/4jdBSTp2S/IhlY0N/EXZ8S3jbuRN1PaDPSdjUdVUwhlHcFlZ
	6Ngkmb+cCfTD4WmUbXkCtk41O/HqkLNLbVrFh+lDT1gb4BE0mBrpyYIoWtS+nmZpGOsEg0
	zVx+7qbF/9QxSAFEEgjnFzZSDSp/i+qF/aOfQvZmKWNoBHyXBKn2rHm76E+wtQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Robert Morris <rtm@csail.mit.edu>
Subject: [PATCH 2/2] smb: client: fix OOB in SMB2_query_info_init()
Date: Wed, 13 Dec 2023 12:25:57 -0300
Message-ID: <20231213152557.6634-2-pc@manguebit.com>
In-Reply-To: <20231213152557.6634-1-pc@manguebit.com>
References: <20231213152557.6634-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A small CIFS buffer (448 bytes) isn't big enough to hold
SMB2_QUERY_INFO request along with user's input data from
CIFS_QUERY_INFO ioctl.  That is, if the user passed an input buffer >
344 bytes, the client will memcpy() off the end of @req->Buffer in
SMB2_query_info_init() thus causing the following KASAN splat:

  BUG: KASAN: slab-out-of-bounds in SMB2_query_info_init+0x242/0x250 [cifs]
  Write of size 1023 at addr ffff88801308c5a8 by task a.out/1240

  CPU: 1 PID: 1240 Comm: a.out Not tainted 6.7.0-rc4 #5
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4a/0x80
   print_report+0xcf/0x650
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __phys_addr+0x46/0x90
   kasan_report+0xd8/0x110
   ? SMB2_query_info_init+0x242/0x250 [cifs]
   ? SMB2_query_info_init+0x242/0x250 [cifs]
   kasan_check_range+0x105/0x1b0
   __asan_memcpy+0x3c/0x60
   SMB2_query_info_init+0x242/0x250 [cifs]
   ? __pfx_SMB2_query_info_init+0x10/0x10 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? smb_rqst_len+0xa6/0xc0 [cifs]
   smb2_ioctl_query_info+0x4f4/0x9a0 [cifs]
   ? __pfx_smb2_ioctl_query_info+0x10/0x10 [cifs]
   ? __pfx_cifsConvertToUTF16+0x10/0x10 [cifs]
   ? kasan_set_track+0x25/0x30
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __kasan_kmalloc+0x8f/0xa0
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? cifs_strndup_to_utf16+0x12d/0x1a0 [cifs]
   ? __build_path_from_dentry_optional_prefix+0x19d/0x2d0 [cifs]
   ? __pfx_smb2_ioctl_query_info+0x10/0x10 [cifs]
   cifs_ioctl+0x11c7/0x1de0 [cifs]
   ? __pfx_cifs_ioctl+0x10/0x10 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? rcu_is_watching+0x23/0x50
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __rseq_handle_notify_resume+0x6cd/0x850
   ? __pfx___schedule+0x10/0x10
   ? blkcg_iostat_update+0x250/0x290
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? ksys_write+0xe9/0x170
   __x64_sys_ioctl+0xc9/0x100
   do_syscall_64+0x47/0xf0
   entry_SYSCALL_64_after_hwframe+0x6f/0x77
  RIP: 0033:0x7f893dde49cf
  Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48
  89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89>
  c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
  RSP: 002b:00007ffc03ff4160 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00007ffc03ff4378 RCX: 00007f893dde49cf
  RDX: 00007ffc03ff41d0 RSI: 00000000c018cf07 RDI: 0000000000000003
  RBP: 00007ffc03ff4260 R08: 0000000000000410 R09: 0000000000000001
  R10: 00007f893dce7300 R11: 0000000000000246 R12: 0000000000000000
  R13: 00007ffc03ff4388 R14: 00007f893df15000 R15: 0000000000406de0
   </TASK>

Fix this by increasing size of SMB2_QUERY_INFO request buffers and
validating input length to prevent other callers from overflowing @req
in SMB2_query_info_init() as well.

Fixes: f5b05d622a3e ("cifs: add IOCTL for QUERY_INFO passthrough to userspace")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
---
 fs/smb/client/smb2pdu.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c571760ad39a..23da76f668cb 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -471,10 +471,15 @@ static int __smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
 				 void **request_buf, unsigned int *total_len)
 {
 	/* BB eventually switch this to SMB2 specific small buf size */
-	if (smb2_command == SMB2_SET_INFO)
+	switch (smb2_command) {
+	case SMB2_SET_INFO:
+	case SMB2_QUERY_INFO:
 		*request_buf = cifs_buf_get();
-	else
+		break;
+	default:
 		*request_buf = cifs_small_buf_get();
+		break;
+	}
 	if (*request_buf == NULL) {
 		/* BB should we add a retry in here if not a writepage? */
 		return -ENOMEM;
@@ -3587,8 +3592,13 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	struct smb2_query_info_req *req;
 	struct kvec *iov = rqst->rq_iov;
 	unsigned int total_len;
+	size_t len;
 	int rc;
 
+	if (unlikely(check_add_overflow(input_len, sizeof(*req), &len) ||
+		     len > CIFSMaxBufSize))
+		return -EINVAL;
+
 	rc = smb2_plain_req_init(SMB2_QUERY_INFO, tcon, server,
 				 (void **) &req, &total_len);
 	if (rc)
@@ -3610,7 +3620,7 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 
 	iov[0].iov_base = (char *)req;
 	/* 1 for Buffer */
-	iov[0].iov_len = total_len - 1 + input_len;
+	iov[0].iov_len = len;
 	return 0;
 }
 
@@ -3618,7 +3628,7 @@ void
 SMB2_query_info_free(struct smb_rqst *rqst)
 {
 	if (rqst && rqst->rq_iov)
-		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+		cifs_buf_release(rqst->rq_iov[0].iov_base); /* request */
 }
 
 static int
@@ -5493,6 +5503,11 @@ build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon,
 	return 0;
 }
 
+static inline void free_qfs_info_req(struct kvec *iov)
+{
+	cifs_buf_release(iov->iov_base);
+}
+
 int
 SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 	      u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdata)
@@ -5524,7 +5539,7 @@ SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
-	cifs_small_buf_release(iov.iov_base);
+	free_qfs_info_req(&iov);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
 		goto posix_qfsinf_exit;
@@ -5575,7 +5590,7 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
-	cifs_small_buf_release(iov.iov_base);
+	free_qfs_info_req(&iov);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
 		goto qfsinf_exit;
@@ -5642,7 +5657,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
-	cifs_small_buf_release(iov.iov_base);
+	free_qfs_info_req(&iov);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
 		goto qfsattr_exit;
-- 
2.43.0

