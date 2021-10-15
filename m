Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1547C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 23:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8018C60EB4
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 23:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbhJOXmS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Oct 2021 19:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhJOXmS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Oct 2021 19:42:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40AEC061570
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 16:40:09 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id oa4so8262831pjb.2
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 16:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BR83r/S/8FWkY5axhdp/J39B1WGg0JrkELM8Y2N7vhQ=;
        b=IAnyhpHsaIDX2xZpvXGmjiI40CiafWodBx+rIrTqdGCMnpSnPnffmlxOBER6c1+HAq
         CWOoeQRw+4ZDN0zxUafSf8bWlKa+Sno8RAZp88UhGPItE8J83lMWzaXEJZ9kQomZCrix
         qEibfgiFhaaaXlwYgkuD6sTrAAGp0p/ZH1AQQxetlqoq6UNDtZsFDC0kJUCsoxNrNg1i
         mkwnxp4AqTaPJ5vgzUstKI3SsPd03PYRo+oZMkL32AEBWJBtIurmyqAsTG6aazRf8mwh
         QkvEJwsDVaWym+DW+82iKH/TL8dQpTxjmpRKR5qd/9kCczJe4rb311UZfZx7ZzZtys32
         Dxmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BR83r/S/8FWkY5axhdp/J39B1WGg0JrkELM8Y2N7vhQ=;
        b=Mw1/GQ8J5TGrE+SAcvmZgj3f1X0eWxomwaeUAiwuldCp05WR0WDS3J00lFBY/TUJAS
         W0d0zsM/1SctiYd/ZugYQPEHHWDSzpZLYTcaQMXUe+c+o/o4LxRXP7oXK8n4HqKrq4S7
         HxjJq4Zsr4bB02bk2jpt3JMzoBJdIHzFup84Ouh979ANrpE5f1RMQ/xErkWhrDJhRMeG
         vVbyIcO5lp7pZBYOe39cJduYeFvvZr1GQSsi7DMnHwq5opqKAuVVRfHgpxXUtvKXXgMX
         /gD+vMagy45J6dkQfFDKqCSibPSPGuQcrB2Li7RLjhs2/JBPWFOM637+huOLr28o191a
         CmSA==
X-Gm-Message-State: AOAM532rP5sQHAfza3ILasvQGqFNrVGWK9VW8VOepl14uGIK8EEpi2QJ
        pagpI4WowZB8PqKLI0KN+ouegcESE6ynOv9y
X-Google-Smtp-Source: ABdhPJwo9mLn5J5R8nkBMUvKSF/RPjHtt3RhUjSR7E9XzanSVaVtaX74hymLfinHqrXAPpT15j/JNg==
X-Received: by 2002:a17:90b:38c6:: with SMTP id nn6mr16792508pjb.206.1634341209082;
        Fri, 15 Oct 2021 16:40:09 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id v9sm6112369pfc.23.2021.10.15.16.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 16:40:08 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: validate OutputBufferLength of QUERY_DIR, QUERY_INFO, IOCTL requests
Date:   Sat, 16 Oct 2021 08:39:54 +0900
Message-Id: <20211015233954.305265-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Validate OutputBufferLength of QUERY_DIR, QUERY_INFO, IOCTL requests and
check the free size of response buffer for these requests.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/smb2pdu.c | 68 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7999d8bc6892..e0f3a44e1599 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3762,6 +3762,24 @@ static int verify_info_level(int info_level)
 	return 0;
 }
 
