Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B853655D8;
	Mon, 27 Jul 2026 06:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785133167; cv=none; b=LhZ5efpr6H/dsNwvVM647eOTANrJyDO272Bors97M2r1P/r+W0BFYYdjlsPyx7fwBgpQZnedooqYGTfQrhXIQ6XdMnA6AmUoM7iLrCLWV/lbjuM9qv+GYMeF8hGtsnyHx3jmp9Dtz3AG4YroVy5D2oKXWVWZc287zIxnYdpKZyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785133167; c=relaxed/simple;
	bh=mUJkndwPhU8o09kL0qeW2YhlugQwvudnTIoXKz9JWVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=av6TuzYrIa14mUyZgOKAe0P/CR0t9QnGRZGhzWtGymijZWmJLvymC0j6gpRNH8fgBd5aLtSKPkF8tVrqksMJXGVSZwPW9+1yGmYQZHRLxqRusdURsPgyeFmi/VZycea6NIda4al9CQ1UWqw9a1WJm8SxzmzjbXVmVuPZJW52Qn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=U2YnXXHb; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="U2YnXXHb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785132974;
	bh=GxEOiQp0LahWhcxD6BVZln9ZZWTjQs1Zs9zWy37RIQ0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=U2YnXXHbeIzavHlmtsEqQw9RjdaUstqcLHt8zVronGVwv4Pd7OOiHE+EWQjlnpAJZ
	 OdRjYF92Ty8bVRoU57W//1IVUANucuBUsCqk0cKsekj+NKJ3tOytzl4fp/WH9cdUxf
	 bUW0ZAqznT3gsOsjTvLQ4gFV4M1OKrULBryByJJY=
X-QQ-mid: esmtpsz18t1785132970t822ed9a7
X-QQ-Originating-IP: SEnPt1hAJtieWfPox/DIbba/HQQkTd5DNdw7CY/T7eE=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 27 Jul 2026 14:16:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6403465585375082852
From: Yichong Chen <chenyichong@uniontech.com>
To: sfrench@samba.org
Cc: bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	samba-technical@lists.samba.org,
	sprasad@microsoft.com,
	tom@talpey.com
Subject: Re: [PATCH] smb: client: free partially allocated transform folio queue
Date: Mon, 27 Jul 2026 14:16:06 +0800
Message-Id: <20260727061606.347179-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260704052714.428561-1-chenyichong@uniontech.com>
References: <20260704052714.428561-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: ODSP3GceLUeqSDfq3s9zNS7fDZ8e3g9KS1tRwT0gbkPQfZUcjGQJil+P
	c2g6Jlt1hQes4aVoVXea8/zK2Jst2qGb7V1fHgeh8ozsPxkGiEw3Qp3Qu4TuW7Xh5LwvloD
	BLyqrUPtZHKoy4FwLOHHWAgt/7fROBnS2ybHBZE6Hik3UQf9zbxUIo7R+81K7H8pwnK/n0v
	FZuTeoiajTVf5yFsMpFxZMinHv132LOn0Vs9vyjsR1KxVeRNvOkQlUIFDJxVa/XOubel5jq
	OiFZuE2NGT6xXJnuEfYbtsacr4aj1xYmSfjtAkDho+WgBXuoh+q+RNFG2tX82v0TCJxMrPz
	LV0lAfsyUPLZOKHZTf7t21gJb2KMLS/UU1Q4h9dcuWgNz2GCrLp7CW8IIfKqOV1byJULKq0
	C9ARuSJta56zgXBsOgXzNART/qG2S2et8RQZdQxK7mAg2PwvsRjbdW/9zzJXYou1KUIOA+d
	Dk+ZbmmdDiM6FHjn0SkeggaCUIp1+bf2ky5+NSop10Q4f1R+AR4SFQFAfQ8Ka62icPnMUcD
	teKXhfnx828PYwev+Y75NuPH4W9z+PRQHcj97euTyQyXnUNRG0WPvzlcdLxn2yx7roJN7sI
	uDGm7SdbgeXVFXuyf8UxPXP/VCPIxgTRWd10Fus2sxOQBH21ilMoDT+7gWCHKFUFDlY4f20
	cfdUj/FlTbPbTnmEtQnEMv5Il3wHTLhhcA7X+bX+uzeQIMrnp1x88//8h112MWTg9PA4sZx
	HxZtDYXAvMrXMQUgwpk2t75Q5fZ5FazwkcXkNeHkFEb6K1L5PJ56FyB3jmJNA2R8BUzBWzp
	WoeO7xU57/3GLyoKg4E7x4xrHKXTvzvKI/eRSS0j0J41RSl0JIFUQZuQWGUrRAI1Ai/+edK
	adFqdLwK1DMOfFg2suUi6SrHrEVUb2qCp6uIhJF1GZjmrxggfhYdqxsD9l0McrHpI8UAEVR
	I/r5dGJRpMDJtAAYsWP4lzDc4cfDVxYSBgRZ2HL8gr7PIDacZVxxnBiy+fObVV0mSql4=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Hi,

Ping.  Could someone please take a look at this patch?

Thanks,
Yichong
