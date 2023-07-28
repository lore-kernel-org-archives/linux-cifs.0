Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F163C001DE
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbjG1Tu2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjG1TuZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:50:25 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC75D3C07
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:50:24 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Be1+OoJlk3lPtyFFMm5Xj1t5nyLX3z79qN7FXZ4QkOg=;
        b=C5zy2sckiDPPZdYTP6p9UbKfq4bihbWWA6DpfSw5YP3x90CTFK8tVzyICktx8P2rAb41g4
        w+6WfDegQWqYsY5ekucOh3blwgTSPDfiXUUEXHQ8dBesoIOglmawbpTz1KMgRexsDVSvM9
        JQgzBnDiQSkcqdZXeLyF3nA3lerp/zbE6YufT2rXbJVZtVcrGwNfNahw0PTn4E369ubXOj
        JHkUvgV8NPUN70b4wVKCM/q0hZxM46kNPjBBXbKFAUcW5xxLGkHlWGqtA4GnmZZM864aqs
        VBNKuFG+A6drUdZ3ONtyXV/Y1IUkfCsWNvZMkoraFhq2Zcstrc8DJo1no12JoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Be1+OoJlk3lPtyFFMm5Xj1t5nyLX3z79qN7FXZ4QkOg=;
        b=J2csI5n1jswaihnviiq8HS3jpBsV7yI5EPjd16hO629dVQB6KASHGnEhZXOAjtPeWmcz8B
        Ym2H2QfH3NJAhZPxOAwgac1ls+h9v5k+C01bWTcoHTAeu5SI78mK8vkztwV7qqmSKoTG4x
        ROxYJ5O7oUPltzx+4/NgRjHTto8FXWb4yhyCCnxWcsDQySeDGC3YkQhGCnOhPuOvRkDMO3
        4pIAqzt4hnmcC8SXYCk1EZruEW6zv0zMlkSF3J1YD6+3WXuMiXUjfXu5GPeLJbNys2C+I0
        6FnSxf6FOacC24HlTzCrxfMlRzsU811NbpGgjaFWg+E7FKHE1nKYUoDK82dGRg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1690573823; a=rsa-sha256;
        cv=none;
        b=lKjaw0boKyUNGK50z7UF9TPnnCA1S5N+YQREvur40RGwx3o3QoEhbVoofQq/G+RqD46R+W
        mw4uXH+pVS03ifbKkHDuNWyCmXciwFFvi/YoqsV68ZH8nkBMV4/hW+NN8lolWRmKNdpzuK
        579uDDuHAUcBQhgwQQWCU6S4Nv9Or/AIBSBEuj5MAvuT8v1aoj/K9bkmJKVzL5Ws+Y7LyA
        8NlerulQeAhXeeo6IKd1MXuKkyojC3VPehT7C8U0YBUljq3t1lWuKvdiQYQ0NJahmp/dzZ
        X/24MOXj3y4iNRDwo2jGXim6N+pNSP5EdG+k64m8/6JlUya0iGu3eqoHQny0fg==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 3/8] smb: client: reduce stack usage in cifs_get_inode_info()
Date:   Fri, 28 Jul 2023 16:50:05 -0300
Message-ID: <20230728195010.19122-3-pc@manguebit.com>
In-Reply-To: <20230728195010.19122-1-pc@manguebit.com>
References: <20230728195010.19122-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/inode.c:963:5: warning: stack frame size (1144)
  exceeds limit (1024) in 'cifs_get_inode_info' [-Wframe-larger-than]

It turns out that cifs_sfu_type() got inlined into
cifs_get_inode_info() which contains some stack-allocated variables
like @fid(96), @oparms(56), @io_parms(64), @buf(24).  Fix this by
marking cifs_sfu_type() as noinline_for_stack.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index c3eeae07e139..7f2a7b22427c 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -473,9 +473,10 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 }
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
-static int
-cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
-	      struct cifs_sb_info *cifs_sb, unsigned int xid)
+static noinline_for_stack int cifs_sfu_type(struct cifs_fattr *fattr,
+					    const char *path,
+					    struct cifs_sb_info *cifs_sb,
+					    unsigned int xid)
 {
 	int rc;
 	__u32 oplock;
-- 
2.41.0

