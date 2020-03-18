Return-Path: <SRS0=eY7I=5D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA4FC1975A
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 01:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1B2120738
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 01:56:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O0QSlAKe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCRB4f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Mar 2020 21:56:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35834 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgCRB4f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Mar 2020 21:56:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id 7so12780191pgr.2
        for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2020 18:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=UuKTZphxyHELGJiAUZZZIv1h2clYb7eause3yawbkiA=;
        b=O0QSlAKeTn21lw3vHM4ehdkG00qNNYqCWIQGXwQHohp8Wqqax3PuQindEZw+EZKPgU
         EyWG80NZFmlc7p2Bw9lAl6dnwHQ6zPAYHPjTR/B2Wq6J6oNavwQyGBAtoosAHXyry5tU
         QQ1c1HnlZMYp/bczjI67rIutxMBgMhXw/GvgzLww57jeyc9kfnXaeOIVmsYHMITyh66C
         SmgCuIi/xyijA/0vc0HnCdvSsBsgtruJQ/Ljq/50/Zyoo8/PlAZ++5/nGwsrspDC9EdW
         x4etIPw0YmnaU8wP4fiZjwMSaJIyzsnQ2U4Ib0lerxny+tSo4CK0ulQep0Q9JGWe+ov7
         V/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=UuKTZphxyHELGJiAUZZZIv1h2clYb7eause3yawbkiA=;
        b=Zerd688a8571RurHVmkzbzyNAGoQMlu5iFpm+6bpPk6vhps+cp3ui/piC3mkorisIp
         aTFb+ZIbuG5jZ/01p9YISA5GeFRqKJriWMGMatmXci7KQf87D9zhAFEhCwDlYTD2bsuq
         hGCNUwqODuQrHj+G8zeF4cITSg9gKpP5od0AvTAiOKLTQIABCJed44YXgGpVfAJu3kmO
         4McaKgxC43OZ6kJYn//UdmmM4yCKlCatvDdDXUkvFf5ikKSOM6PHy4dU4lyaJWUaOM6q
         nDi7wF0GLVR3kRbmKNBkwqSwRqdNsP0Q88qrzwexfT6HV8t4azXZ42cgzV1Fuq3SDLjH
         B9xA==
X-Gm-Message-State: ANhLgQ3qq6B1lEddom/biIOAVaOPzS3LKHVSxMPEw4stQlJB1rOxSpl4
        lNUk4Jj1AL77WPqjTbnE93v/5ZDd
X-Google-Smtp-Source: ADFU+vs1x6Ta/mPcUqKnRg1tefurvCdq0H+c1YkEOfxKZml9euJiATflfjf4Vhlghzew4bVIPdeCVA==
X-Received: by 2002:a63:7b4e:: with SMTP id k14mr2085873pgn.434.1584496592194;
        Tue, 17 Mar 2020 18:56:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y7sm4413606pfq.159.2020.03.17.18.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 18:56:31 -0700 (PDT)
Date:   Wed, 18 Mar 2020 09:56:24 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Subject: [PATCH] CIFS: check new file size when extending file by fallocate
Message-ID: <20200318015624.spmlc7izbszkpdqf@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

xfstests generic/228 checks if fallocate respects RLIMIT_FSIZE.
After fallocate mode 0 extending enabled, cifs can hit this failure.
Fix this by checking the new file size with the vfs helper, which
checks with RLIMIT_FSIZE(ulimit -f) and s_maxbytes.

This patch has been tested by LTP/xfstests aginst samba and
Windows server. No new issue was found.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 fs/cifs/smb2ops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c31e84ee3c39..48bbbb68540d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3246,10 +3246,14 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	 * Extending the file
 	 */
 	if ((keep_size == false) && i_size_read(inode) < off + len) {
+		eof = cpu_to_le64(off + len);
+		rc = inode_newsize_ok(inode, eof);
+		if (rc)
+			goto out;
+
 		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
-		eof = cpu_to_le64(off + len);
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, &eof);
 		if (rc == 0) {
-- 
2.20.1
