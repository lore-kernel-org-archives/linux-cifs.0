Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D088D21578F
	for <linux-cifs@vger.kernel.org>; Fri,  7 Nov 2025 03:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762485838; cv=none; b=P0gN9CQBX9PixtodwhyvkgATzK1rrSnSVm0Ejrw4Kgi20TIZAswAET6iPRpJiSY3sRPG6gMHMizivkwufnbOrr1dIR3LBI8+ca1ubahaoLlHPUDklejmHhHkqLUye2dQt9SyBYn1j0OFa0FSHV4neqU7LBnnbZ18NIy0oWUp1FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762485838; c=relaxed/simple;
	bh=MGnRVPo1pK2sZ7QaNa5y1cjj4FntWeRihIa6BvgC0YA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=N0BO1agGXp59Qn9bubL/z9KHlPJ8gpSHuMmUTQXW+9COyc0SWyBeo1m9J9mMSizoG0E5NBgFa6qNstINTH+5lj8IHAmO0Z+c6Heh19Mwd/2RJV2ml8ut0tehq8xyisHdsIsPPEZiRhc0+Lw7/aQkz+gVx1eD4Qz2Ij/Y+5crF0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AE0jt5CX; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AE0jt5CX"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-880439c5704so2673976d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 19:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762485835; x=1763090635; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7TncHiALD+pxgMMHlQXmFZpFxSnvTJ8aB7WrITHBTwo=;
        b=AE0jt5CXuIm2mKmFSsNMGrzgmDaP1Ie6fChb7y5svx4i7EROq32X4lD25JZBWfzoSu
         n5AMgbrR1UdVQ9f0EURZE07TOMcjmoZirNP85lnbgpUOm9GuHzEiuBI6SI6hmv5/K1Un
         xyZlQ65MEfEVv1c+0lk7VhSx5Hu/xnVlJ/+cuLATeuHoGPVgV1J95mGR92phy5lgfyaS
         tcwkyTV8j+a52ZEt14FgH9DMP6U/j/pqF11YSgGPXBCpY8GgBPisqu7Ll6plE7JGgCxL
         nluY3ZqkZRiiQyYFktwLh/Ey9tk+SXj5Ai1vpChyjl+rijpPGwj6hUs2B0lZRiTxPb3k
         unqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762485835; x=1763090635;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7TncHiALD+pxgMMHlQXmFZpFxSnvTJ8aB7WrITHBTwo=;
        b=lMhPmuywFbfG+TucAhQl8KG1xCHtG1+leoy3Lk8YlQssOZnihMOUOfS2M0W2tj5fwD
         ONtpYKrwRrspE7YUPUC8wukFqc3QnVsJ+7JydTRdpUolXZR0JkIYtMytr2Frb0Gn1zqD
         X/lNrJHocNKA2KBBBMWF24HIW2QnqUM+TLRZO6VbBoYdPRKrhHpyoc8F8TrQzR100L1H
         HFPJVM5zSV/XZ/m1GwWXx2cZ2wZZwHAclH0VoTCFDjtsDKtPrhnhVB+gowYqPpvfpR74
         8Jh0VhHNCS/WW5WToW4yRW/OYRlWk6EwsmBsYM6uKUUzVFY2Ris2LFTIIJLrTcWjAn+/
         5hxA==
X-Gm-Message-State: AOJu0YxDKHMvo9DvSzx1lcqWepU7m0P/zQv2K56D9xkvDqi0uQbJLaZA
	G7yymYG9FQezReHIssJU5Nr1wjs+cMEk/j95HVPGYNLNXSN1Fx+fWjhsr0K/Q++UHOi90mVeyW+
	8jbMCk1I8UurrEx0UCD1KSx6N1cyswgl6+nt5JR0=
X-Gm-Gg: ASbGncsFBH0oVNqLxhjAOsJf3zbPj7Lx4ZU0ZD0ZNhZsKcBzxeRBtBKHT3L49CYJSd/
	kzcFVNY8hetrs63NhAZJq5NI198DMUZPokRtUhqennAAfSTkH+0cs6T0FjD+knNjMe3ulEoes5O
	UO1ONXdbX5Z5eqaCeanxZCu3OpxSoFnhiDwINgGeOw/J/N4G1OyBczskz+E+F3VCDfXki9vkmHj
	m4KVMaO1HGHhc7jjd/ZrR0LciwP/8mmkV2gizWs6RhbPaX88sbyrEZpBNEZIa2R0MKVoqJfw5+N
	1IalKEp11RIRMPnvWtO8o33nS8omhlzxtvOaGAQMPzHfkyd2ep7K7kOwY7bjfBib2GeIkKTyWY1
	cvj6LahR3ovuIeyx944lTyvAyteEWCGDdwYD/AXyqIwrNuLodxM6LQX30nXkBHC3NSlVJB68iqw
	==
X-Google-Smtp-Source: AGHT+IFhfJrDN3/bEWiU5S3L0cVx0GxSunYW8xMnIfxeiJzFggvZkfQLVA3aMKWl2TJuxrgQ/oaSoMMVnJwgV852WKY=
X-Received: by 2002:a05:6214:3015:b0:880:5a06:3a64 with SMTP id
 6a1803df08f44-8817679dff9mr23838416d6.66.1762485835345; Thu, 06 Nov 2025
 19:23:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 6 Nov 2025 21:23:43 -0600
