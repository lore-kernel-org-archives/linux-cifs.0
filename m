Received: from rx2.rx-server.de (rx2.rx-server.de [176.96.139.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E792A24DCFD
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 17:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.96.139.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934138; cv=none; b=qz8hmOXqtzPWJs9t8ZO/Lyf70PRobLxeUm4G/k3eqrn3wWWofFdoaIsilHj8SXYzliJq6bnFuzSnXPoHuNI9gtrmF/AMSBBcQRtvqosHcRzvCCbk2nE7vAdQ8iSmXuBJSqg54kpprwg+3hIlcFbfp6BU9vypDO2S7XyZArHnPOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934138; c=relaxed/simple;
	bh=70ScJyhfWqXNcx2vVrqz4VLNNqdlgZs+D4xG5JLigUY=;
	h=Message-Id:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cEJkMUCmabI7CkM3bRrRa6V3eVwZfNvvn9i+uaC1LZW+M3JEgliE0ViKLLC3fhUrxJy997ucFLd2G7coTDvcMRdgONwA/6EXeReu3UT0Lv1sWCRNsFCe9LEcWVmIPkMD30wLoij/W2tkKyF5nNGR1rtjQes6+kuxXAmibWfoM48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org; spf=pass smtp.mailfrom=casix.org; dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b=IeHARVTX; arc=none smtp.client-ip=176.96.139.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=casix.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b="IeHARVTX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casix.org; s=rx2;
	t=1754933524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tI88ZNH64MZCOcsgh6p2ckRm6UfVLMUl2pBlYi61qo8=;
	b=IeHARVTX6vRC/XBSCBKyONwBzoxTu7SFo67Pjc34/HdQWLmYCdCM7rtC7uqndQpQA0XbXD
	gsg48ij4SIsmWWJwsjeJjiTvsTIl0gUz4DUQTNmDZqY2Ye1NLvsr88mSaby2TcYM3rUSzK
	qjLE6N4TlYRgLt5MYIJx+3suFo8H9o0HOzkNrYXUACc6ypZNBSFuL/Bny+QU5y7Wv4sN/J
	UQW7QngnhaZKrV1b3bAXXazMscCcMv2p8XexJ3v2d1kZcxFvV2/X0tZqdczOxfkt5gAzsA
	hNWVAlYpsWxgjMGva+eEqK4ocVhjfNPejEqqDpZEp/KJ/8IiUx8/IHIIXTz/sw==
Message-Id: <f9401718e2be2ab22058b45a6817db912784ef61.camel@rx2.rx-server.de>
Subject: Re: ksmbd and special characters in file names
From: Philipp Kerling <pkerling@casix.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, Ralph
 =?ISO-8859-1?Q?B=F6hme?=
	 <slow@samba.org>
Date: Mon, 11 Aug 2025 19:32:03 +0200
In-Reply-To: <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@rx2.rx-server.de>
References: 
	<d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
	 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
	 <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
	 <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
	 <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org>
	 <CAKYAXd8FJcfFpGBkevgZaymcHiicJgs-time4r7fbD6n2hBg7w@mail.gmail.com>
	 <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@rx2.rx-server.de>
Content-Type: multipart/mixed; boundary="=-TPLv1QEJsPcEOxnU0Qh3"
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

--=-TPLv1QEJsPcEOxnU0Qh3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2025-05-27 (=E7=81=AB) =E3=81=AE 11:57 +0900 =E3=81=AB Namjae Jeon =E3=81=
=95=E3=82=93=E3=81=AF=E6=9B=B8=E3=81=8D=E3=81=BE=E3=81=97=E3=81=9F:
> On Mon, May 26, 2025 at 11:24=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.o=
rg>
> wrote:
> >=20
> > On Mon, May 26, 2025 at 9:39=E2=80=AFPM Ralph Boehme <slow@samba.org>
> > wrote:
> > >=20
> > > On 5/26/25 1:37 PM, Namjae Jeon wrote:
> > > > On Mon, May 26, 2025 at 7:45=E2=80=AFAM Steve French
> > > > <smfrench@gmail.com> wrote:
> > > > > If the POSIX/Linux context is included in the SMB3.1.1 open
> > > > > then we
> > > > > mounted with ("linux" or "posix")
> > > > Such a context could be created in smb2_create context like
> > > > apple context(AAPL).
> > > > However, I wonder if there is any plan to add it to SMB3.1.1
> > > > posix
> > > > extension specification.
> > > It's been part of the spec since the beginning. You can find it
> > > here:
> > Right, I found it.
> > Thanks for your reply.
> > >=20
> > > https://gitlab.com/samba-team/smb3-posix-spec/-/releases
> > >=20
> > > POSIX-SMB2 2.2.13.2.16 SMB2_CREATE_POSIX_CONTEXT
> Philipp,
>=20
> Can you confirm if your issue is fixed with the attached patch ?
after some more testing, I've found out that there is still (at least)
one special character causing problems. It is the ':' (colon), because
it is used to distinguish alternate data streams on NTFS, but is a
perfectly valid path character in POSIX as well. I have attached a
draft patch on top of the current master that fixes the problem on my
end. It does mean that alternate data streams cannot be accessed when a
posix create context is specified though. Anyway, I guess you can't
really have it both ways given the current specification. If you think
this is a valid approach, I can submit as a proper patch.


Before (being on the client in an smb3-mounted directory with -o
unix,posixpaths):

[philipp@atami smbmnt]$ echo 'hello' > 'a:b'
bash: a:b: No such file or directory
[philipp@atami smbmnt]$ echo 'hello' > 'a'
[philipp@atami smbmnt]$ cat a
hello
[philipp@atami smbmnt]$ mv a 'a:b'
mv: cannot move 'a' to 'a:b': Device or resource busy
[philipp@atami smbmnt]$ mkdir 'f:g'
mkdir: cannot create directory 'f:g': No such file or directory
[philipp@atami smbmnt]$ ls -l | grep 'test'
drwxr-xr-x?   2 root root        23 Aug 11 19:10 test:dir
[philipp@atami smbmnt]$ ls -l 'test:dir'
ls: cannot access 'test:dir': No such file or directory
[philipp@atami smbmnt]$=20

After:

[philipp@atami smbmnt]$ echo 'hello' > 'a:b'
[philipp@atami smbmnt]$ cat 'a:b'
hello
[philipp@atami smbmnt]$ echo 'hello' > 'a'
[philipp@atami smbmnt]$ cat 'a'
hello
[philipp@atami smbmnt]$ mv a 'a:b'
[philipp@atami smbmnt]$ mkdir 'f:g'
[philipp@atami smbmnt]$ ls -l | grep 'test'
drwxr-xr-x   2 root root        23 Aug 11 19:10 test:dir
[philipp@atami smbmnt]$ ls -l 'test:dir'
total 0
-rw-r--r-- 1 root root 0 Aug 11 19:10 a
[philipp@atami smbmnt]$=20


Best regards,
Philipp


--=-TPLv1QEJsPcEOxnU0Qh3
Content-Disposition: attachment; filename="ksmbd-allow-colon-in-posix-ctxt-path.patch"
Content-Type: text/x-patch; name="ksmbd-allow-colon-in-posix-ctxt-path.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL3NtYi9zZXJ2ZXIvc21iMnBkdS5jIGIvZnMvc21iL3NlcnZlci9zbWIy
cGR1LmMKaW5kZXggMGQ5MmNlNDlhZWQ3Li5hNTY1ZmMzNmNlZTYgMTAwNjQ0Ci0tLSBhL2ZzL3Nt
Yi9zZXJ2ZXIvc21iMnBkdS5jCisrKyBiL2ZzL3NtYi9zZXJ2ZXIvc21iMnBkdS5jCkBAIC0yOTUx
LDE4ICsyOTUxLDE5IEBAIGludCBzbWIyX29wZW4oc3RydWN0IGtzbWJkX3dvcmsgKndvcmspCiAJ
CX0KIAogCQlrc21iZF9kZWJ1ZyhTTUIsICJjb252ZXJ0ZWQgbmFtZSA9ICVzXG4iLCBuYW1lKTsK
LQkJaWYgKHN0cmNocihuYW1lLCAnOicpKSB7Ci0JCQlpZiAoIXRlc3Rfc2hhcmVfY29uZmlnX2Zs
YWcod29yay0+dGNvbi0+c2hhcmVfY29uZiwKLQkJCQkJCSAgICBLU01CRF9TSEFSRV9GTEFHX1NU
UkVBTVMpKSB7Ci0JCQkJcmMgPSAtRUJBREY7Ci0JCQkJZ290byBlcnJfb3V0MjsKLQkJCX0KLQkJ
CXJjID0gcGFyc2Vfc3RyZWFtX25hbWUobmFtZSwgJnN0cmVhbV9uYW1lLCAmc190eXBlKTsKLQkJ
CWlmIChyYyA8IDApCi0JCQkJZ290byBlcnJfb3V0MjsKLQkJfQogCiAJCWlmIChwb3NpeF9jdHh0
ID09IGZhbHNlKSB7CisJCQlpZiAoc3RyY2hyKG5hbWUsICc6JykpIHsKKwkJCQlpZiAoIXRlc3Rf
c2hhcmVfY29uZmlnX2ZsYWcod29yay0+dGNvbi0+c2hhcmVfY29uZiwKKwkJCQkJCQlLU01CRF9T
SEFSRV9GTEFHX1NUUkVBTVMpKSB7CisJCQkJCXJjID0gLUVCQURGOworCQkJCQlnb3RvIGVycl9v
dXQyOworCQkJCX0KKwkJCQlyYyA9IHBhcnNlX3N0cmVhbV9uYW1lKG5hbWUsICZzdHJlYW1fbmFt
ZSwgJnNfdHlwZSk7CisJCQkJaWYgKHJjIDwgMCkKKwkJCQkJZ290byBlcnJfb3V0MjsKKwkJCX0K
KwogCQkJcmMgPSBrc21iZF92YWxpZGF0ZV9maWxlbmFtZShuYW1lKTsKIAkJCWlmIChyYyA8IDAp
CiAJCQkJZ290byBlcnJfb3V0MjsKQEAgLTM0NDMsNiArMzQ0NCw4IEBAIGludCBzbWIyX29wZW4o
c3RydWN0IGtzbWJkX3dvcmsgKndvcmspCiAJZnAtPmF0dHJpYl9vbmx5ID0gIShyZXEtPkRlc2ly
ZWRBY2Nlc3MgJiB+KEZJTEVfUkVBRF9BVFRSSUJVVEVTX0xFIHwKIAkJCUZJTEVfV1JJVEVfQVRU
UklCVVRFU19MRSB8IEZJTEVfU1lOQ0hST05JWkVfTEUpKTsKIAorCWZwLT5pc19wb3NpeF9jdHh0
ID0gcG9zaXhfY3R4dDsKKwogCS8qIGZwIHNob3VsZCBiZSBzZWFyY2hhYmxlIHRocm91Z2gga3Nt
YmRfaW5vZGUubV9mcF9saXN0CiAJICogYWZ0ZXIgZGFjY2Vzcywgc2FjY2VzcywgYXR0cmliX29u
bHksIGFuZCBzdHJlYW0gYXJlCiAJICogaW5pdGlhbGl6ZWQuCkBAIC01OTg4LDcgKzU5OTEsNyBA
QCBzdGF0aWMgaW50IHNtYjJfcmVuYW1lKHN0cnVjdCBrc21iZF93b3JrICp3b3JrLAogCWlmIChJ
U19FUlIobmV3X25hbWUpKQogCQlyZXR1cm4gUFRSX0VSUihuZXdfbmFtZSk7CiAKLQlpZiAoc3Ry
Y2hyKG5ld19uYW1lLCAnOicpKSB7CisJaWYgKGZwLT5pc19wb3NpeF9jdHh0ID09IGZhbHNlICYm
IHN0cmNocihuZXdfbmFtZSwgJzonKSkgewogCQlpbnQgc190eXBlOwogCQljaGFyICp4YXR0cl9z
dHJlYW1fbmFtZSwgKnN0cmVhbV9uYW1lID0gTlVMTDsKIAkJc2l6ZV90IHhhdHRyX3N0cmVhbV9z
aXplOwpkaWZmIC0tZ2l0IGEvZnMvc21iL3NlcnZlci92ZnNfY2FjaGUuaCBiL2ZzL3NtYi9zZXJ2
ZXIvdmZzX2NhY2hlLmgKaW5kZXggMDcwODE1NWI1Y2FmLi43OGI1MDZjNWVmMDMgMTAwNjQ0Ci0t
LSBhL2ZzL3NtYi9zZXJ2ZXIvdmZzX2NhY2hlLmgKKysrIGIvZnMvc21iL3NlcnZlci92ZnNfY2Fj
aGUuaApAQCAtMTEyLDYgKzExMiw4IEBAIHN0cnVjdCBrc21iZF9maWxlIHsKIAlib29sCQkJCWlz
X2R1cmFibGU7CiAJYm9vbAkJCQlpc19wZXJzaXN0ZW50OwogCWJvb2wJCQkJaXNfcmVzaWxpZW50
OworCisJYm9vbCAgICAgICAgICAgICAgICAgICAgICAgICAgICBpc19wb3NpeF9jdHh0OwogfTsK
IAogc3RhdGljIGlubGluZSB2b2lkIHNldF9jdHhfYWN0b3Ioc3RydWN0IGRpcl9jb250ZXh0ICpj
dHgsCg==


--=-TPLv1QEJsPcEOxnU0Qh3--
