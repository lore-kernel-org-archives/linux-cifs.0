Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366E638DF9
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 21:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PALDFFI5"
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B1E421B
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 13:52:09 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-507a5f2193bso1534406e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Nov 2023 13:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699566727; x=1700171527; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=71N0m59xLukcDdkm4W+JIoiwHE7GiSCCkWsEYwiOgD4=;
        b=PALDFFI5KqInzo1nk/ez1eoxbpx/yjgL3TPTOV9TzB5hq/X6oJIFtvYEDfPNIAJ8Dm
         BZ5EjbFeag0KqOmT9JeLiw+dFlW4dDZuV7MMEEJOy5jUOcxzuIz0jGBjHz2kY+S8CYdf
         tWsKQNLjpn1BExGtv9owrZA9rgvpLLl/GZ3Fcw2hry2CedrMecq0o/+oks5df2tC8D69
         NLnxm4P6WBvhPRNl80yFeCJ3QnXzA41ArCvO6JNVgNbULHWFz6fCxk8NFIzInFNZlj6s
         JowheMorFECO4z8Jb5aHo16mhNgumoAdZPZ6Mo6R+C4SsjS6DLwWtrQRdeBh0KnApW0X
         11Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699566727; x=1700171527;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=71N0m59xLukcDdkm4W+JIoiwHE7GiSCCkWsEYwiOgD4=;
        b=qBa7fTXCr6sROOZoMKGRfbO3FtR3vvIfKPssqupZgycw8JwnN+dSVoQJLuI9Vcjwc5
         0dmMP/TdLuR0DkHu316rVdQoeJMXAcl4SN8UbpwWiFv4c+ZwhLXMrplh5kncq6WSj1Cd
         aR0fjn3wTATRgrpwIIqvuF1qPAPwW5CZFY3TG0SJyNCoOsIi1gDfp+LX6sT/3tGW3xQD
         mRNneeGydH3I/Nk8yFXZT+EucHG9T38+0BD3mx+5bS0bZheaKfq3HjD9eXHVonuWAnuT
         CF5D6jdtdK3NT63xcEgziZQ96W1FQa6ot4vGq4B8ilTZ33w197UC4ePuDtpD1kkJRfoA
         uqkQ==
X-Gm-Message-State: AOJu0YwiqRqQWzNYwG9dTaE7jvn2GLgpjLU8PfOryfzrUkSjcN1+O+gH
	MK8Sqgu6xBDPYxbtNMWSGh0uJX+B3Erh5aKUgR8G5vUTa6ISEf3J1dU=
X-Google-Smtp-Source: AGHT+IGvEwR5spf34RJevg9oaG4NQSFW8MnTxOFoHMOBxPSPjaf/pCxyTIZyLN1nDPydcRHYL23zuXdey/PEq4vIwcs=
X-Received: by 2002:a19:ad0d:0:b0:501:b929:48af with SMTP id
 t13-20020a19ad0d000000b00501b92948afmr217206lfc.34.1699566727022; Thu, 09 Nov
 2023 13:52:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Nov 2023 15:51:55 -0600
Message-ID: <CAH2r5mt-t0QDZk4Zz+cSs8=s=VhUW09erUBAtm8f7xXG3rHJqw@mail.gmail.com>
Subject: [PATCH][smb3 client] allow debugging session and tcon info to improve
 stats analysis and debugging
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000000962570609bf378b"

--0000000000000962570609bf378b
Content-Type: text/plain; charset="UTF-8"

[PATCH] smb3: allow debugging session and tcon info to improve stats
 analysis and debugging

When multiple mounts are to the same share from the same client it was not
possible to determine which section of /proc/fs/cifs/Stats (and DebugData)
correspond to that mount.  In some recent examples this turned out to  be
a significant problem when trying to analyze performance problems - since
there are many cases where unless we know the tree id and session id we
can't figure out which stats (e.g. number of SMB3.1.1 requests by type,
the total time they take, which is slowest, how many fail etc.) apply to
which mount.

Add an ioctl to return tid, session id, tree connect count and tcon flags.

-- 
Thanks,

Steve

--0000000000000962570609bf378b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-debugging-session-and-tcon-info-to-improv.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-debugging-session-and-tcon-info-to-improv.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lorq4zi10>
X-Attachment-Id: f_lorq4zi10

