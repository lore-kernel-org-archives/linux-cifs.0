Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F2B6AD3
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 03:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741662613; cv=none; b=RyOKnEd2WrlQ0O/j6o27sxv8wYyadiQCmWCPDpH5vxrTuzerqJIq2pEGSYb2C05JOD0kgpKow8+ZU17W6a8fxuq/hnLRNSYJhsHaXvsLK+qf6tCJZD2Ar8zduxs+52r+lolhmCP3LV9k8X5e1yEgkSy1NVjqqx7FgusRxhCqYdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741662613; c=relaxed/simple;
	bh=0x2p6opO4wcJGCxE0ic2d/QTtFvZPmO4JEq0iguuVJU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=JJ8+AYceOPIZCilolEOkOdxIIqPoI+ZlaSqs4mFnoRteeBdCLZ3L4oTBa+NW7WUB2WZtAvkRE/3ViXzO+HaZWtRhQkOYcmjwe00Gd9YJJ8UIAQfgR34Qsbj4PkHFT/bQwzzzSI77h/LZcdwOLCDeBXG+RGSSEsm49Ky3OM1yTbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CMFC2MMa; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMFC2MMa"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e614da8615so948184a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 10 Mar 2025 20:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741662609; x=1742267409; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8rhcitOYrqxP9erHkLxD9laxmF8PKh1UUsigNJPPPio=;
        b=CMFC2MMa0V6yudoDQzbXY8MoW1dTRwfLm3fSxzWfoon7R/sCnvUTgP0GChRrU0acl7
         bX5Ty1S9dCMskV/i6b2L6/yyBYgji63njJJc0p4bdp/925iUNk6plKT+tPt0O7Vmppu7
         HNpY/6e6sVscMTuVVxIf8+EkdYLloj5cog07NKkDyptTpT+YP9za53UO2mpdx02agzBN
         0SrOE1fOrPS6sAQ3YSrXpJ1dUD+wIb3Zk1TFSGyVKmbv7mDusTeWgj0rgzqpH4mipYmH
         Ff5h5z23//d7L/FyFX+PRlKrv53diSXVJYrvel3eQcjtK7tKWEuljLUqoFDWgx9VxVGd
         /d3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741662609; x=1742267409;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8rhcitOYrqxP9erHkLxD9laxmF8PKh1UUsigNJPPPio=;
        b=SmeSANCl9Jtt/9/QEtYpcpushl8BuWjCtqa2mcwdWqGEN6tx7eZwjwBbX5uK4zlCYH
         HL9nHBz9tLAQufQt8nRw4q8ofDSeTx5cGq9O3ul4VQuC/R+Pw9OMF8IIsMM70tR0GwTz
         iwTgc07dUVb3QjfgxOKCNQiqyvSpIWrYHT7UrrCEIP7gKGdz0xLVh0Bsgsqja68eMSYn
         o+JCYq1+c7gwh/PNi0yQ4A/7Tsx6IVQ0eMenQFWyooxv4GLfBiyTtgpa+6+HN/ot2USq
         AMH9v8uyX2szXObDg2AAdrrQregVhkmAu3YwwsoKKk40A+/0BnhHgVLeGbaFL4iPwEbv
         39Cw==
X-Gm-Message-State: AOJu0YxLq6mvmoMQJvhk5LxnD+wQFaqodIqLa5J48Iq71FsOsu/0t89s
	eew03vsiCHv83gwJ3ZWlONx7XwBKUOtUnwSjdxjsn26O/zxb02G2FnTq9fNaQBBQMd/xHIuj8kk
	lI5UmuPTJ1NTcsPeLLPYrk5ggho/94A==
X-Gm-Gg: ASbGncufomW0nJ2aoacdROLX8wMgOdfgfrj2pl7H6QKXtyBGz2oFGecQsQu3W75eTXS
	FucxibL20+OjrIt4/basksiy6g4JsfJ7SBcNpenKMyt30lF7n4YpQz3soB6jUk4QxsKl9nqMEM2
	KM0BeOjW+N/giGn3jgTfne5dtLwbs3+h6PTwcGX5eHSZtk+CUJYVeg//coY77J
