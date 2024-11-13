Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C11920262C
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 12:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731500421; cv=none; b=WuB0Wql6H8ZsP57dkLy1ENVq6TnJdA9Fozp5kCqRDEkSzYYhZ9PwcqJ+IW9t0yyARAFFFjy8rlTxxi/j4TF6h9W+JSEJRZM+P0zRIJ7usEsiQeRbmpyMxo5Xl8FRvSdDakT43GR09ihOe8NN7toO6cHaRBTzR76Km7RqncD3kSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731500421; c=relaxed/simple;
	bh=x/laFq5htPlxXsMwylN3tfpQ+jagiN6dfZ1Zif1QC98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qr01hyj+EtTfWXPfh1nKMwoBssTtbj/dA1hxLawQyekD0co8T7nliUm1BHW7gAcWjUOkgjEBryAtnWh04cN772IgIWxtBFcRezk3NZ8rNg1FXqAY9ooutuRK6WvaKV0Tb79eB9r7yz+/RT5H2mHQCXe+pz23fTCnE6eWkalmEEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kaGMCUFy; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kaGMCUFy"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53da3b911b9so63746e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 04:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731500417; x=1732105217; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mg70hrGJJ2p56H6q0+T+SXgoY+r6pwhuQlcVJhF4O5Y=;
        b=kaGMCUFyFCYxjaCGR2GjaWNI9u9r4bnYR79ZOo6RRYXDiu1AYmR+caN7eEcOIahQSY
         ZJe9zorxI6yf+ALg+P8HiIflTU0FLBqY/3JNvzdAkwPjd4Th70XXw0340miX0UX4NY1t
         BigfHt1LjhkgoPXyQmBz31vq1a7Ef77NF5ypxgQA+Vd3nUHHVumNq4W0ZQsWm3/N66Cv
         CyBR0HEuEokPTuMgzXApIArGtteVxLXf0Gz4Lj4POEOIFr08ohrxEacuXTEa0jqfSYD7
         LOabFLr8KJ2Y9tbOlK8o1cOJ6I1UFW9CHNWnEwE8Y3Sul98DfTV0jN4H6GBIPLYSr+Oa
         J0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731500417; x=1732105217;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mg70hrGJJ2p56H6q0+T+SXgoY+r6pwhuQlcVJhF4O5Y=;
        b=YefL/DoTp0xi+74NTcFizaxY0la5NN+hTcPdUw8IRk2k23sFYwQVKLAyOrp4v9L+HN
         wNqcvYS6ZUxw8pMeQ2B7EErA5lhEZGVGNV0JxQKNRITihfcx0821ZSD52VC74XzjQP0v
         ac93sztZTNjjeJw8Ff1LuLUHOJd+TGShhnkO4MZsx/FVnPleVba2d3ZVIfSOZEe8pldf
         3H834etrciFH/DRjcjftNRGTtxnEaIKlSkDbkGXc6pJcwAmmUhfvp34/HhzQAhzBYQVm
         Ct4k6dSCCZcrPD4fNNripRLlwfWWtT/JkzYq1AfCpHM2YRMsqTAGcOEVPmfvLte2y4rB
         U0jw==
X-Forwarded-Encrypted: i=1; AJvYcCVqiZk61xC0TsxvjlpqzOx9OOkVfbtf2cjO/e7mKBh8pDttH5aOzojYokxvMkNAj5tCLyYHGQbct/P+@vger.kernel.org
X-Gm-Message-State: AOJu0YwdqKBTDtiYpSaRVSNPRum6Uj1gNGRW5IlItMQ6iSkl369Qy2uM
	CWBT4zCNUxLnOAeRnaz1n3iPx9mYB6WbXyuQBXpQdx2YRBL1StVfEgufq9cwrg7hxOWR5vOw8HO
	Ah9P5bpOZGDGIedu/n0Y15BB0mmA=
