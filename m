Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF91824A062
	for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 13:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741787499; cv=none; b=kkZLenIXwr127SR/1yEa4aW9WrR2NiMwXLYeYO+G/+tO+q5cM5KKeSIn/NJNNXJirVFHN95uIXyl0ddqTwPAqFXjmpndenBVTbru2ZTNhIxej85x0HiPJWR8fdzqtQ4ciQJ+hSdC6M9DhRt186cL0VIs7Kwivwy+QpqxksQjTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741787499; c=relaxed/simple;
	bh=Q45a7BaCH9/8YD4mmCkp3cVXg8obZ7dhivw2nLn+dPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RmKMj9IuKHX8eyL+FjfSsJtTKLX3y8yokJ/IBvibWyBPqgfqg4yXXto4z5sTbF6MddYE3LBGiqEi6O7LBbrWSPRfEIwzqUXiWfaFP7grRdt41D/5zD0raUwxuo9pzfTSiR7e5D/i8ZaYami0TLXJW9tmt0KDpP091VqZxsmgnLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=hDepM/42; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="hDepM/42"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1741787495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sQeLNiHbjUzCdJKY/9uIpq0tj5e2EwjbCQGsOLKY8cM=;
	b=hDepM/42fDmM1YT0UEvwAF959CF9VtwEQLNHkzqoJlqqNuuHsDBX3hBvv8cw+aB8dkuz9z
	PjtKjw2wd8i63hMIGRqKdGDplcqz3JW2wySZg8nQSAJTBmbnJBONXlX+vnS91W3O23JmYY
	Bz32+subJAKX6D9jheuBq8hjKmS2qaQJ0R8MCA3iaa1VowXjATKD2xlJsrSWwTcALntdJc
	GOUN/N9m/8w5S1U9nMLB46+3EVSmNUeFOrf8370wzaOMJQgf9fNXJLn5bctJa8xSOCGCAf
	SRaJqWtWej4TNptDccoFNWTaGUedNv4mk99bBgpvhT2HqOK0kunKEEYmmSYLsA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Adam Williamson <awilliam@redhat.com>
Subject: [PATCH] smb: client: fix regression with guest option
Date: Wed, 12 Mar 2025 10:51:31 -0300
Message-ID: <20250312135131.628756-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting a CIFS share with 'guest' mount option, mount.cifs(8)
will set empty password= and password2= options.  Currently we only
handle empty strings from user= and password= options, so the mount
will fail with

	cifs: Bad value for 'password2'

Fix this by handling empty string from password2= option as well.

Link: https://bbs.archlinux.org/viewtopic.php?id=303927
Reported-by: Adam Williamson <awilliam@redhat.com>
Closes: https://lore.kernel.org/r/83c00b5fea81c07f6897a5dd3ef50fd3b290f56c.camel@redhat.com
Fixes: 35f834265e0d ("smb3: fix broken reconnect when password changing on the server by allowing password rotation")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index da5973c228ed..8c73d4d60d1a 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -171,6 +171,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_string("username", Opt_user),
 	fsparam_string("pass", Opt_pass),
 	fsparam_string("password", Opt_pass),
+	fsparam_string("pass2", Opt_pass2),
 	fsparam_string("password2", Opt_pass2),
 	fsparam_string("ip", Opt_ip),
 	fsparam_string("addr", Opt_ip),
@@ -1131,6 +1132,9 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		} else if (!strcmp("user", param->key) || !strcmp("username", param->key)) {
 			skip_parsing = true;
 			opt = Opt_user;
+		} else if (!strcmp("pass2", param->key) || !strcmp("password2", param->key)) {
+			skip_parsing = true;
+			opt = Opt_pass2;
 		}
 	}
 
-- 
2.48.1

