Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E73932143D;
	Mon, 27 Oct 2025 19:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593194; cv=none; b=Wibq6UWVtkn22XzyPp7tUhlRDIaU16tFLetDTNSIR+Ft8I3jUWN0ABtiWkt8437oQKNupjP3UTxyWX7HbymRuLninBi62S/yXqxAzCdNpk3+i/P+ooZaLnPFHRnjZO79ZorcoGAVJYZWZjieXywaps0p0t1vbXhD7zIUtMOXM1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593194; c=relaxed/simple;
	bh=OKlPKqp1BIEa+XjInYQjJpoUxifXIOS9UESkayeucug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZsBX7nNrleMeNUxXoeAT/f1CcpMGsBXXO59dlfNkkxtfjkvz/q2+hSCczwS+55HJSq5kVSB//Y7FpNmqmVIq0HBl7Kg927VBHHgH6ea8fhM0drDr9n+487d0aZqqSutFcKurWkhrxhA/WGORGtkDIPZ502SSHY51HDZ5ziH3V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JprYiCnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JprYiCnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699B2C4CEF1;
	Mon, 27 Oct 2025 19:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593192;
	bh=OKlPKqp1BIEa+XjInYQjJpoUxifXIOS9UESkayeucug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JprYiCnhPOgJP371M/AQ8EKjaJo9LemvKTAm4tYv3T7ke56TdZ85n0pYVptMWKGUr
	 elE+GxZqv2McUdW9YHC3g5q+QD21ic6zZK5AuzobQaYJOGEqsZpp/3WfSg8xvl9ahO
	 siEDULA/+3l37XrlhIpLW2MzDEuMtyVrRogal/e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 031/184] smb: server: let smb_direct_flush_send_list() invalidate a remote key first
Date: Mon, 27 Oct 2025 19:35:13 +0100
Message-ID: <20251027183515.761319761@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 1b53426334c3c942db47e0959a2527a4f815af50 ]

If we want to invalidate a remote key we should do that as soon as
possible, so do it in the first send work request.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index e1f659d3b4cf5..2363244ff5f75 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -939,12 +939,15 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 			       struct smb_direct_sendmsg,
 			       list);
 
+	if (send_ctx->need_invalidate_rkey) {
+		first->wr.opcode = IB_WR_SEND_WITH_INV;
+		first->wr.ex.invalidate_rkey = send_ctx->remote_key;
+		send_ctx->need_invalidate_rkey = false;
+		send_ctx->remote_key = 0;
+	}
+
 	last->wr.send_flags = IB_SEND_SIGNALED;
 	last->wr.wr_cqe = &last->cqe;
-	if (is_last && send_ctx->need_invalidate_rkey) {
-		last->wr.opcode = IB_WR_SEND_WITH_INV;
-		last->wr.ex.invalidate_rkey = send_ctx->remote_key;
-	}
 
 	ret = smb_direct_post_send(t, &first->wr);
 	if (!ret) {
-- 
2.51.0



