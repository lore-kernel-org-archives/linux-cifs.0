Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD47D163
	for <linux-cifs@vger.kernel.org>; Wed,  5 Feb 2025 00:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738714016; cv=none; b=U71tzwlSZuUc4WW5/5AXPuhmjYUFUZM5+MHTOfT3tqRKV2vV5pL/E0VLqV0STwLIiC3hFSQlXd1NMOt4KrjcJ5BMrDp/6GXg2n02ZCXktplHBKp5NyMEw/uODnhjSwJH9V4nFgg0onV4Nap2Zh84GmMse2JxfPYUumct+6i4Fus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738714016; c=relaxed/simple;
	bh=ONOD+TfZ5TTxEyDsgTEUfpuqs/GtUcB2oj/7IxWmRXw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=NPBaxn51kqs40hAnR6ajAAbD0KtiEkCgswV6hSJbx9v78Qtdg925NWdS/0aZot+KENZGnns+OXwy6IP+AfYlvm+N6hWzgv9bBePPTnoZu+c8akVxreGNi69oruqT51KDNpNIrmE+bEP8pR0f4AImAY/+w8dFDz/zcvDq+KNZipY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S3BVRC2K; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3BVRC2K"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5439e331cceso1378485e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Feb 2025 16:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738714013; x=1739318813; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YVk6hpU2pZ7xpK6zq1wxpM3dZuMb8GMpjjaI+pHQ9gk=;
        b=S3BVRC2KAF04zgKhDns9zZKDEXo6wUFGwGRRCWYiBF6HESvp1rM/Rop+5phAGxt2VA
         StIjIWFjkI3Rz2TqHgAcLrCNXOnLarU0btMcBvSfJlYfry7jS2/zs/ui6mjq6xctP2Vs
         IAiuZpMZUvv9xx6OXWpCMU6kkwEZX6UM5X3JBEJBrUYv0bh3a3Jtf2rg+KhnuevbyUvJ
         FSgJ9zZ+NnjlMpg5SwuakJK5RoEV3W2NThmo9AVwg1RoVXeL3F/uBfD0wotCphA7WC8l
         je6besFKn2xynaCQ32wJGQFEZ5OY8HEZCj38BShq8TTHT1+tp0P29zI8uMne6BKL2Kux
         FgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738714013; x=1739318813;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YVk6hpU2pZ7xpK6zq1wxpM3dZuMb8GMpjjaI+pHQ9gk=;
        b=HYenH7644JmhFtO7um+wGEFWrkME1NlAFx2lVok15irKtkVyFnGqnMAmAPqj7s7SdS
         bHNNcq6f7j04STFbmtjD5wK3iVv5DKqPs7NsStKAzGsUQ3UACKpxLxkD5SY04pGuAZMe
         PTlKVOXwA4SgYC7qwgAdBRp+PR0pes6mqX+xGyoIFjA2bWyRHPtic+FhbNqsZ8oxwH6X
         rBmxIubpMFQLsscgeI2qptGa82RS3WrsT6XVM7saEgxpPtBrt7kvEBVhWK3CLMyocpiI
         PqFJd8nTPqB8WPwbIN3wUva2YtheQJ9omxhMQMDD1ftdbHyBtxojs+fU1b/rkaZmXG1n
         zCMw==
X-Gm-Message-State: AOJu0YygeJ8rfI2QWEv2Axnll781YFpEYv3YIyrm03UPOi5q+U+S5+jy
	VXvtq+e2fiOV4jrqgOO4yk/QwbgaM/86awivMo3FIiZUEuFAiJwea+cD+r3/TCm0sPbuGxAXfxY
	OFzl66o7NI9y/lxcGuT0lFLjZnsPk6iX6
X-Gm-Gg: ASbGncs0vqDV910o/xt+R2QhtCdVwcUfhhT5iK0KyI06zXAL8dnvh2nGdujEbSMQf7B
	UABr0tE17L1YvivVxGJVCXhdZVniaDz/v/BsHWwTkuRBpr+Rk5RYta57MonbRW41cVpsnStJZQz
	0yPmSF6NbKCDR+itw70Bdx1p/ulwEEXcM=
X-Google-Smtp-Source: AGHT+IFz6DAvQraRve3XpGlkozDeUEUNobT3bHVAfsS5TwF14w/tWgQGPE0cw0v7dWjui1eHayrsDpnDk5rkm8MeCIs=
X-Received: by 2002:a05:6512:686:b0:543:f1d1:c6cf with SMTP id
 2adb3069b0e04-544059f9cd4mr183646e87.10.1738714012638; Tue, 04 Feb 2025
 16:06:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 4 Feb 2025 18:06:41 -0600
