Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF623148C1
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 07:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760513161; cv=none; b=dIW3v09TUlF3P55QvXAIRXofP0PHrveOYRIuhD1hn8pJkuAlrrJd/ph3ZtmHUfrSJXr14ZI6SE65Y1N2Ms9EMOkWTs/wh2LVRb6VM8gNclmty+SqW88iU9U4NPWJzR6go8jjkQRCtuCxw2z6pAUnSO4M1F+NQaDHGbm+Nbglw1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760513161; c=relaxed/simple;
	bh=C9H7qI+WwF2ZS47Bf+jgGE8IwZf075I+jgXngGUcRis=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NBrXhyb9c9rmZzeb/2FALueVUT9TfmXsUvX7iVvVEQknFAS5oJQUdSlLu9J7JqWLMSQVw1xsr7nkqwHybLfcRZMTo6soASY2LtxiBwYGvSQfcj6EnfWJ2FLSH/GoQUrsEKmjT/BBaeretDYLKbRGiRT8y2pOTaXknhzCYlckntQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=oaGH3xJQ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="oaGH3xJQ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46fc5e54cceso19007495e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 00:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1760513156; x=1761117956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+6oiJ84NVFvJdEc3Kt1dEmkqcugGmwxZN5FuD289l+Q=;
        b=oaGH3xJQWJiPV37zUKl4M0R4uLfwMUUFCuQlIL/XYUij/W8OlqN+Bg7+vTdd60GyXv
         N9NdaIA88yKXaS+FD3rRolq+APcvYZC91xJ3YvbGyLYAKTdNagGOum0x7pp5m1Z6zTEu
         zLtbAf0tno8HLVYMkXreOa3JIv273RuGx9GhHqRfty1D7DVJOmw+02BhKYfyMQexUVTk
         pa0iffTVOvnF2T1vMdfVsp+K+TXChfqygp4Uh0CG+tkd94H1MB5NdRgqfAjIMJtD4q9h
         y6VqepggcVkNV8sCAQ5QdXPRiHdg1RDrEbAPqnDburdhXoHLxGfrXx+wPGzPDN3slXVp
         X5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760513156; x=1761117956;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+6oiJ84NVFvJdEc3Kt1dEmkqcugGmwxZN5FuD289l+Q=;
        b=wFSwi/VWU9oOOmubfSwwPZDUMAIi26lgQFyoytBuOODIuJkPM4xMco+PTQzEbHQ0C8
         HM3blOWSCo0prkxOVC6fjWhf4Fn97y/r8YsQgiFS7hNPYxQMC24F4+LcVnurDcOKFWmj
         ntuGYxFm9ubTTyESKlbfFcv8XxRH0Wb/RAKKVb8oMQcjQLbK7/aLRQpj+O8+OrahTsyv
         dfIRwCBlAy8tRfzDcoPuL12TjqLWrFAPt2w56ZreXoxhE4+1HFpjge7jVxu5gB6gSZ7+
         LCvmlhmcoGitw6NfNmKANSu0QKpaYAliSS32HBLl27lDSEk97aCT7dsWYv+geh4eORug
         5+zA==
X-Gm-Message-State: AOJu0YyaqwoPzxdaEx1maNqQEt6oTYqHso9Dgi/fTXbnINy3HMzEY5g5
	m1ADD1hlNQIMUmY8VKZDyaaDtqHjy/WbwPvsqljQtAKJ/XC1qtY5E2xrn5+B2ETbZv4iN08hk/V
	zgp/Y
X-Gm-Gg: ASbGncvvdrMjsUGAq6Yz6NeuxgjWs9AYfrPEDPXGxiq3WFczvrwm4onAJbHGa0Tc1Yd
	XYzr3yLMvsUF03VvznG2371fBcNHy/RVfUZ9DNHhM54odsgD66N6wWiP6MGEyh6Rk5q3tsJMAEv
	M6Ht1ZQaGS4SpTFSkRIGSWwBGUQXyPPiZEWdeaXesgxaKaNvKPb+2j89ADhCGYiQPH050VYbmLW
	vfzpgsmsa6cosUY+KJANW1zNEPvOGtS98WDrqmqkT21JN0BrreAayjzMKQFhen2G/y1FKbwW1Z0
	3/5H4XWUGvL68cIQrFdxWDeTW5yPCrWv3YOb1KsCFx5ssjdzugwHkYy6pFCX+TPBBUBDWcAlRnn
	glCO46KdhcfLL7IIK930ycRl7BuKcuCiX9B//+y67RhuSdtGBFrrGgJfCVz4TjqMs0p0Gwsrp8/
	cfvQo0G1HD
X-Google-Smtp-Source: AGHT+IFyFdtVaJz0KFcAhC7AK2BRQsRrOkLN1ELKYE6q2zILdyoNRrhUzrHYns0RGItKPvvs+srhew==
X-Received: by 2002:a05:600d:f:b0:458:a7fa:211d with SMTP id 5b1f17b1804b1-46fa9b9a84fmr153323435e9.29.1760513154278;
        Wed, 15 Oct 2025 00:25:54 -0700 (PDT)
