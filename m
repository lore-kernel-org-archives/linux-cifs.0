Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA4754279
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 23:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754522543; cv=none; b=hynIRvnuu7lB9P2D5oiaLGJfadmyktRrZt83M5ImaZ4KCnY7msoCE5oDlMvV9MjpjIY/XjTaSrmZgX/w7DmDHvS0cyDE1l5k7XRF/4wl6vt/CFkRag8NE0ntMJ7KoLc24BwhB3m8Z8P5qF8pdcYUI3z4VwaxaHG/XxnDrqr78oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754522543; c=relaxed/simple;
	bh=7aWaiXE0py29tA8En1hYvigqPqqaFb/k8TM6dH8BMLg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Ng6V8zXR/dLuVzYnAJhkQNfu7+NvkOufeh8nQCQWBcTcIyomMwUBotlgu1vHiw95CtR3ZCIVvA7T3W2oSZ3GmdXkuN6oy3WPPo/kAcg/WWxJe+pK1BX9xTm6P1CeNYF1VP11yaGtpwbd4X6uq0Jqr/vT5ghAi9KP0kot147soIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bme+ffq9; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bme+ffq9"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b0a2dd3a75so2053971cf.0
        for <linux-cifs@vger.kernel.org>; Wed, 06 Aug 2025 16:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754522540; x=1755127340; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mDfCd6PGBB8BTWPHFwkSQWIAaQVTMSPzbC5dPCcammc=;
        b=Bme+ffq9iqPlb88OGOYZDcUfKUw/3LbeCrVWhMKMMyIFHbTr7m9q9tKJGm1hpXhDmP
         nwfOpcMAJOF4r3y2qRMw1bMuMyo/qBy0hZM+d6UND1vAsTZQShn85Kso9G9qUSwakPGd
         1Bd2zllKaA1IVnpB7GBfEH9E0cKDf8Z99zPD5YxhIrBxc4N6/Xg1ke/yEBAYJuWYxKvm
         AXx2HpORDVA2MErKzd9Q+AO9Pvvef2S9XBSkf5k0Sd/l/M987Dh5Sh6zOWTngomu+4gt
         OfpY6gmmUzkiPtBoPoG4Oq9PePnUkWymsmQgQ2iwIi91JGR4Qj1Wz1k31pXWFTRhrNjS
         bbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754522540; x=1755127340;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mDfCd6PGBB8BTWPHFwkSQWIAaQVTMSPzbC5dPCcammc=;
        b=gjK262F6Dx5/P3zn4/obYDtBinSQvHleg8DoDTKedLTCi1HsjWx3GQOb74U09MuCMk
         AYHptdR6feG9eXBWoo+x5bbTGjY5E8VfsdG9qC58nWr0xZVX9B2zbPStmFGwFyPhSaHa
         qD2eIVLngCtUWLT4ExwnjjYnQ2cJexuihi7Gz0hlklaoJ/NSie3rpOpUPxJ0VmoJY4Sx
         SSAsmQN9tflIM8IAr5ZxDpuFb+7s4/uJUlqmSAj+il2skIhvJtp9aQL9ABrVzihdGejd
         17YNsyFxZRv0Mgd6RSUDzNt31Zd5pwvbKLJmb1J9xNpRlwScg7XF4Bm0UZCkezGO7mTK
         0S8g==
X-Gm-Message-State: AOJu0YxM9UBAZ6U1Qb+SJeZ2QPMaUc+8rXz8UkSpfkOeSLhT+i2JZHxT
	Zm/jeEkMZGBeWU9kfo1pvkSTxKMIDQtgLGFX4KCur0thgKeHPdQv3dibAG4qrt793rkx2uUMf6Z
	NA3tGAR342WlKvCR2eqovvew7f6H1tIdX7cYg
X-Gm-Gg: ASbGncvLUXjzsx247zSWzEZhmlOoguiPSb1N4p5joFr5SYN9tb4cXVV7ncVxkJSC+7W
	hLYJcL4QdjgX8lc8im+X1407GOiLTTGcvzLX9fMFvQ4zGDu/fb+/icxcDwyqDWjgDsxKb6+ulu4
	H6z4ytRL7Tj5iod6dd1lt07izMWYtjiWDmTkYEy9j+CStRs5jZEud9MibOWwLErnar3H6Re4jxV
	LaTiE1n6zThQ4+o+Red9GRTxdiY1m6YUAFlrynwBEEd3Q3uLrk=
