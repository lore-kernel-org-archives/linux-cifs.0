Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDF6C83F2B
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Aug 2023 03:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241914AbjHaDw6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Aug 2023 23:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241778AbjHaDw4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Aug 2023 23:52:56 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F51CD8
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 20:52:53 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2bceb02fd2bso7364641fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 20:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693453971; x=1694058771; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mBb/EwYHsM5NA82QuLz6UrHUFVcW7x/nObYGvg4mwlM=;
        b=bbjKD1VVfGPl3hFEFFH9MgmDf9bTiZC5PaB+vqhOKngyt0MJgKar1sS3tmyjqIR1nG
         hHhphiy8Dye6pyiJ1Ks27ugGFUb/SE4kOo3JDezav5ZFzY9je8EX1bm0J+ilsuqcbuZX
         o83F0X2L9ejPjbyQveWiy0R+fIxZe0RaNrqQMjkEWDUlE3RElJhIb+gX7irphU6dBfNv
         0JKVKiLdaVZ8WKGSqVHHfw7wctPgfqm1LUK4KuTVAbeJc94dysUcmqsS/nkpFyyqUOvQ
         +iNnm8xHhCE9L+sw2xonnx1CMUHd3kNUWoAuM8nVvg4skIyDQBy9yCsz0mjaQIB3HzCa
         nIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693453971; x=1694058771;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mBb/EwYHsM5NA82QuLz6UrHUFVcW7x/nObYGvg4mwlM=;
        b=CC86yXniSkNl851FcGja1cJpHB+GPxHCk68WqxlD8TpDVZNemrcks4udGfJfQnKCV0
         SVAkoIbhmOQvm+QWx9DlA9k8xyEjG0Nsz46LXi7C1Smpf+vPcdD5PPaTcYoMIjkLO+Sx
         c73JwBndQT0z6NyIeXGDtjcfu4EAGNC4QZruVvh0FT0n4jP+Ksk2B5T/M/FX7qmvIPDh
         +aGUhsnafiTRtgmvHK6j3q6c9HIDHOdrbTQ/kBCItT6aKjN6HoCoIP75BqkwQLc7Ur4J
         /f2rmj5SimMoqMJgidsFqlaB+lO30USTlwMN7B4j6EPG8OnR2X1kL8VmwbcBnrXIbd5u
         7SHg==
X-Gm-Message-State: AOJu0YwbQPaMfbZuKeNKAYbpSrVkgLwUn2cmdNzyXYW3u62ewWfLyyLR
        bwIsiiQ4P8L9aHyHeGY61NiIM39mr/urZApmPRS10DJEywYywNR9
X-Google-Smtp-Source: AGHT+IHKOAqssY/wKMQ+EQqZpg7Lm+1FTA0/Rm/Aa9OssoiqcRmPwNu8K644Gx7NOFKtMUrzSjNb/RaaizWTe1cK7Ig=
X-Received: by 2002:a2e:b048:0:b0:2bc:ffbc:c1b4 with SMTP id
 d8-20020a2eb048000000b002bcffbcc1b4mr3436872ljl.9.1693453970798; Wed, 30 Aug
 2023 20:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 30 Aug 2023 22:52:39 -0500
Message-ID: <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow controlling length of time directory entries
 are cached with dir leases
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000005f9bcb06042ffa06"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005f9bcb06042ffa06
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated patch with Barath's suggestion of renaming it from
/sys/module/cifs/parameters/max_dir_cache to
/sys/module/cifs/parameters/dir_cache_timeout and also changed it so
if set to zero we disable
directory entry caching.

See attached.

