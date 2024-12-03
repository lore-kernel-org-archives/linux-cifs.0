Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAD781ADA;
	Tue,  3 Dec 2024 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242437; cv=none; b=CI3/78yMpLHi4xRNJfgu1DlAcRwyZysoYmYmpr3wxY4wPzIMGWBRLHlGRh8/f9dP7t5WZ6308suBQRZLdz/2/v6YMgRQ51CzaZq7f7j8FVj2f4Xd3Usa1YLgJZrRl+TWLOGSIgib1fzhlhS2hoCpLk2magwY8H6rouXwJ5Ww088=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242437; c=relaxed/simple;
	bh=xa4ZyBdwllJVdeL84XZoloc3c1cpqAOw9IuuIrfaocE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7ixg6XASSVrqcASsaEdKYUeqOYwzCykdRwamranLC/6GN1URMBr1hL5+IQh6TSKDGmx+Mcsj2EGJIUZMnQ0SMkzAY0NH/Wi08h9QEtDweW+nfiVitTnwPp9YcXz0YRDUvcgopQIMviLQG3Ru2LWj6otjRnU2/VGqzqmLKu7OUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtJWOiZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtJWOiZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C428DC4CECF;
	Tue,  3 Dec 2024 16:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242437;
	bh=xa4ZyBdwllJVdeL84XZoloc3c1cpqAOw9IuuIrfaocE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtJWOiZ//cGVmPAJT+GFBSOwRLoQiU1yDsUyrqBU2NpGmJ42rHfAvZYMjyCZsQ5B8
	 rxX4so3mEkL1YfHTn4Z1oP3B1RR5wzZ8Sz3HEfYJyiU9QETqdudEdz8V5oG5ln9cQZ
	 n3Fwo+ER6eJZ7erRSfCrK00yIvivZ6WiMro43vus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	syzkaller@googlegroups.com,
	Yunseong Kim <yskelg@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 703/826] ksmbd: fix use-after-free in SMB request handling
Date: Tue,  3 Dec 2024 15:47:10 +0100
Message-ID: <20241203144811.180521239@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


