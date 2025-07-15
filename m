Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6671C1487F4
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 03:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550331; cv=none; b=gwnNCubbEYyJEenR+/mX7/I5aKpeuZBEtAD8IvX6NOWK7byUWBVpjFOZNQZCN3FMgiDE6VM23ytMcfdkUjDEd9kJXtxMq60+BY4JHC2X9YoTq4XQNt9Retgvljq4krF6+TYf5QnlRvK7rSeJVkkRmpoSQ03hvyexK+FZgqc3j0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550331; c=relaxed/simple;
	bh=3XH4+o2veW+WdFpMpxvm/SNkP3QBcd31Vk35YsAJ3Do=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=d5y4ZsSA+d978ma1b5WspvcK8J5b3pGdbHLxO18prGQGSQwWZCTj08jEriMpAmIYIRmCX0jEkWo1HGwvnCYkD4z0MSZRcrJvE1R1IZhbQ5Kul1HDSYYE6Pmp2cbisztpqTBFoV3pLNWHyeCyhswtxytaMfOF37rtLczxmLv2F1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X49OA6rF; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X49OA6rF"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7e0d65a87e8so234530985a.0
        for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 20:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752550328; x=1753155128; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GFmgWQvpMxPBtBq1ucsn2DJRdhKAVc7fWWLoKmb9WvQ=;
        b=X49OA6rFTN7S2qToyBdjl67AvyxVgINKtdK9EvjnW+Fn3Izhx+q2x9DxwBhkJ92bz+
         3sDavH9jZInBocHmIM788tRrqGAFXAUeLVrKz42JdEQL5k50N8fc/B04NSb/igsBSRBl
         G567ZhrHoJyx+jiVXPf5s4cIft5XTYPP7ALAk7UOhxAzKYVXpmb/kR4+UHSDo74Upqel
         Mki3d0VmFBUAICtwwZFQGqYAT2UzTMnEF4ddsUWrqfrXwjuhnkKQNe/ZOYV9ym3gLma2
         iPBCmIAlRa+NuNN8ZtmIwMQpAjfINcLmnrNJL20qr0uthutFsvwGIScW3AWDg/x5U660
         DjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752550328; x=1753155128;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GFmgWQvpMxPBtBq1ucsn2DJRdhKAVc7fWWLoKmb9WvQ=;
        b=HnyvNkkX6So9EHy8qKTyxVOWBRPse1zw1cst5U+QmmtKeUKdy06OxXN4uV0723fWEi
         fvx0YjLRUS6EW3kJN4Zw79Y51hKTlhpyuKGfupe5e6GI7QHHhLuJZbjt8sp/T7sKPrXO
         hS1PrWN+n8VdPA57TdJ7LFD2R5LEFFDVfIAVo38pTatKYTni2X7n5jdli+lP9F48ylIk
         +NmE+UtRTluSRQ5BC7lZWQm+YkfccQ9urG782cyqp2ivBeu6zmj7LEgen6YGrF8WFd7h
         GxIy00jV2qE+7bikhZIrbG0ShjvrO196iF0Djvo3JfaUICIbFwQIehCGGqUeKPZJ57vU
         cxog==
X-Gm-Message-State: AOJu0YzmLi6auVyaKCp5MiGYIQuBGoWre2tkkC/LdlJXR004qh7jywyJ
	+EouX2QAZKz8KxsOZbMcDIFIU9f3h9xgkXZELbV+RxrUXu29bN8dYplOn+ts4En9FwUu5f26Vr4
	CVU8wAT7Wo2tgJyxVlokPCnjUjJmfx3OiTmrxPAc=
X-Gm-Gg: ASbGnctPvpiyOzA0jJsoc5S/LV6gEvbILomXfWWI8wAGjkcec5x/IMA/PnMEihq9IR2
	wRTvLrktE5ttW//3vOsCn/JgUdksUrV4LNp9a6zuJGTFY1gayWY/d91gul+oMek9P+3Y/fxVgML
	Qb7NS92Owsay65J6T9r5UdFNINRptB81YwPmVeIwK0SZuX3FtMrXfblGKnaLqUmQrZi/3sdnP5+
	h09USGoL5HQoXLhcsXfYUcns2Hv9DgkImKzrpNyrg==
X-Google-Smtp-Source: AGHT+IGQ5BHrkgFepzjYp8mbMNtIeAqn2WTYFkhaulaKCik4qxPc1MCd4Z9Rx/r3PX1ClwHSUqEicDhYskcA9Yc3DaQ=
X-Received: by 2002:a05:620a:4549:b0:7e2:a47:e50e with SMTP id
 af79cd13be357-7e20a47e7cdmr1158579185a.30.1752550327833; Mon, 14 Jul 2025
 20:32:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 14 Jul 2025 22:31:56 -0500
