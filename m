Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF5711CA1
	for <linux-cifs@vger.kernel.org>; Thu, 20 Jun 2024 04:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718859081; cv=none; b=Q8sKdopvOF1L309wp2zyPHeh3/3/Y5Yi/dpK70QN2wQdDFfloDXkNJmlDBiSlGBwb8PsJX3rxsDTyqEy7JpfRRG8KBwxUXeU+sHcWHAT0cBaGQ96zWic8V/4IoSyInyQftOmaxX03N1c9rSAFO8RvM1dq+MYM9bBM+YGY7ey5WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718859081; c=relaxed/simple;
	bh=WS3XRwDE1ITjDQJ1IwRWI3+f04DYdHkSZtrVfaIWFDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hniv7a1TbXTMfMRGhUHidnIxwpswZPb5R0gtz5DBqF37L6ap/c3Yehdmc7yRtgvIHJYaaNqsv7p4siOSl1fPsoLWvoJmJdtDgl3dLsYvA3KAtdAGpZnKFM3+xDMUOZOJJt8CVyAW6zXwwe1CtITWoSel3kkLSPtLikAoNMDZVuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=vhNnUcqO; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=F1yzK+B9; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="vhNnUcqO";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="F1yzK+B9"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1718858595; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=JAH6JTRhmvd7953RmZL9pLBCVZQTISdDE7398jOxamk=;
 b=vhNnUcqOvsavB6BNDpVrHJTJrCodiaRltEXSjkSGWBlQ87b2J4s44s9VrWY9/7CFGgqow
 ioveJqfIU4YGWvMDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1718858595; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=JAH6JTRhmvd7953RmZL9pLBCVZQTISdDE7398jOxamk=;
 b=F1yzK+B9lzYPVq0n/+IbL797AmMbxY6c7k5HczlG+QmwHyoWczFJIhWl8jLtUsONRQZys
 Eg34dJcNEve4v/S6ZD0rYpPB7/tKoV4E1GfVAsWc7Cg7NC8K3VGAiW2lPbn/JnA9MPqwb2m
 sUG047pUycJhdSHalr75NrG9TtL9dbxwI6P1u0yxDjza+QmVs1cpPAxkmeEyE5K9t9+faYs
 x+u4ga5pVf3beZMfT0WN6fyQrZ4m3xzyd6cW10DtKkfyDdppaQtXkU4hknTKlYBbFGRIl21
 6l00yXl3UYhAwN6/Kwupj/RufZjXVAcjy6wVFTxWJ9eZYCU+nAcs741/Iq6A==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id 4C256813C;
	Wed, 19 Jun 2024 21:43:15 -0700 (PDT)
Received: by vaarsuvius.home.arpa (Postfix, from userid 1000)
	id 7C1578C10A7; Wed, 19 Jun 2024 21:43:14 -0700 (PDT)
Date: Wed, 19 Jun 2024 21:43:14 -0700
From: Paul Aurich <paul@darkrain42.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH][SMB client] fix typo in description of enable_gcm_256
 module load parameter
Message-ID: <ZnOzYjAhF4QOKMwA@vaarsuvius.home.arpa>
Mail-Followup-To: Steve French <smfrench@gmail.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
References: <CAH2r5mviMs7VW5ofa0hZiVkx6RdH-LcnpYYDhyGOxnXxtB=t=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mviMs7VW5ofa0hZiVkx6RdH-LcnpYYDhyGOxnXxtB=t=A@mail.gmail.com>

'0' is probably also a typo.

On 2024-06-19 15:02:16 -0500, Steve French wrote:
>enable_gcm_256 (which allows the server to require the strongest
>encryption) is enabled by default (in the 5.13 kernel and later), but
>the modinfo description
>incorrectly showed it disabled by default. Fix the typo.
>
>Cc: stable@vger.kernel.org
>Fixes: fee742b50289 ("smb3.1.1: enable negotiating stronger encryption
>by default")
>Signed-off-by: Steve French <stfrench@microsoft.com>
>---
> fs/smb/client/cifsfs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
>index bb86fc0641d8..6397fdefd876 100644
>--- a/fs/smb/client/cifsfs.c
>+++ b/fs/smb/client/cifsfs.c
>@@ -134,7 +134,7 @@ module_param(enable_oplocks, bool, 0644);
> MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
>
> module_param(enable_gcm_256, bool, 0644);
>-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256
>bit) GCM encryption. Default: n/N/0");
>+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256
>bit) GCM encryption. Default: y/Y/0");

"y/Y/1"

> module_param(require_gcm_256, bool, 0644);
> MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM
>encryption. Default: n/N/0");
>
>-- 
>Thanks,
>
>Steve

>From c37640c69574b424e687c4e3fac15c8c2a9343d5 Mon Sep 17 00:00:00 2001
>From: Steve French <stfrench@microsoft.com>
>Date: Wed, 19 Jun 2024 14:46:48 -0500
>Subject: [PATCH] cifs: fix typos in module parameter enable_gcm_256
>
>enable_gcm_256 (which allows the server to require the strongest
>encryption) is enabled by default, but the modinfo description
>incorrectly showed it disabled by default. Fix the typo.
>
>Cc: stable@vger.kernel.org
>Fixes: fee742b50289 ("smb3.1.1: enable negotiating stronger encryption by default")
>Signed-off-by: Steve French <stfrench@microsoft.com>
>---
> fs/smb/client/cifsfs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
>index bb86fc0641d8..6397fdefd876 100644
>--- a/fs/smb/client/cifsfs.c
>+++ b/fs/smb/client/cifsfs.c
>@@ -134,7 +134,7 @@ module_param(enable_oplocks, bool, 0644);
> MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
> 
> module_param(enable_gcm_256, bool, 0644);
>-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: n/N/0");
>+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/0");
> 
> module_param(require_gcm_256, bool, 0644);
> MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");
>-- 
>2.43.0
>

