Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CB51E3DED;
	Tue,  3 Dec 2024 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239704; cv=none; b=JbQjWIuGQ9rnPbPDqfy0AVT1GOzL1HloPNzLZycoqxSaNjs+zm4WfVBhgqif5UGXq13QmHh9WjnAJ2jl/O+l1vtSZv5fIHLQPljgVWpceFU/rYh2jDiTL7icJS3+bAjGa5aQVglHxspMFDOb3exIQsaJJROPCeaXLaJryGrSyNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239704; c=relaxed/simple;
	bh=NgY/ZSeIIjpa7hYGELJmhvjSgg8o3hYvlly3zU7NO1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfUh5we4N3iEoMlzId5kd7Iwf0RglOK7hZVW4aNITcMgY88Y2Dxxed/ePgYEOp9AYESJFHUAPo42pSAALVHeFMI8qO7mNhCmRMvqho7S1Se5dI3MDM3SqycvoSSlA22kg0kYnd2MQyNpPhSMEb6aOlnMD/96HT50+ucvTL32fXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1rf9lrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1rf9lrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048ADC4CECF;
	Tue,  3 Dec 2024 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239704;
	bh=NgY/ZSeIIjpa7hYGELJmhvjSgg8o3hYvlly3zU7NO1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1rf9lrFGakPVm3VBUT2fco13VGS6lBkUMDmWlOihOEmQyYSvAzvpeLFdp6oYIpr7
	 mWektDGAOBLfTVLL4gjVNHhitqLSbi3iTiJ/8Be9eTc8Vs/xZttEhUQHiqbKfkD4tv
	 8n3JUnpjTHLr79z2AZJoDw5vbX+oSQO2HyajsmA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	syzkaller@googlegroups.com,
	Yunseong Kim <yskelg@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 705/817] ksmbd: fix use-after-free in SMB request handling
Date: Tue,  3 Dec 2024 15:44:37 +0100
Message-ID: <20241203144023.499149914@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunseong Kim <yskelg@gmail.com>

commit 9a8c5d89d327ff58e9b2517f8a6afb4181d32c6e upstream.

A race condition exists between SMB request handling in
`ksmbd_conn_handler_loop()` and the freeing of `ksmbd_conn` in the
workqueue handler `handle_ksmbd_work()`. This leads to a UAF.
- KASAN: slab-use-after-free Read in handle_ksmbd_work
- KASAN: slab-use-after-free in rtlock_slowlock_locked

This race condition arises as follows:
- `ksmbd_conn_handler_loop()` waits for `conn->r_count` to reach zero:
  `wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);`
- Meanwhile, `handle_ksmbd_work()` decrements `conn->r_count` using
  `atomic_dec_return(&conn->r_count)`, and if it reaches zero, calls
  `ksmbd_conn_free()`, which frees `conn`.
- However, after `handle_ksmbd_work()` decrements `conn->r_count`,
  it may still access `conn->r_count_q` in the following line:
  `waitqueue_active(&conn->r_count_q)` or `wake_up(&conn->r_count_q)`
  This results in a UAF, as `conn` has already been freed.

The discovery of this UAF can be referenced in the following PR for
syzkaller's support for SMB requests.
Link: https://github.com/google/syzkaller/pull/5524

Fixes: ee426bfb9d09 ("ksmbd: add refcnt to ksmbd_conn struct")
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org # v6.6.55+, v6.10.14+, v6.11.3+
Cc: syzkaller@googlegroups.com
Signed-off-by: Yunseong Kim <yskelg@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/server.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -276,8 +276,12 @@ static void handle_ksmbd_work(struct wor
 	 * disconnection. waitqueue_active is safe because it
 	 * uses atomic operation for condition.
 	 */
+	atomic_inc(&conn->refcnt);
 	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
 		wake_up(&conn->r_count_q);
+
+	if (atomic_dec_and_test(&conn->refcnt))
+		kfree(conn);
 }
 
 /**


