Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA99187872
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 19:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737314516; cv=none; b=JJXIqAkbUNGFdSP4+vubRy9TZPnRBfvYJOgc/33t5HmBHrQ0Rt0KC2X7eKd70n/bXklQXxSLlebhZA6pAOl/sQMbDU77U0d7HdQXrSMlF4P2wMAHdbKArDLS7QyCIJUz9lhesmvwz5jeuOaeTenOZCuvBsuBWEp8gimqtjsZXg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737314516; c=relaxed/simple;
	bh=QWV/+St8DbiKz06xOkXykorrzRluFIExlc8fzm+mPno=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=HBtg1YRBkNN6mj+fWfYggd246G6KF/Eej0LJ2WljzfYRyQkQ63k5P87xWMadGEdf7AE7wvJ7bgmgE0ruMBYFe6c/LkudHjqPp9qPaTr3G+cNtawayUkZnzZn3CJXIZuO4pPQis5ktcaOqLrPYcWZsQHPTkOitkxdJM/XIAHf7xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RtF18hBb; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RtF18hBb"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-54024ecc33dso3774778e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 11:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737314513; x=1737919313; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RW/I1gwVCzkTdEikvtdUVVolbvp1q/1QHsSgKe/FT+Y=;
        b=RtF18hBbm9KuyGDuJNxMd9PoDo1m//GKLpRrpeDDWyPHN2cED0oE1FKPVyRQH+qL1m
         8lkiP/Cix9OmQzzGljzTpA4xHz/aDOxk9JnqGJsauKIJfaYPhxIbpmAGLhBKltN8AhOr
         u5J5lhNKSgkGFauTHGTzYsdYyXsXYbC9PrangABad04fdaf1YKju4hRrUHSv6Hl2UJ2i
         lJru+TS3HuvqU4NVAAcaQ8sl79MLQaLi6u1lSfJ1leXOFHsohGqLPFTOlA8lLey1V/KC
         FRwvaFeOjQ54v08+U1Nq7CHs1Zg7kTjOFfX7QGS/GM25ToK5P8si9KONW7PrNG23AUh2
         etQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737314513; x=1737919313;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RW/I1gwVCzkTdEikvtdUVVolbvp1q/1QHsSgKe/FT+Y=;
        b=xPbtmgvvX46vZji73NmMyZAL9z3cA42um0mBIuZH/LPNVAfSOpkq5r7JH0raio/2Ni
         fTIuC6cOsGJrzGxWMjXg+beIkZRQUvUGyJXp2was5UVYk/Gbo1PmUaSLQ80LGoqZxz4D
         BVElBvdj8iKVpZgsAzOxSjXFo3L3c0DwNUorGyirkJP/5vOKAqPG2P/0TBGp/kveASCY
         VZFeYsB0S/1M4hxKWNid59BtKl2I/DqbkbMIgSQkEBfcDLr72aCo4IA+vLiaScwrTrn6
         uShu2fTpJHNedXu+ewhOLE+B/Mzx73z+LY264ahFZUQc4FJmuPK4PCZ1LHAutCO/jCeo
         +D0Q==
X-Gm-Message-State: AOJu0Yx4qoMjPVUO9rRRtUUyp3xdcNeiLc1YYXfY6C3s3j3R6RmM0QH/
	Gbs2PrjrkTbPTwU61grHRxE8gN/GNTC503m7Ws7cOHxPMGR3oM2nn2tJISLamLYJuMQDsjWYzDc
	1MjQ13EQrxPYi6vXC6VcjUNqTrSo=
X-Gm-Gg: ASbGnctsVUrYCUiZ1E9egQC1vLPFoxRNpGYtkdMGiRs5fZx9z99QkWz4ZizDoAzPiAP
	HP+tz+HY3mR76ozlBaPKudOyPOxuVcQfPXqh5AEY2d8U4LaFMbucpB9JGZvvJoZxowrmT5YbvKC
	p+stUNnfw=
X-Google-Smtp-Source: AGHT+IF8h+1IZEfkGf9XhEbsuoGxJpJGrDpf0Hlnahd4oiwTDv2/pDaLMBlGnMFjJsJcNtZMRKnQlPyUbOb4Jp4aV1Q=
X-Received: by 2002:ac2:5230:0:b0:541:1c48:8c0d with SMTP id
 2adb3069b0e04-5439c285a31mr3116237e87.49.1737314513013; Sun, 19 Jan 2025
 11:21:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 19 Jan 2025 13:21:39 -0600
X-Gm-Features: AbW1kvb4WgC7ALSIIw_h25nPJmcpt344c52JTZS6MXMkgjG5X4L2MSehXgML9Pg
Message-ID: <CAH2r5mu+P1n18+EgdzqB_FmcEWXoaEqacqa6osKHtb05B1bBbQ@mail.gmail.com>
Subject: [PATCH] cifs: Fix endian types in struct rfc1002_session_packet
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000697af3062c140ecd"

