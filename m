Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16641C83F01
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Aug 2023 05:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjH0FMo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Aug 2023 01:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjH0FMn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 27 Aug 2023 01:12:43 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3201BF
        for <linux-cifs@vger.kernel.org>; Sat, 26 Aug 2023 22:12:39 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2bcd7a207f7so31800771fa.3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Aug 2023 22:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693113158; x=1693717958;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=te0tCmhyJvqllLKSsV9ph8rZEfpv5ZujuK8WkWy2Hkc=;
        b=lDL9jCDI69S82u9tcdDVm8CR1BZt+tWlNDtw7GtE5taJt7qQopuIbdEZfals7Faz9K
         AvLzjuRdqczS5fmUteezxKlj1q4LVReBWeNuPKB9l9bYAJR2h8NUvUv8IF38hZKI+3Er
         up4z2hkPxOZu/bmx1g5fkGi5G0iTFMLfeL2G/2O0n3spifOsGxzUhj42VqoG/UlJw5ly
         KrfvQKFL/OmXsIgcpcf6OThBv3IC/E1HatqicepcpLP/S3ZmuDK1cEtnJEBV5G6hlXUj
         8V0aJKriL+XYdsk9OXX+JaFGPxeMaE8hInYFgu0RDg0zfYNC13rBuKp5BwxRn3wba20T
         j0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693113158; x=1693717958;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=te0tCmhyJvqllLKSsV9ph8rZEfpv5ZujuK8WkWy2Hkc=;
        b=TKFdDHDNtMRP0sDgQ0UrdWJUDuyRMcfCHolKp7SP15GGO+iqaH8HpNildvS6WsXgGz
         GgNKnaAyKLiwqANM5gR34KajfgMtP08JWqE/b8JOv9mm/nekN2gJmkxICdkdPOWHkzpe
         wVDko+hnlpAgtwpEFnEci7uV8L811Mwk6var/4/ml0j0qrImtofCJyDQq66iFXiVsDXr
         vHpmz9drvn5B8O2Ps/S67EJwwOkfC0rOl49P5esF2UaU39lngVXS4hLGBb8lTKa0OW9Y
         GK6Jm5aqsZc4TvuvyCG7AUGp1Ewcx3eoxNcwkiG2RpY85svMukeB7IjWktVrBERhHmNw
         EMlw==
X-Gm-Message-State: AOJu0YwIFX2IAO4g5PuidIDHLlG9bt+Myz1TJZZUaWEHdfbLE0hDVezS
        ABPwqPFEBtBlMzD70yBMbT9KxBd5h3ijpP92xMzYErCnzzxiKxf1
X-Google-Smtp-Source: AGHT+IHr8443w3l530CKAPvLY20946rraKFm00a7fPf3AmTFLwX2usx2e82PGITEytxd2xtNSabZeuJz0qpqxzeg6eI=
X-Received: by 2002:a2e:88cb:0:b0:2bc:be3c:9080 with SMTP id
 a11-20020a2e88cb000000b002bcbe3c9080mr13915988ljk.27.1693113157495; Sat, 26
 Aug 2023 22:12:37 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 27 Aug 2023 00:12:26 -0500
Message-ID: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
Subject: [PATCH][SMB3] allow controlling length of time directory entries are
 cached with dir leases
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000005149270603e0a062"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005149270603e0a062
Content-Type: text/plain; charset="UTF-8"

Currently with directory leases we cache directory contents for a fixed period
of time (default 30 seconds) but for many workloads this is too short.  Allow
configuring the maximum amount of time directory entries are cached when a
directory lease is held on that directory (and set default timeout to
60 seconds).
Add module load parm "max_dir_cache"

For example to set the timeout to 10 minutes you would do:

  echo 600 > /sys/module/cifs/parameters/max_dir_cache

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/cached_dir.c |  2 +-
 fs/smb/client/cifsfs.c     | 12 ++++++++++++
 fs/smb/client/cifsglob.h   |  1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 2d5e9a9d5b8b..e48a902efd52 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -582,7 +582,7 @@ cifs_cfids_laundromat_thread(void *p)
  return 0;
  spin_lock(&cfids->cfid_list_lock);
  list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
