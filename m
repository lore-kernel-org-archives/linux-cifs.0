Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8921B28E8
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2024 22:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721775061; cv=none; b=LuEWG3KDGFbk4PrP3sKC6/O/+sd4x75roWJewQ2hDzzovMcNLK4+Zn8cL5s/iyju2vRMEFPlc45CpABxz8t4mwSJEhTgf4Uo/GpegnJ4Wy6Zl/DBsD2vCOoh3Ws9Uzsz9HYUlSVQaV8rD52c/5CkKVNu8Q0YhTgVm7ynlJln2Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721775061; c=relaxed/simple;
	bh=CtHxEc4E4KZRVlOnxnTfIVbutN9U8o11Fa5y/hdNSzU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=be+DyxDa9Atz1ENedOcAdUbdu3sLEBCE/lR+dsGcsm1Bveb7CutBYtHmg8SCy+gcDuD7n7L0Q3wn7JSATV1DDqqvNP2Zkl2nKvdXv4PdDNNwrJQxqNg0G0LDIO2YgNPo8+lYS9tsxFp0CRYEc6mWQNcudqQFX6zqEui5tiXK4vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QDaq0U04; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QDaq0U04"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52efd855adbso4799077e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2024 15:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721775058; x=1722379858; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ES59BCfEuAfxXID0F6oW+II6SH5dXpK5Bso9en7P/4M=;
        b=QDaq0U04kKOZP1NIyA2ubQEzFkZdoOvdud+fjZw2CmFc/CW8UP8aVgA9uFgOcsAYYW
         Sp6A5cp3uwdtEjK43cN6Eh+qhyl4Mifhf4bZ8MdiZ+Qm8uObTC+ODp0BhjsHc5tUfFsW
         3Ka7F1x7YlLU0QfJdraVNiqqA+SND1zsoLse13fA+PR2MaLDvL/tFKnyh2pIZvZ7tFaY
         /XuF8ju+FyyXlam8B90qERBWSxNaboKS9shIAIWxHfoYzZTOrphEGnQP1fIBLWq8ooYU
         o6Bnys40QgJAtOOVYUo/wsiuKpGupw5HGi9+m207A+XIh1crasdx5BhSd9gdrAmRgoR9
         7M+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721775058; x=1722379858;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ES59BCfEuAfxXID0F6oW+II6SH5dXpK5Bso9en7P/4M=;
        b=nTTTtWG8qVLO25UoEYpToCLn8RD8/X5H1U4X9Q8+IYIkXKBhK2K96lVaJhwZXY7DD3
         ILhYiISaJCZCFJgoO+5Td29n4UczQgqM0V6sOWH+NY2qzS1RGR96Qm5qFUGodCu3bjxH
         yEh/j4ET75DHhbkblHwMIQyAVre34tukWt0sOEHEa7pinmc5KHcjdALjmUyWa2tSX3pv
         SKW6nTz4DtucjlySQ22tydFkL7DC0vFBwjdKvfR8fuNOInpVVy8Yb8SIpzDGzvNKxCB0
         s1YgRdQ1ydBZjuR7x5+Xxv7g80tu3AslHy1ay9NSjdSxQ+KoFIW4rbWott99pyroztOg
         DBYg==
X-Forwarded-Encrypted: i=1; AJvYcCUOnmWqCe7ZkUtC90K6TG0D4AhqZPMW3ix0h3+yROEm5lKD6L+jqoGbE2z4jcKg1B65BhETIfXLD5qdYqhMlC5k9mKch+oNqWo9dg==
X-Gm-Message-State: AOJu0YwbhtZ6NNhzNSFwiKhTlQ1btq/pDnkxSFbpSNGGqyWRAHQENls/
	0XhryvqEHA/4yJ5WUKCAwUKiLjbSPFgBF7QFEnZbPtprKACUBPKLkZ+56HbSEkNFjOpOOuXEVwV
	RpGaoAumscEoeAknFfBvbsug7DnA=
