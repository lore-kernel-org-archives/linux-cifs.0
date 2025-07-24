Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E504561FFE
	for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 23:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753398347; cv=none; b=bFh2V88hJSx6mPHYBO69YBhkXomKlmj6TcgZp9wEN5hZTpyVdkEZX2ZXhQwCcCrAXRStffQrtmUJz1fRbFlr6jM7lu6Qi9G+kAzsAU/6bZyY3gPZJ1m9aU32py3rLdJaRdRxs13GzI7Xo/Byom3FPbN7JQc3NrcPx5Kcqo9mry4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753398347; c=relaxed/simple;
	bh=c8MuOVUoBDPOwMoQMr1sJ7OG04BCXU97USkLfFoIcSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fr/dIpKxEkJnmwtJGfeYtKpbp0KevgJb1fRlAs849gmVZVAFdZPCz3tJ8TfwoGUsG0p2rAAneX2TohJafPVU4zokJeU4SOGTWsudbvk+HCvC6t7y6sFSPxPpbWElkgNluPXMuKXjiIT6A7vH6jdE0x/3se1G/4NeHxOPkzT2N5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aYI7ueZT; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aYI7ueZT"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-702cbfe860cso14125036d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 16:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753398345; x=1754003145; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HSGD6TuOm1CKHi6e+RMH9mNVYpUs1EJtVV1SDIyVzeo=;
        b=aYI7ueZTc+MQ0bdKDyWmJ7xSOxbKxaDAXlMyoAg3VdlrMpKS5TDDXYm7AAK7zrm3T3
         pennQRO0oWD81QmETY3xcP55KSSi6kxsNS9x9jxUmpEApHp8mP0u3K/XBdrQrKr7kBFr
         gR0FBkj/yZTJTiZlgHwAAm3SqrPsdT06c2UJqmQZhIN6wwTq0IGPf1Vfh29aIXIUNkJi
         Ic4ucs0yfMdrlBQ8q+yhpEI/i1XJev6e6LRMlctJC+CdT4ROgNUM2B3MvSi9is/MNBGM
         CJuNquJO6OdGP5UGVhZvcWjcuUkzdHkgMLnnKJ5kmN3Kmk7FZQswGn7Sx0OF7Mu+6kyt
         LRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753398345; x=1754003145;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HSGD6TuOm1CKHi6e+RMH9mNVYpUs1EJtVV1SDIyVzeo=;
        b=WMBSoaYayhKbs+eGWaUGAZkhIfGTGlwGa5byhCsWOig6IO3I2sIc1DFrSQE5dWb6or
         2+afO8QTvtiRFQUpTqNjyTKVvp7L2ctr+5EvbBKMsd35/E6LsNxBm1Oo8rsOsxAqjhgL
         GOD63z63/G0OVuUSkSwwo769Sy54BRwuNE7klu8orHmggZ1SS+2gt82LE3qgUZ77QCQZ
         6FB0JqI9TjVs1bbshVVTy3jB4yAZzbkrixth/VvSEo1HJZd/+PULjzDPzwRBB6pls5Ja
         AGL5VqqKyn3vHx22Uu7/Eyjfr+l2cnblDs8sVvxes2cEeX47k90swaHjBr7MFZFjcivA
         rdIw==
X-Gm-Message-State: AOJu0YyagxyDEbt5/yPrMdsL0ep42jDvWJJYsmP/iqgxxni6md+/UPrC
	AC/BIxaXaR8KELksHq868xuNTizZu1Agur/jyFmkU0Ir7wwTZmotIELmpMa2wwS76tHZlhDBHbH
	k2LEZCxqwhr1Dl75RYNOOsg7Y6SLDUgE=
X-Gm-Gg: ASbGnctnW8LpNwa2NWQrj7mlK6A9MftMY7zR3XhYwc+wHapRwXCl6fmWZCtiNKzNgsI
	vtnmXGmwU3PJwzHXvVFJz7DyzDmxMejEJrFfO4q8GDUvRvFx1zxdiKhKyjGJn85xHA6HK1MYKW6
	oyvno2pu2Vilbegh0KImO3WK5QhsAcYJ0Sa4gCCOy6iqgxkMhqv1N5erN/GFnLnfV/fdlzsO4tM
	wCJgyNXX6p0A7S5rx0+xOxtcShuS/m98/F4UKdYIHHZ/hNdUAY=
