Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993B53358B0;
	Mon, 20 Apr 2026 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701018; cv=none; b=E+69GjeHFeF9Om/H5sEAtzR+4iGtt1TwiJ7pQMQu7Ka63VakEMcKz1BVEuolHYRMOeGKomCy3law4WWVrgC8CnGxpyZaMOg8iztV2eYTC61TH2SrSkSWU3Uf7KfBFMh7X+dS6zQm8ff4xsnI2tzbdyCKxx+HrWFsTEDLlzZL4bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701018; c=relaxed/simple;
	bh=uLy56vTql2Oo0PluU5NDeJpszMaWMYtfwNohMUBM8H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teF3Ka2OCnsYD8EbnsKib0GiNTRq6jV7LDLUa0RSY+7pgypah8IqGEOfyLKPqYwBwzCa/sOUuj2rPlEqphrghXpSyksBlU/pd1D5XBimGzofty5gVVuJ2+oaoRFYdTatirDTp4dQycPiar302c1uN4dHu0LQir7I6bUPr09YaLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rtd2XpRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rtd2XpRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063B3C19425;
	Mon, 20 Apr 2026 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701018;
	bh=uLy56vTql2Oo0PluU5NDeJpszMaWMYtfwNohMUBM8H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rtd2XpRXFj7r9/7XEVJfpycID0ULD4QMGhT4leiXGVI6ATn/Qed2/gpYvbNiZ8BYD
	 iQIfi0cgzPLqGnaTSGEvpfYcKO9DSlc1u+PaH+ZyJOa4Vc9/RRgTgKuN6nVAFAuxXs
	 9Jax7sCcyC7bHXD4e5+MzYiX2wlLJk4wjjazPZi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruikai Peng <ruikai@pwno.io>,
	stable@kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	security@kernel.org,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 142/198] smb: client: avoid double-free in smbd_free_send_io() after smbd_send_batch_flush()
Date: Mon, 20 Apr 2026 17:42:01 +0200
Message-ID: <20260420153940.722158137@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

commit 27b7c3e916218b5eb2ee350211140e961bfc49be upstream.

smbd_send_batch_flush() already calls smbd_free_send_io(),
so we should not call it again after smbd_post_send()
moved it to the batch list.

Reported-by: Ruikai Peng <ruikai@pwno.io>
Closes: https://lore.kernel.org/linux-cifs/CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com/
Fixes: 21538121efe6 ("smb: client: make use of smbdirect_socket.send_io.bcredits")
Cc: stable@kernel.org
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Ruikai Peng <ruikai@pwno.io>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: security@kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Tested-by: Ruikai Peng <ruikai@pwno.io>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1525,17 +1525,25 @@ static int smbd_post_send_iter(struct sm
 
 	rc = smbd_post_send(sc, batch, request);
 	if (!rc) {
+		/*
+		 * From here request is moved to batch
+		 * and we should not free it explicitly.
+		 */
+
 		if (batch != &_batch)
 			return 0;
 
 		rc = smbd_send_batch_flush(sc, batch, true);
 		if (!rc)
 			return 0;
+
+		goto err_flush;
 	}
 
 err_dma:
 	smbd_free_send_io(request);
 
+err_flush:
 err_alloc:
 	atomic_inc(&sc->send_io.credits.count);
 	wake_up(&sc->send_io.credits.wait_queue);


