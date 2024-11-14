Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054EA1D9664
	for <linux-cifs@vger.kernel.org>; Thu, 14 Nov 2024 11:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731582472; cv=none; b=UeSR2x9hH3NskOmMDq5RwHC+VEGqOoytfsdd8jYpCVZ/T9WJ81ZlrCY2HvkCuf1QLZZYdJ47wmtkiwbpUyKBvNYXocwzIIeMb6Y9JE92iGMj/X4EGY+KSvL58+uj1EZa2tBdyw4E0whCQfMbyS18J8wpi9gLlU6LSzZpIOS8AWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731582472; c=relaxed/simple;
	bh=PdGeKYrrgGr7U8Fzeb6scwQMPdg7RzeAKbvuFx0cQe0=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=M7WFdlY6zQmon0/0yBSxbyK9sxSQrz+doNxECRP0RbysYYT921EKjQlZB110kXLOPLQy/313rmvuV510sPaPEUwDgzU6rsPe6A6B/M7lCLoExKe4s2cldn6w0t1lJWiHN5JzG9VIaFwGjoWehDgJnwGOSDyv7ahExnV61X5PGiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QKvtTgjZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QKvtTgjZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=O81q0W8PlrIAim/ZrgNYiXwfNUO3ekilE2Xp/m//CmY=; b=QKvtTgjZDauXhPMFykavpUpKBo
	GJaXf2VTGnzI7WZN+AZr/tguDisbM0ERpGLKcWOGYIO0kIFD0rCH+je0stJnw3GQjA6/kba1d73YZ
	pk+bcds9QPDHMA+2I2gxUHFMRdWglgBHOuxrpDadFtR/+ZXEmiXg+u7d4TYgt540dVf1L/KOywxOy
	RhnOFr6wMxQRBc32BlYv28FtINlUxdUY6vwEogE33gowHBoSP3vQfZesHDUZ46TkQ1GAcDsbNAgZ1
	l4IVXrz5d/Ua/MuRCSiT5UOE+FieUluuKxyUBsTzM44G+lZ2qIgs7IkKQuB/Z4cEjwArox8NwpINC
	k/MwF+B/ggSmjvhTb+oWr6j1WN4YjK7CEXJ2VpOuRoz6U9sHaJd72nd88t0QATiltQ1EVngPGcU5X
	hfyvhU8zLp2iJD6Si7BcVASEmRHPrUBKRoCnvBIoLV7KjnJUJwkPnRCsIeC04G3jkFntac/GrUsp+
	ebGQIpNHj6/vDYvAjUSFyLV2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tBXhT-00AXQP-0W;
	Thu, 14 Nov 2024 11:07:47 +0000
Content-Type: multipart/mixed; boundary="------------HeFPU9KQXkAMW6ixh0mlkMxJ"
Message-ID: <dad391b1-ce81-4cd0-8220-8b8374a0586e@samba.org>
Date: Thu, 14 Nov 2024 12:07:46 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: chmod
To: Jeremy Allison <jra@samba.org>, ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>,
 Steven French <Steven.French@microsoft.com>,
 CIFS <linux-cifs@vger.kernel.org>, Samuel Cabrero <scabrero@suse.de>
References: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
 <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com>
 <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
 <0447a472-9b60-478a-98e4-9f07a058380b@samba.org>
 <CAN05THQ=fx5hfp=FFRw4D5hCHvcoU8bs6cbeZT2X4o5i=QZkGg@mail.gmail.com>
 <ZzUe-xBC9NLcDSQi@jeremy-HP-Z840-Workstation>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
In-Reply-To: <ZzUe-xBC9NLcDSQi@jeremy-HP-Z840-Workstation>

