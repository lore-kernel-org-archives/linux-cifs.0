Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A472FE060
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 21:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335932; cv=none; b=BbSWaETIjmTNWKVkEmlh7GPiw9abVqcuM7C8PGtjvos2pZNgv03UF03vfta/JbbEH4BcS+OYvZt06gQCmut9ILTUIgiJLYAlM3u+RM3AN5AafDG1ELppJ6WZ2im0j4egq5nzP8gc3d5EtYOUn/p/YdJQytqX3kJKmD9w+zb7/SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335932; c=relaxed/simple;
	bh=V3hRYaC6tmgdcsZ5yGYav0Xh/yfqqFN1hacg6eKFoxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyMDqBhLSSEi60ONxYD1TNKlxoVdM4WgEqV/1YNqWcFSl1HzfBgmE0Zm7m+J/v3/mWY09XAm6SrL5JfmTbbRQm3maEh2e30aj8jmta4xiIAg3iXzbEcEJYwD4ht36XPlG7Rt+whgNhPSrnZa1zDT54fGentTle+0JLYJ7qQm9+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pua/S63c; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aTE2TeHk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pua/S63c";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aTE2TeHk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789335930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVRh5kukn/D6rYTpnAmlPzdqiIatWEMIIV6vU5NUkSQ=;
	b=Pua/S63c0Ux71CX2NUgJ2eGuEATGRlp9x6H5k3vD6uopZJXTh+KhhnrT3imiRV+QLLuhip
	lxEfQtf3ttnUsZahO0d6kL+lhgE6eXQIbkVSXktWX7AAS2UMONO6TSuP1ycbjORsSFB3fX
	kPLw21H4MGY4yregOfY+ReA0ycqHlOc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-6BA3GKpqMSmG7H42riayrQ-1; Sun, 13 Sep 2026 17:45:29 -0400
X-MC-Unique: 6BA3GKpqMSmG7H42riayrQ-1
X-Mimecast-MFC-AGG-ID: 6BA3GKpqMSmG7H42riayrQ_1789335928
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91054f537f9so70165216d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 14:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789335928; x=1789940728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CVRh5kukn/D6rYTpnAmlPzdqiIatWEMIIV6vU5NUkSQ=;
        b=aTE2TeHkFROFZHBhK+BsT7uyC2FGghfrQp5TfSOXW81zMd9cYqNEBHTdgi6qUrC5b2
         G5Po9cetF4a2FT+j+Jtm75OaFT15U+j+RAjTZpiI2Zqi2ICRt923k5u1qQsJhNvnjAVV
         omAqrk0eNaTmP79xzi8ozKV6/i6Q/eLl4fRBPrZxGBHeFuhOTo6Ih9IShbFSBfSS70G8
         8jZDde266m5sTqVua0rEfDOAQ8zomy+t1wG7Dxc5tzH8W2cQ0/Siqh+mw+Fyg3nr//h8
         qSbLkDw4HDaWemx9Wj8UPOAv4NZn3O18HUSvMApcqBX3+/S/pKwhK6JjBUNM2kLuW8Gy
         R9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335928; x=1789940728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CVRh5kukn/D6rYTpnAmlPzdqiIatWEMIIV6vU5NUkSQ=;
        b=ik1ZhGfvAQhJ0A+PBgpNl1eYvr3qz2nEU5qT2NJ9nx+aTGzW3E7zg3yX41kLJEeZqh
         zvdMuFPoGpnu2kg6y0JZz1DtxiRNpxPJkFZWSEeCBWLnxP3RSQ3t4eh55018pR7Rk2hv
         T+dlZ6/X4n9nGbrNY/Jk9kfJUEtq+so2LKsSxlgdVAmhHo10Xb32H6XLJIB5ArFds0PO
         7G/pdJO40egBSSl9c9SkblA6lrOFDKv7PMe3xZgtyyH70Li2KvU5jG+1YyM1AakKyXgI
         9QF9Zt6dkOYbNBOLPYFeKOQi4W4h6QAptWlPXy69PURJkM9tOg9bYAV4Gfjj+D58nPrz
         RLvw==
