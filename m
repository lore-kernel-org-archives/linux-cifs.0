Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A5311C8B
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e71pphY5"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2cca8eb0509so56982451fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 06:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703861858; x=1704466658; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aErgYe502Z11qNVhys7bsUY8Ck4I84hx7ed0TUpdDMo=;
        b=e71pphY5QJ+Gx85x8Ov8bR0cNLusCoVAhzRrR8lArYABh3RT9eXztjqUub3pcd2JBV
         5J+NJ46PQHFwW0oAh+G4hORYD7GMXdlXGX1c/kxU84YcKALt0YKH5/wNgGgN1LXjhvcV
         5NGO2zIyuzwjTEtyHx3cXPd4H98jujbvw4HYrmMoXdNlapK5vY5snmFC7GK1K0CGWvYQ
         yyLwsu6Ht7D1/PEupZF9UKzAqScnnsn3nrpuaQGnaKslj0bApkmpwL6Py6NhB4a4BhrC
         NJDSQ4QYirLenznz3roOC6L5fh718DOka7luoAmRCwLrMRvXUUx+eBaFWQ5HKLm7JDoo
         TdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703861858; x=1704466658;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aErgYe502Z11qNVhys7bsUY8Ck4I84hx7ed0TUpdDMo=;
        b=KfSSwuTrqJXbVwzzBVAQqyfAt67AetyuUgJ+kNGqcgzSYhbLz5oxRGz1HXpq8L+uID
         fpJ1bR41i0SFqY4sbPjOw9/w80WWiuqlQoiuWhL8/es0hyBvZarDgt89njFJfTEFDMGm
         hpQQM0XU0UkEWTgDLfCt6oHbes1i8C/UX9R1ZF/PcczI/5rTYRrkdAFm3tjO4nZ8Y1Kg
         V2Orh5qW6LgO4+woPRcvgvzIVvvN5/WgE2sXE2PlX/g648j22eO6EbVT6WavOBQJXTeX
         EzXRF5aHeeODHtN/4TbfA+DjvdwdGNOBvLT+i2vSyvbH3oUcnKQLd2zDpQ2z0C8xIdhe
         XsWQ==
X-Gm-Message-State: AOJu0Yza6xYyOdbfnKICzqGRC7SljqXhixxY2nZ5HUyzEpibjyeTBRIn
	MNMVk0/w28eSOEOwaRAvi7EOa5j1XGwqtq/ZiWPzVTb59as=
X-Google-Smtp-Source: AGHT+IEQxsa5TIlxBPj8MA7Z2fLEvlKPxu8fux6D9q8lj4BVVwyJ/DEhJLGd8IZ9ZjDIEFqC8TaVR91wMUd/jCgW9i0=
X-Received: by 2002:a05:651c:54c:b0:2cc:d490:28b9 with SMTP id
 q12-20020a05651c054c00b002ccd49028b9mr2765817ljp.5.1703861857412; Fri, 29 Dec
 2023 06:57:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229111618.38887-1-sprasad@microsoft.com> <CANT5p=rX81OL+cU+EVSRcv+xF_cHQQ+Oz6JkMQoTDzH6YVBWqA@mail.gmail.com>
In-Reply-To: <CANT5p=rX81OL+cU+EVSRcv+xF_cHQQ+Oz6JkMQoTDzH6YVBWqA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 29 Dec 2023 08:57:25 -0600
Message-ID: <CAH2r5mvNBNy56Q1vhj=1F_YELX00X9ok_8==njW=P_38F7oAHA@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: cifs_chan_is_iface_active should be called with
 chan_lock held
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, meetakshisetiyaoss@gmail.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000c1fe2a060da740f7"

--000000000000c1fe2a060da740f7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated patch attached (to fix minor merge conflict)

