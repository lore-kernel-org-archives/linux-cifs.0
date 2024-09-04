Received: from mx.astralinux.ru (mx.astralinux.ru [89.232.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3CE4205D;
	Wed,  4 Sep 2024 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.232.161.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725464159; cv=none; b=VvVBuMBuSfcLKr6PNFAxkD3kV1TzMW7Mqh4iUGf8e2SYcqDmDjjYJN4uG3w/S+aDaDMWpTLZZZ468LV8yN2NOmBRj4vWLFd7TdFdr57eop6UfaKgucy3SAJ5RaJehxYMfjx9ur2V3Kx1yw25Qc/LByOnqLKFQQzAwz1gYWIc/WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725464159; c=relaxed/simple;
	bh=u+pEa9oM80bt8tiQrRsEM/oq1M+GZ0F5FyDK9SKmlKk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l2JAMQ8CxRIbf1sNIIb6UvxXmKSEBjNaebMFvtlH2Qas0V+EEoTEthCD79dOZZK/LZyheqpMiElsEe84CFd0vxTlIV/fApIBzaTDpBJ2pEWk9+655NLkq1A8ANdx+sm3EtG4eerB7iy1Hjp9JxsctjC+zqJwyr8PmsbLEcU5Czg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; arc=none smtp.client-ip=89.232.161.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Received: from [10.177.185.109] (helo=new-mail.astralinux.ru)
	by mx.astralinux.ru with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <adiupina@astralinux.ru>)
	id 1sls1k-009mlN-Mi; Wed, 04 Sep 2024 18:34:36 +0300
Received: from rbta-msk-lt-302690.astralinux.ru (unknown [10.198.38.84])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4WzRQh36FHzkWM5;
	Wed,  4 Sep 2024 18:35:40 +0300 (MSK)
From: Alexandra Diupina <adiupina@astralinux.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandra Diupina <adiupina@astralinux.ru>,
	stable@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <palcantara@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10] cifs: Fix freeing non heap memory in dup_vol()
Date: Wed,  4 Sep 2024 18:35:36 +0300
Message-Id: <20240904153536.26533-1-adiupina@astralinux.ru>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DrWeb-SpamScore: 0
X-DrWeb-SpamState: legit
X-DrWeb-SpamDetail: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehuddgtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfftfghgfeunecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeetlhgvgigrnhgurhgrucffihhuphhinhgruceorgguihhuphhinhgrsegrshhtrhgrlhhinhhugidrrhhuqeenucggtffrrghtthgvrhhnpeduleetfeehffekueeuffektefgudfgffeutdefudfghedvieffheehleeuieehteenucffohhmrghinheplhhinhhugihtvghsthhinhhgrdhorhhgnecukfhppedutddrudelkedrfeekrdekgeenucfrrghrrghmpehhvghloheprhgsthgrqdhmshhkqdhlthdqfedtvdeiledtrdgrshhtrhgrlhhinhhugidrrhhupdhinhgvthepuddtrdduleekrdefkedrkeegmeefheduheekpdhmrghilhhfrhhomheprgguihhuphhinhgrsegrshhtrhgrlhhinhhugidrrhhupdhnsggprhgtphhtthhopeekpdhrtghpthhtohepghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprgguihhuphhinhgrsegrshhtrhgrlhhinhhugidrrhhupdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhfrhgvnhgthhesshgrmhgsrgdrohhrghdprhgtphhtthhopehprghltggrnhhtrg
 hrrgesshhushgvrdguvgdprhgtphhtthhopehlihhnuhigqdgtihhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlvhgtqdhprhhojhgvtghtsehlihhnuhigthgvshhtihhnghdrohhrghenucffrhdrhggvsgcutehnthhishhprghmmecunecuvfgrghhsme
X-DrWeb-SpamVersion: Dr.Web Antispam 1.0.7.202406240#1725456685#02
X-AntiVirus: Checked by Dr.Web [MailD: 11.1.19.2307031128, SE: 11.1.12.2210241838, Core engine: 7.00.65.05230, Virus records: 12157467, Updated: 2024-Sep-04 14:05:04 UTC]

No upstream commit exists for this patch.

Remove kfree(&vi->smb_vol), since &vi->smb_vol
is a pointer to an area inside the allocated memory.

The issue was fixed on the way by upstream commit 837e3a1bbfdc
("cifs: rename dup_vol to smb3_fs_context_dup and move it into fs_context.c")
but this commit is not material for stable branches.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 54be1f6c1c37 ("cifs: Add DFS cache routines")
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
---
 fs/cifs/dfs_cache.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 7b6db272fd0b..da6d775102f2 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1194,7 +1194,6 @@ static int dup_vol(struct smb_vol *vol, struct smb_vol *new)
 	kfree_sensitive(new->password);
 err_free_username:
 	kfree(new->username);
-	kfree(new);
 	return -ENOMEM;
 }
 
-- 
2.30.2

