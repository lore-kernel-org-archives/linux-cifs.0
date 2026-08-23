Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF28B3A3834
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511523; cv=none; b=SkRONboYkuCsvKVuu0EwwVu9zLQ88GEWvB3upGJlO2jRvHwnXc5rTVGOVuecAW0F8vlMZp0SX4LBYOqLCNMWAV9cSE97275/jLNuCsRfhF44CFgmLq4R/LYbUVbQfH/dp4l/wPRIw1d4oMeA+X1+JQlP4ukHIpzr5MVFJQl4BYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511523; c=relaxed/simple;
	bh=ymkOB8UMUk5U/Tsy8K8fpcj6cIsBZ2uNEJoBCL7v9V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg3NoeNlUI6geSq7tVek66KuueqyeuEfjeyFxW091tIm0O4PNYK9p4xkgou81Ch5Uygdj7G+YAbgJiy02OvX8ut9FXEUZMKEhubSdAcI3wNCZJJOf7kkL+t17TZW8sZNbWGdVW9icT2leE6ZwPnJLMkpmxIsdWDlwWrssXYk7k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UldmXxuh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PwAQuhIp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UldmXxuh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PwAQuhIp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=00oADfE3L0pXKHn0B52AvTIT7U/c7rXCUL5afdTYVxk=;
	b=UldmXxuhSNOBoNOlsFysd2CCqZQMgMqY36DGJNlM3mSCQQZYZzvYD5U5Ma+dF+jIii80I2
	Wps7J/w9T6obykAUrxZVTqwD1FuV3oGkF4OAHC5xKPkh0AdWQs+NVtcGgJZzKywARAMh0G
	dE9JIsg7wpom1+DNUh7oOfo8m2PwE+8=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-DpYleAyYOvGOKnD5qPTycA-1; Sun, 23 Aug 2026 14:58:39 -0400
X-MC-Unique: DpYleAyYOvGOKnD5qPTycA-1
X-Mimecast-MFC-AGG-ID: DpYleAyYOvGOKnD5qPTycA_1787511519
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7eb60cfd476so5609467a34.3
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511519; x=1788116319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=00oADfE3L0pXKHn0B52AvTIT7U/c7rXCUL5afdTYVxk=;
        b=PwAQuhIpI9cK+r1OTqNBQmbUKM2BOoOThtTdTxphTYsIZGpWW7zPdYFLq8YwotVUYS
         zQDXtR/vBpUTERQy8xR06nLa/eUtQ8JZv1GhJ7QT9Lxt6PCd6oByd1948BbqS4ynMDqu
         qb51/CYt9+z3pqnW5wktMM6P/QiyW6K34F0AH6ZrFNbAaW3Vva1h4rmNuKU/2IZoySGe
         KPrPt9RYJYreHaIPrNh9xTbUKuvDhl+Z/yPBxEH2J1LyM1oxrljEVZeujF3GwYf/Fn28
         QKFIam7SROmHUBfGN1XFum9T9f1wkXPPBqgkAD6S+STB82YZJ8ufawpIVkwcimbAb1Lq
         y/Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511519; x=1788116319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=00oADfE3L0pXKHn0B52AvTIT7U/c7rXCUL5afdTYVxk=;
        b=V337SKTlAxoT4bWj8rnUUw4EPR7gEZqaEs+cngibQhNHOTV5VAy8PMKWuS+iy9Clpr
         pK+Kcx7CO8r34hfoh3LBvrcJk5ksReZSbTsDgoQgoU3ZZyIh1Tts18ox3SABQhV83W1O
         bhef+rBNinl1nfGcE4mfmOM4v2/qaSdALEAfrKeVQ/CuoHbV/rczXc2mqjvcVJmDD7eJ
         5qUYku6QFn8T1o5LQAqrTofTGkW6mCzGu8F0eFwGmjGl54NjxgLlLkq3gxEJPeORg+h/
         b0UuVfPHv9mvIV4TvJPVL8UsDVNow/cAClPYCqZ96IVvVZTsgpOSYbYoILb3/Wf/h6jN
         /zXQ==
