Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E9F184E
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jan 2024 03:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705633454; cv=none; b=cw2El0iVPzXylf7T1gLTM3R+T5RDYYhk4mSeqX0i1ssouxUvEMvWFYnOt3H7hm4X7vEHqFFCun5x8J/IrEgKhE3Wm3Da9viS9FoVgizzMa5Re1ks3gsIu382X0YeXg+nlVZXmaeFhC0hS1KampKhw73QvHnBz/mE7e6Apc0LKuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705633454; c=relaxed/simple;
	bh=bu7Sc0ItTPdofCiFK1zcdmcumCxh81q369SQHXfILhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ubjhLu5zLE+rObgFjORIv5WVPLfOwf92a2Prd+n40DApSMBw0mRrWQpJspSU3q0ywYC4nsNddgsJrEH7+Vo9H3GITX6CPRpgNlXafhIiVo542Tb1AZmUCb3xIgdw5V3AyZHXSySkXwFzIXRCby4OBjw2e1mesrSGOZg5GGgYZk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e4OoxOC4; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4OoxOC4"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-50e7c6f0487so297439e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jan 2024 19:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705633450; x=1706238250; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aUCXTG9uWSQReWhL7/oWYGouMSURFDuOiKy+eREFTfs=;
        b=e4OoxOC405Qc2I8pqsFl15KzAmzo6oMSkV2UG5IyquKGUO1fRH0bQx0JeMhy0hLDie
         x712pc5CXQk8yTu0HpdwEbGs1SHkDFTIsBK421NVxKAF2QmgmNEUXl/LuFIeVGnmE3IU
         Ngpap6CISRfdie7eGlCv91Coqd4RuZXxZWFsKzk5HCrhWrEYSwAoLFWyMTKSM7t5lHtj
         NJBmLSsZyYEFQSCDUUDtkEU2yxT+0Dsa0Es1jYAkt5xUHbE4t3r00VvuvdyFJtCaQCze
         01/aJPSc2KUXvuAq0u+3lwc4tLeeqzJosTszNOnGHgiTYxb/iwjmC3swQX/my3efSgG5
         SG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705633450; x=1706238250;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aUCXTG9uWSQReWhL7/oWYGouMSURFDuOiKy+eREFTfs=;
        b=tplX2gtb75lY31Zgt7QOpE8nPkxzyDRoMS3wOnAEvtzm2muU2/uSeZDOkNSQ5R2KfM
         vgWauUrfxdql89OFIQ+PaY2LSFUCioq7ox+sfyRpRpYGAzEPaSk4MBqSFKB9OweauYTG
         gJRR15Mt9urqvcSvMYdDlN/nndfCrF4fZkAANP5S5QrP+yDvReX8AKyiinAWD2Viw6dR
         h6EhjIGSn+HC9gweDRZqADhafRgz/Z3jg6RNa+c/MoQQfOCLkfuss4EtnVJu+QsrHitp
         Z9GVKvd/w7xFRUMnVwcw8y5E4s6W+cpv9grqnfpo//9+FJi9arz5uRlGW/1ieVrE5BX8
         OEag==
X-Gm-Message-State: AOJu0YxjhCNoKSCBmDb52SF0SC7eBKVghHgQvvet8BUbUARdWmEpCGvI
	jFAHyrN317qwZbZkNB1u3esKkSWZJEAF89ChRl+spmZIasthaLzGWTYVHeiYMb7tZorBESP/ZPU
	Qg6sxyCe9x9RkNbrGJR3iu7dtlpkkv5a5KNk=
X-Google-Smtp-Source: AGHT+IE5jt59ZnD1Sq1kgpsCp57PGnvmV03z3iCKhip3hYqUQnYMJgC8uAdefUsW+Ix+u/z4IwdL1nlu6wjCuzKwYI4=
X-Received: by 2002:a19:6447:0:b0:50e:532a:2c0d with SMTP id
 b7-20020a196447000000b0050e532a2c0dmr187818lfj.177.1705633450007; Thu, 18 Jan
 2024 19:04:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240119124715.7be9a3d7@canb.auug.org.au>
