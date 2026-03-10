Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BC42ED141
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 13:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773148231; cv=none; b=Xz6kYHNJjrSBlc4GsQpSWZ3A1wgvmJHzMROScNtm3+9eTBBYp310k7UFvjTWGyQotORVcOp6hm6IV5TZIWA1zdVEm5TY1YIMRbr/JPbaXxqTslykhMA7Rnm//WJUB6aYjDtci8nC5AonBcbC16tXM+kIICNgnTKkHsaPbJGmZUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773148231; c=relaxed/simple;
	bh=nq99Hm8RGFODKlJRyRIWUDAmpT8jCDWvM/qgmLJrpe4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fU9rU6Vw/93E90ikj3H3jjSDBxMx1GX9LDdTDuz3QE91K9u7Z0+7iCRxWZws0opKcX7+2yB4z/ry9OnULBoj4MR6+QDioI2Quay6/uB9X3NDHMCY6p6MhRJq0w+rJn1t8vxVbemiQjxM6Hin4t7iVpXZgDK4/H5H3gG3rYlMqgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fVZ3V1SR2zYQv7b
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 21:09:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F2B2A4056D
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 21:10:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_UhDGLBp8eGfAQ--.52452S4;
	Tue, 10 Mar 2026 21:10:27 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	linux-cifs@vger.kernel.org,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: samba-technical@lists.samba.org
Subject: [PATCH] smb/client: only export symbol for 'smb2maperror-test' module
Date: Tue, 10 Mar 2026 21:08:47 +0800
Message-Id: <20260310130847.3157345-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_UhDGLBp8eGfAQ--.52452S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4DuF1kJrW7WF48Jw13Jwb_yoW8AryDpF
	y7t39FkF45ArWDu3y8Jay8XasIkrWUJ3W5t3WDWw1fJryDt34ayF18tasa9r1kuw4kWa48
	CFyj93WayayxtFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbiF4tUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Only export smb2_get_err_map_test smb2_error_map_table_test and
smb2_error_map_num symbol for 'smb2maperror-test' module.

Fixes: 7d0bf050a587 ("smb/client: make SMB2 maperror KUnit tests a separate module")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index f4cff44e2796..2b8782c4f684 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -109,6 +109,9 @@ int __init smb2_init_maperror(void)
 }
 
 #if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
+#define EXPORT_SYMBOL_FOR_SMB_TEST(sym) \
+	EXPORT_SYMBOL_FOR_MODULES(sym, "smb2maperror_test")
+
 /* Previous prototype for eliminating the build warning. */
 const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status);
 
@@ -116,11 +119,11 @@ const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status)
 {
 	return smb2_get_err_map(smb2_status);
 }
-EXPORT_SYMBOL_GPL(smb2_get_err_map_test);
+EXPORT_SYMBOL_FOR_SMB_TEST(smb2_get_err_map_test);
 
 const struct status_to_posix_error *smb2_error_map_table_test = smb2_error_map_table;
-EXPORT_SYMBOL_GPL(smb2_error_map_table_test);
+EXPORT_SYMBOL_FOR_SMB_TEST(smb2_error_map_table_test);
 
 unsigned int smb2_error_map_num = ARRAY_SIZE(smb2_error_map_table);
-EXPORT_SYMBOL_GPL(smb2_error_map_num);
+EXPORT_SYMBOL_FOR_SMB_TEST(smb2_error_map_num);
 #endif
-- 
2.34.1

