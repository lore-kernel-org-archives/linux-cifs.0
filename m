Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428DB746E
	for <linux-cifs@vger.kernel.org>; Sun, 22 Sep 2024 04:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726980505; cv=none; b=AjMySOqAY5v6KWdBSIMNp0K8z+uaKKvg+2fh/GqUh99SU+XYUWTzmcWK+DNtzvHqtH7dGVhXBXobs58G3liOjDBNBfb06KZsOukkWpeuwKaV53EGhCHm7vp9W7tYcnOtJZ9HRAiEQHYCBCSJiU+7vHv2SyunG+OTuW5twgEcI+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726980505; c=relaxed/simple;
	bh=oHHMNeRAQu9NLstWzLmSI0EBBLnamsOJ8Fjm6e8kd9s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Pme0GwaeOWeDkthXAH3O0qjiqxdXgAqmdJCNLgYz5XLk4aORNRgYDE2SLIF+GZNDuLchjpIBddUsdi03AunIdVfGrHv+Sum932cVXtRUg5LBScAMksjpCm5p9n47ZMAri9eQLoYJ5gL2toMyTm00XO3wzH2kJ05NT7tdwF8u8ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X01vpx4c; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X01vpx4c"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53567b4c3f4so3501752e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 21 Sep 2024 21:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726980502; x=1727585302; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ve7ook3wQD8EIyjnBvFXXYebcWZemVc3sfN/+ms8WjY=;
        b=X01vpx4cG+5HgFCxkAoYH7kZgwgKjntDQEMpfW9xlH2LGFDgvUOMXkKtCPSEmyDfeP
         ujM5DTy8y2qmvkSINSYzh2SCVNWiEMolXbgN/O0uGKQuFOotBl+Bqsm/eAYdSTGvAd3K
         pR64PkY5ALzuJeeINZDON9GKJWsUkHZsICXr+W6XCqd4cgvuiYtuBuMF6DZ28rWAjMYQ
         aN2YBcwYsDCffAx8mzzyFVL1N/NLVpMwERSWrPFH4uXT1GfosTij3E5fXg9fs8uR9gPl
         YkCe8zXn/ZQmz8pRe5V+kxirRW7DI0NbJ80P7nrcQOulsFsMs5SSZWD8BZzL5KmUn2aD
         AzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726980502; x=1727585302;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ve7ook3wQD8EIyjnBvFXXYebcWZemVc3sfN/+ms8WjY=;
        b=sfmVMEEKT9wtCSw+Gd9utWlo+qF29DlNqIyco0opClOhhhCvSxPAWnr9wbvwyisXvB
         A2rLd8mwnPRWdTDZ2P4+a6jwnaNSKhaD1oq37jJJYo3HY6CC74QOM3yh6xP4J0dISzsc
         ErettDzevQ+t6Yq5bRJSKWjM4jOFiJ8YtsuCoJgV1QTGGGWPsjaiv0l7QhB6dgqwwrow
         t4ehn0KO3vbXHQM4zBkR4UGhJ/4Xdty30U2FtkVwowodoP2QvApKS/4yUTypgmZ/i9W3
         /AtHln9w82juP7w0wHDabEKH6EdB2Uoo5YzyDCL4uwI4QW72SJHMpc7NIq4DDeUr4gLN
         a3jg==
X-Forwarded-Encrypted: i=1; AJvYcCVeKocILdMLKBfgELWhN+PPVh2srjqVRYPueOhSb3YL5TO8/n2EJP5Zgb8IDt71VMmfKEGhYWCo5b52@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4VJ2UhuN0jFlGjtPVZ9g04xKDjt89J20xLbNbLiX7QQQ7kpRD
	kK89JbgQiotALilyT0tuUAlALHejRgJc3+Pkb/fYNNdZlNp+9z6P7hk/+lZHSXxoE3cgJ3WDyFl
	LrGWpqwPCAdaz8OGQE+AnnEU2Z0I=
X-Google-Smtp-Source: AGHT+IGW7VvHOrZ0um5jX8pkZ8aX3XrxnMGnQixIc2TvGq2fpUwtezzJQ5jZIEAxop253UGnvbRlzH0ff+encly4+Ag=
X-Received: by 2002:a05:6512:a8e:b0:536:52c4:e45c with SMTP id
 2adb3069b0e04-536ac2f54b4mr3143712e87.31.1726980502072; Sat, 21 Sep 2024
 21:48:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 21 Sep 2024 23:48:10 -0500
Message-ID: <CAH2r5mtoXf3chr5tmH_em7FZBEaczrPNHpo_U7NYmyicJZTHfw@mail.gmail.com>
Subject: [PATCH][SMB3 client] fix incorrect mode bits reported for stat of
 directories with read only attribute
