Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6057D3A8C3
	for <linux-cifs@vger.kernel.org>; Wed, 31 Jan 2024 22:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706741853; cv=none; b=OWQKNYY+rXvKKus/mToI4C+i7ug6hkOPRj/L3UAE9jMX1F7k+R/qy6e5N/b21SKkP4lE0RkmIu4qM/JJ4qvxXW9i364DMX6pLDVgubIYnX2t9w0OFqqwwHylkhfc8dI5B3SEzNWHu9yCNfWV10XBWMxycWuuv43h7lBiri1YO28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706741853; c=relaxed/simple;
	bh=djCqGu4DCLbaWX7yDUPgiMMeH/lFBvE+fxQa8RfvVMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CfaOKT23d/xuA9IFTU48s8q2Mj3KuiEUAzD6tULRRSXu+ItHi54RCE+KZPmRgLO4lD9Xu9hTH1kj1ZHCKh1hzGCM+6dZSY3fo46/vM2to3fPPY9gk9sscXf3HuEoBtK40vNJQp8HFsBP3kAiIlKbphGj46onIt5oySSfi+5aGhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VUbNps3u; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUbNps3u"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2cf1fd1cc5bso4420161fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 31 Jan 2024 14:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706741849; x=1707346649; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1YSVk2NTb6fYemgBF8wyotfr/Ir5x+g+RZVbtVef4yU=;
        b=VUbNps3uMbCOituXcOfpnQB1dMojT8De4vFXpFoSo2Hs0zbaLlBdAUiTjf9VOba3rF
         z6Zja5iuXpODWk/3XAx1E9H+Gkzp+uIrbLzCdn7nSVez3mK67N8v/RO2LPez4JSvO9iG
         VbTNxGeHXq6lmE5yd3kLkcuYQ7JEkuz9vGianmBM17LHCkwXnRuAl3PFd6IEGYpAMCOA
         wuosQ6q4J5YvTr+xuwR7mwdMgsXftyu0UHHaw6aeLhXC4WfyvrMJikBqN5zcVSD/pPeh
         cTleeyEyMGSyz6x99rXv5ZdBN4RmLTKl54my+uBHbk+uIh7XO1p3mLxFFt1RJjF1+bT5
         5M5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706741849; x=1707346649;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1YSVk2NTb6fYemgBF8wyotfr/Ir5x+g+RZVbtVef4yU=;
        b=I2zDQD7F45LTyD9r7WkZaybi8lz3kxyi1qQZiQLMTsrhPYqwuRdVoRv1YbqwFRUEWQ
         BYryPjM5XhVrwto3nm++jg5JvZZ4jemrzWYNCkAYd2O4nfWeWuA3e/kNqOMd2BOf/j5C
         3drBb/UyggKdGRsiYweDlr8MnN7p5rhvk/3l52atnngSnTR5TgZrylYSqOHd9ZaPeCVF
         saQKljLUiUWUQvQiqHOHUo8asZeIFjMhmP6+eqaDueWkCHwlMkuXB/idTDcRC888jP00
         TwUD4mkSBBqhtwW2Xndxor8k/JqoapKWBiwYOBfcpm1JiiWxd+BjhVGLE4cFtXdwHG8x
         Zdbw==
X-Gm-Message-State: AOJu0Yy5t9YQZ+FEejYwROG5ypdNFj605GAOPEZoCVKKSSNcfAbQbRZq
	lnI9rKHkK9IZ3WgvOChtTOECEETzbUuO7Oxzs8F/9bNbshsSMdmmRvsNDNHiD/8KN6SZaQO7vqP
	M0QY5h1+2FA8fy4Vvlj3zl0HXwLk=
X-Google-Smtp-Source: AGHT+IGC2IS633FPYU9H7yS2NaPxsY0wE1QcqIcHQ8R5f7wGMWKlTigDzLicUwzpCOmaQnBGx+EfQRlUvEo4S7giAKc=
X-Received: by 2002:a2e:a401:0:b0:2d0:5435:7b11 with SMTP id
 p1-20020a2ea401000000b002d054357b11mr2001936ljn.52.1706741848626; Wed, 31 Jan
 2024 14:57:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvEHKkYqu6CEgk5fzY8tR+UFa-Ynh38gB9Sej4u41YjkA@mail.gmail.com>
In-Reply-To: <CAH2r5mvEHKkYqu6CEgk5fzY8tR+UFa-Ynh38gB9Sej4u41YjkA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 31 Jan 2024 16:57:17 -0600
Message-ID: <CAH2r5mvHJZN4Gx5p6bjNzWjHJCHzFa0cZu5mxSuE07AMpkVrcA@mail.gmail.com>
Subject: Re: fix for patch "cifs" make sure that channel scaling is done only once"
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Bharath S M <bharathsm@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000009c73a5061045cd3d"

--0000000000009c73a5061045cd3d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated patch (with fix merged into it) attached - and pushed to
for-next pending review and testing


