Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F353128D5
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 01:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782263679; cv=none; b=A97KYQqm+WHrJ7kG4/s/3EHPAN5ZBenhl4lnMzrzFVsZ5W3LnzyHToaKNgTToX/9nJbu5teXN5yyzmlZ1ZEINrgOvPBlVPjvAFeJb0M5AFBvjNR7yW11vagIWyoDaGJDbGYRwUWx5iaRqGgR60jym9WgIqvbZw8s39kawyPN7LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782263679; c=relaxed/simple;
	bh=nNuzZlvE83yLcCdLNH/fbUQ3KAjWtFybRPbvHKUh+yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjD3jhvi/l38Hzpio2ed3Uf7mrw34cxWrP7788FDLdmXAWuhn8/P3qtDWQQvav2SNocqEjwiibsK485E2R2xPF37Boz1L/aJQB+N507KRjuhCa4O5AAXpNmWmy8eeh84Mj+aWknQ0IwbKOaW9DbqVU9f570/YHi2Lpnf8+hlkq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TNnNvVu6; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TNnNvVu6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=+k
	0IvcomjsHKbhWzKNG4+HgLiDaZgFBqG5Ua0wRt300=; b=TNnNvVu6tJsn2wEWVI
	A0nO4m65Xk9w//UXaCjl5DnCCH6jDYJPIOLrHY3yVz3iLz/RA+f5L6VHj1ZssxSk
	tV7p+tViI5hl9A93Iso6MHebuzX0I6nlGeI4qdMfWqqWFLm0G7R2rffVFadwf5ay
	S4eTRnFmkIPxqXJui6XQNhKxc=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCXb24yLztqsdWDFQ--.18691S3;
	Wed, 24 Jun 2026 09:13:27 +0800 (CST)
From: liuqiangneo@163.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 1/3] ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
Date: Wed, 24 Jun 2026 09:13:18 +0800
Message-ID: <20260624011320.9146-2-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624011320.9146-1-liuqiangneo@163.com>
References: <20260624011320.9146-1-liuqiangneo@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXb24yLztqsdWDFQ--.18691S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7GrWDXrWrAr1xur1UJrW5Jrb_yoWDGwc_Gr
	1DXw1kXry5XF4UWw4UXFW0qF1F9w1UKFyrW39xJFZxG3yjkwsxJanFqws3trZaqrW3tFnx
	G3y3Krsayr909jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8Wlk7UUUUU==
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC3xdCo2o7LzdoawAA3j

From: Qiang Liu <liuqiang@kylinos.cn>

ndr_encode_v4_ntacl() allocates sd_ndr.data via kzalloc() at entry.
If any subsequent ndr_write_*() call returns error during encoding,
the allocated sd_ndr.data won't be freed and causes memory leak.

Move kfree(sd_ndr.data) into out label to ensure the buffer gets
released on all success and error return paths.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 74b0307cb100..febe9f7b54c3 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1479,8 +1479,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	if (rc < 0)
 		pr_err("Failed to store XATTR ntacl :%d\n", rc);
 
-	kfree(sd_ndr.data);
 out:
+	kfree(sd_ndr.data);
 	kfree(acl_ndr.data);
 	kfree(smb_acl);
 	kfree(def_smb_acl);
-- 
2.43.0

