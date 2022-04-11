Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB250C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Apr 2022 07:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238602AbiDKHmQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Apr 2022 03:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245524AbiDKHmO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Apr 2022 03:42:14 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A72DBED
        for <linux-cifs@vger.kernel.org>; Mon, 11 Apr 2022 00:39:57 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m67-20020a1ca346000000b0038e6a1b218aso9445559wme.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 Apr 2022 00:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=1cL0HAUCWjIS6gJ0bYBvFxQVKR0gB/++AOyMDW+fHck=;
        b=GQckq2DA72L1W3jLAjh7SEVY0QCvdMaW+EbenvQ5WTLLYMFNdOVy/AsyRhNlKNl0r1
         yo534S3BA/id1bR4N0/hZJ6bN/Dq3aooI10dMNvyJYbBJXTYiughtgrbK9l+7k/gUcOW
         kEJfQhcXjZIh47LhdJQM/KgqtN/gSZF1ZaEsLg/zU91vNyzdG/hDbktrAcwaDjta4Ubg
         GCagAH551sF011fsanFp1OlBjtofpoBfSWThA0vIbBs7IWR/yK66f7pqWlDtGQGxIIVo
         Ng26IXJr2xU/BauXwf1CDFEAevuCD3s4EvWgalIFqLhY+mLnqpDOSVcwRmlUkFRZFMw/
         CXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=1cL0HAUCWjIS6gJ0bYBvFxQVKR0gB/++AOyMDW+fHck=;
        b=adE8tvpjpNyFJx0FYTduztGWUMZjU0GWOysvFMrB/2+hloH+Dqpy0VlWKPFBviiOlI
         MGLogJ5ia7fJjRNPaWFQCKfKTK6b6TLs+5hcXkeJh0HNM1xgjO/fEq5fDBRRujDhnunM
         RlNyWIas1ir4DhINXq3vtqJ3Z8m1anYa7/GF5UXj2egeDHmaBL5n73N9K84C7H5v4zg8
         oy9QB5FWbV8CF/8k36twV8xZeK7YNjkeG9sYvI/2z6V+VULll+FwXlOlAuwy5rW8LmmS
         Q4GVxCMV82gyyYX0KjL0VduDkPv/TkoTLzBBlysFVrs5Vgj6SQVhCohi4Mhf1NupDG79
         b3kA==
X-Gm-Message-State: AOAM532tpG1Y0ieqZuMVY0PsMrXV82OKLRmKYiTs77OOtLYWw7WkTHg5
        Bd1KsthFzzMWXLLoYc78yDL3btoZSebj9Q==
X-Google-Smtp-Source: ABdhPJx8/HJ6gm7QyqqDcNouQ3X7yHMQYYgUhEe2Ail12LYiNfXmmql6+/D/V+wnP5NbV/PX1tJKYA==
X-Received: by 2002:a05:600c:3009:b0:381:194a:8cb5 with SMTP id j9-20020a05600c300900b00381194a8cb5mr28930984wmh.43.1649662796348;
        Mon, 11 Apr 2022 00:39:56 -0700 (PDT)
Received: from ?IPv6:::1? ([95.179.233.4])
        by smtp.gmail.com with ESMTPSA id p8-20020a5d4e08000000b002054b5437f2sm25185041wrt.115.2022.04.11.00.39.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Apr 2022 00:39:55 -0700 (PDT)
From:   Kinglong Mee <kinglongmee@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.7\))
Subject: [PATCH] cifs: flush all dirty pages to server before read/write
Message-Id: <DDB2AB1F-38C5-4295-97AA-2C55616E7CFB@gmail.com>
Date:   Mon, 11 Apr 2022 15:39:50 +0800
Cc:     linux-cifs@vger.kernel.org
To:     sfrench@samba.org
X-Mailer: Apple Mail (2.3608.120.23.2.7)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Testing with ltp, fsx-linux fail as,