Received: from odysseia.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb55ac08dsm273573585e9.13.2025.10.15.00.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 00:25:53 -0700 (PDT)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linux-cifs@vger.kernel.org
Cc: Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: fix recursive locking in RPC handle list access
Date: Wed, 15 Oct 2025 09:25:46 +0200
Message-ID: <20251015072546.3941890-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 305853cce3794 ("ksmbd: Fix race condition in RPC handle list
access"), ksmbd_session_rpc_method() attempts to lock sess->rpc_lock.

This causes hung connections / tasks when a client attempts to open
a named pipe. Using Samba's rpcclient tool:

 $ rpcclient //192.168.1.254 -U user%password
 $ rpcclient $> srvinfo
 <connection hung here>

Kernel side:
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:kworker/0:0 state:D stack:0 pid:5021 tgid:5021 ppid:2 flags:0x00200000
  Workqueue: ksmbd-io handle_ksmbd_work
  Call trace:
  __schedule from schedule+0x3c/0x58
  schedule from schedule_preempt_disabled+0xc/0x10
  schedule_preempt_disabled from rwsem_down_read_slowpath+0x1b0/0x1d8
  rwsem_down_read_slowpath from down_read+0x28/0x30
  down_read from ksmbd_session_rpc_method+0x18/0x3c
  ksmbd_session_rpc_method from ksmbd_rpc_open+0x34/0x68
  ksmbd_rpc_open from ksmbd_session_rpc_open+0x194/0x228
  ksmbd_session_rpc_open from create_smb2_pipe+0x8c/0x2c8
  create_smb2_pipe from smb2_open+0x10c/0x27ac
  smb2_open from handle_ksmbd_work+0x238/0x3dc
  handle_ksmbd_work from process_scheduled_works+0x160/0x25c
  process_scheduled_works from worker_thread+0x16c/0x1e8
  worker_thread from kthread+0xa8/0xb8
  kthread from ret_from_fork+0x14/0x38
  Exception stack(0x8529ffb0 to 0x8529fff8)

The task deadlocks because the lock is already held:
  ksmbd_session_rpc_open
    down_write(&sess->rpc_lock)
    ksmbd_rpc_open
      ksmbd_session_rpc_method
        down_read(&sess->rpc_lock)   <-- deadlock

Adjust ksmbd_session_rpc_method() callers to take the lock when necessary.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Fixes: 305853cce3794 ("ksmbd: Fix race condition in RPC handle list access")
---
 fs/smb/server/mgmt/user_session.c |  7 ++-----
 fs/smb/server/smb2pdu.c           |  9 ++++++++-
 fs/smb/server/transport_ipc.c     | 12 ++++++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 6fa025374f2f..1c181ef99929 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -147,14 +147,11 @@ void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id)
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id)
 {
 	struct ksmbd_session_rpc *entry;
-	int method;
 
-	down_read(&sess->rpc_lock);
+	lockdep_assert_held(&sess->rpc_lock);
 	entry = xa_load(&sess->rpc_handle_list, id);
-	method = entry ? entry->method : 0;
-	up_read(&sess->rpc_lock);
 
-	return method;
+	return entry ? entry->method : 0;
 }
 
 void ksmbd_session_destroy(struct ksmbd_session *sess)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b1a8fa6de268..8eb32e30db34 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4629,8 +4629,15 @@ static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 	 * pipe without opening it, checking error condition here
 	 */
 	id = req->VolatileFileId;
-	if (!ksmbd_session_rpc_method(sess, id))
+
+	lockdep_assert_not_held(&sess->rpc_lock);
+
+	down_read(&sess->rpc_lock);
+	if (!ksmbd_session_rpc_method(sess, id)) {
+		up_read(&sess->rpc_lock);
 		return -ENOENT;
+	}
+	up_read(&sess->rpc_lock);
 
 	ksmbd_debug(SMB, "FileInfoClass %u, FileId 0x%llx\n",
 		    req->FileInfoClass, req->VolatileFileId);
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 2aa1b29bea08..46f87fd1ce1c 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -825,6 +825,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
 	if (!msg)
 		return NULL;
 
+	lockdep_assert_not_held(&sess->rpc_lock);
+
+	down_read(&sess->rpc_lock);
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
 	req->handle = handle;
@@ -833,6 +836,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
 	req->flags |= KSMBD_RPC_WRITE_METHOD;
 	req->payload_sz = payload_sz;
 	memcpy(req->payload, payload, payload_sz);
+	up_read(&sess->rpc_lock);
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_free(msg);
@@ -849,6 +853,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_read(struct ksmbd_session *sess, int handle)
 	if (!msg)
 		return NULL;
 
+	lockdep_assert_not_held(&sess->rpc_lock);
+
+	down_read(&sess->rpc_lock);
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
 	req->handle = handle;
@@ -856,6 +863,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_read(struct ksmbd_session *sess, int handle)
 	req->flags |= rpc_context_flags(sess);
 	req->flags |= KSMBD_RPC_READ_METHOD;
 	req->payload_sz = 0;
+	up_read(&sess->rpc_lock);
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_free(msg);
@@ -876,6 +884,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
 	if (!msg)
 		return NULL;
 
+	lockdep_assert_not_held(&sess->rpc_lock);
+
+	down_read(&sess->rpc_lock);
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
 	req->handle = handle;
@@ -884,6 +895,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
 	req->flags |= KSMBD_RPC_IOCTL_METHOD;
 	req->payload_sz = payload_sz;
 	memcpy(req->payload, payload, payload_sz);
+	up_read(&sess->rpc_lock);
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_free(msg);
-- 
2.51.0