X-Google-Smtp-Source: AGHT+IGyoPW8W2ZIVH4om3vY67WuHjE9OA4VsnmQGKnBi270ljt/ok4VRrS7XbofCa0WIsndrUHIvaMkofb4h/tKSmw=
X-Received: by 2002:a05:6512:2204:b0:52c:dbe7:cfd5 with SMTP id
 2adb3069b0e04-52fcf000c42mr177660e87.32.1721775057566; Tue, 23 Jul 2024
 15:50:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu2LTRDPX7KbM3V_d7FybuPnvCMRd6YV3__H-7mn1N9uA@mail.gmail.com>
In-Reply-To: <CAH2r5mu2LTRDPX7KbM3V_d7FybuPnvCMRd6YV3__H-7mn1N9uA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jul 2024 17:50:46 -0500
Message-ID: <CAH2r5muHFV8D2+SrDKQiUSkxzDfAG4zJ3rUdQnBXDT12u5D2Ww@mail.gmail.com>
Subject: Re: [PATCH][CIFS] fix reconnect with SMB1 Unix Extensions
To: Andrew Bartlett <abartlet@samba.org>, samba-technical <samba-technical@lists.samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>, Kevin Ottens <kevin.ottens@enioka.com>
Cc: Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="000000000000b0bb5a061df1fe34"

--000000000000b0bb5a061df1fe34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated to add missing #ifdef


On Tue, Jul 23, 2024 at 12:07=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> Andrew had pointed out having problems with SMB1 Unix extensions to
> Samba when investigating an unrelated problem, and when I tried it I
> noticed a serious reconnect issue with the SMB1 Unix Extensions.
>
> When mounting with the SMB1 Unix Extensions (e.g. mounts
> to Samba with vers=3D1.0), cifs.ko reconnects no longer reset the
> Unix Extensions (SetFSInfo SET_FILE_UNIX_BASIC) after tcon so most
> operations (e.g. stat, ls, open, statfs) will fail continuously
> with:
>         "Operation not supported"
> if the connection ever resets (e.g. due to brief network disconnect)
>
> Fix attached
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000b0bb5a061df1fe34
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-cifs-fix-reconnect-with-SMB1-UNIX-Extensions.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-fix-reconnect-with-SMB1-UNIX-Extensions.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lyz0egn50>
X-Attachment-Id: f_lyz0egn50