# mount -t cifs -ocache=3Dnone,nobrl,guest //cifsserverip/test =
/mnt/cifs/
# dd if=3D/dev/zero of=3D/mnt/cifs//junkfile bs=3D8192 count=3D19200 =
conv=3Dblock
# ./testcases/bin/fsx-linux -l 500000 -r 4096 -t 4096 -w 4096 -N 10000 =
/mnt/cifs/junkfile
skipping zero size read
truncating to largest ever: 0x2c000
READ BAD DATA: offset =3D 0x1c000, size =3D 0x9cc0
OFFSET	GOOD	BAD	RANGE
0x1c000	0x09d2	000000	0x22ed
operation# (mod 256) for the bad dataunknown, check HOLE and EXTEND ops
LOG DUMP (10 total operations):
1: 1649662377.404010 SKIPPED (no operation)
2: 1649662377.413729 WRITE    0x3000 thru 0xdece (0xaecf bytes) HOLE
3: 1649662377.424961 WRITE    0x19000 thru 0x1b410 (0x2411 bytes) HOLE
4: 1649662377.435135 TRUNCATE UP	from 0x1b411 to 0x2c000	=
******WWWW
5: 1649662377.487010 MAPWRITE 0x5000 thru 0x13077 (0xe078 bytes)
6: 1649662377.495006 MAPREAD  0x8000 thru 0xe16c (0x616d bytes)
7: 1649662377.500638 MAPREAD  0x1e000 thru 0x2054d (0x254e bytes)	=
***RRRR***
8: 1649662377.506165 WRITE    0x76000 thru 0x7993f (0x3940 bytes) HOLE
9: 1649662377.516674 MAPWRITE 0x1a000 thru 0x1e2fe (0x42ff bytes)	=
******WWWW
10: 1649662377.535312 READ     0x1c000 thru 0x25cbf (0x9cc0 bytes)	=
***RRRR***
Correct content saved for comparison
(maybe hexdump "/mnt/cifs/junkfile" vs "/mnt/cifs/junkfile.fsxgood")

Those data written at MAPWRITE is not flush to smb server,=20
but the fallowing read gets data from the backend.=20

Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
---
 fs/cifs/file.c  | 22 ++++++++++++++++++++++
 fs/cifs/inode.c |  2 +-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d511a78383c3..11912474563e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3222,6 +3222,7 @@ static ssize_t __cifs_writev(
 	struct kiocb *iocb, struct iov_iter *from, bool direct)
 {
 	struct file *file =3D iocb->ki_filp;
+	struct inode *inode =3D file_inode(iocb->ki_filp);
 	ssize_t total_written =3D 0;
 	struct cifsFileInfo *cfile;
 	struct cifs_tcon *tcon;
@@ -3249,6 +3250,16 @@ static ssize_t __cifs_writev(
 	cfile =3D file->private_data;
 	tcon =3D tlink_tcon(cfile->tlink);
=20
+	/* We need to be sure that all dirty pages are written to the =
server. */
+	if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
+	    inode->i_mapping && inode->i_mapping->nrpages !=3D 0) {
+		rc =3D filemap_write_and_wait(inode->i_mapping);
+		if (rc) {
+			mapping_set_error(inode->i_mapping, rc);
+			return rc;
+		}
+	}
+
 	if (!tcon->ses->server->ops->async_writev)
 		return -ENOSYS;
=20
@@ -3961,6 +3972,7 @@ static ssize_t __cifs_readv(
 {
 	size_t len;
 	struct file *file =3D iocb->ki_filp;
+	struct inode *inode =3D file_inode(iocb->ki_filp);
 	struct cifs_sb_info *cifs_sb;
 	struct cifsFileInfo *cfile;
 	struct cifs_tcon *tcon;
@@ -3986,6 +3998,16 @@ static ssize_t __cifs_readv(
 	cfile =3D file->private_data;
 	tcon =3D tlink_tcon(cfile->tlink);
=20
+	/* We need to be sure that all dirty pages are written to the =
server. */
+	if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
+	    inode->i_mapping && inode->i_mapping->nrpages !=3D 0) {
+		rc =3D filemap_write_and_wait(inode->i_mapping);
+		if (rc) {
+			mapping_set_error(inode->i_mapping, rc);
+			return rc;
+		}
+	}
+
 	if (!tcon->ses->server->ops->async_readv)
 		return -ENOSYS;
=20
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 2f9e7d2f81b6..d5c07196a81e 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2440,7 +2440,7 @@ int cifs_getattr(struct user_namespace =
*mnt_userns, const struct path *path,
 	if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE | =
STATX_BLOCKS)) &&
 	    !CIFS_CACHE_READ(CIFS_I(inode)) &&
 	    inode->i_mapping && inode->i_mapping->nrpages !=3D 0) {
-		rc =3D filemap_fdatawait(inode->i_mapping);
+		rc =3D filemap_write_and_wait(inode->i_mapping);
 		if (rc) {
 			mapping_set_error(inode->i_mapping, rc);
 			return rc;
--=20
2.35.1