In-Reply-To: <20240119124715.7be9a3d7@canb.auug.org.au>
From: Steve French <smfrench@gmail.com>
Date: Thu, 18 Jan 2024 21:03:58 -0600
Message-ID: <CAH2r5mu4WpoDt6gw02SM1Sk0k8o3t1iw3FxZbS-ywCt2tUHJcw@mail.gmail.com>
Subject: Fwd: linux-next: build warning after merge of the cifs tree
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e8692c060f43bb0f"

--000000000000e8692c060f43bb0f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated patch attached (corrected a few other minor things in the cifs
documentation)



---------- Forwarded message ---------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, Jan 18, 2024 at 7:47=E2=80=AFPM
Subject: linux-next: build warning after merge of the cifs tree
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Steve French
<stfrench@microsoft.com>, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org>, Linux Next Mailing List
<linux-next@vger.kernel.org>


Hi all,

After merging the cifs tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/admin-guide/cifs/todo.rst:7: WARNING: Definition list
ends without a blank line; unexpected unindent.
Documentation/admin-guide/cifs/todo.rst:20: ERROR: Unexpected indentation.
Documentation/admin-guide/cifs/todo.rst:21: WARNING: Block quote ends
without a blank line; unexpected unindent.

Introduced by commit

  e7dccb219fde ("smb3: minor documentation updates")

--
Cheers,
Stephen Rothwell


--=20
Thanks,

Steve

--000000000000e8692c060f43bb0f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-minor-documentation-updates.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-minor-documentation-updates.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lrk235gp1>
X-Attachment-Id: f_lrk235gp1