X-Google-Smtp-Source: AGHT+IECAjkWTTc82RakZ/gSG69VuqUpDeCkZl4mqP6b2femcSjLQLPISMniCb//L5/04D+tVvbsMWcd/JyT9MtRjzs=
X-Received: by 2002:a05:6214:dcc:b0:704:b09a:9525 with SMTP id
 6a1803df08f44-7098a801687mr15357646d6.29.1754522540314; Wed, 06 Aug 2025
 16:22:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 6 Aug 2025 18:22:08 -0500
X-Gm-Features: Ac12FXxMuTJkyLH8PZuDS8hncJSFQ6cBmGpD9RTSYc7hfoT6vMf4KMARULp0LjY
Message-ID: <CAH2r5mtQ1Bqpd==fi2f2GMWZU9o6OC-Vuj96TiTRW16Tp1Dagw@mail.gmail.com>
Subject: [PATCH][SMB3 client] cifs: Don't need state locking in smb2_get_mid_entry()
To: CIFS <linux-cifs@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000c438f1063bba9cfb"

--000000000000c438f1063bba9cfb
Content-Type: text/plain; charset="UTF-8"

An attempt to rebase one of David's patches to current for-next.
There might be value in this cleanup.   Any opinions?  See attached.

There's no need to get ->srv_lock or ->ses_lock in smb2_get_mid_entry() as
all that happens of relevance (to the lock) inside the locked sections is
the reading of one status value in each.

Replace the locking with READ_ONCE() and use a switch instead of a chain of
if-statements.

Signed-off-by: David Howells <dhowells@redhat.com>

-- 
Thanks,

Steve

--000000000000c438f1063bba9cfb
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Don-t-need-state-locking-in-smb2_get_mid_entry.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Don-t-need-state-locking-in-smb2_get_mid_entry.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_me0lefqy0>
X-Attachment-Id: f_me0lefqy0

