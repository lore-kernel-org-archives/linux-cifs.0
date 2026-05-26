Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F25B25F984
	for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 20:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779827571; cv=pass; b=nypihw7OcJYmka8BtPgYuPzlDLhXxhuL0+d6xlJrhye7o7c/u2oktFd5UgmEBP1/56l4oNWHd6nS6RjW7aezcFePbvb+hogFcxsui7G/yL1Mgi/Ydh2iZG9QQRe0uTv2Ncgq0uApCYykWzD2ZbKcEEcamCh3V7tumnVUwbw0QIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779827571; c=relaxed/simple;
	bh=DP7FCIBE10C4xNoQlYwwlH81pouN6+pTDmF/jz9K3rg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=tw8CTtQg0usMA3Kuxcq0KHtcdRCzcYPAL7dhXuKxfbwiIKH8eM4moubTncl8iNgBNNxESTa81/hxqgZ/twlZS1duWrza/yzT3N/9KygAz2bN6xfHJnvJ5iv5b+6pKSbe+6eYDjSbdpCw+fEIAMdG1hu9zMfECo7DV3moBRu0V6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TBI3QrEc; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TBI3QrEc"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8b9f2295a9dso120021626d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 13:32:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779827569; cv=none;
        d=google.com; s=arc-20240605;
        b=aU8Z69HEBVAfRnJl6rBD/FBdfEeX2hKlkTGXzs4Jmshsx1UKTfuLSCqVsR+xVOB7ji
         7kUyH/BsmlpVkjIuT4jOSQz7VbVB56q/utPGUun1j6zyP9YoLYSbgnpKz01iM+ESpzS7
         vHKdsInTS+anxfQGp14PEAWZuQEBOXul+CK6IbNqmR3rwuZrz6bxQYJDkx/6HjUpVgET
         qvW59M2R+mrXDIZsJAVQyXvb9+YLmJMow7aljCfMNgt5/8kds86oM/L/USKA7GrjYqZq
         EBS9/Rgt7Ls8sXYpften7Smy1VwzpdJ3ywRehloVnpeUhJDvEruWeB0CfDd3KHeIQNin
         591g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=U3QuOMybWjhDlwvprgkkiFQYRMqEDP3CK5OhXT98LZY=;
        fh=L/VyfjwXJFOZI8n+NVy05GFjzkr1ADkEVAEWcyzq0KU=;
        b=hQUNbfribTv2/kOU+Zx9NrvU5+BXi2FXDz2PV2x3g5Ee2mwN0fGANz/s5NIkmItksV
         DT+MzWhAApzjkX4FAb/KayKeGMYi+mK+wB3MUTtiWD2xw67Zu8RD6zhuvpGmSFBuSVBA
         7k8ZhdWCSMl4YDa1QgbERnT7Q+48u33+u48eFUm/+VEPmFOAM9MGUdSc+QdNYrSlfAw4
         GBZOAZWLyFXqqAi2H/wLBtcOG/i4K6Vg41D619IfAlOZwaBVn5boHOCtv+6DNvZCBQum
         BvFEHyCNSUSIWcfy5XYJwfggysvSq3ADonqKWlD5lHS+Qo8iCyXOkpQHYwTfoNUz1Qeq
         RXMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779827569; x=1780432369; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U3QuOMybWjhDlwvprgkkiFQYRMqEDP3CK5OhXT98LZY=;
        b=TBI3QrEcOR28Ql/8ByhzRM2Qx7YMkCuw03nSqABH07wXmIGK+X1uK1r2UA0C+xRYyn
         NP/ctVkuVBRFZhmBVIiOGdwtDpbunaZvBI6jLfMAZMX+LUD8IiPiMMtThBEFoiDfe2ML
         XaWTcqAWcbZ9zwGaW1+7a8VnEtgdur33KrXEVkkhYl4OWTwUS88wE/K1xeAJOlAHTxmf
         o7xjes8QLdDNtsewyl+GTSwAvlnk1VyHi+r13KreKzsnHc7ghYcCzAhzVkGheJVH25Vv
         sdC7OMcXlCp+rvCruT0JcBh152nBnXxbOo6ZIAVaBM4LbsFORKcP+s9mQFdY6r+jUdnE
         mNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779827569; x=1780432369;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3QuOMybWjhDlwvprgkkiFQYRMqEDP3CK5OhXT98LZY=;
        b=RkaF3qNbMKikI89vTaUwZ/moeMcZPBL8p0hRVP/5M3aJcL2UpeonsTzr/S8JFRnmJN
         QJPdZoe+sxZYl0yDgDn755mYalzH8l8OzG8Ks63rvG9+CsAXcTUuuy5P8pg4N0fp1NYJ
         b131mDIC1eCzCqbwfpEgJ+/8Xke1lqZBLGtFnMSw1o8H/P/tnwcLzXhDGU07V7jZUciG
         pueY5Ki72qxdjbflwF0jURdTvi2PTUmN2Jv50Bi99JvocoSCaNXYKtfzxzrg1Xz8Jyc9
         ScXw9iOlLEdRJtkNzKbBnSFl6bTHTrSMQ1qlhaFJkRnJLEQa9NeOsn3gNep3WAQ7X0yt
         BTfQ==
