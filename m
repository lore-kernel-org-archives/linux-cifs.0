Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF17C33A9FE;
	Mon, 20 Apr 2026 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699857; cv=none; b=pbFfnmug3/clhZ7Yq45I23BHpG9sEQ1zmJBeAvchgJBdYz+SryUo2QoLZfnBhR8QP0M/SjM8eqRxay+FrI+w3M2pgSncfCef/ozWgjrXI7hOuMxd3nlNTMlXgBNNtbUl7WpxIeijia+4kmFd6n6WoKjnImHydDi5Ikr7Ulzg1M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699857; c=relaxed/simple;
	bh=LYTCiJf6qmLJkGVTnGHAKZBzm29nm5z8atWCuRnlyMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unn/92uppLrXm8nrbToC4clACCP7haGmSNTLV5YhOxLa3ODVzVnWE9A+zZBEBDgto7G4ARwaHtD0EqXSnPgYK7qwiffuiq0HJpbOtNVRGvjlHUPKvom930z/yr9WF610lk1Hbenw7go4xSdV0Nl1ZoeLmINPCysKrXY/n9OirYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fptz5j59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fptz5j59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A926C19425;
	Mon, 20 Apr 2026 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699857;
	bh=LYTCiJf6qmLJkGVTnGHAKZBzm29nm5z8atWCuRnlyMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fptz5j59Ehb+XYjctgBeiQwpSOliVTB4CrbKrwYSPJatsMzXE++5ILFE1+crVsV9u
	 j8Sj1l+yaWz6NEFOibKXkw+7/69oTqpmY1AgVOaIzoMQt5kzxYNKGTGUYgAiu9Ovy+
	 WYrhAHu84YVi60gmqj+0320wvPFop+tqk5BM3AZk=
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
Subject: [PATCH 7.0 24/76] smb: server: avoid double-free in smb_direct_free_sendmsg after smb_direct_flush_send_list()
Date: Mon, 20 Apr 2026 17:41:35 +0200
Message-ID: <20260420153911.703560229@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1588,15 +1588,21 @@ static int smb_direct_post_send_data(str
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


