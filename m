Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792520336;
	b=oYzMgNgmDF6JSV8CA+LLZ3ne7Tja3SKv8XOX5U84+tKfFc1mX1KiWicbBhToh8mivCgb
	 2ZeRMeY3sTiE/itkXsbZq+Z6XFzt1gFkJT3pnD/TRyhQXRa/UYNCSJoKqu3sRS293o5p8
	 65NoV37torEU9Ab0hT9qNPLbJIu5WAtVsiHEBQBAHPhUeuk6gBrftxRuSnIDiXSpcyDSz
	 Xr2Y+OtjtbI2jZSmIlMXLm1kX/QKhZNS0aulyvCDH99QUjhzjDrYwwbt2bZ3Qlh6Q+gTj
	 2TrRif1vCAdy9QYkKP8ZWsXd7dnqY9gAZO7zB1p921tgyfDHjE8YGuN3H5w8wD1Rn5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792520336;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=XuyCTZj8gPZvUl1CHHVB79Z4Me8T8O5ovdkbzwvs2Vg=;
	b=cfv+jQxmwZTkB9KSyoFe5yB23Nxms07/Yp393XeAszhR1zAnZS2gq/TTsiC/Zit5e0H4
	 NcNk3KqkCi6cf3myChdlb00S16ftwaH7cZGBDZJRytJLqwnFqpT2sznVKiX9aJ38XCCXw
	 9dwQ4qnRvbW5qWylg2rPoF0T7M28BCG/sY8JhzYTAbTAzTb/DFHpP1sot2r3E6c44Vcs5
	 nOrnbJCsrPk4Yc2Wk4cNng0CeQJpL+oZcm2mBeY47Dd9RRf/6JCS6pgTKoG/1hcTgSrL9
	 jKwUnaoZukN6ldO4FeyAYS6gBenKTUW95YSe27sNd3hzD6HwmAkV5iUoT7MRTp1QpOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OTu6uhXn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.43
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EB4606A319
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 18:18:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63EB4606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OTu6uhXn
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-675676afc3cso3594384d50.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 11:18:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792520335; cv=none;
        d=google.com; s=arc-20260327;
        b=JmOVFj573i0mojSKqCCAGtM69fOek2VXvZrv1BqGcn/fgLdlrkUrslk+MCs1Jv1Xcj
         vQI02CI5ZXcO+ZYQ4zE29bbKrB/4arPIvE+4JsHS9M3/6vpFsEWljryce8Cpaio0LMv0
         y6czofJprK+7s6Rk3Kwey1raIqnkYpY2+XCaAraW5yBOmk6UMW8NipvdS0PPdfYc9gaJ
         U9Icp21ccjE612nXO+YItt3vXW15NmzNdaklBEYdvrcRqUAT5OUY6EXSQyRBj7ZbnWhT
         tr1G5eHDkT+pYTlmAgP0ysu0A64FiA6/rfghOF/yenMzIUZZtyC9e9+HNV5phmLjt2a6
         9FCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=XuyCTZj8gPZvUl1CHHVB79Z4Me8T8O5ovdkbzwvs2Vg=;
        fh=EdvMAiFU8colKxyzOzW3+wUFPEWG1iwAQ3Co+Gz/Ffs=;
        b=N+6KFGfwpZfa4lvllfGvL14KRDl/L+ounX95pfwOpI4BMq+gslBF60RkaiY1mrwQyF
         SQYFVbmRWLlFg+1uOxtAY0FkacD7rrpCO8CB37zu+bBL2gPE/d+673FsyKGPU7tFIohb
         rHqXbAa+orWt2EKDMNT3lbw5KPwEKhmmSk98t+fidHjU5xz9wGCw2zErbix0p4+KbmaH
         q0qNc8308RjY6wlxcAM/2kSmEHvOKtON/2z+bnMsyVwHB+vmnF4GR8FR7KiPyR7XsFLh
         MHM+tGPmXsdJ/aizL/U/9iB4jHQ0FgIglzme80dUjKsDopZvpfrrQSE6PjKNoLu/+QiY
         L1nQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792520335; x=1793125135; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XuyCTZj8gPZvUl1CHHVB79Z4Me8T8O5ovdkbzwvs2Vg=;
        b=OTu6uhXnh+BQTnfn3sxkL5bAQJgbfvT8enUh+mWmQjGmqQrpqB2rFNX/MCQ7M9bmoX
         sKyqxcIoQdlV1W+xZldyZjkmJvJMp3lD5tyhuamVdSW2OeGSTEK+rYyQPI/oNtKtTvy2
         oLoN1fwQ1GXjKFAXY8wnbRH7ZrlEqiN5TOyrHT8FQOGli9ypNAwJNN05R3z7guYdU90u
         NV4+D3Ru4SIx0YO//yQa6K+yG/HDwJy3TNUn19vphFi1OHQzWAMBMMENjl4M2gXM76Qh
         DjFyl873LfUX2ay+vLHmLBKyDJKa28V6pvGyJmW0LpubO3xFNR5C0WsC71r6lMbwQyXD
         8ZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792520335; x=1793125135;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XuyCTZj8gPZvUl1CHHVB79Z4Me8T8O5ovdkbzwvs2Vg=;
        b=AxMCZ3WVpORTQlsO1gGE/5O9W1+7xn8FO6d8APRLdrQ5vGuk4H/5lLxk8MsVaCGdvA
         GBXuVSgwUBiVNs85nsBAJ/YSw5Tq79t4Xdo0p1a83E0ar1HnCWrHCximEWrX9cKN0OpL
         lQYSjrnVmpaOO9beyTI/owJV3iMZuT0wpp8Zvd7MPIhGLn1MfED5Qp6BYeSh6teTn3Cj
         eYUi61nZaoyOY/OMf/PWDt/uThiGY17d9acSxO3oJecAFczfQSjF8YrIzjsJEvhXTUcm
         d+Kt7RJeTaRK6hQHeGsWL5FjdAo6Ok45vcq190C9sIPosWbRDGNV0vj08BwBv/LsqUqW
         6r+A==
