Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92320369D4A
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 21:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335936; cv=none; b=K0z1rR1A8orwQhTyNalwf5gh1xZG8rWNXAWISV7d8eTbKIpK84mJK6Q9zypxSRU3PPqagdyLmCyUJTs2dy5IW9FhFfca5TpK3nvnYNh7SuWB+TSJgEWUG+7cgEyERj65+ovxniEXddDs9WPalhGXbBth+VqZqjckIqjigwkvZgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335936; c=relaxed/simple;
	bh=nuQpQA8faMLzi+ViEILyU/7P32ImMw0Svlm3CB3LCuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gApHM7M8qfNm4k0vHyEKSXPMByMziyKqPsk2gUuLIXakl0bfB9QocPvW+2fWbPhyVWnPIVtVU8gMm9xOSZlrwR5R3g/lROSdZRr9HCrn1EUAfVTN1FqEeE7dMgBO5OORz4MCaJ+8I8LfTSMs03Z7Qkdb+1L93ABYKsGg7h3ZhQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ht2//hkX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4EZRUl+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ht2//hkX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4EZRUl+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789335933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h4wqcB7c2XOoCW8tei1Iz+P2VvDk2BP5ymqe1eDpV3Y=;
	b=ht2//hkXkIYrJCkgCpLYN/roFxC4OuhRJ3gpekbI6M1GL6z5oV2EAHkBnYa6/RrERH/jsI
	sI7lYiqcqg7X7Cmebm/8x+IqJJfaiQCWjh9S5XP+zZrb16tzcg8GdEYKFN+z/rioQO80To
	b+De8iYr81aZb3uu+zQ0oLBLtSgMTLQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-VOmSbAitMKK30z3k-Rma8w-1; Sun, 13 Sep 2026 17:45:32 -0400
X-MC-Unique: VOmSbAitMKK30z3k-Rma8w-1
X-Mimecast-MFC-AGG-ID: VOmSbAitMKK30z3k-Rma8w_1789335932
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530ef14c9caso19779651cf.0
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 14:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789335932; x=1789940732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h4wqcB7c2XOoCW8tei1Iz+P2VvDk2BP5ymqe1eDpV3Y=;
        b=F4EZRUl+t+bFDBCTejJmmnlWb80cKnCZNSL+Ur5NkfaK2mwlFHF9P0akvtL4rvmWY/
         im3e+08BFqyNvwBNAB9sICyMQ3vug7Tn2TtxFEqxpNS5Yx5kajKFITfIO4kKWCZiQFqs
         hzwvo784a+NLp6V0kI8CUkVRVDJHeG1DzPLlQK8HHFjcY1RdDM3ORnmNA4jdYmHlVUdf
         3KKZ8kKVJSBSw+dOhtPaTyts6l/jtxcV74ErFOFgIT0WS0Iuyu6O/gyVSc9JCA/0t3Io
         L/YqoCP4y7r9vgFK/W+QCj/DlMdinnA7hcGbasbwXO0uWsQWvnoLvn7qsEpYstLSUTgj
         fcxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335932; x=1789940732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h4wqcB7c2XOoCW8tei1Iz+P2VvDk2BP5ymqe1eDpV3Y=;
        b=pjN9h5AYjTSHB9NKL8w3RGsIGipw/XPEurC6QI+FjoPeloTnrSbRqLlhpd6/TTBAa/
         mhnu/VCGqGFawYh0phHAtjd/h0KvZLSY9/PCQcr8Mvihup9kL0jd1fwhJeNsLs70gHNv
         gzrEW1WKxfHTQ4BrB6VUYZ+L3NKAS9EsEIksGnovKz7HzNBrDifRnO6Op6wdDAn+DTH+
         2AaaYidx7cxZzYxQFjwhvHmO7YzmqENkqFL2zFCKLnXXLozIOuFmHjOzsCFUkgmR7Sxh
         Vs89xF8CXoAl4USZ6uU9xLwkBfJ4UuffIsi5kH5grFtS7ArfEXtyYnfkhMRti0FmMVab
         4AQQ==
