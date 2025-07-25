Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB3886329
	for <linux-cifs@vger.kernel.org>; Fri, 25 Jul 2025 03:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753414028; cv=none; b=m2tRM7GufkbYSvWBGMVoh5kgn619Zd17xFyOvPijzcfNj/g0LqyIFda0Hd4zw4rFwRex07XjQcIEx6i13Q941o5AlZ24doWPc1DY6Pbz6abrqhpzhPjrEkd8O8USUV4tAkjUmb2nnZ38YD0XHmVGpaVKfXElO2KjCLATmPBj4f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753414028; c=relaxed/simple;
	bh=6LfQYIM7QqI3HqnXKTAlE6Qm1JItix5lkI0Ikqrc4z8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ASFrqMOLiAcvkjK+IHNr51wZicCmg/L8y5e2dCFG2byagg6ax7dyTz9u2OREVLEKn/SOlfHySwIofO5FR9fTUGl9YInQSEIi0vz227HnQwCJB3jJlp2ZkLjCp9hrSIWqADX3Zn6yRv5JL6n719uCWIFAL57TxCOOu0asxsIiBoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mgk1KxEP; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mgk1KxEP"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6fd0a91ae98so10723616d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 20:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753414025; x=1754018825; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ErDbuqGUGwR2SnfiAUZvN1aswfEgiX6LVuNlxQqUW08=;
        b=mgk1KxEPS28rdfwrMlOtgO5tZUzrt9xvxX8Uz+hqvTywD20/i4oxFkb79zXAk4Gesn
         sGUrnxvreqn+bq6NCGSL/ouejz8s7xsa7HeGHTEGY6esY0lcyUD+rRlg5nq576AFv7x1
         UEgDYck+jsrxu4poWeffSXFtIxQ5c4Tz4tie2Xl+cOftL3T8Rs4BrncyyqhrSwehWMcR
         /TUp/LIOxkhkEy2tTvHYvx2dsJem8MBOqvkP5KXRHH+wKpeM3wF7fznTY4IIabs1GbqD
         MdmA9G7Niz54WKuYrH6K94vzBSfl3WXt/DNfulgBZV3GmuNuX2f77wGsnHw0gIp18jj1
         +4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753414025; x=1754018825;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ErDbuqGUGwR2SnfiAUZvN1aswfEgiX6LVuNlxQqUW08=;
        b=DEK2S7beh7R72WmQTiiipCcsbeKboqJ17/bvcXr71j+cWPEN+FU4ammQmHUl4OU06p
         t410/kThB8NkR1LKG1HTsPt50AnZbvuAeXUNmSAr4R3FkBPMyLg2FoQcSF8oi/A4rTkR
         IOye8UtkTP5UaAZFJkj2aRqP4ysAwvlJ6/aMm52B9Zhy37HO1BU6Eq4Q2jpmgRhpnkur
         ImdQI8VrTMsPULRzLhZtzOihQijuBdolOMTxUqqa+EWx93b5x0sBznNwZfLqO17f1voN
         jqJIYHKU+tE7DH6o1jgWW+MfhstZuNDXrrNjPRhNj5Db1ruy7AXWNPgan+9wQZJU5fdL
         nPPw==
X-Gm-Message-State: AOJu0Yz3KWDP0IOn8dB9YN4ChTfI/YkPD+rHul7GoKJ+i9vKbkR9VcHm
	tWkzC2GbvreQempiQXIUe+kKEKX3ve4gVCbEoFxfLSuaZsthF+NomX2RgkDe+DXsCYMFBn2lebc
	OcJYKtHUrELflSK6H01DemXpfElxNXns=
