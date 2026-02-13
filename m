Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3B535F8B2;
	Fri, 13 Feb 2026 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990593; cv=none; b=qTwU+1bNwql7XavMIwRSXFaG2+3P8uVlhTZJ2XrhvTLnHK39aK5/U0XiyFove1wKn1BvR48E0Vs3b4I1Za9K9KeGm3iQRoR5TgmHaml9TFiHGmJ1VgSdrQpYE9g8dURl6TZM2Ip2qMWRFZVhIHrobi0NPrX9p4KESSJeLcRP6Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990593; c=relaxed/simple;
	bh=kwEqMAF3u5X6lcFhhy9x2ow1c14Q46qw2u33YJVJy9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMNAiYP+0kWLEGGPhYS4zf8Fs72NsMszjIrZzwzsuVPL83U/gZAAgexLjdG/vJpAWhI2zFQo/7Wqn/y+f8UyrPsGvAdjoJDxrQ6fec6v+x7QuW43FWaIH1/9FXsb9g6yCxGj8X4V/stAjwabfaAxNN1djux4IlEZrQ5fnjmAS6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w64tfPea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w64tfPea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD863C116C6;
	Fri, 13 Feb 2026 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990593;
	bh=kwEqMAF3u5X6lcFhhy9x2ow1c14Q46qw2u33YJVJy9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w64tfPeahcaIUMtSvmPjwDx33DOfaUFCx61kPDdvxvNeLFTercD1TMWo4lsFOjeFv
	 i4OB1p+ticELOvWCrxmMs0RUDALf2LDIFMI7vgRLGPGGCU6EL86M7Y4AU2G4AYvuDj
	 UL4OsPa/C5HZ/3BmYYcJmr+gXIORQXzo6zlTZq3s=
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
Subject: [PATCH 6.19 17/49] smb: client: remove pointless sc->recv_io.credits.count rollback
Date: Fri, 13 Feb 2026 14:47:36 +0100
Message-ID: <20260213134709.361391511@linuxfoundation.org>
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

commit 6858531e5e8d68828eec349989cefce3f45a487f upstream.

We either reach this code path before we call
new_credits = manage_credits_prior_sending(sc),
which means new_credits is still 0
or the connection is already broken as
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
 fs/smb/client/smbdirect.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1288,9 +1288,6 @@ err_dma:
 					    DMA_TO_DEVICE);
 	mempool_free(request, sc->send_io.mem.pool);
 
-	/* roll back the granted receive credits */
-	atomic_sub(new_credits, &sc->recv_io.credits.count);
-
 err_alloc:
 	atomic_inc(&sc->send_io.credits.count);
 	wake_up(&sc->send_io.credits.wait_queue);


