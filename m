Return-Path: <SRS0=eY7I=5D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD15C10DCE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 12:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63B7F2076D
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 12:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dV/k+m3Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgCRMns (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Mar 2020 08:43:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39287 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCRMnr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Mar 2020 08:43:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id d25so5829321pfn.6
        for <linux-cifs@vger.kernel.org>; Wed, 18 Mar 2020 05:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ZMEsmFlOAhMVNcWJSQKpoyZGH8jqSuY6lY2pfF9vav4=;
        b=dV/k+m3Qmbg+A/48O5xlkvRFd2ienTH+9+6mWb7mliYVrvbqODjmYfo4ECKT6KRQSr
         hoDvm9+PBR0P4zI4pG1S1PnmYKEdv9JoQ1JecgBddPQg+OzAHBdwpNFIN6LZhd5sREtP
         A9FGytHxvwZA3t84uXdZPYYBszCtGlmfkhmRCGwpNwfxnZWTt5xQA4bCf2bmHMgEpq40
         Np82kVZf4uyJpMbRUc/B4xyIRztLpkEjoW3U4EjqwAPPAjLinABIB26hrvBHshBaVNE4
         MivR76zH0cHeePviao/RJfH8Z3I7aIykpr7Hg2d26qogJ0RkiFUTVIzb4ajCK3KpR+Me
         bqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ZMEsmFlOAhMVNcWJSQKpoyZGH8jqSuY6lY2pfF9vav4=;
        b=MnghzQXZHWFtoRYr+vu56lSwrKNIXGZlDQLd0oypV6w6cfvpLWjKQ05hOf2nPk0CPu
         rO+mf3TRyHGU508ekIGXQ2gKoxslDW5OQyjXmxsH2BrIZwbY/oElHXhkCyhbIy8254OR
         TUw4mulXVKnnreeJ6RCsYsNbs3wG7w6hR6thKrQ3yHKRuSemMFpjGyKCY0qg9M3gEZN8
         y4hmEzBDPjSxj8lGNPEdLsfERuzzpXq5bD0eKeF8L+hTktQTgekivn2dfE+Aj6NPBBwR
         IyY88olZNXsXQUrZbsYL8PxLFYPXZmz6gj4xxPiOame6AswDC7dFyNTtdR8+k8qpsJLo
         VfTw==
X-Gm-Message-State: ANhLgQ1opJQtKa11wqpc2RSv9+W+yObAICG0mOsYhek8Go7ceGYynx+g
        XtZQzQIV7b/1RaT6Vjd1DoszJPDm
X-Google-Smtp-Source: ADFU+vu4pSx7GgNc6NPNKrFP3c4p5M+PQ+w0xmGAvu94VybAgpH9439OPyuKAwbUVxFHAik8SUGLWA==
X-Received: by 2002:a63:c050:: with SMTP id z16mr4294856pgi.177.1584535426687;
        Wed, 18 Mar 2020 05:43:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mg16sm2488039pjb.12.2020.03.18.05.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 05:43:46 -0700 (PDT)
Date:   Wed, 18 Mar 2020 20:43:38 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Subject: [PATCH v2] CIFS: check new file size when extending file by fallocate
Message-ID: <20200318124338.tcfccbpvn3a3z2sn@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

xfstests generic/228 checks if fallocate respect RLIMIT_FSIZE.
After fallocate mode 0 extending enabled, we can hit this failure.
Fix this by check the new file size with vfs helper, return
error if file size is larger then RLIMIT_FSIZE(ulimit -f).

This patch has been tested by LTP/xfstests aginst samba and
Windows server.

Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---

v2:
  Use (off+len) instead of eof for correct argument type

 fs/cifs/smb2ops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c31e84ee3c39..f221a01f62bd 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3246,6 +3246,10 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	 * Extending the file
 	 */
 	if ((keep_size == false) && i_size_read(inode) < off + len) {
+		rc = inode_newsize_ok(inode, off + len);
+		if (rc)
+			goto out;
+
 		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
-- 
2.20.1

