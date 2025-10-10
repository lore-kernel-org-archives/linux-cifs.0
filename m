Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DD014286;
	Fri, 10 Oct 2025 06:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760078742; cv=none; b=tny8msKgq4clQ6ju9P/8+Gjw4eLC0GlVSRjI5kYAwbf4qS2gJdKEQilvYZuO58DzBiXxv4lj/4PYcJAe8dXu8Fr1R6Yil09tewjAtxDfuqAZiixHEa1C7htn+NbcvLF6jcKFKsmGB4yKt+qdUXi5I57BdWzDCV9EtLFofNXM28Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760078742; c=relaxed/simple;
	bh=5Cr4g1hfH+gkW6LKTaxTeXAOuX9FSCWPqw+iQQlIy88=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=clZxvdVdXOMu2w7WFWV7FpsPH9bZWxiA4c8OYt1a4ZQ4ZMqynKpKUIVTGvQg62ysWK9ud1Tz8N+dgWEEfOWu8wMW6Czl5UN1Kc+8XPgbFEPxDx5f3MlaB4G232QjyOJMUdktkW6dyYFrcoYB6UwV1i+Cp2ofCXy7kjWfiN6QSJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=p1lk0X9v; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="p1lk0X9v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760078731; x=1760683531; i=markus.elfring@web.de;
	bh=i6uv6dmurME/Qc8Q6l5mlSGI7Fu1cbNk9OylSJYyDN8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=p1lk0X9vdAH5sNzHSkMOIuZrfbHMHOQVaNg1KoSsgwO16RdRvJzpFsCqgjF6u1LD
	 5Sh55SfzpqGBVhUr6UtPZVG+6RmFA/Xq45ELMWY/LGOBW0G0LFju/9ks+8rQ9wS/W
	 GBZe9ehWKAR7mFUZp2pfD4uuPESKZuVy3xtGyPxF5AvQd+6YPnAWIc2vQP8sXFDSA
	 kNp/X8NjGuZbqF2296LX5dZzYST/DE6QrPXemATHtCw8Nj59pzJM65X8F+TGWr7S0
	 9ZpBVCP8no8t3pON1yHtWBRGBzZ1XWRR+HFQ6HqjBzplOhkRVwr9g4Hshfy9pPOfA
	 bmC/Xsdc6ed+9wtYcQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MwjK2-1uJ06L0KhW-013QSl; Fri, 10
 Oct 2025 08:45:31 +0200
Message-ID: <e8a44f5e-0f29-40ab-a6a3-74802cd970aa@web.de>
Date: Fri, 10 Oct 2025 08:45:14 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH 0/3] smb: client: Better exception handling for SMB3 hash
 allocations
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Aurelien Aptel <aaptel@suse.com>, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0lfUd69ZVxcWFvGWuqs5e3vgWNSbh8D5f3Hfc5qsij791mrqzOa
 N+Dosi72h49YW0nOtCUrzBPRX/c3WEm0ExY9Sm8QtQOcyYhg1EebdZjSJVDBM7qp2skw/Ys
 JA6zy4GiPc6lBNSn3lCb84PaK2ang40iZPIYfwq5J77ONedat+rIv6s3uFwk/dj99WVuyoZ
 6dqkPDT/hdj9IehK6u7Cg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:418ur511u4Y=;/kfbPV+pwZrr/6wb38G8iScIreo
 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
 qYzzM0UnE1Ccw+QyNXu4hiVGC4=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 10 Oct 2025 08:40:08 +0200

Refine a few implementation details for further development considerations=
.

Markus Elfring (3):
  Return directly after a failed cifs_alloc_hash()
    in smb3_crypto_shash_allocate()
  Improve resource release
    in smb311_crypto_shash_allocate()
  Omit a variable initialisation
    in smb311_crypto_shash_allocate()

 fs/smb/client/smb2transport.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

=2D-=20
2.51.0
