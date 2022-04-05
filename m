Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C9CC4167B
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Apr 2022 23:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiDEXUD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Apr 2022 19:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448489AbiDEPsU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Apr 2022 11:48:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 174CA1A8C0A
        for <linux-cifs@vger.kernel.org>; Tue,  5 Apr 2022 07:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649168893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2HftyXrFUGXnaP4rfcZb6D7hK+A7IkfBIMeUs8IzsCc=;
        b=EfmgJOqrTPXw3YBmhgliZl2Ysi8EciRmyxFYT5HbutHRzU0ESq0igKPfHlVEHqCXtHMBit
        qJi1TxhEPTmhcdFRmymWoF3cPztStCkyhOBNpYUIgazDdru/+dNLKEELV49bRUbtLymZjx
        cAcaVR9vtLT+iKI8A2aTXJvEVOb+fpc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-UpPub7RhNRWdgV9xlcureQ-1; Tue, 05 Apr 2022 10:28:12 -0400
X-MC-Unique: UpPub7RhNRWdgV9xlcureQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD0921010360;
        Tue,  5 Apr 2022 14:28:11 +0000 (UTC)
Received: from dwysocha.rdu.csb (unknown [10.22.11.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D6B9141512B;
        Tue,  5 Apr 2022 14:28:11 +0000 (UTC)
From:   Dave Wysochanski <dwysocha@redhat.com>
To:     dhowells@redhat.com
Cc:     linux-cachefs@redhat.com, jlayton@kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org
Subject: [PATCH v2] cachefiles: Fix KASAN slab-out-of-bounds in cachefiles_set_volume_xattr
Date:   Tue,  5 Apr 2022 10:28:10 -0400
Message-Id: <20220405142810.8208-1-dwysocha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use the actual length of volume coherency data when setting the
xattr to avoid the following KASAN report.

 BUG: KASAN: slab-out-of-bounds in cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
 Write of size 4 at addr ffff888101e02af4 by task kworker/6:0/1347

 CPU: 6 PID: 1347 Comm: kworker/6:0 Kdump: loaded Not tainted 5.18.0-rc1-nfs-fscache-netfs+ #13
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-4.fc34 04/01/2014
 Workqueue: events fscache_create_volume_work [fscache]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x45/0x5a
  print_report.cold+0x5e/0x5db
  ? __lock_text_start+0x8/0x8
  ? cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
  kasan_report+0xab/0x120
  ? cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
  kasan_check_range+0xf5/0x1d0
  memcpy+0x39/0x60
  cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
  cachefiles_acquire_volume+0x2be/0x500 [cachefiles]
  ? __cachefiles_free_volume+0x90/0x90 [cachefiles]
  fscache_create_volume_work+0x68/0x160 [fscache]
  process_one_work+0x3b7/0x6a0
  worker_thread+0x2c4/0x650
  ? process_one_work+0x6a0/0x6a0
  kthread+0x16c/0x1a0
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>

 Allocated by task 1347:
  kasan_save_stack+0x1e/0x40
  __kasan_kmalloc+0x81/0xa0
  cachefiles_set_volume_xattr+0x76/0x350 [cachefiles]
  cachefiles_acquire_volume+0x2be/0x500 [cachefiles]
  fscache_create_volume_work+0x68/0x160 [fscache]
  process_one_work+0x3b7/0x6a0
  worker_thread+0x2c4/0x650
  kthread+0x16c/0x1a0
  ret_from_fork+0x22/0x30

 The buggy address belongs to the object at ffff888101e02af0
 which belongs to the cache kmalloc-8 of size 8
 The buggy address is located 4 bytes inside of
 8-byte region [ffff888101e02af0, ffff888101e02af8)

 The buggy address belongs to the physical page:
 page:00000000a2292d70 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x101e02
 flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
 raw: 0017ffffc0000200 0000000000000000 dead000000000001 ffff888100042280
 raw: 0000000000000000 0000000080660066 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
 ffff888101e02980: fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc
 ffff888101e02a00: 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc 00
 >ffff888101e02a80: fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc 04 fc
                                                            ^
 ffff888101e02b00: fc fc fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc
 ffff888101e02b80: fc fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc
 ==================================================================

Fixes: 413a4a6b0b55 "cachefiles: Fix volume coherency attribute"
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
---
 fs/cachefiles/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 35465109d9c4..f13b642c1d14 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -198,8 +198,7 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
 
 	_enter("%x,#%d", volume->vcookie->debug_id, len);
 
-	len += sizeof(*buf);
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(sizeof(*buf) + len, GFP_KERNEL);
 	if (!buf)
 		return false;
 	buf->reserved = cpu_to_be32(0);
-- 
2.27.1

