Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4306D15A4BF
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086488; cv=pass; b=Qg53xfYOHAn8fdL3iVeGLa1DKwnKI820dGvB7iwdRQo0naLJeQer8K0zKIGWATurLY+94iO3oHu7eh3MASaWG14IM+0H9UF4B4Z0kauS53HMi2tEFvy2Ox+KZgM58keBipnq4D0COVXe/FHByioxesBu0RdltS+3cjQoM30ZMvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086488; c=relaxed/simple;
	bh=9qJo1LLk4mGoQrQ3TOyFfTBbhVaiIbb6fOpvWiLxjBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaVynDXWVMdUYlpNe8Y7A+6OclZZSLQ0xUzvKUEqjeurRUAXXCxCmNH5lgonP4h0k74QgdP7rGCR2kvDQnBH3OPzX2XrpsaJOAb9ecnDsTm2/YChWzCOnqllSslayQYNMllb20Y42k200G+asROuNcCrctgpzzBLFBIEt7tTqoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=onKvuxxb; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="onKvuxxb"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TDIF5pz8B3+b93ew4STkJnG2r5i2svhd2mrslzBBC7g=;
	b=onKvuxxbG/ZQim2ScGm3DELnL/sdd7XYe7U5Rt9CIG3/K2qyG4y5w81msJ3Y5vPv+zY0eb
	9MOXu9Qox948tZjp8+3QotAN7pV1dVGXo55euBr7BkEEbkMR8hUrldjuRMQxo8/73hb5GV
	g7EzhpQgINYrjP+0cN9OCPejIypUE1m1IYnLOcx2L0HcBNHRcVTC/7V2NsIkY9he61+tVJ
	1eUM6+W2gFjAeLOscF5saQnnKtFve/VFUOA69BCrb0nn31KMmTmLfNmxodpWyzIlO4nTC2
	M79ipletkLqfEKj+r0oBLhYeIrPYxpC6oYzCOVXGUPh2/hETTTzzgt/TCp1yGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086485; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TDIF5pz8B3+b93ew4STkJnG2r5i2svhd2mrslzBBC7g=;
	b=rIS0BlnwHAp83v7tTyaPgOGPhf4BGmzqCvqDEKHCT0hv6OsMb19LbqfdSF/q9JjsQx6Q63
	mXA4M//dcdlltKp2Arwi/GNvGvvrmY3uXxgIWeJPiSvfUg6PrV2njI+x/zah0bh/OslvjE
	ybkr2jfR+XmzKqUmX346RgTWtP5yb2bIR1J1chRA4KM5MB6IMAy5WleJzpkreDawxNfZrJ
	xsvhFPapZwbh0njZP4i0kT+mboexnNJCQFGbmpA6Xfpn2cnL881H3c/lE0O9Dvg7WqDC2+
	FpLRfgN4lM5W4zFP/b0oHhviDq+jl1ASYmHk31ah8nIMIwrIymV9juK4f7i18w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086485; a=rsa-sha256;
	cv=none;
	b=hJ43ClbbrOJYhmHp17QJkQmHfx6BVn19yE8qeVVZsRRIPlI5qQicHpp5x9VOqSlUAWyVp+
	cfaSmJOYgNuiztFXj4RWe7R8AtWBQmKfXN+Jr+9xOq59lXa/aBpg1UoQc2NpIV8JDdNA1n
	3RRFyVJYgAmKlV+bnml+ilNCAddD1SHVnOViTggi/56NKklKrWtGHJkqy7Q8EQHX3H3MbE
	egmQfB00Ju3QF1sGK/el3qzUjjFaDUozu4v1Ktf3c/dJv4ZUaW/X2MPVIMBm5rw8T34ZV9
	HbVoZqnOtvmyMmaHHo9S0HUIQdgaSnAjOgOo/0R5pHo2zgtYHSzsNGbSzCVplQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 04/12] smb: client: fix potential UAF in cifs_stats_proc_show()
Date: Tue,  2 Apr 2024 16:33:56 -0300
Message-ID: <20240402193404.236159-4-pc@manguebit.com>
In-Reply-To: <20240402193404.236159-1-pc@manguebit.com>
References: <20240402193404.236159-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifs_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 8535c9907462..c71ae5c04306 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -759,6 +759,8 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 			}
 #endif /* STATS2 */
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				i++;
 				seq_printf(m, "\n%d) %s", i, tcon->tree_name);
-- 
2.44.0