X-Google-Smtp-Source: AGHT+IHbMDL8YxsNULoburABNqDXMZ5dj19hsaY+ZAHmMT9Q1QaO3APd6pveoRCzNDdxphfq8em/dzTfxeD4dXYegGQ=
X-Received: by 2002:a2e:bc84:0:b0:2fb:4abb:7001 with SMTP id
 38308e7fff4ca-2ff4c597724mr17845791fa.2.1731500416999; Wed, 13 Nov 2024
 04:20:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
 <1f8a225b0d16fdfa05c417e0f6602489@manguebit.com> <CANT5p=rm90eHDeA669yRNdKvT=GL+NE1PVTJVS-htQ8pbfiwUA@mail.gmail.com>
 <CANT5p=pFCbi1H-JzRLx5XqL4Qwy-YbOWAX6XmoWXezSn2i__mQ@mail.gmail.com>
 <b8164b0a49ad6d4cd60142fa55ad3566@manguebit.com> <CAFTVevVGMfkgsr31nN35-p+2nQZEXhHK8hPPF1EhfLmdtKdw+A@mail.gmail.com>
 <CAFTVevVa81C3u5Wdc+egz8ZbSrNKF7uy6m=6Nd5YnKfeMfo1sA@mail.gmail.com> <CAFTVevWUNFJg0S_XtJmGx+1v0FPYnxkdYDED_NvR8V5cRWHhDQ@mail.gmail.com>
In-Reply-To: <CAFTVevWUNFJg0S_XtJmGx+1v0FPYnxkdYDED_NvR8V5cRWHhDQ@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Wed, 13 Nov 2024 17:50:04 +0530
Message-ID: <CAFTVevWjXX9egtYK-7St6+O_W40GQRxhGe3A7hOarHCxmsjhLQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: during remount, make sure passwords are in sync
To: Paulo Alcantara <pc@manguebit.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, smfrench@gmail.com, sfrench@samba.org, 
	sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org, 
	bharathsm.hsk@gmail.com, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000004954c00626ca5bda"

--0000000000004954c00626ca5bda
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The last patch needed some revision, please ignore it. Here is the
updated version:
Apologies for the confusion.

On Wed, Nov 13, 2024 at 5:18=E2=80=AFPM Meetakshi Setiya
<meetakshisetiyaoss@gmail.com> wrote:
>
> Thanks for the review, Paulo. I have attached the updated patch.
> I will send the password rotation changes for DFS, SMB1 (and multiuser) l=
ater,
> separately.
>
> Best
> Meetakshi
>
> On Wed, Nov 13, 2024 at 3:30=E2=80=AFPM Meetakshi Setiya
> <meetakshisetiyaoss@gmail.com> wrote:
> >
> > Typo: password rotation for SMB1.0 is NOT supported for reconnects. It =
works for fresh
> > mounts and remounts.
> > Should I add support for reconnect or remove it completely?
> >
> > On Wed, Nov 13, 2024 at 3:20=E2=80=AFPM Meetakshi Setiya <meetakshiseti=
yaoss@gmail.com> wrote:
> >>
> >> Hi Paulo,
> >>
> >> Given your and Shyam's comments, I am thinking of making the
> >> following changes to the code to support password rotation for DFS:
> >>
> >> 1. For a fresh mount:
> >>     - In cifs_do_automount, bring the passwords in fs_context in sync =
with
> >>     the passwords in the session object before sending the context to =
the
> >>     child/submount.
> >>
> >> 2. For a remount (of the root only):
> >>     - In smb3_reconfigure, bring the passwords in the fs_context of th=
e master
> >>     tcon in sync with its session object passwords. After this is done=
, a new
> >>     function will be called to iterate over the dfs_ses_list held in t=
his tcon
> >>     and sync their session passwords with the updated root session pas=
sword
> >>     and password2.
> >>
> >> Password rotation for multiuser mounts is out of scope for this patch =
and I will
> >> address it later.
> >>
> >> Please let me know if you have any comments or suggestions on this app=
roach.
> >>
> >> Also, we share the mount code path (cifs_mount) for all SMB versions. =
So, password
> >> rotation for SMB1.0 is currently supported ONLY on mounts. Password ro=
tation on
> >> remount, however, is not. Should I remove the support completely for S=
MB1.0
> >> (print a warning message), leave it be, or add remount support?
> >
> >
> > reconnect, not remount.
> >
> >>
> >> Thanks
> >> Meetakshi
> >>
> >> On Mon, Nov 11, 2024 at 5:34=E2=80=AFPM Paulo Alcantara <pc@manguebit.=
com> wrote:
> >>>
> >>> Shyam Prasad N <nspmangalore@gmail.com> writes:
> >>>
> >>> > On Fri, Nov 8, 2024 at 5:47=E2=80=AFPM Shyam Prasad N <nspmangalore=
@gmail.com> wrote:
> >>> >> > What about SMB sessions from cifs_tcon::dfs_ses_list?  I don't s=
ee their
> >>> >> > password getting updated over remount.
> >>> >>
> >>> >> This is in our to-do list as well.
> >>> >
> >>> > I did some code reading around how DFS automount works.
> >>> > @Paulo Alcantara Correct me if I'm wrong, but it sounds like we mak=
e
> >>> > an assumption that when a DFS namespace has a junction to another
> >>> > share, the same credentials are to be used to perform the mount of
> >>> > that share. Is that always the case?
> >>>
> >>> Yes, it inherits fs_context from the parent mount.  For multiuser
> >>> mounts, when uid/gid/cruid are unspecified, we need to update its val=
ues
> >>> to match real uid/gid from the calling process.
> >>>
> >>> > If we go by that assumption, for password2 to work with DFS mounts,=
 we
