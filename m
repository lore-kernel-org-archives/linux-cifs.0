Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7E13385B6;
	Mon, 20 Apr 2026 15:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700413; cv=none; b=qad4vfanTobh88UAZeWUCMuzcJ5y8WC+floyrI8k2qm1Xk1wbBwzfy7HFJoIJNdXPVILMbgDbs4x0sz6tnUE/mX5ycnJPRqgvqUQGpnC0Dy+03RKqh7ZbG6zx8pQE4wKb7Up6Xru1dDxIzA/QNJy1BLNMB+QbW7NauGVi2jHAxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700413; c=relaxed/simple;
	bh=PCOAMG2cnXCVvseTE7WEixzt1QirYHj5a+Pu4sKdGmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxyHHU5P+Q9fuDECA5iovD9yMqXZWDqnpybHOnppZZGE65FM06yrAqeQ2ggpHmZbmu1f1+DatumIW0PYKM63xlstWhV2GhqhpdgoE1KJAnF7XC+Po2ewtH9S3Pkb4SILFCqQxvvTo+I1e2Nu9iGNlsAfUqJzEoXpk1wiZ3SUvgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n87Ysi3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n87Ysi3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC73C4AF09;
	Mon, 20 Apr 2026 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700412;
	bh=PCOAMG2cnXCVvseTE7WEixzt1QirYHj5a+Pu4sKdGmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n87Ysi3yV/2roUX2iXyRJ09azXdfk6BrMUTVgQPOrHRs5erKxDXkncHVasJCxZN/E
	 ekpXk9MRQiTbL8VzTOk0OTJ+feIkTzqg5XrukC3DjBU3T6WU/kXb0joblZN1A3AYkG
	 Ype5BsLnl9Caq8qxq+U/jr31xL7M3r9GJvFk7ztU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruikai Peng <ruikai@pwno.io>,
	stable@kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	security@kernel.org,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 162/220] smb: server: avoid double-free in smb_direct_free_sendmsg after smb_direct_flush_send_list()
Date: Mon, 20 Apr 2026 17:41:43 +0200
Message-ID: <20260420153939.862198773@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

commit 84ff995ae826aa6bbcc6c7b9ea569ff67c021d72 upstream.

smb_direct_flush_send_list() already calls smb_direct_free_sendmsg(),
so we should not call it again after post_sendmsg()
moved it to the batch list.

Reported-by: Ruikai Peng <ruikai@pwno.io>
Closes: https://lore.kernel.org/linux-cifs/CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com/
Fixes: 34abd408c8ba ("smb: server: make use of smbdirect_socket.send_io.bcredits")
Cc: stable@kernel.org
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ruikai Peng <ruikai@pwno.io>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: security@kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Tested-by: Ruikai Peng <ruikai@pwno.io>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1575,15 +1575,21 @@ static int smb_direct_post_send_data(str
 	if (ret)
 		goto err;
 
+	/*
+	 * From here msg is moved to send_ctx
+	 * and we should not free it explicitly.
+	 */
+
 	if (send_ctx == &_send_ctx) {
 		ret = smb_direct_flush_send_list(sc, send_ctx, true);
 		if (ret)
-			goto err;
+			goto flush_failed;
 	}
 
 	return 0;
 err:
 	smb_direct_free_sendmsg(sc, msg);
+flush_failed:
 header_failed:
 	atomic_inc(&sc->send_io.credits.count);
 credit_failed:


