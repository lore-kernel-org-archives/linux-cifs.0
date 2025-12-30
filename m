Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F29532862F
	for <linux-cifs@vger.kernel.org>; Tue, 30 Dec 2025 16:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767113710; cv=none; b=GivhKzjqUvKO0kxuuog1ShwsY2pj/4iCSzuqE/UHQqWYDczqD1+9fjmECMxN7PRSaN4MBKAA3mngEJ7+oODAg0dBbFSQfvf8WgTTelkqshLwFIOnVZRzDKSo6kCYX+CBhpP8OJBD8k6JCAqis3Mybh9wv8idE3kasLffL0u0R+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767113710; c=relaxed/simple;
	bh=+ylrM6DUEna8gSVUDwMFrd0L3TG0DdXd12LPLjhKaEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gtm1Zl+5l1AN1HXt0W2i0Jmna2ML72J9NMqP4CIIBzG0EnxffDx2GoAD7IDmFtEzsU56Vfop7m/gygA+WdMbpwEpFxzh3GSv/C4qmsKKStkmb3+COyGBE9rbDbgnJXpnrSCo/fnb9+AHp8KgfVkqVf8HOB/Ei+V9ZtlG+sMyjWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from lenovo-93812.smb.basealt.ru (unknown [193.43.11.202])
	(Authenticated sender: alekseevamo)
	by air.basealt.ru (Postfix) with ESMTPSA id CE50A2336D;
	Tue, 30 Dec 2025 19:48:34 +0300 (MSK)
From: Maria Alexeeva <alxvmr@altlinux.org>
To: smfrench@gmail.com
Cc: pc@manguebit.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	tom@talpey.com,
	vt@altlinux.org,
	Maria Alexeeva <alxvmr@altlinux.org>
Subject: [PATCH v3 0/1] Add hostname option for CIFS module
Date: Tue, 30 Dec 2025 20:47:58 +0400
Message-ID: <20251230164759.259346-1-alxvmr@altlinux.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CAH2r5mvDa8E8NKNHevoWYARY_52DJ+WQX3oetYw-pwysMyAKYQ@mail.gmail.com>
References: <CAH2r5mvDa8E8NKNHevoWYARY_52DJ+WQX3oetYw-pwysMyAKYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Good afternoon!

Unfortunately, our correspondence was interrupted at the stage of discussing 
the shortcomings of the previous patch versions - we still have not received 
the promised comments and suggestions from you.
We have decided to revert to using the name hostname for this option, 
as its application is not limited solely to domain-based DFS resources. 
For example, it can also be used for mounting via CNAME.

We will send the updated versions of the patches for both the CIFS module and 
cifs-utils in the following emails.

Maria Alexeeva (1):
  fs/smb/client/fs_context: Add hostname option for CIFS module to work
    with domain-based dfs resources with Kerberos authentication

 fs/smb/client/fs_context.c | 35 +++++++++++++++++++++++++++++------
 fs/smb/client/fs_context.h |  3 +++
 2 files changed, 32 insertions(+), 6 deletions(-)


base-commit: f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
-- 
2.50.1

