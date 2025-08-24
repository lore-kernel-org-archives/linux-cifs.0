Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E8412F5A5
	for <linux-cifs@vger.kernel.org>; Sun, 24 Aug 2025 02:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756002579; cv=none; b=LmAA1XgH7fx5ESU+K+pH8tkIFZzcO3ER602dR8xpZeqQFbfGnwlY6lNuhbpT3ArG5l13kb+Sr43exMLexc3crHx5q5lmWrXQBgEMWlTLUyg5MZDS2QMr+gLjVyVujRwCOGDN9CSo/foHaiuXl/RExidCyTWktKaetcSo1rZ6hfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756002579; c=relaxed/simple;
	bh=E+TKvqF9QvhV2MSVUxkh/K8H0TagSIMgwvPsB0QopYU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=E4sGFPf4NzMoeckGS3JMSy5YtUDbgbaPBU55Z9iu+ZazT/9BfZgg8Qjgd14Zm2dayAKoQJXMnyISkioc7+amNM5hFiIB6TIJfI2rK/q0VTDjZyG5BIkGCN7Wxe9h4kiHx2yUR9cIP+ew43BXrnRf8trsUd4z9hng+Tv67IKtl0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKH/8I15; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKH/8I15"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-70d93f579fdso21860936d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 23 Aug 2025 19:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756002576; x=1756607376; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YWYoctmURaLTOb5MBEKCUj59vUPi5jpIUVDshcozoBI=;
        b=AKH/8I15gMZCxGRtDr8ylVdfTeZ0RNb78t2cPYVY5YQaR2yDFvc1jOjvmcmeIY8dnp
         V6t88ZPiJrKX2Rh1L6dFkjjTlb92a7YPcul33Kr5sy0xXRUykpSwlGEg/3c9myEoFphm
         pSPcrkyLU4uLLxvE0du81ykllvwbX3V+eabb6KfiabDobzatZkBrUNvIoMfbDPFijveQ
         r9DuLgVOcUavpn3DiQckjcq2yfOP4JFg+FZJ1UFfTkUqbrzQx9K2jXJPq8LYh7TYmAZB
         vW3nFc8yDYvbPZ3vx01u0y/5dFmG7cc/ghbABDwDOu4drwjANXri/14ynwHLn7s+sf4a
         sXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756002576; x=1756607376;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YWYoctmURaLTOb5MBEKCUj59vUPi5jpIUVDshcozoBI=;
        b=kghtoj2POwf7hJOE8NIpPUp3fUdkdHxsMO9eWCuM3O+aSyBbDYT5ROh4dk6Nw2Vsgk
         lcgKD9eXlKx/6c2eoJFLic6CjBMs2Cpw8kVcgxaH47NJZu0RU5/zKdo5glS9Id8CBqOJ
         ajtL/unBaFSNkUnxZIZ0SHoWkI85ajzAk6ATROD8eAGy1QS76+kbdbY3IGaQE3qGV4xe
         0DR/TRNmIE59s0V7PZeV5qeHHiWXfdcANPzrM9xYf1BFanJp8nKOzl/2F+P2u9BgKwgG
         L1iv//dy0r+2gs68tgNE3weOjw80VxtYlw1QOkgdwaH7mkjsDhku4zVjmg8WbibjQIQb
         W9gw==
X-Gm-Message-State: AOJu0YwWtjl8YYClRnH+vFmUxPfX0EzRruL3JiMmohXLb+WvInW0Ilfl
	Nr5qKcK59vN6GVH15r0TrwFOpRV/cEizguo5XpsUYkCeL9Co+uBcMr57GaFKMBuVUDZ7pGJiDEo
	LMiYj009XQiOYu/cPYCWbMBbUNMJqfhP8bWIA
X-Gm-Gg: ASbGnctIH0NVT8GLmTcOCGZR0zXfrianiXaulHd6VusnUzM0lCVcqtPSo3mlu8FnlrG
	Y8sKEoMzUVV4bacVn98mocaZPVEOiRhU4z9aCgfYYt2n1n2qOu9FcYlrV/9seOLagWKqvyybDJd
	2W/gqHCVKdPR4Sv9sQsL9xVLDZGwwzpRcwNngS5NgiRWw9QfQedpI0yjgXTd0y1UILl7cP+Rn4m
	yz3GQtDGJHrwZhFeP4M0suZQHwIL/c2DzdrNBXdeOuo32TAq4Z84Xjhpno=
X-Google-Smtp-Source: AGHT+IEsJ57nkeIF3HT7PqM7T5bRGVaTMCt+5dNETIQ+opqHvvDBr2lj+Uwepq1xJ4EbueQHEmh6QhOI2eY/FyAFbUQ=
X-Received: by 2002:a05:6214:21cd:b0:709:f305:705d with SMTP id
 6a1803df08f44-70d9722c613mr96611336d6.19.1756002576245; Sat, 23 Aug 2025
 19:29:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 23 Aug 2025 21:29:24 -0500
X-Gm-Features: Ac12FXwZPwo_7Fmi8_yCb1tjvU2PmHOL1VnizxW6ut2nQNBeoSpsO3SVSYEiBHE
Message-ID: <CAH2r5msoo=8URS+thrOxYs9-PLW96w8vT6kQUeePcBU21-Rm6Q@mail.gmail.com>
Subject: [PATCH][SMB3 client] fix copy_file_range() return codes to fix
 generic/157 test
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c8423e063d1335d8"

--000000000000c8423e063d1335d8
Content-Type: text/plain; charset="UTF-8"

