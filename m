Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794706497;
	b=CHx00db2SocuYC+CZTGorzh1O9ZVjaTdFkdbK2+niQjFrsZJPioTt1IkerPfZoj9Z6In
	 LdQqDTLxi99ZkY5U1dDQGk11moBepi0vb8Yo0uaF8Yt2puZC3fOMrOHjUVKdNonHj/rNI
	 7DlmvQ7Z5ZaNGJsxsbnBa1mHRBxyV+GaTI7N4fffYiZ/x59YGGoV70jTELtQfTw3EA3JC
	 gHtp+bADRHrIrJCvUG1ySJlUdrwGemS44Q/Am2lYfXufmtouc9ET5/+lqVrV92uJ2Qt9N
	 7d1o7SeeYrM2WTuCDm/SKWUuUt8XpLSHlOltYGtGEvK3E5P8WinbwNLZMNsy6mXbMNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794706497;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:X-Mailer:
	 References:In-Reply-To;
	bh=OMlLqSrjy+6LHFtfcGTg2faXloa2fdF0Up8sQHmX++U=;
	b=mikfAET/Q9Ti0nqJ4loMDjzCuKjO72L6aegkmg/uwlyEf7UYTwkXM2lQzZJkl821xqBq
	 0TbC+cEHfW0Swcp3bJDUe31boEuacEjymylWE22jB9zSlkzwiICFh+un8OTjpuJjNWTQ3
	 QES1LfxtllmoN/gCSSvE2VUt0+Di8N/CqyeKvlFT2t1RLKTdQkrU24gJuL2qsFYVNxyos
	 B34VIo5Y8vDXfMuSLQnAQFZLL5BFBS4kVwX7EbJR3zKb9SJuT6i3nFH4YJO1gOlLUZaAw
	 rSxB/qK1IGO5xS3PNCP9EnLUHlDpQEi8TnkX7KdunZhnDzREOxBSE3vDgt/XmEQwrAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NH91V7uH;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930E0606A327
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 01:34:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 930E0606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NH91V7uH
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so18141315e9.1
        for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 17:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794706495; x=1795311295; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OMlLqSrjy+6LHFtfcGTg2faXloa2fdF0Up8sQHmX++U=;
        b=NH91V7uHVhn4uThEXEM9hHqDiasPPqpuxi+21pKdirqLLIOHH4Yfp7qfsfVNoAx7V1
         7u9TM3geCmMP5fv1vknYHs9ftD0PpWWcNLKQvzevKIFafFsUSg5K8hbjrqtC+vdDBrnB
         gv4hzDTjOOpU1zWnFV/KgaPQX154tMKD6Yph+OYYePWqkv0tdKQVZeyTikq+v6XrrrMh
         sRJIUpp4l7mKu8u3g9NIblJZLl6CHsNSuYWMwFrAYpAwIbIsaFCdhZCb/H1kkSm6dRt2
         sdusnXONVx3bBUkali5uIGRvHdaWAl71JEslGKTRgur+cCBNrGO31Pq+yCMUux08xHi1
         nQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794706495; x=1795311295;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OMlLqSrjy+6LHFtfcGTg2faXloa2fdF0Up8sQHmX++U=;
        b=xioBr91oC/cJlZRFI+R8rfWjo7Cb69D4Ejjl0862QLmkh7cvR+rTxw6DjjKLDhnkFi
         yadSC95J5lxJKcwBkKmlcrvOgqzNzGxlqpHu/xLM0P8LLVygTmI9WRaqQTQbVy9JxnCG
         A4d1av1y40dfysENIuSXDaktMMZ9of1WXoLcTCoDt0Kop6PyWyf3tizmT2i7atxULqEJ
         hDUFWlKrCCiUAXk73OY3xxmVVkf4h028xrqUMqGVydLtImgUoG6Nh4gLrKJ+g2HLfp07
         qaK6dYW1C1I8zuS8HFjd02EzC+6pFD5m3BASmg7pftwpdzujgq0i0ZgDtdL1aFeEry4l
         YZ1w==
X-Forwarded-Encrypted: i=1; AL+hErGJcO/TTpiyRDLErhvK5Q040JjEDN9stusJYhtr7WBsm3Zay8Kkr1RwFX2q6zBYBAfrdAiSV3MqDsDb@vger.kernel.org
X-Gm-Message-State: APuU4Z9yM9iiaTLi6BxC4e+j68gQfaVYrbMSauzOw0edYTnzEekyPRyY
	yfVbrfn18GiztL3hBl+OOyz7KZYi2tdOm8oUqvuSfDYnNhFlIlPGUc+z
X-Gm-Gg: AYBFou13F0ck5k4z1f6fQcREMP44tpIoslJq5uobSbhJmy3Fk7wnQzS/AtbyOIKmIj6
	175C9Z9Wmo51re2jbqnd3ydlE4fjvZ/peNpmOJ2e8aYC2Q7hu55XbjljcoKEeioIRKa9mSNq+Hx
	DtG7iEcjYhhUjiK3A2mO2Sz8CHtMpezoKsDrSLfbsSi9jwI69IMG5WXqVrPXkntaU1k4M8ycB7i
	Fy5yNBJ5kxMjql7LuFvMtASwHXIhpcsnes/ksiprK3IKTlDE/3J9cZYbcUpZUFRX1zOC+gF6VaX
	MXhPU56ePpZzTy3wDIKZi5K/0iZyzbwJfZMX0jwPS4x8xVtp9TcRPmRKS51krx2iV4k1eEB6el3
	4vaw1L4TQdZqlbJb0+6G2sGRuZQhmASQVyM+mrcmBHRkofQyvSBXMxzxDd9LFkUQNNe54SOBnQU
	7dgQVOArqbes6QGLq+7ZAFHpc6VKYlnG+/RXIhpnfnFtSJpr1iDDjF8JQjtqHNcILjdRc333A6R
	tk5C7SwHLwn4gB+tHW0V6ORhZ8gXorBNTZ1iaTGb6o8MzKXHTUhCcoPWkWkOXahErTJulphbhHz
	JMxGG/ZLH+OMvAt4tcR+ti1baTK++y7+o/fFPXH4OEMArrg=