This is a multi-part message in MIME format.
--------------HeFPU9KQXkAMW6ixh0mlkMxJ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/24 10:49 PM, Jeremy Allison wrote:
> On Thu, Nov 14, 2024 at 06:52:14AM +1000, ronnie sahlberg wrote:
>> On Thu, 14 Nov 2024 at 05:07, Ralph Boehme <slow@samba.org> wrote:
>>>
>>> On 11/13/24 4:39 PM, Ralph Boehme wrote:
>>> > Am I missing anything? Thoughts?
>>>
>>> did some more research on what the option modefromsid actually does and
>>> I guess the problem is that the behaviour is likely correct for
>>> modefromsid, it just doesn't work for smb3 posix, so populate_new_aces()
>>> needs to be tweaked to not include sid_authusers.
>>
>> Remember, it also need to work for use-cases with normal Windows and
>> Azure servers where you do NOT
>> have a multiuser mount (i.e. all client access is using the
>> credentials from the mount)
>> and you basically have an inherited ACE to "allow all access to the
>> mount user" for the whole share.
> 
> This is different from the SMB3-POSIX chmod operation.
> 
> I think Ralph is suggesting the modefromsid is left alone,
> and a new (separate) code path used for SMB3-POSIX that
> sends the one-ACE entry defined in that spec.

exactly.

I've implemented a quick fix and am currently testing it.

Thanks!
-slow
--------------HeFPU9KQXkAMW6ixh0mlkMxJ
Content-Type: text/x-patch; charset=UTF-8; name="chmod-smb3-posix.patch"
Content-Disposition: attachment; filename="chmod-smb3-posix.patch"
Content-Transfer-Encoding: base64

