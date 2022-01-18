Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76658C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 22:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344690AbiARWkR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jan 2022 17:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240802AbiARWkR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jan 2022 17:40:17 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05760C061574
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jan 2022 14:40:17 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id s30so1335661lfo.7
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jan 2022 14:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=yqjcDkDLFuxD/E3IY7kN5HbG7Me5rWq+SC0fQFHJSCU=;
        b=ikQYOBQho1WQEk+6MPYwSlxb/cMjeYv6C784FHZww1zgXtO2sscmmkXUMrlQKKCDrA
         VlO8zKIJS92c+S/4lwFC4YNPqXGVwTsENkgWPuBXP1HPi3+8hu7rHcShgPawkUxf0on2
         1Yjn8swD/EvXh6d1unoKf3Wd6g+hYMpXWNl7JddD+L37wViRXBhATWI3joxEFYYDd0QE
         BsBWosUmuX58e2rU6/F6ZaMVqo719kd8I1TfYIPnGof2QnKi82URtJ5FqETG/7Z3GA9/
         BYEnVq6/Z5JN1Szq54siNIb6v62vS1/3uqtjW950JRG1WpMZStYZPCRDzz8qSqHi6z3y
         baUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=yqjcDkDLFuxD/E3IY7kN5HbG7Me5rWq+SC0fQFHJSCU=;
        b=fqSt3NWyDjVUVr8uEIo4OuWkwTef3ULnsf0gJc18y+gW77Zc905bK2K0N8UDjF/9bF
         g0Xym8QCw+kXlOOgBs+5n0RmhnjBz5UcPG+Z35a58waZe+WsPszsNI8uPYS74BHVjfwy
         mH0HMTCzsskFrqLM3+Uz3alSu1joWheA49nAbCuEe39dVJAhK4M9E7Istlwyw54uEuRV
         F2BQ4e94KjCtyeY3vFjOn+FBDsqcZ7D+DMBl/B6UgLyUlU9qe1kt/Dl1bOHYUxnvz/Pl
         CK5F2+GKbi+0xSyIgzM6uitGVrL1gw9D6xCy90sBt9ZPWIAIPZXZ8tW3a56ZFHEUd3qU
         +b0w==
X-Gm-Message-State: AOAM53339QzriZkJJg8DjE3BLW+NU1W5wPzq9NLWqqPLrNFJMCAUfKGO
        5NPvuiEf4fCOJj4tlXef5j+os66rrNnFF8rRZ0W2Ushno0w=
X-Google-Smtp-Source: ABdhPJx7wt+iJsuUhXfvPvn17JqE5Ol++PQR8kFg7Zxhiu6ZUoVqek9wvXcqtMsQD37C7XRI5UujJa0wIPHbVQw5S/I=
X-Received: by 2002:a05:651c:1503:: with SMTP id e3mr19651971ljf.460.1642545615084;
 Tue, 18 Jan 2022 14:40:15 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 18 Jan 2022 16:40:04 -0600
Message-ID: <CAH2r5msv5w5oWVomujjwoC=PiNBu3b7kbQO6uJXVKbAwxGKuJw@mail.gmail.com>
Subject: [PATCH][SMB3] add new defines from protocol specification
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Trivial update to list of valid smb3 fsctls

In the October updates to MS-SMB2 two additional FSCTLs
were described.  Add the missing defines for these,
as well as fix a typo in an earlier define.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smbfs_common/smb2pdu.h  | 2 +-
 fs/smbfs_common/smbfsctl.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
index 7ccadcbe684b..38b8fc514860 100644
--- a/fs/smbfs_common/smb2pdu.h
+++ b/fs/smbfs_common/smb2pdu.h
@@ -449,7 +449,7 @@ struct smb2_netname_neg_context {
  */

 /* Flags */
-#define SMB2_ACCEPT_TRANSFORM_LEVEL_SECURITY 0x00000001
+#define SMB2_ACCEPT_TRANSPORT_LEVEL_SECURITY 0x00000001

 struct smb2_transport_capabilities_context {
  __le16 ContextType; /* 6 */
diff --git a/fs/smbfs_common/smbfsctl.h b/fs/smbfs_common/smbfsctl.h
index 926f87cd6af0..d51939c43ad7 100644
--- a/fs/smbfs_common/smbfsctl.h
+++ b/fs/smbfs_common/smbfsctl.h
@@ -95,8 +95,10 @@
 #define FSCTL_SET_SHORT_NAME_BEHAVIOR 0x000901B4 /* BB add struct */
 #define FSCTL_GET_INTEGRITY_INFORMATION 0x0009027C
 #define FSCTL_GET_REFS_VOLUME_DATA   0x000902D8 /* See MS-FSCC 2.3.24 */
+#define FSCTL_SET_INTEGRITY_INFORMATION_EXT 0x00090380
 #define FSCTL_GET_RETRIEVAL_POINTERS_AND_REFCOUNT 0x000903d3
 #define FSCTL_GET_RETRIEVAL_POINTER_COUNT 0x0009042b
+#define FSCTL_REFS_STREAM_SNAPSHOT_MANAGEMENT 0x00090440
 #define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF
 #define FSCTL_SET_DEFECT_MANAGEMENT  0x00098134 /* BB add struct */
 #define FSCTL_FILE_LEVEL_TRIM        0x00098208 /* BB add struct */
-- 

-- 
Thanks,

Steve