To: Maxim Patlasov <mpatlaso@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="0000000000005c4f870622adfb45"

--0000000000005c4f870622adfb45
Content-Type: text/plain; charset="UTF-8"

In investigating a problem that Maxim pointed out (with rmdir when
file has read only attribute set - which will be fixed with a
different patch), we noticed a bug with "stat" of directories when
readonly.  See attached fix.

Commands like "chmod 0444" mark a file readonly via the attribute flag
(when mapping of mode bits into the ACL are not set, or POSIX extensions
are not negotiated), but they were not reported correctly for stat of
directories (they were reported ok for files and for "ls").  See example
below:

    root:~# ls /mnt2 -l
    total 12
    drwxr-xr-x 2 root root         0 Sep 21 18:03 normaldir
    -rwxr-xr-x 1 root root         0 Sep 21 23:24 normalfile
    dr-xr-xr-x 2 root root         0 Sep 21 17:55 readonly-dir
    -r-xr-xr-x 1 root root 209716224 Sep 21 18:15 readonly-file
    root:~# stat -c %a /mnt2/readonly-dir
    755
    root:~# stat -c %a /mnt2/readonly-file
    555

This fixes the stat of directories when ATTR_READONLY is set
(in cases where the mode can not be obtained other ways). See
below stat output with patch applied:

    root:~# stat -c %a /mnt2/readonly-dir
    555

-- 
Thanks,

Steve

--0000000000005c4f870622adfb45
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-incorrect-mode-displayed-for-read-only-file.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-incorrect-mode-displayed-for-read-only-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m1d3jlcq0>
X-Attachment-Id: f_m1d3jlcq0

