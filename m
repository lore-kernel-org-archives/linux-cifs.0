Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=207.148.104.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795304321;
	b=L+jDnSjOa9cd9DD55RpEXFHP8e2Hi0dWTLui0bs7OEy4mbCt6/YPzE+agZPrUIuNaBPG
	 OEK5VmRjR+nEWKR4QhYcnSXntvbtZBXGT0IsWe4Tph5gRKCQeyYxL1G3eZguHxtHM22hg
	 tKj1/+JN/Kp6Y0DTeQIeWlIvNUOm3fRTbu03VS44SBm6rcZc+mLCfIRJdjXnIFTyGoyOp
	 EJDCgd5YG13Vc3IOzd5NRd0dUTVnIFgo8vt+t6h0xcoo9Zy3pCq0jrGUlzelygdXkbNzA
	 z2glFs0ukPhYLvNDYmp92AYy4g8hc4kF5yBpXyPn5AUEkchxeMVF77LSlpUAc6mcmgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795304321;
	h=DMARC-Filter:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:To:Reply-To:Message-ID:
	 List-Unsubscribe;
	bh=SCRfLO8DwpnTRaKcYPa7SkXdOkFHHcXHUF5Od1WjqXc=;
	b=nV/lBngHv3goFXG90aRNJLeB2Ne1+A2nSP29ybdiObnF4kRGj9qqSvZsQx2lE/triLOL
	 PHO3Jf3e0RMAn79+eAiG7uPqUwXddOwvi5hVPfRjpPlEuia5V/zTLT59v51crHEOQReiN
	 n+GDB4aWpYHqX6EWItHBBHzbUBq5xMBB8Zoj4ibqpX2znBJ3ZH21nhR2sm9oBS51TxIJO
	 1kKjGi0qZ7UfZ01cjYu6hmypEYDf4NgOrcpgf8eVy7aNUjzXsrVkzN+CoVq04rcC/eB4t
	 3ul2KPbIuwcdkLE2CmP00joqQnRTNOTjE6ycU0K08wkxK1e0EsOI/JAYVcuyicCjIfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=textscene.com;
	spf=pass smtp.mailfrom=textscene.com;
	dkim=pass header.d=textscene.com header.i=@textscene.com header.a=rsa-sha256 header.s=default header.b=ru0xHzHD;
	arc=none smtp.remote-ip=207.148.104.199
