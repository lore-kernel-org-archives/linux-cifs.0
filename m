Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9132A1BF
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 13:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775653835; cv=none; b=sOc48q8tF/KkmkPYsBD0caUwxEzrp1dbEuBKZYjBp2gYw5Pm5f3W99OvMYr4dBRne5iFFaMQr5UgD3WPK6QMFs3EpjdzPZKmaJEwWEISg/znL8qXP6sIsZi6ksyuh2DxFu3hCoIV+Vvhh+i3IvPAUEvEh3xdQSSumwCfSav6UqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775653835; c=relaxed/simple;
	bh=J/u4g3US7T31VtVOkec3rnZhNI6AXR/ktJocnQ3zshI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oCFu0Qo6NiL/4pP5zItDyAOy+ZtX4icAw9tyHdj0/Gbb+pRZ9kc4lLo9yawOqe1urpbv1JDBJT/nTVODSJYpbqxfdrR2MMV8xbOcvfwjpoVtKo3olmGDgA8wSllxWqTthP1HsXoWYfH9O3MhgVQSR75re5iKOHEMEVwP7KD137g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=rYv/a0t4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="rYv/a0t4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=XOFVPi4XQLpwFUagU/OyXj6eyQcoJqVp68qaIRQOY/c=; b=rYv/a0t4t6nDcariS5mvchWjkn
	E6/4h47Dmdtk//fi6CPCl1Ba+Nj2AKvbk1mFfVjO6GFobv/c832FibxgnOCxkx60azRbwiyRjJREl
	9cuGR/0bIrdeWECscoGSJ/IYuIPj926pqOeXz6eI5XL7DZTQm3KJ92eMI8ztAfKJyEEaiYd9gZhVX
	poAfElcu7IOz2Hmc9JiUUMJvrujgfseFO45MWw02zL9JCAWU7mok9uZtKK9aEbO9re4iSa3AQlRty
	wPgzpdoVic1QbZNbBrJjYYGl+3m8A24ry4H0qHHpDhlnINTPmTzwUwNJLnvr9AeITZCeuiWGFK/8f
	qqelDXXLAtKjIQVz4Lsg9psD3b/vMXwpCz+VHoXwfFONGEZj6Co7YGPVhD7lXYox/SXUWtgKKV5AI
	F/b5ykrKrv0PISUUidXmV33scP56T8Bn4HvhwblIoqO27DxdMIUhrTt/bkf75ExP3mSOb95m+48VX
	D2l7zAf3pIrPQDA6bBQ9HFK0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wASfr-00000007rX7-2s7r;
	Wed, 08 Apr 2026 13:10:27 +0000
Message-ID: <72ccf23d-f3e1-4e33-9eb0-4b4c9cd6d504@samba.org>
Date: Wed, 8 Apr 2026 15:10:27 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] SMB Direct: double-free of send_io on ib_post_send
 failure in batch flush path
To: Ruikai Peng <ruikai@pwno.io>, linkinjeon@kernel.org, sfrench@samba.org,
 senozhatsky@chromium.org, tom@talpey.com
Cc: security@kernel.org, pc@manguebit.org, linux-cifs@vger.kernel.org
References: <CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ruikai,

can you please check if the changes below fix the problem?
If so I'll prepare real commits.

Thanks!
metze

  fs/smb/client/smbdirect.c      | 8 ++++++++
  fs/smb/server/transport_rdma.c | 8 +++++++-
  2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c79304012b08..461658105013 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1551,17 +1551,25 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,

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
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 188572491d53..dbc8dedb85dc 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1588,15 +1588,21 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
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

