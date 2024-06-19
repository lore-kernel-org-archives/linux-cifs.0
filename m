Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BCB4A19
	for <linux-cifs@vger.kernel.org>; Wed, 19 Jun 2024 20:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718827351; cv=none; b=vAS6XMAqwvk3dbEQOiiJ5DVSnwr6OTBd+nt/tGn/aPEs9IW7PG1FGsoPFwk0FNI10t9fGom76h3+kijia30HMeQjBVqIYR5LhOr9DKTl5RJTk4tqZ8t1UUPf9sdtBP6fIojVmpfWA2SaD19FG/imV7J3TIVHiMCvf3fZTyvbXcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718827351; c=relaxed/simple;
	bh=jyJ46qsG+aRr7XBVNcvu4lYMN/u7gnkmPmc3b2yv7ow=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=GC2530Fk0PDNFWa84cnxE3zFL7KFqpo8w55aOeFwUuSReezTfQ+3YD9sC2QpCqFpmJ08JNHRrkpbyxHPCruSluRvuiyMaoA8qtKw08dOd4WJR+ZT5HYWnaL3bxl8Y1YFC017iEL1CfxK82mF+RVSI++VqcLTdJkBT6C5CbBBlAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GC1wHRuu; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GC1wHRuu"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ebe3fb5d4dso1633891fa.0
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jun 2024 13:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718827348; x=1719432148; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ObTKtlaoAucWuUDiB7Ljvkt+4uv8qsHp5amrOpfAu8w=;
        b=GC1wHRuuSPYfHtvk+bt4rdwH2f+z03sskb5ceX8PIN/M3/wfrwv9T9JYHfv5Zv6qM4
         mdgrYi7HNwqaPfVuDcu1W46bdn/aBBzSq6mkKdHypwBS5QBX24ebzBOvtpeTM8KX7svu
         IPWIjToEaOZIjTyM8RoMijEXNujKbKoIJuUySQizYPTd2algWpeSdtmv0+GwjAlxnoWj
         K665kVlAkwBGJCeE5QSL1kwaMuhJhjSOzZCe4fjr82WT6GFTi4V9uA5o19V22+ZEHgm0
         FbW/6ku5X7BYLwzcG0h+v24ussYGu8APclkbn2fzCzqYmO4DCW1Muo0ifuMHL9ZjAgt9
         qpTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718827348; x=1719432148;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ObTKtlaoAucWuUDiB7Ljvkt+4uv8qsHp5amrOpfAu8w=;
        b=uX2BzmJ5JJ3dzfSJDytgcVxtjBHAgNVzIDeY3a0TIPtxaliFSqD1b0LCOUeUSYyrnC
         y08ZFQcIrWAy5cx/mD1IYASQO8a6bWBXDYmbqbqCfuTGmtgEX1Ayx0Vr5c2S1XKvP262
         p/iC9u5pwjXyt22nJD0fGZcYfNq3BGEzwm8CqxWZ5nOCLLhKUTHxBYaXiecJd1jkOqOP
         hd7ChnEeiknmCcvRohXft25ZMf4PxKb0SadSrzXaxNNrRNiR4Xjj25hb0sOtPuZ+dyYT
         rama0qfetFrF4aLYFe5dzBc00zyZ9o73IihYqQG7EQ2LRjb5Eh7+ze6kPnm1VIObfosq
         26EA==
X-Gm-Message-State: AOJu0Yygztw7IgfqrwcA38oQYRmSXV/pvNjvNNW4e9krjvGFEtkp2D2M
	VZTWGRJXtq0aS45pqF90F6/IuM6LtyHHuMivEcAOZWNLh5yXpPrR/1mIt1zics524/BWT0XVRbn
	bopbQy55vG1/JJ15VuO9NV5CqGWUu3uby
X-Google-Smtp-Source: AGHT+IE3mjtYTiVPHQBo+4xKQHM3j4/HpnZWXTf5BjtCKQn6ZLjhWTnqEr5ETpMRt9hufBzq2NdH2G4Do2x56MqNkKg=
X-Received: by 2002:a2e:9d90:0:b0:2ec:3747:fcc4 with SMTP id
 38308e7fff4ca-2ec374800b1mr16975501fa.5.1718827347633; Wed, 19 Jun 2024
 13:02:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 19 Jun 2024 15:02:16 -0500
Message-ID: <CAH2r5mviMs7VW5ofa0hZiVkx6RdH-LcnpYYDhyGOxnXxtB=t=A@mail.gmail.com>
Subject: [PATCH][SMB client] fix typo in description of enable_gcm_256 module
 load parameter
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000007c8454061b43ad2a"

