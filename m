Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9C314A0BC
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 16:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714063465; cv=none; b=EbZ2UVB4itrqHKFm8HLjnNnafcaMyP27Ya3yRbcGdR9sJ0/XTV1B723ZuB94v8piZ1ILnQJDVyLZk51JEis8zfv/u8H1jgM8R8B9ZB1EnRlsdHFLhsUq9OtkOhJM9NWCVW5TVSmgIPvtRHcU2QnokObgcnyWTAulzlzdBcUlEdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714063465; c=relaxed/simple;
	bh=y2EqmehhW54mcD/zvSKGA8COj7PnRnGS2as1YDACdt4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=blg0J6PrUy1cCWZS4CgmXJvmh00kIlAXAl5R/vNc1oBH4mIxZilUv6on6OE1ZWqvTXfth8lzTKPnM2+uoL50dvJojG8uRiT5v0u0OKGygkrZ5RccAjpJNYCnlLg9a+gvroqfgRX7QrRx2C8vZlhsXnEusR6JRT0cHayPGI05D04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bbtP917v; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbtP917v"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-51ae2e37a87so1469489e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 09:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714063462; x=1714668262; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lrGKcYGp8mRpiMoDMfLNLKsUgEEM5NHWg9cDoJ5/RDo=;
        b=bbtP917vXm85L1c31Da7g3UHICxuGpsVh7jtaDxgFccQg+G1+qhb5P3QMLHG8wQ85o
         GUlY707vyTSoh52Ou6NGNfzHhbxvGL+Fh4T6aC9JL/DGRTbNMn3Col0Ec/DNQmFdDYph
         qMF/2ymrVvKoSRSj5FGfc8L6e1knGMTowuA1g8+S+g0GX3J9CUpRPVt/sDiQnnDnaAGD
         L9BWBvEQppEDdY3R/WsZmoBK0PvoUrVxIBJXyiFgqZgg9Cu30pDrfhDGa8Qi9/mMoX9L
         XWhA9l69GZfg1FpqSSytOZL4T0oenJ94oycWoCstQVAW2oxwqRJqnPmshjEWdA4xtrl6
         8X4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714063462; x=1714668262;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lrGKcYGp8mRpiMoDMfLNLKsUgEEM5NHWg9cDoJ5/RDo=;
        b=UT/9h1xI6nWKp3gd2352yWs7L/UpxTWaVF5I9xXzGzIrlYgcyuObd0SZXtLvBflw/N
         rvGfmRBtVJRmRy5a59WvPuxIrVSPe7pEHqUGv268yPwC02PccuLKA48xNcZsJRDpzNiA
         kS2p9YI0XFbz9Qbwl0nHQTiThRl8L3TsbQE6LQbgba03zMTWpWmJb1ZIsPxdfQlNnNjE
         LJw6G1V1EMN+8rOme9XK/CcxDHrhek6gx/ETBIf7UxlDxOEb1GCNlgEqCbBkhXGrsRtn
         XUMeS0J8XVafF0P2RSBB17B/9600ZtgM5bZVO/npxggCgJXFt1pvA2zwfh6XA+M9hqYZ
         niMw==
X-Gm-Message-State: AOJu0YxRE2OtbYGNCVgiKBFABvFxBRG8FwH422SoTUtCP9K2Utsekiab
	r3+kb1HFBAVMqIyAproWMxJhzLMM5g4NqckNPPipKLHlFCle9YEGTNP8Jt7vtJNPwVClB+PtvLM
	CoAWmU0DIrWhonugp6zYFmGFT0WV5Q4kE
X-Google-Smtp-Source: AGHT+IGcAHJ35lR9syhu5dvxK9qe/yzOpsHk5cEIcA4M7qKuOFEdyXp2XtVM8qop/b9lxX1+4o4GBHHmZK9gLFnYX3I=
X-Received: by 2002:a05:6512:2101:b0:51a:d0d2:8613 with SMTP id
 q1-20020a056512210100b0051ad0d28613mr3813028lfr.0.1714063461393; Thu, 25 Apr
 2024 09:44:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 25 Apr 2024 11:44:08 -0500
