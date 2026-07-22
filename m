Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6FF331EB2;
	Wed, 22 Jul 2026 21:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784755755; cv=none; b=m1KXLYaJEE3KmYdkMTzW2r68zRaNI+mUkQPwVD+tm4rVHtXIPNmzUSwnpS96tXiaYyUg7aIvmoGwB1H0zEZUDT5u3DpjqPmYn2qLIRM+JSTl1OYMxb6IyGGzf9VFMkcs2TngzVwIPJ778iqlkNwO2BJndHNAsVGg7gFnAkxSSk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784755755; c=relaxed/simple;
	bh=8JKIuen/wwgNcSfpOnSr7awX4oln7E8PBxxBAqQ5TJw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lORvmhhWM589mDg4VusYU8KVMDMbYpBC+9FvjKWHUerLeeBIBrOw0maA42OW1nunVK6G7hOQkZWPieu9sbDNJcZjfZcWWj1YSmn38qkoOPWxOIrA0algB8MNqEeo5MiMKoJ/KGXv+rj9eUlhcNQX5tRVAy0+XDwIu0Qe1w607WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=dV1++DTY; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="dV1++DTY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Cc:To:Message-Id:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Subject:Date:From:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=H+Gq4g/t9EIYA0uAB92taJMYQ1ksEreDOqexcLNDj8s=; b=dV1++DTYT1mRCJ8UruU9v02IWb
	ska4L6dVd8if/cJ3ByZsRqkFqeZmRDeQ+0UNiHbUqohkkMoLBzBgYIzgnk2J3yFp8XTjyusAFCR69
	KxRJc7TU/yZRoQGkWvZzTz96nNr1dBmY4VEMrqoW22uckPf29jkcfqNMzD2MQ0IK575GovRXBHVKQ
	Dka2aZBuEZCpPDOvoNrFxltYXizakFhy5Ujwr1SUahKYda5PQfQjgCo4hSpgbcjRzevEdZbSSaLTa
	IuVreEdeAS8DqKrm0hsh90bfdVp740kOTanhQRwMNGdXE0HHlr0juq9Eme/eVW/p4VChdGWr7tzPf
	C4Rk0hlw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.2)
	id 1wmeUx-00000003qHp-1ds1;
	Wed, 22 Jul 2026 18:29:03 -0300
From: Paulo Alcantara <pc@manguebit.org>
Date: Wed, 22 Jul 2026 18:28:37 -0300
Subject: [PATCH net-next] net: dns_resolver: allow shorter names in
 dns_query()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-net-dns_resolver-v1-1-c3385898ccf9@manguebit.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM0QqCQBBFf0XmuQV3yQ36lYiw9WoTMcbMKoL47
 635eLj3nJUMyjC6VispZjYepYA/VZRerQxw3BWmUIdYX0Jwguw6sYfCxs8MdbGJ575Ban3yVLS
 voufln7zR/hYsme7HYtPzjZT3Im3bD6EZlK1+AAAA
X-Change-ID: 20260722-net-dns_resolver-6564f5eca1c1
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: David Howells <dhowells@redhat.com>, 
 Frank Sorenson <sorenson@redhat.com>, netdev@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Pierguido Lambri <plambri@redhat.com>, 
 Paulo Alcantara <pc@manguebit.org>
X-Mailer: b4 0.16-dev-659f5

Customer reported a problem with mounting CIFS shares where the server
hostname was 2 chars long.  Turned out that the CIFS client wasn't
able to resolve NetBIOS names shorter than 3 chars.

Fix this by allowing a minimum of one character per hostname in
dns_query().

Reproducer with samba server:

  # 'ab' and 'srv' hotnames resolve to same ip address
  $ ssh srv ln -s 'msdfs:\\ab\\share' /home/shares/dfs/link1
  $ mount.cifs //srv/dfs/link1 /mnt -o ... [EINVAL]

Reported-by: Pierguido Lambri <plambri@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
---
 net/dns_resolver/dns_query.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index 14bee83cbe22..b8fb9a1245bf 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -72,7 +72,7 @@ int dns_query(struct net *net,
 	kenter("%s,%*.*s,%zu,%s",
 	       type, (int)namelen, (int)namelen, name, namelen, options);
 
-	if (!name || namelen < 3 || namelen > 255)
+	if (!name || namelen < 1 || namelen > 255)
 		return -EINVAL;
 	if (type && *type == '\0')
 		return -EINVAL;



