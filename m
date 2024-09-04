Received: from mx.astralinux.ru (mx.astralinux.ru [89.232.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6811D383A2;
	Wed,  4 Sep 2024 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.232.161.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725461357; cv=none; b=Se5tgiehKls0hSNpQRPYqo6x/yuNFvkWJMbNK1pwugzm6CtUoDHGuRKmEydIdfyhUR1XBu6rQxm6vWxa4qWK8S6t8iIFb2+BlSoqtFGF+HFHw6SuR7pHmGhKS7fHaqCWRTntJ9qooX6P61TZ6TcDmrN2m4uVii/H4Keek4qVjeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725461357; c=relaxed/simple;
	bh=ih32sz16+1Bo8017jKrT+lylx+9UJQKMc0c26/f6B2E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y8aeNIJ8IQO6WyLDqTH6xIhma9UbusjUPvLHDtap71Rds0qNGiHNEmS2vKf4OXR0ksturwtKuJW1AyLDfsWMEB+oFZJRlDAijbzdE2T6rG/y6hmxSsDx6yC6pjHkCIF9Gj13B4FhUA5X5FbMDCXbOdiQjMrCkWLBz+HSPgYSXz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; arc=none smtp.client-ip=89.232.161.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Received: from [10.177.185.108] (helo=new-mail.astralinux.ru)
	by mx.astralinux.ru with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <adiupina@astralinux.ru>)
	id 1slrIK-009mJm-3t; Wed, 04 Sep 2024 17:47:40 +0300
Received: from rbta-msk-lt-302690.astralinux.ru (unknown [10.198.38.84])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4WzQNW5xtsz1gx6v;
	Wed,  4 Sep 2024 17:48:43 +0300 (MSK)
From: Alexandra Diupina <adiupina@astralinux.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandra Diupina <adiupina@astralinux.ru>,
	Steve French <sfrench@samba.org>,
	stable@vger.kernel.org,
	Aurelien Aptel <aaptel@suse.com>,
	Paulo Alcantara <palcantara@suse.de>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10] cifs: Fix freeing non heap memory in dup_vol()
Date: Wed,  4 Sep 2024 17:48:32 +0300
Message-Id: <20240904144832.28857-1-adiupina@astralinux.ru>
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
X-DrWeb-SpamDetail: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehuddgtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfftfghgfeunecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeetlhgvgigrnhgurhgrucffihhuphhinhgruceorgguihhuphhinhgrsegrshhtrhgrlhhinhhugidrrhhuqeenucggtffrrghtthgvrhhnpeduleetfeehffekueeuffektefgudfgffeutdefudfghedvieffheehleeuieehteenucffohhmrghinheplhhinhhugihtvghsthhinhhgrdhorhhgnecukfhppedutddrudelkedrfeekrdekgeenucfrrghrrghmpehhvghloheprhgsthgrqdhmshhkqdhlthdqfedtvdeiledtrdgrshhtrhgrlhhinhhugidrrhhupdhinhgvthepuddtrdduleekrdefkedrkeegmeehkeefuddvpdhmrghilhhfrhhomheprgguihhuphhinhgrsegrshhtrhgrlhhinhhugidrrhhupdhnsggprhgtphhtthhopedutddprhgtphhtthhopehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrughiuhhpihhnrgesrghsthhrrghlihhnuhigrdhruhdprhgtphhtthhopehsfhhrvghntghhsehsrghmsggrrdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprggrphhtvghlse
 hsuhhsvgdrtghomhdprhgtphhtthhopehprghltggrnhhtrghrrgesshhushgvrdguvgdprhgtphhtthhopehlihhnuhigqdgtihhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsrghmsggrqdhtvggthhhnihgtrghlsehlihhsthhsrdhsrghmsggrrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhvtgdqphhrohhjvggttheslhhinhhugihtvghsthhinhhgrdhorhhgnecuffhrrdghvggsucetnhhtihhsphgrmhemucenucfvrghgshem
X-DrWeb-SpamVersion: Dr.Web Antispam 1.0.7.202406240#1725456685#02
X-AntiVirus: Checked by Dr.Web [MailD: 11.1.19.2307031128, SE: 11.1.12.2210241838, Core engine: 7.00.65.05230, Virus records: 12157423, Updated: 2024-Sep-04 13:08:53 UTC]

Remove kfree(&vi->smb_vol), since &vi->smb_vol
is a pointer to an area inside the allocated memory.

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

