Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0401628A3FA
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 23:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754005622; cv=none; b=DxjnL/KkNKt4tt+4hSVoe+2CNxzmkx9n2+5USzFIEzTPWWcOv5yArdgleZZc5gw4af54uJBheHF2dql2DuaKe3tKrDIR8kbV3pSvVz5Tu3UJP7fj8T3jnHmTWHVIHot86FsG8iDvuyCIYKbmqXTPprk4+P7t86uCGy0PMQ/FPBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754005622; c=relaxed/simple;
	bh=J+7zy58E7GCjjRhWj8vrVxOFOKucyiBhjp/GW/m4bhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsdTfwgUenBRc3E2CzhdbLMv2f+Rq5pkaRN0P07gWAq/BNZHn1vK7FUhidpBxlEyGO3LboURoDFDSCt/82M+ZqHSsN44TvTiqtEiZy37uhb+wRMt4vnZB9RF+9ysu/QtYrj3zv/3UrCfrTXYwCjp16HVpv8daIURxgO6nTwhbNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=8IM3Jtf9; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="8IM3Jtf9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=xps/pYD6CyJpPVvNeBMYuONo4Em3OCOezpap+GWrfwE=; b=8IM3Jtf9GB6iaesCDERGm0scA4
	jrLpa+GFX7+wOm5KBxt6Mjv4GUtLKi+pmD3zafTEdZDnlD3R/OOSjHdItCWE4FQpdcaw8E0StRP7G
	99wPOUwMEOQTSzrOlDHJb7tt+lB3ueajxEgb6PRTZEtw8VY0OEvfFYD+GBT40BbhrHtcq5iLxEyRP
	QvQarnrAFILfUWR3kjgznmGc6+Ws+W2FQ7LnKiqMyegEuCGHPrqzNfk5NHfkiLgUspbiA2Z6eAnij
	MP+tOQBC+tUO0z09HCFcOJbSBRdu+z7a0tThDlTUyuI2B0yL6ExMa9krne9Pf1Sl89amVWJD2KgL6
	P8v15dWw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uhczD-00000000Abk-04oH;
	Thu, 31 Jul 2025 20:46:59 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Ralph Boehme <slow@samba.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Richardson <m.richardson@ed.ac.uk>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>
Subject: [PATCH 2/3] smb: client: default to nonativesocket under POSIX mounts
Date: Thu, 31 Jul 2025 20:46:42 -0300
Message-ID: <20250731234643.787785-2-pc@manguebit.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250731234643.787785-1-pc@manguebit.org>
References: <20250731234643.787785-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB3.1.1 POSIX mounts require sockets to be created with NFS reparse
points.

Cc: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>
Cc: David Howells <dhowells@redhat.com>
Reported-by: Matthew Richardson <m.richardson@ed.ac.uk>
Closes: https://marc.info/?i=1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/fs_context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index cc8bd79ebca9..312f5a0592ae 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1652,6 +1652,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 				pr_warn_once("conflicting posix mount options specified\n");
 			ctx->linux_ext = 1;
 			ctx->no_linux_ext = 0;
+			ctx->nonativesocket = 1;
 		}
 		break;
 	case Opt_nocase:
-- 
2.50.1