X-Google-Smtp-Source: AGHT+IF7TmJCvKdRJacDlJn1TFle5nVF3vrHGDwuHtzl3TjAyUpFfRLqYPkmivxes96jJ39LFkFrwKTjsspLvb1zEnc=
X-Received: by 2002:a05:6214:c67:b0:6f5:40d5:e51 with SMTP id
 6a1803df08f44-707005136bbmr129761536d6.11.1753398344552; Thu, 24 Jul 2025
 16:05:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250604101829.832577-1-sprasad@microsoft.com> <20250604101829.832577-7-sprasad@microsoft.com>
In-Reply-To: <20250604101829.832577-7-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 24 Jul 2025 18:05:32 -0500
X-Gm-Features: Ac12FXwbOl-wu2pUkmkDSvfh8pZSXisEXOl3dBASll5GtuAg1CoZhNUiZ9CEpPA
Message-ID: <CAH2r5mvHV8Y2tO156TmQ7ymrgaiFPZSsZdzSNWvEreDq2p-G=A@mail.gmail.com>
Subject: Re: [PATCH 7/7] cifs: add new field to track the last access time of cfid
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	meetakshisetiyaoss@gmail.com, pc@manguebit.com, paul@darkrain42.org, 
	henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000007a5ea4063ab4dd9f"

--0000000000007a5ea4063ab4dd9f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Rebased version of patch attached. See attached. Let me know if any
objections.  It solves an obvious important issue (we shouldn't be
timing out directory leases if they are the most recently used ones)