- if (time_after(jiffies, cfid->time + HZ * 30)) {
+ if (time_after(jiffies, cfid->time + HZ * max_dir_cache)) {
  list_del(&cfid->entry);
  list_add(&cfid->entry, &entry);
  cfids->num_entries--;
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index d49fd2bf71b0..7a89718d2a59 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -117,6 +117,10 @@ module_param(cifs_max_pending, uint, 0444);
 MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server for "
     "CIFS/SMB1 dialect (N/A for SMB3) "
     "Default: 32767 Range: 2 to 32767.");
+unsigned int max_dir_cache = 60;
+module_param(max_dir_cache, uint, 0644);
+MODULE_PARM_DESC(max_dir_cache, "Number of seconds to cache directory
contents for which we have a lease. Default: 60 "
+ "Range: 1 to 65000 seconds");
 #ifdef CONFIG_CIFS_STATS2
 unsigned int slow_rsp_threshold = 1;
 module_param(slow_rsp_threshold, uint, 0644);
@@ -1679,6 +1683,14 @@ init_cifs(void)
  CIFS_MAX_REQ);
  }

+ if (max_dir_cache < 1) {
+ max_dir_cache = 1;
+ cifs_dbg(VFS, "max_dir_cache timeout set to min of 1 second\n");
+ } else if (max_dir_cache > 65000) {
+ max_dir_cache = 65000;
+ cifs_dbg(VFS, "max_dir_cache timeout set to max of 65000 seconds\n");
+ }
+
  cifsiod_wq = alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
  if (!cifsiod_wq) {
  rc = -ENOMEM;
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 259e231f8b4f..7aeeaa260cce 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2016,6 +2016,7 @@ extern unsigned int CIFSMaxBufSize;  /* max size
not including hdr */
 extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 extern unsigned int cifs_min_small;  /* min size of small buf pool */
 extern unsigned int cifs_max_pending; /* MAX requests at once to server*/
+extern unsigned int max_dir_cache; /* max time for directory lease
caching of dir */
 extern bool disable_legacy_dialects;  /* forbid vers=1.0 and vers=2.0 mounts */
 extern atomic_t mid_count;


-- 
Thanks,

Steve

--0000000000005149270603e0a062
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-controlling-length-of-time-directory-entr.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-controlling-length-of-time-directory-entr.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_llsztr790>
X-Attachment-Id: f_llsztr790

RnJvbSBjNTE0M2NjZDU5YjM4ODIxZjVjMjA4ZDgzNWI4YjdmODYxNmNhNjMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMjYgQXVnIDIwMjMgMjM6NTk6MjUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhbGxvdyBjb250cm9sbGluZyBsZW5ndGggb2YgdGltZSBkaXJlY3RvcnkgZW50cmllcyBh
cmUKIGNhY2hlZCB3aXRoIGRpciBsZWFzZXMKCkN1cnJlbnRseSB3aXRoIGRpcmVjdG9yeSBsZWFz
ZXMgd2UgY2FjaGUgZGlyZWN0b3J5IGNvbnRlbnRzIGZvciBhIGZpeGVkIHBlcmlvZApvZiB0aW1l
IChkZWZhdWx0IDMwIHNlY29uZHMpIGJ1dCBmb3IgbWFueSB3b3JrbG9hZHMgdGhpcyBpcyB0b28g
c2hvcnQuICBBbGxvdwpjb25maWd1cmluZyB0aGUgbWF4aW11bSBhbW91bnQgb2YgdGltZSBkaXJl
Y3RvcnkgZW50cmllcyBhcmUgY2FjaGVkIHdoZW4gYQpkaXJlY3RvcnkgbGVhc2UgaXMgaGVsZCBv
biB0aGF0IGRpcmVjdG9yeS4gQWRkIG1vZHVsZSBsb2FkIHBhcm0gIm1heF9kaXJfY2FjaGUiCgpG
b3IgZXhhbXBsZSB0byBzZXQgdGhlIHRpbWVvdXQgdG8gMTAgbWludXRlcyB5b3Ugd291bGQgZG86
CgogIGVjaG8gNjAwID4gL3N5cy9tb2R1bGUvY2lmcy9wYXJhbWV0ZXJzL21heF9kaXJfY2FjaGUK
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0t
CiBmcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYyB8ICAyICstCiBmcy9zbWIvY2xpZW50L2NpZnNm
cy5jICAgICB8IDEyICsrKysrKysrKysrKwogZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oICAgfCAg
MSArCiAzIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRp
ZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYyBiL2ZzL3NtYi9jbGllbnQvY2Fj
aGVkX2Rpci5jCmluZGV4IDJkNWU5YTlkNWI4Yi4uZTQ4YTkwMmVmZDUyIDEwMDY0NAotLS0gYS9m
cy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYworKysgYi9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIu
YwpAQCAtNTgyLDcgKzU4Miw3IEBAIGNpZnNfY2ZpZHNfbGF1bmRyb21hdF90aHJlYWQodm9pZCAq
cCkKIAkJCXJldHVybiAwOwogCQlzcGluX2xvY2soJmNmaWRzLT5jZmlkX2xpc3RfbG9jayk7CiAJ
CWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShjZmlkLCBxLCAmY2ZpZHMtPmVudHJpZXMsIGVudHJ5
KSB7Ci0JCQlpZiAodGltZV9hZnRlcihqaWZmaWVzLCBjZmlkLT50aW1lICsgSFogKiAzMCkpIHsK
KwkJCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIGNmaWQtPnRpbWUgKyBIWiAqIG1heF9kaXJfY2Fj
aGUpKSB7CiAJCQkJbGlzdF9kZWwoJmNmaWQtPmVudHJ5KTsKIAkJCQlsaXN0X2FkZCgmY2ZpZC0+
ZW50cnksICZlbnRyeSk7CiAJCQkJY2ZpZHMtPm51bV9lbnRyaWVzLS07CmRpZmYgLS1naXQgYS9m
cy9zbWIvY2xpZW50L2NpZnNmcy5jIGIvZnMvc21iL2NsaWVudC9jaWZzZnMuYwppbmRleCBkNDlm
ZDJiZjcxYjAuLjdhODk3MThkMmE1OSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzZnMu
YworKysgYi9mcy9zbWIvY2xpZW50L2NpZnNmcy5jCkBAIC0xMTcsNiArMTE3LDEwIEBAIG1vZHVs
ZV9wYXJhbShjaWZzX21heF9wZW5kaW5nLCB1aW50LCAwNDQ0KTsKIE1PRFVMRV9QQVJNX0RFU0Mo
Y2lmc19tYXhfcGVuZGluZywgIlNpbXVsdGFuZW91cyByZXF1ZXN0cyB0byBzZXJ2ZXIgZm9yICIK
IAkJCQkgICAiQ0lGUy9TTUIxIGRpYWxlY3QgKE4vQSBmb3IgU01CMykgIgogCQkJCSAgICJEZWZh
dWx0OiAzMjc2NyBSYW5nZTogMiB0byAzMjc2Ny4iKTsKK3Vuc2lnbmVkIGludCBtYXhfZGlyX2Nh
Y2hlID0gNjA7Cittb2R1bGVfcGFyYW0obWF4X2Rpcl9jYWNoZSwgdWludCwgMDY0NCk7CitNT0RV
TEVfUEFSTV9ERVNDKG1heF9kaXJfY2FjaGUsICJOdW1iZXIgb2Ygc2Vjb25kcyB0byBjYWNoZSBk
aXJlY3RvcnkgY29udGVudHMgZm9yIHdoaWNoIHdlIGhhdmUgYSBsZWFzZS4gRGVmYXVsdDogNjAg
IgorCQkJCSAiUmFuZ2U6IDEgdG8gNjUwMDAgc2Vjb25kcyIpOwogI2lmZGVmIENPTkZJR19DSUZT
X1NUQVRTMgogdW5zaWduZWQgaW50IHNsb3dfcnNwX3RocmVzaG9sZCA9IDE7CiBtb2R1bGVfcGFy
YW0oc2xvd19yc3BfdGhyZXNob2xkLCB1aW50LCAwNjQ0KTsKQEAgLTE2NzksNiArMTY4MywxNCBA
QCBpbml0X2NpZnModm9pZCkKIAkJCSBDSUZTX01BWF9SRVEpOwogCX0KIAorCWlmIChtYXhfZGly
X2NhY2hlIDwgMSkgeworCQltYXhfZGlyX2NhY2hlID0gMTsKKwkJY2lmc19kYmcoVkZTLCAibWF4
X2Rpcl9jYWNoZSB0aW1lb3V0IHNldCB0byBtaW4gb2YgMSBzZWNvbmRcbiIpOworCX0gZWxzZSBp
ZiAobWF4X2Rpcl9jYWNoZSA+IDY1MDAwKSB7CisJCW1heF9kaXJfY2FjaGUgPSA2NTAwMDsKKwkJ
Y2lmc19kYmcoVkZTLCAibWF4X2Rpcl9jYWNoZSB0aW1lb3V0IHNldCB0byBtYXggb2YgNjUwMDAg
c2Vjb25kc1xuIik7CisJfQorCiAJY2lmc2lvZF93cSA9IGFsbG9jX3dvcmtxdWV1ZSgiY2lmc2lv
ZCIsIFdRX0ZSRUVaQUJMRXxXUV9NRU1fUkVDTEFJTSwgMCk7CiAJaWYgKCFjaWZzaW9kX3dxKSB7
CiAJCXJjID0gLUVOT01FTTsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaCBi
L2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaAppbmRleCAyNTllMjMxZjhiNGYuLjdhZWVhYTI2MGNj
ZSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCisrKyBiL2ZzL3NtYi9jbGll
bnQvY2lmc2dsb2IuaApAQCAtMjAxNiw2ICsyMDE2LDcgQEAgZXh0ZXJuIHVuc2lnbmVkIGludCBD
SUZTTWF4QnVmU2l6ZTsgIC8qIG1heCBzaXplIG5vdCBpbmNsdWRpbmcgaGRyICovCiBleHRlcm4g
dW5zaWduZWQgaW50IGNpZnNfbWluX3JjdjsgICAgLyogbWluIHNpemUgb2YgYmlnIG50d3JrIGJ1
ZiBwb29sICovCiBleHRlcm4gdW5zaWduZWQgaW50IGNpZnNfbWluX3NtYWxsOyAgLyogbWluIHNp
emUgb2Ygc21hbGwgYnVmIHBvb2wgKi8KIGV4dGVybiB1bnNpZ25lZCBpbnQgY2lmc19tYXhfcGVu
ZGluZzsgLyogTUFYIHJlcXVlc3RzIGF0IG9uY2UgdG8gc2VydmVyKi8KK2V4dGVybiB1bnNpZ25l
ZCBpbnQgbWF4X2Rpcl9jYWNoZTsgLyogbWF4IHRpbWUgZm9yIGRpcmVjdG9yeSBsZWFzZSBjYWNo
aW5nIG9mIGRpciAqLwogZXh0ZXJuIGJvb2wgZGlzYWJsZV9sZWdhY3lfZGlhbGVjdHM7ICAvKiBm
b3JiaWQgdmVycz0xLjAgYW5kIHZlcnM9Mi4wIG1vdW50cyAqLwogZXh0ZXJuIGF0b21pY190IG1p
ZF9jb3VudDsKIAotLSAKMi4zNC4xCgo=
--0000000000005149270603e0a062--
