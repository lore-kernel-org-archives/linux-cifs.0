Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9582DCBE3
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776693067; cv=none; b=hcND5Ct9zuJlRweHeWN/pKPfzn2JsRHEy67GgxeBI2dk2yaV2P0q5tsc5vdQLWWOAxyOG/spYZWk/Yis3s0ikvQHmLq+aFJvAvG5xSdhiNhFec1uTM7H4L3inE+1TqGmqvVoavHG/hHymLdrjBr/gv4rd0ROTVOMQy49ABPZm0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776693067; c=relaxed/simple;
	bh=vmZvs6UHY7QD3B9MWYRhLwssp9+U49BA9oDYPNJlnbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WQZqf/y/WfPqj7sZjLdzmBJirRiStFhivmg2xYAVXwIDklSgDTzhuBGSW5VUG2UHLwGr/zb9F8XTa061DadG1t1SKMgX1CvKwrBIHVJJ5WRRwplpdF9jaExeKZrPQckplMDSfw83nD/ZHltpWIK3rlQtwEIxDQKzOaCFKZL3I2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eX1CBI0I; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eX1CBI0I"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8dfb9139008so199174785a.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 06:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776693062; x=1777297862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2CQQpu+pTCuIRdY5y4O2DIzGNhbLx1QOGGuLTzhze6c=;
        b=eX1CBI0ISZbv2Dtqx9JEmkmhtO9WaeFmWzGJxfDY58gGclDPTjLddsg7dijrhcFXk3
         8tikwhZAkUd9yivwOGS4nIrbrPlVeeTGyt/QJ96yEgr2rNgWwVmR6Eg/svqHb0XY8eee
         j/erY13lySWTYWbaCnMMrA/QnmOV9zEkqEYFVXgvl/uXL3B05RgaFYiKDv0MCuenp0ZR
         ig5Dr2pmSIRFGnff1TeBnfbk28J5SdUTENMRYPW3kQY+UlPA98EdVDdf4FauSpOxG2o6
         yy5ycx8LcPKoGDCGjfqCR1naZ9Iew6mwU7H9zVCG7VyQiOcXlo9D55lcHE73dtJQnGbZ
         LEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776693062; x=1777297862;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2CQQpu+pTCuIRdY5y4O2DIzGNhbLx1QOGGuLTzhze6c=;
        b=N5okDjLkHeFh4NFFTDjxXBwvHBYyAx2qEtOgOum+0Td92uElfDTMP3678fpxjwATTd
         JDEwaHrnv81Wtmy2urLgMoYy14Akn2DKDEXRUFJGE06dfZEOUDsUe82HQkKg48xBjGdl
         PPksTPnGnJNvO28f44XX9ZTgJxe5LxV/8jEPlQ5Cl5oAM85NyngU8/ibyrwZrThs3Q8h
         PPNyS5epy3fVRW8cp9hBBiFUbGcGotc6JJoKGmpuirQoF684JVH/ZhXT+1c99KOdsi1w
         ZbGnTthJcGpzQg7mgpnBTIJSBV4YqGDrGvCuJt+6QMIPukgRR+DCpt8mbHHT47tyWGOb
         fNZQ==
X-Forwarded-Encrypted: i=1; AFNElJ+J/y4ttVzcodlBGMeJZsn7PpfXYXd1jN35iislKKKO4sAV9j5h3qMri7UDz1yp/9mXgT8b2lwc5rVz@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2hWClKRVJBsaDpwvcfL1WV86phn+Jr+afrq/v6uwguhdSGvwU
	6/0ARWuMWfbrJt41h/b0Ntilnqa57y5oP1BujNUF7zGJqXfNQjct9JwvzG3HzT9v
X-Gm-Gg: AeBDieukPuhKuYRtLRsjiaZbL9GfUp+clF+4gw3bH5Md1H1Vwx9itPPFaSIux8ET7BG
	daXVTbo9tDtsY3m+9Xpm/t5H11vaNNUtgTUxA19yaNzgL5EqH7RscMDr6h2mAwfRwStNXfLgtXX
	KtuE6JmgOisaXCsW7KFneEg+3z0bdzCQgiJm66tsRWqSx9ByLLfKS/aFiRPPTzyIk7XZfAxsHVE
	hUlIm60W/G+OC5e5KoY2l3J4FyLj/FVytrRe3k3nR74sG+Q46SdEcBSKJgZ+mBQCtxj1H3/PmZe
	HD+iOkeeRxHfhcMnn34oLpK8ORRv4gcgrXO/8GRovcKEm2vAMUeRA/LxHQxgulGYnNtVmWzVwCT
	VB3JrusMWdXlIx9ft/Cj6UOinm1FwjIkN9Ee8X89fE3XogXddaTvetp3xFT5KnnyZz3w8uoKsbx
	enTT28LpfFUc83RcArqm3vbKwaTldG4fELScqE0I3LuaalTCZPBxCbLwu55rw4hzC+8R5zNbGE7
	gp0LNuRWZf8P4kOB1lTbNgJ3SCCABHieLK65XnN+w==
X-Received: by 2002:a05:620a:370e:b0:8cf:d953:b4f1 with SMTP id af79cd13be357-8e78f72ffd4mr1870500885a.1.1776693061842;
        Mon, 20 Apr 2026 06:51:01 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d69abee3sm790342385a.17.2026.04.20.06.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 06:51:01 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: require a full NFS mode SID before reading mode bits
Date: Mon, 20 Apr 2026 09:50:58 -0400
Message-ID: <20260420135058.469990-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_dacl() treats an ACE SID matching sid_unix_NFS_mode as an NFS
mode SID and reads sid.sub_auth[2] to recover the mode bits.

That assumes the ACE carries three subauthorities, but compare_sids()
only compares min(a, b) subauthorities.  A malicious server can return
an ACE with num_subauth = 2 and sub_auth[] = {88, 3}, which still
matches sid_unix_NFS_mode and then drives the sub_auth[2] read four
bytes past the end of the ACE.

Require num_subauth >= 3 before treating the ACE as an NFS mode SID.
This keeps the fix local to the special-SID mode path without changing
compare_sids() semantics for the rest of cifsacl.

Fixes: e2f8fbfb8d09 ("cifs: get mode bits from special sid on stat")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/smb/client/cifsacl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index c920039d733c..a62c8a733779 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -831,6 +831,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 			dump_ace(ppace[i], end_of_acl);
 #endif
 			if (mode_from_special_sid &&
+			    ppace[i]->sid.num_subauth >= 3 &&
 			    (compare_sids(&(ppace[i]->sid),
 					  &sid_unix_NFS_mode) == 0)) {
 				/*
-- 
2.53.0

