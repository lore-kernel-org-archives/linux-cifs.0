Return-Path: <SRS0=OUN2=XO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD44C3A5A6
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Sep 2019 12:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3053A207FC
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Sep 2019 12:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="ILi49dpi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389225AbfISMVQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Sep 2019 08:21:16 -0400
Received: from mx.cjr.nz ([51.158.111.142]:37822 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387977AbfISMVQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 19 Sep 2019 08:21:16 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2019 08:21:14 EDT
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id E62CF810D5;
        Thu, 19 Sep 2019 12:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1568895156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xYHaguuqkZAjGKqBi/wff33jzCeg21O+5/4qDe2Bzsg=;
        b=ILi49dpi9tB8Ua1osuj+YxzBeu2EP20naHgIK+Yo+YJeNzJ1zEQDB7q5Hof7a4vTKxPGuF
        GzZnfoESt4P99CMXOkhAZ1vokSwQFNQyEJgwycprJrLC/WsrWL+q3oTNCFDKSu14dQefmO
        6W0YYOw65P9QU7sp2urwYWEDwQC0OeuTXIHud3UFO5Bd2ZdwXLiDe0G+XbZPumLao7krCb
        oMErQ23dkjNu8Wi4oL2pBq3oPtiO1BhitHY4MSyv5fRtvsFaFYAGuUjf/ngs4QbVXlg+ox
        6aB3I+Nez6D/0/sJFq3TmsDC+Kh4cvKbYDcxLapJPjNGf/7xzyMl/nE79qry4A==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH] mount.cifs: Fix invalid free
Date:   Thu, 19 Sep 2019 09:12:26 -0300
Message-Id: <20190919121226.8756-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz;
        s=dkim; t=1568895156; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=xYHaguuqkZAjGKqBi/wff33jzCeg21O+5/4qDe2Bzsg=;
        b=rLB2+4mKS1HTM+j5bsgs2n+8w8NOpFxJY7FgUIgJdARelR94krlFuANYEkUMysAiuATZAU
        q38LpY93MKBFcHgQqXamBXT435fkSI81SnClUippQxp/sy0AZs31E5Uwc1/CJnsyTKOhLI
        +pj/8DG+iwbaqJn2DMig5jTuWyZYu0cAHMTU5zJlwDSkEX/CyWN+9qGy7OosUYzCmxc5By
        cXgBBZBskqaJ+DdEtL7P2YhvJrJPAwxPVI6EeYWh6dHxbqNVu9XFvACuSorFEUKrHSNXA6
        RB1/2NdDw3l77xVMeSJUgnP+EW8j7CmzJyblvsOfAKuVEisaED319eSN5zMm/g==
ARC-Seal: i=1; s=dkim; d=cjr.nz; t=1568895156; a=rsa-sha256; cv=none;
        b=ruYd0dg3VWEmHBPwv6x+9AyZBvURT23m8AOeKOsdXHRHbCyozqyLY2jOsmo0poVWKZGPZC
        Ft0lQXRJY0dDLzL3YEAzoSiNHC9UYICG0rhhHiZbECDVwt76ZgT7i6g7seeblGh2puvhSz
        RrQi86wpDueCBvMZK9dp6LcL82fe5lowKB9V8f3z+adcKiQwQRMY2VKsO2+9MH8jXVrGqK
        zpHTFYxCkH4tI3mFUZ1g2zggwWJLm9T80QfQ3BbVXKqcBbv0hvZAR9x43OpBV373YDBfQA
        kSHN2UxIAajtlCS49HsfLBIwupFXQPqtG2SzSAkxn/Do3CWUbB63zdKtX5zUGw==
ARC-Authentication-Results: i=1;
        mx.cjr.nz;
        auth=pass smtp.auth=pc smtp.mailfrom=pc@cjr.nz
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When attemping to chdir into non-existing directories, mount.cifs
crashes.

This patch fixes the following ASAN report:

$ ./mount.cifs //localhost/foo /mnt/invalid-dir -o ...
/mnt/bar -o username=foo,password=foo,vers=1.0
Couldn't chdir to /mnt/bar: No such file or directory
=================================================================
==11846==ERROR: AddressSanitizer: attempting free on address which was
not malloc()-ed: 0x7ffd86332e97 in thread T0
    #0 0x7f0860ca01e7 in
    __interceptor_free (/usr/lib64/libasan.so.5+0x10a1e7)
    #1 0x557edece9ccb in
    acquire_mountpoint (/home/paulo/src/cifs-utils/mount.cifs+0xeccb)
    #2 0x557edecea63d in
    main (/home/paulo/src/cifs-utils/mount.cifs+0xf63d)
    #3 0x7f08609f0bca in __libc_start_main (/lib64/libc.so.6+0x26bca)
    #4 0x557edece27d9 in
    _start (/home/paulo/src/cifs-utils/mount.cifs+0x77d9)

Address 0x7ffd86332e97 is located in stack of thread T0 at offset 8951
in frame
    #0 0x557edece9ce0 in
    main (/home/paulo/src/cifs-utils/mount.cifs+0xece0)

  This frame has 2 object(s):
    [48, 52) 'rc' (line 1959)
    [64, 72) 'mountpoint' (line 1955) <== Memory access at offset 8951
    overflows this variable
HINT: this may be a false positive if your program uses some custom
stack unwind mechanism, swapcontext or vfork
      (longjmp and C++ exceptions *are* supported)
SUMMARY: AddressSanitizer: bad-free (/usr/lib64/libasan.so.5+0x10a1e7)
in __interceptor_free
==11846==ABORTING

Fixes: bf7f48f4c7dc ("mount.cifs.c: fix memory leaks in main func")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 mount.cifs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 7748d54aa814..0c38adcd99b1 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1893,7 +1893,7 @@ acquire_mountpoint(char **mountpointp)
 	int rc, dacrc;
 	uid_t realuid, oldfsuid;
 	gid_t oldfsgid;
-	char *mountpoint;
+	char *mountpoint = NULL;
 
 	/*
 	 * Acquire the necessary privileges to chdir to the mountpoint. If
@@ -1942,9 +1942,9 @@ restore_privs:
 		gid_t __attribute__((unused)) gignore = setfsgid(oldfsgid);
 	}
 
-	if (rc) {
-		free(*mountpointp);
-	}
+	if (rc)
+		free(mountpoint);
+
 	return rc;
 }
 
-- 
2.23.0

