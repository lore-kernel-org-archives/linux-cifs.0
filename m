Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3AD5BAEA
	for <linux-cifs@vger.kernel.org>; Wed,  6 Mar 2024 07:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709709089; cv=none; b=TGcaqaiKlyCHw8QtyKBw4tbKb7/GichEnAFMeDmVNDxSBrzCdZdZZQWGcJbZVJOrhyRsiJY/OWnW8d8dmW4rhcmIzeFw5VcEJBBIRKuwS39M77c6EQl9NqG3YNJWh7ow8BBmlz8XyppCqB2krVmncQl6L1GC+sIQKYLAcw6tW20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709709089; c=relaxed/simple;
	bh=MX8gRFsiH0PC3cSA3oXE/j6ZLY/xwh3uHCeUt64jUKg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gWvmHm4ex0hHHoaHLQVCEOAvnnT1EH3q2wHHVAYX4bV58MJTz9xGXWXFGSoUJzqhzA/JN2MOw/pKL5jKl1Kx6+HZwzvOByM7tRWPzw5woG+rCFlhPqBupQMnpi+yBHJDyaD0FND33nZYdwB4JPjEwnKZoMlfkzTJJLLoHrcEqwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=efc7E9tH; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="efc7E9tH"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d29aad15a5so83539651fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2024 23:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709709085; x=1710313885; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8J3DkEstVgcwqYqRiZthYww5Y5k2vKqSegj5AlFKN5o=;
        b=efc7E9tHUOLPeS9FAptHkv7+j/3OKhFNIXL6UwoQDWajtJxrTfBEHIxklO6ASS7KH4
         FT9bRGs02G3XGQXbGTnk958//mFUkGq7V0wYMsOTbMssdR1v5n6ajYdJILkNEQOOen/3
         t9ytdG2+AYmz07rKm7Bk8Mcza9vhzAu1IQFDwC+JJT+WC4jtz7zdsVP8viniP7IHwTqR
         F+1OoH0GDMdUHZXO3IV6CF7ZWrLB/6xW9MeC2HWV3mFttlfusnHvqMaGhXThz0CosKC0
         hQo/IJiff2HLrVpBNgmrrx//xveX+2vk1Cv1Jc7x+k20mcDXO6NU89eTJRQ66Vwgmucl
         Rryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709709085; x=1710313885;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8J3DkEstVgcwqYqRiZthYww5Y5k2vKqSegj5AlFKN5o=;
        b=lU6FjpR9WMJNSqwOKeQoXT87is4IxyzEJng5ynMCLwFvS7vMpMyJEc8meSS8ht/XYB
         K4hujYXcXcfGDoPQlhCs4FbhZD8CvCYQ82n0zL+6Yfis/xx2gj2M13T5iMv1rncs2SSh
         mRwdKXZ2atyFA7b2ZCq0E/LgGtDf+kVgQ4DcycdxwFVlvsJyiSlMNAb5QLOgykgO7bvY
         6YJi/DaMYzP9fYGiJCMuW/T3F3Ftlf6wTLiVOHMLVPyFLndHNDvQlhf3NWRqtRRBBM/y
         cXfovm65VJ06i0K6SyYrsrHldpD3TWjoMzHM1dWgHx3GHU1dQ69H1fBNtuSDm9PrmfNY
         BDPw==
X-Gm-Message-State: AOJu0YzZBOG82iW4rOT/RQXdMItFrJsXW2QaYm4o27U2luWBbr63XuwN
	D0B5DFceU+4LjLKqPinjxQ9B1Q4tjElUgWJRh6sDKiyyIguenxxa7Y2DoLxzl8rcSoNombxeii1
	b5dB9U3cXXqY1ABWk4IRDHl1mpCNd17BiG3cLRw==
X-Google-Smtp-Source: AGHT+IHZPTphlt7ACCBZ6PGXWtHW5k15WJS4AcznYYtRMH4Rq4mrg0fBivLbXbHGfoDowSU2LLXB0kQlAcf/KA35448=
X-Received: by 2002:a2e:99d5:0:b0:2d3:f095:ff2a with SMTP id
 l21-20020a2e99d5000000b002d3f095ff2amr2610543ljj.47.1709709085297; Tue, 05
 Mar 2024 23:11:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 6 Mar 2024 01:11:13 -0600
