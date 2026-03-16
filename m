Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADF83A4523
	for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 15:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676150; cv=none; b=FErNZlzBgwiId80mhMySuRZluwdyVmBeCg8rVkcZMZUkSoi27N8mwuTJgfKDfS7mIdgsTU+HCP30tkmz9Bfftc/H04czRM6gpAQ17XKcCzGDURMdOg3eiosW2b3O93gPyRJMrNJzXTRZBf3rMzqiHvo5e9nqnj7vUpubXLlatjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676150; c=relaxed/simple;
	bh=Dh7+4dYkoUTolSxtP0+/CTh6ZhfJ28yseiX8+sYEy5I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I2FoewUTwcn36sVOOrA2b6r79FRk6Rp80v4jUx60vwdKlw687Tihw5Tk5KZUpgvohbBNDaVbAbQYWUiEgG3JuVkTQwSu0IDyed4zggffXhaO2K+fzfk/OAYPlLTmTz7V1ZEQUpbJ1QyCatEWUIFVjsiZmeUZ+pWDdloCziOiDMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eorOX1nP; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eorOX1nP"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so43491585e9.2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 08:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773676146; x=1774280946; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwwDgcyrhQFPGtIVQQIcEl/sTMG9NYkgRg8ru3+yAMU=;
        b=eorOX1nP3PXbhX39A0n+5w+d+NZgUhEIznxjjWXhlRYELYsXL+Q0ufd9fhn8MsLJJK
         YHS565iyt7PsIw7nqxISAu7eZrN2GKIm34AXy+sF1xk3RKeOAr6WVTGgFc/W/XooSNvi
         zvjfecPUsvGRpq1Ni85a+bHqp7sA/uzSGhC+OuxFbFyZaY+CPJYams8KeIFz/LuYh18G
         zP3KHzk7yWnm9h8EdTCEdkBSVbgsMZqx5youUw1+i+f67nz9KzMILEsy7J7nNcp+Lt+Y
         zYqQCn9dxdgt27yOVdc7B4s9slUYFaAr4+JJbH+s78Ql3t0rlbkhBsWwhXgj3BNhLlFN
         JfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773676146; x=1774280946;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lwwDgcyrhQFPGtIVQQIcEl/sTMG9NYkgRg8ru3+yAMU=;
        b=UH7pYGZX/jD4FSeBq3wOb1VX/M6L6abRQG4XMzwiFrIztTEY1NYrNPu+T+FOW0vx1m
         8JQE9h4V50qL6MYShx/xlrbEM8tllAfnSCl6nZoKEgLfBo9AqouKHZdOMzOnfLdfgcck
         NHjPmSdsR8iM/S0wrsC5/CGcSYlFaPpXxVAq85Y14lk11WsUKB9L8/MomnH/tx6ZtLDV
         2DIiaZ+C7zjYrHQ1L3OdW4HYg4GQNu8y4W5goLkCTK0q3K6wwOW1uzvmzC709sg1Ig7g
         qM67P2d1bJd1GqAr/2N4ojUGwONZggtNiFpCYXA4XcW9v6RgFxVBXKYkpapAHeuu8sdJ
         b31Q==
X-Gm-Message-State: AOJu0YxjeFCPBhbktI5u/o+6ZD3h1Ir+XfFoMT7k3fh2Mg3AY+XsG5Tu
	UNP4GdladxKpX5lVnDCQkWZ2KsD8TrmKRftFJ9Twy+XETdaW8VFCO81SM2b3ucJmcnk=
X-Gm-Gg: ATEYQzwpibtN2UhTr+8x8JelY5J1K99fP+/PSd3Z3k1jTJlTarkj4ssivi31QP5LDsR
	YOSwvBKxCgbmfnf0lcpoYUmsXefUw2+0nN3/sICClz39bxs4SEOOrDnvzaIe6jOr6L3C479WrhN
	ozJtKHJ0nSA2xKXmVL+2vi/N6HH5lmZmp88jFOb9KqlLR4CbTA9cJOhjZiT1X7H/ubJXt5sbjCD
	h5zxcQYzNVvqixsz5zr0Ouh+oOrxWFDWgHf8kD5EU6ay17+qyEE4aUhkSOxKZrAbEt/G22ZqRDN
	TVis/9oM1898jkRga/sjcJJqAjUKtdAEdM/a4RnHIIINllNV0lp7xt8tZqeMAjkyI8uU4pcyjuN
	jwJTeWLoHxksq/mDGA2V6ZfW4C2EsHFjMQ/8MU9QXtLP3kNoE3XAg0Rj+lf/gw2xHAozNaxSOLn
	p+6zBQxkQRaQfocNo5EkvM1a08zs0kP5BNVkrrcXdaGifLQybIKwIzDrg=
X-Received: by 2002:a05:600c:8486:b0:485:4136:99a8 with SMTP id 5b1f17b1804b1-48556700ca5mr224691885e9.22.1773676146089;
        Mon, 16 Mar 2026 08:49:06 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128f62b01eesm14212346c88.7.2026.03.16.08.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 08:49:05 -0700 (PDT)
Date: Mon, 16 Mar 2026 12:49:00 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	thorsten.blum@linux.dev, pc@manguebit.org
Subject: stable: [PATCH] smb: client: Don't log plaintext credentials in
 cifs_set_cifscreds
Message-ID: <eijo3pknvy4gl2xh23by7kjdxpoc27an3dqfmfttremp4xb53o@z2kq34l2onvy>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I believe the following commit may have been missed for the relevant
stable branches.

2f37dc436d4e ("smb: client: Don't log plaintext credentials in cifs_set_cifscreds")

Could you please consider backporting it?

Thanks!

-- 
Henrique
SUSE Labs

----- Forwarded message from Thorsten Blum <thorsten.blum@linux.dev> -----

Date: Thu, 26 Feb 2026 22:28:45 +0100
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
  Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>,  Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>,  Jeff Layton <jlayton@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, stable@vger.kernel.org,  Steve
 French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org,  linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: Don't log plaintext credentials in
 cifs_set_cifscreds
Message-ID: <20260226212845.784172-2-thorsten.blum@linux.dev>

When debug logging is enabled, cifs_set_cifscreds() logs the key
payload and exposes the plaintext username and password. Remove the
debug log to avoid exposing credentials.

Fixes: 8a8798a5ff90 ("cifs: fetch credentials out of keyring for non-krb5 auth multiuser mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/client/connect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 33dfe116ca52..038f87062419 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2236,7 +2236,6 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 	/* find first : in payload */
 	payload = upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cifs_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
 		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
 			 upayload->datalen);
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4



----- End forwarded message -----
