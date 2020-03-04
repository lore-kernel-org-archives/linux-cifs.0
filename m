Return-Path: <SRS0=Ot+p=4V=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FF9C3F2D7
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 07:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 048CA207FD
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 07:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QmhwHp0R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgCDHm5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:42:57 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42098 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgCDHm5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Mar 2020 02:42:57 -0500
Received: by mail-pf1-f194.google.com with SMTP id f5so527924pfk.9;
        Tue, 03 Mar 2020 23:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=14FOLP39kovMhiom5TElTOvVVr83ej6vgzddbJ1ZbSw=;
        b=QmhwHp0R1nBlEgmVbZsJV2I11av6ZuPcBVRu9dKipkj40E7CDyc4j7DkzzLqRpIUsb
         8swpWFp7merjryagZqPfpGqJoPxoqyzc6EGaHdaEFSteZF9VJxhOKZKYgzhw/32gmzXG
         d4RejB71Miuhb0mfdQ3+nwngWWnoIBYwYORx7SCFUnsPgvhoo7yeRa5FA3HmUxoMP/Nc
         bFeFchhp/SzBK94dL/kLjioThshcgkOhS4hJxZVMAteqaCsjOL3i/pQMQbrNVIuFZoeY
         C5tEf3x+GXVI4WyQ9SvMschh0+Hkv4uvqqytd66qzN/dZgEgg4Qm1unpaONhjtIE2q5D
         vLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=14FOLP39kovMhiom5TElTOvVVr83ej6vgzddbJ1ZbSw=;
        b=klfpDdmPxiCvVVEYurEjpPeGMH9opwZd2JSKuwl18dUXJuCImibOv08AU/HuccMPzE
         VRV0Rqt8hueKa+QnQvJdclSNe7F+wXhzZdyXzY9K6oq6hpxOl7mjNQ+ElgqWJ815pA52
         key05v5nKr3N3Byedb143y+tpAtWbszyZy62bibOPSJLb94Y2nD9LDsgxI/jBVFyIC6u
         01hZG3PrubRvk9A/5PjyddmC4042hcgFrnSqyjJie2QQ5W3oJsGmek/bfRYJ9+AnQRkG
         /qEkjL+wJ+LxwXPbQMx7eMAsHd9L3U1h6ZnBTERvnbWe+THDSQd0ToMKBS6AI5+EBzn0
         P3Sw==
X-Gm-Message-State: ANhLgQ1qXiLH8cAED3kqjrVrZFn44ErvlLA5FMulHK6LSXoZfUlnv+Uo
        4uuw7Y2729133Tp0PG7KThU=
X-Google-Smtp-Source: ADFU+vseHleg5KSAG2OyPurpjtBZNnpwvQHxfnVc0M0p6CrA127qbqlMRtqbognjHfqrPLor1/HqRw==
X-Received: by 2002:a63:1201:: with SMTP id h1mr1467035pgl.284.1583307774971;
        Tue, 03 Mar 2020 23:42:54 -0800 (PST)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id a19sm1561337pjs.22.2020.03.03.23.42.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 23:42:54 -0800 (PST)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        smfrench@gmail.com, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] fs/cifs: fix gcc warning in sid_to_id
Date:   Wed,  4 Mar 2020 15:42:51 +0800
Message-Id: <1583307771-16365-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fix warning [-Wunused-but-set-variable] at variable 'rc',
keeping the code readable.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 fs/cifs/cifsacl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 716574a..ae42163 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -342,7 +342,7 @@
 sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		struct cifs_fattr *fattr, uint sidtype)
 {
-	int rc;
+	int rc = 0;
 	struct key *sidkey;
 	char *sidstr;
 	const struct cred *saved_cred;
@@ -450,11 +450,12 @@
 	 * fails then we just fall back to using the mnt_uid/mnt_gid.
 	 */
 got_valid_id:
+	rc = 0;
 	if (sidtype == SIDOWNER)
 		fattr->cf_uid = fuid;
 	else
 		fattr->cf_gid = fgid;
-	return 0;
+	return rc;
 }
 
 int
-- 
1.8.3.1