RnJvbSA1NDc5NmE1NTVhNTVjNDBmZjYxYjE0ZjU3NGExMzljOTEyY2ZmZGVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgOSBOb3YgMjAyMyAxNToyODoxMiAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFsbG93IGRlYnVnZ2luZyBzZXNzaW9uIGFuZCB0Y29uIGluZm8gdG8gaW1wcm92ZSBzdGF0
cwogYW5hbHlzaXMgYW5kIGRlYnVnZ2luZwoKV2hlbiBtdWx0aXBsZSBtb3VudHMgYXJlIHRvIHRo
ZSBzYW1lIHNoYXJlIGZyb20gdGhlIHNhbWUgY2xpZW50IGl0IHdhcyBub3QKcG9zc2libGUgdG8g
ZGV0ZXJtaW5lIHdoaWNoIHNlY3Rpb24gb2YgL3Byb2MvZnMvY2lmcy9TdGF0cyAoYW5kIERlYnVn
RGF0YSkKY29ycmVzcG9uZCB0byB0aGF0IG1vdW50LiAgSW4gc29tZSByZWNlbnQgZXhhbXBsZXMg
dGhpcyB0dXJuZWQgb3V0IHRvICBiZQphIHNpZ25pZmljYW50IHByb2JsZW0gd2hlbiB0cnlpbmcg
dG8gYW5hbHl6ZSBwZXJmb3JtYW5jZSBwcm9ibGVtcyAtIHNpbmNlCnRoZXJlIGFyZSBtYW55IGNh
c2VzIHdoZXJlIHVubGVzcyB3ZSBrbm93IHRoZSB0cmVlIGlkIGFuZCBzZXNzaW9uIGlkIHdlCmNh
bid0IGZpZ3VyZSBvdXQgd2hpY2ggc3RhdHMgKGUuZy4gbnVtYmVyIG9mIFNNQjMuMS4xIHJlcXVl
c3RzIGJ5IHR5cGUsCnRoZSB0b3RhbCB0aW1lIHRoZXkgdGFrZSwgd2hpY2ggaXMgc2xvd2VzdCwg
aG93IG1hbnkgZmFpbCBldGMuKSBhcHBseSB0bwp3aGljaCBtb3VudC4KCkFkZCBhbiBpb2N0bCB0
byByZXR1cm4gdGlkLCBzZXNzaW9uIGlkLCB0cmVlIGNvbm5lY3QgY291bnQgYW5kIHRjb24gZmxh
Z3MuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
Ci0tLQogZnMvc21iL2NsaWVudC9jaWZzX2lvY3RsLmggfCAgOCArKysrKysrKwogZnMvc21iL2Ns
aWVudC9pb2N0bC5jICAgICAgfCAyNiArKysrKysrKysrKysrKysrKysrKysrKysrKwogMiBmaWxl
cyBjaGFuZ2VkLCAzNCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9j
aWZzX2lvY3RsLmggYi9mcy9zbWIvY2xpZW50L2NpZnNfaW9jdGwuaAppbmRleCAzMzI1ODhlNzdj
MzEuLjJlYjBhNzQ3YjZjMyAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzX2lvY3RsLmgK
KysrIGIvZnMvc21iL2NsaWVudC9jaWZzX2lvY3RsLmgKQEAgLTI2LDYgKzI2LDEzIEBAIHN0cnVj
dCBzbWJfbW50X2ZzX2luZm8gewogCV9fdTY0ICAgY2lmc19wb3NpeF9jYXBzOwogfSBfX3BhY2tl
ZDsKIAorc3RydWN0IHNtYl9tbnRfdGNvbl9pbmZvIHsKKwlfX3UzMgl0aWQ7CisJX191NjQJc2Vz
c2lvbl9pZDsKKwlpbnQJdGNfY291bnQ7CisJX191MTYJZmxhZ3M7Cit9IF9fcGFja2VkOworCiBz
dHJ1Y3Qgc21iX3NuYXBzaG90X2FycmF5IHsKIAlfX3UzMgludW1iZXJfb2Zfc25hcHNob3RzOwog
CV9fdTMyCW51bWJlcl9vZl9zbmFwc2hvdHNfcmV0dXJuZWQ7CkBAIC0xMDgsNiArMTE1LDcgQEAg
c3RydWN0IHNtYjNfbm90aWZ5X2luZm8gewogI2RlZmluZSBDSUZTX0lPQ19OT1RJRlkgX0lPVyhD
SUZTX0lPQ1RMX01BR0lDLCA5LCBzdHJ1Y3Qgc21iM19ub3RpZnkpCiAjZGVmaW5lIENJRlNfRFVN
UF9GVUxMX0tFWSBfSU9XUihDSUZTX0lPQ1RMX01BR0lDLCAxMCwgc3RydWN0IHNtYjNfZnVsbF9r
ZXlfZGVidWdfaW5mbykKICNkZWZpbmUgQ0lGU19JT0NfTk9USUZZX0lORk8gX0lPV1IoQ0lGU19J
T0NUTF9NQUdJQywgMTEsIHN0cnVjdCBzbWIzX25vdGlmeV9pbmZvKQorI2RlZmluZSBDSUZTX0lP
Q19HRVRfVENPTl9JTkZPIF9JT1IoQ0lGU19JT0NUTF9NQUdJQywgMTIsIHN0cnVjdCBzbWJfbW50
X3Rjb25faW5mbykKICNkZWZpbmUgQ0lGU19JT0NfU0hVVERPV04gX0lPUignWCcsIDEyNSwgX191
MzIpCiAKIC8qCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2lvY3RsLmMgYi9mcy9zbWIvY2xp
ZW50L2lvY3RsLmMKaW5kZXggZjcxNjAwMDNlMGVkLi44MDAwNDMzNDA3ZGYgMTAwNjQ0Ci0tLSBh
L2ZzL3NtYi9jbGllbnQvaW9jdGwuYworKysgYi9mcy9zbWIvY2xpZW50L2lvY3RsLmMKQEAgLTEx
Nyw2ICsxMTcsMjIgQEAgc3RhdGljIGxvbmcgY2lmc19pb2N0bF9jb3B5Y2h1bmsodW5zaWduZWQg
aW50IHhpZCwgc3RydWN0IGZpbGUgKmRzdF9maWxlLAogCXJldHVybiByYzsKIH0KIAorc3RhdGlj
IGxvbmcgc21iX21udF9nZXRfdGNvbl9pbmZvKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHZvaWQg
X191c2VyICphcmcpCit7CisJaW50IHJjID0gMDsKKwlzdHJ1Y3Qgc21iX21udF90Y29uX2luZm8g
dGNvbl9pbmY7CisKKwl0Y29uX2luZi50aWQgPSB0Y29uLT50aWQ7CisJdGNvbl9pbmYuc2Vzc2lv
bl9pZCA9IHRjb24tPnNlcy0+U3VpZDsKKwl0Y29uX2luZi50Y19jb3VudCA9IHRjb24tPnRjX2Nv
dW50OworCXRjb25faW5mLmZsYWdzID0gdGNvbi0+RmxhZ3M7CisKKwlpZiAoY29weV90b191c2Vy
KGFyZywgJnRjb25faW5mLCBzaXplb2Yoc3RydWN0IHNtYl9tbnRfdGNvbl9pbmZvKSkpCisJCXJj
ID0gLUVGQVVMVDsKKworCXJldHVybiByYzsKK30KKwogc3RhdGljIGxvbmcgc21iX21udF9nZXRf
ZnNpbmZvKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJdm9p
ZCBfX3VzZXIgKmFyZykKIHsKQEAgLTQxNCw2ICs0MzAsMTYgQEAgbG9uZyBjaWZzX2lvY3RsKHN0
cnVjdCBmaWxlICpmaWxlcCwgdW5zaWduZWQgaW50IGNvbW1hbmQsIHVuc2lnbmVkIGxvbmcgYXJn
KQogCQkJdGNvbiA9IHRsaW5rX3Rjb24ocFNNQkZpbGUtPnRsaW5rKTsKIAkJCXJjID0gc21iX21u
dF9nZXRfZnNpbmZvKHhpZCwgdGNvbiwgKHZvaWQgX191c2VyICopYXJnKTsKIAkJCWJyZWFrOwor
CQljYXNlIENJRlNfSU9DX0dFVF9UQ09OX0lORk86CisJCQljaWZzX3NiID0gQ0lGU19TQihpbm9k
ZS0+aV9zYik7CisJCQl0bGluayA9IGNpZnNfc2JfdGxpbmsoY2lmc19zYik7CisJCQlpZiAoSVNf
RVJSKHRsaW5rKSkgeworCQkJCXJjID0gUFRSX0VSUih0bGluayk7CisJCQkJYnJlYWs7CisJCQl9
CisJCQl0Y29uID0gdGxpbmtfdGNvbih0bGluayk7CisJCQlyYyA9IHNtYl9tbnRfZ2V0X3Rjb25f
aW5mbyh0Y29uLCAodm9pZCBfX3VzZXIgKilhcmcpOworCQkJYnJlYWs7CiAJCWNhc2UgQ0lGU19F
TlVNRVJBVEVfU05BUFNIT1RTOgogCQkJaWYgKHBTTUJGaWxlID09IE5VTEwpCiAJCQkJYnJlYWs7
Ci0tIAoyLjM5LjIKCg==
--0000000000000962570609bf378b--