+static int smb2_calc_max_out_buf_len(struct ksmbd_work *work,
+				     unsigned short hdr2_len,
+				     unsigned int out_buf_len)
+{
+	int free_len;
+
+	if (out_buf_len > work->conn->vals->max_trans_size)
+		return -EINVAL;
+
+	free_len = (int)(work->response_sz -
+			 (get_rfc1002_len(work->response_buf) + 4)) -
+		hdr2_len;
+	if (free_len < 0)
+		return -EINVAL;
+
+	return min_t(int, out_buf_len, free_len);
+}
+
 int smb2_query_dir(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
@@ -3838,9 +3856,13 @@ int smb2_query_dir(struct ksmbd_work *work)
 	memset(&d_info, 0, sizeof(struct ksmbd_dir_info));
 	d_info.wptr = (char *)rsp->Buffer;
 	d_info.rptr = (char *)rsp->Buffer;
-	d_info.out_buf_len = (work->response_sz - (get_rfc1002_len(rsp_org) + 4));
-	d_info.out_buf_len = min_t(int, d_info.out_buf_len, le32_to_cpu(req->OutputBufferLength)) -
-		sizeof(struct smb2_query_directory_rsp);
+	d_info.out_buf_len =
+		smb2_calc_max_out_buf_len(work, 8,
+					  le32_to_cpu(req->OutputBufferLength));
+	if (d_info.out_buf_len < 0) {
+		rc = -EINVAL;
+		goto err_out;
+	}
 	d_info.flags = srch_flag;
 
 	/*
@@ -4074,12 +4096,11 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 				    le32_to_cpu(req->Flags));
 	}
 
-	buf_free_len = work->response_sz -
-			(get_rfc1002_len(rsp_org) + 4) -
-			sizeof(struct smb2_query_info_rsp);
-
-	if (le32_to_cpu(req->OutputBufferLength) < buf_free_len)
-		buf_free_len = le32_to_cpu(req->OutputBufferLength);
+	buf_free_len =
+		smb2_calc_max_out_buf_len(work, 8,
+					  le32_to_cpu(req->OutputBufferLength));
+	if (buf_free_len < 0)
+		return -EINVAL;
 
 	rc = ksmbd_vfs_listxattr(path->dentry, &xattr_list);
 	if (rc < 0) {
@@ -4390,6 +4411,8 @@ static void get_file_stream_info(struct ksmbd_work *work,
 	struct path *path = &fp->filp->f_path;
 	ssize_t xattr_list_len;
 	int nbytes = 0, streamlen, stream_name_len, next, idx = 0;
+	int buf_free_len;
+	struct smb2_query_info_req *req = ksmbd_req_buf_next(work);
 
 	generic_fillattr(file_mnt_user_ns(fp->filp), file_inode(fp->filp),
 			 &stat);
@@ -4403,6 +4426,12 @@ static void get_file_stream_info(struct ksmbd_work *work,
 		goto out;
 	}
 
+	buf_free_len =
+		smb2_calc_max_out_buf_len(work, 8,
+					  le32_to_cpu(req->OutputBufferLength));
+	if (buf_free_len < 0)
+		goto out;
+
 	while (idx < xattr_list_len) {
 		stream_name = xattr_list + idx;
 		streamlen = strlen(stream_name);
@@ -4427,6 +4456,10 @@ static void get_file_stream_info(struct ksmbd_work *work,
 		streamlen = snprintf(stream_buf, streamlen + 1,
 				     ":%s", &stream_name[XATTR_NAME_STREAM_LEN]);
 
+		next = sizeof(struct smb2_file_stream_info) + streamlen * 2;
+		if (next > buf_free_len)
+			break;
+
 		file_info = (struct smb2_file_stream_info *)&rsp->Buffer[nbytes];
 		streamlen  = smbConvertToUTF16((__le16 *)file_info->StreamName,
 					       stream_buf, streamlen,
@@ -4437,12 +4470,13 @@ static void get_file_stream_info(struct ksmbd_work *work,
 		file_info->StreamSize = cpu_to_le64(stream_name_len);
 		file_info->StreamAllocationSize = cpu_to_le64(stream_name_len);
 
-		next = sizeof(struct smb2_file_stream_info) + streamlen;
 		nbytes += next;
+		buf_free_len -= next;
 		file_info->NextEntryOffset = cpu_to_le32(next);
 	}
 
-	if (!S_ISDIR(stat.mode)) {
+	if (!S_ISDIR(stat.mode) &&
+	    buf_free_len >= sizeof(struct smb2_file_stream_info) + 7 * 2) {
 		file_info = (struct smb2_file_stream_info *)
 			&rsp->Buffer[nbytes];
 		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,
@@ -7453,11 +7487,13 @@ int smb2_ioctl(struct ksmbd_work *work)
 	}
 
 	cnt_code = le32_to_cpu(req->CntCode);
-	out_buf_len = le32_to_cpu(req->MaxOutputResponse);
-	out_buf_len =
-		min_t(u32, work->response_sz - work->next_smb2_rsp_hdr_off -
-				(offsetof(struct smb2_ioctl_rsp, Buffer) - 4),
-		      out_buf_len);
+	ret = smb2_calc_max_out_buf_len(work, 48,
+					le32_to_cpu(req->MaxOutputResponse));
+	if (ret < 0) {
+		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		goto out;
+	}
+	out_buf_len = (unsigned int)ret;
 	in_buf_len = le32_to_cpu(req->InputCount);
 
 	switch (cnt_code) {
-- 
2.25.1

