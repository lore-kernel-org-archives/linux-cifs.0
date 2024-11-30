Received: from mail2.galax.is (ns2.galax.is [185.101.96.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B6214A4C6;
	Sat, 30 Nov 2024 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.101.96.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732969984; cv=none; b=VQdXJHMj0wvAvu/5YB67iZOcQIJC9IRIYLtiMjmy8A8skxN+5yQPeF7qfzlLniP+4xWoU7p4wAM+yx04OnVmDfH8hyxm4mhlm46M1eHwOTNXcNp44tY79cX1Si3Qhb/RgBhxKTeOtJJOmb47Ju0IcXHAGZGubmCL9HJ02sJbwpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732969984; c=relaxed/simple;
	bh=B+/rAqHq/4Tm3UqzMGfHzBIHcmNbQQMlWPgGCVV9Dmw=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=mnXUa5rwncnkLHqsM1P2mJ8wWSh+FgTnNvOZ9lNWys02EvFxf75CkVsyJcTsFaU4QAl4mJyB65Z/dorQuaIT/jIUge+1lsHIwAwyuyXdHLGPcl647763FTa06vgkHi5WIZkCBAgRmrTzbnj+ZiSWF9bvKPo6KbsdkG3u0VBZS0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=galax.is; spf=pass smtp.mailfrom=galax.is; dkim=pass (2048-bit key) header.d=galax.is header.i=@galax.is header.b=ysLVkQOe; arc=none smtp.client-ip=185.101.96.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=galax.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=galax.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=galax.is header.i=@galax.is header.b="ysLVkQOe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=galax.is; s=default;
	t=1732965475; bh=B+/rAqHq/4Tm3UqzMGfHzBIHcmNbQQMlWPgGCVV9Dmw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ysLVkQOeKfj0OVIwytoFHbdQsureXLmhj7w4vXWJPG14IRqUx+HYM8TfAjDxrdqK3
	 emOMj6ka5tnbgeO33cao3EF5LZMasmIBZewVA1nNdc2mpNQ/QSoaByl1UD0YaqX5IX
	 FKFFrL+bWOQJpaWW2/lKSYxEdr/rEPf7JaTvrm0r0k3xbgpv03Q/qAjLNt15Cco8t4
	 1uOTJzkHOlBLJyLypMF2n68QW7vNpPyTkNl0FRyotjoubpTZKO2Okle7e4nWDoqfZf
	 kVxPfBgqIXfnlzuB+zUtLgmAIOYPP14OzXv3+/HIEVnLUt5tKWsccFlXHIvGKmOffb
	 b9QFfGwxLhbLQ==
Received: from [IPV6:2001:4091:a247:843f:ae6e:e692:c5a4:10bc] (unknown [IPv6:2001:4091:a247:843f:ae6e:e692:c5a4:10bc])
	by mail2.galax.is (Postfix) with ESMTPSA id CB2D91FF38;
	Sat, 30 Nov 2024 12:17:53 +0100 (CET)
Content-Type: multipart/mixed; boundary="------------aXDlJb8JN0TyYB1Ro06mAAly"
Message-ID: <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
Date: Sat, 30 Nov 2024 12:17:47 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
To: Salvatore Bonaccorso <carnil@debian.org>, gregkh@linuxfoundation.org,
 Paulo Alcantara <pc@manguebit.com>, Steve French <stfrench@microsoft.com>,
 Michael <mk-debian@galax.is>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
 linux-cifs@vger.kernel.org
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
From: Michael Krause <mk-debian@galax.is>
Content-Language: de-LU, en-US
In-Reply-To: <Z0rZFrZ0Cz3LJEbI@eldamar.lan>

This is a multi-part message in MIME format.
--------------aXDlJb8JN0TyYB1Ro06mAAly
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi *,


On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
> Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
> in smb2_reconnect_server()") which seems in fact to solve the issue.
> 
> Michael, can you please post your backport here for review from Paulo
> and Steve?

Of course, attached.

Now I really hope I didn't screw it up :)

cheers
Michael
--------------aXDlJb8JN0TyYB1Ro06mAAly
Content-Type: text/x-patch; charset=UTF-8; name="backport.patch"
Content-Disposition: attachment; filename="backport.patch"
Content-Transfer-Encoding: base64

LS0tIGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMJMjAyNC0xMS0yMiAxNDozNzozNS4wMDAw
MDAwMDAgKzAwMDAKKysrIGIvZnMvc21iL2NsaWVudC9jb25uZWN0LmMJMjAyNC0xMS0zMCAx
MTowNTo1My4xMzczMzkyMjkgKzAwMDAKQEAgLTI1OSw3ICsyNTksMTMgQEAKIAogCXNwaW5f
bG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShz
ZXMsIG5zZXMsICZwc2VydmVyLT5zbWJfc2VzX2xpc3QsIHNtYl9zZXNfbGlzdCkgewotCQkv
KiBjaGVjayBpZiBpZmFjZSBpcyBzdGlsbCBhY3RpdmUgKi8KKwkJc3Bpbl9sb2NrKCZzZXMt
PnNlc19sb2NrKTsKKwkJaWYgKHNlcy0+c2VzX3N0YXR1cyA9PSBTRVNfRVhJVElORykgewor
CQkJc3Bpbl91bmxvY2soJnNlcy0+c2VzX2xvY2spOworCQkJY29udGludWU7CisJCX0KKwkJ
c3Bpbl91bmxvY2soJnNlcy0+c2VzX2xvY2spOworCiAJCXNwaW5fbG9jaygmc2VzLT5jaGFu
X2xvY2spOwogCQlpZiAoIWNpZnNfY2hhbl9pc19pZmFjZV9hY3RpdmUoc2VzLCBzZXJ2ZXIp
KSB7CiAJCQlzcGluX3VubG9jaygmc2VzLT5jaGFuX2xvY2spOwpAQCAtMTk3NywzMSArMTk4
Myw2IEBACiAJcmV0dXJuIHJjOwogfQogCi0vKioKLSAqIGNpZnNfZnJlZV9pcGMgLSBoZWxw
ZXIgdG8gcmVsZWFzZSB0aGUgc2Vzc2lvbiBJUEMgdGNvbgotICogQHNlczogc21iIHNlc3Np
b24gdG8gdW5tb3VudCB0aGUgSVBDIGZyb20KLSAqCi0gKiBOZWVkcyB0byBiZSBjYWxsZWQg
ZXZlcnl0aW1lIGEgc2Vzc2lvbiBpcyBkZXN0cm95ZWQuCi0gKgotICogT24gc2Vzc2lvbiBj
bG9zZSwgdGhlIElQQyBpcyBjbG9zZWQgYW5kIHRoZSBzZXJ2ZXIgbXVzdCByZWxlYXNlIGFs
bCB0Y29ucyBvZiB0aGUgc2Vzc2lvbi4KLSAqIE5vIG5lZWQgdG8gc2VuZCBhIHRyZWUgZGlz
Y29ubmVjdCBoZXJlLgotICoKLSAqIEJlc2lkZXMsIGl0IHdpbGwgbWFrZSB0aGUgc2VydmVy
IHRvIG5vdCBjbG9zZSBkdXJhYmxlIGFuZCByZXNpbGllbnQgZmlsZXMgb24gc2Vzc2lvbiBj
bG9zZSwgYXMKLSAqIHNwZWNpZmllZCBpbiBNUy1TTUIyIDMuMy41LjYgUmVjZWl2aW5nIGFu
IFNNQjIgTE9HT0ZGIFJlcXVlc3QuCi0gKi8KLXN0YXRpYyBpbnQKLWNpZnNfZnJlZV9pcGMo
c3RydWN0IGNpZnNfc2VzICpzZXMpCi17Ci0Jc3RydWN0IGNpZnNfdGNvbiAqdGNvbiA9IHNl
cy0+dGNvbl9pcGM7Ci0KLQlpZiAodGNvbiA9PSBOVUxMKQotCQlyZXR1cm4gMDsKLQotCXRj
b25JbmZvRnJlZSh0Y29uKTsKLQlzZXMtPnRjb25faXBjID0gTlVMTDsKLQlyZXR1cm4gMDsK
LX0KLQogc3RhdGljIHN0cnVjdCBjaWZzX3NlcyAqCiBjaWZzX2ZpbmRfc21iX3NlcyhzdHJ1
Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0
eCkKIHsKQEAgLTIwMzUsMzUgKzIwMTYsNDQgQEAKIHsKIAl1bnNpZ25lZCBpbnQgcmMsIHhp
ZDsKIAl1bnNpZ25lZCBpbnQgY2hhbl9jb3VudDsKKyAJYm9vbCBkb19sb2dvZmY7CisgCXN0
cnVjdCBjaWZzX3Rjb24gKnRjb247CiAJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVy
ID0gc2VzLT5zZXJ2ZXI7CiAKKyAJc3Bpbl9sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CiAJ
c3Bpbl9sb2NrKCZzZXMtPnNlc19sb2NrKTsKLQlpZiAoc2VzLT5zZXNfc3RhdHVzID09IFNF
U19FWElUSU5HKSB7CisJY2lmc19kYmcoRllJLCAiJXM6IGlkPTB4JWxseCBzZXNfY291bnQ9
JWQgc2VzX3N0YXR1cz0ldSBpcGM9JXNcbiIsCisJCSBfX2Z1bmNfXywgc2VzLT5TdWlkLCBz
ZXMtPnNlc19jb3VudCwgc2VzLT5zZXNfc3RhdHVzLAorCQkgc2VzLT50Y29uX2lwYyA/IHNl
cy0+dGNvbl9pcGMtPnRyZWVfbmFtZSA6ICJub25lIik7CisJaWYgKHNlcy0+c2VzX3N0YXR1
cyA9PSBTRVNfRVhJVElORyB8fCAtLXNlcy0+c2VzX2NvdW50ID4gMCkgewogCQlzcGluX3Vu
bG9jaygmc2VzLT5zZXNfbG9jayk7CisgCQlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xv
Y2spOwogCQlyZXR1cm47CiAJfQotCXNwaW5fdW5sb2NrKCZzZXMtPnNlc19sb2NrKTsKKyAJ
Lyogc2VzX2NvdW50IGNhbiBuZXZlciBnbyBuZWdhdGl2ZSAqLworIAlXQVJOX09OKHNlcy0+
c2VzX2NvdW50IDwgMCk7CiAKLQljaWZzX2RiZyhGWUksICIlczogc2VzX2NvdW50PSVkXG4i
LCBfX2Z1bmNfXywgc2VzLT5zZXNfY291bnQpOwotCWNpZnNfZGJnKEZZSSwKLQkJICIlczog
c2VzIGlwYzogJXNcbiIsIF9fZnVuY19fLCBzZXMtPnRjb25faXBjID8gc2VzLT50Y29uX2lw
Yy0+dHJlZV9uYW1lIDogIk5PTkUiKTsKLQotCXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xv
Y2spOwotCWlmICgtLXNlcy0+c2VzX2NvdW50ID4gMCkgewotCQlzcGluX3VubG9jaygmY2lm
c190Y3Bfc2VzX2xvY2spOwotCQlyZXR1cm47Ci0JfQorCXNwaW5fbG9jaygmc2VzLT5jaGFu
X2xvY2spOworCWNpZnNfY2hhbl9jbGVhcl9uZWVkX3JlY29ubmVjdChzZXMsIHNlcnZlcik7
CisJc3Bpbl91bmxvY2soJnNlcy0+Y2hhbl9sb2NrKTsKKworCWRvX2xvZ29mZiA9IHNlcy0+
c2VzX3N0YXR1cyA9PSBTRVNfR09PRCAmJiBzZXJ2ZXItPm9wcy0+bG9nb2ZmOworCXNlcy0+
c2VzX3N0YXR1cyA9IFNFU19FWElUSU5HOworCXRjb24gPSBzZXMtPnRjb25faXBjOworCXNl
cy0+dGNvbl9pcGMgPSBOVUxMOworIAlzcGluX3VubG9jaygmc2VzLT5zZXNfbG9jayk7CiAJ
c3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKIAotCS8qIHNlc19jb3VudCBjYW4g
bmV2ZXIgZ28gbmVnYXRpdmUgKi8KLQlXQVJOX09OKHNlcy0+c2VzX2NvdW50IDwgMCk7Ci0K
LQlpZiAoc2VzLT5zZXNfc3RhdHVzID09IFNFU19HT09EKQotCQlzZXMtPnNlc19zdGF0dXMg
PSBTRVNfRVhJVElORzsKLQotCWNpZnNfZnJlZV9pcGMoc2VzKTsKLQotCWlmIChzZXMtPnNl
c19zdGF0dXMgPT0gU0VTX0VYSVRJTkcgJiYgc2VydmVyLT5vcHMtPmxvZ29mZikgeworCS8q
CisJICogT24gc2Vzc2lvbiBjbG9zZSwgdGhlIElQQyBpcyBjbG9zZWQgYW5kIHRoZSBzZXJ2
ZXIgbXVzdCByZWxlYXNlIGFsbAorCSAqIHRjb25zIG9mIHRoZSBzZXNzaW9uLiAgTm8gbmVl
ZCB0byBzZW5kIGEgdHJlZSBkaXNjb25uZWN0IGhlcmUuCisJICoKKwkgKiBCZXNpZGVzLCBp
dCB3aWxsIG1ha2UgdGhlIHNlcnZlciB0byBub3QgY2xvc2UgZHVyYWJsZSBhbmQgcmVzaWxp
ZW50CisJICogZmlsZXMgb24gc2Vzc2lvbiBjbG9zZSwgYXMgc3BlY2lmaWVkIGluIE1TLVNN
QjIgMy4zLjUuNiBSZWNlaXZpbmcgYW4KKwkgKiBTTUIyIExPR09GRiBSZXF1ZXN0LgorCSAq
LworCXRjb25JbmZvRnJlZSh0Y29uKTsKKwlpZiAoZG9fbG9nb2ZmKSB7CiAJCXhpZCA9IGdl
dF94aWQoKTsKIAkJcmMgPSBzZXJ2ZXItPm9wcy0+bG9nb2ZmKHhpZCwgc2VzKTsKIAkJaWYg
KHJjKQo=

--------------aXDlJb8JN0TyYB1Ro06mAAly--