--000000000000697af3062c140ecd
Content-Type: text/plain; charset="UTF-8"

    > All fields in struct rfc1002_session_packet are in big endian. This is
    > because all NetBIOS packet headers are in big endian as opposite of SMB
    >structures which are in little endian.
    > Therefore use __be16 and __be32 types instead of __u16 and __u32 in
    >struct rfc1002_session_packet.
    >
    >Reported-by: kernel test robot <lkp@intel.com>

Do you have a link to the kernel bot reported by (email?)

-- 
Thanks,

Steve

--000000000000697af3062c140ecd
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0029-cifs-Fix-endian-types-in-struct-rfc1002_session_pack.patch"
Content-Disposition: attachment; 
	filename="0029-cifs-Fix-endian-types-in-struct-rfc1002_session_pack.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m6405hgg0>
X-Attachment-Id: f_m6405hgg0

RnJvbSBiYmQ4YWQwZDg5OTRkNDQ4YWExMmU5ZGY1ZmUyM2U1ODQ3NzI5OTA5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UGFsaT0yMFJvaD1DMz1BMXI/PSA8cGFsaUBr
ZXJuZWwub3JnPgpEYXRlOiBXZWQsIDI1IERlYyAyMDI0IDE1OjU0OjIyICswMTAwClN1YmplY3Q6
IFtQQVRDSCAyOS83MV0gY2lmczogRml4IGVuZGlhbiB0eXBlcyBpbiBzdHJ1Y3QgcmZjMTAwMl9z
ZXNzaW9uX3BhY2tldApNSU1FLVZlcnNpb246IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47
IGNoYXJzZXQ9VVRGLTgKQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKQWxsIGZpZWxk
cyBpbiBzdHJ1Y3QgcmZjMTAwMl9zZXNzaW9uX3BhY2tldCBhcmUgaW4gYmlnIGVuZGlhbi4gVGhp
cyBpcwpiZWNhdXNlIGFsbCBOZXRCSU9TIHBhY2tldCBoZWFkZXJzIGFyZSBpbiBiaWcgZW5kaWFu
IGFzIG9wcG9zaXRlIG9mIFNNQgpzdHJ1Y3R1cmVzIHdoaWNoIGFyZSBpbiBsaXR0bGUgZW5kaWFu
LgoKVGhlcmVmb3JlIHVzZSBfX2JlMTYgYW5kIF9fYmUzMiB0eXBlcyBpbnN0ZWFkIG9mIF9fdTE2
IGFuZCBfX3UzMiBpbgpzdHJ1Y3QgcmZjMTAwMl9zZXNzaW9uX3BhY2tldC4KClJlcG9ydGVkLWJ5
OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogUGFsaSBS
b2jDoXIgPHBhbGlAa2VybmVsLm9yZz4KLS0tCiBmcy9zbWIvY2xpZW50L3JmYzEwMDJwZHUuaCB8
IDYgKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvcmZjMTAwMnBkdS5oIGIvZnMvc21iL2NsaWVu
dC9yZmMxMDAycGR1LmgKaW5kZXggYWUxZDAyNWRhMjk0Li5hYzgyYzJmM2E0YTIgMTAwNjQ0Ci0t
LSBhL2ZzL3NtYi9jbGllbnQvcmZjMTAwMnBkdS5oCisrKyBiL2ZzL3NtYi9jbGllbnQvcmZjMTAw
MnBkdS5oCkBAIC0yNCw3ICsyNCw3IEBACiBzdHJ1Y3QgcmZjMTAwMl9zZXNzaW9uX3BhY2tldCB7
CiAJX191OAl0eXBlOwogCV9fdTgJZmxhZ3M7Ci0JX191MTYJbGVuZ3RoOworCV9fYmUxNglsZW5n
dGg7CiAJdW5pb24gewogCQlzdHJ1Y3QgewogCQkJX191OCBjYWxsZWRfbGVuOwpAQCAtMzUsOCAr
MzUsOCBAQCBzdHJ1Y3QgcmZjMTAwMl9zZXNzaW9uX3BhY2tldCB7CiAJCQlfX3U4IHNjb3BlMjsg
LyogbnVsbCAqLwogCQl9IF9fYXR0cmlidXRlX18oKHBhY2tlZCkpIHNlc3Npb25fcmVxOwogCQlz
dHJ1Y3QgewotCQkJX191MzIgcmV0YXJnZXRfaXBfYWRkcjsKLQkJCV9fdTE2IHBvcnQ7CisJCQlf
X2JlMzIgcmV0YXJnZXRfaXBfYWRkcjsKKwkJCV9fYmUxNiBwb3J0OwogCQl9IF9fYXR0cmlidXRl
X18oKHBhY2tlZCkpIHJldGFyZ2V0X3Jlc3A7CiAJCV9fdTggbmVnX3Nlc19yZXNwX2Vycm9yX2Nv
ZGU7CiAJCS8qIFBPU0lUSVZFX1NFU1NJT05fUkVTUE9OU0UgcGFja2V0IGRvZXMgbm90IGluY2x1
ZGUgdHJhaWxlci4KLS0gCjIuNDMuMAoK
--000000000000697af3062c140ecd--
