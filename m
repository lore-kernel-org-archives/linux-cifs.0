Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAE554723;
	Fri, 13 Feb 2026 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990835; cv=none; b=rbhZzPzqvKBPWtbkmVxgDW1CScLmZK/Z3PPJDMYn5Q0s2eNdKS/TUim/h1UgglZl8uMXA7ZASmCMjp8ZuL3vn8niGXkh8lkqrRrQtPbidn53s3++VEMBagxbdbfMyDu5YeYyVdV+6ruKEKwtWRO1+xn7YVJh+CHc3wS+UsYkUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990835; c=relaxed/simple;
	bh=zq2DU7phj5dAJ5/brgIDEVBiXsTdoGJg32TBLgo2qOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEPtH4MdWueF4nqSpJqQ76pptUXJg/3qTXQXrm5BHCDa+qZNtbqaDNhIn1aeNkIiJBzsBlSwmNatZpmv19E4IaK8ZeIg8o0vWjFfrehO4mADoyEcd5eeZln+8ubSm7Q83OX5wMyr+cNQ8HqEt1Cn8ltQoD+DjeVLGhSzRTRLJWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eq6HbzDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eq6HbzDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC872C116C6;
	Fri, 13 Feb 2026 13:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990835;
	bh=zq2DU7phj5dAJ5/brgIDEVBiXsTdoGJg32TBLgo2qOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eq6HbzDqEh/IB4HQaWvkK0sIfQlcjJlQPWQ5gp9MxKxfaRGzoHwXJrR/qNm9GENuH
	 PYcy8wJ2u0fBf10kcbIkxKw6Ri32rt15FQsnrcWMoGHFOeFYXDQfvFRM9wboRbtDbf
	 +4QLMu62u7VgwLZjG7vn/35h1nfbhFs1bjACSlvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 08/49] smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*
Date: Fri, 13 Feb 2026 14:47:52 +0100
Message-ID: <20260213134709.191402372@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 8e94268b21c8235d430ce1aa6dc0b15952744b9b upstream.

It turns out that our code will corrupt the stream of
reassabled data transfer messages when we trigger an
immendiate (empty) send.

In order to fix this we'll have a single 'batch' credit per
connection. And code getting that credit is free to use
as much messages until remaining_length reaches 0, then
the batch credit it given back and the next logical send can
happen.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -155,6 +155,17 @@ struct smbdirect_socket {
 		} mem;
 
 		/*
+		 * This is a coordination for smbdirect_send_batch.
+		 *
+		 * There's only one possible credit, which means
+		 * only one instance is running at a time.
+		 */
+		struct {
+			atomic_t count;
+			wait_queue_head_t wait_queue;
+		} bcredits;
+
+		/*
 		 * The local credit state for ib_post_send()
 		 */
 		struct {
@@ -359,6 +370,9 @@ static __always_inline void smbdirect_so
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
 
+	atomic_set(&sc->send_io.bcredits.count, 0);
+	init_waitqueue_head(&sc->send_io.bcredits.wait_queue);
+
 	atomic_set(&sc->send_io.lcredits.count, 0);
 	init_waitqueue_head(&sc->send_io.lcredits.wait_queue);
 
@@ -473,6 +487,8 @@ struct smbdirect_send_batch {
 	 */
 	bool need_invalidate_rkey;
 	u32 remote_key;
+
+	int credit;
 };
 
 struct smbdirect_recv_io {


