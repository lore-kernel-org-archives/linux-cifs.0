Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8556DC2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 19:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62EE361107
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 19:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhFVTCX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 15:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhFVTCW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 15:02:22 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BCDC061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 12:00:06 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x24so37611005lfr.10
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 12:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Y1SGpz7niQeuXIA1UfJ4nAxjxBzGboS4Z9yUl1iaXVE=;
        b=hs1+jspUFwBSZbmzwjYPlxO3/dyB6bA0gzzvHC5exBwvwgKjVjNkVznFhWpwvEuWqz
         MxBsI+bl7tEunjwr9Zl65ZM4ZIG4f7eofAgzuaP+b/m27CraIfa8YI0Kb8VPlWhImduA
         r2RyJUt8EYZ0KVS/6KV8CC5rjn0sZBIKEk2dKwu+/sESVARO00iX1jXzKIvDhaplwxfk
         ArrEi3H4mDi+7VDumhRTqnjTdNFTviGCdZXfoycktD2d0xQUT0Q5QOCpU/g3PLGy6bkD
         Y90yA1mRh75qcjmRKfPirDZAAlXPj6jrLC4FLZJaT8c6ZVCmyrLcu7s5jwAgnOd5NpTo
         PZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Y1SGpz7niQeuXIA1UfJ4nAxjxBzGboS4Z9yUl1iaXVE=;
        b=fchE9QlcoFpIjG4xh0HrCzE7WgfByTCLKroasEx9wrY4bM4HSllljiIuSWxqsiTRq+
         9bSqE94hMgixbPkv9nMWQSKJ+RnJt/6jomKrGAK3QwAAfdBFtp2LmZVmRA6K4LTZ3LYE
         BuaLfz0/OgZZTgPDNxm7BryMZZ/t2WK19AJ9CQ96LKYb+mvxVeLycfGFVgJ1AHkb/SEE
         Je+5saOoMIjbwAPU0+DlHECZQRqgwhepMua5vD4O+RPThvMcHn14k8QacFYQH1azJtI9
         B5lAu9El4+0+iAfDmn/dCAf/tO8ymFrPj6aalFB5GpLf1AQCbK5LqNrVaUlJa0sI5nYG
         Ohag==
X-Gm-Message-State: AOAM533au0lS/Pa7ABajbIEMKJunXzn/aLFGqCVU0Mp8XRgpHajW+Wbk
        peaOdRyuZQUZdYAomESno3479ZiBGj0LBr3v5yKIINk9azlvBg==
X-Google-Smtp-Source: ABdhPJyggIrON9JS6dCdKkp7fiLzYpLXDwB4DCZewYN5NHk3asFWPeFt5Sv67gtoF4+MhTq5KsOYmL1F1uTjWGmU1OA=
X-Received: by 2002:ac2:419a:: with SMTP id z26mr3977783lfh.307.1624388404772;
 Tue, 22 Jun 2021 12:00:04 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 13:59:53 -0500
Message-ID: <CAH2r5mtAf73mMnjYbs67K2KsnZpzQRjxD+VvYBiwS4PWO7W_Qw@mail.gmail.com>
Subject: [PATCH][CIFS] Add new info level for query directory
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SMB3: Add new info level for query directory

The recently updated MS-SMB2 (June 2021) added protocol definitions
for a new level 60 for query directory (FileIdExtdDirectoryInformation).

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/readdir.c |  2 +-
 fs/cifs/smb2pdu.h | 39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 00b6b953d13c..bfee176b901d 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -309,7 +309,7 @@ static void cifs_fulldir_info_to_fattr(struct
cifs_fattr *fattr,
 {
  __dir_info_to_fattr(fattr, info);

- /* See MS-FSCC 2.4.18 FileIdFullDirectoryInformation */
+ /* See MS-FSCC 2.4.19 FileIdFullDirectoryInformation */
  if (fattr->cf_cifsattrs & ATTR_REPARSE)
  fattr->cf_cifstag = le32_to_cpu(info->EaSize);
  cifs_fill_common_info(fattr, cifs_sb);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 653486243cdf..a5c48b85549a 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -264,7 +264,7 @@ struct share_redirect_error_context_rsp {
  __le32 NotificationType;
  __le32 ResourceNameOffset;
  __le32 ResourceNameLength;
- __le16 Flags;
+ __le16 Reserved;
  __le16 TargetType;
  __le32 IPAddrCount;
  struct move_dst_ipaddr IpAddrMoveList[];
@@ -1448,6 +1448,22 @@ struct smb2_echo_rsp {

 #define SMB2_QUERY_DIRECTORY_IOV_SIZE 2

+/*
+ * Valid FileInformation classes.
+ *
+ * Note that these are a subset of the (file) QUERY_INFO levels defined
+ * later in this file (but since QUERY_DIRECTORY uses equivalent numbers
+ * we do not redefine them here)
+ *
+ * FileDirectoryInfomation 0x01
+ * FileFullDirectoryInformation 0x02
+ * FileIdFullDirectoryInformation 0x26
+ * FileBothDirectoryInformation 0x03
+ * FileIdBothDirectoryInformation 0x25
+ * FileNamesInformation 0x0C
+ * FileIdExtdDirectoryInformation 0x3C
+ */
+
 struct smb2_query_directory_req {
  struct smb2_sync_hdr sync_hdr;
  __le16 StructureSize; /* Must be 33 */
@@ -1684,6 +1700,7 @@ struct smb3_fs_vol_info {
 #define FILEID_GLOBAL_TX_DIRECTORY_INFORMATION 50
 #define FILE_STANDARD_LINK_INFORMATION 54
 #define FILE_ID_INFORMATION 59
+#define FILE_ID_EXTD_DIRECTORY_INFORMATION 60

 struct smb2_file_internal_info {
  __le64 IndexNumber;
@@ -1764,13 +1781,31 @@ struct smb2_file_network_open_info {
  __le32 Reserved;
 } __packed; /* level 34 Query also similar returned in close rsp and
open rsp */

-/* See MS-FSCC 2.4.43 */
+/* See MS-FSCC 2.4.21 */
 struct smb2_file_id_information {
  __le64 VolumeSerialNumber;
  __u64  PersistentFileId; /* opaque endianness */
  __u64  VolatileFileId; /* opaque endianness */
 } __packed; /* level 59 */

+/* See MS-FSCC 2.4.18 */
+struct smb2_file_id_extd_directory_info {
+ __le32 NextEntryOffset;
+ __u32 FileIndex;
+ __le64 CreationTime;
+ __le64 LastAccessTime;
+ __le64 LastWriteTime;
+ __le64 ChangeTime;
+ __le64 EndOfFile;
+ __le64 AllocationSize;
+ __le32 FileAttributes;
+ __le32 FileNameLength;
+ __le32 EaSize; /* EA size */
+ __le32 ReparsePointTag; /* valid if FILE_ATTR_REPARSE_POINT set in
FileAttributes */
+ __le64 UniqueId; /* inode num - le since Samba puts ino in low 32 bit */
+ char FileName[1];
+} __packed; /* level 60 */
+
 extern char smb2_padding[7];

 /* equivalent of the contents of SMB3.1.1 POSIX open context response */

-- 
Thanks,

Steve
