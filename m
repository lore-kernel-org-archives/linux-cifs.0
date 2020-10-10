Return-Path: <SRS0=ZPc7=DR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6E8C43467
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Oct 2020 23:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEDFC2075E
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Oct 2020 23:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388235AbgJJW4r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:56:47 -0400
Received: from mleia.com ([178.79.152.223]:55600 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731229AbgJJTEg (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 10 Oct 2020 15:04:36 -0400
X-Greylist: delayed 1309 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2020 15:04:36 EDT
Received: from mail.mleia.com (localhost [127.0.0.1])
        by mail.mleia.com (Postfix) with ESMTP id B629E40FFF7;
        Sat, 10 Oct 2020 18:26:05 +0000 (UTC)
From:   Vladimir Zapolskiy <vz@mleia.com>
To:     Steve French <stfrench@microsoft.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org,
        Vladimir Zapolskiy <vladimir@tuxera.com>
Subject: [PATCH] cifs: Fix incomplete memory allocation on setxattr path
Date:   Sat, 10 Oct 2020 21:25:54 +0300
Message-Id: <20201010182554.337097-1-vz@mleia.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20201010_182605_767711_67D155C6 
X-CRM114-Status: GOOD (  16.92  )
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Vladimir Zapolskiy <vladimir@tuxera.com>

On setxattr() syscall path due to an apprent typo the size of a dynamically
allocated memory chunk for storing struct smb2_file_full_ea_info object is
computed incorrectly, to be more precise the first addend is the size of
a pointer instead of the wanted object size. Coincidentally it makes no
difference on 64-bit platforms, however on 32-bit targets the following
memcpy() writes 4 bytes of data outside of the dynamically allocated memory.

  =============================================================================
  BUG kmalloc-16 (Not tainted): Redzone overwritten
  -----------------------------------------------------------------------------
  
  Disabling lock debugging due to kernel taint
  INFO: 0x79e69a6f-0x9e5cdecf @offset=368. First byte 0x73 instead of 0xcc
  INFO: Slab 0xd36d2454 objects=85 used=51 fp=0xf7d0fc7a flags=0x35000201
  INFO: Object 0x6f171df3 @offset=352 fp=0x00000000
  
  Redzone 5d4ff02d: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
  Object 6f171df3: 00 00 00 00 00 05 06 00 73 6e 72 75 62 00 66 69  ........snrub.fi
  Redzone 79e69a6f: 73 68 32 0a                                      sh2.
  Padding 56254d82: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
  CPU: 0 PID: 8196 Comm: attr Tainted: G    B             5.9.0-rc8+ #3
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
  Call Trace:
   dump_stack+0x54/0x6e
   print_trailer+0x12c/0x134
   check_bytes_and_report.cold+0x3e/0x69
   check_object+0x18c/0x250
   free_debug_processing+0xfe/0x230
   __slab_free+0x1c0/0x300
   kfree+0x1d3/0x220
   smb2_set_ea+0x27d/0x540
   cifs_xattr_set+0x57f/0x620
   __vfs_setxattr+0x4e/0x60
   __vfs_setxattr_noperm+0x4e/0x100
   __vfs_setxattr_locked+0xae/0xd0
   vfs_setxattr+0x4e/0xe0
   setxattr+0x12c/0x1a0
   path_setxattr+0xa4/0xc0
   __ia32_sys_lsetxattr+0x1d/0x20
   __do_fast_syscall_32+0x40/0x70
   do_fast_syscall_32+0x29/0x60
   do_SYSENTER_32+0x15/0x20
   entry_SYSENTER_32+0x9f/0xf2

Fixes: 5517554e4313 ("cifs: Add support for writing attributes on SMB2+")
Signed-off-by: Vladimir Zapolskiy <vladimir@tuxera.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 24f107f763f0..76d82a60a550 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1216,7 +1216,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[1].rq_iov = si_iov;
 	rqst[1].rq_nvec = 1;
 
-	len = sizeof(ea) + ea_name_len + ea_value_len + 1;
+	len = sizeof(*ea) + ea_name_len + ea_value_len + 1;
 	ea = kzalloc(len, GFP_KERNEL);
 	if (ea == NULL) {
 		rc = -ENOMEM;
-- 
2.24.0

