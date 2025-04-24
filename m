Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D8E18BBB0
	for <linux-cifs@vger.kernel.org>; Thu, 24 Apr 2025 15:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745507101; cv=none; b=aX3vfFmp/uOQqNBEFOeM1p8uIAQ1zoptrZwOFiLJKgtC/M6W/wJAaqynl9JzkeWYlgyG2+w3WCSJ4/jgUc2n4+JgefYHFKc0BB97qHP5Hb4WqXWZng1xd4qaj2Oa/fOO6IR/CaFF06dwyMrOZuvRgZdyq4kUFdSvLCux7jd35gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745507101; c=relaxed/simple;
	bh=/exFxDk8UUCPx5iCgfXBWGQN5ob8iA+WNf5MlrDS2nI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ReXzYT18gKUq6IHPiQhtm18dhAzNKpGm2Zwmpm4nsTyQ9wbqK+w1eHegszOqBfneqqpET0GZkw3th7VJoi1EhaWW7j9q1w0n3+OxMkor9Ilz8du3vhQBWH5Em6I0kTSOaVBNM00hW4iYwYr/xHQuukpCzZjc7rrsC3QlNl5Xef8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gsMtucg0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gsMtucg0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QdaEnh440KuOkVWxvPUuQOVVV+9fv0zxTqjxWn5kwvQ=; b=gsMtucg0UdXLYJITh+f+UwcKaY
	iP8/PiVTqIOuw1qkv9Ckxvp19palSKP5dE9tU96DRtvI5hHLRHbIvxah6iY0d8xtGkQLIPX3o/w1p
	xXYOsfpuM/YLeu+VzibuNQ2pa+bX5+P91wLmLMsxdOJQ+DoBxYEd98cdX/YFty84gZkufyJBDwvip
	jswKiyrXzhvoaNmEeHnzezYlgl+gJmnBBIJxh5cYbeDym+pepErH1z6q2js2m3T4dRRYsc5jvizSr
	a45FYuoYHZY4+/Wxr2+JZVP1r9rayIDY0WUjERZRLFH1ubl8TCoYA0F5v7EUQSMSy5lgPipsrWd9H
	rk1zNy1g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7y8E-000jeg-1Z;
	Thu, 24 Apr 2025 23:04:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 23:04:54 +0800
Date: Thu, 24 Apr 2025 23:04:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: cifs: Do not include crypto/internal header files
Message-ID: <aApTFgDKVzgS_HFZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Any files under crypto/internal should not be included by users
outside of the Crypto API.

Remove crypto/internal/hash.h from cifsglob.h and add crypto/hash.h
to the files where the hash API is actually used.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index e69968e88fe7..dd143f6e629b 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -24,6 +24,7 @@
 #include <linux/iov_iter.h>
 #include "../common/arc4.h"
 #include <crypto/aead.h>
+#include <crypto/hash.h>
 
 static size_t cifs_shash_step(void *iter_base, size_t progress, size_t len,
 			      void *priv, void *priv2)
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 07c4688ec4c9..167a42f190c5 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -22,7 +22,6 @@
 #include <linux/netfs.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
-#include <crypto/internal/hash.h>
 #include <uapi/linux/cifs/cifs_mount.h>
 #include "../common/smb2pdu.h"
 #include "smb2pdu.h"
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 769752ad2c5c..e13671869e0c 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -5,6 +5,7 @@
  *   Author(s): Steve French (sfrench@us.ibm.com)
  *
  */
+#include <crypto/hash.h>
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 7b6ed9b23e71..b283ed0f46e2 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -6,6 +6,7 @@
  *
  */
 
+#include <crypto/hash.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/mempool.h>
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index cddf273c14ae..caf06548657d 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -7,6 +7,7 @@
  *              Pavel Shilovsky (pshilovsky@samba.org) 2012
  *
  */
+#include <crypto/hash.h>
 #include <linux/ctype.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 475b36c27f65..304370befcd4 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -19,6 +19,7 @@
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
+#include <crypto/hash.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
