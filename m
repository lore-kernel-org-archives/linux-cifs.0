Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501F72EA159;
	Fri, 13 Mar 2026 03:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773373238; cv=none; b=Q67sFaVCoIdHT6dgxk6G9ZhcqArlq2sAao3rtqUia7qIeBJL6IdJQZksySzVOwS/7OPknYqGpYdkGCMi75YADpy9fWSpAE4W3BMTgGx+fp1PGfeXK3K04+7HL7QXeLQpRo1fB5zAwG0fBdfcyjJIOsRxhu8G5C8ALrVzFWR1taE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773373238; c=relaxed/simple;
	bh=NggLR0I+UlR+c27hCToYTFR7gboM1SSAVr6TfrsU/6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZIpX+9lxK1gNQqrvcrv5PUJjhIbuf5SQDzbKCDLwnFK27i59heqj9yXt/riHJvN+Bv9AZt2Feu4CBJgTX3pktMBiqvl4xY3e1We3kGEuMWcDjDhVpqhByrF4I2Uc1Frd3gHrledLrUvplUI0JkTAG3p3foBZCoScFTfu7ePQ+Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=j09M3lJP; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="j09M3lJP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=kpxSdz/+UMvNKg0RMweyNkPP8eMewLSlykXzZYK04VA=; b=j09M3lJPrMyI+FHTpzctWDKtLd
	6TLCa3PvFXg0WJyQfeppUcyDlH2uIPGWhzYw/3eHAOCkcoJYl0UogytAQC/pVjAcAe4nXTM0N2/QQ
	gCorH/XMS+EX/EKV1q7UGTzahS6OQSaQ68xTnvYB7rokXYAlQwZYWS8HBIdx3rQk++dpFjwYRUnmA
	/oJP1k5RzN3UQSTzyJjFOZ7yo1h6YQJGocYojNhMmycHRsLVx/mK6LIISXkbUiPMKuchL0E3kqvbB
	WiDurUx5cMZstK40V0MRsf3SJdOSy1pcsQtPz1/YheaGSBPJdoaD+K+B3FFAmfXZSttc/cjx4qz+J
	bWi8Aqqw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w0tNz-00000000pLA-3ZMI;
	Fri, 13 Mar 2026 00:40:27 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Oscar Santos <ossantos@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix krb5 mount with username option
Date: Fri, 13 Mar 2026 00:40:27 -0300
Message-ID: <20260313034027.933719-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Customer reported that some of their krb5 mounts were failing against
a single server as the client was trying to mount the shares with
wrong credentials.  It turned out the client was reusing SMB session
from first mount to try mounting the other shares, even though a
different username= option had been specified to the other mounts.

By using username mount option along with sec=krb5 to search for
principals from keytab is supported by cifs.upcall(8) since
cifs-utils-4.8.  So fix this by matching username mount option in
match_session() even with Kerberos.

For example, the second mount below should fail with -ENOKEY as there
is no 'foobar' principal in keytab (/etc/krb5.keytab).  The client
ends up reusing SMB session from first mount to perform the second
one, which is wrong.

```
$ ktutil
ktutil:  add_entry -password -p testuser -k 1 -e aes256-cts
Password for testuser@ZELDA.TEST:
ktutil:  write_kt /etc/krb5.keytab
ktutil:  quit
$ klist -ke
Keytab name: FILE:/etc/krb5.keytab
KVNO Principal
 ---- ----------------------------------------------------------------
   1 testuser@ZELDA.TEST (aes256-cts-hmac-sha1-96)
$ mount.cifs //w22-root2/scratch /mnt/1 -o sec=krb5,username=testuser
$ mount.cifs //w22-root2/scratch /mnt/2 -o sec=krb5,username=foobar
$ mount -t cifs | grep -Po 'username=\K\w+'
testuser
testuser
```

Reported-by: Oscar Santos <ossantos@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
---
 fs/smb/client/connect.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 3bad2c5c523d..8573d5c5235b 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1955,6 +1955,11 @@ static int match_session(struct cifs_ses *ses,
 	case Kerberos:
 		if (!uid_eq(ctx->cred_uid, ses->cred_uid))
 			return 0;
+		if (ctx->username &&
+		    (!ses->user_name ||
+		     strncmp(ses->user_name, ctx->username,
+			     CIFS_MAX_USERNAME_LEN)))
+			return 0;
 		break;
 	case NTLMv2:
 	case RawNTLMSSP:
-- 
2.53.0

