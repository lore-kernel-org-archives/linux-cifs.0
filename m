Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42C3EB64DA
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jul 2023 03:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjGFDIO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jul 2023 23:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbjGFDHz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jul 2023 23:07:55 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83F11FD3
        for <linux-cifs@vger.kernel.org>; Wed,  5 Jul 2023 20:07:51 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b6ef9ed2fdso2076011fa.2
        for <linux-cifs@vger.kernel.org>; Wed, 05 Jul 2023 20:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688612870; x=1691204870;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xRcIoeHcYX10ooGxDx9e9VqhMIBnFuaqoYcbWd0M2DY=;
        b=AFZOK9f5IXm3U1O+dbhpIL+JaUUJcw85et958ZpAM7c5uq/m97P7WuQX0fkka06L+U
         YLp1Ogg64TaSQBknvA4ljBuWUq1Uic/sZ29lu5nOfg/ZhyXeB8wg6jq25VBVz2LpZf9E
         5/J5Tb4lw2cLAhBdxKc2mD1p2DQk5SbwyHkSztzqOjQ2zMANMigssMhB0KfCMFnDXWSn
         XD1V7EBLTDgsGcia33BcC53EmetULjrc0zYkVMRJWRNeOfM6BzjEBR51P8QxAORiX/bH
         NE9hUZqGr5fJFI/OaBdBS8OWSxzPmhqzqCZoEwZKJ5UnahovFeGZn7IE4DEQB7v1iUPn
         Yqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688612870; x=1691204870;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xRcIoeHcYX10ooGxDx9e9VqhMIBnFuaqoYcbWd0M2DY=;
        b=E2yif7ARi3oXujB/YsAJigHH617RTmRbfUnV67ORVkgWBMkSqtqfwEAdCCZT9nnXMb
         LnyiQ1QlPtGrsZvnzSwcu5RfHiTyo3gFr+KR2mm5kg1FW+brp6fPhjWIUmWL4MfGAncE
         vakPT2oXdFMMF7eOO+YuPz8h9/4f4RX8Uy97GtucwWS892TyxdMcePMrQWHo+yfFduya
         ikTyzooNZ4NL/lFI4y8v0G19/Sh4FojgWXDh3suxMHrIdDIZlAuj95CC1EW36xkRTncc
         MMEsQEAnxLQDQVlXNRNahdjDHvwEuSqUQMMkQDOQICV8wNtNK2+1glyeH2b5lCjD9tr/
         Uwhw==
X-Gm-Message-State: ABy/qLalsaJPb1pDlUZeiMqs6Tc1GRoQsqJ410hUAjmgb7EA+eAgMutO
        M8CiV+a8PoxE/Jfzb8CDgNemeTMMfTFaTnff7Il8/n5v
X-Google-Smtp-Source: APBJJlF6qGAcmtNIiGMaSyOLKJkuu9QscvtfGVYFXJGUy4Uuad0qWFyp0Wg0Q0zujlDidePI+lsKLr8CWWMoe4/BhQE=
X-Received: by 2002:a2e:9208:0:b0:2b6:f009:921a with SMTP id
 k8-20020a2e9208000000b002b6f009921amr321642ljg.13.1688612869701; Wed, 05 Jul
 2023 20:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230706023224.609324-1-lsahlber@redhat.com>
In-Reply-To: <20230706023224.609324-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Jul 2023 22:07:38 -0500
Message-ID: <CAH2r5mtAXKOOUN6BfVD25SzAq6TXfeRt+9u19i5o+f6oSgfGrA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add a laundromat thread for cached directories
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000043195f05ffc8d2a4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000043195f05ffc8d2a4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated to fix two checkpatch warnings (see attached) and tentatively
merged into for-next pending review/testing


