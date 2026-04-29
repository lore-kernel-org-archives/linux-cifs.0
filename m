Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E743AA50A;
	Wed, 29 Apr 2026 09:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777453241; cv=pass; b=C7q0mfWpGbuuRvvhurnLrhMdExYei016mdDa+wyrbROLox8+kylHqmzikk2p7YHML3hOAKWGKRThoACrLUUmE2Jp+/s/3qZ0LNM6T3FAzUEJiFvhYMguIjsQat+tqV1PxUg2gb+W52VnNEQINxEFdPOkdGY3t3zwgD+I64B6MhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777453241; c=relaxed/simple;
	bh=rV8glw086WVi2K69FtjQnQtbin2wKiquM05qZaglO6k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tqnIEKh8u2z7DWAtDJND9I3vhyE1opCySeAoWMSaOw6CJyzT0iLsQrZUGxuiFe2Z+VQFPtgH4+DC5y8AgFuevQ2ewLnX4u2n6yDvdayXSTZlo7HrVOxKGS+StxLFwyi9YE2SFd/UPndE48VY8Nx1oG8uvjDScOSpcmOJCckr7SE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=3wpy67hA; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="3wpy67hA"
ARC-Seal: i=1; d=cse.ust.hk; s=arccse; a=rsa-sha256; cv=none; t=1777453208;
	b=AB715FkAn4q2NzYXlUpNYKnqxTX4jZ0eGw+9kp/NgDLqAL58fT0Uno8IL+rJAruHd/Yr
	 Dmu8ngDUi8mm8dQCA1PyaN6kdxCPG0jr4B3YlQzVt1x1pfUkZOBmpOJI6AC9jX44S37kK
	 +p0kkTFE2CM70S4fK0wagDjzW7ov5A5pCs=
ARC-Message-Signature: i=1; d=cse.ust.hk; s=arccse; a=rsa-sha256;
	c=relaxed/relaxed; t=1777453208;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version;
	bh=33PTQZPJbu6sjAhXoqNtjSbyDKywwjVQQR7Cb/Pb8Yc=;
	b=KsQfHfdGytO8i74eAr9WtYNJiWJ1DQnjsPVDg8ytPatg0AXWmMR+ugOozNZIQSjsuCO2
	 QTrXY5lIxM7no2RCLXZVegDahw32IkfYrh2mQGAO9hF8e3MojYxf686F48/u2TWqOARXo
	 DVIpdXDLlXgztGAZ+PCs3aidZvciInCgEY=
ARC-Authentication-Results: i=1; cse.ust.hk; arc=none smtp.remote-ip=143.89.191.45
Received: from chcpu16 (191host045.mobilenet.cse.ust.hk [143.89.191.45])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 63T901P93610265
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 17:00:07 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1777453208;
	bh=33PTQZPJbu6sjAhXoqNtjSbyDKywwjVQQR7Cb/Pb8Yc=;
	h=Date:From:To:Cc:Subject:From;
	b=3wpy67hAMIIJPS1E0OPIBPEO61XNSe9SAaehA2iPKZt6ihAi88LSuKbw2x1/8Qmsk
	 yhirey2caCmbWl04KdoyzFccvBNSRNVHbEZ7DRplgdalYc3A/DSfRW1lQuBQJOTyl0
	 tePR4OwgNTjAjpIu/g12shjJnB8/aF3XJl1mRNts=
Date: Wed, 29 Apr 2026 16:59:56 +0800
From: Shuhao Fu <sfual@cse.ust.hk>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: fail share config requests when path allocation fails
Message-ID: <20260429085956.GA3326432@chcpu16>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Env-From: sfual

Non-pipe shares must have a duplicated backing path before they can be
published. share_config_request() currently calls kstrndup() for that
path, but if the allocation fails it leaves ret unchanged. If veto list
parsing succeeds and share->name exists, the partially built share is
still inserted into the global share table with share->path left NULL.

A later share-root SMB2 create uses tree_conn->share_conf->path as the
lookup root. If the share was published with path == NULL, that request
passes a NULL pathname into do_getname_kernel()/strlen() and can crash
the ksmbd worker.

Set ret = -ENOMEM when path duplication fails so the incomplete share is
destroyed before publication.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
---
 fs/smb/server/mgmt/share_config.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index 53f44ff4d376f3e..6f97f8d39657cd2 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -167,7 +167,10 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 
 		share->path = kstrndup(ksmbd_share_config_path(resp), path_len,
 				      KSMBD_DEFAULT_GFP);
-		if (share->path) {
+		if (!share->path) {
+			ret = -ENOMEM;
+		} else {
+			ret = 0;
 			share->path_sz = strlen(share->path);
 			while (share->path_sz > 1 &&
 			       share->path[share->path_sz - 1] == '/')
@@ -179,9 +182,10 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 		share->force_directory_mode = resp->force_directory_mode;
 		share->force_uid = resp->force_uid;
 		share->force_gid = resp->force_gid;
-		ret = parse_veto_list(share,
-				      KSMBD_SHARE_CONFIG_VETO_LIST(resp),
-				      resp->veto_list_sz);
+		if (!ret)
+			ret = parse_veto_list(share,
+					      KSMBD_SHARE_CONFIG_VETO_LIST(resp),
+					      resp->veto_list_sz);
 		if (!ret && share->path) {
 			if (__ksmbd_override_fsids(work, share)) {
 				kill_share(share);
-- 
2.49.0
