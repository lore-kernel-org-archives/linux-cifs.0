Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF615B995
	for <linux-cifs@vger.kernel.org>; Thu,  1 Feb 2024 11:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706786151; cv=none; b=KZBlYfXgguuHMMPaVIjHl1TJu6zNEndLWfVPpRLQvf4RZrbnGjm6rPZnlvn0Vtdba1DaJUlvpxOIvN9exPlKibY5DoOBEgH1KmQLUA/xwqVfocxN5/mBqfuQ5Pzi+GQStRRHl7H4TzTzxLcj6rNg1BYaUi0rB4GbmIHxFd9bJn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706786151; c=relaxed/simple;
	bh=HCOcu/1rbGO5BBk94tFa9ME7lPJDOr2W8q6UVAEJNqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FKR20YT6u6yaCZ8Q/qv9mHO5C6YxpXcFhAFKYSuYwbQ4rZJTLXZpG2WJVnLKy/ZNuym8jgCfE/M/fXLUisXjCu70sX8eCcZ2cf+87R+NQSI9V2785Eu7brPmb3shgIYtJrxJa0i7VwG8FoOaUsZAoXB1Ju4EZr9AWvk5Lq/AohM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzUJ4qpb; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzUJ4qpb"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5d8b276979aso581842a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 01 Feb 2024 03:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706786148; x=1707390948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Frl2WBgfcQjJvWCrb+CbUqOaJYs+6rcVF+uT2seRujQ=;
        b=IzUJ4qpbgbVhVWIWwFem6ijk/HKXrCyGtlfSlTXTu/3XIKJEght24HIqYQ7Tdq2/m4
         /SRrCfafWX7fs5zvzUzCZbsUAj5Az37V6RjGXcb7jk0x0oWfsmUea7kM+yJ3xOOpArHD
         HuSBL6LHy5NYarHbDvtwI4sbeNidy8aiPTkMWvn15VgsPm1g2RbiGouLAU6nqfVAJaZA
         DJ2hdgIpVjhoBWrQcpVxq60S2cS+bylzvDqd+RRiVXFAxYfErcrREI3TdcF8PgRCCpVK
         nZ+NiOimy7j5XCsJWU8D1013t9tNO9C6RuQU/ZLg5NHGVQfijzEOOKsfFFL3AQTYPXwC
         rd4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706786148; x=1707390948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Frl2WBgfcQjJvWCrb+CbUqOaJYs+6rcVF+uT2seRujQ=;
        b=VW/BfsuyiRkCuSG7y9ssQEs+WrbADSZltn6fZ3Pa9/M3OiWkLyBHrh8sd2FxTjf14M
         nYmd+i/Y2Ypah+wOp5NplKnA+wYL8q5R4JJXsiiYnWcH2gR5WxOtOYxNvQaf5LmSLsM2
         zWeq9Bj86uJJISLiR47mfASdcjxl2TVC/ue51uY5srTUHin1wf9JBhlOEV17HhsNsxZn
         Xr3Y7jmRpgiEHllM3opnGqH9qLpGVEpxGhKq1SLWQqaGxEwK8ZhUd0Lq7u31yaYbPjWy
         Zk2D6pYQ6IspJeXk6KuQkisNxEqps2rqRhNxrG1UwKB/uc3jIbLk7V9W8nDewBaqca6r
         LkQA==
X-Gm-Message-State: AOJu0YwNgG0PVqAH8Oe1O9UEooKa4yLaNoEujIPJR2T2vgq9NAvYqis5
	YcgPZkZpRefII9T63OMLbdIHXV3uxFWRgHTIb0sUC3eSrI96LIFMCUv9Jyjr
X-Google-Smtp-Source: AGHT+IH48XlmqjbCnQuy5MGjqtUQ8eXWgEQgKVAwtGYoC7FnBKNoVDQipxRfZVL3jWrRBQ/h5xyRFg==
X-Received: by 2002:a05:6a20:1e8a:b0:19c:9419:1f37 with SMTP id dl10-20020a056a201e8a00b0019c94191f37mr3549896pzb.13.1706786148367;
        Thu, 01 Feb 2024 03:15:48 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWzhx/07OQ78AVVqULElFiAnO3JCWlsPlwsKUZ5JLDZfmkuQIVl3fHSNPsLQ2gwv+WlwNIxjhyUo2PgDRUdtpT62aBZzkUZ5tpo52ZgRBatxtTXmBsBni3lf9vl9i0PSy6gjaR6jcKKDeGN7uA+
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902f69300b001d94c4938b3sm1129926plg.262.2024.02.01.03.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 03:15:48 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/5] cifs: failure to add channel on iface should bump up weight
Date: Thu,  1 Feb 2024 11:15:29 +0000
Message-Id: <20240201111530.17194-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240201111530.17194-1-sprasad@microsoft.com>
References: <20240201111530.17194-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

After the interface selection policy change to do a weighted
round robin, each iface maintains a weight_fulfilled. When the
weight_fulfilled reaches the total weight for the iface, we know
that the weights can be reset and ifaces can be allocated from
scratch again.

During channel allocation failures on a particular channel,
weight_fulfilled is not incremented. If a few interfaces are
inactive, we could end up in a situation where the active
interfaces are all allocated for the total_weight, and inactive
ones are all that remain. This can cause a situation where
no more channels can be allocated further.

This change fixes it by increasing weight_fulfilled, even when
channel allocation failure happens. This could mean that if
there are temporary failures in channel allocation, the iface
weights may not strictly be adhered to. But that's still okay.

Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based on speed")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/sess.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 3d2548c35c9d..ed4bd88dd528 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -273,6 +273,8 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 					 &iface->sockaddr,
 					 rc);
 				kref_put(&iface->refcount, release_iface);
+				/* failure to add chan should increase weight */
+				iface->weight_fulfilled++;
 				continue;
 			}
 
-- 
2.34.1

