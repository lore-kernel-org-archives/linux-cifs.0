Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3226B1339BA
	for <linux-cifs@vger.kernel.org>; Fri, 23 Feb 2024 18:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708714734; cv=none; b=TyAeH8vBu0/quYRWtpyiv3hNYTTNfDqepL22JSjYPidOnnlGcQcDU/tjYHv/d3Ddesm3/p1pbFuTt0nknavlYYdKjO/YaZ4+9KL5g47QQdRMh1NA0KMbGR2YgwQUAIjZorrm58Z1BxSLulfBQ+SHkhMIz+52MOeM3zgnnrzP7Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708714734; c=relaxed/simple;
	bh=kRBqxX4PjcxUvdKtyq+qaPq1foSn4lSWND9O7N5MueI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C8p91vbfpynJqiOHnX4oDaJFbMmZ1q06VPnNElHM1KOvWyHPlkQOC1BP7iNyb8XWWca6xmLKv4Jq4k1P8G9WGZ+En08m75G1umGdsIug0T8VnPFrv10isZEdlkhIod1LESu6u4zYV1BPQylaKd6FBEYLhLq+zUfEuytlbyAgVtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AMUoeUpe; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMUoeUpe"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-512ed314881so490475e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 23 Feb 2024 10:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708714730; x=1709319530; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r0ZNOV7vLX3TtO2Mgftc62LE+eOfcah04FjIA6cXMR0=;
        b=AMUoeUpeugeEYnYb8D3hV7fymlvKuTwFQ/C73BMc0jbUWOwwthRPjsSleYbwWAX66y
         h2gF7lDYIEBuTPFDwUq2sVWP+UHmbpf5XAp5fqV7/jDagwpGyF9350BUzADqfCaHt1NT
         BNd8m1EK3iP3N+BRzgdBZ9SsF/WY2atTyBhjasPZOqUirKqEfUootqPA0i9V+GCHkRYT
         z0pU4+SHtyy88hC5sKjgMCclWMnhSVSiv++b4uah0ZhMaCqWv1RWEoB7Zb2UWAkpC6Hd
         RoOiKT/m/5oAT2/8tVx0RBxEJahCnl/GvPacOPLb/WESegCjfpkAyocL8LrvbP9VjFbc
         sikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708714730; x=1709319530;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r0ZNOV7vLX3TtO2Mgftc62LE+eOfcah04FjIA6cXMR0=;
        b=WYn5EYzJw30FpgB9o+1tYm60lnrMfEZYIFedYBOLAYKsuW6Dqfrib88H/uqHFmLgoT
         /OK6X0t000LV6P4DRvMw5+i474E+iVQwH+tg/2O1ypLJva1CMCeEi0B1/0JMs4KgqtTw
         R6z8KkqW3HNiGJQ8mqgm3M2kTPeIXS6AgBfpiw1OcSI5V93nFygPdizU6xrccjwd/32U
         eixytMowTftYT8ENy6mMdWII5SAF0cZa8sQ1Ca+dB7nQB0543a8jtj1G8EyvPYQfqIp7
         oFmBKPuuH5DPRM/Fs+z4bitaeGTZdBlAsgpRhVNthR3d+U4cD87YB56Twk9wS71EDDYY
         I3Lg==
X-Forwarded-Encrypted: i=1; AJvYcCWKtzRnLlj3XZvyWkqU5IllXyO+jV8aPBMIBhI9rszkVMuShqNjbpvm8XTlVCxlUz6QU5+EUzJIc1FMsozcab5D+UYubQkUPAFhdw==
X-Gm-Message-State: AOJu0YzVUaORLZkG2CZzSEpR4/wY84SXdZB8LTgdQsYsOtzWO3+IYI2I
	3SWPdq2iLez2PohGF22EHoIsIuPoie8H9ZVw2p9K0x6Km1IXd+KoL02DBLjmnMTSb9VnFRzkjgV
	uv/4vGqN8vug4KjItPIUjfJ60XzM=