Message-ID: <CAH2r5mss9gPr8DQqXBaUG3xaKYf85tzV6yziKEL+CQq2de70CQ@mail.gmail.com>
Subject: [PATCH][SMB3 client] add dynamic trace point for ioctl
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Bharath S M <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000b2e9800612f8aa1d"

--000000000000b2e9800612f8aa1d
Content-Type: text/plain; charset="UTF-8"

 smb3: add dynamic trace point for ioctls

It can be helpful in debugging to know which ioctls are called to better
correlate them with smb3 fsctls (and opens).  Add a dynamic trace
point to trace ioctls into cifs.ko (see attached)

Here is sample output:

            TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
               | |         |   |||||     |         |
 new-inotify-ioc-90418   [001] ..... 142157.397024: smb3_ioctl: xid=18
fid=0x0 ioctl cmd=0xc009cf0b
 new-inotify-ioc-90457   [007] ..... 142217.943569: smb3_ioctl: xid=22
fid=0x389bf5b6 ioctl cmd=0xc009cf0b

-- 
Thanks,

Steve

--000000000000b2e9800612f8aa1d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-trace-point-for-ioctls.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-trace-point-for-ioctls.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ltfgmy940>
X-Attachment-Id: f_ltfgmy940

RnJvbSA4OWRmYzJlM2E0OWJmZDdhNzVmMTM5OGFiMTk0YTk5OGY5ZDU1NGRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgNiBNYXIgMjAyNCAwMTowMzo1OSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFkZCBkeW5hbWljIHRyYWNlIHBvaW50IGZvciBpb2N0bHMKCkl0IGNhbiBiZSBoZWxwZnVs
IGluIGRlYnVnZ2luZyB0byBrbm93IHdoaWNoIGlvY3RscyBhcmUgY2FsbGVkIHRvIGJldHRlcgpj
b3JyZWxhdGUgdGhlbSB3aXRoIHNtYjMgZnNjdGxzIChhbmQgb3BlbnMpLiAgQWRkIGEgZHluYW1p
YyB0cmFjZSBwb2ludAp0byB0cmFjZSBpb2N0bHMgaW50byBjaWZzLmtvCgpIZXJlIGlzIHNhbXBs
ZSBvdXRwdXQ6CgogICAgICAgICAgICBUQVNLLVBJRCAgICAgQ1BVIyAgfHx8fHwgIFRJTUVTVEFN
UCAgRlVOQ1RJT04KICAgICAgICAgICAgICAgfCB8ICAgICAgICAgfCAgIHx8fHx8ICAgICB8ICAg
ICAgICAgfAogbmV3LWlub3RpZnktaW9jLTkwNDE4ICAgWzAwMV0gLi4uLi4gMTQyMTU3LjM5NzAy
NDogc21iM19pb2N0bDogeGlkPTE4IGZpZD0weDAgaW9jdGwgY21kPTB4YzAwOWNmMGIKIG5ldy1p
bm90aWZ5LWlvYy05MDQ1NyAgIFswMDddIC4uLi4uIDE0MjIxNy45NDM1Njk6IHNtYjNfaW9jdGw6
IHhpZD0yMiBmaWQ9MHgzODliZjViNiBpb2N0bCBjbWQ9MHhjMDA5Y2YwYgoKU2lnbmVkLW9mZi1i
eTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGll
bnQvaW9jdGwuYyB8ICA1ICsrKysrCiBmcy9zbWIvY2xpZW50L3RyYWNlLmggfCAzMiArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAzNyBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9pb2N0bC5jIGIvZnMvc21iL2NsaWVudC9p
b2N0bC5jCmluZGV4IGUyZjkyYzIxZmZmNS4uYzAxMmRmZGJhODBkIDEwMDY0NAotLS0gYS9mcy9z
bWIvY2xpZW50L2lvY3RsLmMKKysrIGIvZnMvc21iL2NsaWVudC9pb2N0bC5jCkBAIC0zNDUsNiAr
MzQ1LDExIEBAIGxvbmcgY2lmc19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsIHVuc2lnbmVkIGlu
dCBjb21tYW5kLCB1bnNpZ25lZCBsb25nIGFyZykKIAl4aWQgPSBnZXRfeGlkKCk7CiAKIAljaWZz
X2RiZyhGWUksICJjaWZzIGlvY3RsIDB4JXhcbiIsIGNvbW1hbmQpOworCWlmIChwU01CRmlsZSA9
PSBOVUxMKQorCQl0cmFjZV9zbWIzX2lvY3RsKHhpZCwgMCwgY29tbWFuZCk7CisJZWxzZQorCQl0
cmFjZV9zbWIzX2lvY3RsKHhpZCwgcFNNQkZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCwgY29tbWFu
ZCk7CisKIAlzd2l0Y2ggKGNvbW1hbmQpIHsKIAkJY2FzZSBGU19JT0NfR0VURkxBR1M6CiAJCQlp
ZiAocFNNQkZpbGUgPT0gTlVMTCkKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvdHJhY2UuaCBi
L2ZzL3NtYi9jbGllbnQvdHJhY2UuaAppbmRleCBjZTkwYWUwZDc3ZjguLmY5YzFmZDMyZDBiOCAx
MDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC90cmFjZS5oCisrKyBiL2ZzL3NtYi9jbGllbnQvdHJh
Y2UuaApAQCAtMTAzMiw2ICsxMDMyLDM4IEBAIERFRklORV9FVkVOVChzbWIzX3Nlc19jbGFzcywg
c21iM18jI25hbWUsICBcCiAKIERFRklORV9TTUIzX1NFU19FVkVOVChzZXNfbm90X2ZvdW5kKTsK
IAorREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX2lvY3RsX2NsYXNzLAorCVRQX1BST1RPKHVuc2ln
bmVkIGludCB4aWQsCisJCV9fdTY0CWZpZCwKKwkJdW5zaWduZWQgaW50IGNvbW1hbmQpLAorCVRQ
X0FSR1MoeGlkLCBmaWQsIGNvbW1hbmQpLAorCVRQX1NUUlVDVF9fZW50cnkoCisJCV9fZmllbGQo
dW5zaWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQoX191NjQsIGZpZCkKKwkJX19maWVsZCh1bnNp
Z25lZCBpbnQsIGNvbW1hbmQpCisJKSwKKwlUUF9mYXN0X2Fzc2lnbigKKwkJX19lbnRyeS0+eGlk
ID0geGlkOworCQlfX2VudHJ5LT5maWQgPSBmaWQ7CisJCV9fZW50cnktPmNvbW1hbmQgPSBjb21t
YW5kOworCSksCisJVFBfcHJpbnRrKCJ4aWQ9JXUgZmlkPTB4JWxseCBpb2N0bCBjbWQ9MHgleCIs
CisJCV9fZW50cnktPnhpZCwgX19lbnRyeS0+ZmlkLCBfX2VudHJ5LT5jb21tYW5kKQorKQorCisj
ZGVmaW5lIERFRklORV9TTUIzX0lPQ1RMX0VWRU5UKG5hbWUpICAgICAgICBcCitERUZJTkVfRVZF
TlQoc21iM19pb2N0bF9jbGFzcywgc21iM18jI25hbWUsICBcCisJVFBfUFJPVE8odW5zaWduZWQg
aW50IHhpZCwJICAgICBcCisJCV9fdTY0IGZpZCwJCSAgICAgXAorCQl1bnNpZ25lZCBpbnQgY29t
bWFuZCksCSAgICAgXAorCVRQX0FSR1MoeGlkLCBmaWQsIGNvbW1hbmQpKQorCitERUZJTkVfU01C
M19JT0NUTF9FVkVOVChpb2N0bCk7CisKKworCisKKwogREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIz
X2NyZWRpdF9jbGFzcywKIAlUUF9QUk9UTyhfX3U2NAljdXJybWlkLAogCQlfX3U2NCBjb25uX2lk
LAotLSAKMi40MC4xCgo=
--000000000000b2e9800612f8aa1d--