> >>> > only need to make sure that in cifs_do_automount, cur_ctx passwords
> >>> > are synced up to the current ses passwords. That should be quite ea=
sy.
> >>>
> >>> Correct.  The fs_context for the automount is dup'ed from the parent
> >>> mount.  smb3_fs_context_dup() already dups password2, so it should wo=
rk.
> >>>
> >>> The 'remount' case isn't still handled, that's why I mentioned it abo=
ve.
> >>> You'd need to set password2 for all sessios in @tcon->dfs_ses_list.
> >>>
> >>> I think we need to update password2 for the multiuser sessions as wel=
l
> >>> and not only for session from master tcon.

--0000000000004954c00626ca5bda
Content-Type: application/octet-stream; 
	name="0001-cifs-during-remount-make-sure-passwords-are-in-sync.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-during-remount-make-sure-passwords-are-in-sync.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3fukm7c0>
X-Attachment-Id: f_m3fukm7c0

RnJvbSBlNzhjY2U5NjQ1NzIxZWIyYjA2MTY5MjJjMzM1MzM2NzMzNGQzZmIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDMwIE9jdCAyMDI0IDA2OjQ1OjUwICswMDAwClN1YmplY3Q6IFtQQVRDSCAx
LzJdIGNpZnM6IGR1cmluZyByZW1vdW50LCBtYWtlIHN1cmUgcGFzc3dvcmRzIGFyZSBpbiBzeW5j
CgpXZSByZWNlbnRseSBpbnRyb2R1Y2VkIGEgcGFzc3dvcmQyIGZpZWxkIGluIGJvdGggc2VzIGFu
ZCBjdHggc3RydWN0cy4KVGhpcyB3YXMgZG9uZSBzbyBhcyB0byBhbGxvdyB0aGUgY2xpZW50IHRv
IHJvdGF0ZSBwYXNzd29yZHMgZm9yIGEgbW91bnQKd2l0aG91dCBhbnkgZG93bnRpbWUuIEhvd2V2
ZXIsIHdoZW4gdGhlIGNsaWVudCB0cmFuc3BhcmVudGx5IGhhbmRsZXMKcGFzc3dvcmQgcm90YXRp
b24sIGl0IGNhbiBzd2FwIHRoZSB2YWx1ZXMgb2YgdGhlIHR3byBwYXNzd29yZCBmaWVsZHMKaW4g
dGhlIHNlcyBzdHJ1Y3QsIGJ1dCBub3QgaW4gc21iM19mc19jb250ZXh0IHN0cnVjdCB0aGF0IGhh
bmdzIG9mZgpjaWZzX3NiLiBUaGlzIGNhbiBsZWFkIHRvIGEgc2l0dWF0aW9uIHdoZXJlIGEgcmVt
b3VudCB1bmludGVudGlvbmFsbHkKb3ZlcndyaXRlcyBhIHdvcmtpbmcgcGFzc3dvcmQgaW4gdGhl
IHNlcyBzdHJ1Y3QuCgpJbiBvcmRlciB0byBmaXggdGhpcywgd2UgZmlyc3QgZ2V0IHRoZSBwYXNz
d29yZHMgaW4gY3R4IHN0cnVjdAppbi1zeW5jIHdpdGggc2VzIHN0cnVjdCwgYmVmb3JlIHJlcGxh
Y2luZyB0aGVtIHdpdGggd2hhdCB0aGUgcGFzc3dvcmRzCnRoYXQgY291bGQgYmUgcGFzc2VkIGFz
IGEgcGFydCBvZiByZW1vdW50LgoKQWxzbywgaW4gb3JkZXIgdG8gYXZvaWQgcmFjZSBjb25kaXRp
b24gYmV0d2VlbiBzbWIyX3JlY29ubmVjdCBhbmQKc21iM19yZWNvbmZpZ3VyZSwgd2UgbWFrZSBz
dXJlIHRvIGxvY2sgc2Vzc2lvbl9tdXRleCBiZWZvcmUgY2hhbmdpbmcKcGFzc3dvcmQgYW5kIHBh
c3N3b3JkMiBmaWVsZHMgb2YgdGhlIHNlcyBzdHJ1Y3R1cmUuCgpGaXhlczogMzVmODM0MjY1ZTBk
ICgic21iMzogZml4IGJyb2tlbiByZWNvbm5lY3Qgd2hlbiBwYXNzd29yZCBjaGFuZ2luZyBvbiB0
aGUgc2VydmVyIGJ5IGFsbG93aW5nIHBhc3N3b3JkIHJvdGF0aW9uIikKU2lnbmVkLW9mZi1ieTog
U2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogTWVl
dGFrc2hpIFNldGl5YSA8bXNldGl5YUBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQv
ZnNfY29udGV4dC5jIHwgODMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0K
IGZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5oIHwgIDEgKwogMiBmaWxlcyBjaGFuZ2VkLCA3NSBp
bnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQv
ZnNfY29udGV4dC5jIGIvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMKaW5kZXggNWM1YTUyMDE5
ZWZhLi4xYTU4NDJjZWQ0ODkgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5j
CisrKyBiL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jCkBAIC04OTAsMTIgKzg5MCwzNyBAQCBk
byB7CQkJCQkJCQkJXAogCWNpZnNfc2ItPmN0eC0+ZmllbGQgPSBOVUxMOwkJCQkJXAogfSB3aGls
ZSAoMCkKIAoraW50IHNtYjNfc3luY19zZXNzaW9uX2N0eF9wYXNzd29yZHMoc3RydWN0IGNpZnNf
c2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNpZnNfc2VzICpzZXMpCit7CisJaWYgKHNlcy0+cGFz
c3dvcmQgJiYKKwkgICAgY2lmc19zYi0+Y3R4LT5wYXNzd29yZCAmJgorCSAgICBzdHJjbXAoc2Vz
LT5wYXNzd29yZCwgY2lmc19zYi0+Y3R4LT5wYXNzd29yZCkpIHsKKwkJa2ZyZWVfc2Vuc2l0aXZl
KGNpZnNfc2ItPmN0eC0+cGFzc3dvcmQpOworCQljaWZzX3NiLT5jdHgtPnBhc3N3b3JkID0ga3N0
cmR1cChzZXMtPnBhc3N3b3JkLCBHRlBfS0VSTkVMKTsKKwkJaWYgKCFjaWZzX3NiLT5jdHgtPnBh
c3N3b3JkKQorCQkJcmV0dXJuIC1FTk9NRU07CisJfQorCWlmIChzZXMtPnBhc3N3b3JkMiAmJgor
CSAgICBjaWZzX3NiLT5jdHgtPnBhc3N3b3JkMiAmJgorCSAgICBzdHJjbXAoc2VzLT5wYXNzd29y
ZDIsIGNpZnNfc2ItPmN0eC0+cGFzc3dvcmQyKSkgeworCQlrZnJlZV9zZW5zaXRpdmUoY2lmc19z
Yi0+Y3R4LT5wYXNzd29yZDIpOworCQljaWZzX3NiLT5jdHgtPnBhc3N3b3JkMiA9IGtzdHJkdXAo
c2VzLT5wYXNzd29yZDIsIEdGUF9LRVJORUwpOworCQlpZiAoIWNpZnNfc2ItPmN0eC0+cGFzc3dv
cmQyKSB7CisJCQlrZnJlZV9zZW5zaXRpdmUoY2lmc19zYi0+Y3R4LT5wYXNzd29yZCk7CisJCQlj
aWZzX3NiLT5jdHgtPnBhc3N3b3JkID0gTlVMTDsKKwkJCXJldHVybiAtRU5PTUVNOworCQl9CisJ
fQorCXJldHVybiAwOworfQorCiBzdGF0aWMgaW50IHNtYjNfcmVjb25maWd1cmUoc3RydWN0IGZz
X2NvbnRleHQgKmZjKQogewogCXN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCA9IHNtYjNfZmMy
Y29udGV4dChmYyk7CiAJc3RydWN0IGRlbnRyeSAqcm9vdCA9IGZjLT5yb290OwogCXN0cnVjdCBj
aWZzX3NiX2luZm8gKmNpZnNfc2IgPSBDSUZTX1NCKHJvb3QtPmRfc2IpOwogCXN0cnVjdCBjaWZz
X3NlcyAqc2VzID0gY2lmc19zYl9tYXN0ZXJfdGNvbihjaWZzX3NiKS0+c2VzOworCWNoYXIgKm5l
d19wYXNzd29yZCA9IE5VTEwsICpuZXdfcGFzc3dvcmQyID0gTlVMTDsKIAlib29sIG5lZWRfcmVj
b24gPSBmYWxzZTsKIAlpbnQgcmM7CiAKQEAgLTkxNSwyMSArOTQwLDYxIEBAIHN0YXRpYyBpbnQg
c21iM19yZWNvbmZpZ3VyZShzdHJ1Y3QgZnNfY29udGV4dCAqZmMpCiAJU1RFQUxfU1RSSU5HKGNp
ZnNfc2IsIGN0eCwgVU5DKTsKIAlTVEVBTF9TVFJJTkcoY2lmc19zYiwgY3R4LCBzb3VyY2UpOwog
CVNURUFMX1NUUklORyhjaWZzX3NiLCBjdHgsIHVzZXJuYW1lKTsKKwogCWlmIChuZWVkX3JlY29u
ID09IGZhbHNlKQogCQlTVEVBTF9TVFJJTkdfU0VOU0lUSVZFKGNpZnNfc2IsIGN0eCwgcGFzc3dv
cmQpOwogCWVsc2UgIHsKLQkJa2ZyZWVfc2Vuc2l0aXZlKHNlcy0+cGFzc3dvcmQpOwotCQlzZXMt
PnBhc3N3b3JkID0ga3N0cmR1cChjdHgtPnBhc3N3b3JkLCBHRlBfS0VSTkVMKTsKLQkJaWYgKCFz
ZXMtPnBhc3N3b3JkKQotCQkJcmV0dXJuIC1FTk9NRU07Ci0JCWtmcmVlX3NlbnNpdGl2ZShzZXMt
PnBhc3N3b3JkMik7Ci0JCXNlcy0+cGFzc3dvcmQyID0ga3N0cmR1cChjdHgtPnBhc3N3b3JkMiwg
R0ZQX0tFUk5FTCk7Ci0JCWlmICghc2VzLT5wYXNzd29yZDIpIHsKLQkJCWtmcmVlX3NlbnNpdGl2
ZShzZXMtPnBhc3N3b3JkKTsKLQkJCXNlcy0+cGFzc3dvcmQgPSBOVUxMOworCQlpZiAoY3R4LT5w
YXNzd29yZCkgeworCQkJbmV3X3Bhc3N3b3JkID0ga3N0cmR1cChjdHgtPnBhc3N3b3JkLCBHRlBf
S0VSTkVMKTsKKwkJCWlmICghbmV3X3Bhc3N3b3JkKQorCQkJCXJldHVybiAtRU5PTUVNOworCQl9
IGVsc2UKKwkJCVNURUFMX1NUUklOR19TRU5TSVRJVkUoY2lmc19zYiwgY3R4LCBwYXNzd29yZCk7
CisJfQorCisJLyoKKwkgKiBpZiBhIG5ldyBwYXNzd29yZDIgaGFzIGJlZW4gc3BlY2lmaWVkLCB0
aGVuIHJlc2V0IGl0J3MgdmFsdWUKKwkgKiBpbnNpZGUgdGhlIHNlcyBzdHJ1Y3QKKwkgKi8KKwlp
ZiAoY3R4LT5wYXNzd29yZDIpIHsKKwkJbmV3X3Bhc3N3b3JkMiA9IGtzdHJkdXAoY3R4LT5wYXNz
d29yZDIsIEdGUF9LRVJORUwpOworCQlpZiAoIW5ld19wYXNzd29yZDIpIHsKKwkJCWtmcmVlX3Nl
bnNpdGl2ZShuZXdfcGFzc3dvcmQpOwogCQkJcmV0dXJuIC1FTk9NRU07CiAJCX0KKwl9IGVsc2UK
KwkJU1RFQUxfU1RSSU5HX1NFTlNJVElWRShjaWZzX3NiLCBjdHgsIHBhc3N3b3JkMik7CisKKwkv
KgorCSAqIHdlIG1heSB1cGRhdGUgdGhlIHBhc3N3b3JkcyBpbiB0aGUgc2VzIHN0cnVjdCBiZWxv
dy4gTWFrZSBzdXJlIHdlIGRvCisJICogbm90IHJhY2Ugd2l0aCBzbWIyX3JlY29ubmVjdAorCSAq
LworCW11dGV4X2xvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CisKKwkvKgorCSAqIHNtYjJfcmVj
b25uZWN0IG1heSBzd2FwIHBhc3N3b3JkIGFuZCBwYXNzd29yZDIgaW4gY2FzZSBzZXNzaW9uIHNl
dHVwCisJICogZmFpbGVkLiBGaXJzdCBnZXQgY3R4IHBhc3N3b3JkcyBpbiBzeW5jIHdpdGggc2Vz
IHBhc3N3b3Jkcy4gSXQgc2hvdWxkCisJICogYmUgb2theSB0byBkbyB0aGlzIGV2ZW4gaWYgdGhp
cyBmdW5jdGlvbiB3ZXJlIHRvIHJldHVybiBhbiBlcnJvciBhdCBhCisJICogbGF0ZXIgc3RhZ2UK
KwkgKi8KKwlyYyA9IHNtYjNfc3luY19zZXNzaW9uX2N0eF9wYXNzd29yZHMoY2lmc19zYiwgc2Vz
KTsKKwlpZiAocmMpCisJCXJldHVybiByYzsKKworCS8qCisJICogbm93IHRoYXQgYWxsb2NhdGlv
bnMgZm9yIHBhc3N3b3JkcyBhcmUgZG9uZSwgY29tbWl0IHRoZW0KKwkgKi8KKwlpZiAobmV3X3Bh
c3N3b3JkKSB7CisJCWtmcmVlX3NlbnNpdGl2ZShzZXMtPnBhc3N3b3JkKTsKKwkJc2VzLT5wYXNz
d29yZCA9IG5ld19wYXNzd29yZDsKIAl9CisJaWYgKG5ld19wYXNzd29yZDIpIHsKKwkJa2ZyZWVf
c2Vuc2l0aXZlKHNlcy0+cGFzc3dvcmQyKTsKKwkJc2VzLT5wYXNzd29yZDIgPSBuZXdfcGFzc3dv
cmQyOworCX0KKworCW11dGV4X3VubG9jaygmc2VzLT5zZXNzaW9uX211dGV4KTsKKwogCVNURUFM
X1NUUklORyhjaWZzX3NiLCBjdHgsIGRvbWFpbm5hbWUpOwogCVNURUFMX1NUUklORyhjaWZzX3Ni
LCBjdHgsIG5vZGVuYW1lKTsKIAlTVEVBTF9TVFJJTkcoY2lmc19zYiwgY3R4LCBpb2NoYXJzZXQp
OwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmggYi9mcy9zbWIvY2xpZW50
L2ZzX2NvbnRleHQuaAppbmRleCA4OTBkNmQ5ZDRhNTkuLmM4YzhiNDQ1MWIzYiAxMDA2NDQKLS0t
IGEvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmgKKysrIGIvZnMvc21iL2NsaWVudC9mc19jb250
ZXh0LmgKQEAgLTI5OSw2ICsyOTksNyBAQCBzdGF0aWMgaW5saW5lIHN0cnVjdCBzbWIzX2ZzX2Nv
bnRleHQgKnNtYjNfZmMyY29udGV4dChjb25zdCBzdHJ1Y3QgZnNfY29udGV4dCAqZgogfQogCiBl
eHRlcm4gaW50IHNtYjNfZnNfY29udGV4dF9kdXAoc3RydWN0IHNtYjNfZnNfY29udGV4dCAqbmV3
X2N0eCwgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4KTsKK2V4dGVybiBpbnQgc21iM19zeW5j
X3Nlc3Npb25fY3R4X3Bhc3N3b3JkcyhzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLCBzdHJ1
Y3QgY2lmc19zZXMgKnNlcyk7CiBleHRlcm4gdm9pZCBzbWIzX3VwZGF0ZV9tbnRfZmxhZ3Moc3Ry
dWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYik7CiAKIC8qCi0tIAoyLjQ2LjAuNDYuZzQwNmYzMjZk
MjcKCg==
--0000000000004954c00626ca5bda--