X-Received: by 2002:a05:600c:2784:b0:4a1:d49e:9ce with SMTP id 5b1f17b1804b1-4bb4e2918b1mr192482965e9.2.1794706494729;
        Sat, 14 Nov 2026 17:34:54 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8c248sm13643520f8f.58.2026.11.14.17.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 17:34:52 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=7778e8827e5f90a3e7c9592d930e9c3386ae58c962b71883b69d27e225ed;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Sun, 15 Nov 2026 02:34:38 +0100
Message-Id: <DMVECM7B14I1.3GF2HZB9KRUX@gmail.com>
From: "koraynilay" <koray.fra@gmail.com>
To: "Namjae Jeon" <linkinjeon@kernel.org>, "Ian Bridges" <icb@fastmail.org>
Cc: <koray.fra@gmail.com>, <senozhatsky@chromium.org>, <tom@talpey.com>,
 <chenxiaosong@chenxiaosong.com>, <hyc.lee@gmail.com>,
 <linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ksmbd: decode and honor DOS attribute validity flags
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261114012736.639171-1-koray.fra@gmail.com>
 <20261114160332.2228435-1-icb@fastmail.org>
 <CAKYAXd_qe-dLq6o7XdJzG8orYiKRioAtfEsLjxj33Ca3=PzGjw@mail.gmail.com>
In-Reply-To: <CAKYAXd_qe-dLq6o7XdJzG8orYiKRioAtfEsLjxj33Ca3=PzGjw@mail.gmail.com>

--7778e8827e5f90a3e7c9592d930e9c3386ae58c962b71883b69d27e225ed
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Sun Nov 15, 2026 at 1:22 AM CET, Namjae Jeon wrote:
> On Sun, Nov 15, 2026 at 1:03=E2=80=AFAM Ian Bridges <icb@fastmail.org> wr=
ote:
>>
>> Hi,
>>
>> There is an existing bug that matters when enabling these checks.
>>
>> ksmbd stores DOS attributes and the client's creation time in
>> user.DOSATTRIB. The xattr also contains flags saying which fields
>> are valid. Currently, ndr_decode_dos_attr() reads the values but
>> discards those flags.
>>
>> When the sparse or compression code updates an existing xattr,
>> it writes the creation time back but sets only
>> XATTR_DOSINFO_ATTRIB. The time is still on disk, but its validity
>> flag is missing. This has not affected the reported creation time
>> because ksmbd currently reads it without checking the flag.
>>
>> Your patch preserves the flags on future updates. However, the new
>> read-side checks also apply to xattrs that ksmbd has already written.
>> Those files will stop reporting their stored creation time.
>>
>> For example, with DOS attribute storage enabled:
>>
>> 1. On the unpatched server, create a file over SMB and set its
>>    creation time to a date different from its filesystem birth time.
>> 2. Make the file sparse. Its xattr retains the requested time, but
>>    now has only XATTR_DOSINFO_ATTRIB set.
>> 3. Upgrade to the patched server and reopen the file.
>>
>> The server now reports the filesystem birth time instead of the
>> client's time. Directory listings change too. On a filesystem without
>> birth time support, the fallback is ctime.
>>
>> The affected writers are fsctl_set_sparse() and
>> __ksmbd_vfs_set_compression(). Their existing-xattr path differs from
>> the no-xattr case in the commit message: it writes flags 0x01, not
>> 0x51.
>>
>> I am not sure whether handling these old xattrs belongs in this patch
>> or in a separate one. Namjae, what do you think?
> Agreed. separate patch in the same series is fine, but the
> compatibility handling should land together with the read-side checks
> to avoid changing the creation time reported for existing files.

Hello, so I should include the legacy handling in this same patch and
separate the bugfix for sparse/compression in another one?

The problem I had found when trying this approach (I originally wanted
to send PATCH 1/2 to fix sparse/compression and 2/2 for the decode/read
fixes) is that with only the sparse/compression patch applied, ksmbd
clobbers the time on reading by reporting 0, since it doesn't check
the flags and reads the timestamp anyway.

For example:

file created on host directly
sparse through cifs/ksmbd
file's xattr's creation time is 0 (because sparse is now fixed)
allinfo reports NTTIME(0) because the reader doesn't check the flags

I also tried reversing them (so first fix decode and then
sparse/compression) but I couldn't find a good reproducer for the first
patch, as it's not really visible.

Please tell me if I wasn't clear, this patch/bug is quite confusing for
me since it touches a few bugs and they all depend on each other.
(And one fix introduces another bug fixed by the next fix).

Thanks,
koraynilay

> Thanks!
>>
>> Thanks,
>> Ian



--7778e8827e5f90a3e7c9592d930e9c3386ae58c962b71883b69d27e225ed
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCavkMLgAKCRDmj22qf5IG
XBg8AQC0NZYp9aIV0dkoPd8ASyea4rdD9tU+TEW6i8WgdDlNaQD/aIAljJtDYKLj
IcT/BByomHzQYq8tiaJH9xBykbpu/Ak=
=MVUY
-----END PGP SIGNATURE-----

--7778e8827e5f90a3e7c9592d930e9c3386ae58c962b71883b69d27e225ed--