On Fri, Dec 29, 2023 at 5:25=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Fri, Dec 29, 2023 at 4:46=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > cifs_chan_is_iface_active checks the channels of a session to see
> > if the associated iface is active. This should always happen
> > with chan_lock held. However, these two callers of this function
> > were missing this locking.
> >
> > This change makes sure the function calls are protected with
> > proper locking.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/connect.c | 7 +++++--
> >  fs/smb/client/smb2ops.c | 7 ++++++-
> >  2 files changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 8b7cffba1ad5..3052a208c6ca 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -232,10 +232,13 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_=
Server_Info *server,
> >         spin_lock(&cifs_tcp_ses_lock);
> >         list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb=
_ses_list) {
> >                 /* check if iface is still active */
> > -               if (!cifs_chan_is_iface_active(ses, server))
> > +               spin_lock(&ses->chan_lock);
> > +               if (!cifs_chan_is_iface_active(ses, server)) {
> > +                       spin_unlock(&ses->chan_lock);
> >                         cifs_chan_update_iface(ses, server);
> > +                       spin_lock(&ses->chan_lock);
> > +               }
> >
> > -               spin_lock(&ses->chan_lock);
> >                 if (!mark_smb_session && cifs_chan_needs_reconnect(ses,=
 server)) {
> >                         spin_unlock(&ses->chan_lock);
> >                         continue;
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 441d144bd712..104c58df0368 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -784,9 +784,14 @@ SMB3_request_interfaces(const unsigned int xid, st=
ruct cifs_tcon *tcon, bool in_
> >                 goto out;
> >
> >         /* check if iface is still active */
> > +       spin_lock(&ses->chan_lock);
> >         pserver =3D ses->chans[0].server;
> > -       if (pserver && !cifs_chan_is_iface_active(ses, pserver))
> > +       if (pserver && !cifs_chan_is_iface_active(ses, pserver)) {
> > +               spin_unlock(&ses->chan_lock);
> >                 cifs_chan_update_iface(ses, pserver);
> > +               spin_lock(&ses->chan_lock);
> > +       }
> > +       spin_unlock(&ses->chan_lock);
> >
> >  out:
> >         kfree(out_buf);
> > --
> > 2.34.1
> >
>
> This one fixes two changes. Not sure if it's valid to have two Fixes tag.

Yes - that is ok (two Fixes tags)
--=20
Thanks,

Steve

--000000000000c1fe2a060da740f7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-cifs_chan_is_iface_active-should-be-called-with.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-cifs_chan_is_iface_active-should-be-called-with.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lqqrbv820>
X-Attachment-Id: f_lqqrbv820

RnJvbSA5ZGRmNzllMjk3MTcxZTM0NjYyZDliYzc5MjI0MDM1YTU5NGEwZjEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDI5IERlYyAyMDIzIDExOjE2OjE1ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogY2lmc19jaGFuX2lzX2lmYWNlX2FjdGl2ZSBzaG91bGQgYmUgY2FsbGVkIHdpdGgKIGNo
YW5fbG9jayBoZWxkCgpjaWZzX2NoYW5faXNfaWZhY2VfYWN0aXZlIGNoZWNrcyB0aGUgY2hhbm5l
bHMgb2YgYSBzZXNzaW9uIHRvIHNlZQppZiB0aGUgYXNzb2NpYXRlZCBpZmFjZSBpcyBhY3RpdmUu
IFRoaXMgc2hvdWxkIGFsd2F5cyBoYXBwZW4Kd2l0aCBjaGFuX2xvY2sgaGVsZC4gSG93ZXZlciwg
dGhlc2UgdHdvIGNhbGxlcnMgb2YgdGhpcyBmdW5jdGlvbgp3ZXJlIG1pc3NpbmcgdGhpcyBsb2Nr
aW5nLgoKVGhpcyBjaGFuZ2UgbWFrZXMgc3VyZSB0aGUgZnVuY3Rpb24gY2FsbHMgYXJlIHByb3Rl
Y3RlZCB3aXRoCnByb3BlciBsb2NraW5nLgoKRml4ZXM6IGI1NDAzNGE3M2JhZiAoImNpZnM6IGR1
cmluZyByZWNvbm5lY3QsIHVwZGF0ZSBpbnRlcmZhY2UgaWYgbmVjZXNzYXJ5IikKRml4ZXM6IGZh
MWQwNTA4YmRkNCAoImNpZnM6IGFjY291bnQgZm9yIHByaW1hcnkgY2hhbm5lbCBpbiB0aGUgaW50
ZXJmYWNlIGxpc3QiKQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBT
aHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9jb25u
ZWN0LmMgfCA3ICsrKysrLS0KIGZzL3NtYi9jbGllbnQvc21iMm9wcy5jIHwgNyArKysrKystCiAy
IGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMgYi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwpp
bmRleCBkZDJhMWZiNjVlNzEuLjA4YzA0YTc4MzAzZCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVu
dC9jb25uZWN0LmMKKysrIGIvZnMvc21iL2NsaWVudC9jb25uZWN0LmMKQEAgLTIyOCwxMCArMjI4
LDEzIEBAIGNpZnNfbWFya190Y3Bfc2VzX2Nvbm5zX2Zvcl9yZWNvbm5lY3Qoc3RydWN0IFRDUF9T
ZXJ2ZXJfSW5mbyAqc2VydmVyLAogCQkJYnJlYWs7CiAKIAkJLyogY2hlY2sgaWYgaWZhY2UgaXMg
c3RpbGwgYWN0aXZlICovCi0JCWlmICghY2lmc19jaGFuX2lzX2lmYWNlX2FjdGl2ZShzZXMsIHNl
cnZlcikpCisJCXNwaW5fbG9jaygmc2VzLT5jaGFuX2xvY2spOworCQlpZiAoIWNpZnNfY2hhbl9p
c19pZmFjZV9hY3RpdmUoc2VzLCBzZXJ2ZXIpKSB7CisJCQlzcGluX3VubG9jaygmc2VzLT5jaGFu
X2xvY2spOwogCQkJY2lmc19jaGFuX3VwZGF0ZV9pZmFjZShzZXMsIHNlcnZlcik7CisJCQlzcGlu
X2xvY2soJnNlcy0+Y2hhbl9sb2NrKTsKKwkJfQogCi0JCXNwaW5fbG9jaygmc2VzLT5jaGFuX2xv
Y2spOwogCQlpZiAoIW1hcmtfc21iX3Nlc3Npb24gJiYgY2lmc19jaGFuX25lZWRzX3JlY29ubmVj
dChzZXMsIHNlcnZlcikpIHsKIAkJCXNwaW5fdW5sb2NrKCZzZXMtPmNoYW5fbG9jayk7CiAJCQlj
b250aW51ZTsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jIGIvZnMvc21iL2Ns
aWVudC9zbWIyb3BzLmMKaW5kZXggOWE5ZDlkZWM3MDgxLi4xNGJjNzQ1ZGUxOTkgMTAwNjQ0Ci0t
LSBhL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5j
CkBAIC03OTEsOSArNzkxLDE0IEBAIFNNQjNfcmVxdWVzdF9pbnRlcmZhY2VzKGNvbnN0IHVuc2ln
bmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIGJvb2wgaW5fCiAJCWdvdG8gb3V0
OwogCiAJLyogY2hlY2sgaWYgaWZhY2UgaXMgc3RpbGwgYWN0aXZlICovCisJc3Bpbl9sb2NrKCZz
ZXMtPmNoYW5fbG9jayk7CiAJcHNlcnZlciA9IHNlcy0+Y2hhbnNbMF0uc2VydmVyOwotCWlmIChw
c2VydmVyICYmICFjaWZzX2NoYW5faXNfaWZhY2VfYWN0aXZlKHNlcywgcHNlcnZlcikpCisJaWYg
KHBzZXJ2ZXIgJiYgIWNpZnNfY2hhbl9pc19pZmFjZV9hY3RpdmUoc2VzLCBwc2VydmVyKSkgewor
CQlzcGluX3VubG9jaygmc2VzLT5jaGFuX2xvY2spOwogCQljaWZzX2NoYW5fdXBkYXRlX2lmYWNl
KHNlcywgcHNlcnZlcik7CisJCXNwaW5fbG9jaygmc2VzLT5jaGFuX2xvY2spOworCX0KKwlzcGlu
X3VubG9jaygmc2VzLT5jaGFuX2xvY2spOwogCiBvdXQ6CiAJa2ZyZWUob3V0X2J1Zik7Ci0tIAoy
LjQwLjEKCg==
--000000000000c1fe2a060da740f7--
