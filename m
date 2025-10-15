Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6F83375A5;
	Wed, 15 Oct 2025 16:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760545509; cv=none; b=mJ1SBl1L38AjugpK6Nw/MpaZFHYr+dzniManEPgNXgwvwJhX359ekmk9IYYkt6SAp9b2RFuSPcxaxsw88Jerjem9O5LzhPzWgUVDImh2h0RTLAh9Ryt7CE5otKh6bouibTICMsZqwzLWv2lkS2NiAB2Sdv1HMhuVMlk/IQqeALE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760545509; c=relaxed/simple;
	bh=Kwgs6flM+VOjdwp/hKSdsQrrl/FgQz4PU+UuNc7sZjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ea4sQHc5FE7TQM0bKedwqUY2qB8u6jWrKs9kGlPJo8jTMCA5+rZWr2AZUK4JxL2y6tBqlnWOjJp0D7hxJd0I7DcvLTzi//gJi4LJKDL6MlcjrFNPUCykz/+hjoSN8nB9Ab7WaknKTyLW+yMf6VGtdgA+koZKVH5OE2VHyseT7S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=rMUJmEWT; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="rMUJmEWT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760545503; x=1761150303; i=markus.elfring@web.de;
	bh=YYJoI5I02ny4wVnuhsS6zAtI1EfJ/BTpbBtlel7UDls=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rMUJmEWTXt6MQJPyBvnJarXLCH6SsAFt4GJNT6b+FXZh0MN5cPMmfWSGeh2sutwU
	 aokkmU7mIqaAuA48cPjkx6VoeYfWxBsdKciQQ+iZkF3QCGJRfkfn9h1uJdWhjtVWB
	 dwzyZgwlUTt8TaLi4/Vr2/MoYEayTFuT+rd8mPliU/ykUjNtxgw9wBUFI9LpkUVKT
	 ZJVaKfJj6BQ2rYqz/CrxaE2nhktRItvX8ctowQ4TQBORG7OO9xYJ1qJqymP5cfTnf
	 C/OkpLAWBPHGxA/er+PzFDpnTw+fJyq3BB7nT40r2Inrr1R2bSZ+ZFG6HcQIzE6L/
	 WyuU++/VL0/fJniuZQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.181]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MsaS7-1uF1wS0rf9-017ZAS; Wed, 15
 Oct 2025 18:25:03 +0200
Message-ID: <6eeec2b6-ef28-4280-a854-cc22d2df55ed@web.de>
Date: Wed, 15 Oct 2025 18:25:00 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: Fix refcount leak for cifs_sb_tlink
To: Shuhao Fu <sfual@cse.ust.hk>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <aOzRF9JB9VkBKapw@osx.local>
 <6599bf31-1099-426d-a8e5-902c3d98e032@web.de> <aO/DLq/OtAjvkgcY@chcpu18>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <aO/DLq/OtAjvkgcY@chcpu18>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:30EQJqlPxbR40CcOnLo2c9jAPOtC2viQwddlZGg3tVuuIp/4f4d
 6Z2ucPy9Avaw3Q6/NQbv+5W0WzgKE10nVg6ep1YiUtBqotT7ReniAbHXbP1jrTW959donEa
 0uE5wKW0kgjAq7wxbI15NBrnIR8MieT9FQ4UdWf+3SW6gO9iV0eYYda8LT5F/vjCZQHSWn3
 CMjcDpTiPs/zAvr7nVO+Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:U+Gmw03Zo08=;P73bPuUgvrgZYY4I2b1lyyqtjIg
 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

> Fix three refcount inconsistency issues related to `cifs_sb_tlink`.=20

I suggest to omit this introduction.


> Comments for `cifs_sb_tlink` state that `cifs_put_tlink()` needs to be

                             ()?


> called after successful calls to `cifs_sb_tlink`. Three callsites fail

                                                          call sites?


> to update refcount accordingly, leading to possible resource leaks.

* Do we prefer the term =E2=80=9Creference count=E2=80=9D?

* Is the word =E2=80=9Cpossible=E2=80=9D really relevant here?
  (Would you find corresponding case distinctions more helpful?)

* How do you think about to increase the application of scope-based resour=
ce management?


Regards,
Markus