We were returning -EOPNOTSUPP for various remap_file_range cases
but for some of these the copy_file_range_syscall() requires -EINVAL
to be returned (e.g. where source and target file ranges overlap and
source and target are the same file). This fixes xfstest generic/157
which checks various reflink return codes and which was expecting
EINVAL for that (and also e.g. for when the src
offset is beyond end of file).

See attached

-- 
Thanks,

Steve

--000000000000c8423e063d1335d8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-client-fix-return-code-mapping-of-remap_file_ra.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-client-fix-return-code-mapping-of-remap_file_ra.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mep2jtom0>
X-Attachment-Id: f_mep2jtom0

RnJvbSBjNWIxYmYxMGQ3ZTQ0MTk2OWEyMWJhYjUzNTNhZGMyNzBiYTg1YTFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMjMgQXVnIDIwMjUgMjE6MTU6NTkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzIGNsaWVudDogZml4IHJldHVybiBjb2RlIG1hcHBpbmcgb2YgcmVtYXBfZmlsZV9yYW5nZQoK
V2Ugd2VyZSByZXR1cm5pbmcgLUVPUE5PVFNVUFAgZm9yIHZhcmlvdXMgcmVtYXBfZmlsZV9yYW5n
ZSBjYXNlcwpidXQgZm9yIHNvbWUgb2YgdGhlc2UgdGhlIGNvcHlfZmlsZV9yYW5nZV9zeXNjYWxs
KCkgcmVxdWlyZXMgLUVJTlZBTAp0byBiZSByZXR1cm5lZCAoZS5nLiB3aGVyZSBzb3VyY2UgYW5k
IHRhcmdldCBmaWxlIHJhbmdlcyBvdmVybGFwIGFuZApzb3VyY2UgYW5kIHRhcmdldCBhcmUgdGhl
IHNhbWUgZmlsZSkuIFRoaXMgZml4ZXMgeGZzdGVzdCBnZW5lcmljLzE1Nwp3aGljaCB3YXMgZXhw
ZWN0aW5nIEVJTlZBTCBmb3IgdGhhdCAoYW5kIGFsc28gZS5nLiBmb3Igd2hlbiB0aGUgc3JjCm9m
ZnNldCBpcyBiZXlvbmQgZW5kIG9mIGZpbGUpLgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcK
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL3NtYi9jbGllbnQvY2lmc2ZzLmMgfCAxNCArKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5n
ZWQsIDE0IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNmcy5j
IGIvZnMvc21iL2NsaWVudC9jaWZzZnMuYwppbmRleCAzYmQ4NWFiMmRlYjEuLmUxODQ4Mjc2YmFi
NCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYworKysgYi9mcy9zbWIvY2xpZW50
L2NpZnNmcy5jCkBAIC0xMzU4LDYgKzEzNTgsMjAgQEAgc3RhdGljIGxvZmZfdCBjaWZzX3JlbWFw
X2ZpbGVfcmFuZ2Uoc3RydWN0IGZpbGUgKnNyY19maWxlLCBsb2ZmX3Qgb2ZmLAogCQkJdHJ1bmNh
dGVfc2V0c2l6ZSh0YXJnZXRfaW5vZGUsIG5ld19zaXplKTsKIAkJCWZzY2FjaGVfcmVzaXplX2Nv
b2tpZShjaWZzX2lub2RlX2Nvb2tpZSh0YXJnZXRfaW5vZGUpLAogCQkJCQkgICAgICBuZXdfc2l6
ZSk7CisJCX0gZWxzZSBpZiAocmMgPT0gLUVPUE5PVFNVUFApIHsKKwkJCS8qCisJCQkgKiBjb3B5
X2ZpbGVfcmFuZ2Ugc3lzY2FsbCBtYW4gcGFnZSBpbmRpY2F0ZXMgRUlOVkFMCisJCQkgKiBpcyBy
ZXR1cm5lZCBlLmcgd2hlbiAiZmRfaW4gYW5kIGZkX291dCByZWZlciB0byB0aGUKKwkJCSAqIHNh
bWUgZmlsZSBhbmQgdGhlIHNvdXJjZSBhbmQgdGFyZ2V0IHJhbmdlcyBvdmVybGFwLiIKKwkJCSAq
IFRlc3QgZ2VuZXJpYy8xNTcgd2FzIHdoYXQgc2hvd2VkIHRoZXNlIGNhc2VzIHdoZXJlCisJCQkg
KiB3ZSBuZWVkIHRvIHJlbWFwIEVPUE5PVFNVUFAgdG8gRUlOVkFMCisJCQkgKi8KKwkJCWlmIChv
ZmYgPj0gc3JjX2lub2RlLT5pX3NpemUpIHsKKwkJCQlyYyA9IC1FSU5WQUw7CisJCQl9IGVsc2Ug
aWYgKHNyY19pbm9kZSA9PSB0YXJnZXRfaW5vZGUpIHsKKwkJCQlpZiAob2ZmICsgbGVuID4gZGVz
dG9mZikKKwkJCQkJcmMgPSAtRUlOVkFMOworCQkJfQogCQl9CiAJCWlmIChyYyA9PSAwICYmIG5l
d19zaXplID4gdGFyZ2V0X2NpZnNpLT5uZXRmcy56ZXJvX3BvaW50KQogCQkJdGFyZ2V0X2NpZnNp
LT5uZXRmcy56ZXJvX3BvaW50ID0gbmV3X3NpemU7Ci0tIAoyLjQ4LjEKCg==
--000000000000c8423e063d1335d8--
