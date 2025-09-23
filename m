Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6104510F1
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 03:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597937; cv=none; b=LfDtDbTGU3tKlm13QPL5bjA874IRDvzBDslKQUKwFQjy2N7xx3icRVu577Gw5KLH7ruKvhDNLuCWNatvpIDs+XrmjKo72sNCD/xT79jjBprdJgSdZ/I4nn/ywjsfF70DBjKR87jmxxlD9bMHUlm6DdKb62ZL/z+xK0j+t9NaA0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597937; c=relaxed/simple;
	bh=d2kF0/FX+BfQdEqTgcpFgSlkmnfBaeSuPXJLMA6dmhc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PSI+D5GhGlKy1K6Gp/SThWxVwoH/fkxftyl8Vmv0/oN3hKfvMh57UAVs+uI/MDhaBCnRTfDoa7WVnHsXBK46D6AmK5skeNTkkUIZUs+PFAH8Kel8QBet5ehJriA2JFnyalRCojwVG9qmS3FvK3TffJ3/kAPi3vlYWpsl16Qv0Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aS4p777i; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aS4p777i"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-7900f7f4ba9so44049536d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 20:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758597935; x=1759202735; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O+M0NLYx4hlCNTr+E19YN4XGSCzUmdnofDI/StcpPYE=;
        b=aS4p777iW3S69w07JLd4UFbN6rKFSJF/+Q24SHveRo20cT/+MIhIaOz0/owh1ucZMA
         nuvtJe4nk8Ous9vwTr5l78IVACS+PHeeqEDYEn28V1+a9FEApM9MclR1pg8fxBka8q4r
         r3m5/kHIocA48e+YG3Uwf/lQD/rLcnczYy6agQq0yuwBxWpcWX+MuoaeGD/i3nOEqJh2
         SSo3tQNF3gXPyRyMe1LkOYzvDpFZVfqLTtMzf5h5NjSQn1IEB83jeMD1gnBv+XXxNiAv
         ehdbeDtVpW6lmfnGdXFaEUz9eHRL+vaB4bbvDRZWj/8atyUuRr3cg9Vc9w8aMxwe5lPS
         C4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758597935; x=1759202735;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O+M0NLYx4hlCNTr+E19YN4XGSCzUmdnofDI/StcpPYE=;
        b=JjnGeaE09+RCHftBxTmItXnjSu98k8mNKQPa2A5Ej+yLmNuWRakil3kbkl+WRaTa/y
         RCvCIKhMertmqQAter6ghBhcKmOKprMawig16+dBrQJ2VbpQCWv4ip2PMfnsHkEqaxFT
         Drk+tnoL0K+XZJHhmdCJ3qfIZpBlfEsj/6zRvNtTLENhDE4+JWcYE91yp4QRr2+YsLDM
         aj6yj/q9/XN2Y7tW65TTuU2gAhhmGO9x0h0/kRdOP1xYHr+irOc69CvJeSJ9CgS4HVzY
         gdQKu3bCDJ2HfkQiq7LGBWtNV5/PIhhqIDn7D+RU0gWuNBZ847SByXRGBlNUbs/Y5P1U
         6FhA==
X-Gm-Message-State: AOJu0YyO/9nzAPOE8S6SEKh+xPssSKnZZb2NY0Y7yKBs4hvHlnneddsa
	zKQnmu4hA7iJLtaI6VRsD4caZ2g+jB5vMAAPSrIWwJbXfJfv+aq6M3YW3X7QRyRUCmAAZRpXlen
	gdi2+amdoiJxheexLqBepTEBmWA5T/AhJDg==
X-Gm-Gg: ASbGncs2mIqWhLAYXq1zJ1sB7ums1BFhtRv0D0nuuYhN6e0TSC1MRCrJuM5pyvWF3at
	2AraAl98+SQ93ZzVZNbZMRWKUX+DQKt7qKtSAHI5fWfkDH2DI42ZhRCcL9ic4IzZPu+Lbze2glA
	4M6MrsjWjIOjTqdlFNlwcXRz24u72aMy9u6mm+7WjDIO44bTDw7biwM/5oLOrZo2QYYS7h3SsRM
	pB3U+lkmMzrwm/6w3IdrJBybay34DqI6t0RCrLly67yFg7UNwSIaK6LkIj5iA8kWU/iRd4H0WWA
	wVNDEmeMa7DCswSAW8wWToZ1NPWOvhjkjudl2nTANWPUA86NkyL9IrVWDU+I4gsez/40zbKCDhC
	BCsVYpCUQNuvF9aicJsaAtClxCOp7zo58
X-Google-Smtp-Source: AGHT+IGa/Cua+iH9o/FiXyx/Kn1TwusXyL1mnDNktnPt9QZZjnpnSNYUUlMD4UWL4Y2n1xLTJY7NYldWgq+J8NAaDwI=
X-Received: by 2002:a05:6214:202e:b0:78d:b474:8e3e with SMTP id
 6a1803df08f44-7e714e995ebmr12493106d6.49.1758597934577; Mon, 22 Sep 2025
 20:25:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muDbZTXitjyMP3LWnAHvZwdLKk5OigR8_fH849jz2ukQg@mail.gmail.com>
