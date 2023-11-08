Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179373033C
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 15:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="RpKnnDVI"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D291BF7
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 07:24:21 -0800 (PST)
Message-ID: <c7eef14c50dc56ce00bc202e6c2f99ca.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699457059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=usNr8UPuWEMHfAhe0jKYMJnVy2/JmGLdgx0enPZglNI=;
	b=RpKnnDVIp7ppg8Og7eg9eZBkZvIvpfPGRjv4qAVywRrpeaQCSpFOczM1+liSC6S+UXij+S
	O9YFLo3QjmbRCRYlxJVkUIfMkEUUpwQnGLEXtxp4zDcI5Xs3uTj86JuO+Bj8r6yFxpQrir
	C4v1B5HznvN+jO4btSWfEseZpZMWYu9b4++xZAYRjbCFJuI2MNCT3VFTQ5LHKZedh0jmpg
	j5cNEzTiHCPJ7f8jMrToxxGJraEKP2BomFCSg5m2ahwgfbZuuE/RGssS1TFzvYwKUquiq/
	em+oGryUPTj0J4cZCL3ULbNM9BVCR1FPH0dntqMM7IrS0ou+FqR+K9ZYqIV9ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699457059; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=usNr8UPuWEMHfAhe0jKYMJnVy2/JmGLdgx0enPZglNI=;
	b=QUxQO8zi3PqhAyWf9dzeWdBfbc4GOTu8MV7EvaFM4LQ9T6sOHVVnMuWUtpSF0YSovYdiSf
	BGQyzF5NFAEyHJ7uw5vW1j86F56vzHkE14dV2JZHZbMr0IOKVJiz34/nF3IdGhsqQQpiED
	EfjoDkiUu+6DcenPNO+EOoJcw78dLjWzrVl+UmYtWs+izhklLTreyydlUorliJ1CbJScfg
	R0LEfOSSA0IwHvroGfww7xqkLasADwDBqA9isG+NVkdNhXKy5jUI2gmz3O+sJsPjcjoZAg
	pdnhFrLZSPY427yBABqF2wDJKZL4kzELPtrGTeoKz4sqQWcV0EEP026HzwcpIQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699457059; a=rsa-sha256;
	cv=none;
	b=qjfQ/UWbG0tRlUITrESwS+f0uGl6Y3A+5P/Rp8S4VTO4+/9AmwPlf/f97mQsjssCL0Jq1/
	oF9d4Q2ouHrZTlph/16EH6YYAN21tzElAwBUrOQ2RMvd3YemhhzUIzp/6cbXx4KTRVBdna
	/nqCXYh7vrDWtLRoyrLOvhXv6dSQt8EDyX62QYb2yJCeHakktVfneSYOr/AknFQMdur6Ep
	lrHHLMO8KlaXLGurT2XlX85YKz5auLKngBKVdwhfxC+oAVCcnZUXteIKX7J/Z3IBCZQvnR
	9iWDzgb1a82TVwUV/NkFF3pA3iuhfL3un70gnfeK1K+YqMQyeeSLTD9Rli+Flg==
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org,
 Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 09/14] cifs: add a back pointer to cifs_sb from tcon
In-Reply-To: <CANT5p=qhjFzZJMC8i9Qt6zHomZvCCRdNiQ0koFTdQirO6GBgHQ@mail.gmail.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-9-sprasad@microsoft.com>
 <ffa541bac7417c9dea79c73e22de1eda.pc@manguebit.com>
 <CANT5p=ph84SkoXf-2q7oa1nQdfjw4q7jzzWOtU-mWMtg2=TxnA@mail.gmail.com>
 <CANT5p=qhjFzZJMC8i9Qt6zHomZvCCRdNiQ0koFTdQirO6GBgHQ@mail.gmail.com>
Date: Wed, 08 Nov 2023 12:24:16 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Shyam Prasad N <nspmangalore@gmail.com> writes:

> Here's the replacement patch for "cifs: add a back pointer to cifs_sb from tcon"

Looks good,

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
