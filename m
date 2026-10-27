Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793119696;
	b=AWXkCMNFyWXRmPzpRn7HHQyi3msVmQknAyImTfDJ5QSM4LI/gJJFZOQ6naWe5Pl4djcz
	 cw9u0nWXdn1ej+vGhADuKnKYUCl6Rhq5uEqH3QMOrEhHEMRrN8xrZZ25kw7Nq0ELjkTQs
	 AIU2Rx7yh/lF/JvxxPsm1OFdkBb7JSL19DdbrAIHXYCRKuWrdJOHofmPPKFYnb61Gu6IU
	 gpcT6x6xQDOk+F1AfhyKfysgnyQ9PhN9BqavtOrqg8wwBnfdQy9e6XewhK0rbqaTc/MK+
	 qNXm6oY00HdMeCIdxuK6PDInZRefKBKYSTA2nXY8DgSJhxaIVgOwF7/3QRS/NoPAIhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793119696;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=EQjVci2hf0W6p4qb5pdX2Gom0JjwGilCqdEkj+MUey0=;
	b=VKRs2TNd0tpj4NtFxWtS8MEQLhMPWh7pNl9EzcwipmaXw/8KTrrkyUhvEMxCEDGMILOW
	 QYe6+XWg7EK3XU+Xjn64N7VbPvsx8Ez9H141y6nLC0vGETTKxpWgkhnrK2DmFkCR6ko4x
	 8TTom6/mAJWFf8uB4k8K3M8LdtlvJYdln1Cmzlm8BfzAUIjOBhSVi83jQTkMge+1ZbyJG
	 8zMAXixyHuThjNmriiZNvYsdIEdSaDW0rbGV5pkereFMW0sJPyLkXjfBk4g9QmtK+1N5y
	 6q+T77bsyeHiYNLtfVKtapHDTxgjhK+v+Tngb5FEfz6cJMwM11wxw5bGGag2y3E/PZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="AIKEZ/F1";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9EC606A31A
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 16:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA9EC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AIKEZ/F1
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c40e30c26a4so191175166b.0
        for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 09:48:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793119694; cv=none;
        d=google.com; s=arc-20260327;
        b=phiAkd+yYdZdEdDvl7Z9cw7lZvHXvzdTXjjrHdW1WVaodCqwprG6aPfd43hh6hX6jq
         x8C6zU3lq9phrWgSIZ6wuGmDfygwZe4BR5SocAS0ddqoUNsC/hjLr0W8BkuAwANHxJDW
         6OmNIua6+TiT24EsJclU9SfwoxDa4vV+0iHO3ZvGZWlNNCMZBY2qHLs5GaiMHjJlSY+f
         jw1X9f6O4gmiIPf7dToppCEzN9fjxtzB5+J64n6pKgQeOIFdxWZWHFhH0NOFJiFi/lAM
         FyEjhKrm1oS62ps6oOQsxsU5ELBUUDoQFZl5CP717Em6oL6nJHKx+oBG+bmHZ/zrhvMU
         /lTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EQjVci2hf0W6p4qb5pdX2Gom0JjwGilCqdEkj+MUey0=;
        fh=v5mHdik8NJObGK5x3DCqBLWpyoyFmd8HfZEwxJ5TX04=;
        b=dzxeLOZ8Qcn5vHantoJZMKZbsEv/lA+MFp1R4LVrAJv+a1I7D2XLPIU2zSFMhlUEc5
         C865mfF9zAhCewgqm++tp5Pg+hqQ/biJb3MoeBbVV55F82Q9uPGI746rm1qKLeISvz7U
         feMlNkON7TLAuXdmjc3ypGrqZ+HQ7LeJn1sNFHO2nxSE/nOw4UYQYabGDI8JrYo9VxEp
         Ws69cmezQhmGT7F+c8KjsRKPScRJ9kErWMSYoxbWPTUhL9xoN3qQHHfDln4blWAJucpe
         fSQ0bfkpR9zJd1jQ1/0C7biAqg1YI0QUvHxgdHsRokKsnWkF0txO9qlRjzNXE4PRHlCH
         EXmw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793119694; x=1793724494; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EQjVci2hf0W6p4qb5pdX2Gom0JjwGilCqdEkj+MUey0=;
        b=AIKEZ/F1vRctyn6m0c1CXuU/Y2L+/28iEGUArazDJUSXSCLIgstjzpoUx0YNB51RpO
         rlyGozWUvRIZRj5dzOal6yeIqh+BLfIlOVJJTtkW+7e+e+pqv79R1HTzpJTWssBdbHw/
         ms4DdHfH9P8RKd6Z6EV1cAiN2nk9YZpatX/NYcIv29QA4LSS9b05GpPCcySwE8at5qSw
         j5wophCVc0eIrslz7iJOLv8Z9ULR+JKvUCDhYQgPXEk429SV7KNarAmsOJMko2T9Bvnh
         IuPcTLBtxobr0XxiPIaUw1R1lIts4J4Z1Ygk1vvGhzgnYokGCEf7zG3hl1pzEK3fYvPR
         +CZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119694; x=1793724494;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EQjVci2hf0W6p4qb5pdX2Gom0JjwGilCqdEkj+MUey0=;
        b=2E6PPchm/3Yz5DXpTeR0oZM1s6i9UXvwEChmQGkdJfNDd1xbMSuySpIc3Z+XGLP5ri
         MD3r0q3sR2OfK9a0PlqvRYcE8xPa2keD2iKvhq+eoFn5iSOdzTSw15jVnFciaOpNEzEp
         kwwljqLzGYtFs9yaPZRXNyEU9XE6KZK+P7HBSb3zux34vPUeim3eLwGeo5wAdNtwHgwr
         2jNkkCpJqNiK6BAXDeGf79D9KZ9IV8SzoZcEJ/bhtZQZsCY1wDCmZP8Eesey3nckWJhC
         DpUGSsCbzrQ6shybsakwHTcW6taVKjwXMMm4r5uSE8ISUs3VADIhO+vRS9opXY5MMiAN
         0KbA==