X-Gm-Message-State: AOJu0Yx8/5iW4YD1mdhJL94Xf3hcSwlyroryeBbK9dk7YjmjlGU9EzxI
	W1CMnCGzObgpgKk4Gt/dCsSTrcNF0V/xgUwizU1ZCIHnhUvpXjJnYPro5OsKgn8Xpl/whfI02yc
	e6KjTP1juFAKZapdX76vgaYHIeJYVjkXtgMcB
X-Gm-Gg: Acq92OF7hpIs/fUyG+TCeD4Bn4B8QZMfpaSDL9S8G2kTdv3GOleDFEDUZ9aiPFQl3aL
	msouQLiEhJ8jDyJCC6sJLAGGVD6M7gdoIqvAIJOL3UquMAi1W4rNINTR9YgiHXphyeZ9K1ZhTcz
	c6o/rTxo+Gn9SJbNk9vtaYo3MZjuprVe5LfnP4hlc5Fs7jm0yP7db/VOf9t+WKzewGL91ccMrAw
	NXAephONB8C0jWTj3YWF17sXpFfPofaRTXIraPk4vFKSMidJB1YwG/UF15AuMe397A0aGub9oJS
	DBI9gXHZxW2GPws/xa73yIbp0UqD2WsIRsEOov2fzZjjCLaTo8HxEnNQbspICkKZwAWjYY0PdxL
	/ndCQpbQyJ9/oeKhYZRkdr8bkjw1Qa19L3k2u392Hm1j3reez1s4JTJDenlUsc3YZCQpp78vEA6
	028QrYM8m0qmH44cBS/9A8YqQYK8ft5nvD2YEgjm0oFr4=
X-Received: by 2002:ad4:594f:0:b0:89c:c2e7:97ad with SMTP id
 6a1803df08f44-8cc7b5d66e8mr350554886d6.43.1779827569252; Tue, 26 May 2026
 13:32:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 26 May 2026 15:32:37 -0500
X-Gm-Features: AVHnY4KRPaC8t4D-rOCySncZZ4CGiEJ1xdLLsycAvMsyRr_YeS_IAac7uSfTIfs
Message-ID: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
Subject: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX Extensions
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000000755d30652be662b"

--0000000000000755d30652be662b
Content-Type: text/plain; charset="UTF-8"

chmod and chgrp were being ignored when mouting with the SMB3.1.1
POSIX Extensions. Add support for chmod and chgrp when mounting
with the SMB3.1.1 POSIX Extensions.


-- 
Thanks,

Steve

--0000000000000755d30652be662b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-client-fix-chmod-and-chgrp-with-SMB3.1.1-POSIX-E.patch"
Content-Disposition: attachment; 
	filename="0001-smb-client-fix-chmod-and-chgrp-with-SMB3.1.1-POSIX-E.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mpn3d9c20>