RnJvbSAzODVhODZmYTQ3MDRlYzExZjE5NTY0ZWE0MmVhZjY3N2IyODNlNmNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMjEgU2VwIDIwMjQgMjM6Mjg6MzIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggaW5jb3JyZWN0IG1vZGUgZGlzcGxheWVkIGZvciByZWFkLW9ubHkgZmlsZXMKCkNv
bW1hbmRzIGxpa2UgImNobW9kIDA0NDQiIG1hcmsgYSBmaWxlIHJlYWRvbmx5IHZpYSB0aGUgYXR0
cmlidXRlIGZsYWcKKHdoZW4gbWFwcGluZyBvZiBtb2RlIGJpdHMgaW50byB0aGUgQUNMIGFyZSBu
b3Qgc2V0LCBvciBQT1NJWCBleHRlbnNpb25zCmFyZSBub3QgbmVnb3RpYXRlZCksIGJ1dCB0aGV5
IHdlcmUgbm90IHJlcG9ydGVkIGNvcnJlY3RseSBmb3Igc3RhdCBvZgpkaXJlY3RvcmllcyAodGhl
eSB3ZXJlIHJlcG9ydGVkIG9rIGZvciBmaWxlcyBhbmQgZm9yICJscyIpLiAgU2VlIGV4YW1wbGUK
YmVsb3c6CgogICAgcm9vdDp+IyBscyAvbW50MiAtbAogICAgdG90YWwgMTIKICAgIGRyd3hyLXhy
LXggMiByb290IHJvb3QgICAgICAgICAwIFNlcCAyMSAxODowMyBub3JtYWxkaXIKICAgIC1yd3hy
LXhyLXggMSByb290IHJvb3QgICAgICAgICAwIFNlcCAyMSAyMzoyNCBub3JtYWxmaWxlCiAgICBk
ci14ci14ci14IDIgcm9vdCByb290ICAgICAgICAgMCBTZXAgMjEgMTc6NTUgcmVhZG9ubHktZGly
CiAgICAtci14ci14ci14IDEgcm9vdCByb290IDIwOTcxNjIyNCBTZXAgMjEgMTg6MTUgcmVhZG9u
bHktZmlsZQogICAgcm9vdDp+IyBzdGF0IC1jICVhIC9tbnQyL3JlYWRvbmx5LWRpcgogICAgNzU1
CiAgICByb290On4jIHN0YXQgLWMgJWEgL21udDIvcmVhZG9ubHktZmlsZQogICAgNTU1CgpUaGlz
IGZpeGVzIHRoZSBzdGF0IG9mIGRpcmVjdG9yaWVzIHdoZW4gQVRUUl9SRUFET05MWSBpcyBzZXQK
KGluIGNhc2VzIHdoZXJlIHRoZSBtb2RlIGNhbiBub3QgYmUgb2J0YWluZWQgb3RoZXIgd2F5cyku
CgogICAgcm9vdDp+IyBzdGF0IC1jICVhIC9tbnQyL3JlYWRvbmx5LWRpcgogICAgNTU1CgpDYzog
c3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJl
bmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9pbm9kZS5jIHwgMTkgKysrKysr
KysrKystLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDggZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9pbm9kZS5jIGIvZnMvc21iL2NsaWVu
dC9pbm9kZS5jCmluZGV4IDczZTJlNmMyMzBiNy4uM2NjZjNlNjliZWM2IDEwMDY0NAotLS0gYS9m
cy9zbWIvY2xpZW50L2lub2RlLmMKKysrIGIvZnMvc21iL2NsaWVudC9pbm9kZS5jCkBAIC04MDAs
MTAgKzgwMCw2IEBAIHN0YXRpYyB2b2lkIGNpZnNfb3Blbl9pbmZvX3RvX2ZhdHRyKHN0cnVjdCBj
aWZzX2ZhdHRyICpmYXR0ciwKIAkJZmF0dHItPmNmX21vZGUgPSBTX0lGUkVHIHwgY2lmc19zYi0+
Y3R4LT5maWxlX21vZGU7CiAJCWZhdHRyLT5jZl9kdHlwZSA9IERUX1JFRzsKIAotCQkvKiBjbGVh
ciB3cml0ZSBiaXRzIGlmIEFUVFJfUkVBRE9OTFkgaXMgc2V0ICovCi0JCWlmIChmYXR0ci0+Y2Zf
Y2lmc2F0dHJzICYgQVRUUl9SRUFET05MWSkKLQkJCWZhdHRyLT5jZl9tb2RlICY9IH4oU19JV1VH
Tyk7Ci0KIAkJLyoKIAkJICogRG9uJ3QgYWNjZXB0IHplcm8gbmxpbmsgZnJvbSBub24tdW5peCBz
ZXJ2ZXJzIHVubGVzcwogCQkgKiBkZWxldGUgaXMgcGVuZGluZy4gIEluc3RlYWQgbWFyayBpdCBh
cyB1bmtub3duLgpAQCAtODE2LDYgKzgxMiwxMCBAQCBzdGF0aWMgdm9pZCBjaWZzX29wZW5faW5m
b190b19mYXR0cihzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIsCiAJCX0KIAl9CiAKKwkvKiBjbGVh
ciB3cml0ZSBiaXRzIGlmIEFUVFJfUkVBRE9OTFkgaXMgc2V0ICovCisJaWYgKGZhdHRyLT5jZl9j
aWZzYXR0cnMgJiBBVFRSX1JFQURPTkxZKQorCQlmYXR0ci0+Y2ZfbW9kZSAmPSB+KFNfSVdVR08p
OworCiBvdXRfcmVwYXJzZToKIAlpZiAoU19JU0xOSyhmYXR0ci0+Y2ZfbW9kZSkpIHsKIAkJaWYg
KGxpa2VseShkYXRhLT5zeW1saW5rX3RhcmdldCkpCkBAIC0xMjMzLDExICsxMjMzLDE0IEBAIHN0
YXRpYyBpbnQgY2lmc19nZXRfZmF0dHIoc3RydWN0IGNpZnNfb3Blbl9pbmZvX2RhdGEgKmRhdGEs
CiAJCQkJIF9fZnVuY19fLCByYyk7CiAJCQlnb3RvIG91dDsKIAkJfQotCX0KLQotCS8qIGZpbGwg
aW4gcmVtYWluaW5nIGhpZ2ggbW9kZSBiaXRzIGUuZy4gU1VJRCwgVlRYICovCi0JaWYgKGNpZnNf
c2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9VTlhfRU1VTCkKKwl9IGVsc2UgaWYgKGNp
ZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9VTlhfRU1VTCkKKwkJLyogZmlsbCBp
biByZW1haW5pbmcgaGlnaCBtb2RlIGJpdHMgZS5nLiBTVUlELCBWVFggKi8KIAkJY2lmc19zZnVf
bW9kZShmYXR0ciwgZnVsbF9wYXRoLCBjaWZzX3NiLCB4aWQpOworCWVsc2UgaWYgKCEodGNvbi0+
cG9zaXhfZXh0ZW5zaW9ucykpCisJCS8qIGNsZWFyIHdyaXRlIGJpdHMgaWYgQVRUUl9SRUFET05M
WSBpcyBzZXQgKi8KKwkJaWYgKGZhdHRyLT5jZl9jaWZzYXR0cnMgJiBBVFRSX1JFQURPTkxZKQor
CQkJZmF0dHItPmNmX21vZGUgJj0gfihTX0lXVUdPKTsKKwogCiAJLyogY2hlY2sgZm9yIE1pbnNo
YWxsK0ZyZW5jaCBzeW1saW5rcyAqLwogCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJ
RlNfTU9VTlRfTUZfU1lNTElOS1MpIHsKLS0gCjIuNDMuMAoK
--0000000000005c4f870622adfb45--