X-Gm-Features: AWEUYZlxLXUrKlbrk5kGe14p7KcR2yRAHAPHylLU0wr7AWt6iXvGzfnYJC3xgpM
Message-ID: <CAH2r5mt15YNyLuvJGnUaMb3SU5-zZdak+k9Dx6an3aLqBY4XUg@mail.gmail.com>
Subject: Re: [PATCH 13/43] cifs: Treat unhandled directory name surrogate
 reparse points as mount directory nodes
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000170258062d59e7b2"

--000000000000170258062d59e7b2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Do you have a repro scenario (an easy way to create the surrogate
directory type you mention) to test your patch below



If the reparse point was not handled (indicated by the -EOPNOTSUPP from
ops->parse_reparse_point() call) but reparse tag is of type name surrogate
directory type, then treat is as a new mount point.

Name surrogate reparse point represents another named entity in the system.

From SMB client point of view, this another entity is resolved on the SMB
server, and server serves its content automatically. Therefore from Linux
client point of view, this name surrogate reparse point of directory type
crosses mount point.

Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>


--=20
Thanks,

Steve

--000000000000170258062d59e7b2
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0013-cifs-Treat-unhandled-directory-name-surrogate-repars.patch"
Content-Disposition: attachment; 
	filename="0013-cifs-Treat-unhandled-directory-name-surrogate-repars.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m6r5egmi0>
X-Attachment-Id: f_m6r5egmi0