--0000000000007c8454061b43ad2a
Content-Type: text/plain; charset="UTF-8"

enable_gcm_256 (which allows the server to require the strongest
encryption) is enabled by default (in the 5.13 kernel and later), but
the modinfo description
incorrectly showed it disabled by default. Fix the typo.

Cc: stable@vger.kernel.org
Fixes: fee742b50289 ("smb3.1.1: enable negotiating stronger encryption
by default")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index bb86fc0641d8..6397fdefd876 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -134,7 +134,7 @@ module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");

 module_param(enable_gcm_256, bool, 0644);
-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256
bit) GCM encryption. Default: n/N/0");
+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256
bit) GCM encryption. Default: y/Y/0");

 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM
encryption. Default: n/N/0");

-- 
Thanks,

Steve

--0000000000007c8454061b43ad2a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-typos-in-module-parameter-enable_gcm_256.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-typos-in-module-parameter-enable_gcm_256.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lxm97mp70>
X-Attachment-Id: f_lxm97mp70

RnJvbSBjMzc2NDBjNjk1NzRiNDI0ZTY4N2M0ZTNmYWMxNWM4YzJhOTM0M2Q1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTkgSnVuIDIwMjQgMTQ6NDY6NDggLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggdHlwb3MgaW4gbW9kdWxlIHBhcmFtZXRlciBlbmFibGVfZ2NtXzI1NgoKZW5hYmxl
X2djbV8yNTYgKHdoaWNoIGFsbG93cyB0aGUgc2VydmVyIHRvIHJlcXVpcmUgdGhlIHN0cm9uZ2Vz
dAplbmNyeXB0aW9uKSBpcyBlbmFibGVkIGJ5IGRlZmF1bHQsIGJ1dCB0aGUgbW9kaW5mbyBkZXNj
cmlwdGlvbgppbmNvcnJlY3RseSBzaG93ZWQgaXQgZGlzYWJsZWQgYnkgZGVmYXVsdC4gRml4IHRo
ZSB0eXBvLgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKRml4ZXM6IGZlZTc0MmI1MDI4OSAo
InNtYjMuMS4xOiBlbmFibGUgbmVnb3RpYXRpbmcgc3Ryb25nZXIgZW5jcnlwdGlvbiBieSBkZWZh
dWx0IikKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29t
PgotLS0KIGZzL3NtYi9jbGllbnQvY2lmc2ZzLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2Np
ZnNmcy5jIGIvZnMvc21iL2NsaWVudC9jaWZzZnMuYwppbmRleCBiYjg2ZmMwNjQxZDguLjYzOTdm
ZGVmZDg3NiAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYworKysgYi9mcy9zbWIv
Y2xpZW50L2NpZnNmcy5jCkBAIC0xMzQsNyArMTM0LDcgQEAgbW9kdWxlX3BhcmFtKGVuYWJsZV9v
cGxvY2tzLCBib29sLCAwNjQ0KTsKIE1PRFVMRV9QQVJNX0RFU0MoZW5hYmxlX29wbG9ja3MsICJF
bmFibGUgb3IgZGlzYWJsZSBvcGxvY2tzLiBEZWZhdWx0OiB5L1kvMSIpOwogCiBtb2R1bGVfcGFy
YW0oZW5hYmxlX2djbV8yNTYsIGJvb2wsIDA2NDQpOwotTU9EVUxFX1BBUk1fREVTQyhlbmFibGVf
Z2NtXzI1NiwgIkVuYWJsZSByZXF1ZXN0aW5nIHN0cm9uZ2VzdCAoMjU2IGJpdCkgR0NNIGVuY3J5
cHRpb24uIERlZmF1bHQ6IG4vTi8wIik7CitNT0RVTEVfUEFSTV9ERVNDKGVuYWJsZV9nY21fMjU2
LCAiRW5hYmxlIHJlcXVlc3Rpbmcgc3Ryb25nZXN0ICgyNTYgYml0KSBHQ00gZW5jcnlwdGlvbi4g
RGVmYXVsdDogeS9ZLzAiKTsKIAogbW9kdWxlX3BhcmFtKHJlcXVpcmVfZ2NtXzI1NiwgYm9vbCwg
MDY0NCk7CiBNT0RVTEVfUEFSTV9ERVNDKHJlcXVpcmVfZ2NtXzI1NiwgIlJlcXVpcmUgc3Ryb25n
ZXN0ICgyNTYgYml0KSBHQ00gZW5jcnlwdGlvbi4gRGVmYXVsdDogbi9OLzAiKTsKLS0gCjIuNDMu
MAoK
--0000000000007c8454061b43ad2a--
