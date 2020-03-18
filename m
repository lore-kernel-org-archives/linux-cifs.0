Return-Path: <SRS0=eY7I=5D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6947AC10DCE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 12:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33BC520753
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 12:47:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUaIkLST"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCRMrJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Mar 2020 08:47:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40774 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgCRMrJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Mar 2020 08:47:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id l184so13836586pfl.7
        for <linux-cifs@vger.kernel.org>; Wed, 18 Mar 2020 05:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Bdlmx0BlIeSJWrC9gTAGaYCGq/dzC4e4bikL8bUxYFQ=;
        b=aUaIkLSTHy4hLHGiCnXaPO+SM3si8CmW2mTTHHw4E0KMiJbruOH65x61aeU09tKFGr
         46e5E8QVX9ghr+wmkWWuaOVIJuDdvWZrrJ055PeTlrbWEz1bYQ+VRQ+vRwaCKxsV6exR
         KugPk99XPVkTwj21Onp1hi2duWRyby03yyqqigCdggGCOQP7cOiE0iFcgJPvLmsuHB9L
         5zMswQTtu1eLvFrubLSa3/FWN8VJh/GjfmphWnuCKXM67h1JKFKQG0tdRBjxnDpiPujZ
         kFv+zENKY+AHl5E2ctaOahBdLB6yxGDYKtlMliEuiKu9cW9sPxo/xiSOPxTwx6yqb1wY
         eaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Bdlmx0BlIeSJWrC9gTAGaYCGq/dzC4e4bikL8bUxYFQ=;
        b=Zk6+rb5hQu/kfLCGsv19VYvueiNFVeIMeG8In0XYiOT9JuHQUMvpDpopctzdEG5N14
         4ezn7rrEkYq2r90slyRAj/b5Cqq/UvE+T8OrKSwPA7CIWtn7plMzgVnfcaaGBLokYk91
         v1SOHt+RUhUQw6StEtD1uvUhVelkuNYWRrheNOBlpgVOX9xAY9IGF9cWUhocpxn01IW9
         qajQjqOUboJpCxWqCwhbJCBNc/Xf5rREZodTtsdhqwOu/pGTqxf63vmdzaRJ5UMKaFbX
         cuqVI6OAmxx2YVL+ePdHnUa+GialE1Sg6onOUnUNTvUi9mueQp96i2FAL0dhHbi4KLnF
         87jw==
X-Gm-Message-State: ANhLgQ2q/1+PXhjRZgXV64YzpExp+rmNZZhQieNKkvZC26R4M0Vr4otv
        OgyvH/a51qIJqOSPg1Dx3cYOfsqD
X-Google-Smtp-Source: ADFU+vvNtQhzG0yDtdG7QyV3/Zv2Bl7TvRBjvZp2UvtsSgYUeqdOko6TX6dtpeC7Yo/ZGDz+e0vZpw==
X-Received: by 2002:a63:1404:: with SMTP id u4mr4426037pgl.172.1584535626969;
        Wed, 18 Mar 2020 05:47:06 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s125sm5962624pgc.53.2020.03.18.05.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 05:47:06 -0700 (PDT)
Date:   Wed, 18 Mar 2020 20:46:59 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Subject: [PATCH v3] CIFS: check new file size when extending file by fallocate
Message-ID: <20200318124659.cbxngqb4kbt2vhza@xzhoux.usersys.redhat.com>
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

Acked-by: ronnie sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---

v2:
  Use (off+len) instead of eof for correct argument type.
v3:
  Fix Ronnie's email address.

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