RnJvbSBjODE0MTQ2MmM3ZTg1MDM5OGUzN2E5YTA3ZGM1N2Q0YWM3YjcxMGYwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UGFsaT0yMFJvaD1DMz1BMXI/PSA8cGFsaUBr
ZXJuZWwub3JnPgpEYXRlOiBXZWQsIDE4IFNlcCAyMDI0IDAwOjI4OjI1ICswMjAwClN1YmplY3Q6
IFtQQVRDSCAxMy80M10gY2lmczogVHJlYXQgdW5oYW5kbGVkIGRpcmVjdG9yeSBuYW1lIHN1cnJv
Z2F0ZSByZXBhcnNlCiBwb2ludHMgYXMgbW91bnQgZGlyZWN0b3J5IG5vZGVzCk1JTUUtVmVyc2lv
bjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYtOApDb250ZW50LVRy
YW5zZmVyLUVuY29kaW5nOiA4Yml0CgpJZiB0aGUgcmVwYXJzZSBwb2ludCB3YXMgbm90IGhhbmRs
ZWQgKGluZGljYXRlZCBieSB0aGUgLUVPUE5PVFNVUFAgZnJvbQpvcHMtPnBhcnNlX3JlcGFyc2Vf
cG9pbnQoKSBjYWxsKSBidXQgcmVwYXJzZSB0YWcgaXMgb2YgdHlwZSBuYW1lIHN1cnJvZ2F0ZQpk
aXJlY3RvcnkgdHlwZSwgdGhlbiB0cmVhdCBpcyBhcyBhIG5ldyBtb3VudCBwb2ludC4KCk5hbWUg
c3Vycm9nYXRlIHJlcGFyc2UgcG9pbnQgcmVwcmVzZW50cyBhbm90aGVyIG5hbWVkIGVudGl0eSBp
biB0aGUgc3lzdGVtLgoKRnJvbSBTTUIgY2xpZW50IHBvaW50IG9mIHZpZXcsIHRoaXMgYW5vdGhl
ciBlbnRpdHkgaXMgcmVzb2x2ZWQgb24gdGhlIFNNQgpzZXJ2ZXIsIGFuZCBzZXJ2ZXIgc2VydmVz
IGl0cyBjb250ZW50IGF1dG9tYXRpY2FsbHkuIFRoZXJlZm9yZSBmcm9tIExpbnV4CmNsaWVudCBw
b2ludCBvZiB2aWV3LCB0aGlzIG5hbWUgc3Vycm9nYXRlIHJlcGFyc2UgcG9pbnQgb2YgZGlyZWN0
b3J5IHR5cGUKY3Jvc3NlcyBtb3VudCBwb2ludC4KClNpZ25lZC1vZmYtYnk6IFBhbGkgUm9ow6Fy
IDxwYWxpQGtlcm5lbC5vcmc+Ci0tLQogZnMvc21iL2NsaWVudC9pbm9kZS5jICAgIHwgMTMgKysr
KysrKysrKysrKwogZnMvc21iL2NvbW1vbi9zbWJmc2N0bC5oIHwgIDMgKysrCiAyIGZpbGVzIGNo
YW5nZWQsIDE2IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2lub2Rl
LmMgYi9mcy9zbWIvY2xpZW50L2lub2RlLmMKaW5kZXggOWNjMzFjZjZlYmQwLi4yMTQyNDA2MTI1
NDkgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvaW5vZGUuYworKysgYi9mcy9zbWIvY2xpZW50
L2lub2RlLmMKQEAgLTEyMTUsNiArMTIxNSwxOSBAQCBzdGF0aWMgaW50IHJlcGFyc2VfaW5mb190
b19mYXR0cihzdHJ1Y3QgY2lmc19vcGVuX2luZm9fZGF0YSAqZGF0YSwKIAkJCXJjID0gc2VydmVy
LT5vcHMtPnBhcnNlX3JlcGFyc2VfcG9pbnQoY2lmc19zYiwKIAkJCQkJCQkgICAgICBmdWxsX3Bh
dGgsCiAJCQkJCQkJICAgICAgaW92LCBkYXRhKTsKKwkJCS8qCisJCQkgKiBJZiB0aGUgcmVwYXJz
ZSBwb2ludCB3YXMgbm90IGhhbmRsZWQgYnV0IGl0IGlzIHRoZQorCQkJICogbmFtZSBzdXJyb2dh
dGUgd2hpY2ggcG9pbnRzIHRvIGRpcmVjdG9yeSwgdGhlbiB0cmVhdAorCQkJICogaXMgYXMgYSBu
ZXcgbW91bnQgcG9pbnQuIE5hbWUgc3Vycm9nYXRlIHJlcGFyc2UgcG9pbnQKKwkJCSAqIHJlcHJl
c2VudHMgYW5vdGhlciBuYW1lZCBlbnRpdHkgaW4gdGhlIHN5c3RlbS4KKwkJCSAqLworCQkJaWYg
KHJjID09IC1FT1BOT1RTVVBQICYmCisJCQkgICAgSVNfUkVQQVJTRV9UQUdfTkFNRV9TVVJST0dB
VEUoZGF0YS0+cmVwYXJzZS50YWcpICYmCisJCQkgICAgKGxlMzJfdG9fY3B1KGRhdGEtPmZpLkF0
dHJpYnV0ZXMpICYgQVRUUl9ESVJFQ1RPUlkpKSB7CisJCQkJcmMgPSAwOworCQkJCWNpZnNfY3Jl
YXRlX2p1bmN0aW9uX2ZhdHRyKGZhdHRyLCBzYik7CisJCQkJZ290byBvdXQ7CisJCQl9CiAJCX0K
IAogCQlpZiAoZGF0YS0+cmVwYXJzZS50YWcgPT0gSU9fUkVQQVJTRV9UQUdfU1lNTElOSyAmJiAh
cmMpIHsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jb21tb24vc21iZnNjdGwuaCBiL2ZzL3NtYi9jb21t
b24vc21iZnNjdGwuaAppbmRleCA0YjM3OWU4NGM0NmIuLjMyNTNhMThlY2I1YyAxMDA2NDQKLS0t
IGEvZnMvc21iL2NvbW1vbi9zbWJmc2N0bC5oCisrKyBiL2ZzL3NtYi9jb21tb24vc21iZnNjdGwu
aApAQCAtMTU5LDYgKzE1OSw5IEBACiAjZGVmaW5lIElPX1JFUEFSU0VfVEFHX0xYX0NIUgkgICAg
IDB4ODAwMDAwMjUKICNkZWZpbmUgSU9fUkVQQVJTRV9UQUdfTFhfQkxLCSAgICAgMHg4MDAwMDAy
NgogCisvKiBJZiBOYW1lIFN1cnJvZ2F0ZSBCaXQgaXMgc2V0LCB0aGUgZmlsZSBvciBkaXJlY3Rv
cnkgcmVwcmVzZW50cyBhbm90aGVyIG5hbWVkIGVudGl0eSBpbiB0aGUgc3lzdGVtLiAqLworI2Rl
ZmluZSBJU19SRVBBUlNFX1RBR19OQU1FX1NVUlJPR0FURSh0YWcpICghISgodGFnKSAmIDB4MjAw
MDAwMDApKQorCiAvKiBmc2N0bCBmbGFncyAqLwogLyogSWYgRmxhZ3MgaXMgc2V0IHRvIHRoaXMg
dmFsdWUsIHRoZSByZXF1ZXN0IGlzIGFuIEZTQ1RMIG5vdCBpb2N0bCByZXF1ZXN0ICovCiAjZGVm
aW5lIFNNQjJfMF9JT0NUTF9JU19GU0NUTAkJMHgwMDAwMDAwMQotLSAKMi40My4wCgo=
--000000000000170258062d59e7b2--
