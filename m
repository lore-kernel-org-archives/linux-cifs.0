Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F63A2FE060
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 21:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335930; cv=none; b=pQQnJg0hBlw5Si1Q6ZWiNgELVJLCW/5haeUv4ZXB6Xe2IHTk5sPFj11vU0YoY3YcvUw45HZA76VgXbKLWaXHoR1pigdk7wyi444XZ8guGOIgq6JCpGI3brZ1qWjiC752cfMWr1FHBJYSo/l2tpj55Ucyb6bzka2lAaRiklZp7Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335930; c=relaxed/simple;
	bh=f+YJXylF+jELmM3YL8b/3zgaQ/j7J8cGlBlt+c/+tZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6M/IgSCFSAvnxYEwZbuEgkyHCMXfkhsCn/vc4ifHyV287ujUd1m7HXGN6mwAQkFfMhajsE1vB1YquMl1tMzQJO6c2w0Ulu89S2aKTzKbRZI0cs6YnmmNIrJkWsaD1KNoqKRVNJ2N+p2VoedaDVdl4szkYpkNtaT4lTuPNbOWTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fgptOSQ6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AG2MPAVa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fgptOSQ6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AG2MPAVa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789335928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KKqvOsVDrJRPcyxb6Szb7e0yhM454WCjOV2ZQ8hI9uY=;
	b=fgptOSQ6LcmevO4aisjE46zY+hyvxxxL9+lvKweQAk2/8mUj+0hmCauKpaNt9mw2ap3Mpm
	k7JQmGMbqDr+PsT45v9O2gOlgCpnqr/hh/EMnv0YQDr/TlBg/zPE11wyLh6gkDUHi7AWHH
	ts3cNr2Bsk3BbDx482UFiBZmKu9klWE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-jA_qDW9TNTuPJyA83F9cPg-1; Sun, 13 Sep 2026 17:45:22 -0400
X-MC-Unique: jA_qDW9TNTuPJyA83F9cPg-1
X-Mimecast-MFC-AGG-ID: jA_qDW9TNTuPJyA83F9cPg_1789335921
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9103f4ddce5so31797806d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 14:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789335921; x=1789940721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KKqvOsVDrJRPcyxb6Szb7e0yhM454WCjOV2ZQ8hI9uY=;
        b=AG2MPAVak6OeIfAQNylyYx5uYp4f7Jk1VwsD7hB/LEkz2/LRXztVr4H3dtHYlxE+98
         smMcffsme+Kmc0aPW2O8udosqi8l5Ml3wBX1ZduaODi/YxNYmYTEN1TwOxFpGDM3yYAN
         mYiQrHgI1nu6YJ7NAhzeVPKi7ZzWYZsUp1DgEMHbZmFqpQ/kl1zz/As1iffgFyG51S8r
         /XDlrWoJmBUSPHXfs7/2X+8qH++DveWi4Y5ZvOnI+fu/evT7I5svGosgZZVG8ii4QOxE
         e3u1PKhscpYxptxIYn2zrzJ8IIzRGXBaWlch8WPxBX8pJW0M2m7CF7uE3dCXrcFN/Zfa
         6sRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335921; x=1789940721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KKqvOsVDrJRPcyxb6Szb7e0yhM454WCjOV2ZQ8hI9uY=;
        b=VVB8vGOBGqrtLmjd+bE9MhecukQfkItRQ2LWMlG0z0Qsim9orWjTXdIFMvOUvbIi2v
         VVDVzD1lDgbQt8NvxjArxGgmB4BM/9unEajAXoQY8F06W2pxvGvl5KbZkzv6Cp04W80B
         HxL5khD08orGlze11FyWo9/xcqswkgzJXi6LAqf9U1wb68gYc12KkTmipau1QIBp986n
         Fl1mLmAD520YUQchlKPyFFMkmJCVbipPA526q29bGSeTRjgwOTFu0zgxurqSq0FSTzzJ
         za7wUs7m1aLywUuYuWih9SXs9ZpdfZRAgeB+0o8p7TpFExhbq5lXyJN6WUMc3Mh2mOl7
         3bSw==
X-Gm-Message-State: AFuF++k2VWIBttaOpV8SjhdilP9QXZzwi1kJEPfxH5w8Yxg9Mc3uxxfY
	yp+vM/nxjjv234dYYlRAJm1sRiqrs9gMxMHEczS7EPdB2JNRSEyCUBZ58w0BcuSiZttFpu0Hlo9
	RlZhPJTHu6rEpcuN019ZgWSVHZr2JcjKO4isX5Ib1VC05dAiQ9va77LHHyAW9GV9Z79MZtL65vr
	qOB6FHyDpYkJmpAJMzxGCxA9Z4wo1Tmealneo2Jdj7PAlXpk8doA==
X-Gm-Gg: AYBFou35ODP6seCuT3bURKzPEDXKS1HQ5AbWD3DjcSgKh9lldFEchysixIXSBem5Rbv
	+1h1NG7bsdf/PbmAczU0veWh4vMfw1DZV/tskcQhc0dnv0HQRT3C5QCKOu0N+Wnqoj58qJIs8Y3
	AsUiMponZePqD4Z1sax8uikpmVpAVRa+4kGwBOYzPSQcHAwGnHzOvkCn4mya/R/IzA+4XcNHAmL
	15sGUY2fkfl+haNPNklK9xpTQLLwpnh+S/SXMt2WzrYR+gbFgEpcTbhdqWvawNPCU4/+1oJpIVX
	tdoVqiac2CuGfO0oBuao7HaBRUI52gfBYN3BBY4gDV/bO8h5zcvvJYWR46lgrNc3Y9LDPqBXtqw
	XKQMCU9Aj8Jw93b5YtYRAK3E7ST+Yu1It+lgv59vZNYo+fvDwawKjHiHN05p49exv3w==
X-Received: by 2002:a05:6214:4a05:b0:910:3988:b3b with SMTP id 6a1803df08f44-9121210a899mr243747556d6.36.1789335921450;
        Sun, 13 Sep 2026 14:45:21 -0700 (PDT)
X-Received: by 2002:a05:6214:4a05:b0:910:3988:b3b with SMTP id 6a1803df08f44-9121210a899mr243747136d6.36.1789335920941;
        Sun, 13 Sep 2026 14:45:20 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f49444bsm78581126d6.29.2026.09.13.14.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:45:19 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v4 04/10] smb: client: fix missing lower-bound check on DFS referral string offsets
Date: Sun, 13 Sep 2026 16:45:02 -0500
Message-ID: <20260913214510.3071370-5-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260913214510.3071370-1-sorenson@redhat.com>
References: <20260913214510.3071370-1-sorenson@redhat.com>
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

If a server provides an offset smaller than sizeof(struct dfs_referral_level_3),
the derived string pointer overlaps with the struct fields, causing
cifs_strndup_from_utf16() to interpret header data as UTF-16 strings.

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