X-Gm-Message-State: AFq9FYL3DyQtu+XvrzKhVaErCIGsrAGvhH4/vP3OWxMLjCHajxpdR64r
	YWjQOSlW5gmscrMnYTD3Q2StJ+GKKUTP8tbajjjYbKncKfT3xhaJQhsatPZ+I1uRY//RV4xzfci
	m5VJhCnaJm2mZtQ3Rvpkets6EYQaQExo=
X-Gm-Gg: AYBFou0FAYkfDGzRQQCsI6Iy5X8bMk1PPtIGVL+bPzaU2o5XAGoDossp2KCs48nccQ0
	Os5XRT7pTLHdYWg9AjhPrAaZEuAr1HmbETCdhXjsMfVz7hLAGw++k8FIXY5XAPeUQ3viI/4KxF3
	XCCSp5IlQbGozkDZsKl42MoMFukGdlWscsKQcn2dZo1rNzWGXQB9ZNJnS/CKvV2a6spb4vnarvn
	TBxY9cTCF58GSr2C7eD2QuYVa8I7Mn7TBrVnOoiZnpNPH9y8UXKCWZ9psf68Qz3L0oZcWt3VhP2
	bqA1bUrz6yqht/tZnYuS/XxMUdOAvKbylIi/nYpkGftrE97/pgf1okeNvdtN3IMPGZEPnimRXQw
	03qMI2kpRMuhU
X-Received: by 2002:a05:690e:4092:b0:677:edc8:2d93 with SMTP id
 956f58d0204a3-67a0ddf67fbmr59373d50.0.1792520335449; Tue, 20 Oct 2026
 11:18:55 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Mohammed <mohammed.saad.alquraini@gmail.com>
Date: Tue, 20 Oct 2026 21:18:43 +0300
X-Gm-Features: AclHuK9-z3kWmIRRdVCBQCNai6XrCsdMNLXAZopo76rjfyChogdzOwx1tST6dQY
Message-ID: <CAD37_9gRtYiiKOV-efL7HAaP+_F7CUhv6k-iJhfwnEwuYt3GWg@mail.gmail.com>
Subject: [PATCH] ksmbd: reject foreign RPC pipe handles on IPC$ read and write
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000d93cc1065e49a9d2"

--000000000000d93cc1065e49a9d2
Content-Type: text/plain; charset="UTF-8"

Hi Namjae,

Patch attached for the IPC$ pipe-handle issue I reported. Tested
locally. Thanks!

Best regards,
Mohammed Alquraini