X-Attachment-Id: f_mpn3d9c20

RnJvbSBkZTliMDFlNTQ3MmZlNjI4ZmNlMzg0Y2NiZDkyMjMyNWM4ODA0YTU5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjYgTWF5IDIwMjYgMTU6MjU6NTQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWI6IGNsaWVudDogZml4IGNobW9kIGFuZCBjaGdycCB3aXRoIFNNQjMuMS4xIFBPU0lYCiBFeHRl
bnNpb25zCgpjaG1vZCBhbmQgY2hncnAgd2VyZSBiZWluZyBpZ25vcmVkIHdoZW4gbW91dGluZyB3
aXRoIHRoZSBTTUIzLjEuMQpQT1NJWCBFeHRlbnNpb25zLiBBZGQgc3VwcG9ydCBmb3IgY2htb2Qg
YW5kIGNoZ3JwIHdoZW4gbW91bnRpbmcKd2l0aCB0aGUgU01CMy4xLjEgUE9TSVggRXh0ZW5zaW9u
cy4KCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5j
aCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2NpZnNhY2wuYyB8
IDE4ICsrKysrKysrKysrKysrKystLQogZnMvc21iL2NsaWVudC9pbm9kZS5jICAgfCAgMyArKy0K
IDIgZmlsZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNhY2wuYyBiL2ZzL3NtYi9jbGllbnQvY2lmc2FjbC5j
CmluZGV4IDQyYTMxMTUzNTlkYS4uNmI4NjI2ZjA3NTAxIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xp
ZW50L2NpZnNhY2wuYworKysgYi9mcy9zbWIvY2xpZW50L2NpZnNhY2wuYwpAQCAtMTQ2OCw3ICsx
NDY4LDE0IEBAIHN0YXRpYyBpbnQgYnVpbGRfc2VjX2Rlc2Moc3RydWN0IHNtYl9udHNkICpwbnRz
ZCwgc3RydWN0IHNtYl9udHNkICpwbm50c2QsCiAJCQkJZ290byBjaG93bl9jaGdycF9leGl0Owog
CQkJfQogCQkJaWQgPSBmcm9tX2t1aWQoJmluaXRfdXNlcl9ucywgdWlkKTsKLQkJCWlmIChpZF9m
cm9tX3NpZCkgeworCQkJaWYgKHBvc2l4KSB7CisJCQkJLyogU01CMy4xLjEgUE9TSVg6IFVuaXgg
TWFwcGluZyBvd25lciBTSUQgUy0xLTIyLTEtPHVpZD4gKi8KKwkJCQlub3duZXJfc2lkX3B0ci0+
cmV2aXNpb24gPSAxOworCQkJCW5vd25lcl9zaWRfcHRyLT5udW1fc3ViYXV0aCA9IDI7CisJCQkJ
bm93bmVyX3NpZF9wdHItPmF1dGhvcml0eVs1XSA9IDIyOworCQkJCW5vd25lcl9zaWRfcHRyLT5z
dWJfYXV0aFswXSA9IGNwdV90b19sZTMyKDEpOworCQkJCW5vd25lcl9zaWRfcHRyLT5zdWJfYXV0
aFsxXSA9IGNwdV90b19sZTMyKGlkKTsKKwkJCX0gZWxzZSBpZiAoaWRfZnJvbV9zaWQpIHsKIAkJ
CQlzdHJ1Y3Qgb3duZXJfc2lkICpvc2lkID0gKHN0cnVjdCBvd25lcl9zaWQgKilub3duZXJfc2lk
X3B0cjsKIAkJCQkvKiBQb3B1bGF0ZSB0aGUgdXNlciBvd25lcnNoaXAgZmllbGRzIFMtMS01LTg4
LTEgKi8KIAkJCQlvc2lkLT5SZXZpc2lvbiA9IDE7CkBAIC0xNDk2LDcgKzE1MDMsMTQgQEAgc3Rh
dGljIGludCBidWlsZF9zZWNfZGVzYyhzdHJ1Y3Qgc21iX250c2QgKnBudHNkLCBzdHJ1Y3Qgc21i
X250c2QgKnBubnRzZCwKIAkJCQlnb3RvIGNob3duX2NoZ3JwX2V4aXQ7CiAJCQl9CiAJCQlpZCA9
IGZyb21fa2dpZCgmaW5pdF91c2VyX25zLCBnaWQpOwotCQkJaWYgKGlkX2Zyb21fc2lkKSB7CisJ
CQlpZiAocG9zaXgpIHsKKwkJCQkvKiBTTUIzLjEuMSBQT1NJWDogVW5peCBNYXBwaW5nIGdyb3Vw
IFNJRCBTLTEtMjItMi08Z2lkPiAqLworCQkJCW5ncm91cF9zaWRfcHRyLT5yZXZpc2lvbiA9IDE7
CisJCQkJbmdyb3VwX3NpZF9wdHItPm51bV9zdWJhdXRoID0gMjsKKwkJCQluZ3JvdXBfc2lkX3B0
ci0+YXV0aG9yaXR5WzVdID0gMjI7CisJCQkJbmdyb3VwX3NpZF9wdHItPnN1Yl9hdXRoWzBdID0g
Y3B1X3RvX2xlMzIoMik7CisJCQkJbmdyb3VwX3NpZF9wdHItPnN1Yl9hdXRoWzFdID0gY3B1X3Rv
X2xlMzIoaWQpOworCQkJfSBlbHNlIGlmIChpZF9mcm9tX3NpZCkgewogCQkJCXN0cnVjdCBvd25l
cl9zaWQgKmdzaWQgPSAoc3RydWN0IG93bmVyX3NpZCAqKW5ncm91cF9zaWRfcHRyOwogCQkJCS8q
IFBvcHVsYXRlIHRoZSBncm91cCBvd25lcnNoaXAgZmllbGRzIFMtMS01LTg4LTIgKi8KIAkJCQln
c2lkLT5SZXZpc2lvbiA9IDE7CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2lub2RlLmMgYi9m
cy9zbWIvY2xpZW50L2lub2RlLmMKaW5kZXggMGFmOTNlODgxNjA4Li44MjZkMzZlZDEzZWMgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvaW5vZGUuYworKysgYi9mcy9zbWIvY2xpZW50L2lub2Rl
LmMKQEAgLTMzNzYsNyArMzM3Niw4IEBAIGNpZnNfc2V0YXR0cl9ub3VuaXgoc3RydWN0IGRlbnRy
eSAqZGlyZW50cnksIHN0cnVjdCBpYXR0ciAqYXR0cnMpCiAJaWYgKGF0dHJzLT5pYV92YWxpZCAm
IEFUVFJfR0lEKQogCQlnaWQgPSBhdHRycy0+aWFfZ2lkOwogCi0JaWYgKHNiZmxhZ3MgJiAoQ0lG
U19NT1VOVF9DSUZTX0FDTCB8IENJRlNfTU9VTlRfTU9ERV9GUk9NX1NJRCkpIHsKKwlpZiAoKHNi
ZmxhZ3MgJiAoQ0lGU19NT1VOVF9DSUZTX0FDTCB8IENJRlNfTU9VTlRfTU9ERV9GUk9NX1NJRCkp
IHx8CisJICAgIGNpZnNfc2JfbWFzdGVyX3Rjb24oY2lmc19zYiktPnBvc2l4X2V4dGVuc2lvbnMp
IHsKIAkJaWYgKHVpZF92YWxpZCh1aWQpIHx8IGdpZF92YWxpZChnaWQpKSB7CiAJCQltb2RlID0g
Tk9fQ0hBTkdFXzY0OwogCQkJcmMgPSBpZF9tb2RlX3RvX2NpZnNfYWNsKGlub2RlLCBmdWxsX3Bh
dGgsICZtb2RlLAotLSAKMi41My4wCgo=
--0000000000000755d30652be662b--