RnJvbSBhMjE0Mzg0Y2UyNmI2MTExZWE4YzhkNThmYTgyYTFjYTYzOTk2YzM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjIgSnVsIDIwMjQgMjM6NDA6MDggLTA1MDAKU3ViamVjdDogW1BBVENIIDIv
M10gY2lmczogZml4IHJlY29ubmVjdCB3aXRoIFNNQjEgVU5JWCBFeHRlbnNpb25zCgpXaGVuIG1v
dW50aW5nIHdpdGggdGhlIFNNQjEgVW5peCBFeHRlbnNpb25zIChlLmcuIG1vdW50cwp0byBTYW1i
YSB3aXRoIHZlcnM9MS4wKSwgcmVjb25uZWN0cyBubyBsb25nZXIgcmVzZXQgdGhlClVuaXggRXh0
ZW5zaW9ucyAoU2V0RlNJbmZvIFNFVF9GSUxFX1VOSVhfQkFTSUMpIGFmdGVyIHRjb24gc28gbW9z
dApvcGVyYXRpb25zIChlLmcuIHN0YXQsIGxzLCBvcGVuLCBzdGF0ZnMpIHdpbGwgZmFpbCBjb250
aW51b3VzbHkKd2l0aDoKICAgICAgICAiT3BlcmF0aW9uIG5vdCBzdXBwb3J0ZWQiCmlmIHRoZSBj
b25uZWN0aW9uIGV2ZXIgcmVzZXRzIChlLmcuIGR1ZSB0byBicmllZiBuZXR3b3JrIGRpc2Nvbm5l
Y3QpCgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpSZXZpZXdlZC1ieTogUGF1bG8gQWxjYW50
YXJhIChSZWQgSGF0KSA8cGNAbWFuZ3VlYml0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJl
bmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY29ubmVjdC5j
IHwgMTcgKysrKysrKysrKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMgYi9m
cy9zbWIvY2xpZW50L2Nvbm5lY3QuYwppbmRleCA3YTE2ZTEyZjVkYTguLjg5ZDlmODZjYzI5YSAx
MDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMKKysrIGIvZnMvc21iL2NsaWVudC9j
b25uZWN0LmMKQEAgLTM2ODYsNiArMzY4Niw3IEBAIGludCBjaWZzX21vdW50KHN0cnVjdCBjaWZz
X3NiX2luZm8gKmNpZnNfc2IsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkKIH0KICNlbmRp
ZgogCisjaWZkZWYgQ09ORklHX0NJRlNfQUxMT1dfSU5TRUNVUkVfTEVHQUNZCiAvKgogICogSXNz
dWUgYSBUUkVFX0NPTk5FQ1QgcmVxdWVzdC4KICAqLwpAQCAtMzgwNywxMSArMzgwOCwyNSBAQCBD
SUZTVENvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkJ
ZWxzZQogCQkJdGNvbi0+RmxhZ3MgPSAwOwogCQljaWZzX2RiZyhGWUksICJUY29uIGZsYWdzOiAw
eCV4XG4iLCB0Y29uLT5GbGFncyk7Ci0JfQogCisJCS8qCisJCSAqIHJlc2V0X2NpZnNfdW5peF9j
YXBzIGNhbGxzIFFGU0luZm8gd2hpY2ggcmVxdWlyZXMKKwkJICogbmVlZF9yZWNvbm5lY3QgdG8g
YmUgZmFsc2UsIGJ1dCB3ZSB3b3VsZCBub3QgbmVlZCB0byBjYWxsCisJCSAqIHJlc2V0X2NhcHMg
aWYgdGhpcyB3ZXJlIG5vdCBhIHJlY29ubmVjdCBjYXNlIHNvIG11c3QgY2hlY2sKKwkJICogbmVl
ZF9yZWNvbm5lY3QgZmxhZyBoZXJlLiAgVGhlIGNhbGxlciB3aWxsIGFsc28gY2xlYXIKKwkJICog
bmVlZF9yZWNvbm5lY3Qgd2hlbiB0Y29uIHdhcyBzdWNjZXNzZnVsIGJ1dCBuZWVkZWQgdG8gYmUK
KwkJICogY2xlYXJlZCBlYXJsaWVyIGluIHRoZSBjYXNlIG9mIHVuaXggZXh0ZW5zaW9ucyByZWNv
bm5lY3QKKwkJICovCisJCWlmICh0Y29uLT5uZWVkX3JlY29ubmVjdCAmJiB0Y29uLT51bml4X2V4
dCkgeworCQkJY2lmc19kYmcoRllJLCAicmVzZXR0aW5nIGNhcHMgZm9yICVzXG4iLCB0Y29uLT50
cmVlX25hbWUpOworCQkJdGNvbi0+bmVlZF9yZWNvbm5lY3QgPSBmYWxzZTsKKwkJCXJlc2V0X2Np
ZnNfdW5peF9jYXBzKHhpZCwgdGNvbiwgTlVMTCwgTlVMTCk7CisJCX0KKwl9CiAJY2lmc19idWZf
cmVsZWFzZShzbWJfYnVmZmVyKTsKIAlyZXR1cm4gcmM7CiB9CisjZW5kaWYgLyogQ09ORklHX0NJ
RlNfQUxMT1dfSU5TRUNVUkVfTEVHQUNZICovCiAKIHN0YXRpYyB2b2lkIGRlbGF5ZWRfZnJlZShz
dHJ1Y3QgcmN1X2hlYWQgKnApCiB7Ci0tIAoyLjQzLjAKCg==
--000000000000b0bb5a061df1fe34--
