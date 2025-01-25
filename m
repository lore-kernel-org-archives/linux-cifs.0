Received: from fabamailgate01.fabasoft.com (fabamailgate01.fabasoft.com [192.84.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476E22066CB
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jan 2025 22:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.84.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737843775; cv=none; b=YGShlFR/KULJCIZJBtmixqeRP+EHiusERbmedauHsnI2iwKxpFtfbNPA6LHfcLkWcuIQhSlAV4fXr8j8d9ApBi4DsjBbYnkgayXjpkRYAPpx1VWUUXKUZATXhjqnVAnA3v4vLED7sXdCXxuIOyJ9UI+VEc7nSqetJLDU3GBpsTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737843775; c=relaxed/simple;
	bh=SPcyrQtXln2T2uDvxn+Ph/exivwbXMt9N+aWFHgcsjY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LmxbBnYmoi1DP/pzvrEIphcFoTIsP8ODbA8hvvqBaRucbmsK7Hi9fnhFv9Fy6zIcjkFMuDFkR5cOGrmWXz8P7Kv6UxR7XVx9wUVPEFjsKfwKD8kGwKs4l7/nJnbIS4NdCuxLd3M4+LaSp8mSOCj7R8D3XkdQ8WlBC0WkRBdpSSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fabasoft.com; spf=pass smtp.mailfrom=fabasoft.com; arc=none smtp.client-ip=192.84.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fabasoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fabasoft.com
Received: from fabamailgate01.fabasoft.com (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by fabamailgate01.fabasoft.com (Fabasoft e-Mail Services) with ESMTPS id 5277D2004130;
	Sat, 25 Jan 2025 23:22:44 +0100 (CET)
Received: from [127.0.0.1] (helo=fabamailgate01.fabasoft.com)
	by fabamailgate01.fabasoft.com with ESMTP (eXpurgate 4.51.0)
	(envelope-from <horst.reiterer@fabasoft.com>)
	id 67956434-045f-7f0000012b03-7f000001d8ee-1
	for <multiple-recipients>; Sat, 25 Jan 2025 23:22:44 +0100
Received: from FABAEXCH01.fabagl.fabasoft.com (fabaexch01 [10.10.5.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by fabamailgate01.fabasoft.com (Fabasoft e-Mail Services) with ESMTPS;
	Sat, 25 Jan 2025 23:22:44 +0100 (CET)
Received: from FABAEXCH01.fabagl.fabasoft.com (10.10.5.4) by
 FABAEXCH01.fabagl.fabasoft.com (10.10.5.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sat, 25 Jan 2025 23:22:43 +0100
Received: from FABAEXCH01.fabagl.fabasoft.com ([fe80::c9d7:6a74:cdb8:4ed7]) by
 FABAEXCH01.fabagl.fabasoft.com ([fe80::c9d7:6a74:cdb8:4ed7%4]) with mapi id
 15.01.2507.044; Sat, 25 Jan 2025 23:22:43 +0100
From: "Reiterer, Horst" <horst.reiterer@fabasoft.com>
To: "pc@manguebit.com" <pc@manguebit.com>
CC: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: RE: Regression: smb: chmod ignored (5.14.0-427.40.1.el9_4 vs.
 5.14.0-503.15.1.el9_5)
Thread-Topic: Regression: smb: chmod ignored (5.14.0-427.40.1.el9_4 vs.
 5.14.0-503.15.1.el9_5)
Thread-Index: Adtvd23lVSVT8VVlSIaajlplMuoqUw==
Date: Sat, 25 Jan 2025 22:22:43 +0000
Message-ID: <e70df2a91d1346fdbe88463d4edbf05c@fabasoft.com>
Accept-Language: en-US, de-AT
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-purgate-ID: 152191::1737843764-D67BAACB-75584E38/0/0
X-purgate-type: clean
X-purgate-size: 1136
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean

Hi Paulo,

thanks for testing with mainline. Bug created:

https://bugzilla.kernel.org/show_bug.cgi?id=3D219724

Cheers,

Horst Reiterer

-----Urspr=FCngliche Nachricht-----
Von: Paulo Alcantara <pc@manguebit.com>=20
Gesendet: Samstag, 25. Januar 2025 15:25
An: Reiterer, Horst <horst.reiterer@fabasoft.com>; linux-cifs@vger.kernel.o=
rg
Betreff: Re: Regression: smb: chmod ignored (5.14.0-427.40.1.el9_4 vs. 5.14=
.0-503.15.1.el9_5)

Hi,

Thanks for the report.

"Reiterer, Horst" <horst.reiterer@fabasoft.com> writes:

> after updating from AlmaLinux 9.4 to 9.5=20
> (https://repo.almalinux.org/vault/9.4/BaseOS/Source/Packages/kernel-5.
> 14.0-427.40.1.el9_4.src.rpm vs.=20
> https://repo.almalinux.org/vault/9.5/BaseOS/Source/Packages/kernel-5.1
> 4.0-503.15.1.el9_5.src.rpm), chmod gets ignored by the CIFS filesystem=20
> when executed against a Windows file server unless chmod happens in=20
> another process.

Yeah, I was able to reproduce it with mainline kernel as well.

Could you please file a bug [1] against File System -> CIFS component?

Thanks.

[1] https://bugzilla.kernel.org/
