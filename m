Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A874401
	for <linux-cifs@vger.kernel.org>; Mon, 15 Jan 2024 01:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9E/HoSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08909C43399
	for <linux-cifs@vger.kernel.org>; Mon, 15 Jan 2024 01:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705282474;
	bh=sTsR3kEXgSpd9zVROhJ7khOcVbmJlFxaxG4HCw7vCGY=;
	h=From:Date:Subject:To:Cc:From;
	b=L9E/HoSeX4z8T3/lEGFaFvcmmDQFbZSApkaKRpRwgSwYFoQqQUhSrrsWaP8qgyARa
	 gUBOjLDeGkp4HtSExGiMTg2tickqkWngxZEiuRdxXkzCIvLkD9A7jKptpv3fb96BNH
	 caUkAYsd7E4NdRTFwMrPbdD4DUILzO7NTaJXF++6aaihtPszkLxth84RS/aSG8Iae2
	 4FpOcTc2ir8gSKCh3LwtpvcgvHzi33j4kd2I/gMJQjuSPIoovvsTElYtQXWipPqRqR
	 IbrlpWED3QHqA7SBeSiQedp2AQjmR2NxoUY1yTubtPKYFH7029rNARHGhBVKJpwBfw
	 cEWf3XV/JGJRw==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-204520717b3so5815149fac.0
        for <linux-cifs@vger.kernel.org>; Sun, 14 Jan 2024 17:34:33 -0800 (PST)
X-Gm-Message-State: AOJu0YwEQF8VVfnoEMau7tLXLQqlREIj5jivvHnv9J4kQbiGnoAoFkzn
	/ULDG6ANqogUabR/2qiuxPLERxyqaD+3VjPPRzo=
X-Google-Smtp-Source: AGHT+IG/hfMmPtu4RCWWUIkfdzfvpM6G9spKr9XAgeZkuyWkI6GRSaveF2HJKA8gNDZFfq1Q9NeX4l3qCbzV1BWDjSY=
X-Received: by 2002:a05:6870:7807:b0:203:b957:e0bc with SMTP id
 hb7-20020a056870780700b00203b957e0bcmr7300839oab.116.1705282473264; Sun, 14
 Jan 2024 17:34:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:668c:0:b0:513:2a06:84a8 with HTTP; Sun, 14 Jan 2024
 17:34:32 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 15 Jan 2024 10:34:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_BwOLLKmV6BSwPoCF=TXn7cKBMQVGsx+4o0gyKBj-hzg@mail.gmail.com>
Message-ID: <CAKYAXd_BwOLLKmV6BSwPoCF=TXn7cKBMQVGsx+4o0gyKBj-hzg@mail.gmail.com>
Subject: [PATCH] ksmbd: only v2 leases handle the directory
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Namjae Jeon <linkinjeon@kernel.org>

When smb2 leases is disable, ksmbd can send oplock break notification
and cause wait oplock break ack timeout. It may appear like hang when
accessing a directory. This patch make only v2 leases handle the
directory.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 001926d3b348..53dfaac425c6 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1197,6 +1197,12 @@ int smb_grant_oplock(struct ksmbd_work *work,
int req_op_level, u64 pid,
 	bool prev_op_has_lease;
 	__le32 prev_op_state = 0;

+	/* Only v2 leases handle the directory */
+	if (S_ISDIR(file_inode(fp->filp)->i_mode)) {
+		if (!lctx || lctx->version != 2)
+			return 0;
+	}
+
 	opinfo = alloc_opinfo(work, pid, tid);
 	if (!opinfo)
 		return -ENOMEM;
-- 
2.34.1
