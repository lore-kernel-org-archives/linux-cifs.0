Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCCA2003DF
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 11:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498496; cv=none; b=gtz/58RgMSBrZ+17aY3WkrkHXNbK8/SnXc4mcteplH5tFpueAcDchiPnnXcd5l/p2Q1eFYg+dX/H36CFJDWjV2B64Y+PhMSC8JPtFXqTwemWfR5+CafFBXoDqBY3xIIPZk5Wg/ymfrjJSDlGEwePp84qLvJf66h/OZBuHAh6kVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498496; c=relaxed/simple;
	bh=spbpJNivx4N5/MtMhq5jTHND/nOpCzU1jm7Ihk6f7PU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NYOwRlpIEhmF7AUYlkanXOttq1sRdiORCFQ8Wa7jEFK4hDlY1YFdqWR4fxJYfo5R20Tb2YDT/aGLgWTHmags8MjcHKoVMWe+K+rJNTGCaxQgNlzUt3El0Y7GbYr3HmjPn5OliajPz2iMEYP5LMuKTlU6i4lAqgl7iTIVmWTEt4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C3DZ9Wx9; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C3DZ9Wx9"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5ceb03aaddeso8044353a12.2
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 03:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731498493; x=1732103293; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9vMqdfLSVxOND9dPev47/U5o//iZ47Aeg6YEl/9pwRg=;
        b=C3DZ9Wx9D++chniPWfk1Xaet1+l7mf6E+oKw67bOqSMjpiwizh0YHsGJP62+iiXkCu
         49MzbU1b+ZLxz4lnComP2RHXjba7MSvdK5LtRB4vkvV9l+vyEt+0FigBZKsQq//MT42W
         qkJFa/sSUu/I6METgg26iKvNKrcU38xmT5SY1yuv713eTeTFPU2RQmQuu47YLPgSILzL
         SXqW6I/NADn2lmZdWSHpa1C9xR+ycjZCT8yRvQbbicT8aSyBCHCx66cptRD500QxEkGp
         7bYVFQaEYpkGBrdAnwTBFSJuIIenJDm4wzQWD5VB+rLEMnWX8827QkQx910TErXhSZue
         rcXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731498493; x=1732103293;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9vMqdfLSVxOND9dPev47/U5o//iZ47Aeg6YEl/9pwRg=;
        b=n50WEwYbwfmuoG6ws7mDHU14PLeY8QyU0GsgLcWDtqixXgbWqnGtFDKMg8EaLpMEzi
         SE6iiOz8sHT2LRNENO/JzVBcEBOuq/mZyRdmpsQhYVpf/5PlQIQZGNEuwWFZmm7TLiqN
         8KdC2GqbMxG7IJaWz4zz5YFLN8v+GocNhuvG1eIKkCPe71/f+1dTadj4bdhuoASJ8yAg
         LLzaUEDn8Lfa37hqTUoYr+MVAe17RGTu1q716FvgP0OwN9ezlrah3mGIG3yGy0Pew+jB
         TkZTZaQRlRi03Kbv0j9JgqfE+ONwYjd7+zybZg479mVPdim4oUETAeCF2irVPF6Bx1Q0
         XKCg==
X-Forwarded-Encrypted: i=1; AJvYcCXLQc0mWKVhkPSy0L8EHrteXDVZwY1pk+fdipwcy60X68G3zJdLrKFaa/PgY8+NXJKTapVKXsDn4dhg@vger.kernel.org
X-Gm-Message-State: AOJu0YzpMT9RgFdzYlBLlNcvxSWbJ/cISijb5TjENtvZKqPVsNELKk1E
	jzXG9OD+YGeuQp5d0vAqWYN+9LkqaT/vHyHW/fe1a8lAViV/L9xEP9OAh3zLxK2hFMisf6elDeA
	daKQ0sSfYgGZlI9YCqyKkkuLXGbgyVw==
X-Google-Smtp-Source: AGHT+IHdke5cjJounr4vv/AITbK85cGLbkXput4n4TFdVu8TTNmJrhA9WJu5jst2/qtOX0KBfvsjM8LIhepOgQvxgF0=
X-Received: by 2002:a05:6402:350f:b0:5cf:451e:a5bb with SMTP id
 4fb4d7f45d1cf-5cf451ea6b7mr8057511a12.13.1731498492776; Wed, 13 Nov 2024
 03:48:12 -0800 (PST)
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
 <CAFTVevVa81C3u5Wdc+egz8ZbSrNKF7uy6m=6Nd5YnKfeMfo1sA@mail.gmail.com>
