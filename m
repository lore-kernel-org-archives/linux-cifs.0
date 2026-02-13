Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89F354AE7;
	Fri, 13 Feb 2026 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990596; cv=none; b=I0PgBGBBcQiioDPoFglmmWl6SGpw55eivHpPe/yNcT89lfo9KFxPtKkzuW6feQzPVfQWoUB5PU3c2Ue9qNat+4av6es+SPI39PjHZkOeVqr4EB+Yb/hTA+MzDRsoZ5eYDoWRG3uQUXGh/eA5QwhOpQwXrJCptupK7GbQSc+uctA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990596; c=relaxed/simple;
	bh=niSonsek+zzh8u9mOPrMxw4ZfoEGwD0wlGJ8MWFEOys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgreMH24PM3XKwIdKpwMea7oQ7xby7tp6cH+V03Ai4bAJESPkGOg+afuB3EGspDKpMKA+8p1VyHMyW4cmHe32krpTxQWjBE9mTFMBj86i+OIMoLKOBW5BMOk7lWGqs1uR9y9aZk4dRY8YcuQVGyR20Fmsm+iKZiUsOJ4RQIYu3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XbE99j3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XbE99j3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27604C116C6;
	Fri, 13 Feb 2026 13:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990596;
	bh=niSonsek+zzh8u9mOPrMxw4ZfoEGwD0wlGJ8MWFEOys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XbE99j3ghRAaIz9FGIsIzdFS9VCNWlLGjDVmFrgojPzNBN+P1LixFra7jZAGnEdq
	 C6lDnVQBVyY/IE/RnoDZLJbCOSNNme5ha+KDZPbkwOLf7r+HLCuqpyK46YJ3bhjj/d
	 DePE/ZYMEuUiI5G958wbOKrzdjP6l8DUuh0bG7CE=
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
Subject: [PATCH 6.19 18/49] smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()
Date: Fri, 13 Feb 2026 14:47:37 +0100
Message-ID: <20260213134709.398297892@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 8bfe3fd33f36b987c8200b112646732b5f5cd8b3 upstream.

If we reach this the connection is already broken as
smbd_post_send() already called
smbd_disconnect_rdma_connection().

This will also simplify further changes.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1274,11 +1274,6 @@ wait_credit:
 	if (!rc)
 		return 0;
 
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-	wake_up(&sc->send_io.pending.dec_wait_queue);
-
 err_dma:
 	for (i = 0; i < request->num_sge; i++)
 		if (request->sge[i].addr)


