Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EFF1FF5EF
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 20:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393805; cv=none; b=FeOCEaHHocAgF2Y0m5qGpvkpiMefiPdj4SumY6GnhOG9TR80cAi6Io7kPdeSPmEgyqD3A+0/5CO99d/ERYj5A10Bz79uLDA64uphHB0sOC1I0+rs6BqsO+NRGaok307+h6NWbgClF+Myb+wLGew4agGF4r7bA5sclmkxMKYe1e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393805; c=relaxed/simple;
	bh=Ver/u5L3/WcBHa3ccZxMFxb1Aq8SYVuVwrMRcbM2hdg=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=BVm5xwL1/ZwLOYUkfHWU/KHwrtHrEdHlN3ISEudT/EH2JsKQoVPV4Q+gpp+hLA6cBV6JUOHr2KaNI6ytIeDxqoexSzFkWU7iDHiMSKrQlwvHSYHc89qTWzLQ4qpt+eufxQAlXK8FFTZNglAYl5K0NbnAnp8yi7foS0pHX7VDNDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Ws6tsJpV; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Ws6tsJpV"
Message-ID: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1739393375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=QAhQ41hsO8HG3YzAE+E1vV6KmZRuDxC48acTFWz+7s4=;
	b=Ws6tsJpVycjXCXtfiAIQpYS9G9wJfMHpsIcJQfzepyb+B7FIhlGIJFYslJ/E8Eu7qg4iHi
	NDk+fhbX1LojyeEF3Tx2QwXRwuwcLtUMRBO532EB56Nm8k7KmvjIaO6cVD3HMqfcuC0Lfu
	8H8MTBwIt6pyA1ts9q7BdKvpsRj+39SHcohpXtx19Um0W6laIobfh6Mrs5Zxz+kqGK0LJ+
	9DrD9RgdpPkb29a2BYrXw3wPE4TMcZix1qwUt5ZR8bTWqk6+8bTRHKA4YxuJM2knQH9LPj
	Rw6A7z3thjep+ulNp/ozbLk/cUBRdYRP5dLCIM67HlSFQn/KI7bG8NqdbY8ABw==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Pali =?utf-8?Q?Roh=C3=A1r?=
 <pali@kernel.org>
Subject: Regression with getcifsacl(1) in v6.14-rc1
Date: Wed, 12 Feb 2025 17:49:31 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve,

The commit 438e2116d7bd ("cifs: Change translation of
STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) because it
expects -EIO to be returned from getxattr(2) when the client can't read
system.cifs_ntsd_full attribute and then fall back to system.cifs_acl
attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but that's a
different problem, though.

Reproduced against samba-4.22 server.