In-Reply-To: <CAFTVevVa81C3u5Wdc+egz8ZbSrNKF7uy6m=6Nd5YnKfeMfo1sA@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Wed, 13 Nov 2024 17:18:00 +0530
Message-ID: <CAFTVevWUNFJg0S_XtJmGx+1v0FPYnxkdYDED_NvR8V5cRWHhDQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: during remount, make sure passwords are in sync
To: Paulo Alcantara <pc@manguebit.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, smfrench@gmail.com, sfrench@samba.org, 
	sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org, 
	bharathsm.hsk@gmail.com, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000009779050626c9e8fc"

--0000000000009779050626c9e8fc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review, Paulo. I have attached the updated patch.
I will send the password rotation changes for DFS, SMB1 (and multiuser) lat=
er,
separately.

Best
Meetakshi

On Wed, Nov 13, 2024 at 3:30=E2=80=AFPM Meetakshi Setiya
<meetakshisetiyaoss@gmail.com> wrote:
>
> Typo: password rotation for SMB1.0 is NOT supported for reconnects. It wo=
rks for fresh
> mounts and remounts.
> Should I add support for reconnect or remove it completely?
>
> On Wed, Nov 13, 2024 at 3:20=E2=80=AFPM Meetakshi Setiya <meetakshisetiya=
oss@gmail.com> wrote:
>>
>> Hi Paulo,
>>
>> Given your and Shyam's comments, I am thinking of making the
>> following changes to the code to support password rotation for DFS:
>>
>> 1. For a fresh mount:
>>     - In cifs_do_automount, bring the passwords in fs_context in sync wi=
th
>>     the passwords in the session object before sending the context to th=
e
>>     child/submount.
>>
>> 2. For a remount (of the root only):
>>     - In smb3_reconfigure, bring the passwords in the fs_context of the =
master
>>     tcon in sync with its session object passwords. After this is done, =
a new
>>     function will be called to iterate over the dfs_ses_list held in thi=
s tcon
>>     and sync their session passwords with the updated root session passw=
ord
>>     and password2.
>>
>> Password rotation for multiuser mounts is out of scope for this patch an=
d I will
>> address it later.
>>
>> Please let me know if you have any comments or suggestions on this appro=
ach.
>>
>> Also, we share the mount code path (cifs_mount) for all SMB versions. So=
, password
>> rotation for SMB1.0 is currently supported ONLY on mounts. Password rota=
tion on
>> remount, however, is not. Should I remove the support completely for SMB=
1.0
>> (print a warning message), leave it be, or add remount support?
>
>
> reconnect, not remount.
>
>>
>> Thanks
>> Meetakshi
>>
>> On Mon, Nov 11, 2024 at 5:34=E2=80=AFPM Paulo Alcantara <pc@manguebit.co=
m> wrote:
>>>
>>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>>>
>>> > On Fri, Nov 8, 2024 at 5:47=E2=80=AFPM Shyam Prasad N <nspmangalore@g=
mail.com> wrote:
>>> >> > What about SMB sessions from cifs_tcon::dfs_ses_list?  I don't see=
 their
>>> >> > password getting updated over remount.
>>> >>
>>> >> This is in our to-do list as well.
>>> >
>>> > I did some code reading around how DFS automount works.
>>> > @Paulo Alcantara Correct me if I'm wrong, but it sounds like we make
>>> > an assumption that when a DFS namespace has a junction to another
>>> > share, the same credentials are to be used to perform the mount of
>>> > that share. Is that always the case?
>>>
>>> Yes, it inherits fs_context from the parent mount.  For multiuser
>>> mounts, when uid/gid/cruid are unspecified, we need to update its value=
s
>>> to match real uid/gid from the calling process.
>>>
>>> > If we go by that assumption, for password2 to work with DFS mounts, w=
e
>>> > only need to make sure that in cifs_do_automount, cur_ctx passwords
>>> > are synced up to the current ses passwords. That should be quite easy=
.
>>>
>>> Correct.  The fs_context for the automount is dup'ed from the parent
>>> mount.  smb3_fs_context_dup() already dups password2, so it should work=
.
>>>
>>> The 'remount' case isn't still handled, that's why I mentioned it above=
.
>>> You'd need to set password2 for all sessios in @tcon->dfs_ses_list.
>>>
>>> I think we need to update password2 for the multiuser sessions as well
>>> and not only for session from master tcon.