On Wed, Jun 4, 2025 at 5:18=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> The handlecache code today tracks the time at which dir lease was
> acquired and the laundromat thread uses that to check for old
> entries to cleanup.
>
> However, if a directory is actively accessed, it should not
> be chosen to expire first.
>
> This change adds a new last_access_time field to cfid and
> uses that to decide expiry of the cfid.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c | 6 ++++--
>  fs/smb/client/cached_dir.h | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 4abf5bbd8baf..d432a40f902e 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -213,6 +213,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon,
>          */
>         spin_lock(&cfid->fid_lock);
>         if (cfid->has_lease && cfid->time) {
> +               cfid->last_access_time =3D jiffies;
>                 spin_unlock(&cfid->fid_lock);
>                 mutex_unlock(&cfid->cfid_mutex);
>                 *ret_cfid =3D cfid;
> @@ -365,6 +366,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon,
>         cfid->tcon =3D tcon;
>         cfid->is_open =3D true;
>         cfid->time =3D jiffies;
> +       cfid->last_access_time =3D jiffies;
>         spin_unlock(&cfid->fid_lock);
>
>  oshr_free:
> @@ -741,8 +743,8 @@ static void cfids_laundromat_worker(struct work_struc=
t *work)
>         spin_lock(&cfids->cfid_list_lock);
>         list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
>                 spin_lock(&cfid->fid_lock);
> -               if (cfid->time &&
> -                   time_after(jiffies, cfid->time + HZ * dir_cache_timeo=
ut)) {
> +               if (cfid->last_access_time &&
> +                   time_after(jiffies, cfid->last_access_time + HZ * dir=
_cache_timeout)) {
>                         cfid->on_list =3D false;
>                         list_move(&cfid->entry, &entry);
>                         cfids->num_entries--;
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index 93c936af2253..6d4b9413aa67 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -39,6 +39,7 @@ struct cached_fid {
>         bool on_list:1;
>         bool file_all_info_is_valid:1;
>         unsigned long time; /* jiffies of when lease was taken */
> +       unsigned long last_access_time; /* jiffies of when last accessed =
*/
>         struct kref refcount;
>         struct cifs_fid fid;
>         spinlock_t fid_lock;
> --
> 2.43.0
>


--=20
Thanks,

Steve

--0000000000007a5ea4063ab4dd9f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="rebased-add-new-field-to-track-last-access-time-of-cfid.diff"
Content-Disposition: attachment; 
	filename="rebased-add-new-field-to-track-last-access-time-of-cfid.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mdi038h80>
X-Attachment-Id: f_mdi038h80

ZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jIGIvZnMvc21iL2NsaWVudC9j
YWNoZWRfZGlyLmMKaW5kZXggMTE2NDcwYjFkZmVhLi5iNjlkYWViMTMwMWIgMTAwNjQ0Ci0tLSBh
L2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rp
ci5jCkBAIC0xOTUsNiArMTk1LDcgQEAgaW50IG9wZW5fY2FjaGVkX2Rpcih1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCSAqIGZyb20gQGNmaWRzLT5lbnRyaWVzLiAg
Q2FsbGVyIHdpbGwgcHV0IGxhc3QgcmVmZXJlbmNlIGlmIHRoZSBsYXR0ZXIuCiAJICovCiAJaWYg
KGNmaWQtPmhhc19sZWFzZSAmJiBjZmlkLT50aW1lKSB7CisJCWNmaWQtPmxhc3RfYWNjZXNzX3Rp
bWUgPSBqaWZmaWVzOwogCQlzcGluX3VubG9jaygmY2ZpZHMtPmNmaWRfbGlzdF9sb2NrKTsKIAkJ
KnJldF9jZmlkID0gY2ZpZDsKIAkJa2ZyZWUodXRmMTZfcGF0aCk7CkBAIC0zNjMsNiArMzY0LDcg
QEAgaW50IG9wZW5fY2FjaGVkX2Rpcih1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQljZmlkLT5maWxlX2FsbF9pbmZvX2lzX3ZhbGlkID0gdHJ1ZTsKIAogCWNmaWQt
PnRpbWUgPSBqaWZmaWVzOworCWNmaWQtPmxhc3RfYWNjZXNzX3RpbWUgPSBqaWZmaWVzOwogCXNw
aW5fdW5sb2NrKCZjZmlkcy0+Y2ZpZF9saXN0X2xvY2spOwogCS8qIEF0IHRoaXMgcG9pbnQgdGhl
IGRpcmVjdG9yeSBoYW5kbGUgaXMgZnVsbHkgY2FjaGVkICovCiAJcmMgPSAwOwpAQCAtNzMwLDgg
KzczMiw4IEBAIHN0YXRpYyB2b2lkIGNmaWRzX2xhdW5kcm9tYXRfd29ya2VyKHN0cnVjdCB3b3Jr
X3N0cnVjdCAqd29yaykKIAogCXNwaW5fbG9jaygmY2ZpZHMtPmNmaWRfbGlzdF9sb2NrKTsKIAls
aXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoY2ZpZCwgcSwgJmNmaWRzLT5lbnRyaWVzLCBlbnRyeSkg
ewotCQlpZiAoY2ZpZC0+dGltZSAmJgotCQkgICAgdGltZV9hZnRlcihqaWZmaWVzLCBjZmlkLT50
aW1lICsgSFogKiBkaXJfY2FjaGVfdGltZW91dCkpIHsKKwkJaWYgKGNmaWQtPmxhc3RfYWNjZXNz
X3RpbWUgJiYKKwkJICAgIHRpbWVfYWZ0ZXIoamlmZmllcywgY2ZpZC0+bGFzdF9hY2Nlc3NfdGlt
ZSArIEhaICogZGlyX2NhY2hlX3RpbWVvdXQpKSB7CiAJCQljZmlkLT5vbl9saXN0ID0gZmFsc2U7
CiAJCQlsaXN0X21vdmUoJmNmaWQtPmVudHJ5LCAmZW50cnkpOwogCQkJY2ZpZHMtPm51bV9lbnRy
aWVzLS07CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuaCBiL2ZzL3NtYi9j
bGllbnQvY2FjaGVkX2Rpci5oCmluZGV4IDA3MGIwOTYyZGU5OC4uMmMyNjI4ODFiN2IxIDEwMDY0
NAotLS0gYS9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuaAorKysgYi9mcy9zbWIvY2xpZW50L2Nh
Y2hlZF9kaXIuaApAQCAtMzksNiArMzksNyBAQCBzdHJ1Y3QgY2FjaGVkX2ZpZCB7CiAJYm9vbCBv
bl9saXN0OjE7CiAJYm9vbCBmaWxlX2FsbF9pbmZvX2lzX3ZhbGlkOjE7CiAJdW5zaWduZWQgbG9u
ZyB0aW1lOyAvKiBqaWZmaWVzIG9mIHdoZW4gbGVhc2Ugd2FzIHRha2VuICovCisJdW5zaWduZWQg
bG9uZyBsYXN0X2FjY2Vzc190aW1lOyAvKiBqaWZmaWVzIG9mIHdoZW4gbGFzdCBhY2Nlc3NlZCAq
LwogCXN0cnVjdCBrcmVmIHJlZmNvdW50OwogCXN0cnVjdCBjaWZzX2ZpZCBmaWQ7CiAJc3Bpbmxv
Y2tfdCBmaWRfbG9jazsK
--0000000000007a5ea4063ab4dd9f--