X-Gm-Message-State: AFuF++lwqoScM979ltwDfY6jnqeJeUemOGMpTAAkRuGyKqo3bCuiebCU
	6O3zndB8DL49ltXd7d7d42ePjFm9b6c0a1yWfsrFbmVkWmgODA5AL7mqe+9VrdXoj/NSDBrg/6D
	OQPwkOAonTXhpNXpJfpqw8nUaF+dyPjjmPtxDIcIwCLFN1Euj1ByTbIhYddPJTC7TqE4nb6BKc2
	VV/BeA+iNQkf389/fISU8KDiyovCKbSzoZ5ZEsdHvYJDB6S5Q=
X-Gm-Gg: AR+sD12jqBP+i9ijoSv2mA5bKqumeV4FVHUy0miV/dTuO7Iqb+na4E8ilOTyygzvDf1
	8vP3INFAiwhJistbX8xmb1CmIjHmjgxCID+HZUHhooJ+NmULCvptLLlLFkJ8nzOoYk7d8ndQ8qz
	mTUZVrpf/G+6du75OsexG1h+7jhB91Da8bmHfv+V/Sh5Pgc/UvnCQK2i77JxO4R/I99FaHQ/OAp
	ZI9enllmXIWR5oVp4SH+ec10w7sfipfju8MsmWNBbWrv9GgvlgSiUbICqBs+XcWXA1MJ8OrAD5X
	uMcRwypTn2w6SLBeHEw/LY1SpIA3ZG63RfvegV7QghjCi//qyKlDKDE+fgv+JPoGV0Ym9A48OyO
	6zdVglS8XPwsSYG0BJFSI1QHzY0sQf6UcL49PB4yU38j7QGBiTWqlkZKUmS0vISyONw==
X-Received: by 2002:a05:6830:3590:b0:7e7:76f:3ec0 with SMTP id 46e09a7af769-7f4615ccd5fmr25283749a34.15.1787511518711;
        Sun, 23 Aug 2026 11:58:38 -0700 (PDT)
X-Received: by 2002:a05:6830:3590:b0:7e7:76f:3ec0 with SMTP id 46e09a7af769-7f4615ccd5fmr25283718a34.15.1787511518292;
        Sun, 23 Aug 2026 11:58:38 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:37 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 04/11] smb: client: fix missing lower-bound check on DFS referral string offsets
Date: Sun, 23 Aug 2026 13:58:00 -0500
Message-ID: <20260823185807.3115901-5-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823185807.3115901-1-sorenson@redhat.com>
References: <20260823185807.3115901-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_dfs_referrals() checks DfsPathOffset and NetworkAddressOffset
against the buffer end but not against sizeof(*ref).  An offset smaller
than sizeof(struct dfs_referral_level_3) places the derived pointer
inside the referral header, causing cifs_strndup_from_utf16() to read
struct fields as string data.

Require each offset to be at least sizeof(*ref).

Fixes: 4ecce920e13a ("CIFS: move DFS response parsing out of SMB1 code")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/misc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 46e1382e8e04..bc7cccebf387 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -787,7 +787,11 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
 
 		/* copy DfsPath */
-		if (le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+		if (le16_to_cpu(ref->DfsPathOffset) < sizeof(*ref) ||
+		    le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+			cifs_dbg(VFS, "%s: DfsPathOffset %u out of range [%zu, %td]\n",
+				 __func__, le16_to_cpu(ref->DfsPathOffset),
+				 sizeof(*ref), data_end - (char *)ref);
 			rc = -EINVAL;
 			goto parse_DFS_referrals_exit;
 		}
@@ -801,7 +805,11 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		}
 
 		/* copy link target UNC */
-		if (le16_to_cpu(ref->NetworkAddressOffset) > data_end - (char *)ref) {
+		if (le16_to_cpu(ref->NetworkAddressOffset) < sizeof(*ref) ||
+		    le16_to_cpu(ref->NetworkAddressOffset) > data_end - (char *)ref) {
+			cifs_dbg(VFS, "%s: NetworkAddressOffset %u out of range [%zu, %td]\n",
+				 __func__, le16_to_cpu(ref->NetworkAddressOffset),
+				 sizeof(*ref), data_end - (char *)ref);
 			rc = -EINVAL;
 			goto parse_DFS_referrals_exit;
 		}
-- 
2.55.0