--000000000000d93cc1065e49a9d2
Content-Type: application/x-patch; 
	name="0001-ksmbd-reject-foreign-RPC-pipe-handles-on-IPC-read-an.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-reject-foreign-RPC-pipe-handles-on-IPC-read-an.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mvh096141>
X-Attachment-Id: f_mvh096141

RnJvbSAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNb2hhbW1lZCBBbHF1cmFpbmkgPG1vaGFtbWVkLnNhYWQuYWxx
dXJhaW5pQGdtYWlsLmNvbT4KRGF0ZTogTW9uLCAyMCBPY3QgMjAyNiAyMDozMDowMCArMDMwMApT
dWJqZWN0OiBbUEFUQ0hdIGtzbWJkOiByZWplY3QgZm9yZWlnbiBSUEMgcGlwZSBoYW5kbGVzIG9u
IElQQyQgcmVhZCBhbmQgd3JpdGUKClJQQyBwaXBlIGhhbmRsZXMgb24gSVBDJCBhcmUgYWxsb2Nh
dGVkIGZyb20gYSBzaW5nbGUgc2VydmVyLWdsb2JhbCBJREEsCmFuZCBrc21iZC5tb3VudGQgbG9v
a3MgYSBwaXBlIHVwIGJ5IGhhbmRsZSBhbG9uZSwgd2l0aCBubyBzZXNzaW9uCmluZm9ybWF0aW9u
LiAgc21iMl9yZWFkX3BpcGUoKSBhbmQgc21iMl93cml0ZV9waXBlKCkgdGFrZSB0aGUgaGFuZGxl
CnN0cmFpZ2h0IGZyb20gdGhlIGNsaWVudCByZXF1ZXN0IChWb2xhdGlsZUZpbGVJZCkgYW5kIHBh
c3MgaXQgdG8gdGhlCmRhZW1vbiB3aXRob3V0IGNoZWNraW5nIHRoYXQgdGhlIHJlcXVlc3Rpbmcg
c2Vzc2lvbiBvcGVuZWQgaXQuICBBbgphdXRoZW50aWNhdGVkIHVzZXIgY2FuIHRoZXJlZm9yZSBp
c3N1ZSBhbiBTTUIyIFJFQUQgb3IgV1JJVEUgb24gSVBDJAp3aXRoIGFub3RoZXIgc2Vzc2lvbidz
IGhhbmRsZSBhbmQgcmVjZWl2ZSB0aGF0IHNlc3Npb24ncyBpbi1mbGlnaHQKRENFUlBDIHJlc3Bv
bnNlLCBvciB3cml0ZSBhdHRhY2tlci1jaG9zZW4gYnl0ZXMgaW50byBpdHMgcGlwZSBzdHJlYW0u
CkEgdHJlZSBjb25uZWN0IHRvIElQQyQsIHdoaWNoIGV2ZXJ5IFJQQyBjbGllbnQgYWxyZWFkeSBo
YXMsIGlzIHRoZSBvbmx5CnJlcXVpcmVtZW50LgoKVmFsaWRhdGUgb3duZXJzaGlwIGJlZm9yZSB0
aGUgdHJhbnNmZXIsIHRoZSB3YXkgdGhlIHNpYmxpbmcgcGlwZSBwYXRocwphbHJlYWR5IGRvOiB1
bmRlciBzZXNzLT5ycGNfbG9jaywga3NtYmRfc2Vzc2lvbl9ycGNfbWV0aG9kKCkgcmV0dXJucyAw
CmZvciBhIGhhbmRsZSB0aGUgc2Vzc2lvbiBkaWQgbm90IG9wZW4uICBzbWIyX2dldF9pbmZvX2Zp
bGVfcGlwZSgpIGFuZAp0aGUgRlNDVExfUElQRV9UUkFOU0NFSVZFIGlvY3RsIGFscmVhZHkgcmVq
ZWN0IHN1Y2ggaGFuZGxlczsgcmVhZCBhbmQKd3JpdGUgd2VyZSB0aGUgcmVtYWluaW5nIGdhcC4g
IFJlamVjdCB0aGVtIHdpdGggU1RBVFVTX0ZJTEVfQ0xPU0VELCBhcwp0aGUgaW9jdGwgcGF0aCBk
b2VzLgoKRml4ZXM6IGUyZjM0NDgxYjI0ZCAoImNpZnNkOiBhZGQgc2VydmVyLXNpZGUgcHJvY2Vk
dXJlcyBmb3IgU01CMyIpCkFzc2lzdGVkLWJ5OiBMTE0KU2lnbmVkLW9mZi1ieTogTW9oYW1tZWQg
QWxxdXJhaW5pIDxtb2hhbW1lZC5zYWFkLmFscXVyYWluaUBnbWFpbC5jb20+Ci0tLQogZnMvc21i
L3NlcnZlci9zbWIycGR1LmMgfCAyMCArKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5n
ZWQsIDIwIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIvc2VydmVyL3NtYjJwZHUu
YyBiL2ZzL3NtYi9zZXJ2ZXIvc21iMnBkdS5jCmluZGV4IDQwYWYzNWMwYS4uNWNkYTM0M2UxIDEw
MDY0NAotLS0gYS9mcy9zbWIvc2VydmVyL3NtYjJwZHUuYworKysgYi9mcy9zbWIvc2VydmVyL3Nt
YjJwZHUuYwpAQCAtOTIzMyw2ICs5MjMzLDE2IEBAIHN0YXRpYyBub2lubGluZSBpbnQgc21iMl9y
ZWFkX3BpcGUoc3RydWN0IGtzbWJkX3dvcmsgKndvcmspCiAKIAlpZCA9IHJlcS0+Vm9sYXRpbGVG
aWxlSWQ7CiAKKwlsb2NrZGVwX2Fzc2VydF9ub3RfaGVsZCgmd29yay0+c2Vzcy0+cnBjX2xvY2sp
OworCWRvd25fcmVhZCgmd29yay0+c2Vzcy0+cnBjX2xvY2spOworCWlmICgha3NtYmRfc2Vzc2lv
bl9ycGNfbWV0aG9kKHdvcmstPnNlc3MsIGlkKSkgeworCQl1cF9yZWFkKCZ3b3JrLT5zZXNzLT5y
cGNfbG9jayk7CisJCXJzcC0+aGRyLlN0YXR1cyA9IFNUQVRVU19GSUxFX0NMT1NFRDsKKwkJc21i
Ml9zZXRfZXJyX3JzcCh3b3JrKTsKKwkJcmV0dXJuIC1FTk9FTlQ7CisJfQorCXVwX3JlYWQoJndv
cmstPnNlc3MtPnJwY19sb2NrKTsKKwogCXJwY19yZXNwID0ga3NtYmRfcnBjX3JlYWQod29yay0+
c2VzcywgaWQpOwogCWlmIChycGNfcmVzcCkgewogCQl2b2lkICphdXhfcGF5bG9hZF9idWY7CkBA
IC05ODYzLDYgKzk4NzMsMTYgQEAgc3RhdGljIG5vaW5saW5lIGludCBzbWIyX3dyaXRlX3BpcGUo
c3RydWN0IGtzbWJkX3dvcmsgKndvcmspCiAJCWdvdG8gb3V0OwogCX0KIAorCWxvY2tkZXBfYXNz
ZXJ0X25vdF9oZWxkKCZ3b3JrLT5zZXNzLT5ycGNfbG9jayk7CisJZG93bl9yZWFkKCZ3b3JrLT5z
ZXNzLT5ycGNfbG9jayk7CisJaWYgKCFrc21iZF9zZXNzaW9uX3JwY19tZXRob2Qod29yay0+c2Vz
cywgaWQpKSB7CisJCXVwX3JlYWQoJndvcmstPnNlc3MtPnJwY19sb2NrKTsKKwkJcnNwLT5oZHIu
U3RhdHVzID0gU1RBVFVTX0ZJTEVfQ0xPU0VEOworCQlzbWIyX3NldF9lcnJfcnNwKHdvcmspOwor
CQlyZXR1cm4gLUVOT0VOVDsKKwl9CisJdXBfcmVhZCgmd29yay0+c2Vzcy0+cnBjX2xvY2spOwor
CiAJZGF0YV9idWYgPSAoY2hhciAqKSgoKGNoYXIgKikmcmVxLT5oZHIuUHJvdG9jb2xJZCkgKwog
CQkJICAgZGF0YV9vZmZzZXQpOwogCi0tIAoyLjQzLjAK
--000000000000d93cc1065e49a9d2--