Received: from mail.textscene.com (mail.textscene.com [207.148.104.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5846606A320
	for <linux-cifs@vger.kernel.org>; Sat, 21 Nov 2026 23:38:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5846606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=textscene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=textscene.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=textscene.com header.i=@textscene.com header.a=rsa-sha256 header.s=default header.b=ru0xHzHD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=textscene.com;
	s=default; t=1795304311;
	bh=SCRfLO8DwpnTRaKcYPa7SkXdOkFHHcXHUF5Od1WjqXc=;
	h=Subject:From:To:Reply-To:List-Unsubscribe;
	b=ru0xHzHDu8lspu0j1/HVmWJPXJMEgt6TuQ7vAbiuUq2d1eOV7Pey6mGXYgB/mNAkP
	 RlbBYtYNYOdJ5dc5PsGvrvzZiz0o5POB6dvNP7owofzwDs+1q64p3JLd/xdGJtr22D
	 eZMNf574KigMCM2tQNsAUUyifXPmdbRcKyGlIHzN+C5cMrUfLpEf0/vBtCIJjUeeFA
	 x7xiXSmQoXxGq3Cbdr4oHDLL/EUs0+NJO38NVtVcNRFWVpc3UL3e3hH4SM2XEZXlWx
	 2hi9FAQNt65E1vkgAjbjoyA46EzkmAdQiln8NI6Xii+sbx/rSbtI0QAtbdcubqKW7I
	 /yYdsoeWYz2Lw==
Received: from [172.30.219.47] (unknown [39.105.124.184])
	by mail.textscene.com (Postfix) with ESMTPSA id 6E242126633
	for <linux-cifs@vger.kernel.org>; Sat, 21 Nov 2026 23:38:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Subject: =?utf-8?q?A_short_note_from_8341TokenFactory?=
From: =?utf-8?b?ODM0MVRva2Vu5bel5Y6C?= <send18@textscene.com>
To: linux-cifs@vger.kernel.org
Reply-To: wuqiong@token8341.com
Message-ID: <179530430641.2857420.13365575693833186378@textscene.com>

SGksCgpObyBwaXRjaCBkZWNrLCBqdXN0IG9uZSBxdWVzdGlvbiBhYm91dCBob3cgeW91ciB0ZWFt
IGhhbmRsZXMgbW9kZWwgYWNjZXNzIHRvZGF5Li4KCkF0IHRoaXMgbGF5ZXIgdGhlIGZpZGRseSBw
YXJ0IGlzIHVzdWFsbHkga2VlcGluZyB0aGUgcGx1bWJpbmcgb3V0IG9mIHlvdXIgd2F5LCBzbyB5
b3VyIHRpbWUgY2FuIGdvIHRvIHRoZSByZWFsIHByb2JsZW1zLgoKQSBzb2xvLW1haW50YWluZWQg
cHJvamVjdCBtZWFucyB5b3VyIGVuZXJneSBnb2VzIHRvIHJlYWwgcHJvYmxlbXMuIFN0aWNraW5n
IHdpdGggaXQgdGhpcyBsb25nIGlzIHdvcnRoIHRha2luZyBzZXJpb3VzbHkuCgpJZiBtb2RlbCBp
bnRlZ3JhdGlvbiBpcyBhbnl3aGVyZSBpbiB0aGUgcGljdHVyZSwgb3VyIEFQSSBjYW4gdGFrZSB0
aGF0IGxheWVyIG9mZiB5b3VyIHBsYXRlIOKAlCBubyBrZXlzLCBxdW90YXMgb3IgZmFsbGJhY2tz
IHRvIG1haW50YWluIHlvdXJzZWxmLgoKODM0MVRva2VuRmFjdG9yeSAodG9rZW44MzQxLmNvbSkg
ZG9lcyB0d28gdGhpbmdzLgoKRmlyc3QsIEFQSSBhZ2dyZWdhdGlvbjogb25lIE9wZW5BSS1jb21w
YXRpYmxlIGtleSBhY3Jvc3MgdGhlIHVzdWFsIENoaW5lc2UgTExNcyDigJQgRGVlcFNlZWssIEtp
bWksIFpoaXB1IEdMTSwgUXdlbiwgTWluaU1heC4KClRoZSBzYW1lIGVuZHBvaW50IGFsc28gY2Fy
cmllcyB2aWRlbyBtb2RlbHMgKEgzLCBXYW4gMi4yLCBiaWxsZWQgcGVyIHNlY29uZCkuCgpTZWNv
bmQsIHZpZGVvIGFnZW50czogc2hvcnQgZHJhbWEg4oCUIG9uZSBzZW50ZW5jZSBpbiwgYSBmaW5p
c2hlZCBlcGlzb2RlIG91dC4KCldlIGlzc3VlIGludm9pY2VzIGFuZCBydW4gb3VyIG93biBjb21w
dXRlIHJhdGhlciB0aGFuIHJlc2VsbGluZyBzb21lb25lJ3MgcXVvdGEg4oCUIHRoYXQgYmFyZWx5
IG1hdHRlcnMgYXQgcHJvdG90eXBlIHN0YWdlLCBidXQgaXQgdGVuZHMgdG8gbWF0dGVyIGxhdGVy
LgoKwqUwLjUgb24gc2lnbnVwLCDCpTUgbW9yZSBvbiBhIGZpcnN0IHRvcC11cCBvZiDCpTUrLiBU
cnkgaXQgb24gc29tZXRoaW5nIHJlYWwgYmVmb3JlIGRlY2lkaW5nLgoKT25lIG1vcmUgdGhpbmcg
d2UgYnVpbHQ6IDxzdHJvbmc+dG9rZW4tbGV2ZWwgc21hcnQgcm91dGluZzwvc3Ryb25nPiAoZGV2
ZWxvcGVkIHdpdGggYSB0ZWFtIGZyb20gVHNpbmdodWEgVW5pdmVyc2l0eSkg4oCUIG5vdCBldmVy
eSByZXF1ZXN0IG5lZWRzIGEgZnJvbnRpZXIgbW9kZWwuIFNpbXBsZSBxdWVyaWVzIGdvIHRvIGEg
c21hbGwgbW9kZWwsIGhhcmQgb25lcyBnZXQgZXNjYWxhdGVkLiBTYW1lIGFuc3dlciwgbWF0ZXJp
YWxseSBmZXdlciB0b2tlbnMsIGxvd2VyIGJpbGwsIG5vIHF1YWxpdHkgbG9zcy4KClJlcGx5IGhl
cmUgYW5kIEknbGwgcGljayBpdCB1cC4KCgoKODM0MVRva2VuRmFjdG9yeSAodG9rZW44MzQxLmNv
bSkKCi0tLQpXdSBRaW9uZwo4MzQxVG9rZW5GYWN0b3J5CgotLQpEb24ndCB3YW50IHRoZXNlIGVt
YWlscz8gUmVwbHkgInVuc3Vic2NyaWJlIiBvciB3cml0ZSB0byBoZWxsb0B0ZXh0c2NlbmUuY29t
IHdpdGggc3ViamVjdCB1bnN1YnNjcmliZS4=
