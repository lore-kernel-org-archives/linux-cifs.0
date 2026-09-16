Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E2451E456
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572612; cv=none; b=RXV2dDQ8MvKQ71aFrpYSy8nfSagOEaCGQ8zBuXCjE0ksS02kyagE9T2Hu5dHvuPOMGDvQkeXKOv2kHCFWFXJl9uH6dnRG5Sg7XLY4ED+xqNlP3UtfH+Jee/XDHWYY0o509FWRxrnQSBin8UiTJztGOpQ5rD8MMyG3JrGb3YQj7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572612; c=relaxed/simple;
	bh=cQ3XD4xlXS3A56ijjNrgFkyuFqlG6PUgCycmq37PHh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egqQNZVnd2rzwVQc6mgWqn5cFJiRp7Cwo9NnJHDfB6ZPabnE4GC56hUFUxEvgR1qhHZPZ9rPZrBu0p7g4nN4F91yPaf30mZlY1au9elUKC6gpF3LF1DVlbKg7HXEgapKgREtYzN6IunWpMLVun0GwOcGBtvdqmy6WUn8p6g6dys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=LlLhaMsq; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="LlLhaMsq"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-39e03468a5fso812069a91.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789572604; x=1790177404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=30Mb0XnSsYSSJCEzGSzxcCg7ATN2zfh7FV1OVcvN8qQ=;
        b=LlLhaMsqJrHfEt7wPjzz618ZCcA5sPy5spGtoinMz4zeGL4LmFBYTpyi/nMG6ChBOx
         BzF0cFS2iZmkLTNeDwc7GGQEXPKWl5ZPmUA2pL33dplGIyqmjde6rhwb4RPkDyskKrMi
         KBe27e4OrtjEoC8/8ETRffNRyMMWPwafK24x5uSWAXKOfCNc0j0kxHSQ4YzlHV4xMpSS
         fiY9ooO8mNU89Inr/Rhcyp84CjKQX65BhtfVn0m4Jp8Cq1ShuAukbINOIiyIFdvzVIRk
         52PQ0GAp9JEFkCV3gf/VqqRwqPCq9CuYFPXrJeth/oAdS9Z/pHW2bo59d6F7k0fnmKF9
         Vvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789572604; x=1790177404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=30Mb0XnSsYSSJCEzGSzxcCg7ATN2zfh7FV1OVcvN8qQ=;
        b=c37eFfyDi9UlswbutKYGVWoSYVyr8DDUpVe8rClYrgCIdclUUDr41XDyMwGyY6WKJq
         Po6o69cMxSWV1vLx10sLF4rtO1+o1vMZ4c+UT+NqCsjbXPCojq5AOLDfGFVn/m1ThVwS
         GiHVfRUwDKpO/FgbJj2LGGFkylyVWKqnBY4k2XzpQN/E1utecutnZDAMoZGFj0DtjfXk
         kbbm2Zrpn5CP9p+aef0+6h2L6fAADqoggnNnb2bgyPKlx8S7aqLcNF7fRt878qhwhlha
         WEZJfx1MMwxP74gCLJlLo86qA1HxbAdu4vH6yLdbCFdTyvnoyZzcZcXAh3exxniwb7hV
         IsDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzpCosmxdt7T+lGC7T3cDdSSvs3LpkQfgZNT91RpLZEPeGM/Dh/V3UEu9amIHI9Arh2WMFWMcjr7V93@vger.kernel.org
X-Gm-Message-State: AFuF++lgRpoegHEsiLiqaxi+HrGqljxJL/wzvGNUM4EEBuydoukqHJO2
	ojB/oEoF8P3d1cY/GuJ/k6peXB+4MDbMX5TrFHR+fnH81zmO1XtFZ85yG1F/gK+Ai2z+
X-Gm-Gg: AYBFou20cBLx+OgYEAWPXxYpaQZZX6o6BXbUlW9Ax9a4Gx6LIWVg6VS/dvvixjPV+kT
	X1IuTc9HMDxFJwHak18iA7eN0wtY5l0g4CfL30bRDqw6hiP+8fZ8dLqnTKFi5lEkvjenGGZ05RA
	T4fUArTrP4EtJdsaNbJevHKm0Ctm7R+fTn6RvZIcgq2Sa60Lkq5UiuyNxBwTyMVydQFH0oM1Wgt
	i4GebBzBFlD3vHvfJHeeU2PaAfhBf3z0JlCCVLlNE9YjN6owh0hIDlHdmb7B6aQ5WHyyliu8OTP
	d0vtCC18Zm6KG6O4voM7N8oe/qulOR3Wuf7XqJsSEPmdLTzyxnVqTp0yIwrcjGOH6J4otx9JSyr
	4E5q1AwLQb8UFXmq7QqmiTJdAPCUtBqqzKo6hYbBdt+7M23KpeNdEM8qjOmcvz5dwXHNWEmVHCm
	a6ZgrO4gVj5zsRqh+JOzfDm17k4ap0Ai6msZw6ykXyaURqmMHCx3ZeNLom+dKXy0YGXDWXrBOdV
	72SqaESIjCpyCkJ1k2XyzHx06k7wA==
X-Received: by 2002:a17:90b:3ccb:b0:39e:433:23b5 with SMTP id 98e67ed59e1d1-39e1e24f9f4mr7077518a91.5.1789572603863;
        Wed, 16 Sep 2026 08:30:03 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35dab2e9sm28214a91.1.2026.09.16.08.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:30:03 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: pc@manguebit.org
Cc: linkinjeon@kernel.org,
	zihanx@nebusec.ai,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v4 6/6] smb: client: preserve create-context parsing errors
Date: Wed, 16 Sep 2026 15:29:29 +0000
Message-ID: <fdbc804e06159785f9b18172fc87a88a145b4e6e.1789478666.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789478666.git.zihanx@nebusec.ai>
References: <cover.1789478666.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_compound_op() saves the result from compound_send_recv() in
tmp_rc. For SMB2_OP_OPEN_QUERY it then parses the CREATE contexts, but
the final assignment of rc from tmp_rc discards a parsing error. A
malformed create-context response can therefore be reported as
successful to smb2_query_path_info().

Keep a create-context parsing error in tmp_rc so it survives per-command
response processing and is returned to the caller.

Fixes: b07687edee99 ("cifs: Improve SMB2+ stat() to work also without FILE_READ_ATTRIBUTES")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>

---
changes in v4:
  - Keep a create-context parsing error in tmp_rc while processing later
    compound responses.
  - v3 Link: https://lore.kernel.org/all/cover.1788516372.git.zihanx@nebusec.ai/
changes in v3:
  - No counterpart; this patch is added in the v4 reroll.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - No counterpart in v2.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/

---
 fs/smb/client/smb2inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 6971496dfe8c2..cedad9daeb220 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -582,8 +582,10 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		/* smb2_parse_contexts() fills idata->fi.IndexNumber */
 		rc = smb2_parse_contexts(server, &rsp_iov[0], &oparms->fid->epoch,
 					 oparms->fid->lease_key, &oplock, &idata->fi, NULL);
-		if (rc)
+		if (rc) {
 			cifs_dbg(VFS, "rc: %d parsing context of compound op\n", rc);
+			tmp_rc = rc;
+		}
 	}
 
 	for (i = 0; i < num_cmds; i++) {
-- 
2.43.0