RnJvbSA3YjBhYTUyN2U2OTNkMTMzOTEyMjg5N2M0Y2RlYzY1MGQ2ODI2MTQ3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBSYWxwaCBCb2VobWUgPHNsb3dAc2FtYmEub3JnPgpE
YXRlOiBUaHUsIDE0IE5vdiAyMDI0IDExOjA1OjEzICswMTAwClN1YmplY3Q6IFtQQVRDSF0g
ZnMvc21iL2NsaWVudDogaW1wbGVtZW50IGNobW9kKCkgZm9yIFNNQjMgUE9TSVggRXh0ZW5z
aW9ucwoKLS0tCiBmcy9zbWIvY2xpZW50L2NpZnNhY2wuYyB8IDM3ICsrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNlcnRpb25z
KCspLCAxNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNh
Y2wuYyBiL2ZzL3NtYi9jbGllbnQvY2lmc2FjbC5jCmluZGV4IDFkMjk0ZDUzZjY2Mi4uZTUy
MzdjNjJhNDQwIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNhY2wuYworKysgYi9m
cy9zbWIvY2xpZW50L2NpZnNhY2wuYwpAQCAtOTMzLDcgKzkzMyw4IEBAIHN0YXRpYyB2b2lk
IHBvcHVsYXRlX25ld19hY2VzKGNoYXIgKm5hY2xfYmFzZSwKIAkJc3RydWN0IHNtYl9zaWQg
KnBvd25lcnNpZCwKIAkJc3RydWN0IHNtYl9zaWQgKnBncnBzaWQsCiAJCV9fdTY0ICpwbm1v
ZGUsIHUzMiAqcG51bV9hY2VzLCB1MTYgKnBuc2l6ZSwKLQkJYm9vbCBtb2RlZnJvbXNpZCkK
KwkJYm9vbCBtb2RlZnJvbXNpZCwKKwkJYm9vbCBwb3NpeCkKIHsKIAlfX3U2NCBubW9kZTsK
IAl1MzIgbnVtX2FjZXMgPSAwOwpAQCAtOTUwLDEzICs5NTEsMTUgQEAgc3RhdGljIHZvaWQg
cG9wdWxhdGVfbmV3X2FjZXMoY2hhciAqbmFjbF9iYXNlLAogCW51bV9hY2VzID0gKnBudW1f
YWNlczsKIAluc2l6ZSA9ICpwbnNpemU7CiAKLQlpZiAobW9kZWZyb21zaWQpIHsKKwlpZiAo
bW9kZWZyb21zaWQgfHwgcG9zaXgpIHsKIAkJcG5udGFjZSA9IChzdHJ1Y3Qgc21iX2FjZSAq
KSAobmFjbF9iYXNlICsgbnNpemUpOwogCQluc2l6ZSArPSBzZXR1cF9zcGVjaWFsX21vZGVf
QUNFKHBubnRhY2UsIG5tb2RlKTsKIAkJbnVtX2FjZXMrKzsKLQkJcG5udGFjZSA9IChzdHJ1
Y3Qgc21iX2FjZSAqKSAobmFjbF9iYXNlICsgbnNpemUpOwotCQluc2l6ZSArPSBzZXR1cF9h
dXRodXNlcnNfQUNFKHBubnRhY2UpOwotCQludW1fYWNlcysrOworCQlpZiAobW9kZWZyb21z
aWQpIHsKKwkJCXBubnRhY2UgPSAoc3RydWN0IHNtYl9hY2UgKikgKG5hY2xfYmFzZSArIG5z
aXplKTsKKwkJCW5zaXplICs9IHNldHVwX2F1dGh1c2Vyc19BQ0UocG5udGFjZSk7CisJCQlu
dW1fYWNlcysrOworCQl9CiAJCWdvdG8gc2V0X3NpemU7CiAJfQogCkBAIC0xMDc2LDcgKzEw
NzksNyBAQCBzdGF0aWMgX191MTYgcmVwbGFjZV9zaWRzX2FuZF9jb3B5X2FjZXMoc3RydWN0
IHNtYl9hY2wgKnBkYWNsLCBzdHJ1Y3Qgc21iX2FjbCAqcAogCiBzdGF0aWMgaW50IHNldF9j
aG1vZF9kYWNsKHN0cnVjdCBzbWJfYWNsICpwZGFjbCwgc3RydWN0IHNtYl9hY2wgKnBuZGFj
bCwKIAkJc3RydWN0IHNtYl9zaWQgKnBvd25lcnNpZCwJc3RydWN0IHNtYl9zaWQgKnBncnBz
aWQsCi0JCV9fdTY0ICpwbm1vZGUsIGJvb2wgbW9kZV9mcm9tX3NpZCkKKwkJX191NjQgKnBu
bW9kZSwgYm9vbCBtb2RlX2Zyb21fc2lkLCBib29sIHBvc2l4KQogewogCWludCBpOwogCXUx
NiBzaXplID0gMDsKQEAgLTEwOTgsNyArMTEwMSw3IEBAIHN0YXRpYyBpbnQgc2V0X2NobW9k
X2RhY2woc3RydWN0IHNtYl9hY2wgKnBkYWNsLCBzdHJ1Y3Qgc21iX2FjbCAqcG5kYWNsLAog
CQlwb3B1bGF0ZV9uZXdfYWNlcyhuYWNsX2Jhc2UsCiAJCQkJcG93bmVyc2lkLCBwZ3Jwc2lk
LAogCQkJCXBubW9kZSwgJm51bV9hY2VzLCAmbnNpemUsCi0JCQkJbW9kZV9mcm9tX3NpZCk7
CisJCQkJbW9kZV9mcm9tX3NpZCwgcG9zaXgpOwogCQlnb3RvIGZpbmFsaXplX2RhY2w7CiAJ
fQogCkBAIC0xMTE1LDcgKzExMTgsNyBAQCBzdGF0aWMgaW50IHNldF9jaG1vZF9kYWNsKHN0
cnVjdCBzbWJfYWNsICpwZGFjbCwgc3RydWN0IHNtYl9hY2wgKnBuZGFjbCwKIAkJCXBvcHVs
YXRlX25ld19hY2VzKG5hY2xfYmFzZSwKIAkJCQkJcG93bmVyc2lkLCBwZ3Jwc2lkLAogCQkJ
CQlwbm1vZGUsICZudW1fYWNlcywgJm5zaXplLAotCQkJCQltb2RlX2Zyb21fc2lkKTsKKwkJ
CQkJbW9kZV9mcm9tX3NpZCwgcG9zaXgpOwogCiAJCQluZXdfYWNlc19zZXQgPSB0cnVlOwog
CQl9CkBAIC0xMTQ0LDcgKzExNDcsNyBAQCBzdGF0aWMgaW50IHNldF9jaG1vZF9kYWNsKHN0
cnVjdCBzbWJfYWNsICpwZGFjbCwgc3RydWN0IHNtYl9hY2wgKnBuZGFjbCwKIAkJcG9wdWxh
dGVfbmV3X2FjZXMobmFjbF9iYXNlLAogCQkJCXBvd25lcnNpZCwgcGdycHNpZCwKIAkJCQlw
bm1vZGUsICZudW1fYWNlcywgJm5zaXplLAotCQkJCW1vZGVfZnJvbV9zaWQpOworCQkJCW1v
ZGVfZnJvbV9zaWQsIHBvc2l4KTsKIAogCQluZXdfYWNlc19zZXQgPSB0cnVlOwogCX0KQEAg
LTEyNTEsNyArMTI1NCw3IEBAIHN0YXRpYyBpbnQgcGFyc2Vfc2VjX2Rlc2Moc3RydWN0IGNp
ZnNfc2JfaW5mbyAqY2lmc19zYiwKIC8qIENvbnZlcnQgcGVybWlzc2lvbiBiaXRzIGZyb20g
bW9kZSB0byBlcXVpdmFsZW50IENJRlMgQUNMICovCiBzdGF0aWMgaW50IGJ1aWxkX3NlY19k
ZXNjKHN0cnVjdCBzbWJfbnRzZCAqcG50c2QsIHN0cnVjdCBzbWJfbnRzZCAqcG5udHNkLAog
CV9fdTMyIHNlY2Rlc2NsZW4sIF9fdTMyICpwbnNlY2Rlc2NsZW4sIF9fdTY0ICpwbm1vZGUs
IGt1aWRfdCB1aWQsIGtnaWRfdCBnaWQsCi0JYm9vbCBtb2RlX2Zyb21fc2lkLCBib29sIGlk
X2Zyb21fc2lkLCBpbnQgKmFjbGZsYWcpCisJYm9vbCBtb2RlX2Zyb21fc2lkLCBib29sIGlk
X2Zyb21fc2lkLCBib29sIHBvc2l4LCBpbnQgKmFjbGZsYWcpCiB7CiAJaW50IHJjID0gMDsK
IAlfX3UzMiBkYWNsb2Zmc2V0OwpAQCAtMTI4OCw3ICsxMjkxLDcgQEAgc3RhdGljIGludCBi
dWlsZF9zZWNfZGVzYyhzdHJ1Y3Qgc21iX250c2QgKnBudHNkLCBzdHJ1Y3Qgc21iX250c2Qg
KnBubnRzZCwKIAkJbmRhY2xfcHRyLT5udW1fYWNlcyA9IGNwdV90b19sZTMyKDApOwogCiAJ
CXJjID0gc2V0X2NobW9kX2RhY2woZGFjbF9wdHIsIG5kYWNsX3B0ciwgb3duZXJfc2lkX3B0
ciwgZ3JvdXBfc2lkX3B0ciwKLQkJCQkgICAgcG5tb2RlLCBtb2RlX2Zyb21fc2lkKTsKKwkJ
CQkgICAgcG5tb2RlLCBtb2RlX2Zyb21fc2lkLCBwb3NpeCk7CiAKIAkJc2lkc29mZnNldCA9
IG5kYWNsb2Zmc2V0ICsgbGUxNl90b19jcHUobmRhY2xfcHRyLT5zaXplKTsKIAkJLyogY29w
eSB0aGUgbm9uLWRhY2wgcG9ydGlvbiBvZiBzZWNkZXNjICovCkBAIC0xNTg3LDYgKzE1OTAs
NyBAQCBpZF9tb2RlX3RvX2NpZnNfYWNsKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGNvbnN0IGNo
YXIgKnBhdGgsIF9fdTY0ICpwbm1vZGUsCiAJc3RydWN0IHRjb25fbGluayAqdGxpbmsgPSBj
aWZzX3NiX3RsaW5rKGNpZnNfc2IpOwogCXN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25z
ICpvcHM7CiAJYm9vbCBtb2RlX2Zyb21fc2lkLCBpZF9mcm9tX3NpZDsKKwlib29sIHBvc2l4
ID0gdGxpbmtfdGNvbih0bGluayktPnBvc2l4X2V4dGVuc2lvbnM7CiAJY29uc3QgdTMyIGlu
Zm8gPSAwOwogCiAJaWYgKElTX0VSUih0bGluaykpCkBAIC0xNjIyLDEyICsxNjI2LDEzIEBA
IGlkX21vZGVfdG9fY2lmc19hY2woc3RydWN0IGlub2RlICppbm9kZSwgY29uc3QgY2hhciAq
cGF0aCwgX191NjQgKnBubW9kZSwKIAkJaWRfZnJvbV9zaWQgPSBmYWxzZTsKIAogCS8qIFBv
dGVudGlhbGx5LCBmaXZlIG5ldyBBQ0VzIGNhbiBiZSBhZGRlZCB0byB0aGUgQUNMIGZvciBV
LEcsTyBtYXBwaW5nICovCi0JbnNlY2Rlc2NsZW4gPSBzZWNkZXNjbGVuOwogCWlmIChwbm1v
ZGUgJiYgKnBubW9kZSAhPSBOT19DSEFOR0VfNjQpIHsgLyogY2htb2QgKi8KLQkJaWYgKG1v
ZGVfZnJvbV9zaWQpCi0JCQluc2VjZGVzY2xlbiArPSAyICogc2l6ZW9mKHN0cnVjdCBzbWJf
YWNlKTsKKwkJaWYgKHBvc2l4KQorCQkJbnNlY2Rlc2NsZW4gPSAxICogc2l6ZW9mKHN0cnVj
dCBzbWJfYWNlKTsKKwkJZWxzZSBpZiAobW9kZV9mcm9tX3NpZCkKKwkJCW5zZWNkZXNjbGVu
ID0gc2VjZGVzY2xlbiArICgyICogc2l6ZW9mKHN0cnVjdCBzbWJfYWNlKSk7CiAJCWVsc2Ug
LyogY2lmc2FjbCAqLwotCQkJbnNlY2Rlc2NsZW4gKz0gNSAqIHNpemVvZihzdHJ1Y3Qgc21i
X2FjZSk7CisJCQluc2VjZGVzY2xlbiA9IHNlY2Rlc2NsZW4gKyAoNSAqIHNpemVvZihzdHJ1
Y3Qgc21iX2FjZSkpOwogCX0gZWxzZSB7IC8qIGNob3duICovCiAJCS8qIFdoZW4gb3duZXJz
aGlwIGNoYW5nZXMsIGNoYW5nZXMgbmV3IG93bmVyIHNpZCBsZW5ndGggY291bGQgYmUgZGlm
ZmVyZW50ICovCiAJCW5zZWNkZXNjbGVuID0gc2l6ZW9mKHN0cnVjdCBzbWJfbnRzZCkgKyAo
c2l6ZW9mKHN0cnVjdCBzbWJfc2lkKSAqIDIpOwpAQCAtMTY1Nyw3ICsxNjYyLDcgQEAgaWRf
bW9kZV90b19jaWZzX2FjbChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBjb25zdCBjaGFyICpwYXRo
LCBfX3U2NCAqcG5tb2RlLAogCX0KIAogCXJjID0gYnVpbGRfc2VjX2Rlc2MocG50c2QsIHBu
bnRzZCwgc2VjZGVzY2xlbiwgJm5zZWNkZXNjbGVuLCBwbm1vZGUsIHVpZCwgZ2lkLAotCQkJ
ICAgIG1vZGVfZnJvbV9zaWQsIGlkX2Zyb21fc2lkLCAmYWNsZmxhZyk7CisJCQkgICAgbW9k
ZV9mcm9tX3NpZCwgaWRfZnJvbV9zaWQsIHBvc2l4LCAmYWNsZmxhZyk7CiAKIAljaWZzX2Ri
ZyhOT0lTWSwgImJ1aWxkX3NlY19kZXNjIHJjOiAlZFxuIiwgcmMpOwogCi0tIAoyLjQ3LjAK
Cg==

--------------HeFPU9KQXkAMW6ixh0mlkMxJ--
