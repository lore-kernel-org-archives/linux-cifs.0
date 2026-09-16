Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E28C49CF56
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594478; cv=none; b=kXvtLoESKb4XB56/d5anRFml3jGlLo9f7Vl8a3z3HwoQpp89Rw5dFnKAVxMnbi4I5GmYPE2Y6oplstNKtkGteXRG1LLyi/P78tC8MXzZU0Albi9XhYJ8r7k4dx0aNEhnsWP/pMD4oFV1xVd2Enunj7aZDiW8IssP9FSQsRsR5E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594478; c=relaxed/simple;
	bh=Qmnf+v4LrIMRZqg6edS/dfA+zof2rqtKyGrQNG8y/rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPfhA9Fwhc3/X1xwPdWrNWFUeVjeszY2srOonbpSvY8oJrEv3qY/Iz6a495Ub2Ap+YB7UTKrpWCQaub8uEsDUbTgmHiaXamtZCqofOwhityw/NGxi+QM0JABPdIfdtaGNlzolOZ1+Ad8n17MZJxf0FTajpU67uw92oWEPgxnmvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RnXrbOKD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DYkUb2G5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RnXrbOKD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DYkUb2G5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TMTDgfe97KIkncHZCw2WXJmRfTT4UsDz8mHppwqPsQ=;
	b=RnXrbOKDajMKTfkB8YxKNq+zrMFpXzyOXxeIFJPFsbz9F/uh+ZdLHFhnIYKbxaGyna51F4
	BDshQnpc0qCF/vxfIkNleWace9cLKzcfo3uaTXLhfQxbvEqBEa8VKxZflZiUiV9ruZ0bOL
	xX7m8eZBT/DarS+GaWlTXTo9L4315HA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-kKDWy0_yMVWu--f-EIt9jw-1; Wed, 16 Sep 2026 17:34:16 -0400
X-MC-Unique: kKDWy0_yMVWu--f-EIt9jw-1
X-Mimecast-MFC-AGG-ID: kKDWy0_yMVWu--f-EIt9jw_1789594456
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9123c523d0cso1815166d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594456; x=1790199256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7TMTDgfe97KIkncHZCw2WXJmRfTT4UsDz8mHppwqPsQ=;
        b=DYkUb2G5Fq7vCgnTp916zbRfUP9eOsl0c4feSQdnbTwNPzR/RQM2SlEg+OaADnxXZ6
         KoaFH+Vlfkx7SmWdKs6Vcxk19wf/ebaS6gZusFN530tlz7PEEj4Gl9dkq+l0WIC5ev80
         ez57ShJ+8b6E02bFnoLuUudQrnWBRr2awv//CqLo3KEHPsi7MUM6jUYspE1qcPmqCQj0
         wPSnHtJBupwEnv/FMIqk24m+mYqjyu2PE8YMin4HIzRX5I4WSPDffuT6Nf/eTkhDQPUV
         vr1IjnF3kNfd+JcSjsdoOLyQOEFvyMBv9DZuUXVlx3VTpcrCFYjzuPe16P7xqFwDLVFn
         58hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594456; x=1790199256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7TMTDgfe97KIkncHZCw2WXJmRfTT4UsDz8mHppwqPsQ=;
        b=T1Uhn/7zrw+EVVYQQtZdXjWIzHDSZUX4teojR/OkMct3wd1Svrhtag3CQfwffDYYZv
         ZtWUWsbHJMXdiHJfknWUmTeuCcJdibJk6Op9vVA5TSGSUUgrXrYXGB8sim4lzKu7oyUz
         alCj7CfldbURFpVGNM4Le957WPRWwpN7c6R/VYpz3cJw51YqmO7r/Sn8bHYTTWYYOumU
         gEudtd1tZZpd57Gr18xlB1HHPlXbKusoX/1X3/Mi4ScBbQmyMgIbFcS58f9DFar6Jge2
         5eKCUhXwoqzo+lTugs7zc4bQKRuCcphjQ1VInN+RfPP0RxtFSMqJWRbFsm6RCR07Xc2c
         ecnA==
X-Gm-Message-State: AFuF++mE/PEPk0HUh2PA2d1Tq7xHokfm3WmHmzsceqcPW1x0zz25KTWa
	Yzl9Mf3h0NtOV85KM1tE6RfAmjCHCJ5i6PjefvbhMEv/mVCoYiKlPqrJKqITbjKbok8DRczed+Q
	iZj61FRxPGre9ODAXj0X3H2+Ndg0g9tTdvbbMg1zV9OP4Z+Yd6tACTsaP9Oq1TszNNKLfJc31xB
	+7dq5Zw/O0aJFEzlRzekWFhRloJZfUCPhCT59c691gkIbAwd4NdA==
X-Gm-Gg: AYBFou3HGJy9flbLWLVnHz4jg5vvpuOVB1NL9QSbyHwGgXrGSEmWch33YPKPcaBfLR2
	olcaXg2o1lRTH/FINMBf2iA8l776xt748tSYB5bwG+CpfQjL9GK3LlQJICNajxNDDpp1u/s4xgi
	Hf9EUCRVfbhdzSw5iUojHOW/6wB4jKv1yVlU2KMCHOiKLoD1KpACuWsEY3B8gAyDYezcmJxLKfm
	Rm5qlSt0UQdYuqlcLMAQrHgqiUKkMGcZNBTQs4BIrvTsqYUonE5MfUYagyU+sjTR3ym92q0Bt60
	ukeVsy+9vthsPbxi2BMCmI9c8XFhU/uCfGMrXMIa2jPtE11Ouk0VAuCQ+oZGlZBnmyZdx/SeU9u
	TbT1cUX+N/BNmx/dM9EkQi8fHHEDDNfiRVTiOd9eySDWTReH9J9CXmWZrpQWcQLDtQA==
X-Received: by 2002:ac8:594b:0:b0:531:d21:5021 with SMTP id d75a77b69052e-5327ed7c18dmr74679861cf.13.1789594456066;
        Wed, 16 Sep 2026 14:34:16 -0700 (PDT)
X-Received: by 2002:ac8:594b:0:b0:531:d21:5021 with SMTP id d75a77b69052e-5327ed7c18dmr74679181cf.13.1789594455315;
        Wed, 16 Sep 2026 14:34:15 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:14 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v5 4/9] smb: client: fix missing lower-bound check on DFS referral string offsets
Date: Wed, 16 Sep 2026 16:33:55 -0500
Message-ID: <20260916213406.1496960-5-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916213406.1496960-1-sorenson@redhat.com>
References: <20260916213406.1496960-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_dfs_referrals() checks that DfsPathOffset and NetworkAddressOffset
do not exceed the buffer end, but fails to check that they don't point
inside the referral header itself.

If a server provides an offset smaller than
sizeof(struct dfs_referral_level_3), the derived string pointer overlaps
with the struct fields, causing cifs_strndup_from_utf16() to interpret
header data as UTF-16 strings.

Fix this by enforcing that string offsets are at least sizeof(*ref).

Fixes: 4ecce920e13a ("CIFS: move DFS response parsing out of SMB1 code")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/misc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 945194fe7a97..05168284f205 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -788,7 +788,11 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
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
@@ -802,7 +806,11 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
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

