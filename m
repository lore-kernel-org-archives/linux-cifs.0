Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FCB72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046151; cv=none; b=Qd/sMNhSw9p1hza+D09bbIaiax0lAh9wqUPg96MqwN5/1IYYDQWRihMdCTGMyHshf/Tj98jWwsRxqcFtwTjUVBxZEwubVziBpD/bLFqHg1cdWw2Xcv6eGPxaiDj0PA197BMjRoGp1BHND6baVyR0kKrWMOaSYbS/s0Mes2hPZNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046151; c=relaxed/simple;
	bh=oVI1m2++rUVGhEZjqCjdu48z+e93rwSZiICnJM7h5e0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nzROGveMaUGQ8LfdMB5Xhdiyx9uH/Cd1xJDYH0xiGV1mV5pRV/fYjnvrj3M9pwMXn7kWbI7rXHI3UC52BbrNdEmBA5CX1THKjlvwl5qkWUvOnqcHdV4QDnN8RCz3MWnB4kAu9/90eWfyJPdBIsC1JUKXxTyFFZPF+Nx8KMQAt3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APvj5JF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APvj5JF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FA61F00A3A;
	Sun, 21 Jun 2026 12:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046150;
	bh=kOOnUPe92oMkyhD/prmU2CvGUgiL4TfMsRyfcXGffg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APvj5JF6Rm+iBixQLRIsv9dCBlPRCwQaJ4bVXox6/mIlSEiiYtGn07ArdGKrMlC16
	 p3P2GJOIriHlpv2CZXWh3q8D7HbqH56V+P7JHsiJxRmIdAeXk6AH+qA/5S3qdlylUx
	 t2Ze6ZMF8vinNE2XdDZlvbgF7PYIX5I2SV8djq4TKTWcxNHM3STWo2ap+v374Oc6RP
	 1+u8Y2C5Jl2lYPvYEr4dti1o+Y7a3DEPV4cXlovCAA23mvLzlej290BVbwEdtveTxg
	 G1H2WcF85oQyPxsR910TD2psYiiDUxKIYPG06RW2EeWV9K039i0LGpqNyOpX8Vo5rC
	 LP8srAs0i+ZaQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 10/29] ksmbd: validate handle for create or get object id
Date: Sun, 21 Jun 2026 21:48:25 +0900
Message-Id: <20260621124844.6235-10-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FSCTL_CREATE_OR_GET_OBJECT_ID returned a dummy successful response without
checking whether the request handle was valid. That let an invalid related
compound handle succeed in smb2.compound.related5, although the client
expected STATUS_FILE_CLOSED.

Look up the file handle before building the object id response and fail
with STATUS_FILE_CLOSED when the handle is invalid or already closed.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index df79533dc0a2..d3bd198ec938 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8789,6 +8789,15 @@ int smb2_ioctl(struct ksmbd_work *work)
 	case FSCTL_CREATE_OR_GET_OBJECT_ID:
 	{
 		struct file_object_buf_type1_ioctl_rsp *obj_buf;
+		struct ksmbd_file *fp;
+
+		fp = ksmbd_lookup_fd_fast(work, id);
+		if (!fp) {
+			ret = -EBADF;
+			rsp->hdr.Status = STATUS_FILE_CLOSED;
+			goto out2;
+		}
+		ksmbd_fd_put(work, fp);
 
 		nbytes = sizeof(struct file_object_buf_type1_ioctl_rsp);
 		obj_buf = (struct file_object_buf_type1_ioctl_rsp *)
-- 
2.25.1

