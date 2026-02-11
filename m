Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8220B352FAB
	for <linux-cifs@vger.kernel.org>; Wed, 11 Feb 2026 04:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770783018; cv=none; b=Afh3db/QrE3e6cNF4D0ApKwBo1fpcdZSIkCm9QYW7IuR9S/iPxsuXYqz670RI4QQZdabwEMINdsJ99gDVHZaU3EqunwZQyzP9g5wASZQIrKVUW3t+gkpt81BGrbEif1/Rnzi6bSwx2i+ddsR0FI87AVwkiDG5vkdVNCTNhKx9Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770783018; c=relaxed/simple;
	bh=+GKOjhN/WlK/hiEDCAa/sV8zrF0enuAcpG+AeGdBwjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hRLBRrUyEVuhQm7alUXP00b9mVYEu13zcC7JGqFXGpDTmwg9c47JR+gBe9eKc4jVRRLiOuQQpgC6Eu/DoWx3wrltOaotxlivRGGPbMBAFVrNPO+mr5YBEd1aUfMYk4zJZ8vlhprmKiG+o07Br3DSdG2qbR0CDy7lI9RnCMTQyeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=PlRafheH; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="PlRafheH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=lSD+Ax1sDSyorPnGecWqOahNzTslXs6aYJUbfdf0TGA=; b=PlRafheHu6m+6u/VkhqXRyqA0i
	96DmHSxhcr/g9mqf4F28spEyOoixCO4OhOO0mzhon8cdzGWEm334RPSgJexpwC5o+bOgfGeedkjQA
	ozQzGu3NcPgUU/sKpXNpQPN7Yzj7gqcTUUqdsS2UuU0JIACUbTuBZxdOoT9cwPSnLf3vNeQj2HyIA
	OCN7hf07Ea0ssvHikxiqyXsaNsFQVf9jSlzPMddJ/ycZljh0Sm0OwY36rjbj3Tt5JZcR6Skkg4I91
	955hUBG6WtY+o5hQwjA4HmRpvlhtntT0CsSbq97lG3PerrbozaC0HN8Brrs5Ya9QFhzXi43FSL+uy
	3gZOs5BQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vq1YF-0000000019F-3V3t;
	Wed, 11 Feb 2026 01:10:07 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Xiaoli Feng <xifeng@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix regression with mount options parsing
Date: Wed, 11 Feb 2026 01:10:07 -0300
Message-ID: <20260211041007.324919-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit 1ef15fbe6771 ("cifs: client: enforce consistent handling
of multichannel and max_channels"), invalid mount options started to
be ignored, allowing cifs.ko to proceed with the mount instead of
baling out.

The problem was related to smb3_handle_conflicting_options() being
called even when an invalid parameter had been parsed, overwriting the
return value of vfs_parse_fs_string() in
smb3_fs_context_parse_monolithic().

Fix this by calling smb3_handle_conflicting_options() only when a
valid mount option has been passed.

Reproducer:

$ mount.cifs //srv/share /mnt -o ${opts}
$ mount -o remount,foo,${opts} /mnt # must fail

Fixes: 1ef15fbe6771 ("cifs: client: enforce consistent handling of multichannel and max_channels")
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/fs_context.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index ec84204aee18..412c5b534791 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -825,9 +825,7 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 		if (ret < 0)
 			break;
 	}
-	ret = smb3_handle_conflicting_options(fc);
-
-	return ret;
+	return ret ?: smb3_handle_conflicting_options(fc);
 }
 
 /*
-- 
2.53.0