X-Gm-Features: AWmQ_bm6aWMBwErFhkVBlcQ0miuUqvwLvYu9tS1jcSeSuaUZLjp6teLCDUzR4VA
Message-ID: <CAH2r5mtLBAwfk7YbgRkCnA4S7uNyiTGs7kDssa697pci=rCYDw@mail.gmail.com>
Subject: [PATCH] smb: client: validate change notify buffer before copy
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Joshua Rogers <linux@joshua.hu>
Content-Type: multipart/mixed; boundary="00000000000023451b0642f8b6d6"

--00000000000023451b0642f8b6d6
Content-Type: text/plain; charset="UTF-8"

    SMB2_change_notify called smb2_validate_iov() but ignored the return
    code, then kmemdup()ed using server provided OutputBufferOffset/Length.

    Check the return of smb2_validate_iov() and bail out on error.

See attached (lightly updated to fix checkpatch warnings from Joshua's
original patch)



-- 
Thanks,

Steve

--00000000000023451b0642f8b6d6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-client-validate-change-notify-buffer-before-copy.patch"
Content-Disposition: attachment; 
	filename="0001-smb-client-validate-change-notify-buffer-before-copy.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mhoaj42u0>
X-Attachment-Id: f_mhoaj42u0

RnJvbSAzN2I4ZGQ3MzZlNzdkNTkzNmY5YWNmNWI1MjM1OWE0OTZjNGQwMWZlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb3NodWEgUm9nZXJzIDxsaW51eEBqb3NodWEuaHU+CkRhdGU6
IEZyaSwgNyBOb3YgMjAyNSAwMDowOTozNyArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHNtYjogY2xp
ZW50OiB2YWxpZGF0ZSBjaGFuZ2Ugbm90aWZ5IGJ1ZmZlciBiZWZvcmUgY29weQoKU01CMl9jaGFu
Z2Vfbm90aWZ5IGNhbGxlZCBzbWIyX3ZhbGlkYXRlX2lvdigpIGJ1dCBpZ25vcmVkIHRoZSByZXR1
cm4KY29kZSwgdGhlbiBrbWVtZHVwKCllZCB1c2luZyBzZXJ2ZXIgcHJvdmlkZWQgT3V0cHV0QnVm
ZmVyT2Zmc2V0L0xlbmd0aC4KCkNoZWNrIHRoZSByZXR1cm4gb2Ygc21iMl92YWxpZGF0ZV9pb3Yo
KSBhbmQgYmFpbCBvdXQgb24gZXJyb3IuCgpTaWduZWQtb2ZmLWJ5OiBKb3NodWEgUm9nZXJzIDxs
aW51eEBqb3NodWEuaHU+CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCkZpeGVzOiBlM2U5NDYz
NDE0ZjYxICgic21iMzogaW1wcm92ZSBTTUIzIGNoYW5nZSBub3RpZmljYXRpb24gc3VwcG9ydCIp
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0t
CiBmcy9zbWIvY2xpZW50L3NtYjJwZHUuYyB8IDcgKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDUg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50
L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCmluZGV4IGIwNzM5YTI2NjFiZi4u
OGI0YTQ1NzNlOWMzIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYworKysgYi9m
cy9zbWIvY2xpZW50L3NtYjJwZHUuYwpAQCAtNDA1NCw5ICs0MDU0LDEyIEBAIFNNQjJfY2hhbmdl
X25vdGlmeShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAog
CiAJCXNtYl9yc3AgPSAoc3RydWN0IHNtYjJfY2hhbmdlX25vdGlmeV9yc3AgKilyc3BfaW92Lmlv
dl9iYXNlOwogCi0JCXNtYjJfdmFsaWRhdGVfaW92KGxlMTZfdG9fY3B1KHNtYl9yc3AtPk91dHB1
dEJ1ZmZlck9mZnNldCksCi0JCQkJbGUzMl90b19jcHUoc21iX3JzcC0+T3V0cHV0QnVmZmVyTGVu
Z3RoKSwgJnJzcF9pb3YsCisJCXJjID0gc21iMl92YWxpZGF0ZV9pb3YobGUxNl90b19jcHUoc21i
X3JzcC0+T3V0cHV0QnVmZmVyT2Zmc2V0KSwKKwkJCQlsZTMyX3RvX2NwdShzbWJfcnNwLT5PdXRw
dXRCdWZmZXJMZW5ndGgpLAorCQkJCSZyc3BfaW92LAogCQkJCXNpemVvZihzdHJ1Y3QgZmlsZV9u
b3RpZnlfaW5mb3JtYXRpb24pKTsKKwkJaWYgKHJjKQorCQkJZ290byBjbm90aWZ5X2V4aXQ7CiAK
IAkJKm91dF9kYXRhID0ga21lbWR1cCgoY2hhciAqKXNtYl9yc3AgKyBsZTE2X3RvX2NwdShzbWJf
cnNwLT5PdXRwdXRCdWZmZXJPZmZzZXQpLAogCQkJCWxlMzJfdG9fY3B1KHNtYl9yc3AtPk91dHB1
dEJ1ZmZlckxlbmd0aCksIEdGUF9LRVJORUwpOwotLSAKMi41MS4wCgo=
--00000000000023451b0642f8b6d6--