X-Google-Smtp-Source: AGHT+IGPoDO1jWS/ydBPyfzIkxDt0f79IWphwX4yollIHWgM+abt7TTNRj5orL+ucviSGdA2qdrcf9Zoc1YrHqfPUJc=
X-Received: by 2002:a05:6402:5cb:b0:5de:572c:72cf with SMTP id
 4fb4d7f45d1cf-5e7631dbdd9mr1588013a12.10.1741662609194; Mon, 10 Mar 2025
 20:10:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 10 Mar 2025 22:09:56 -0500
X-Gm-Features: AQ5f1JrvNkNIzPMUS4_SvD_GgWKs1f331kTlH7Mi67UVG1yVZ5K7WCGG_enXxGY
Message-ID: <CAH2r5muQRk_-JdHbPcGY9Zu7BYZ50nYHRSDJbbTA=Mi2EdBDuA@mail.gmail.com>
Subject: two patches added to cifs-utils for-next branch
To: CIFS <linux-cifs@vger.kernel.org>
Cc: =?UTF-8?Q?Pavel_Filipensk=C3=BD?= <pfilipensky@samba.org>
Content-Type: multipart/mixed; boundary="00000000000023f7890630086d82"

--00000000000023f7890630086d82
Content-Type: text/plain; charset="UTF-8"

See attached.  Also added to my smb3-utils repo on github

If any objections or review comments, let us know.



-- 
Thanks,

Steve

--00000000000023f7890630086d82
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0002-resolve_host.c-Initialize-site_name.patch"
Content-Disposition: attachment; 
	filename="0002-resolve_host.c-Initialize-site_name.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m83wxeu60>
X-Attachment-Id: f_m83wxeu60

RnJvbSBhYTU2NjZhM2FhODA4ZDFjNGQzMzc0MTkyYzY4ZmVmNGY0YTNkM2E2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UGF2ZWw9MjBGaWxpcGVuc2s9QzM9QkQ/PSA8
cGZpbGlwZW5za3lAc2FtYmEub3JnPgpEYXRlOiBXZWQsIDkgT2N0IDIwMjQgMTI6Mzk6MjMgKzAy
MDAKU3ViamVjdDogW1BBVENIIDIvMl0gcmVzb2x2ZV9ob3N0LmM6IEluaXRpYWxpemUgc2l0ZV9u
YW1lCk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1V
VEYtOApDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0CgpyZXBvcnRlZCBieSBSZWQgSGF0
IGNvZGUgYW5hbHl6ZXI6CgpjaWZzLXV0aWxzLTcuMS9yZXNvbHZlX2hvc3QuYzoxODg6MzogdW5p
bml0X3VzZV9pbl9jYWxsOiBVc2luZwp1bmluaXRpYWxpemVkIHZhbHVlICIqc2l0ZV9uYW1lIiBh
cyBhcmd1bWVudCB0byAiJXMiIHdoZW4gY2FsbGluZwoic25wcmludGYiLgoKU2lnbmVkLW9mZi1i
eTogUGF2ZWwgRmlsaXBlbnNrw70gPHBmaWxpcGVuc2t5QHNhbWJhLm9yZz4KU2lnbmVkLW9mZi1i
eTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIHJlc29sdmVfaG9z
dC5jIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQgYS9y
ZXNvbHZlX2hvc3QuYyBiL3Jlc29sdmVfaG9zdC5jCmluZGV4IGZjNjgyZTUuLjkxOGM2YWQgMTAw
NjQ0Ci0tLSBhL3Jlc29sdmVfaG9zdC5jCisrKyBiL3Jlc29sdmVfaG9zdC5jCkBAIC0xNDcsNiAr
MTQ3LDcgQEAgaW50IHJlc29sdmVfaG9zdChjb25zdCBjaGFyICpob3N0LCBjaGFyICphZGRyc3Ry
KSB7CiAJCQlnb3RvIHJlc29sdmVfaG9zdF9vdXQ7CiAKIAkJY2hhciBzaXRlX25hbWVbTUFYQ0RO
QU1FXTsKKwkJc2l0ZV9uYW1lWzBdID0gJ1wwJzsKIAkJLy8gV2UgYXNzdW1lIHRoYXQgQUQgYWx3
YXlzIHNlbmRzIHRoZSBpcCBhZGRyZXNzZXMgaW4gdGhlIGFkZHRpb25hbCBkYXRhIGJsb2NrCiAJ
CWZvciAoaW50IGkgPSAwOyBpIDwgbnNfbXNnX2NvdW50KGdsb2JhbF9kb21haW5faGFuZGxlLCBu
c19zX2FyKTsgaSsrKSB7CiAJCQluc19yciBycjsKLS0gCjIuNDMuMAoK
--00000000000023f7890630086d82
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0001-cldap_ping-Fix-socket-fd-leak.patch"
Content-Disposition: attachment; 
	filename="0001-cldap_ping-Fix-socket-fd-leak.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m83wxeun1>
