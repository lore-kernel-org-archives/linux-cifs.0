Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="LyaKZlOH"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BD21A2
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 16:06:33 -0800 (PST)
Message-ID: <fb9c59cf8da2881158d54014feaadee5@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701821191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hxQ2SynPSg3hgN+UU2wX4tE5qyV9/n0Z9bzzghD6Ufw=;
	b=LyaKZlOHycQza1UtmRK45rd/m+t3EM96E5R4ZpbnVtMtfAudSwbGviuQjk77e9BoYp6Q+x
	l6mXMvtBdiZVupNBeG4SkTzRfaUD4ZEYP9pXrIo5SmIHP+yxuqHwq88KszgCH5z2BNyICd
	YE5audEbTBv40x8hyM3LoRbMkO1GlS3b75VmBxwdmA4hyqBUr7WrvUvyRkpCwmYNNUQ8kv
	/7N3jdPluPcl+X2rtAfCoJvomfVWscRpL/FQScGs2cSMYslniSO0Y2waQy1SsiKVsuwRYu
	/IovkSqXeHBmiRCrDIFti2qEP9pXLN7DdR5qXHqkyvBz6O73VnA14cmG8kEbsA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1701821191; a=rsa-sha256;
	cv=none;
	b=QQENDculH566E/0l0VxQvuyWs+l456jVmLzlkbXkZRUatoJYREQBGPlhl06F0OXOSzABVV
	kEq0LBTtkjXZbmiQkpBnzmYyItSLkx1Ie4c7VgZ/R+tdmCrpynVt8iPhezj56xQAZqIkVl
	vw7w71vh4Unf5JmBfr/K1Cd2xUtqgkpcIHqRWfIB/MeRHBih9KLdCjr7hh2Yc8pReoPgk4
	0pvjpZYrS6CFgrroSwezB0ql7Uc/qxVqDKeB7QWBDGl0wx76FBbk9IOw85mGkst8RqrJb8
	3z+y1Jb7jV9WE7KG4EfZKJNcR95PfkMjcs5HoM4i/8yQ823yYMLJt3Efl4G2pw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701821191; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hxQ2SynPSg3hgN+UU2wX4tE5qyV9/n0Z9bzzghD6Ufw=;
	b=PePTbM2CYEkIxcUBvKnkLKZNQKrdOUNb62RyJIIE3aaRit4NoXVLsF8jROZHrfjNuBEiYz
	0OLZHGLouksDnBzqWsmIrseIxphXYlXyXgDZA4F8mdYNSsvby+P3uK1iYJWJThksbMWGut
	HzeDlBLBxwhsMm9/vheX8+6dA7uOIU5fx2M3Vubc0E+X9j1EAftfZaQ69PnsbO+Oa8GYBl
	FMQaXXE2tl9efJymJ3JkgwfSlICl2nTDe/Ts9Dkh4AqySd78LZ3+VZEAQFmwdTKPsHIPWL
	1U27dwBGkCswHSDUgFvfBCSelgN0faVhrOkYTJg7/p6azbjmI0AmOjUNQaxsdg==
From: Paulo Alcantara <pc@manguebit.com>
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Sergey
 Senozhatsky <senozhatsky@chromium.org>, atheik <atteh.mailbox@gmail.com>
Subject: Re: ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE
In-Reply-To: <CAKYAXd_2diW78c1kCehQ3suGyOC6Zj_3fn=A=_GzFAbL8D4nQw@mail.gmail.com>
References: <CAKYAXd_2diW78c1kCehQ3suGyOC6Zj_3fn=A=_GzFAbL8D4nQw@mail.gmail.com>
Date: Tue, 05 Dec 2023 21:06:28 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Namjae Jeon <linkinjeon@kernel.org> writes:

> MS confirm that "AISi" name of SMB2_CREATE_ALLOCATION_SIZE in MS-SMB2
> specification is a typo. cifs/ksmbd have been using this wrong name from
> MS-SMB2. It should be "AlSi". Also It will cause problem when running
> smb2.create.open test in smbtorture against ksmbd.

I see only ksmbd using it.

> Cc: stable@vger.kernel.org
> Fixes: 12197a7fdda9 ("Clarify SMB2/SMB3 create context and add missing ones")
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/smb/common/smb2pdu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good,

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
