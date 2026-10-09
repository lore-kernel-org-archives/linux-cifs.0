Received: from cvsmtppost33.nm.naver.com (cvsmtppost33.nm.naver.com [114.111.35.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEC93F44D5
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 05:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525284; cv=none; b=pcyxNmLCO2vYKRyw0upYxdqtUfczjDimET5JprI6cPbn7As5yXPqV50SLX5zGavxLdwztMK8AMAeNhJDKuTt9UmnXasfbUCugHFlR/OIWqXTMkV5ke+XcSyQOp7WDwna8jemqZDGTv1TIVf1YMaxd+YkO4QATaLXYZ300lScctY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525284; c=relaxed/simple;
	bh=/QO71l06XwK7AvoaYMtQhBKB+kOZjHKExgv8BrbqsJc=;
	h=MIME-Version:Message-ID:Date:From:In-Reply-To:References:To:Cc:
	 Subject:Content-Type; b=UOL7Eh4sHtLTmxJmdZU+B63YnqYnBynq5Ast7jvV2qmTusUN6n9CBwILaWuPJttX7j5qJ45/ZJFg9nqLsPpqWEdiwb0wt03j/xWiHV+d6mIYf02hSxtCDzrUz3CTA/T9f7ZULZAYI3FVadHZ6xb7svIXlgh8oWR/3EJ6127qWzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=bPWN7GUF; arc=none smtp.client-ip=114.111.35.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="bPWN7GUF"
X-Works-Smtp-Source: fXblFAulFqJCpNm9Fq2ZWHF0
Received: from nv1s-hmac-real-22 ([10.180.31.91])
  by cvsmtppost33.nm.naver.com with ESMTP id TOj-MMBaSlO8A6DiyO8VVg
  for <multiple recipients>;
  Fri, 09 Oct 2026 05:54:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791525275; bh=/QO71l06XwK7AvoaYMtQhBKB+kOZjHKExgv8BrbqsJc=;
	h=Message-ID:Date:From:To:Subject:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=bPWN7GUFEPJL6DRm3n8tOma/qv/tnRqwTkyxXBclOnquZUJGMaNWL/7gVky/vzGme
	 uXQFHLNT73BwJNdCnL3vjPQkyHUey94q/I+f0Q/gPUEV77qfVnnNIPGiZaLmAX/DtY
	 5Dv/NMdGVAUSe5u+94/R+2kD6lV5GMdkoi+IxXTAI0PEQFxKVQEnjBnXA1Ms8fJfQU
	 JXJ+wHaY3W7cDFRVG8HeKNo/n6eQZu2+vgm7DJiLw22C8I5LxbCHQd1RnRm5SDw5dS
	 RsOz8cXI/X8MjeDQR6X36G4VBc5csfsrDABI3ApN5IhXRscyHzZnHN2Hvowx6h7POZ
	 5lEvDM3HzY5Aw==
X-Session-ID: 762fc6d31a4f9d031c17fffaaff9ad49a36b7e742fc4fe8903786de786ec8bc2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <b4d1f88de611ed37ff6fe08462593@cweb014.nm>
Date: Fri, 09 Oct 2026 14:54:34 +0900
From: =?utf-8?B?7ISx67OR7LCs?= <tjdqudcks0424@naver.com>
In-Reply-To: <CAKYAXd-3W-7gV6_+L=Fv==dr7oZuqF4rEjF538eOkKfCy4t4Kw@mail.gmail.com>
References: <20261007063050.26322-1-tjdqudcks0424@naver.com>
	<CAKYAXd-3W-7gV6_+L=Fv==dr7oZuqF4rEjF538eOkKfCy4t4Kw@mail.gmail.com>
Importance: normal
To: =?utf-8?B?TmFtamFlIEplb24=?= <linkinjeon@kernel.org>
Cc: <linux-cifs@vger.kernel.org>
Subject: =?utf-8?B?UmU6IFtQQVRDSF0ga3NtYmQ6IHZhbGlkYXRlIEFwcEluc3RhbmNlSWQgdGFrZW92ZXIgdA==?=
	=?utf-8?B?YXJnZXQ=?=
X-Works-Send-Opt: OlRwpzGdjHmdKHFOMr39Ko3YKHmZjAudFqM9KqMqFxIYkEljxBmwjAg=
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64

SGkgTmFtamFlLAoKVGhhbmtzIGZvciB1cGRhdGluZyB0aGUgcGF0Y2guCgpJIHJldmlld2VkIHRo
ZSBhdHRhY2hlZCByZXZpc2lvbi4gVGhlIGFkZGl0aW9uYWwgc2hhcmUsIHJlc29sdmVkIHBhdGgs
CnN0cmVhbSwgQ2xpZW50R3VpZCwgYW5kIGFjY2VzcyBjaGVja3MgYXJlIGNvbnNpc3RlbnQgd2l0
aCB0aGUgaXNzdWUgSQpyZXBvcnRlZC4gUGFzc2luZyB0aGUgcmVmZXJlbmNlZCBvcGVuIGRpcmVj
dGx5IHRvIHRoZSBjbG9zZSBwYXRoIGFuZCB0aGUKYWRkaXRpb25hbCBzaGFyZSBsaWZldGltZSBh
bmQgZHVyYWJsZSByZWNvbm5lY3Qgc3luY2hyb25pemF0aW9uIGNoYW5nZXMKYWxzbyBsb29rIGdv
b2QgdG8gbWUuCgpNeSBwcmV2aW91cyBydW50aW1lIHRlc3RzIGNvdmVyZWQgbXkgb3JpZ2luYWwg
cGF0Y2gsIG5vdCB0aGlzIGV4YWN0CnJldmlzZWQgdmVyc2lvbiwgc28gSSBjYW5ub3QgcHJvdmlk
ZSBhIFRlc3RlZC1ieSB0YWcgZm9yIHRoaXMgcmV2aXNpb24uCgpUaGFua3MsClN1bmcgQnllb25n
Y2hhbgo=
