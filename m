Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DAE3BB126
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 08:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168395; cv=none; b=GmM01Fvwzz+e5bY0ytl9j0ufPeihhJXvy5CnP05aojTAEaXReR7mktSUzkF8J2E6ANMO4MlRhbiVn7HNIKsp7xgemNmm6R2RamWDO0fU29A0WjUx8ff0mmjSIsQwYGjlGcWZ58E5KmizF6l10CBTexdmTsD1iGwsJxzv4fLpz6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168395; c=relaxed/simple;
	bh=QgmccsK5dccfuLVpxKECy02Cyq4fJw4GPvf8VwxeAUE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Xz5HcYaeCjmI0P5SSUAM+lHOeeTqET+Tw9zAnBt81mDexCoPw/w5NZCGIGMFBgRoeXa4s9aH9gGIVJll47KG6Xwg2u8lDNoCChxphjyK3jfzSUrH1EWptkka+Jp8sOOpjveY09ZW09RNXTzf6RbcGxvYjSqIbk8NDY78c0KapUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kQB2UwI/; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kQB2UwI/"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ce9df31840so59256576d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 01:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781168393; x=1781773193; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SDvuiII1LGFXTJ1G7CEro7BK7MfvK9SQkUAqzNSYDJU=;
        b=kQB2UwI/TU51v2bvMzTGySkGg8hGMVg/4zYf+LVdTIWnK5ntIFSjDxFVvMpYt4OLUI
         Jvcmq2kNGkDYFavHIK68p86IZMQyveDi9nmbig4OLnvo7ZJgud4k2lRxd+JaWcbJ1PV5
         +IelYTNu93jUT3KsUjSSccSG6UaKGKWnTjQaw90CO3ZUAuKskbUWe+HrNOmKRkl5RHhF
         00Q7+IgzQYAATmssnJLE9WW3SZqsvY5NlUj5J1u41O/8uMG8vxUmOV9QQl1DFHLFSMLs
         r11n08qlrcFDHIO6f+P+Kj7sYdXVEmtXHcBVS+b3h/O71emqHJBleX5fm+Hc64mEtEOj
         9JvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781168393; x=1781773193;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SDvuiII1LGFXTJ1G7CEro7BK7MfvK9SQkUAqzNSYDJU=;
        b=Umlq+pdU8e4S9WFiqcWceYJQuWXZF5UIm0xWbIowK/VlrkL6xCxd3I8jMLCzTFsd9y
         D2JPmDi/NDPBFCFLCqtFiB3WndRxaA8VfJqvy4ecvAOjhDsd+PE9jM/jST7pur0+sIE0
         Xi89LoOqA926SnR2gyulzsPzlpxmjkSblqI68lYkPA3HdVhtWJzEwIkW5UGj/66Y72/8
         3c5cQCUhj3etSez0gzX3T+quR1qjnFxxDjPQIqtVqG9sBcaKcsP1JvNSaVdbVELvIHuW
         d0XAMNrG+iidHIsJVMqFTqiT0D/pHVcracurzDdLPBy5xpQu+XNeUg6ds6iRKSr77Uf6
         Zu0w==
X-Forwarded-Encrypted: i=1; AFNElJ8r6P+cFkZQOyv3gVHZ7TFUIya3RcvwhqqJptemEwptn5BiLXAB246o131fSU4KhPOGdPKXLtEVeRII@vger.kernel.org
X-Gm-Message-State: AOJu0YwGLEaeWKNCMWrGcabV5OdSFGEAixK7YvFedR8SPZZBfDWrxw17
	IxDOXRnyIxAGBBP2SDhl6u4oriSREkEjHZxE4XyxPTsjiX/wxNsEtriW
X-Gm-Gg: Acq92OHnbGENuXBfpQONOBJw+sOwAAbmE6h3sgKMxIeaHRkAXshvrArW60AEB7ExM8d
	wO3XbBTU1GgjrK/fK4CONOddSXZRPdnN0tF7QNI8yLgjLARoaCW7riSOm4U/WAprIN29gP3rXOJ
	AmWUs3BRemUcwvC5Okg7bW0I/I6T6w0OJtIQ8z8oeENxJ8vaql91A0lZ90F80WLRVpkGTTzXiB0
	LpEnDQWgPktBXkCCfJDfbWqTe6e+lBr3UNsfUMxRnSAjsxani1T9IDb+R0aItczsp5f/RKR5CD5
	/iIyYS8czYnnyP2iiPp3cfAAf8HBLqGOJ79ZstEcf8ntNwQJLqTZZxCVY6d5ccoZJA6S6fEkZ7p
	QLqDcSFBAZPd+4yFpKMNqXa8A7Yw7NNtoJHC+amC2T/EYgiPNK3UkiTAPJk3U71kcVcNuZpA5Eu
	LhogKEmbi9DcXPQpMYxtv2OXjq1EY=
X-Received: by 2002:a05:6214:434a:b0:8ce:d77e:e5f with SMTP id 6a1803df08f44-8d1dac289e1mr31795746d6.36.1781168392876;
        Thu, 11 Jun 2026 01:59:52 -0700 (PDT)
Received: from localhost ([149.40.50.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d1e819f58fsm12553176d6.11.2026.06.11.01.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 01:59:51 -0700 (PDT)
Date: Thu, 11 Jun 2026 10:35:28 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] smb/client: Fix error code in smb2_aead_req_alloc()
Message-ID: <aiplQF3QGXmXAEk2@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "*num_sgs" variable is a u32 so "ERR_PTR(*num_sgs)" doesn't work.
We would have to do something similar to the previous line where it's
cast to int and then long.  However, it's simpler to store the return in
an int ret variable.

This bug would eventually result in a crash when dereference the invalid
error pointer.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Cc: stable@kernel.org
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 fs/smb/client/smb2ops.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a3257815e661..a8f8feeeccb5 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4359,11 +4359,13 @@ static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst
 	unsigned int req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
 	unsigned int iv_size = crypto_aead_ivsize(tfm);
 	unsigned int len;
+	int ret;
 	u8 *p;
 
-	*num_sgs = cifs_get_num_sgs(rqst, num_rqst, sig);
-	if (IS_ERR_VALUE((long)(int)*num_sgs))
-		return ERR_PTR(*num_sgs);
+	ret = cifs_get_num_sgs(rqst, num_rqst, sig);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	*num_sgs = ret;
 
 	len = iv_size;
 	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
-- 
2.53.0