RnJvbSA0Njk0NjRiYThlMjI1YWE3MTU2NzdlYjYzMmZhZTkyZWJhMGJkMjg4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgNiBBdWcgMjAyNSAxODoxNzowNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IERvbid0IG5lZWQgc3RhdGUgbG9ja2luZyBpbiBzbWIyX2dldF9taWRfZW50cnkoKQoKVGhl
cmUncyBubyBuZWVkIHRvIGdldCAtPnNydl9sb2NrIG9yIC0+c2VzX2xvY2sgaW4gc21iMl9nZXRf
bWlkX2VudHJ5KCkgYXMKYWxsIHRoYXQgaGFwcGVucyBvZiByZWxldmFuY2UgKHRvIHRoZSBsb2Nr
KSBpbnNpZGUgdGhlIGxvY2tlZCBzZWN0aW9ucyBpcwp0aGUgcmVhZGluZyBvZiBvbmUgc3RhdHVz
IHZhbHVlIGluIGVhY2guCgpSZXBsYWNlIHRoZSBsb2NraW5nIHdpdGggUkVBRF9PTkNFKCkgYW5k
IHVzZSBhIHN3aXRjaCBpbnN0ZWFkIG9mIGEgY2hhaW4gb2YKaWYtc3RhdGVtZW50cy4KClNpZ25l
ZC1vZmYtYnk6IERhdmlkIEhvd2VsbHMgPGRob3dlbGxzQHJlZGhhdC5jb20+CmNjOiBQYXVsbyBB
bGNhbnRhcmEgPHBjQG1hbmd1ZWJpdC5vcmc+CmNjOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBt
aWNyb3NvZnQuY29tPgpjYzogVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+CmNjOiBsaW51eC1j
aWZzQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNo
QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9zbWIydHJhbnNwb3J0LmMgfCA0NCAr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDE4IGlu
c2VydGlvbnMoKyksIDI2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQv
c21iMnRyYW5zcG9ydC5jIGIvZnMvc21iL2NsaWVudC9zbWIydHJhbnNwb3J0LmMKaW5kZXggZmY5
ZWY3ZmNkMDEwLi45NTYxNzNhOTMwYjcgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMnRy
YW5zcG9ydC5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc21iMnRyYW5zcG9ydC5jCkBAIC03OTksNDMg
Kzc5OSwzNSBAQCBzdGF0aWMgaW50CiBzbWIyX2dldF9taWRfZW50cnkoc3RydWN0IGNpZnNfc2Vz
ICpzZXMsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAkJICAgc3RydWN0IHNtYjJf
aGRyICpzaGRyLCBzdHJ1Y3QgbWlkX3FfZW50cnkgKiptaWQpCiB7Ci0Jc3Bpbl9sb2NrKCZzZXJ2
ZXItPnNydl9sb2NrKTsKLQlpZiAoc2VydmVyLT50Y3BTdGF0dXMgPT0gQ2lmc0V4aXRpbmcpIHsK
LQkJc3Bpbl91bmxvY2soJnNlcnZlci0+c3J2X2xvY2spOworCXN3aXRjaCAoUkVBRF9PTkNFKHNl
cnZlci0+dGNwU3RhdHVzKSkgeworCWNhc2UgQ2lmc0V4aXRpbmc6CiAJCXJldHVybiAtRU5PRU5U
OwotCX0KLQotCWlmIChzZXJ2ZXItPnRjcFN0YXR1cyA9PSBDaWZzTmVlZFJlY29ubmVjdCkgewot
CQlzcGluX3VubG9jaygmc2VydmVyLT5zcnZfbG9jayk7CisJY2FzZSBDaWZzTmVlZFJlY29ubmVj
dDoKIAkJY2lmc19kYmcoRllJLCAidGNwIHNlc3Npb24gZGVhZCAtIHJldHVybiB0byBjYWxsZXIg
dG8gcmV0cnlcbiIpOwogCQlyZXR1cm4gLUVBR0FJTjsKKwljYXNlIENpZnNOZWVkTmVnb3RpYXRl
OgorCQlpZiAoc2hkci0+Q29tbWFuZCAhPSBTTUIyX05FR09USUFURSkKKwkJCXJldHVybiAtRUFH
QUlOOworCQlicmVhazsKKwlkZWZhdWx0OgorCQlicmVhazsKIAl9CiAKLQlpZiAoc2VydmVyLT50
Y3BTdGF0dXMgPT0gQ2lmc05lZWROZWdvdGlhdGUgJiYKLQkgICBzaGRyLT5Db21tYW5kICE9IFNN
QjJfTkVHT1RJQVRFKSB7Ci0JCXNwaW5fdW5sb2NrKCZzZXJ2ZXItPnNydl9sb2NrKTsKLQkJcmV0
dXJuIC1FQUdBSU47Ci0JfQotCXNwaW5fdW5sb2NrKCZzZXJ2ZXItPnNydl9sb2NrKTsKLQotCXNw
aW5fbG9jaygmc2VzLT5zZXNfbG9jayk7Ci0JaWYgKHNlcy0+c2VzX3N0YXR1cyA9PSBTRVNfTkVX
KSB7CisJc3dpdGNoIChSRUFEX09OQ0Uoc2VzLT5zZXNfc3RhdHVzKSkgeworCWNhc2UgU0VTX05F
VzoKIAkJaWYgKChzaGRyLT5Db21tYW5kICE9IFNNQjJfU0VTU0lPTl9TRVRVUCkgJiYKLQkJICAg
IChzaGRyLT5Db21tYW5kICE9IFNNQjJfTkVHT1RJQVRFKSkgewotCQkJc3Bpbl91bmxvY2soJnNl
cy0+c2VzX2xvY2spOworCQkgICAgKHNoZHItPkNvbW1hbmQgIT0gU01CMl9ORUdPVElBVEUpKQog
CQkJcmV0dXJuIC1FQUdBSU47Ci0JCX0KIAkJLyogZWxzZSBvayAtIHdlIGFyZSBzZXR0aW5nIHVw
IHNlc3Npb24gKi8KLQl9Ci0KLQlpZiAoc2VzLT5zZXNfc3RhdHVzID09IFNFU19FWElUSU5HKSB7
Ci0JCWlmIChzaGRyLT5Db21tYW5kICE9IFNNQjJfTE9HT0ZGKSB7Ci0JCQlzcGluX3VubG9jaygm
c2VzLT5zZXNfbG9jayk7CisJCWJyZWFrOworCWNhc2UgU0VTX0VYSVRJTkc6CisJCWlmIChzaGRy
LT5Db21tYW5kICE9IFNNQjJfTE9HT0ZGKQogCQkJcmV0dXJuIC1FQUdBSU47Ci0JCX0KIAkJLyog
ZWxzZSBvayAtIHdlIGFyZSBzaHV0dGluZyBkb3duIHRoZSBzZXNzaW9uICovCisJCWJyZWFrOwor
CWRlZmF1bHQ6CisJCWJyZWFrOwogCX0KLQlzcGluX3VubG9jaygmc2VzLT5zZXNfbG9jayk7CiAK
IAkqbWlkID0gc21iMl9taWRfZW50cnlfYWxsb2Moc2hkciwgc2VydmVyKTsKIAlpZiAoKm1pZCA9
PSBOVUxMKQotLSAKMi40My4wCgo=
--000000000000c438f1063bba9cfb--
