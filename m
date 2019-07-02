Return-Path: <SRS0=GYif=U7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04929C06510
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Jul 2019 18:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D204220989
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Jul 2019 18:20:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bgi/EVQT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfGBSUH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Jul 2019 14:20:07 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39738 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGBSUH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Jul 2019 14:20:07 -0400
Received: by mail-pl1-f193.google.com with SMTP id b7so807398pls.6;
        Tue, 02 Jul 2019 11:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Jd8xYP3fG+KhX6g7bNBS4eWXzd05+Eza9a78A930Hq0=;
        b=bgi/EVQTd5450nG5gU42dXnAW6I5Rm4Q8TjxB2Q1cSqxTP0yO9bMY9881nuWVJ7uwb
         9/SYbUpu0/QsxTr+WJwrRT6Wt1GIUvByj4L5r1KZY0UOHZxC4YGC9y/lwyzBWS8JnUzh
         E97mb7q+4HvYFE/1H19B6gKv/rL7zX38ywAeKAh/gKOGUu0+wzCuK02YZJIKy/Wr7NFk
         1/2iamcT7Bc7PG6y2Adshl6g/jbf0Vw0ydVvXQ84CryAoD8wrXmplTlYuIQ4W9mmT1AG
         ns4OGeT7dxIGq5dupRd+IqcvmlMG1qUbaBKsOx7OgB8CfxVMzkEj3uLzledgHqaeYPX3
         J0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Jd8xYP3fG+KhX6g7bNBS4eWXzd05+Eza9a78A930Hq0=;
        b=FrB064wA8U28UJVe2plNfpW+7aejogXMIYD0vGes7q0q6XbklnjSQG3KQnbGP3+n4T
         LsggWAxUoFez6/SrjaqtvbvZR8FZ3qII83nMJE+tnEw4xToDPCDK6gDE1H1V7jKXsrJL
         AwrwHB9gmGk6iNlFXRmx8wQzrYHalR+Vheb1Rz2B7ojfyrwvP44QMY+ZulQzgkSbxkdP
         EyDGNzUWD9NLsEpFSePe/2XSWtC1L6yhKElsbdHNedwL+6DWXCawx5nZu4PiSA0smuQw
         83gSd1NedxyVlhcd8HPb9kbbbIsAO5Tf0IkuhAEsomN4lf+L7C0bZW9z73/skhlszJAn
         vMqg==
X-Gm-Message-State: APjAAAXYZLf8wYIEhJEwMhxTEkSgK3Pa8WiE50DxJcYF4PRVgWvhsLxs
        cbnYuM5sCSu/RDMbU1ahSIipZ9K2
X-Google-Smtp-Source: APXvYqybg1FjokTgrM9gNGTLuXeT/G/dMsG6LdcUxxdF9deI7XtjdnPgXoOnqNPbrt3BC3+G1F+ocw==
X-Received: by 2002:a17:902:b20c:: with SMTP id t12mr37175998plr.285.1562091606504;
        Tue, 02 Jul 2019 11:20:06 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.92.187])
        by smtp.gmail.com with ESMTPSA id t96sm2881313pjb.1.2019.07.02.11.20.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 11:20:05 -0700 (PDT)
Date:   Tue, 2 Jul 2019 23:50:02 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: cifs: cifsssmb: Change return type of
 convert_ace_to_cifs_ace
Message-ID: <20190702182001.GA11497@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change return from int to void of  convert_ace_to_cifs_ace as it never
fails.

fixes below issue reported by coccicheck
fs/cifs/cifssmb.c:3606:7-9: Unneeded variable: "rc". Return "0" on line
3620

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 fs/cifs/cifssmb.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 2ea2855..6228719 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3600,11 +3600,9 @@ static int cifs_copy_posix_acl(char *trgt, char *src, const int buflen,
 	return size;
 }
 
-static __u16 convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
+static void convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
 				     const struct posix_acl_xattr_entry *local_ace)
 {
-	__u16 rc = 0; /* 0 = ACL converted ok */
-
 	cifs_ace->cifs_e_perm = le16_to_cpu(local_ace->e_perm);
 	cifs_ace->cifs_e_tag =  le16_to_cpu(local_ace->e_tag);
 	/* BB is there a better way to handle the large uid? */
@@ -3617,7 +3615,6 @@ static __u16 convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
 	cifs_dbg(FYI, "perm %d tag %d id %d\n",
 		 ace->e_perm, ace->e_tag, ace->e_id);
 */
-	return rc;
 }
 
 /* Convert ACL from local Linux POSIX xattr to CIFS POSIX ACL wire format */
@@ -3653,13 +3650,8 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
 		cifs_dbg(FYI, "unknown ACL type %d\n", acl_type);
 		return 0;
 	}
-	for (i = 0; i < count; i++) {
-		rc = convert_ace_to_cifs_ace(&cifs_acl->ace_array[i], &ace[i]);
-		if (rc != 0) {
-			/* ACE not converted */
-			break;
-		}
-	}
+	for (i = 0; i < count; i++)
+		convert_ace_to_cifs_ace(&cifs_acl->ace_array[i], &ace[i]);
 	if (rc == 0) {
 		rc = (__u16)(count * sizeof(struct cifs_posix_ace));
 		rc += sizeof(struct cifs_posix_acl);
-- 
2.7.4