X-Forwarded-Encrypted: i=1; AKwUvBxcvPBZQZVRw9Po/MHaizjAUVGhPCB6JdIVYADAdWl/N1AyE3mwl9a9AGiDgbgfbmaC5+/Y46o82SQH@vger.kernel.org
X-Gm-Message-State: AFq9FYIJMtdn388teIKAZ1m5oiIA2fmoiIW+kYEQNFdwHYvqdBy4R/7x
	vbPt4rXqy5/lnllEOkI5qS+xGeCgkAnVTc7ZU7GMs8bII1rO4zSkbr/wTJgvRbILl0JH/hRtqga
	qNZqiArGHkFbSoXtkqwDzmF9EY3TWa4M=
X-Gm-Gg: AYBFou3cumpAidX2Xb1QQrfRMMdrnmXYDMiMAjmtLwppdARZ6Fo7LF4ypbTC2EQlvjx
	y4XAcwdmEkXYUjG/r7yg3/WOET8xIhECP9KcT+iL/WEBf+rpOsi48daSnzPHJh+3VV8PawKkGqm
	0Q8+lXFji1cu38b/Y34b9NX7mhbn0OjNV5OA9wlLZD06fptZU6cmS1Kz+oj8fatn8EFDfP5oA0B
	Tf2qmyR+RcxKf+qXv8W000L6SKYQoP9c0WEtOZxtzVG3Uapg5emq0nIcVn+qX/PGgkSvfzo05vs
	JFSri6x8zdZGVawyU2QQXu/f4p+rz4XRhgLuy3nmLduGVmH536H+LEi0PH8SiEd3DARbBgXLdrN
	pqS/0zdLNCV6czmJmGk3ZZDlrT0RWBb5G/iUPe5SrcbMRr2p/UySuhXAFCvVM/VWMBJnKkwfX+o
	zzneWqTb+qAVOfpcl7UA==
X-Received: by 2002:a17:907:9494:b0:c46:9745:ac13 with SMTP id
 a640c23a62f3a-c49a7480d39mr282381866b.32.1793119693863; Tue, 27 Oct 2026
 09:48:13 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CANTrAmxiBn6GT+N5qivdf=xtGg6yFksK5qN_PhpoNdxXDSpikA@mail.gmail.com>
 <2026102733-sinner-baguette-1d07@gregkh>
In-Reply-To: <2026102733-sinner-baguette-1d07@gregkh>
From: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Date: Tue, 27 Oct 2026 23:47:59 +0700
X-Gm-Features: AclHuK-jR9KeCd4-1ulfy0atNQaFAsyObEdHdBLGJ2PEjFclYxSOA967pfi9Ni0
Message-ID: <CANTrAmys9yD+KB4Nhkqo5Z1R7vJCbyoXpizDeV6kM5YA4nEMiw@mail.gmail.com>
Subject: Re: Backport request: ksmbd and smbdirect fixes merged in 7.4-rc
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 11:44PM, Greg KH wrote:
> Why no tag?  What happened to prevent that?

For 3) that is on me. When I sent ef85bad39cf2 on 2026-10-15 the
commit it fixes, 25e414db7033, was only in 7.3-rc, so I assumed there
was no released kernel to backport to and left the tag off. 7.3 was
then released with the bug before the fix reached mainline, which is
why I am asking now.

For 1) and 2) I am the reporter, not the author, so I cannot say why
the tags were not added. Namjae and Stefan are on Cc and can answer
that. I only noticed the gap when I checked which of the fixes had
reached a stable tree.

Thanks,
Lee Seong Hyeon

On Tue, Oct 27, 2026 at 11:44=E2=80=AFPM Greg KH <gregkh@linuxfoundation.or=
g> wrote:
>
> On Tue, Oct 27, 2026 at 11:07:48PM +0700, =EC=9D=B4=EC=84=B1=ED=98=84 wro=
te:
> > ```
> > Hi,
> >
> > Please consider the following fixes, all merged into mainline during
> > the 7.4 merge window, for the stable trees listed. None of them
> > carried a Cc: stable tag.
>
> Why no tag?  What happened to prevent that?
>
> thanks,
>
> greg k-h