X-Gm-Message-State: AFuF++kfTvfv+ocZNW/dp7Hp9gbhRVlvO7bthCYaKR7jA1WbsGfCzOEV
	n1Fpcc5bW5Hj5lHfs3kWcGGU/TlsAx5Lwkb2YrwteLx3KiZxhIWS0sxXuw5PDZDkGqmSqBjsvvL
	DN7Ezo3JMJyVvs6AvCtP5WoFny9uAfZvBT3/HU1xP0s01RryiVoP8uXPSfP5NwLgawKVIcu5MyJ
	aZ42UGyy5Ex8h9p1OiO2hMim4h9Nx4O0pNt2bm4LPnkBuBQJI=
X-Gm-Gg: AYBFou2zTeUUg72//5jjzwp/+wyrMZLemjzw3FuJU+t/R9dxKSJKVx5m+gicEnF97jl
	h0Om0HRSGtp/WSqqAEUNc2YJlkqHKHl4mpq86Hknriak3f+Hbs79dbXv01iYGgj7NaNJADAa6YD
	1hLmNzQl0MuHzYqKemASc3kPBaZWf2hJ8Gb6HmMyqWCB77aqA/2ElYAUOKzyJnjDD7X5fJid5AY
	4sNqecUwCufuFEfK8rBAVICBUJJ2uOnDKJwEx3xChZ/S2YfGZQEQNv1R+AT7hh/IDHz9fDoozze
	nPV6HxB4STEMwlijS97ce56gcuF1wbuP2G5yD0BSFJUJbex4e1lRUxRUo+bJZn7it8tD6Fmg9Yx
	APAVn6LTHNPsQHoLo63hXs2amiIYiH8V9+QZk7xzsZ+bYTzSGKibDdVscK2L03BZsFg==
X-Received: by 2002:a05:622a:c08:b0:530:e36d:1855 with SMTP id d75a77b69052e-530e36d205cmr152534101cf.42.1789335931926;
        Sun, 13 Sep 2026 14:45:31 -0700 (PDT)
X-Received: by 2002:a05:622a:c08:b0:530:e36d:1855 with SMTP id d75a77b69052e-530e36d205cmr152533651cf.42.1789335931258;
        Sun, 13 Sep 2026 14:45:31 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f49444bsm78581126d6.29.2026.09.13.14.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:45:30 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v4 09/10] smb: client: fix potential OOB read in smb3_enum_snapshots()
Date: Sun, 13 Sep 2026 16:45:07 -0500
Message-ID: <20260913214510.3071370-10-sorenson@redhat.com>
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

If snapshot_array_size is smaller than GMT_TOKEN_SIZE, smb3_enum_snapshots()
sets ret_data_len to sizeof(struct smb_snapshot_array) without verifying
the actual length of the server's reply.

Because SMB2_ioctl() places no lower bound on the server-supplied OutputCount
and allocates retbuf to exactly that length, a short reply results in
ret_data_len exceeding the size of retbuf. The subsequent copy_to_user()
then reads past the end of retbuf, leaking adjacent slab memory to userspace.
The subsequent clamp check is ineffective as it only reduces ret_data_len.

Fix this by rejecting replies shorter than sizeof(struct smb_snapshot_array)
with -EIO. Note that the bound is set to the 12-byte struct size rather than
the 16-byte MIN_SNAPSHOT_ARRAY_SIZE defined in MS-SMB2 3.3.5.15.1, because
12 bytes is exactly what copy_to_user() attempts to read to ensure memory
safety.

Fixes: e02789a53d71 ("smb3: enumerating snapshots was leaving part of the data off end")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ee3c98e3f316..3464470d3297 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2463,8 +2463,14 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 		 * and retry the ioctl again with larger array size sufficient
 		 * to hold all of the snapshot GMT tokens on the second try.
 		 */
-		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE)
+		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE) {
+			if (ret_data_len < sizeof(struct smb_snapshot_array)) {
+				rc = -EIO;
+				kfree(retbuf);
+				return rc;
+			}
 			ret_data_len = sizeof(struct smb_snapshot_array);
+		}
 
 		/*
 		 * We return struct SRV_SNAPSHOT_ARRAY, followed by
-- 
2.55.0