In-Reply-To: <CAH2r5muDbZTXitjyMP3LWnAHvZwdLKk5OigR8_fH849jz2ukQg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 22 Sep 2025 22:25:21 -0500
X-Gm-Features: AS18NWAiafzfR8g7s2QblpZm3v1bnjqXrB4BjmaWRZKGlB6kexvComkhSs3XXt8
Message-ID: <CAH2r5mteYtF_Fq1dWi7k2DSLoQdk7gMsicvJpU+FjZbv+FgGZw@mail.gmail.com>
Subject: Re: Fix for xfstest generic/637 (dir lease not updating for newly
 created file on same client)
To: CIFS <linux-cifs@vger.kernel.org>, 
	Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Bharath S M <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000031c07d063f6f7dcf"

--00000000000031c07d063f6f7dcf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry about confusion - sent the wrong patch in the attachment.
Correct patch for this important problem is attached


On Mon, Sep 22, 2025 at 7:50=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Am testing this potential fix for the dir lease caching issue now.
> See attached fix.  Additional testing and review would be very
> helpful.
>
>    smb client: fix dir lease bug with newly created file in cached dir
>
>     Test generic/637 spotted a problem with create of a new file in a
>     cached directory (by the same client) could cause cases where the
>     new file does not show up properly in ls on that client until the
>     lease times out.
>
>     Fixes: 037e1bae588e ("smb: client: use ParentLeaseKey in cifs_do_crea=
te")
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--00000000000031c07d063f6f7dcf
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-client-fix-dir-lease-bug-with-newly-created-file.patch"
Content-Disposition: attachment; 
	filename="0001-smb-client-fix-dir-lease-bug-with-newly-created-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mfvzsgso0>
X-Attachment-Id: f_mfvzsgso0

RnJvbSA0MmRlNjY2MmIyN2FkZDEzZDFmOWY4ZWRhNDlkOWVhNzhiNjUzZDI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogTW9uLCAyMiBTZXAgMjAyNSAxOTozNzozMyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YiBjbGllbnQ6IGZpeCBkaXIgbGVhc2UgYnVnIHdpdGggbmV3bHkgY3JlYXRlZCBmaWxlIGluCiBj
YWNoZWQgZGlyCgpUZXN0IGdlbmVyaWMvNjM3IHNwb3R0ZWQgYSBwcm9ibGVtIHdpdGggY3JlYXRl
IG9mIGEgbmV3IGZpbGUgaW4gYQpjYWNoZWQgZGlyZWN0b3J5IChieSB0aGUgc2FtZSBjbGllbnQp
IGNvdWxkIGNhdXNlIGNhc2VzIHdoZXJlIHRoZQpuZXcgZmlsZSBkb2VzIG5vdCBzaG93IHVwIHBy
b3Blcmx5IGluIGxzIG9uIHRoYXQgY2xpZW50IHVudGlsIHRoZQpsZWFzZSB0aW1lcyBvdXQuCgpG
aXhlczogMDM3ZTFiYWU1ODhlICgic21iOiBjbGllbnQ6IHVzZSBQYXJlbnRMZWFzZUtleSBpbiBj
aWZzX2RvX2NyZWF0ZSIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6
IEJoYXJhdGggU00gPGJoYXJhdGhzbUBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9kaXIu
YyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoK
ZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvZGlyLmMgYi9mcy9zbWIvY2xpZW50L2Rpci5jCmlu
ZGV4IDUyMjNlZGY2ZDExYS4uM2UwMjI2OThjYzM2IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50
L2Rpci5jCisrKyBiL2ZzL3NtYi9jbGllbnQvZGlyLmMKQEAgLTMyOCw3ICszMjgsNyBAQCBzdGF0
aWMgaW50IGNpZnNfZG9fY3JlYXRlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBkZW50cnkg
KmRpcmVudHJ5LCB1bnNpZ25lZAogCQkJCQltZW1jcHkoZmlkLT5wYXJlbnRfbGVhc2Vfa2V5LAog
CQkJCQkgICAgICAgcGFyZW50X2NmaWQtPmZpZC5sZWFzZV9rZXksCiAJCQkJCSAgICAgICBTTUIy
X0xFQVNFX0tFWV9TSVpFKTsKLQkJCQkJcGFyZW50X2NmaWQtPmRpcmVudHMuaXNfdmFsaWQgPSBm
YWxzZTsKKwkJCQkJcGFyZW50X2NmaWQtPmRpcmVudHMuaXNfZmFpbGVkID0gdHJ1ZTsKIAkJCQl9
CiAJCQkJYnJlYWs7CiAJCQl9Ci0tIAoyLjQ4LjEKCg==
--00000000000031c07d063f6f7dcf--
