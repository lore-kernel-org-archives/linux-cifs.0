Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC613A0B39
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778624999; cv=none; b=qdmE5wTNMVALpXB2cQZZHobk4HveXR3P6I9N5+OI1qzWU7pMHBSnR02bccJnOm8UHL2NUSoqp9Jt9VpAFCu6OdM6bdg7eAOx0TRMRNOOxtHQkjhVLRZ4udd4vUWgbcjVLKoHH6PBVrnQYfB6RryebSLBQhI372kXtna8xRDyPG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778624999; c=relaxed/simple;
	bh=Kad4F7fLkwjbD6FqM7idZtYX36lLU8I870BzsHUT58o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=KXfS6YHD0SOIEf98xHiLTaLmDB15rvktrT8LiiEQoRCN2dJ3tWRXzBocvQIyXxHJTF1++Y2Iaah1bAmTSZUZuYPkymniiRpZNsMjMIuTG6S1KVPrrvFmUSbo1BWYyIUfe85oUVcJ5CaO9VBl+KBS7mUTFJvxlhMkFr887LLqu6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=EiCRgEod; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="EiCRgEod"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1778624998; x=1810160998;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IlfMsVakpqeFY9uvbIlRYi3hyNhCQXnUG+fluKP/kAw=;
  b=EiCRgEod7KLIVOfRSahI0QqqSTBqdnDaaiHHArHRpHnaZ2VzhwMQYlkx
   w6ZMz0pltY2QpfgW99lYuUmQJOnwFy6A3eviZRkbc/GypaJqKDg7M5SWM
   oLEWpxip7K0UWW2ctUCYvi8rTnQlzNyctx2uLHvuRUzTWrqgQTqaqqPTp
   9vY/LflpQS90+UvXF0xAH4qLuFca4pqlU6qLZwwChTLprMGv5sugfThZw
   TyN9yX6iID7hVtHmvLYtE/Ho1MMERHX+j3ObsJeWwf6rBdlyzF0Zz0RH7
   ySMMLMwPr9NAzoK/ktzZO95uHjoVb3q/wU32JgIJ2LHnX3d7tsDuW8wZ9
   Q==;
X-CSE-ConnectionGUID: GrrVbTbkQMiBcuCY+Tf+KA==
X-CSE-MsgGUID: 8B8vuSdrS6Oel8B9gvpUgQ==
X-IronPort-AV: E=Sophos;i="6.23,231,1770595200"; 
   d="scan'208";a="19477410"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 22:29:55 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:31357]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.132:2525] with esmtp (Farcaster)
 id 2b7c2b24-ab35-436e-abbc-d8b5d456a5ed; Tue, 12 May 2026 22:29:55 +0000 (UTC)
X-Farcaster-Flow-ID: 2b7c2b24-ab35-436e-abbc-d8b5d456a5ed
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 12 May 2026 22:29:54 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 12 May 2026 22:29:53 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: Steve French <smfrench@gmail.com>
CC: Bjoern Doebel <doebel@amazon.de>, CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH] smb: client: use kzalloc to zero-initialize security descriptor buffer
Date: Tue, 12 May 2026 22:29:34 +0000
Message-ID: <agOptysuOb5bNNX+@dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CAH2r5mtXTpYdhU01w-GD32pDabZe6pq7=AhDnCpCGC00-JRxng@mail.gmail.com>
References: <CAH2r5mtXTpYdhU01w-GD32pDabZe6pq7=AhDnCpCGC00-JRxng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Transfer-Encoding: 7bit

Hi Steve,

On Fri, May 08, 2026 at 11:50:59AM -0500, Steve French wrote:
> You mentioned:
>     "When the reserved field happens to contain non-zero slab garbage,
>     Samba rejects the security descriptor with "ndr_pull_security_descriptor
>     failed: Range Error", causing chmod to fail with EINVAL."
> I had also been seeing unexpected chmod failures to Samba sometimes in
> a few xfstests, did you have a good repro for this?  We also have a
> problem with chown to Samba that when I tried to fix  on the client
> got an unexpected error back from Samba, so ideas on cleaning up
> setattr_nounix() to fix chown would be appreciated too.

This specific issue I analyzed on a quest to hunt down sporadic xfstest
failures in the Amazon Linux kernel test suite. It came down to

``` bash
count=0
while ./check -cifs generic/680; do
    count=$((count+1))
done
echo "Failed after $count iterations."
```

which then took around 10-40 iterations to fail on an otherwise idle
system.

Bjoern




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