X-Gm-Gg: ASbGncvC6f2dxWtQC7tcnL2efE62yjSR/gA+HCt5EynF7TXnkohCLPml2heHUThlX+n
	luXnjK0klA9jU3RCthp9HSwJSxv5XwSx95m4WFLSmU3RnX7QczBcOtkrpCfoZKcQC39mTccME6Y
	xUHCvRV6TAF1j3/TjPRQ+oP25HfSQ3e+ZfyecGMX1NEWmXH/rh/PwtinlrHuDFG+V/fdBVy8rGb
	G6oZff2S1/UnimlfDJYmXaLhuWMDK1POE88BYVfI35EFJ5g22gU
X-Google-Smtp-Source: AGHT+IG1e8Ff8UNy9GvCa4Y7NhIEWBf4DJ2EzHuqcFQt4+Z+8i2kpjncixUVHdGw6L8gsj8lev/GUGelrT8B4Ns7/to=
X-Received: by 2002:a05:6214:29eb:b0:700:c179:f57c with SMTP id
 6a1803df08f44-707205c33d8mr4417006d6.38.1753414025099; Thu, 24 Jul 2025
 20:27:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-7-sprasad@microsoft.com> <CAH2r5mvHV8Y2tO156TmQ7ymrgaiFPZSsZdzSNWvEreDq2p-G=A@mail.gmail.com>
In-Reply-To: <CAH2r5mvHV8Y2tO156TmQ7ymrgaiFPZSsZdzSNWvEreDq2p-G=A@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 24 Jul 2025 22:26:53 -0500
X-Gm-Features: Ac12FXzSUb5wLuzdf9nf4pk7sppMvTP017fkmfaD3uALmvNdcPZFn0JjIAhW1hY
Message-ID: <CAH2r5muix9VFHpoVmDvUbZnwEeT94zXw7SrGKRf+Crgj8vgS5Q@mail.gmail.com>
Subject: Re: [PATCH 7/7] cifs: add new field to track the last access time of cfid
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	meetakshisetiyaoss@gmail.com, pc@manguebit.com, paul@darkrain42.org, 
	henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000001c5eb1063ab884cd"

--0000000000001c5eb1063ab884cd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated patch with description


