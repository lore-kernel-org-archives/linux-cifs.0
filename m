Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB6A19E819
	for <linux-cifs@vger.kernel.org>; Sat, 25 Oct 2025 02:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761358882; cv=none; b=QJyrWQ6+SzLwMZOS+JZMRrgMyzFsIDdJnnERn2Irx0N5KQEKbg9Cc3OyW93QTZM+fx3EdCSC0a+W1ozwRMd7dOrJMTv13b2wVHmZUrh6REh1gcAFmUpCs3vNNjyG8os+ya+oOQjr31gFqT1l3i/U3glhPqTDvLAwMC5TVNqEg6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761358882; c=relaxed/simple;
	bh=khHbIiJ/XWfZc+s6v6UyO/bW+V2SIr0MqXpGct2A+vA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q3TBs0m+rlW+etF8pfDcE+592UsC7YWnFE2jIhD68N3aRbnXgKR5H/hPzB2TYeyEpb8QY19WIiFVjn5QzPbp6mF62PkNZRayDSRtFWfENYtyyxLQMp7cIFVz7+xaTxat8mTjruX4YBJKPuHdd7u37Zm9Tb+1Oa3w7i/yhBA2Mhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YVzSVKwm; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YVzSVKwm"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-87c1ceac7d7so27257586d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 19:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761358879; x=1761963679; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zWNW7UqNeE9CZ72Kbvq5fQCSuNh9OCFzicehp0kdJkg=;
        b=YVzSVKwmWvZhJ/yUa3sqjhQB+4PMJZT3OZRz1A4HT3o4/dykrelUccDllTIX4IjGOG
         Qc6ACPNZqoS1A5luFVKiA/DgNlAClvJFHOF4yG0W/b0eRrJCEK/4aFzz/r7MOsHd9m9q
         bnUVrS/rsulmDJIgOzNCfvt5N2JChrAMV4lvVbCuyjM6uZ8VW2MTCbBOF9aufu0JAipA
         z2cQXC1MXhpygzaNI6VL1Und4Uo8npxYw4uUU1GDHENhdZXNQ7fHIqumQzBCGLbtnHtW
         Gv7x0J3ev4JxLLEVd0KZJmEojB/29/Ugu0HLHaiDY83+glQjCAUQid+e5JclbcJq+a1j
         s4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761358879; x=1761963679;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zWNW7UqNeE9CZ72Kbvq5fQCSuNh9OCFzicehp0kdJkg=;
        b=FMiiMYlnZXZOYbNTkLp7IuipfFZtlKt/yW4aHi8wVx6QluBESbRP4vu2cQgXEGoMPW
         UFkTCbY7uwGQJiiZ5UUNmMDIiPau6e00a2CyTGQFpAStmvAB4pxCp4zDj8RXRolcOcyG
         ZF50eFb3BWaFnR1+NWbnJmvuuuK6eluCAJQjZwKI8o/husDR8DrycBl2MHsdXO2asI8F
         /MH3QJbyKXQSmEdm3LT0Qn6TESbUjxjmfXmxWyFXb3DdsVJv5wG0lt1yTQhxiaNqlEXg
         bkvgUjrlzQ2DfWITb0VKMOXfzuAFxIECAp0PZ1H9dTkNgTPpL7qs21UzeHe5xOYsUU9v
         r9Fg==
X-Gm-Message-State: AOJu0YwCAigfGzfND50cMmhsybiNSp3o/Roxk5/WRmFlvpV/uO8Yv+b+
	t7p0ZeQhNTQ7IV4mEawSexBpXm8mGWUdc4fft0KZyxmPDifFTlFHFTT0t4uPuYGrr6e4bI2Irxb
	lOjKhRzEPBCqfKeYQDh4Gx1D0e/4Un/gBE55w
X-Gm-Gg: ASbGncszJBV80EzyPJdfEGeqSHgCXRYox8tSE3JjnURG742HRhT4zApz22kUZQP+lXX
	usQC0cFEiO2MGuAHuxkQ8lfEnfiePGTT4+7CRz6w3xk/EjpHQQ51fbB+5cSLS+i2xhmXdineV3m
	tL01DHsz2FCORK6LgUNwIJbIV1Mhq6mi8PMgS1nMcxlpf7AGnRCDgxfVmXPTjA68eiRxpcTbGEd
	4/DbzzsSK45D4ru+p6HnT+3S0hzpdzGawsmSQI1DbksPxaBWZNJEi0naCh7ITb1yatsotkkSMf8
	kHJIioY12S3jVIN2SklogyP/J3dJhzPJZISP3ZmYqgORrTDlMU3kPClYFxs50M4fx3lDToDnNnc
	fyJlKh7J7cRG+2RIGKwketMl2qDb5HL8WmMnb5mwYQ9OlJMyYJwiVet+MjfqL0AkCnjN0d8ycB9
	hsxUfnISaHkQ==