X-Attachment-Id: f_m83wxeun1

RnJvbSA5MDE0MDlhMmVmNmJiNWI3MmE2Zjc3NDcxM2Y3NTRlYzdjYzNlY2EyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UGF2ZWw9MjBGaWxpcGVuc2s9QzM9QkQ/PSA8
cGZpbGlwZW5za3lAc2FtYmEub3JnPgpEYXRlOiBXZWQsIDkgT2N0IDIwMjQgMTI6Mzc6MTIgKzAy
MDAKU3ViamVjdDogW1BBVENIIDEvMl0gY2xkYXBfcGluZzogRml4IHNvY2tldCBmZCBsZWFrCk1J
TUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYtOApD
b250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0CgpyZXBvcnRlZCBieSBSZWQgSGF0IGNvZGUg
YW5hbHl6ZXI6CgpjaWZzLXV0aWxzLTcuMS9jbGRhcF9waW5nLmM6MzIzOjM6IGxlYWtlZF9oYW5k
bGU6IEhhbmRsZSB2YXJpYWJsZSAic29jayIgZ29pbmcgb3V0IG9mIHNjb3BlIGxlYWtzIHRoZSBo
YW5kbGUuCgpTaWduZWQtb2ZmLWJ5OiBQYXZlbCBGaWxpcGVuc2vDvSA8cGZpbGlwZW5za3lAc2Ft
YmEub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogY2xkYXBfcGluZy5jIHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKQoKZGlmZiAtLWdpdCBhL2NsZGFwX3BpbmcuYyBiL2NsZGFwX3BpbmcuYwppbmRleCBhNjAz
YmUzLi41YzIwZjg0IDEwMDY0NAotLS0gYS9jbGRhcF9waW5nLmMKKysrIGIvY2xkYXBfcGluZy5j
CkBAIC0zMTgsOSArMzE4LDExIEBAIGludCBjbGRhcF9waW5nKGNoYXIgKmRvbWFpbiwgc2FfZmFt
aWx5X3QgZmFtaWx5LCB2b2lkICphZGRyLCBjaGFyICpzaXRlX25hbWUpIHsKIAogCXN0cnVjdCB0
aW1ldmFsIHRpbWVvdXQgPSB7LnR2X3NlYyA9IDIsIC50dl91c2VjID0gMH07CiAJaWYgKHNldHNv
Y2tvcHQoc29jaywgU09MX1NPQ0tFVCwgU09fU05EVElNRU8sICZ0aW1lb3V0LCBzaXplb2YodGlt
ZW91dCkpIDwgMCkgeworCQljbG9zZShzb2NrKTsKIAkJcmV0dXJuIENMREFQX1BJTkdfTkVUV09S
S19FUlJPUjsKIAl9CiAJaWYgKHNldHNvY2tvcHQoc29jaywgU09MX1NPQ0tFVCwgU09fUkNWVElN
RU8sICZ0aW1lb3V0LCBzaXplb2YodGltZW91dCkpIDwgMCkgeworCQljbG9zZShzb2NrKTsKIAkJ
cmV0dXJuIENMREFQX1BJTkdfTkVUV09SS19FUlJPUjsKIAl9CiAKLS0gCjIuNDMuMAoK
--00000000000023f7890630086d82--
