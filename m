Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5515A1C232D;
	Mon,  4 Nov 2024 11:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730718412; cv=none; b=uRZ2hEPxNs3xuIihJ3YFdJhn8Wb2IsGWFr62gpkvW/AsD/OWVcM0VCYrC48VdNuSGDzZq99d9QSPXbxB06Z4LRvzIaKu9qF32qGMf6+uXkXyGK3bgx9NKD50t1C5nDCz5eERDMTHVJl19zg3j4OrwnNqebfY3gcPRu9poq1tyNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730718412; c=relaxed/simple;
	bh=cpMHOzTmHXwYuMf8y9DgtSpuqgJbsAryhON8DIq3anA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VuHPaLV2skHCniKy6Cwtnc+ypHsto3b6Z/ULyxB1QiFCo5MZrIhLGH8VMy5x/fLKDpSkee3B05Tm0E4FeXTnH9Avb6peba07msn0x5QV/PUOztCrgA2rxnyhRhy7a3wzpvBdeza0KYIuGt3SScfEtEEltBMj7LoWclgPymcU96g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=wArfhlkK; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="wArfhlkK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1730718391; x=1731323191; i=markus.elfring@web.de;
	bh=cpMHOzTmHXwYuMf8y9DgtSpuqgJbsAryhON8DIq3anA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=wArfhlkKYJZ9iDulb+ia3AmPgHdyh4qhgU1EjBjjAh2i/6LE6nQ17Voqd7lG5uKC
	 RKbnV+MqTyFyOFCm19xoVajjZqjRoJk0Wp/P+5bn0jxOYTH08fitgy2jiYodV+/g0
	 YMVghGo9CuwkKiKCcZ+2VBxb+dvh7DJYBi4di20dxo1gROy7KZNGu8EVZ9sOXEfhq
	 sCb4XqHxSDckzv1ismB1XQXFQszE4fRB7pXHRYm3QHeQF8L89KT8ik6NA0FguyD4G
	 0MZaawj2qXSDxnVkptu7JOP9YntI9pmFwgk910+1IJSiNvM6Id1BSdr+O79EX0esG
	 5MhiqS1O0T/5YJEP5A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.88.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MqIB7-1tdNps2XHX-00dOcl; Mon, 04
 Nov 2024 12:06:31 +0100
Message-ID: <275d4e36-4628-4cfc-b51d-1bd909a6fadd@web.de>
Date: Mon, 4 Nov 2024 12:06:26 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] smb: client: Handle kstrdup failures for passwords
To: Henrique Carvalho <henrique.carvalho@suse.com>, make24@iscas.ac.cn,
 linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Steve French <sfrench@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bharath SM
 <bharathsm@microsoft.com>, Enzo Matsumiya <ematsumiya@suse.de>,
 Paulo Alcantara <pc@manguebit.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>
References: <20241022171515.3330183-1-henrique.carvalho@suse.com>
 <20241022182126.3353440-1-henrique.carvalho@suse.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20241022182126.3353440-1-henrique.carvalho@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UKsMFjSFw/SsoEH6fR4zC38H/Juei55bM3AqNKlYLFKcPyl6UZT
 157woyooQgjV74nPVHCJ60NaFS+oprDknq9BoxQCUeSA/k4A/m1UXrYjjFHCu7XMHd/1q5f
 s8DUgCvTfeR9bzHMFW+S0AeDlrnEL32Bp5ow9hiHUMiF9pU4VXpsQMPCoXMNVY4X4WFgU+L
 YUK8gkTPb5k1HO0MsbB4A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fyUIJPm37sM=;E1oE+e4I49Ao5fkCvxxO87jZ/Sm
 nIiUTcSTW32fxAJpN9HTCjmuLnqYup6I3cl0PC5iHKeqaYlQBhkOLnJOesxnYADNtzMSUgYKK
 TDGghoK2L8gbzajyLmcwxnXWFbSfXC9LtirK+gmDsephcg6PCBsPpguaKwAXmAtQBTGbmJaKl
 xkkXJCYDy3OFcbEBOlwzF7sMiBdYCARhgmeb4IfpD9JgEJ+WL9F9y7zZbaKNyn0C9to25NnDL
 oGdNO9CYci1SuzPeUq3iPRKBVJGneZ3FFCk/M/SOPCEv1f+HJyNrjlN4XRBommNCLswj4KQz2
 ANT8+X2/H0edRXAuzsaHmVldKdVtgJmIh73CokGdL2ZqqVX4f7n3dwkec/HQR95qPF9hAWrAh
 Aw38w5HqpVWw6fCtVCJLnToxsuT4oZ+V+56SqdrdDLvLz8lUYiX/g7SHUSosj4SHyQBJkk57p
 RHsyaqGWMMJrVbWOTS1iZWB3yJFM3oFip53K4CHKIauaBk7xDhHHojWeva2VFm9JwxFisGvYl
 YCxhbx7XMeXoXS08FpzItBS3EN3Y89mCp1H4l8wrDX2e9OtT8tV4tbjhgbeuhri/ME0OrZS//
 4aN6Fe7ytA9gvLO2Y37nYmD1bGcoepppWICX1UpLBMrwzLp+Fyz0r04mXxk3CqAsPwy5o87S+
 FkxFRNQrY90GDbpmPcZP6MJvp2rxVgk5VJui49iVADcfbFeFyqrhiWpAZ/dEDrMpMp/Bou25z
 88cPpFQr48LxCsxGBEbKEZOFTvexu4P0EQH+udsledbsLfeS5xQKgolALz4jtyGd2xFFgzHv9
 AbvlLK123g0FIvEgi5RVTo/g==

=E2=80=A6
> Signed-off-by: Haoxiang Li <make24@iscas.ac.cn>

How relevant can such information still be according to requirements
for the Developer's Certificate of Origin after different names
were presented for such an email address?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.12-rc6#n396
https://lore.kernel.org/linux-kernel/?q=3Dmake24%40iscas.ac.cn

Regards,
Markus