RnJvbSA5ZmEwOGFmN2M5MjcxOWQxZjVlZjA3YWJmZGM2YjFkOTkxNTlmZGUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTcgSmFuIDIwMjQgMTc6NTk6NTkgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBtaW5vciBkb2N1bWVudGF0aW9uIHVwZGF0ZXMKClVwZGF0ZSB0aGUgdXNhZ2UgZG9jdW1l
bnRhdGlvbiB0byBpbmNsdWRlIHNvbWUgbWlzc2luZwpjb25maWd1cmF0aW9uIG9wdGlvbnMuICBV
cGRhdGUgdGhlIHRvZG8gbGlzdCBkb2N1bWVudGF0aW9uCmZvciBjaWZzLmtvCgpSZXZpZXdlZC1i
eTogQmhhcmF0aCBTTSA8YmhhcmF0aHNtQG1pY3Jvc29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0
ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBEb2N1bWVudGF0aW9uL2Fk
bWluLWd1aWRlL2NpZnMvdG9kby5yc3QgIHwgMzYgKysrKysrKysrKysrKy0tLS0tLS0tLS0tCiBE
b2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2NpZnMvdXNhZ2UucnN0IHwgIDggKysrKystCiAyIGZp
bGVzIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvY2lmcy90b2RvLnJzdCBiL0RvY3VtZW50YXRp
b24vYWRtaW4tZ3VpZGUvY2lmcy90b2RvLnJzdAppbmRleCAyNjQ2ZWQyZTJkM2UuLmU0NmMzNjAw
MTM5NCAxMDA2NDQKLS0tIGEvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9jaWZzL3RvZG8ucnN0
CisrKyBiL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvY2lmcy90b2RvLnJzdApAQCAtMiw3ICsy
LDggQEAKIFRPRE8KID09PT0KIAotVmVyc2lvbiAyLjE0IERlY2VtYmVyIDIxLCAyMDE4CitBcyBv
ZiA2Ljcga2VybmVsLiBTZWUgaHR0cHM6Ly93aWtpLnNhbWJhLm9yZy9pbmRleC5waHAvTGludXhD
SUZTS2VybmVsCitmb3IgbGlzdCBvZiBmZWF0dXJlcyBhZGRlZCBieSByZWxlYXNlCiAKIEEgUGFy
dGlhbCBMaXN0IG9mIE1pc3NpbmcgRmVhdHVyZXMKID09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KQEAgLTEyLDIyICsxMywyMiBAQCBmb3IgdmlzaWJsZSwgaW1wb3J0YW50IGNvbnRy
aWJ1dGlvbnMgdG8gdGhpcyBtb2R1bGUuICBIZXJlCiBpcyBhIHBhcnRpYWwgbGlzdCBvZiB0aGUg
a25vd24gcHJvYmxlbXMgYW5kIG1pc3NpbmcgZmVhdHVyZXM6CiAKIGEpIFNNQjMgKGFuZCBTTUIz
LjEuMSkgbWlzc2luZyBvcHRpb25hbCBmZWF0dXJlczoKKyAgIG11bHRpY2hhbm5lbCBwZXJmb3Jt
YW5jZSBvcHRpbWl6YXRpb25zLCBhbGdvcml0aG1pYyBjaGFubmVsIHNlbGVjdGlvbiwKKyAgIGRp
cmVjdG9yeSBsZWFzZXMgb3B0aW1pemF0aW9ucywKKyAgIHN1cHBvcnQgZm9yIGZhc3RlciBwYWNr
ZXQgc2lnbmluZyAoR01BQyksCisgICBzdXBwb3J0IGZvciBjb21wcmVzc2lvbiBvdmVyIHRoZSBu
ZXR3b3JrLAorICAgVDEwIGNvcHkgb2ZmbG9hZCBpZSAiT0RYIiAoY29weSBjaHVuaywgYW5kICJE
dXBsaWNhdGUgRXh0ZW50cyIgaW9jdGwKKyAgIGFyZSBjdXJyZW50bHkgdGhlIG9ubHkgdHdvIHNl
cnZlciBzaWRlIGNvcHkgbWVjaGFuaXNtcyBzdXBwb3J0ZWQpCiAKLSAgIC0gbXVsdGljaGFubmVs
IChwYXJ0aWFsbHkgaW50ZWdyYXRlZCksIGludGVncmF0aW9uIG9mIG11bHRpY2hhbm5lbCB3aXRo
IFJETUEKLSAgIC0gZGlyZWN0b3J5IGxlYXNlcyAoaW1wcm92ZWQgbWV0YWRhdGEgY2FjaGluZyku
IEN1cnJlbnRseSBvbmx5IGltcGxlbWVudGVkIGZvciByb290IGRpcgotICAgLSBUMTAgY29weSBv
ZmZsb2FkIGllICJPRFgiIChjb3B5IGNodW5rLCBhbmQgIkR1cGxpY2F0ZSBFeHRlbnRzIiBpb2N0
bAotICAgICBjdXJyZW50bHkgdGhlIG9ubHkgdHdvIHNlcnZlciBzaWRlIGNvcHkgbWVjaGFuaXNt
cyBzdXBwb3J0ZWQpCitiKSBCZXR0ZXIgb3B0aW1pemVkIGNvbXBvdW5kaW5nIGFuZCBlcnJvciBo
YW5kbGluZyBmb3Igc3BhcnNlIGZpbGUgc3VwcG9ydCwKKyAgIHBlcmhhcHMgYWRkaXRpb24gb2Yg
bmV3IG9wdGlvbmFsIFNNQjMuMS4xIGZzY3RscyB0byBtYWtlIGNvbGxhcHNlIHJhbmdlCisgICBh
bmQgaW5zZXJ0IHJhbmdlIG1vcmUgYXRvbWljCiAKLWIpIGltcHJvdmVkIHNwYXJzZSBmaWxlIHN1
cHBvcnQgKGZpZW1hcCBhbmQgU0VFS19IT0xFIGFyZSBpbXBsZW1lbnRlZAotICAgYnV0IGFkZGl0
aW9uYWwgZmVhdHVyZXMgd291bGQgYmUgc3VwcG9ydGFibGUgYnkgdGhlIHByb3RvY29sIHN1Y2gK
LSAgIGFzIEZBTExPQ19GTF9DT0xMQVBTRV9SQU5HRSBhbmQgRkFMTE9DX0ZMX0lOU0VSVF9SQU5H
RSkKLQotYykgRGlyZWN0b3J5IGVudHJ5IGNhY2hpbmcgcmVsaWVzIG9uIGEgMSBzZWNvbmQgdGlt
ZXIsIHJhdGhlciB0aGFuCi0gICB1c2luZyBEaXJlY3RvcnkgTGVhc2VzLCBjdXJyZW50bHkgb25s
eSB0aGUgcm9vdCBmaWxlIGhhbmRsZSBpcyBjYWNoZWQgbG9uZ2VyCi0gICBieSBsZXZlcmFnaW5n
IERpcmVjdG9yeSBMZWFzZXMKK2MpIFN1cHBvcnQgZm9yIFNNQjMuMS4xIG92ZXIgUVVJQyAoYW5k
IHBlcmhhcHMgb3RoZXIgc29ja2V0IGJhc2VkIHByb3RvY29scworICAgbGlrZSBTQ1RQKQogCiBk
KSBxdW90YSBzdXBwb3J0IChuZWVkcyBtaW5vciBrZXJuZWwgY2hhbmdlIHNpbmNlIHF1b3RhIGNh
bGxzIG90aGVyd2lzZQotICAgIHdvbid0IG1ha2UgaXQgdG8gbmV0d29yayBmaWxlc3lzdGVtcyBv
ciBkZXZpY2VsZXNzIGZpbGVzeXN0ZW1zKS4KKyAgIHdvbid0IG1ha2UgaXQgdG8gbmV0d29yayBm
aWxlc3lzdGVtcyBvciBkZXZpY2VsZXNzIGZpbGVzeXN0ZW1zKS4KIAogZSkgQWRkaXRpb25hbCB1
c2UgY2FzZXMgY2FuIGJlIG9wdGltaXplZCB0byB1c2UgImNvbXBvdW5kaW5nIiAoZS5nLgogICAg
b3Blbi9xdWVyeS9jbG9zZSBhbmQgb3Blbi9zZXRpbmZvL2Nsb3NlKSB0byByZWR1Y2UgdGhlIG51
bWJlciBvZgpAQCAtOTIsMTAgKzkzLDEzIEBAIHQpIHNwbGl0IGNpZnMgYW5kIHNtYjMgc3VwcG9y
dCBpbnRvIHNlcGFyYXRlIG1vZHVsZXMgc28gbGVnYWN5IChhbmQgbGVzcwogCiB2KSBBZGRpdGlv
bmFsIHRlc3Rpbmcgb2YgUE9TSVggRXh0ZW5zaW9ucyBmb3IgU01CMy4xLjEKIAotdykgQWRkIHN1
cHBvcnQgZm9yIGFkZGl0aW9uYWwgc3Ryb25nIGVuY3J5cHRpb24gdHlwZXMsIGFuZCBhZGRpdGlv
bmFsIHNwbmVnbwotICAgYXV0aGVudGljYXRpb24gbWVjaGFuaXNtcyAoc2VlIE1TLVNNQjIpLiAg
R0NNLTI1NiBpcyBub3cgcGFydGlhbGx5IGltcGxlbWVudGVkLgordykgU3VwcG9ydCBmb3IgdGhl
IE1hYyBTTUIzLjEuMSBleHRlbnNpb25zIHRvIGltcHJvdmUgaW50ZXJvcCB3aXRoIEFwcGxlIHNl
cnZlcnMKKworeCkgU3VwcG9ydCBmb3IgYWRkaXRpb25hbCBhdXRoZW50aWNhdGlvbiBvcHRpb25z
IChlLmcuIElBS0VSQiwgcGVlci10by1wZWVyCisgICBLZXJiZXJvcywgU0NSQU0gYW5kIG90aGVy
cyBzdXBwb3J0ZWQgYnkgZXhpc3Rpbmcgc2VydmVycykKIAoteCkgRmluaXNoIHN1cHBvcnQgZm9y
IFNNQjMuMS4xIGNvbXByZXNzaW9uCit5KSBJbXByb3ZlZCB0cmFjaW5nLCBtb3JlIGVCUEYgdHJh
Y2UgcG9pbnRzLCBiZXR0ZXIgc2NyaXB0cyBmb3IgcGVyZm9ybWFuY2UKKyAgIGFuYWx5c2lzCiAK
IEtub3duIEJ1Z3MKID09PT09PT09PT0KZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vYWRtaW4t
Z3VpZGUvY2lmcy91c2FnZS5yc3QgYi9Eb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2NpZnMvdXNh
Z2UucnN0CmluZGV4IDVmOTM2YjRiNjAxOC4uYWE4MjkwYTI5ZGM4IDEwMDY0NAotLS0gYS9Eb2N1
bWVudGF0aW9uL2FkbWluLWd1aWRlL2NpZnMvdXNhZ2UucnN0CisrKyBiL0RvY3VtZW50YXRpb24v
YWRtaW4tZ3VpZGUvY2lmcy91c2FnZS5yc3QKQEAgLTgxLDcgKzgxLDcgQEAgbXVjaCBvbGRlciBh
bmQgbGVzcyBzZWN1cmUgdGhhbiB0aGUgZGVmYXVsdCBkaWFsZWN0IFNNQjMgd2hpY2ggaW5jbHVk
ZXMKIG1hbnkgYWR2YW5jZWQgc2VjdXJpdHkgZmVhdHVyZXMgc3VjaCBhcyBkb3duZ3JhZGUgYXR0
YWNrIGRldGVjdGlvbgogYW5kIGVuY3J5cHRlZCBzaGFyZXMgYW5kIHN0cm9uZ2VyIHNpZ25pbmcg
YW5kIGF1dGhlbnRpY2F0aW9uIGFsZ29yaXRobXMuCiBUaGVyZSBhcmUgYWRkaXRpb25hbCBtb3Vu
dCBvcHRpb25zIHRoYXQgbWF5IGJlIGhlbHBmdWwgZm9yIFNNQjMgdG8gZ2V0Ci1pbXByb3ZlZCBQ
T1NJWCBiZWhhdmlvciAoTkI6IGNhbiB1c2UgdmVycz0zLjAgdG8gZm9yY2Ugb25seSBTTUIzLCBu
ZXZlciAyLjEpOgoraW1wcm92ZWQgUE9TSVggYmVoYXZpb3IgKE5COiBjYW4gdXNlIHZlcnM9MyB0
byBmb3JjZSBTTUIzIG9yIGxhdGVyLCBuZXZlciAyLjEpOgogCiAgICBgYG1mc3ltbGlua3NgYCBh
bmQgZWl0aGVyIGBgY2lmc2FjbGBgIG9yIGBgbW9kZWZyb21zaWRgYCAodXN1YWxseSB3aXRoIGBg
aWRzZnJvbXNpZGBgKQogCkBAIC03MTUsNiArNzE1LDcgQEAgRGVidWdEYXRhCQlEaXNwbGF5cyBp
bmZvcm1hdGlvbiBhYm91dCBhY3RpdmUgQ0lGUyBzZXNzaW9ucyBhbmQKIFN0YXRzCQkJTGlzdHMg
c3VtbWFyeSByZXNvdXJjZSB1c2FnZSBpbmZvcm1hdGlvbiBhcyB3ZWxsIGFzIHBlcgogCQkJc2hh
cmUgc3RhdGlzdGljcy4KIG9wZW5fZmlsZXMJCUxpc3QgYWxsIHRoZSBvcGVuIGZpbGUgaGFuZGxl
cyBvbiBhbGwgYWN0aXZlIFNNQiBzZXNzaW9ucy4KK21vdW50X3BhcmFtcyAgICAgICAgICAgIExp
c3Qgb2YgYWxsIG1vdW50IHBhcmFtZXRlcnMgYXZhaWxhYmxlIGZvciB0aGUgbW9kdWxlCiA9PT09
PT09PT09PT09PT09PT09PT09PSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09CiAKIENvbmZpZ3VyYXRpb24gcHNldWRvLWZpbGVzOgpAQCAtODY0
LDYgKzg2NSwxMSBAQCBpLmUuOjoKIAogICAgIGVjaG8gInZhbHVlIiA+IC9zeXMvbW9kdWxlL2Np
ZnMvcGFyYW1ldGVycy88cGFyYW0+CiAKK01vcmUgZGV0YWlsZWQgZGVzY3JpcHRpb25zIG9mIHRo
ZSBhdmFpbGFibGUgbW9kdWxlIHBhcmFtZXRlcnMgYW5kIHRoZWlyIHZhbHVlcworY2FuIGJlIHNl
ZW4gYnkgZG9pbmc6CisKKyAgICBtb2RpbmZvIGNpZnMgKG9yIG1vZGluZm8gc21iMykKKwogPT09
PT09PT09PT09PT09PT0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQogMS4gZW5hYmxlX29wbG9ja3MgRW5hYmxlIG9yIGRpc2FibGUgb3Bs
b2Nrcy4gT3Bsb2NrcyBhcmUgZW5hYmxlZCBieSBkZWZhdWx0LgogCQkgIFtZL3kvMV0uIFRvIGRp
c2FibGUgdXNlIGFueSBvZiBbTi9uLzBdLgotLSAKMi40MC4xCgo=
--000000000000e8692c060f43bb0f--