X-Google-Smtp-Source: AGHT+IHv+F7CRB4JTF6D6CmKyw2DLu53mY3ljrKB/sa1t0IMoN7zvf7R6/d4CgLTptOosqqc9aWmy5acEZCne1DDjZs=
X-Received: by 2002:a05:6214:e43:b0:87c:67a:ca69 with SMTP id
 6a1803df08f44-87c2063c1camr440226816d6.61.1761358879246; Fri, 24 Oct 2025
 19:21:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEAsNvS5RbZ293x0iL=Fcck4m7wKgn1VeJhN-1kxvwdBcMVU3w@mail.gmail.com>
 <CAEAsNvSFTfBKjL-3WW_hnBC31WaOY2tOi5PAXTSTDQadTDS3jw@mail.gmail.com>
In-Reply-To: <CAEAsNvSFTfBKjL-3WW_hnBC31WaOY2tOi5PAXTSTDQadTDS3jw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 24 Oct 2025 21:21:07 -0500
X-Gm-Features: AWmQ_blo2rvyMAD32q4JaUDADxAojz4p-oAOFlp13WitOe3z4DJsVeAL7lxaqrY
Message-ID: <CAH2r5mv5tJ+nEenOJFBZjOn=6e39nTBzDR_GQZTf0Wg=dR4BdA@mail.gmail.com>
Subject: Re: Minor typo fix for enable_gcm_256 cifs module parameter description
To: Thomas Spear <speeddymon@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000051e4290641f252d9"

--00000000000051e4290641f252d9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Created a patch with your suggestion and added to cifs-2.6.git
for-next (see attached).  Good catch.


On Fri, Oct 24, 2025 at 1:34=E2=80=AFPM Thomas Spear <speeddymon@gmail.com>=
 wrote:
>
> Hi all,
>
> I noticed a patch was put in during kernel 6.6 development to fix a
> typo in cifsfs.c, but it seems that the patch still contained a typo
> and so I wanted to submit this tiny typo fix.
>
> Thank you,
>
> Thomas Spear



--=20
Thanks,

Steve

--00000000000051e4290641f252d9
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-typo-in-enable_gcm_256-module-parameter.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-typo-in-enable_gcm_256-module-parameter.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mh5nl3by0>
X-Attachment-Id: f_mh5nl3by0

RnJvbSA2NjU4MWZhNTBiZDMxNGMwNDU3Mzc2ZjExNjhjMGZkZWY1MGY2NGQ4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjQgT2N0IDIwMjUgMjE6MTc6MDEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggdHlwbyBpbiBlbmFibGVfZ2NtXzI1NiBtb2R1bGUgcGFyYW1ldGVyCgpGaXggdHlw
byBpbiBkZXNjcmlwdGlvbiBvZiBlbmFibGVfZ2NtXzI1NiBtb2R1bGUgcGFyYW1ldGVyCgpTdWdn
ZXN0ZWQtYnk6IFRob21hcyBTcGVhciA8c3BlZWRkeW1vbkBnbWFpbC5jb20+ClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xp
ZW50L2NpZnNmcy5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYyBiL2ZzL3NtYi9j
bGllbnQvY2lmc2ZzLmMKaW5kZXggNGY5NTlmMWUwOGQyLi4xODVhYzQxYmQ3ZTkgMTAwNjQ0Ci0t
LSBhL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMKKysrIGIvZnMvc21iL2NsaWVudC9jaWZzZnMuYwpA
QCAtMTczLDcgKzE3Myw3IEBAIG1vZHVsZV9wYXJhbShlbmFibGVfb3Bsb2NrcywgYm9vbCwgMDY0
NCk7CiBNT0RVTEVfUEFSTV9ERVNDKGVuYWJsZV9vcGxvY2tzLCAiRW5hYmxlIG9yIGRpc2FibGUg
b3Bsb2Nrcy4gRGVmYXVsdDogeS9ZLzEiKTsKIAogbW9kdWxlX3BhcmFtKGVuYWJsZV9nY21fMjU2
LCBib29sLCAwNjQ0KTsKLU1PRFVMRV9QQVJNX0RFU0MoZW5hYmxlX2djbV8yNTYsICJFbmFibGUg
cmVxdWVzdGluZyBzdHJvbmdlc3QgKDI1NiBiaXQpIEdDTSBlbmNyeXB0aW9uLiBEZWZhdWx0OiB5
L1kvMCIpOworTU9EVUxFX1BBUk1fREVTQyhlbmFibGVfZ2NtXzI1NiwgIkVuYWJsZSByZXF1ZXN0
aW5nIHN0cm9uZ2VzdCAoMjU2IGJpdCkgR0NNIGVuY3J5cHRpb24uIERlZmF1bHQ6IHkvWS8xIik7
CiAKIG1vZHVsZV9wYXJhbShyZXF1aXJlX2djbV8yNTYsIGJvb2wsIDA2NDQpOwogTU9EVUxFX1BB
Uk1fREVTQyhyZXF1aXJlX2djbV8yNTYsICJSZXF1aXJlIHN0cm9uZ2VzdCAoMjU2IGJpdCkgR0NN
IGVuY3J5cHRpb24uIERlZmF1bHQ6IG4vTi8wIik7Ci0tIAoyLjQ4LjEKCg==
--00000000000051e4290641f252d9--