X-Gm-Features: Ac12FXzrmLboga7OWI2YMuucTsXiG3AXGz7CTDK1uPmxzV-1mpI-ggSRZkqiFq8
Message-ID: <CAH2r5mvA3NQp8BDj_v-k3YRUR9Xe7u5XmaM_XQBP4xJts0R6bA@mail.gmail.com>
Subject: [PATCH][SMB3 client] Fix SMB311 posix special file creation to
 servers which do not advertise reparse support
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>, Paulo Alcantara <pc@manguebit.org>
Content-Type: multipart/mixed; boundary="000000000000bdf9050639ef6b0b"

--000000000000bdf9050639ef6b0b
Content-Type: text/plain; charset="UTF-8"

Some servers (including Samba), support the SMB3.1.1 POSIX Extensions
(which use reparse
points for handling special files) but do not properly advertise file
system attribute
FILE_SUPPORTS_REPARSE_POINTS.  Although we don't check for this
attribute flag when
querying special file information, we do check it when creating
special files which
causes them to fail unnecessarily.   If we have negotiated SMB3.1.1
POSIX Extensions
with the server we can expect the server to support creating special files via
reparse points, and even if the server fails the operation due to
really forbidding
creating special files, then it should be no problem and is more
likely to return a
more accurate rc in any case (e.g. EACCES instead of EOPNOTSUPP).

Allow creating special files as long as the server supports either
reparse points
or the SMB3.1.1 POSIX Extensions (note that if the "sfu" mount option
is specified
it uses a different way of storing special files that does not rely on
reparse points).

See attached patch

-- 
Thanks,

Steve

--000000000000bdf9050639ef6b0b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Fix-SMB311-posix-special-file-creation-to-servers-wh.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-SMB311-posix-special-file-creation-to-servers-wh.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_md3z6nfo0>
X-Attachment-Id: f_md3z6nfo0

