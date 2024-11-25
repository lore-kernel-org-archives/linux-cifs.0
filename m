Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9020318DF8D;
	Mon, 25 Nov 2024 08:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732524856; cv=none; b=O8KSCWPcxEWo79SWi0irccDfhinSncNxvx6dljUCcsolE3BAA2fdfO1yaWETnXAdyild+jhM4aK+QYSnkiShcWOs/wfKK+dJJk+tGD/p6vrqcscUEGuHuy/gcVI4O5S3gFNZ9d+LYxf6a0q11mjdJv+swUgrhmg7oGsusBQN0WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732524856; c=relaxed/simple;
	bh=xV69ApqQ+gYiW0Cq34RkQgROnh9IshIjsivHhrCYb3k=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rFaDroLU5OFFW6OayIfG3yl3b71e4kLfSQcQhr4J9EygQwI6jVVJxYM/3Ei9J+sDj6xoCu+eVnP1AD/gnPeBvuq2TRiB4eWaDDuX39kUajHKXTECfAIv0eKwVwvzOCUcyv1xNiXZcn1S4g/7cAPN1djOPlM7GltEWVLbu8GbpOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=pL+t1BZD; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="pL+t1BZD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732524855; x=1764060855;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=xV69ApqQ+gYiW0Cq34RkQgROnh9IshIjsivHhrCYb3k=;
  b=pL+t1BZDZz1pCqHucEgW0ZJDJ24QxGo6ATQ/sUaGanHdidnX0AtrInZ7
   lCz8eI1JuX7x9bhgR+VbeLLcH5qhVTL+J2wzpIEWETZOw72uxK3yqhvee
   Us/cBIAc6Rcryfp7pcqyAh/zHg83mkijstKXjOqu0DsDlKFoxMbxgrIci
   I=;
X-IronPort-AV: E=Sophos;i="6.12,182,1728950400"; 
   d="scan'208";a="698010430"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 08:54:10 +0000
Received: from EX19MTAUEC002.ant.amazon.com [10.0.29.78:20039]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.19.131:2525] with esmtp (Farcaster)
 id 61843e51-cbcc-43eb-9f46-8bb6a50bf74a; Mon, 25 Nov 2024 08:54:09 +0000 (UTC)
X-Farcaster-Flow-ID: 61843e51-cbcc-43eb-9f46-8bb6a50bf74a
Received: from EX19EXOUEC002.ant.amazon.com (10.252.135.179) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 25 Nov 2024 08:54:06 +0000
Received: from EX19MTAUEA001.ant.amazon.com (10.252.134.203) by
 EX19EXOUEC002.ant.amazon.com (10.252.135.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 25 Nov 2024 08:54:03 +0000
Received: from email-imr-corp-prod-pdx-all-2b-a57195ef.us-west-2.amazon.com
 (10.124.125.2) by mail-relay.amazon.com (10.252.134.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 25 Nov 2024 08:54:03 +0000
Received: from dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com [10.15.1.225])
	by email-imr-corp-prod-pdx-all-2b-a57195ef.us-west-2.amazon.com (Postfix) with ESMTP id 47F0BA0676;
	Mon, 25 Nov 2024 08:54:03 +0000 (UTC)
Received: by dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (Postfix, from userid 23907357)
	id D1E5E1E9C; Mon, 25 Nov 2024 09:54:02 +0100 (CET)
From: Mahmoud Adam <mngyadam@amazon.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
CC: <gregkh@linuxfoundation.org>, <stfrench@microsoft.com>,
	<stable@vger.kernel.org>, <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: Fix buffer overflow when parsing NFS reparse points
In-Reply-To: <20241123122050.23euwjcjsuqwiodx@pali> ("Pali =?utf-8?Q?Roh?=
 =?utf-8?Q?=C3=A1r=22's?= message of
	"Sat, 23 Nov 2024 13:20:50 +0100")
References: <20241122134410.124563-1-mngyadam@amazon.com>
	<20241123122050.23euwjcjsuqwiodx@pali>
Date: Mon, 25 Nov 2024 09:54:02 +0100
Message-ID: <lrkyqmshny9qt.fsf@dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Friday 22 November 2024 14:44:10 Mahmoud Adam wrote:
>> From: Pali Roh=C3=A1r <pali@kernel.org>
>>=20
>> upstream e2a8910af01653c1c268984855629d71fb81f404 commit.
>>=20
>> ReparseDataLength is sum of the InodeType size and DataBuffer size.
>> So to get DataBuffer size it is needed to subtract InodeType's size from
>> ReparseDataLength.
>>=20
>> Function cifs_strndup_from_utf16() is currentlly accessing buf->DataBuff=
er
>> at position after the end of the buffer because it does not subtract
>> InodeType size from the length. Fix this problem and correctly subtract
>> variable len.
>>=20
>> Member InodeType is present only when reparse buffer is large enough. Ch=
eck
>> for ReparseDataLength before accessing InodeType to prevent another inva=
lid
>> memory access.
>>=20
>> Major and minor rdev values are present also only when reparse buffer is
>> large enough. Check for reparse buffer size before calling reparse_mkdev=
().
>>=20
>> Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse po=
ints")
>> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
>> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
>> Signed-off-by: Steve French <stfrench@microsoft.com>
>> [use variable name symlink_buf, the other buf->InodeType accesses are
>> not used in current version so skip]
>> Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
>> ---
>> This fixes CVE-2024-49996, and applies cleanly on 5.4->6.1, 6.6 and
>> later already has the fix.
>
> Interesting... I have not know that there is CVE number for this issue.
> Have you asked for assigning CVE number? Or was it there before?
>
Nope, It was assigned a CVE here:
 https://lore.kernel.org/all/2024102138-CVE-2024-49996-0d29@gregkh/

-MNAdam