X-Google-Smtp-Source: AGHT+IECP/Nt+ShRihe8rChjqu3bwpyp4mkcsu/y0RxmoR36enzMOV/IskLwxeeGWXhcThPSmD3mGmkFvhbClrWxeWI=
X-Received: by 2002:ac2:44d6:0:b0:512:ed6b:1796 with SMTP id
 d22-20020ac244d6000000b00512ed6b1796mr391926lfm.49.1708714729934; Fri, 23 Feb
 2024 10:58:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtUnLDtwbW7or=Uc+AXkzLpHsJoPuoLE7yyjPVYjvZCow@mail.gmail.com>
 <CANT5p=oNRF9BAgybCX7dE+KvYj=k2G3tERa+fMJOY6tsuZ00Hw@mail.gmail.com>
 <bc2eaf5b9eafe2134820d1ea8c07e43f@manguebit.com> <CAH2r5mtSB0nDKxAJHtnp6USgoeVN7hNF79NaOcX_pnF5MVPFhA@mail.gmail.com>
 <CANT5p=qTe2XQJYVdYiVkc34WdsE4ekHaH0f4uMwUoDtSNchwug@mail.gmail.com> <e215357d673befaf1a2198aeb26b595b@manguebit.com>
In-Reply-To: <e215357d673befaf1a2198aeb26b595b@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 23 Feb 2024 12:58:37 -0600
Message-ID: <CAH2r5msfi54usMaqKR_-jpMkY4yBD+zd7bNPOjru60NyNWORJQ@mail.gmail.com>
Subject: Re: [WIP PATCH] allow changing the password on remount in some cases
To: Paulo Alcantara <pc@manguebit.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Bharath S M <bharathsm@microsoft.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	David Howells <dhowells@redhat.com>, samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000008027f00612112650"

--0000000000008027f00612112650
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is an updated patch which handles the point about preventing remount
from changing it for the sec=3Dkrb5 case.

This does look like something important for stable (users have cases where
they can't unmount due to a running app but need to update an expired
password) - are you preferring that we only allow this when user also speci=
fies
a new mount option in addition to "remount" ie "forcenewcreds" (or probably
better would be to call it "newpassword=3D" mount option)?

On Fri, Feb 23, 2024 at 8:08=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > No major objections for this patch. While it may not cover all cases
> > like DFS, multiuser etc., it's still a starting point to allowing
> > users to change password on existing mounts without unmounting.
>
> As long as it doesn't go through -stable and is accompanied with at
> least a new option like 'forcenewcreds', should be fine.  Then you have
> the next merge window to handle the missing cases and fix any problems.



--=20
Thanks,

Steve

--0000000000008027f00612112650
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-allow-changing-password-during-remount.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-allow-changing-password-during-remount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lsz0mgrg0>
X-Attachment-Id: f_lsz0mgrg0