On Thu, Jul 24, 2025 at 6:05=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Rebased version of patch attached. See attached. Let me know if any
> objections.  It solves an obvious important issue (we shouldn't be
> timing out directory leases if they are the most recently used ones)
>
>
> On Wed, Jun 4, 2025 at 5:18=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > The handlecache code today tracks the time at which dir lease was
> > acquired and the laundromat thread uses that to check for old
> > entries to cleanup.
> >
> > However, if a directory is actively accessed, it should not
> > be chosen to expire first.
> >
> > This change adds a new last_access_time field to cfid and
> > uses that to decide expiry of the cfid.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cached_dir.c | 6 ++++--
> >  fs/smb/client/cached_dir.h | 1 +
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > index 4abf5bbd8baf..d432a40f902e 100644
> > --- a/fs/smb/client/cached_dir.c
> > +++ b/fs/smb/client/cached_dir.c
> > @@ -213,6 +213,7 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >          */
> >         spin_lock(&cfid->fid_lock);
> >         if (cfid->has_lease && cfid->time) {
> > +               cfid->last_access_time =3D jiffies;
> >                 spin_unlock(&cfid->fid_lock);
> >                 mutex_unlock(&cfid->cfid_mutex);
> >                 *ret_cfid =3D cfid;
> > @@ -365,6 +366,7 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >         cfid->tcon =3D tcon;
> >         cfid->is_open =3D true;
> >         cfid->time =3D jiffies;
> > +       cfid->last_access_time =3D jiffies;
> >         spin_unlock(&cfid->fid_lock);
> >
> >  oshr_free:
> > @@ -741,8 +743,8 @@ static void cfids_laundromat_worker(struct work_str=
uct *work)
> >         spin_lock(&cfids->cfid_list_lock);
> >         list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> >                 spin_lock(&cfid->fid_lock);
> > -               if (cfid->time &&
> > -                   time_after(jiffies, cfid->time + HZ * dir_cache_tim=
eout)) {
> > +               if (cfid->last_access_time &&
> > +                   time_after(jiffies, cfid->last_access_time + HZ * d=
ir_cache_timeout)) {
> >                         cfid->on_list =3D false;
> >                         list_move(&cfid->entry, &entry);
> >                         cfids->num_entries--;
> > diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> > index 93c936af2253..6d4b9413aa67 100644
> > --- a/fs/smb/client/cached_dir.h
> > +++ b/fs/smb/client/cached_dir.h
> > @@ -39,6 +39,7 @@ struct cached_fid {
> >         bool on_list:1;
> >         bool file_all_info_is_valid:1;
> >         unsigned long time; /* jiffies of when lease was taken */
> > +       unsigned long last_access_time; /* jiffies of when last accesse=
d */
> >         struct kref refcount;
> >         struct cifs_fid fid;
> >         spinlock_t fid_lock;
> > --
> > 2.43.0
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--0000000000001c5eb1063ab884cd
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-add-new-field-to-track-the-last-access-time-of-.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-add-new-field-to-track-the-last-access-time-of-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mdi9fhrh0>
X-Attachment-Id: f_mdi9fhrh0

RnJvbSBlNGFlMjdkMTVkZGVlYjhjMjc2M2Y2ZDAzOGUyNTUzYTQ4YWZlMzRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDI0IEp1bCAyMDI1IDIyOjIzOjUzIC0wNTAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogYWRkIG5ldyBmaWVsZCB0byB0cmFjayB0aGUgbGFzdCBhY2Nlc3MgdGltZSBvZiBjZmlk
CgpUaGUgaGFuZGxlY2FjaGUgY29kZSB0b2RheSB0cmFja3MgdGhlIHRpbWUgYXQgd2hpY2ggZGly
IGxlYXNlIHdhcwphY3F1aXJlZCBhbmQgdGhlIGxhdW5kcm9tYXQgdGhyZWFkIHVzZXMgdGhhdCB0
byBjaGVjayBmb3Igb2xkCmVudHJpZXMgdG8gY2xlYW51cC4KCkhvd2V2ZXIsIGlmIGEgZGlyZWN0
b3J5IGlzIGFjdGl2ZWx5IGFjY2Vzc2VkLCBpdCBzaG91bGQgbm90CmJlIGNob3NlbiB0byBleHBp
cmUgZmlyc3QuCgpUaGlzIGNoYW5nZSBhZGRzIGEgbmV3IGxhc3RfYWNjZXNzX3RpbWUgZmllbGQg
dG8gY2ZpZCBhbmQKdXNlcyB0aGF0IHRvIGRlY2lkZSBleHBpcnkgb2YgdGhlIGNmaWQuCgpTaWdu
ZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21i
L2NsaWVudC9jYWNoZWRfZGlyLmMgfCA2ICsrKystLQogZnMvc21iL2NsaWVudC9jYWNoZWRfZGly
LmggfCAxICsKIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jIGIvZnMvc21iL2NsaWVu
dC9jYWNoZWRfZGlyLmMKaW5kZXggMTE2NDcwYjFkZmVhLi5iNjlkYWViMTMwMWIgMTAwNjQ0Ci0t
LSBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY2FjaGVk
X2Rpci5jCkBAIC0xOTUsNiArMTk1LDcgQEAgaW50IG9wZW5fY2FjaGVkX2Rpcih1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCSAqIGZyb20gQGNmaWRzLT5lbnRyaWVz
LiAgQ2FsbGVyIHdpbGwgcHV0IGxhc3QgcmVmZXJlbmNlIGlmIHRoZSBsYXR0ZXIuCiAJICovCiAJ
aWYgKGNmaWQtPmhhc19sZWFzZSAmJiBjZmlkLT50aW1lKSB7CisJCWNmaWQtPmxhc3RfYWNjZXNz
X3RpbWUgPSBqaWZmaWVzOwogCQlzcGluX3VubG9jaygmY2ZpZHMtPmNmaWRfbGlzdF9sb2NrKTsK
IAkJKnJldF9jZmlkID0gY2ZpZDsKIAkJa2ZyZWUodXRmMTZfcGF0aCk7CkBAIC0zNjMsNiArMzY0
LDcgQEAgaW50IG9wZW5fY2FjaGVkX2Rpcih1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190
Y29uICp0Y29uLAogCQljZmlkLT5maWxlX2FsbF9pbmZvX2lzX3ZhbGlkID0gdHJ1ZTsKIAogCWNm
aWQtPnRpbWUgPSBqaWZmaWVzOworCWNmaWQtPmxhc3RfYWNjZXNzX3RpbWUgPSBqaWZmaWVzOwog
CXNwaW5fdW5sb2NrKCZjZmlkcy0+Y2ZpZF9saXN0X2xvY2spOwogCS8qIEF0IHRoaXMgcG9pbnQg
dGhlIGRpcmVjdG9yeSBoYW5kbGUgaXMgZnVsbHkgY2FjaGVkICovCiAJcmMgPSAwOwpAQCAtNzMw
LDggKzczMiw4IEBAIHN0YXRpYyB2b2lkIGNmaWRzX2xhdW5kcm9tYXRfd29ya2VyKHN0cnVjdCB3
b3JrX3N0cnVjdCAqd29yaykKIAogCXNwaW5fbG9jaygmY2ZpZHMtPmNmaWRfbGlzdF9sb2NrKTsK
IAlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoY2ZpZCwgcSwgJmNmaWRzLT5lbnRyaWVzLCBlbnRy
eSkgewotCQlpZiAoY2ZpZC0+dGltZSAmJgotCQkgICAgdGltZV9hZnRlcihqaWZmaWVzLCBjZmlk
LT50aW1lICsgSFogKiBkaXJfY2FjaGVfdGltZW91dCkpIHsKKwkJaWYgKGNmaWQtPmxhc3RfYWNj
ZXNzX3RpbWUgJiYKKwkJICAgIHRpbWVfYWZ0ZXIoamlmZmllcywgY2ZpZC0+bGFzdF9hY2Nlc3Nf
dGltZSArIEhaICogZGlyX2NhY2hlX3RpbWVvdXQpKSB7CiAJCQljZmlkLT5vbl9saXN0ID0gZmFs
c2U7CiAJCQlsaXN0X21vdmUoJmNmaWQtPmVudHJ5LCAmZW50cnkpOwogCQkJY2ZpZHMtPm51bV9l
bnRyaWVzLS07CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuaCBiL2ZzL3Nt
Yi9jbGllbnQvY2FjaGVkX2Rpci5oCmluZGV4IDA3MGIwOTYyZGU5OC4uMmMyNjI4ODFiN2IxIDEw
MDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuaAorKysgYi9mcy9zbWIvY2xpZW50
L2NhY2hlZF9kaXIuaApAQCAtMzksNiArMzksNyBAQCBzdHJ1Y3QgY2FjaGVkX2ZpZCB7CiAJYm9v
bCBvbl9saXN0OjE7CiAJYm9vbCBmaWxlX2FsbF9pbmZvX2lzX3ZhbGlkOjE7CiAJdW5zaWduZWQg
bG9uZyB0aW1lOyAvKiBqaWZmaWVzIG9mIHdoZW4gbGVhc2Ugd2FzIHRha2VuICovCisJdW5zaWdu
ZWQgbG9uZyBsYXN0X2FjY2Vzc190aW1lOyAvKiBqaWZmaWVzIG9mIHdoZW4gbGFzdCBhY2Nlc3Nl
ZCAqLwogCXN0cnVjdCBrcmVmIHJlZmNvdW50OwogCXN0cnVjdCBjaWZzX2ZpZCBmaWQ7CiAJc3Bp
bmxvY2tfdCBmaWRfbG9jazsKLS0gCjIuNDMuMAoK
--0000000000001c5eb1063ab884cd--