On Wed, Jan 31, 2024 at 4:43=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Looks like the patch in for-next "cifs: make sure that channel scaling
> is done only once" (see attached) was missing some unlocks that were
> noticed by compile with C=3D1 and/or sparse.   See below.
>
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 2837fc4465a7..3110aabc32c5 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -400,8 +400,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon=
 *tcon,
>         }
>
>         spin_lock(&ses->ses_lock);
> -       if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS)
> +       if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> +               spin_unlock(&ses->ses_lock);
> +               mutex_unlock(&ses->session_mutex);
>                 goto skip_add_channels;
> +       }
>         ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
>         spin_unlock(&ses->ses_lock);
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--0000000000009c73a5061045cd3d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-make-sure-that-channel-scaling-is-done-only-onc.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-make-sure-that-channel-scaling-is-done-only-onc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ls2e0s2r0>
X-Attachment-Id: f_ls2e0s2r0

RnJvbSBlZTM2YTNiMzQ1YzQzM2E4NDZlZmZjZGNmYmE0MzdjMjI5OGVlZGE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBNb24sIDI5IEphbiAyMDI0IDEzOjU4OjEzICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogbWFrZSBzdXJlIHRoYXQgY2hhbm5lbCBzY2FsaW5nIGlzIGRvbmUgb25seSBvbmNlCgpG
b2xsb3dpbmcgYSBzdWNjZXNzZnVsIGNpZnNfdHJlZV9jb25uZWN0LCB3ZSBoYXZlIHRoZSBjb2Rl
CnRvIHNjYWxlIHVwL2Rvd24gdGhlIG51bWJlciBvZiBjaGFubmVscyBpbiB0aGUgc2Vzc2lvbi4K
SG93ZXZlciwgaXQgaXMgbm90IHByb3RlY3RlZCBieSBhIGxvY2sgdG9kYXkuCgpBcyBhIHJlc3Vs
dCwgdGhpcyBjb2RlIGNhbiBiZSBleGVjdXRlZCBieSBzZXZlcmFsIHByb2Nlc3Nlcwp0aGF0IHNl
bGVjdCB0aGUgc2FtZSBjaGFubmVsLiBUaGUgY29yZSBmdW5jdGlvbnMgaGFuZGxlIHRoaXMKd2Vs
bCwgYXMgdGhleSBwaWNrIGNoYW5fbG9jay4gSG93ZXZlciwgd2UndmUgc2VlbiBjYXNlcyB3aGVy
ZQpzbWIyX3JlY29ubmVjdCB0aHJvd3Mgc29tZSB3YXJuaW5ncy4KClRvIGZpeCB0aGF0LCB0aGlz
IGNoYW5nZSBpbnRyb2R1Y2VzIGEgZmxhZ3MgYml0bWFwIGluc2lkZSB0aGUKY2lmc19zZXMgc3Ry
dWN0dXJlLiBBIG5ldyBmbGFnIHR5cGUgaXMgdXNlZCB0byBlbnN1cmUgdGhhdApvbmx5IG9uZSBw
cm9jZXNzIGVudGVycyB0aGlzIHNlY3Rpb24gYXQgYW55IHRpbWUuCgpTaWduZWQtb2ZmLWJ5OiBT
aHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9jaWZz
Z2xvYi5oIHwgIDMgKysrCiBmcy9zbWIvY2xpZW50L3NtYjJwZHUuYyAgfCAyMCArKysrKysrKysr
KysrKysrKy0tLQogMiBmaWxlcyBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaCBiL2ZzL3NtYi9jbGll
bnQvY2lmc2dsb2IuaAppbmRleCAxNmJlZmZmNGNiYjQuLjkwOTNjNTA3MDQyZiAxMDA2NDQKLS0t
IGEvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2Iu
aApAQCAtMTAzMiw2ICsxMDMyLDggQEAgc3RydWN0IGNpZnNfY2hhbiB7CiAJX191OCBzaWdua2V5
W1NNQjNfU0lHTl9LRVlfU0laRV07CiB9OwogCisjZGVmaW5lIENJRlNfU0VTX0ZMQUdfU0NBTEVf
Q0hBTk5FTFMgKDB4MSkKKwogLyoKICAqIFNlc3Npb24gc3RydWN0dXJlLiAgT25lIG9mIHRoZXNl
IGZvciBlYWNoIHVpZCBzZXNzaW9uIHdpdGggYSBwYXJ0aWN1bGFyIGhvc3QKICAqLwpAQCAtMTA2
NCw2ICsxMDY2LDcgQEAgc3RydWN0IGNpZnNfc2VzIHsKIAllbnVtIHNlY3VyaXR5RW51bSBzZWN0
eXBlOyAvKiB3aGF0IHNlY3VyaXR5IGZsYXZvciB3YXMgc3BlY2lmaWVkPyAqLwogCWJvb2wgc2ln
bjsJCS8qIGlzIHNpZ25pbmcgcmVxdWlyZWQ/ICovCiAJYm9vbCBkb21haW5BdXRvOjE7CisJdW5z
aWduZWQgaW50IGZsYWdzOwogCV9fdTE2IHNlc3Npb25fZmxhZ3M7CiAJX191OCBzbWIzc2lnbmlu
Z2tleVtTTUIzX1NJR05fS0VZX1NJWkVdOwogCV9fdTggc21iM2VuY3J5cHRpb25rZXlbU01CM19F
TkNfREVDX0tFWV9TSVpFXTsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jIGIv
ZnMvc21iL2NsaWVudC9zbWIycGR1LmMKaW5kZXggODZmNmYzNWI3ZjMyLi42ZGI1NGM2ZWY1NzEg
MTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCisrKyBiL2ZzL3NtYi9jbGllbnQv
c21iMnBkdS5jCkBAIC0zOTksNiArMzk5LDE1IEBAIHNtYjJfcmVjb25uZWN0KF9fbGUxNiBzbWIy
X2NvbW1hbmQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCWdvdG8gb3V0OwogCX0KIAorCXNw
aW5fbG9jaygmc2VzLT5zZXNfbG9jayk7CisJaWYgKHNlcy0+ZmxhZ3MgJiBDSUZTX1NFU19GTEFH
X1NDQUxFX0NIQU5ORUxTKSB7CisJCXNwaW5fdW5sb2NrKCZzZXMtPnNlc19sb2NrKTsKKwkJbXV0
ZXhfdW5sb2NrKCZzZXMtPnNlc3Npb25fbXV0ZXgpOworCQlnb3RvIHNraXBfYWRkX2NoYW5uZWxz
OworCX0KKwlzZXMtPmZsYWdzIHw9IENJRlNfU0VTX0ZMQUdfU0NBTEVfQ0hBTk5FTFM7CisJc3Bp
bl91bmxvY2soJnNlcy0+c2VzX2xvY2spOworCiAJaWYgKCFyYyAmJgogCSAgICAoc2VydmVyLT5j
YXBhYmlsaXRpZXMgJiBTTUIyX0dMT0JBTF9DQVBfTVVMVElfQ0hBTk5FTCkpIHsKIAkJbXV0ZXhf
dW5sb2NrKCZzZXMtPnNlc3Npb25fbXV0ZXgpOwpAQCAtNDI4LDE3ICs0MzcsMjIgQEAgc21iMl9y
ZWNvbm5lY3QoX19sZTE2IHNtYjJfY29tbWFuZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJ
aWYgKHNlcy0+Y2hhbl9tYXggPiBzZXMtPmNoYW5fY291bnQgJiYKIAkJICAgIHNlcy0+aWZhY2Vf
Y291bnQgJiYKIAkJICAgICFTRVJWRVJfSVNfQ0hBTihzZXJ2ZXIpKSB7Ci0JCQlpZiAoc2VzLT5j
aGFuX2NvdW50ID09IDEpCisJCQlpZiAoc2VzLT5jaGFuX2NvdW50ID09IDEpIHsKIAkJCQljaWZz
X3NlcnZlcl9kYmcoVkZTLCAic3VwcG9ydHMgbXVsdGljaGFubmVsIG5vd1xuIik7CisJCQkJcXVl
dWVfZGVsYXllZF93b3JrKGNpZnNpb2Rfd3EsICZ0Y29uLT5xdWVyeV9pbnRlcmZhY2VzLAorCQkJ
CQkJIChTTUJfSU5URVJGQUNFX1BPTExfSU5URVJWQUwgKiBIWikpOworCQkJfQogCiAJCQljaWZz
X3RyeV9hZGRpbmdfY2hhbm5lbHMoc2VzKTsKLQkJCXF1ZXVlX2RlbGF5ZWRfd29yayhjaWZzaW9k
X3dxLCAmdGNvbi0+cXVlcnlfaW50ZXJmYWNlcywKLQkJCQkJICAgKFNNQl9JTlRFUkZBQ0VfUE9M
TF9JTlRFUlZBTCAqIEhaKSk7CiAJCX0KIAl9IGVsc2UgewogCQltdXRleF91bmxvY2soJnNlcy0+
c2Vzc2lvbl9tdXRleCk7CiAJfQorCiBza2lwX2FkZF9jaGFubmVsczoKKwlzcGluX2xvY2soJnNl
cy0+c2VzX2xvY2spOworCXNlcy0+ZmxhZ3MgJj0gfkNJRlNfU0VTX0ZMQUdfU0NBTEVfQ0hBTk5F
TFM7CisJc3Bpbl91bmxvY2soJnNlcy0+c2VzX2xvY2spOwogCiAJaWYgKHNtYjJfY29tbWFuZCAh
PSBTTUIyX0lOVEVSTkFMX0NNRCkKIAkJbW9kX2RlbGF5ZWRfd29yayhjaWZzaW9kX3dxLCAmc2Vy
dmVyLT5yZWNvbm5lY3QsIDApOwotLSAKMi40MC4xCgo=
--0000000000009c73a5061045cd3d--