--0000000000009779050626c9e8fc
Content-Type: application/octet-stream; 
	name="0001-cifs-during-remount-make-sure-passwords-are-in-sync.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-during-remount-make-sure-passwords-are-in-sync.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3ftg5800>
X-Attachment-Id: f_m3ftg5800

RnJvbSAyNWY4YmQ1Zjc0NDdjMjU5NGIzMjAyNGNiZTE2ZTIxMWQxZGIxZGJiIE1vbiBTZXAgMTcg
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
ZWZhLi5iYzY4ZTZlYmI5OWIgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5j
CisrKyBiL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jCkBAIC04OTAsMTIgKzg5MCwzNyBAQCBk
byB7CQkJCQkJCQkJXAogCWNpZnNfc2ItPmN0eC0+ZmllbGQgPSBOVUxMOwkJCQkJXAogfSB3aGls
ZSAoMCkKIAoraW50IHNtYl9zeW5jX3Nlc3Npb25fY3R4X3Bhc3N3b3JkcyhzdHJ1Y3QgY2lmc19z
Yl9pbmZvIGNpZnNfc2IsIHN0cnVjdCBjaWZzX3NlcyBzZXMpCit7CisJaWYgKHNlcy0+cGFzc3dv
cmQgJiYKKwkgICAgY2lmc19zYi0+Y3R4LT5wYXNzd29yZCAmJgorCSAgICBzdHJjbXAoc2VzLT5w
YXNzd29yZCwgY2lmc19zYi0+Y3R4LT5wYXNzd29yZCkpIHsKKwkJa2ZyZWVfc2Vuc2l0aXZlKGNp
ZnNfc2ItPmN0eC0+cGFzc3dvcmQpOworCQljaWZzX3NiLT5jdHgtPnBhc3N3b3JkID0ga3N0cmR1
cChzZXMtPnBhc3N3b3JkLCBHRlBfS0VSTkVMKTsKKwkJaWYgKCFjaWZzX3NiLT5jdHgtPnBhc3N3
b3JkKQorCQkJcmV0dXJuIC1FTk9NRU07CisJfQorCWlmIChzZXMtPnBhc3N3b3JkMiAmJgorCSAg
ICBjaWZzX3NiLT5jdHgtPnBhc3N3b3JkMiAmJgorCSAgICBzdHJjbXAoc2VzLT5wYXNzd29yZDIs
IGNpZnNfc2ItPmN0eC0+cGFzc3dvcmQyKSkgeworCQlrZnJlZV9zZW5zaXRpdmUoY2lmc19zYi0+
Y3R4LT5wYXNzd29yZDIpOworCQljaWZzX3NiLT5jdHgtPnBhc3N3b3JkMiA9IGtzdHJkdXAoc2Vz
LT5wYXNzd29yZDIsIEdGUF9LRVJORUwpOworCQlpZiAoIWNpZnNfc2ItPmN0eC0+cGFzc3dvcmQy
KSB7CisJCQlrZnJlZV9zZW5zaXRpdmUoY2lmc19zYi0+Y3R4LT5wYXNzd29yZCk7CisJCQljaWZz
X3NiLT5jdHgtPnBhc3N3b3JkID0gTlVMTDsKKwkJCXJldHVybiAtRU5PTUVNOworCQl9CisJfQor
CXJldHVybiAwOworfQorCiBzdGF0aWMgaW50IHNtYjNfcmVjb25maWd1cmUoc3RydWN0IGZzX2Nv
bnRleHQgKmZjKQogewogCXN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCA9IHNtYjNfZmMyY29u
dGV4dChmYyk7CiAJc3RydWN0IGRlbnRyeSAqcm9vdCA9IGZjLT5yb290OwogCXN0cnVjdCBjaWZz
X3NiX2luZm8gKmNpZnNfc2IgPSBDSUZTX1NCKHJvb3QtPmRfc2IpOwogCXN0cnVjdCBjaWZzX3Nl
cyAqc2VzID0gY2lmc19zYl9tYXN0ZXJfdGNvbihjaWZzX3NiKS0+c2VzOworCWNoYXIgKm5ld19w
YXNzd29yZCA9IE5VTEwsICpuZXdfcGFzc3dvcmQyID0gTlVMTDsKIAlib29sIG5lZWRfcmVjb24g
PSBmYWxzZTsKIAlpbnQgcmM7CiAKQEAgLTkxNSwyMSArOTQwLDYxIEBAIHN0YXRpYyBpbnQgc21i
M19yZWNvbmZpZ3VyZShzdHJ1Y3QgZnNfY29udGV4dCAqZmMpCiAJU1RFQUxfU1RSSU5HKGNpZnNf
c2IsIGN0eCwgVU5DKTsKIAlTVEVBTF9TVFJJTkcoY2lmc19zYiwgY3R4LCBzb3VyY2UpOwogCVNU
RUFMX1NUUklORyhjaWZzX3NiLCBjdHgsIHVzZXJuYW1lKTsKKwogCWlmIChuZWVkX3JlY29uID09
IGZhbHNlKQogCQlTVEVBTF9TVFJJTkdfU0VOU0lUSVZFKGNpZnNfc2IsIGN0eCwgcGFzc3dvcmQp
OwogCWVsc2UgIHsKLQkJa2ZyZWVfc2Vuc2l0aXZlKHNlcy0+cGFzc3dvcmQpOwotCQlzZXMtPnBh
c3N3b3JkID0ga3N0cmR1cChjdHgtPnBhc3N3b3JkLCBHRlBfS0VSTkVMKTsKLQkJaWYgKCFzZXMt
PnBhc3N3b3JkKQotCQkJcmV0dXJuIC1FTk9NRU07Ci0JCWtmcmVlX3NlbnNpdGl2ZShzZXMtPnBh
c3N3b3JkMik7Ci0JCXNlcy0+cGFzc3dvcmQyID0ga3N0cmR1cChjdHgtPnBhc3N3b3JkMiwgR0ZQ
X0tFUk5FTCk7Ci0JCWlmICghc2VzLT5wYXNzd29yZDIpIHsKLQkJCWtmcmVlX3NlbnNpdGl2ZShz
ZXMtPnBhc3N3b3JkKTsKLQkJCXNlcy0+cGFzc3dvcmQgPSBOVUxMOworCQlpZiAoY3R4LT5wYXNz
d29yZCkgeworCQkJbmV3X3Bhc3N3b3JkID0ga3N0cmR1cChjdHgtPnBhc3N3b3JkLCBHRlBfS0VS
TkVMKTsKKwkJCWlmICghbmV3X3Bhc3N3b3JkKQorCQkJCXJldHVybiAtRU5PTUVNOworCQl9IGVs
c2UKKwkJCVNURUFMX1NUUklOR19TRU5TSVRJVkUoY2lmc19zYiwgY3R4LCBwYXNzd29yZCk7CisJ
fQorCisJLyoKKwkgKiBpZiBhIG5ldyBwYXNzd29yZDIgaGFzIGJlZW4gc3BlY2lmaWVkLCB0aGVu
IHJlc2V0IGl0J3MgdmFsdWUKKwkgKiBpbnNpZGUgdGhlIHNlcyBzdHJ1Y3QKKwkgKi8KKwlpZiAo
Y3R4LT5wYXNzd29yZDIpIHsKKwkJbmV3X3Bhc3N3b3JkMiA9IGtzdHJkdXAoY3R4LT5wYXNzd29y
ZDIsIEdGUF9LRVJORUwpOworCQlpZiAoIW5ld19wYXNzd29yZDIpIHsKKwkJCWtmcmVlX3NlbnNp
dGl2ZShuZXdfcGFzc3dvcmQpOwogCQkJcmV0dXJuIC1FTk9NRU07CiAJCX0KKwl9IGVsc2UKKwkJ
U1RFQUxfU1RSSU5HX1NFTlNJVElWRShjaWZzX3NiLCBjdHgsIHBhc3N3b3JkMik7CisKKwkvKgor
CSAqIHdlIG1heSB1cGRhdGUgdGhlIHBhc3N3b3JkcyBpbiB0aGUgc2VzIHN0cnVjdCBiZWxvdy4g
TWFrZSBzdXJlIHdlIGRvCisJICogbm90IHJhY2Ugd2l0aCBzbWIyX3JlY29ubmVjdAorCSAqLwor
CW11dGV4X2xvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CisKKwkvKgorCSAqIHNtYjJfcmVjb25u
ZWN0IG1heSBzd2FwIHBhc3N3b3JkIGFuZCBwYXNzd29yZDIgaW4gY2FzZSBzZXNzaW9uIHNldHVw
CisJICogZmFpbGVkLiBGaXJzdCBnZXQgY3R4IHBhc3N3b3JkcyBpbiBzeW5jIHdpdGggc2VzIHBh
c3N3b3Jkcy4gSXQgc2hvdWxkCisJICogYmUgb2theSB0byBkbyB0aGlzIGV2ZW4gaWYgdGhpcyBm
dW5jdGlvbiB3ZXJlIHRvIHJldHVybiBhbiBlcnJvciBhdCBhCisJICogbGF0ZXIgc3RhZ2UKKwkg
Ki8KKwlyYyA9IHNtYl9zeW5jX3Nlc3Npb25fY3R4X3Bhc3N3b3JkcyhjaWZzX3NiLCBzZXMpOwor
CWlmIChyYykKKwkJcmV0dXJuIHJjOworCisJLyoKKwkgKiBub3cgdGhhdCBhbGxvY2F0aW9ucyBm
b3IgcGFzc3dvcmRzIGFyZSBkb25lLCBjb21taXQgdGhlbQorCSAqLworCWlmIChuZXdfcGFzc3dv
cmQpIHsKKwkJa2ZyZWVfc2Vuc2l0aXZlKHNlcy0+cGFzc3dvcmQpOworCQlzZXMtPnBhc3N3b3Jk
ID0gbmV3X3Bhc3N3b3JkOwogCX0KKwlpZiAobmV3X3Bhc3N3b3JkMikgeworCQlrZnJlZV9zZW5z
aXRpdmUoc2VzLT5wYXNzd29yZDIpOworCQlzZXMtPnBhc3N3b3JkMiA9IG5ld19wYXNzd29yZDI7
CisJfQorCisJbXV0ZXhfdW5sb2NrKCZzZXMtPnNlc3Npb25fbXV0ZXgpOworCiAJU1RFQUxfU1RS
SU5HKGNpZnNfc2IsIGN0eCwgZG9tYWlubmFtZSk7CiAJU1RFQUxfU1RSSU5HKGNpZnNfc2IsIGN0
eCwgbm9kZW5hbWUpOwogCVNURUFMX1NUUklORyhjaWZzX3NiLCBjdHgsIGlvY2hhcnNldCk7CmRp
ZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2ZzX2NvbnRleHQuaCBiL2ZzL3NtYi9jbGllbnQvZnNf
Y29udGV4dC5oCmluZGV4IDg5MGQ2ZDlkNGE1OS4uNTAzYWJiOGYwYjU1IDEwMDY0NAotLS0gYS9m
cy9zbWIvY2xpZW50L2ZzX2NvbnRleHQuaAorKysgYi9mcy9zbWIvY2xpZW50L2ZzX2NvbnRleHQu
aApAQCAtMjk5LDYgKzI5OSw3IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IHNtYjNfZnNfY29udGV4
dCAqc21iM19mYzJjb250ZXh0KGNvbnN0IHN0cnVjdCBmc19jb250ZXh0ICpmCiB9CiAKIGV4dGVy
biBpbnQgc21iM19mc19jb250ZXh0X2R1cChzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpuZXdfY3R4
LCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpOworZXh0ZXJuIGludCBzbWJfc3luY19zZXNz
aW9uX2N0eF9wYXNzd29yZHMoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNp
ZnNfc2VzICpzZXMpOwogZXh0ZXJuIHZvaWQgc21iM191cGRhdGVfbW50X2ZsYWdzKHN0cnVjdCBj
aWZzX3NiX2luZm8gKmNpZnNfc2IpOwogCiAvKgotLSAKMi40Ni4wLjQ2Lmc0MDZmMzI2ZDI3Cgo=
--0000000000009779050626c9e8fc--
