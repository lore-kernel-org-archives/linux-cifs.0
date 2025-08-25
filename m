Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B7D28C00D
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154673; cv=none; b=Ho9pbSFONsAvvU6Zfe5st5NcScdeJD2avYQ8dSswrqwcc00vlOvxpkMhOuiS0PvJjmbEvTpBxQUF0xEqdyFMg6+vNZYHtYCUvLuSelIi7VHhgFP8VqS8fA4VAoD9NYCnYVWYhlPi/vPbhkReUCLBj8dSpw5EDuRpwrj6PRDV+R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154673; c=relaxed/simple;
	bh=L9EGmmnnXD0se1/scnCL7+HxOjZvFjvA1v6CpnSCXUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNs9FX9/iW3ZUkRMkuCnUDZzkF8m+g+gq4s14lcuc+HN7iHNd8FTwUpelPp+rzx2K/iD2t8x8qAdictXu5y2aUmAkI2CZEucWLJFxzs47fZrlz0yF3P6AJUKZMGJfFbtUnW86fyCK4UgsSm7Y6SibFGm76PM32pEyfe8EFAJu8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BaaeR3Hl; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BaaeR3Hl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=2xlJXPzPk3P1CMeruOsdqKAMRmOlgnuQV272X11hZWs=; b=BaaeR3HlgAa9rxwGp0hdr+NKd1
	DPzP8trxLBf7XMnF5w+DH6jYXqtFLSr/s7kwdlhO9mPjZ0HdUHqbT4VmIGiT1mn8XEpeP/cA0OSTa
	m1wLO3K5bQMAo8P409H4k8d0FkiuedWjuf/3zNizkdsx/1UK7mgtdiFCX2f+s2Al4THTYe0+i+xFZ
	DvfCfYw8W/XuI8FgzeqiBzQc1JHxpsXagnf4yoMbrJViAUjORIxJCh9YWXIICt0tWRrKXHqUVOrON
	i0+j6HD886TK7t6vFK16MQzlz+1flGb9w3wZegZpchxnG7s3+iTB8wk5lrQDqkBQCRmXYa6BAfECm
	bUOsOAAkC9NjT7SUgBnZVf1pvTqwW9DixqCs1lJR7coZtAQOjozdgs6v+V/Uk4naXGnYFw+rp21YW
	OAGgKnFUBcoTZbrTudfYP51Jup0lQgP0qDOGOTsAdYbg59OII05/AjJDUFJPn0gZpxx/z/4XsZS+W
	TF1UMdghmSV65Qe76pUfoj3h;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe3E-000jeQ-0L;
	Mon, 25 Aug 2025 20:44:25 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 015/142] smb: smbdirect: introduce smbdirect_socket.workqueue
Date: Mon, 25 Aug 2025 22:39:36 +0200
Message-ID: <bb8d3aef2a5f89376f84c4a032b16707960de1d6.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The client currently used a per socket workqueue
because it can block in a work function
waiting for credits.

So we use a per socket pointer in order to prepare
common code.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 5df0143ccd6a..c4e37c156f46 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -28,6 +28,14 @@ struct smbdirect_socket {
 	enum smbdirect_socket_status status;
 	wait_queue_head_t status_wait;
 
+	/*
+	 * This points to the workqueue to
+	 * be used for this socket.
+	 * It can be per socket (on the client)
+	 * or point to a global workqueue (on the server)
+	 */
+	struct workqueue_struct *workqueue;
+
 	struct work_struct disconnect_work;
 
 	/* RDMA related */
-- 
2.43.0