On Sun, Aug 27, 2023 at 12:12=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> Currently with directory leases we cache directory contents for a fixed p=
eriod
> of time (default 30 seconds) but for many workloads this is too short.  A=
llow
> configuring the maximum amount of time directory entries are cached when =
a
> directory lease is held on that directory (and set default timeout to
> 60 seconds).
> Add module load parm "max_dir_cache"
>
> For example to set the timeout to 10 minutes you would do:
>
>   echo 600 > /sys/module/cifs/parameters/max_dir_cache
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c |  2 +-
>  fs/smb/client/cifsfs.c     | 12 ++++++++++++
>  fs/smb/client/cifsglob.h   |  1 +
>  3 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 2d5e9a9d5b8b..e48a902efd52 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -582,7 +582,7 @@ cifs_cfids_laundromat_thread(void *p)
>   return 0;
>   spin_lock(&cfids->cfid_list_lock);
>   list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> - if (time_after(jiffies, cfid->time + HZ * 30)) {
> + if (time_after(jiffies, cfid->time + HZ * max_dir_cache)) {
>   list_del(&cfid->entry);
>   list_add(&cfid->entry, &entry);
>   cfids->num_entries--;
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index d49fd2bf71b0..7a89718d2a59 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -117,6 +117,10 @@ module_param(cifs_max_pending, uint, 0444);
>  MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server for =
"
>      "CIFS/SMB1 dialect (N/A for SMB3) "
>      "Default: 32767 Range: 2 to 32767.");
> +unsigned int max_dir_cache =3D 60;
> +module_param(max_dir_cache, uint, 0644);
> +MODULE_PARM_DESC(max_dir_cache, "Number of seconds to cache directory
> contents for which we have a lease. Default: 60 "
> + "Range: 1 to 65000 seconds");
>  #ifdef CONFIG_CIFS_STATS2
>  unsigned int slow_rsp_threshold =3D 1;
>  module_param(slow_rsp_threshold, uint, 0644);
> @@ -1679,6 +1683,14 @@ init_cifs(void)
>   CIFS_MAX_REQ);
>   }
>
> + if (max_dir_cache < 1) {
> + max_dir_cache =3D 1;
> + cifs_dbg(VFS, "max_dir_cache timeout set to min of 1 second\n");
> + } else if (max_dir_cache > 65000) {
> + max_dir_cache =3D 65000;
> + cifs_dbg(VFS, "max_dir_cache timeout set to max of 65000 seconds\n");
> + }
> +
>   cifsiod_wq =3D alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_RECLAIM, =
0);
>   if (!cifsiod_wq) {
>   rc =3D -ENOMEM;
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 259e231f8b4f..7aeeaa260cce 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -2016,6 +2016,7 @@ extern unsigned int CIFSMaxBufSize;  /* max size
> not including hdr */
>  extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool *=
/
>  extern unsigned int cifs_min_small;  /* min size of small buf pool */
>  extern unsigned int cifs_max_pending; /* MAX requests at once to server*=
/
> +extern unsigned int max_dir_cache; /* max time for directory lease
> caching of dir */
>  extern bool disable_legacy_dialects;  /* forbid vers=3D1.0 and vers=3D2.=
0 mounts */
>  extern atomic_t mid_count;
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--0000000000005f9bcb06042ffa06
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-controlling-length-of-time-directory-entr.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-controlling-length-of-time-directory-entr.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_llymrcmy0>
X-Attachment-Id: f_llymrcmy0

RnJvbSBjNWUxOGY0ZDVlMmExNGNlYjUxMzE0MDY3OTg0ZDQ4ODgyOWU0NWNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMzAgQXVnIDIwMjMgMjI6NDg6NDEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhbGxvdyBjb250cm9sbGluZyBsZW5ndGggb2YgdGltZSBkaXJlY3RvcnkgZW50cmllcyAg
YXJlCiBjYWNoZWQgd2l0aCBkaXIgbGVhc2VzCgpDdXJyZW50bHkgd2l0aCBkaXJlY3RvcnkgbGVh
c2VzIHdlIGNhY2hlIGRpcmVjdG9yeSBjb250ZW50cyBmb3IgYSBmaXhlZCBwZXJpb2QKb2YgdGlt
ZSAoZGVmYXVsdCAzMCBzZWNvbmRzKSBidXQgZm9yIG1hbnkgd29ya2xvYWRzIHRoaXMgaXMgdG9v
IHNob3J0LiAgQWxsb3cKY29uZmlndXJpbmcgdGhlIG1heGltdW0gYW1vdW50IG9mIHRpbWUgZGly
ZWN0b3J5IGVudHJpZXMgYXJlIGNhY2hlZCB3aGVuIGEKZGlyZWN0b3J5IGxlYXNlIGlzIGhlbGQg
b24gdGhhdCBkaXJlY3RvcnkuIEFkZCBtb2R1bGUgbG9hZCBwYXJtICJtYXhfZGlyX2NhY2hlIgoK
Rm9yIGV4YW1wbGUgdG8gc2V0IHRoZSB0aW1lb3V0IHRvIDEwIG1pbnV0ZXMgeW91IHdvdWxkIGRv
OgoKICBlY2hvIDYwMCA+IC9zeXMvbW9kdWxlL2NpZnMvcGFyYW1ldGVycy9kaXJfY2FjaGVfdGlt
ZW91dAoKb3IgdG8gZGlzYWJsZSBjYWNoaW5nIGRpcmVjdG9yeSBjb250ZW50czoKCiAgZWNobyAw
ID4gL3N5cy9tb2R1bGUvY2lmcy9wYXJhbWV0ZXJzL2Rpcl9jYWNoZV90aW1lb3V0CgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21i
L2NsaWVudC9jYWNoZWRfZGlyLmMgfCAgNCArKy0tCiBmcy9zbWIvY2xpZW50L2NpZnNmcy5jICAg
ICB8IDEwICsrKysrKysrKysKIGZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaCAgIHwgIDEgKwogMyBm
aWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jIGIvZnMvc21iL2NsaWVudC9jYWNoZWRfZGly
LmMKaW5kZXggMmQ1ZTlhOWQ1YjhiLi45ZDg0YzRhN2JkMGMgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9j
bGllbnQvY2FjaGVkX2Rpci5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jCkBAIC0x
NDUsNyArMTQ1LDcgQEAgaW50IG9wZW5fY2FjaGVkX2Rpcih1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAogCWNvbnN0IGNoYXIgKm5wYXRoOwogCiAJaWYgKHRjb24gPT0g
TlVMTCB8fCB0Y29uLT5jZmlkcyA9PSBOVUxMIHx8IHRjb24tPm5vaGFuZGxlY2FjaGUgfHwKLQkg
ICAgaXNfc21iMV9zZXJ2ZXIodGNvbi0+c2VzLT5zZXJ2ZXIpKQorCSAgICBpc19zbWIxX3NlcnZl
cih0Y29uLT5zZXMtPnNlcnZlcikgfHwgKGRpcl9jYWNoZV90aW1lb3V0ID09IDApKQogCQlyZXR1
cm4gLUVPUE5PVFNVUFA7CiAKIAlzZXMgPSB0Y29uLT5zZXM7CkBAIC01ODIsNyArNTgyLDcgQEAg
Y2lmc19jZmlkc19sYXVuZHJvbWF0X3RocmVhZCh2b2lkICpwKQogCQkJcmV0dXJuIDA7CiAJCXNw
aW5fbG9jaygmY2ZpZHMtPmNmaWRfbGlzdF9sb2NrKTsKIAkJbGlzdF9mb3JfZWFjaF9lbnRyeV9z
YWZlKGNmaWQsIHEsICZjZmlkcy0+ZW50cmllcywgZW50cnkpIHsKLQkJCWlmICh0aW1lX2FmdGVy
KGppZmZpZXMsIGNmaWQtPnRpbWUgKyBIWiAqIDMwKSkgeworCQkJaWYgKHRpbWVfYWZ0ZXIoamlm
ZmllcywgY2ZpZC0+dGltZSArIEhaICogZGlyX2NhY2hlX3RpbWVvdXQpKSB7CiAJCQkJbGlzdF9k
ZWwoJmNmaWQtPmVudHJ5KTsKIAkJCQlsaXN0X2FkZCgmY2ZpZC0+ZW50cnksICZlbnRyeSk7CiAJ
CQkJY2ZpZHMtPm51bV9lbnRyaWVzLS07CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNm
cy5jIGIvZnMvc21iL2NsaWVudC9jaWZzZnMuYwppbmRleCBkNDlmZDJiZjcxYjAuLmI5MmU5YTEz
ODQ0MyAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYworKysgYi9mcy9zbWIvY2xp
ZW50L2NpZnNmcy5jCkBAIC0xMTcsNiArMTE3LDEwIEBAIG1vZHVsZV9wYXJhbShjaWZzX21heF9w
ZW5kaW5nLCB1aW50LCAwNDQ0KTsKIE1PRFVMRV9QQVJNX0RFU0MoY2lmc19tYXhfcGVuZGluZywg
IlNpbXVsdGFuZW91cyByZXF1ZXN0cyB0byBzZXJ2ZXIgZm9yICIKIAkJCQkgICAiQ0lGUy9TTUIx
IGRpYWxlY3QgKE4vQSBmb3IgU01CMykgIgogCQkJCSAgICJEZWZhdWx0OiAzMjc2NyBSYW5nZTog
MiB0byAzMjc2Ny4iKTsKK3Vuc2lnbmVkIGludCBkaXJfY2FjaGVfdGltZW91dCA9IDYwOworbW9k
dWxlX3BhcmFtKGRpcl9jYWNoZV90aW1lb3V0LCB1aW50LCAwNjQ0KTsKK01PRFVMRV9QQVJNX0RF
U0MoZGlyX2NhY2hlX3RpbWVvdXQsICJOdW1iZXIgb2Ygc2Vjb25kcyB0byBjYWNoZSBkaXJlY3Rv
cnkgY29udGVudHMgZm9yIHdoaWNoIHdlIGhhdmUgYSBsZWFzZS4gRGVmYXVsdDogNjAgIgorCQkJ
CSAiUmFuZ2U6IDEgdG8gNjUwMDAgc2Vjb25kcywgMCB0byBkaXNhYmxlIGNhY2hpbmcgZGlyIGNv
bnRlbnRzIik7CiAjaWZkZWYgQ09ORklHX0NJRlNfU1RBVFMyCiB1bnNpZ25lZCBpbnQgc2xvd19y
c3BfdGhyZXNob2xkID0gMTsKIG1vZHVsZV9wYXJhbShzbG93X3JzcF90aHJlc2hvbGQsIHVpbnQs
IDA2NDQpOwpAQCAtMTY3OSw2ICsxNjgzLDEyIEBAIGluaXRfY2lmcyh2b2lkKQogCQkJIENJRlNf
TUFYX1JFUSk7CiAJfQogCisJLyogTGltaXQgbWF4IHRvIGFib3V0IDE4IGhvdXJzLCBhbmQgc2V0
dGluZyB0byB6ZXJvIGRpc2FibGVzIGRpcmVjdG9yeSBlbnRyeSBjYWNoaW5nICovCisJaWYgKGRp
cl9jYWNoZV90aW1lb3V0ID4gNjUwMDApIHsKKwkJZGlyX2NhY2hlX3RpbWVvdXQgPSA2NTAwMDsK
KwkJY2lmc19kYmcoVkZTLCAiZGlyX2NhY2hlX3RpbWVvdXQgc2V0IHRvIG1heCBvZiA2NTAwMCBz
ZWNvbmRzXG4iKTsKKwl9CisKIAljaWZzaW9kX3dxID0gYWxsb2Nfd29ya3F1ZXVlKCJjaWZzaW9k
IiwgV1FfRlJFRVpBQkxFfFdRX01FTV9SRUNMQUlNLCAwKTsKIAlpZiAoIWNpZnNpb2Rfd3EpIHsK
IAkJcmMgPSAtRU5PTUVNOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oIGIv
ZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCmluZGV4IDI1OWUyMzFmOGI0Zi4uNTAxNDI2ZWUzOWU3
IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKKysrIGIvZnMvc21iL2NsaWVu
dC9jaWZzZ2xvYi5oCkBAIC0yMDE2LDYgKzIwMTYsNyBAQCBleHRlcm4gdW5zaWduZWQgaW50IENJ
RlNNYXhCdWZTaXplOyAgLyogbWF4IHNpemUgbm90IGluY2x1ZGluZyBoZHIgKi8KIGV4dGVybiB1
bnNpZ25lZCBpbnQgY2lmc19taW5fcmN2OyAgICAvKiBtaW4gc2l6ZSBvZiBiaWcgbnR3cmsgYnVm
IHBvb2wgKi8KIGV4dGVybiB1bnNpZ25lZCBpbnQgY2lmc19taW5fc21hbGw7ICAvKiBtaW4gc2l6
ZSBvZiBzbWFsbCBidWYgcG9vbCAqLwogZXh0ZXJuIHVuc2lnbmVkIGludCBjaWZzX21heF9wZW5k
aW5nOyAvKiBNQVggcmVxdWVzdHMgYXQgb25jZSB0byBzZXJ2ZXIqLworZXh0ZXJuIHVuc2lnbmVk
IGludCBkaXJfY2FjaGVfdGltZW91dDsgLyogbWF4IHRpbWUgZm9yIGRpcmVjdG9yeSBsZWFzZSBj
YWNoaW5nIG9mIGRpciAqLwogZXh0ZXJuIGJvb2wgZGlzYWJsZV9sZWdhY3lfZGlhbGVjdHM7ICAv
KiBmb3JiaWQgdmVycz0xLjAgYW5kIHZlcnM9Mi4wIG1vdW50cyAqLwogZXh0ZXJuIGF0b21pY190
IG1pZF9jb3VudDsKIAotLSAKMi4zNC4xCgo=
--0000000000005f9bcb06042ffa06--