Message-ID: <CAH2r5ms2xmxgZ08pecifj+Za=_oWnrhVOUgifjYLnCw+Rz9_kA@mail.gmail.com>
Subject: [PATCH][SMB3 client] missing lock when picking channel
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000bd50610616ee7f9b"

--000000000000bd50610616ee7f9b
Content-Type: text/plain; charset="UTF-8"

Coverity spotted a place where we should have been holding the
channel lock when accessing the ses channel index.

Addresses-Coverity: 1582039 ("Data race condition (MISSING_LOCK)")
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 443b4b89431d..fc0ddc75abc9 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1059,9 +1059,11 @@ struct TCP_Server_Info
*cifs_pick_channel(struct cifs_ses *ses)
  index = (uint)atomic_inc_return(&ses->chan_seq);
  index %= ses->chan_count;
  }
+
+ server = ses->chans[index].server;
  spin_unlock(&ses->chan_lock);

- return ses->chans[index].server;
+ return server;
 }

-- 
Thanks,

Steve

--000000000000bd50610616ee7f9b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-smb3-missing-lock-when-picking-channel.patch"
Content-Disposition: attachment; 
	filename="0002-smb3-missing-lock-when-picking-channel.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lvfh2n440>
X-Attachment-Id: f_lvfh2n440

RnJvbSA1ZWM5OTVjMzNjYzMwZjFjZmIyNmFiMDEyNmMwNzdjYTgyZjY0YTA2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjUgQXByIDIwMjQgMTE6MzA6MTYgLTA1MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gc21iMzogbWlzc2luZyBsb2NrIHdoZW4gcGlja2luZyBjaGFubmVsCgpDb3Zlcml0eSBzcG90
dGVkIGEgcGxhY2Ugd2hlcmUgd2Ugc2hvdWxkIGhhdmUgYmVlbiBob2xkaW5nIHRoZQpjaGFubmVs
IGxvY2sgd2hlbiBhY2Nlc3NpbmcgdGhlIHNlcyBjaGFubmVsIGluZGV4LgoKQWRkcmVzc2VzLUNv
dmVyaXR5OiAxNTgyMDM5ICgiRGF0YSByYWNlIGNvbmRpdGlvbiAoTUlTU0lOR19MT0NLKSIpCkNj
OiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3Rm
cmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L3RyYW5zcG9ydC5jIHwgNCAr
KystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZm
IC0tZ2l0IGEvZnMvc21iL2NsaWVudC90cmFuc3BvcnQuYyBiL2ZzL3NtYi9jbGllbnQvdHJhbnNw
b3J0LmMKaW5kZXggNDQzYjRiODk0MzFkLi5mYzBkZGM3NWFiYzkgMTAwNjQ0Ci0tLSBhL2ZzL3Nt
Yi9jbGllbnQvdHJhbnNwb3J0LmMKKysrIGIvZnMvc21iL2NsaWVudC90cmFuc3BvcnQuYwpAQCAt
MTA1OSw5ICsxMDU5LDExIEBAIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKmNpZnNfcGlja19jaGFu
bmVsKHN0cnVjdCBjaWZzX3NlcyAqc2VzKQogCQlpbmRleCA9ICh1aW50KWF0b21pY19pbmNfcmV0
dXJuKCZzZXMtPmNoYW5fc2VxKTsKIAkJaW5kZXggJT0gc2VzLT5jaGFuX2NvdW50OwogCX0KKwor
CXNlcnZlciA9IHNlcy0+Y2hhbnNbaW5kZXhdLnNlcnZlcjsKIAlzcGluX3VubG9jaygmc2VzLT5j
aGFuX2xvY2spOwogCi0JcmV0dXJuIHNlcy0+Y2hhbnNbaW5kZXhdLnNlcnZlcjsKKwlyZXR1cm4g
c2VydmVyOwogfQogCiBpbnQKLS0gCjIuNDAuMQoK
--000000000000bd50610616ee7f9b--