RnJvbSA0ZTFjOTExOGVhNjJjNTJmNzBjYTJjMzk0OWQwOTUwOTZjNGViNjY2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTQgSnVsIDIwMjUgMjI6MTY6MTkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBG
aXggU01CMzExIHBvc2l4IHNwZWNpYWwgZmlsZSBjcmVhdGlvbiB0byBzZXJ2ZXJzIHdoaWNoIGRv
CiBub3QgYWR2ZXJ0aXNlIHJlcGFyc2Ugc3VwcG9ydAoKU29tZSBzZXJ2ZXJzIChpbmNsdWRpbmcg
U2FtYmEpLCBzdXBwb3J0IHRoZSBTTUIzLjEuMSBQT1NJWCBFeHRlbnNpb25zICh3aGljaCB1c2Ug
cmVwYXJzZQpwb2ludHMgZm9yIGhhbmRsaW5nIHNwZWNpYWwgZmlsZXMpIGJ1dCBkbyBub3QgcHJv
cGVybHkgYWR2ZXJ0aXNlIGZpbGUgc3lzdGVtIGF0dHJpYnV0ZQpGSUxFX1NVUFBPUlRTX1JFUEFS
U0VfUE9JTlRTLiAgQWx0aG91Z2ggd2UgZG9uJ3QgY2hlY2sgZm9yIHRoaXMgYXR0cmlidXRlIGZs
YWcgd2hlbgpxdWVyeWluZyBzcGVjaWFsIGZpbGUgaW5mb3JtYXRpb24sIHdlIGRvIGNoZWNrIGl0
IHdoZW4gY3JlYXRpbmcgc3BlY2lhbCBmaWxlcyB3aGljaApjYXVzZXMgdGhlbSB0byBmYWlsIHVu
bmVjZXNzYXJpbHkuICAgSWYgd2UgaGF2ZSBuZWdvdGlhdGVkIFNNQjMuMS4xIFBPU0lYIEV4dGVu
c2lvbnMKd2l0aCB0aGUgc2VydmVyIHdlIGNhbiBleHBlY3QgdGhlIHNlcnZlciB0byBzdXBwb3J0
IGNyZWF0aW5nIHNwZWNpYWwgZmlsZXMgdmlhCnJlcGFyc2UgcG9pbnRzLCBhbmQgZXZlbiBpZiB0
aGUgc2VydmVyIGZhaWxzIHRoZSBvcGVyYXRpb24gZHVlIHRvIHJlYWxseSBmb3JiaWRkaW5nCmNy
ZWF0aW5nIHNwZWNpYWwgZmlsZXMsIHRoZW4gaXQgc2hvdWxkIGJlIG5vIHByb2JsZW0gYW5kIGlz
IG1vcmUgbGlrZWx5IHRvIHJldHVybiBhCm1vcmUgYWNjdXJhdGUgcmMgaW4gYW55IGNhc2UgKGUu
Zy4gRUFDQ0VTIGluc3RlYWQgb2YgRU9QTk9UU1VQUCkuCgpBbGxvdyBjcmVhdGluZyBzcGVjaWFs
IGZpbGVzIGFzIGxvbmcgYXMgdGhlIHNlcnZlciBzdXBwb3J0cyBlaXRoZXIgcmVwYXJzZSBwb2lu
dHMKb3IgdGhlIFNNQjMuMS4xIFBPU0lYIEV4dGVuc2lvbnMgKG5vdGUgdGhhdCBpZiB0aGUgInNm
dSIgbW91bnQgb3B0aW9uIGlzIHNwZWNpZmllZAppdCB1c2VzIGEgZGlmZmVyZW50IHdheSBvZiBz
dG9yaW5nIHNwZWNpYWwgZmlsZXMgdGhhdCBkb2VzIG5vdCByZWx5IG9uIHJlcGFyc2UgcG9pbnRz
KS4KCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJl
bmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvc21iMmlub2Rl
LmMgfCAzICsrLQogZnMvc21iL2NsaWVudC9zbWIyb3BzLmMgICB8IDMgKystCiAyIGZpbGVzIGNo
YW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9z
bWIvY2xpZW50L3NtYjJpbm9kZS5jIGIvZnMvc21iL2NsaWVudC9zbWIyaW5vZGUuYwppbmRleCAy
YTNlNDZiOGUxNWEuLmExMWEyYTY5M2M1MSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIy
aW5vZGUuYworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJpbm9kZS5jCkBAIC0xMzQ2LDcgKzEzNDYs
OCBAQCBzdHJ1Y3QgaW5vZGUgKnNtYjJfZ2V0X3JlcGFyc2VfaW5vZGUoc3RydWN0IGNpZnNfb3Bl
bl9pbmZvX2RhdGEgKmRhdGEsCiAJICogZW1wdHkgb2JqZWN0IG9uIHRoZSBzZXJ2ZXIuCiAJICov
CiAJaWYgKCEobGUzMl90b19jcHUodGNvbi0+ZnNBdHRySW5mby5BdHRyaWJ1dGVzKSAmIEZJTEVf
U1VQUE9SVFNfUkVQQVJTRV9QT0lOVFMpKQotCQlyZXR1cm4gRVJSX1BUUigtRU9QTk9UU1VQUCk7
CisJCWlmICghdGNvbi0+cG9zaXhfZXh0ZW5zaW9ucykKKwkJCXJldHVybiBFUlJfUFRSKC1FT1BO
T1RTVVBQKTsKIAogCW9wYXJtcyA9IENJRlNfT1BBUk1TKGNpZnNfc2IsIHRjb24sIGZ1bGxfcGF0
aCwKIAkJCSAgICAgU1lOQ0hST05JWkUgfCBERUxFVEUgfApkaWZmIC0tZ2l0IGEvZnMvc21iL2Ns
aWVudC9zbWIyb3BzLmMgYi9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYwppbmRleCBjYjY1OTI1NmQy
MTkuLjkzOGE4YTdjNWQyMSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKKysr
IGIvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKQEAgLTUyNjAsNyArNTI2MCw4IEBAIHN0YXRpYyBp
bnQgc21iMl9tYWtlX25vZGUodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGlub2RlICppbm9kZSwK
IAlpZiAoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX1VOWF9FTVVMKSB7CiAJ
CXJjID0gY2lmc19zZnVfbWFrZV9ub2RlKHhpZCwgaW5vZGUsIGRlbnRyeSwgdGNvbiwKIAkJCQkJ
ZnVsbF9wYXRoLCBtb2RlLCBkZXYpOwotCX0gZWxzZSBpZiAobGUzMl90b19jcHUodGNvbi0+ZnNB
dHRySW5mby5BdHRyaWJ1dGVzKSAmIEZJTEVfU1VQUE9SVFNfUkVQQVJTRV9QT0lOVFMpIHsKKwl9
IGVsc2UgaWYgKChsZTMyX3RvX2NwdSh0Y29uLT5mc0F0dHJJbmZvLkF0dHJpYnV0ZXMpICYgRklM
RV9TVVBQT1JUU19SRVBBUlNFX1BPSU5UUykKKwkJfHwgKHRjb24tPnBvc2l4X2V4dGVuc2lvbnMp
KSB7CiAJCXJjID0gc21iMl9ta25vZF9yZXBhcnNlKHhpZCwgaW5vZGUsIGRlbnRyeSwgdGNvbiwK
IAkJCQkJZnVsbF9wYXRoLCBtb2RlLCBkZXYpOwogCX0KLS0gCjIuNDMuMAoK
--000000000000bdf9050639ef6b0b--