On Wed, Jul 5, 2023 at 9:32=E2=80=AFPM Ronnie Sahlberg <lsahlber@redhat.com=
> wrote:
>
> and drop cached directories after 30 seconds
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/smb/client/cached_dir.c | 67 ++++++++++++++++++++++++++++++++++++++
>  fs/smb/client/cached_dir.h |  1 +
>  2 files changed, 68 insertions(+)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index bfc964b36c72..f567eea0a456 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -568,6 +568,53 @@ static void free_cached_dir(struct cached_fid *cfid)
>         kfree(cfid);
>  }
>
> +static int
> +cifs_cfids_laundromat_thread(void *p)
> +{
> +       struct cached_fids *cfids =3D p;
> +       struct cached_fid *cfid, *q;
> +       struct list_head entry;
> +
> +       while (!kthread_should_stop()) {
> +               ssleep(1);
> +               INIT_LIST_HEAD(&entry);
> +               if (kthread_should_stop())
> +                       return 0;
> +               spin_lock(&cfids->cfid_list_lock);
> +               list_for_each_entry_safe(cfid, q, &cfids->entries, entry)=
 {
> +                       if (jiffies > cfid->time + HZ * 30) {
> +                               list_del(&cfid->entry);
> +                               list_add(&cfid->entry, &entry);
> +                               cfids->num_entries--;
> +                       }
> +               }
> +               spin_unlock(&cfids->cfid_list_lock);
> +
> +               list_for_each_entry_safe(cfid, q, &entry, entry) {
> +                       cfid->on_list =3D false;
> +                       list_del(&cfid->entry);
> +                       /*
> +                        * Cancel, and wait for the work to finish in
> +                        * case we are racing with it.
> +                        */
> +                       cancel_work_sync(&cfid->lease_break);
> +                       if (cfid->has_lease) {
> +                               /*
> +                                * We lease has not yet been cancelled fr=
om
> +                                * the server so we need to drop the refe=
rence.
> +                                */
> +                               spin_lock(&cfids->cfid_list_lock);
> +                               cfid->has_lease =3D false;
> +                               spin_unlock(&cfids->cfid_list_lock);
> +                               kref_put(&cfid->refcount, smb2_close_cach=
ed_fid);
> +                       }
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +
>  struct cached_fids *init_cached_dirs(void)
>  {
>         struct cached_fids *cfids;
> @@ -577,6 +624,20 @@ struct cached_fids *init_cached_dirs(void)
>                 return NULL;
>         spin_lock_init(&cfids->cfid_list_lock);
>         INIT_LIST_HEAD(&cfids->entries);
> +
> +       /*
> +        * since we're in a cifs function already, we know that
> +        * this will succeed. No need for try_module_get().
> +        */
> +       __module_get(THIS_MODULE);
> +       cfids->laundromat =3D kthread_run(cifs_cfids_laundromat_thread,
> +                                 cfids, "cifsd-cfid-laundromat");
> +       if (IS_ERR(cfids->laundromat)) {
> +               cifs_dbg(VFS, "Failed to start cfids laundromat thread.\n=
");
> +               kfree(cfids);
> +               module_put(THIS_MODULE);
> +               return NULL;
> +       }
>         return cfids;
>  }
>
> @@ -589,6 +650,12 @@ void free_cached_dirs(struct cached_fids *cfids)
>         struct cached_fid *cfid, *q;
>         LIST_HEAD(entry);
>
> +       if (cfids->laundromat) {
> +               kthread_stop(cfids->laundromat);
> +               cfids->laundromat =3D NULL;
> +               module_put(THIS_MODULE);
> +       }
> +
>         spin_lock(&cfids->cfid_list_lock);
>         list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
>                 cfid->on_list =3D false;
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index 2f4e764c9ca9..facc9b154d00 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -57,6 +57,7 @@ struct cached_fids {
>         spinlock_t cfid_list_lock;
>         int num_entries;
>         struct list_head entries;
> +       struct task_struct *laundromat;
>  };
>
>  extern struct cached_fids *init_cached_dirs(void);
> --
> 2.35.3
>


--=20
Thanks,

Steve

--00000000000043195f05ffc8d2a4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Add-a-laundromat-thread-for-cached-directories.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Add-a-laundromat-thread-for-cached-directories.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ljqkhm5f0>
X-Attachment-Id: f_ljqkhm5f0

RnJvbSBjYzllZDI2ODQ4ZjcyNDA2NWFiYTUwNjQ3NTQwZTVlYmU2ZTBkM2U5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFRodSwgNiBKdWwgMjAyMyAxMjozMjoyNCArMTAwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IEFkZCBhIGxhdW5kcm9tYXQgdGhyZWFkIGZvciBjYWNoZWQgZGlyZWN0b3JpZXMKCmFuZCBk
cm9wIGNhY2hlZCBkaXJlY3RvcmllcyBhZnRlciAzMCBzZWNvbmRzCgpTaWduZWQtb2ZmLWJ5OiBS
b25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZl
IEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2NhY2hl
ZF9kaXIuYyB8IDY3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiBmcy9z
bWIvY2xpZW50L2NhY2hlZF9kaXIuaCB8ICAxICsKIDIgZmlsZXMgY2hhbmdlZCwgNjggaW5zZXJ0
aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jIGIvZnMvc21i
L2NsaWVudC9jYWNoZWRfZGlyLmMKaW5kZXggYmZjOTY0YjM2YzcyLi5mNTY3ZWVhMGE0NTYgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jCisrKyBiL2ZzL3NtYi9jbGllbnQv
Y2FjaGVkX2Rpci5jCkBAIC01NjgsNiArNTY4LDUzIEBAIHN0YXRpYyB2b2lkIGZyZWVfY2FjaGVk
X2RpcihzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCkKIAlrZnJlZShjZmlkKTsKIH0KIAorc3RhdGlj
IGludAorY2lmc19jZmlkc19sYXVuZHJvbWF0X3RocmVhZCh2b2lkICpwKQoreworCXN0cnVjdCBj
YWNoZWRfZmlkcyAqY2ZpZHMgPSBwOworCXN0cnVjdCBjYWNoZWRfZmlkICpjZmlkLCAqcTsKKwlz
dHJ1Y3QgbGlzdF9oZWFkIGVudHJ5OworCisJd2hpbGUgKCFrdGhyZWFkX3Nob3VsZF9zdG9wKCkp
IHsKKwkJc3NsZWVwKDEpOworCQlJTklUX0xJU1RfSEVBRCgmZW50cnkpOworCQlpZiAoa3RocmVh
ZF9zaG91bGRfc3RvcCgpKQorCQkJcmV0dXJuIDA7CisJCXNwaW5fbG9jaygmY2ZpZHMtPmNmaWRf
bGlzdF9sb2NrKTsKKwkJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGNmaWQsIHEsICZjZmlkcy0+
ZW50cmllcywgZW50cnkpIHsKKwkJCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIGNmaWQtPnRpbWUg
KyBIWiAqIDMwKSB7CisJCQkJbGlzdF9kZWwoJmNmaWQtPmVudHJ5KTsKKwkJCQlsaXN0X2FkZCgm
Y2ZpZC0+ZW50cnksICZlbnRyeSk7CisJCQkJY2ZpZHMtPm51bV9lbnRyaWVzLS07CisJCQl9CisJ
CX0KKwkJc3Bpbl91bmxvY2soJmNmaWRzLT5jZmlkX2xpc3RfbG9jayk7CisKKwkJbGlzdF9mb3Jf
ZWFjaF9lbnRyeV9zYWZlKGNmaWQsIHEsICZlbnRyeSwgZW50cnkpIHsKKwkJCWNmaWQtPm9uX2xp
c3QgPSBmYWxzZTsKKwkJCWxpc3RfZGVsKCZjZmlkLT5lbnRyeSk7CisJCQkvKgorCQkJICogQ2Fu
Y2VsLCBhbmQgd2FpdCBmb3IgdGhlIHdvcmsgdG8gZmluaXNoIGluCisJCQkgKiBjYXNlIHdlIGFy
ZSByYWNpbmcgd2l0aCBpdC4KKwkJCSAqLworCQkJY2FuY2VsX3dvcmtfc3luYygmY2ZpZC0+bGVh
c2VfYnJlYWspOworCQkJaWYgKGNmaWQtPmhhc19sZWFzZSkgeworCQkJCS8qCisJCQkJICogV2Ug
bGVhc2UgaGFzIG5vdCB5ZXQgYmVlbiBjYW5jZWxsZWQgZnJvbQorCQkJCSAqIHRoZSBzZXJ2ZXIg
c28gd2UgbmVlZCB0byBkcm9wIHRoZSByZWZlcmVuY2UuCisJCQkJICovCisJCQkJc3Bpbl9sb2Nr
KCZjZmlkcy0+Y2ZpZF9saXN0X2xvY2spOworCQkJCWNmaWQtPmhhc19sZWFzZSA9IGZhbHNlOwor
CQkJCXNwaW5fdW5sb2NrKCZjZmlkcy0+Y2ZpZF9saXN0X2xvY2spOworCQkJCWtyZWZfcHV0KCZj
ZmlkLT5yZWZjb3VudCwgc21iMl9jbG9zZV9jYWNoZWRfZmlkKTsKKwkJCX0KKwkJfQorCX0KKwor
CXJldHVybiAwOworfQorCisKIHN0cnVjdCBjYWNoZWRfZmlkcyAqaW5pdF9jYWNoZWRfZGlycyh2
b2lkKQogewogCXN0cnVjdCBjYWNoZWRfZmlkcyAqY2ZpZHM7CkBAIC01NzcsNiArNjI0LDIwIEBA
IHN0cnVjdCBjYWNoZWRfZmlkcyAqaW5pdF9jYWNoZWRfZGlycyh2b2lkKQogCQlyZXR1cm4gTlVM
TDsKIAlzcGluX2xvY2tfaW5pdCgmY2ZpZHMtPmNmaWRfbGlzdF9sb2NrKTsKIAlJTklUX0xJU1Rf
SEVBRCgmY2ZpZHMtPmVudHJpZXMpOworCisJLyoKKwkgKiBzaW5jZSB3ZSdyZSBpbiBhIGNpZnMg
ZnVuY3Rpb24gYWxyZWFkeSwgd2Uga25vdyB0aGF0CisJICogdGhpcyB3aWxsIHN1Y2NlZWQuIE5v
IG5lZWQgZm9yIHRyeV9tb2R1bGVfZ2V0KCkuCisJICovCisJX19tb2R1bGVfZ2V0KFRISVNfTU9E
VUxFKTsKKwljZmlkcy0+bGF1bmRyb21hdCA9IGt0aHJlYWRfcnVuKGNpZnNfY2ZpZHNfbGF1bmRy
b21hdF90aHJlYWQsCisJCQkJICBjZmlkcywgImNpZnNkLWNmaWQtbGF1bmRyb21hdCIpOworCWlm
IChJU19FUlIoY2ZpZHMtPmxhdW5kcm9tYXQpKSB7CisJCWNpZnNfZGJnKFZGUywgIkZhaWxlZCB0
byBzdGFydCBjZmlkcyBsYXVuZHJvbWF0IHRocmVhZC5cbiIpOworCQlrZnJlZShjZmlkcyk7CisJ
CW1vZHVsZV9wdXQoVEhJU19NT0RVTEUpOworCQlyZXR1cm4gTlVMTDsKKwl9CiAJcmV0dXJuIGNm
aWRzOwogfQogCkBAIC01ODksNiArNjUwLDEyIEBAIHZvaWQgZnJlZV9jYWNoZWRfZGlycyhzdHJ1
Y3QgY2FjaGVkX2ZpZHMgKmNmaWRzKQogCXN0cnVjdCBjYWNoZWRfZmlkICpjZmlkLCAqcTsKIAlM
SVNUX0hFQUQoZW50cnkpOwogCisJaWYgKGNmaWRzLT5sYXVuZHJvbWF0KSB7CisJCWt0aHJlYWRf
c3RvcChjZmlkcy0+bGF1bmRyb21hdCk7CisJCWNmaWRzLT5sYXVuZHJvbWF0ID0gTlVMTDsKKwkJ
bW9kdWxlX3B1dChUSElTX01PRFVMRSk7CisJfQorCiAJc3Bpbl9sb2NrKCZjZmlkcy0+Y2ZpZF9s
aXN0X2xvY2spOwogCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShjZmlkLCBxLCAmY2ZpZHMtPmVu
dHJpZXMsIGVudHJ5KSB7CiAJCWNmaWQtPm9uX2xpc3QgPSBmYWxzZTsKZGlmZiAtLWdpdCBhL2Zz
L3NtYi9jbGllbnQvY2FjaGVkX2Rpci5oIGIvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmgKaW5k
ZXggMmY0ZTc2NGM5Y2E5Li5mYWNjOWIxNTRkMDAgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQv
Y2FjaGVkX2Rpci5oCisrKyBiL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5oCkBAIC01Nyw2ICs1
Nyw3IEBAIHN0cnVjdCBjYWNoZWRfZmlkcyB7CiAJc3BpbmxvY2tfdCBjZmlkX2xpc3RfbG9jazsK
IAlpbnQgbnVtX2VudHJpZXM7CiAJc3RydWN0IGxpc3RfaGVhZCBlbnRyaWVzOworCXN0cnVjdCB0
YXNrX3N0cnVjdCAqbGF1bmRyb21hdDsKIH07CiAKIGV4dGVybiBzdHJ1Y3QgY2FjaGVkX2ZpZHMg
KmluaXRfY2FjaGVkX2RpcnModm9pZCk7Ci0tIAoyLjM0LjEKCg==
--00000000000043195f05ffc8d2a4--