X-Gm-Message-State: AFuF++kZs0JIQx0wIek4YuegEFkPJUQvz45lip4J8sRXVCgfo5cQ4XJx
	SmhmTxK1OGm9+cYANiU89ojpLVYqvCYEWcM18iZDkx+EP4UtD+9LNBV6ndxeS5IJ5hMHC9sSsUC
	HA24upbhelI2+UddgYYqngBF5OCtGAtzrzuiT3Iqu4u0KlfcuhzWyqzcVzICwN4eAa7Epeed8Ev
	LSMtS2nFyVnDnMuA+YRN/SJWR3ezG4RZg5hQm1E0wlU5AcdOk=
X-Gm-Gg: AYBFou2q0dEvu5htgH40oXMY5bSavaw4877XN1FJsfkvZUVwDdj5BA4iQcTMhKQpAcx
	C8tHD61oVUL22gytr4Cqq3PCEU25ob6tilzPA5yAGdpzRYcbv1ILnViPEvmL5W2NpCKIRwm0ZAh
	+5MFrl6JPHi3Dy9ThOGHVzzhohoT4AoX6dlmLZO9nTu9GJDvtB4zmEEWdXatmu7+82dFRAp5HEn
	d+naOIuzNZQAMRkxCpvp7ynrU6/yDZV5QpDdWOoOksRLth1sI8a8is61Btu9IYMv0plWl3eYAbG
	qbnYEPXBGXGUTQ3Yu9ZdBsQ+qIVNbpvjmhMBmmYiLmcF/cpLDDwD+88xormS6ZzsEDe8GyMXSiu
	HI4xRVy/EJPUPseTTTJYMj3oCF+UB2ga+xD+8sjWRZBnvHrbo6ZiBsLJu1Rkt8OvzTg==
X-Received: by 2002:a05:6214:860a:b0:910:3923:cc74 with SMTP id 6a1803df08f44-91226bdfedemr46565466d6.29.1789335928557;
        Sun, 13 Sep 2026 14:45:28 -0700 (PDT)
X-Received: by 2002:a05:6214:860a:b0:910:3923:cc74 with SMTP id 6a1803df08f44-91226bdfedemr46565196d6.29.1789335927993;
        Sun, 13 Sep 2026 14:45:27 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f49444bsm78581126d6.29.2026.09.13.14.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:45:26 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v4 07/10] smb: client: fix missing iov bounds check in parse_posix_sids()
Date: Sun, 13 Sep 2026 16:45:05 -0500
Message-ID: <20260913214510.3071370-8-sorenson@redhat.com>
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

In parse_posix_sids(), sidsbuf_end is calculated using the server-supplied
out_len without being validated against the actual length of the received
iov (iov_len).

If a server provides an inflated out_len, sidsbuf_end will point past the
end of the iov. This defeats the bounds guards in posix_info_sid_size(),
allowing out-of-bounds reads into adjacent kernel memory.

Fix this by rejecting responses where the calculated sidsbuf_end would
exceed the received iov boundaries or cause pointer wraparound.

Fixes: a90f37e3d7ac ("smb: client: parse owner/group when creating reparse points")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 96063e355186..13fe8e3b48f3 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -77,6 +77,17 @@ static int parse_posix_sids(struct cifs_open_info_data *data,
 
 	sidsbuf = (u8 *)qi + le16_to_cpu(qi->OutputBufferOffset) + qi_len;
 	sidsbuf_end = sidsbuf + out_len - qi_len;
+	if (sidsbuf_end < sidsbuf) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u caused pointer wraparound\n",
+			 __func__, out_len);
+		return -EINVAL;
+	}
+	if (sidsbuf_end > (u8 *)rsp_iov->iov_base + rsp_iov->iov_len) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u overruns iov by %td bytes\n",
+			 __func__, out_len,
+			 sidsbuf_end - ((u8 *)rsp_iov->iov_base + rsp_iov->iov_len));
+		return -EINVAL;
+	}
 
 	owner_len = posix_info_sid_size(sidsbuf, sidsbuf_end);
 	if (owner_len == -1)
-- 
2.55.0