RnJvbSA3OGQ1Yzc2ODNmNDVlNTVlNTU1NTE2ZGU4MGU1YTE3ZGE2ZWRlNmM0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTMgRmViIDIwMjQgMDA6NDA6MDEgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhbGxvdyBjaGFuZ2luZyBwYXNzd29yZCBkdXJpbmcgcmVtb3VudAoKVGhlcmUgYXJlIGNh
c2VzIHdoZXJlIGEgc2Vzc2lvbiBpcyBkaXNjb25uZWN0ZWQgYW5kIHBhc3N3b3JkIGhhcyBjaGFu
Z2VkCm9uIHRoZSBzZXJ2ZXIgKG9yIGV4cGlyZWQpIGZvciB0aGlzIHVzZXIgYW5kIHRoaXMgY3Vy
cmVudGx5IGNhbiBub3QKYmUgZml4ZWQgd2l0aG91dCB1bm1vdW50IGFuZCBtb3VudGluZyBhZ2Fp
bi4gIFRoaXMgcGF0Y2ggYWxsb3dzCnJlbW91bnQgdG8gY2hhbmdlIHRoZSBwYXNzd29yZCAoZm9y
IHRoZSBub24gS2VyYmVyb3MgY2FzZSwgS2VyYmVyb3MKdGlja2V0IHJlZnJlc2ggaXMgaGFuZGxl
ZCBkaWZmZXJlbnRseSkgd2hlbiB0aGUgc2Vzc2lvbiBpcyBkaXNjb25uZWN0ZWQKYW5kIHRoZSB1
c2VyIGNhbiBub3QgcmVjb25uZWN0IGR1ZSB0byBzdGlsbCB1c2luZyBvbGQgcGFzc3dvcmQuCgpG
dXR1cmUgcGF0Y2hlcyBzaG91bGQgYWxzbyBhbGxvdyB1cyB0byBzZXR1cCB0aGUga2V5cmluZyAo
Y2lmc2NyZWRzKQp0byBoYXZlIGFuICJhbHRlcm5hdGUgcGFzc3dvcmQiIHNvIHdlIHdvdWxkIGJl
IGFibGUgdG8gY2hhbmdlCnRoZSBwYXNzd29yZCBiZWZvcmUgdGhlIHNlc3Npb24gZHJvcHMgKHdp
dGhvdXQgdGhlIHJpc2sgb2YgcmFjZXMKYmV0d2VlbiB3aGVuIHRoZSBwYXNzd29yZCBjaGFuZ2Vz
IGFuZCB0aGUgZGlzY29ubmVjdCBvY2N1cnMgLQppZSBjYXNlcyB3aGVyZSB0aGUgb2xkIHBhc3N3
b3JkIGlzIHN0aWxsIG5lZWRlZCBiZWNhdXNlIHRoZSBuZXcKcGFzc3dvcmQgaGFzIG5vdCBmdWxs
eSByb2xsZWQgb3V0IHRvIGFsbCBzZXJ2ZXJzIHlldCkuCgpDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZwpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
Ci0tLQogZnMvc21iL2NsaWVudC9jaWZzX2RlYnVnLmMgfCAgMiArKwogZnMvc21iL2NsaWVudC9j
aWZzZ2xvYi5oICAgfCAgMSArCiBmcy9zbWIvY2xpZW50L2ZzX2NvbnRleHQuYyB8IDI1ICsrKysr
KysrKysrKysrKysrKysrLS0tLS0KIGZzL3NtYi9jbGllbnQvc21iMnBkdS5jICAgIHwgIDUgKysr
KysKIDQgZmlsZXMgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNfZGVidWcuYyBiL2ZzL3NtYi9jbGllbnQvY2lm
c19kZWJ1Zy5jCmluZGV4IDNlNDIwOWY0MWMxOC4uMjNkMjYyMmI5NjlmIDEwMDY0NAotLS0gYS9m
cy9zbWIvY2xpZW50L2NpZnNfZGVidWcuYworKysgYi9mcy9zbWIvY2xpZW50L2NpZnNfZGVidWcu
YwpAQCAtNDg4LDYgKzQ4OCw4IEBAIHN0YXRpYyBpbnQgY2lmc19kZWJ1Z19kYXRhX3Byb2Nfc2hv
dyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHZvaWQgKnYpCiAJCQkJc2VzLT5zZXNfY291bnQsIHNlcy0+
c2VydmVyT1MsIHNlcy0+c2VydmVyTk9TLAogCQkJCXNlcy0+Y2FwYWJpbGl0aWVzLCBzZXMtPnNl
c19zdGF0dXMpOwogCQkJfQorCQkJaWYgKHNlcy0+ZXhwaXJlZF9wd2QpCisJCQkJc2VxX3B1dHMo
bSwgInBhc3N3b3JkIG5vIGxvbmdlciB2YWxpZCAiKTsKIAkJCXNwaW5fdW5sb2NrKCZzZXMtPnNl
c19sb2NrKTsKIAogCQkJc2VxX3ByaW50ZihtLCAiXG5cdFNlY3VyaXR5IHR5cGU6ICVzICIsCmRp
ZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmggYi9mcy9zbWIvY2xpZW50L2NpZnNn
bG9iLmgKaW5kZXggNTNjNzVjZmIzM2FiLi5lYzlhMjZiZDA1YTEgMTAwNjQ0Ci0tLSBhL2ZzL3Nt
Yi9jbGllbnQvY2lmc2dsb2IuaAorKysgYi9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKQEAgLTEw
NjYsNiArMTA2Niw3IEBAIHN0cnVjdCBjaWZzX3NlcyB7CiAJZW51bSBzZWN1cml0eUVudW0gc2Vj
dHlwZTsgLyogd2hhdCBzZWN1cml0eSBmbGF2b3Igd2FzIHNwZWNpZmllZD8gKi8KIAlib29sIHNp
Z247CQkvKiBpcyBzaWduaW5nIHJlcXVpcmVkPyAqLwogCWJvb2wgZG9tYWluQXV0bzoxOworCWJv
b2wgZXhwaXJlZF9wd2Q7ICAvKiB0cmFjayBpZiBhY2Nlc3MgZGVuaWVkIG9yIGV4cGlyZWQgcHdk
IHNvIGNhbiBrbm93IGlmIG5lZWQgdG8gdXBkYXRlICovCiAJdW5zaWduZWQgaW50IGZsYWdzOwog
CV9fdTE2IHNlc3Npb25fZmxhZ3M7CiAJX191OCBzbWIzc2lnbmluZ2tleVtTTUIzX1NJR05fS0VZ
X1NJWkVdOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMgYi9mcy9zbWIv
Y2xpZW50L2ZzX2NvbnRleHQuYwppbmRleCA0YjJmNWFhMmVhMGUuLjEyODI3MGU3Njk0ZiAxMDA2
NDQKLS0tIGEvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMKKysrIGIvZnMvc21iL2NsaWVudC9m
c19jb250ZXh0LmMKQEAgLTc3Miw3ICs3NzIsNyBAQCBzdGF0aWMgdm9pZCBzbWIzX2ZzX2NvbnRl
eHRfZnJlZShzdHJ1Y3QgZnNfY29udGV4dCAqZmMpCiAgKi8KIHN0YXRpYyBpbnQgc21iM192ZXJp
ZnlfcmVjb25maWd1cmVfY3R4KHN0cnVjdCBmc19jb250ZXh0ICpmYywKIAkJCQkgICAgICAgc3Ry
dWN0IHNtYjNfZnNfY29udGV4dCAqbmV3X2N0eCwKLQkJCQkgICAgICAgc3RydWN0IHNtYjNfZnNf
Y29udGV4dCAqb2xkX2N0eCkKKwkJCQkgICAgICAgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqb2xk
X2N0eCwgYm9vbCBuZWVkX3JlY29uKQogewogCWlmIChuZXdfY3R4LT5wb3NpeF9wYXRocyAhPSBv
bGRfY3R4LT5wb3NpeF9wYXRocykgewogCQljaWZzX2Vycm9yZihmYywgImNhbiBub3QgY2hhbmdl
IHBvc2l4cGF0aHMgZHVyaW5nIHJlbW91bnRcbiIpOwpAQCAtNzk4LDggKzc5OCwxMyBAQCBzdGF0
aWMgaW50IHNtYjNfdmVyaWZ5X3JlY29uZmlndXJlX2N0eChzdHJ1Y3QgZnNfY29udGV4dCAqZmMs
CiAJfQogCWlmIChuZXdfY3R4LT5wYXNzd29yZCAmJgogCSAgICAoIW9sZF9jdHgtPnBhc3N3b3Jk
IHx8IHN0cmNtcChuZXdfY3R4LT5wYXNzd29yZCwgb2xkX2N0eC0+cGFzc3dvcmQpKSkgewotCQlj
aWZzX2Vycm9yZihmYywgImNhbiBub3QgY2hhbmdlIHBhc3N3b3JkIGR1cmluZyByZW1vdW50XG4i
KTsKLQkJcmV0dXJuIC1FSU5WQUw7CisJCWlmIChuZWVkX3JlY29uID09IGZhbHNlKSB7CisJCQlj
aWZzX2Vycm9yZihmYywKKwkJCQkgICAgImNhbiBub3QgY2hhbmdlIHBhc3N3b3JkIG9mIGFjdGl2
ZSBzZXNzaW9uIGR1cmluZyByZW1vdW50XG4iKTsKKwkJCXJldHVybiAtRUlOVkFMOworCQl9IGVs
c2UgaWYgKG9sZF9jdHgtPnNlY3R5cGUgPT0gS2VyYmVyb3MpCisJCQljaWZzX2Vycm9yZihmYywK
KwkJCQkgICAgImNhbiBub3QgY2hhbmdlIHBhc3N3b3JkIGZvciBLZXJiZXJvcyB2aWEgcmVtb3Vu
dFxuIik7CiAJfQogCWlmIChuZXdfY3R4LT5kb21haW5uYW1lICYmCiAJICAgICghb2xkX2N0eC0+
ZG9tYWlubmFtZSB8fCBzdHJjbXAobmV3X2N0eC0+ZG9tYWlubmFtZSwgb2xkX2N0eC0+ZG9tYWlu
bmFtZSkpKSB7CkBAIC04NDMsOSArODQ4LDE0IEBAIHN0YXRpYyBpbnQgc21iM19yZWNvbmZpZ3Vy
ZShzdHJ1Y3QgZnNfY29udGV4dCAqZmMpCiAJc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4ID0g
c21iM19mYzJjb250ZXh0KGZjKTsKIAlzdHJ1Y3QgZGVudHJ5ICpyb290ID0gZmMtPnJvb3Q7CiAJ
c3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiA9IENJRlNfU0Iocm9vdC0+ZF9zYik7CisJc3Ry
dWN0IGNpZnNfc2VzICpzZXMgPSBjaWZzX3NiX21hc3Rlcl90Y29uKGNpZnNfc2IpLT5zZXM7CisJ
Ym9vbCBuZWVkX3JlY29uID0gZmFsc2U7CiAJaW50IHJjOwogCi0JcmMgPSBzbWIzX3ZlcmlmeV9y
ZWNvbmZpZ3VyZV9jdHgoZmMsIGN0eCwgY2lmc19zYi0+Y3R4KTsKKwlpZiAoc2VzLT5leHBpcmVk
X3B3ZCkKKwkJbmVlZF9yZWNvbiA9IHRydWU7CisKKwlyYyA9IHNtYjNfdmVyaWZ5X3JlY29uZmln
dXJlX2N0eChmYywgY3R4LCBjaWZzX3NiLT5jdHgsIG5lZWRfcmVjb24pOwogCWlmIChyYykKIAkJ
cmV0dXJuIHJjOwogCkBAIC04NTgsNyArODY4LDEyIEBAIHN0YXRpYyBpbnQgc21iM19yZWNvbmZp
Z3VyZShzdHJ1Y3QgZnNfY29udGV4dCAqZmMpCiAJU1RFQUxfU1RSSU5HKGNpZnNfc2IsIGN0eCwg
VU5DKTsKIAlTVEVBTF9TVFJJTkcoY2lmc19zYiwgY3R4LCBzb3VyY2UpOwogCVNURUFMX1NUUklO
RyhjaWZzX3NiLCBjdHgsIHVzZXJuYW1lKTsKLQlTVEVBTF9TVFJJTkdfU0VOU0lUSVZFKGNpZnNf
c2IsIGN0eCwgcGFzc3dvcmQpOworCWlmIChuZWVkX3JlY29uID09IGZhbHNlKQorCQlTVEVBTF9T
VFJJTkdfU0VOU0lUSVZFKGNpZnNfc2IsIGN0eCwgcGFzc3dvcmQpOworCWVsc2UgIHsKKwkJa2Zy
ZWVfc2Vuc2l0aXZlKHNlcy0+cGFzc3dvcmQpOworCQlzZXMtPnBhc3N3b3JkID0ga3N0cmR1cChj
dHgtPnBhc3N3b3JkLCBHRlBfS0VSTkVMKTsKKwl9CiAJU1RFQUxfU1RSSU5HKGNpZnNfc2IsIGN0
eCwgZG9tYWlubmFtZSk7CiAJU1RFQUxfU1RSSU5HKGNpZnNfc2IsIGN0eCwgbm9kZW5hbWUpOwog
CVNURUFMX1NUUklORyhjaWZzX3NiLCBjdHgsIGlvY2hhcnNldCk7CmRpZmYgLS1naXQgYS9mcy9z
bWIvY2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCmluZGV4IDYwOGVl
MDU0OTFlMi4uYTUwMDM4MGQxYjJlIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUu
YworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpAQCAtMTUzNiw2ICsxNTM2LDExIEBAIFNN
QjJfc2Vzc19zZW5kcmVjZWl2ZShzdHJ1Y3QgU01CMl9zZXNzX2RhdGEgKnNlc3NfZGF0YSkKIAkJ
CSAgICAmc2Vzc19kYXRhLT5idWYwX3R5cGUsCiAJCQkgICAgQ0lGU19MT0dfRVJST1IgfCBDSUZT
X1NFU1NfT1AsICZyc3BfaW92KTsKIAljaWZzX3NtYWxsX2J1Zl9yZWxlYXNlKHNlc3NfZGF0YS0+
aW92WzBdLmlvdl9iYXNlKTsKKwlpZiAocmMgPT0gMCkKKwkJc2Vzc19kYXRhLT5zZXMtPmV4cGly
ZWRfcHdkID0gZmFsc2U7CisJZWxzZSBpZiAoKHJjID09IC1FQUNDRVMpIHx8IChyYyA9PSAtRUtF
WUVYUElSRUQpIHx8IChyYyA9PSAtRUtFWVJFVk9LRUQpKQorCQlzZXNzX2RhdGEtPnNlcy0+ZXhw
aXJlZF9wd2QgPSB0cnVlOworCiAJbWVtY3B5KCZzZXNzX2RhdGEtPmlvdlswXSwgJnJzcF9pb3Ys
IHNpemVvZihzdHJ1Y3Qga3ZlYykpOwogCiAJcmV0dXJuIHJjOwotLSAKMi40MC4xCgo=
--0000000000008027f00612112650--
