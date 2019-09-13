Return-Path: <SRS0=frs6=XI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9FFC4CEC9
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 19:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F0072089F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 19:46:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="umwKejy5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388960AbfIMTqZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Sep 2019 15:46:25 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35658 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388766AbfIMTqZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Sep 2019 15:46:25 -0400
Received: by mail-io1-f66.google.com with SMTP id f4so64437549ion.2
        for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2019 12:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dkJ2hTJ1IvrzmNAvKPplHEs/0OEhA254r5D0GtN8oqk=;
        b=umwKejy5j6MamH3mwU8Ex1DCCV3y78bB1bv+GE6l2A47srTvrtEJXkIFoNJrQGuz8m
         f8jXhkmzufVCWwmdN7axw3BsF6+5pyHJJynu0TeZ9XjgtkVybfGTX14vPBE9yngrtRrk
         ElgS4GwjYDv89A8IGZZMuEtnkOCGe4sAmPTVFeQyld+I1lkAf13cKEwS6pzHYPTeVWH8
         3GsFfpPqvmijl6WEuZbOmmypooZoBg6vB1ITi5EbHbPA9lMsNJuxzt7f8FqqwXIAi5q1
         tWJI/OV5G0HrYZBK6sxIfakoSA6T8bB577Ht5a/4gkQh+D8cBD2IF2nBoFh/anP+L2XN
         odQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dkJ2hTJ1IvrzmNAvKPplHEs/0OEhA254r5D0GtN8oqk=;
        b=b/rJfntU1Mx75Jq2wghzsFsTOkKozC/avCauebAg8DXiT0+JYIXVzjbSiAsslfhn6o
         GfS0pv/JCA8dI8Qtan5CYTTkKka3p+Hk/y91IrGT1Wed4RyDueK8kRTA+49kV66GvVSJ
         aBDJ6aMN4muc5ky4rwF68oakPDt9H6LOaD0S7Jd6YuVNGuok2V/rioRftBX1j6Ezff1J
         sd7cpCLmxlPIqqFcWP9RLuXSk/KvW//p9/6GL9Oijrocv4qKUAgoz0bXtwaoxStr2QEK
         QjHmYgMLkqdNaCeGzvswtA5ggkuT0PpXv6g52jk0bp3L028eEa35z1I1LS3UpWdvJDm9
         tWTQ==
X-Gm-Message-State: APjAAAWbPP+wyFF52qOMS/BhkvzE141b0fLgwlfVy3Mh4wrY0dl9Zcjm
        2FuprDrSCh7hXFbjiyoTWsLrC6jY7uc5c/E4H3o=
X-Google-Smtp-Source: APXvYqym9WVnPtChEpjsHBp1rlWlXVdTQtpQIFsSKfRcCTJv9uTkkPVLEm7B3YbfTnbixibn+ct5nm8lGhc/O7Hm884=
X-Received: by 2002:a6b:ee17:: with SMTP id i23mr1811736ioh.168.1568403984020;
 Fri, 13 Sep 2019 12:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190913135510.GS20699@kadam>
In-Reply-To: <20190913135510.GS20699@kadam>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 13 Sep 2019 14:46:12 -0500
Message-ID: <CAH2r5msUK79ZjF2pthS8C+Ucz1Abkg3T=UJ85_4d43iyAMdOOA@mail.gmail.com>
Subject: Re: [cifs:for-next 31/31] fs/cifs/smb2ops.c:786 open_shroot() error:
 double unlock 'mutex:&tcon->crfid.fid_mutex'
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@01.org, Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kbuild-all@01.org, Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000552513059274826e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000552513059274826e
Content-Type: text/plain; charset="UTF-8"

Updated patch, addressing the problem Dan pointed out is attached.

On Fri, Sep 13, 2019 at 8:58 AM Dan Carpenter via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   5fc321fb644fc787710353be11129edadd313f3a
> commit: 5fc321fb644fc787710353be11129edadd313f3a [31/31] smb3: fix unmount hang in open_shroot
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> New smatch warnings:
> fs/cifs/smb2ops.c:786 open_shroot() error: double unlock 'mutex:&tcon->crfid.fid_mutex'
>
> git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
> git remote update cifs
> git checkout 5fc321fb644fc787710353be11129edadd313f3a
> vim +786 fs/cifs/smb2ops.c
>
> fs/cifs/smb2ops.c
>    726                  /*
>    727                   * caller expects this func to set pfid to a valid
>    728                   * cached root, so we copy the existing one and get a
>    729                   * reference.
>    730                   */
>    731                  memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
>    732                  kref_get(&tcon->crfid.refcount);
>    733
>    734                  mutex_unlock(&tcon->crfid.fid_mutex);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Unlock (recently added)
>
>    735
>    736                  if (rc == 0) {
>    737                          /* close extra handle outside of crit sec */
>    738                          SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
>    739                  }
>    740                  goto oshr_free;
>    741          }
>    742
>    743          /* Cached root is still invalid, continue normaly */
>    744
>    745          if (rc) {
>    746                  if (rc == -EREMCHG) {
>    747                          tcon->need_reconnect = true;
>    748                          printk_once(KERN_WARNING "server share %s deleted\n",
>    749                                      tcon->treeName);
>    750                  }
>    751                  goto oshr_exit;
>    752          }
>    753
>    754          o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
>    755          oparms.fid->persistent_fid = o_rsp->PersistentFileId;
>    756          oparms.fid->volatile_fid = o_rsp->VolatileFileId;
>    757  #ifdef CONFIG_CIFS_DEBUG2
>    758          oparms.fid->mid = le64_to_cpu(o_rsp->sync_hdr.MessageId);
>    759  #endif /* CIFS_DEBUG2 */
>    760
>    761          memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
>    762          tcon->crfid.tcon = tcon;
>    763          tcon->crfid.is_valid = true;
>    764          kref_init(&tcon->crfid.refcount);
>    765
>    766          /* BB TBD check to see if oplock level check can be removed below */
>    767          if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
>    768                  kref_get(&tcon->crfid.refcount);
>    769                  smb2_parse_contexts(server, o_rsp,
>    770                                  &oparms.fid->epoch,
>    771                                  oparms.fid->lease_key, &oplock, NULL);
>    772          } else
>    773                  goto oshr_exit;
>    774
>    775          qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
>    776          if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
>    777                  goto oshr_exit;
>    778          if (!smb2_validate_and_copy_iov(
>    779                                  le16_to_cpu(qi_rsp->OutputBufferOffset),
>    780                                  sizeof(struct smb2_file_all_info),
>    781                                  &rsp_iov[1], sizeof(struct smb2_file_all_info),
>    782                                  (char *)&tcon->crfid.file_all_info))
>    783                  tcon->crfid.file_all_info_is_valid = 1;
>    784
>    785  oshr_exit:
>    786          mutex_unlock(&tcon->crfid.fid_mutex);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Double unlock.
>
>    787  oshr_free:
>    788          SMB2_open_free(&rqst[0]);
>    789          SMB2_query_info_free(&rqst[1]);
>    790          free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
>    791          free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
>    792          return rc;
>    793  }
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>


-- 
Thanks,

Steve

--000000000000552513059274826e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-unmount-hang-in-open_shroot.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-unmount-hang-in-open_shroot.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0ij88ik0>
X-Attachment-Id: f_k0ij88ik0

RnJvbSAzNGQ4ZGMyNmViMWYzNzA0MGI0ODE5ZTY1ZGZkZTQwMTdhZTNhMjgxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTIgU2VwIDIwMTkgMTc6NTI6NTQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggdW5tb3VudCBoYW5nIGluIG9wZW5fc2hyb290CgpBbiBlYXJsaWVyIHBhdGNoICJD
SUZTOiBmaXggZGVhZGxvY2sgaW4gY2FjaGVkIHJvb3QgaGFuZGxpbmciCmRpZCBub3QgY29tcGxl
dGVseSBhZGRyZXNzIHRoZSBkZWFkbG9jayBpbiBvcGVuX3Nocm9vdC4gVGhpcwpwYXRjaCBhZGRy
ZXNzZXMgdGhlIGRlYWRsb2NrLgoKSW4gdGVzdGluZyB0aGUgcmVjZW50IHBhdGNoOgogIHNtYjM6
IGltcHJvdmUgaGFuZGxpbmcgb2Ygc2hhcmUgZGVsZXRlZCAoYW5kIHNoYXJlIHJlY3JlYXRlZCkK
d2Ugd2VyZSBhYmxlIHRvIHJlcHJvZHVjZSB0aGUgb3Blbl9zaHJvb3QgZGVhZGxvY2sgdG8gb25l
Cm9mIHRoZSB0YXJnZXQgc2VydmVycyBpbiB1bm1vdW50IGluIGEgZGVsZXRlIHNoYXJlIHNjZW5h
cmlvLgoKRml4ZXM6IDdlNWE3MGFkODhiMWUgKCJDSUZTOiBmaXggZGVhZGxvY2sgaW4gY2FjaGVk
IHJvb3QgaGFuZGxpbmciKQoKVGhpcyBpcyB2ZXJzaW9uIDIgb2YgdGhpcyBwYXRjaC4gQW4gZWFy
bGllciB2ZXJzaW9uIG9mIHRoaXMKcGF0Y2ggInNtYjM6IGZpeCB1bm1vdW50IGhhbmcgaW4gb3Bl
bl9zaHJvb3QiIGhhZCBhIHByb2JsZW0KZm91bmQgYnkgRGFuLgoKUmVwb3J0ZWQtYnk6IGtidWls
ZCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPgpSZXBvcnRlZC1ieTogRGFuIENhcnBlbnRlciA8
ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPgoKU3VnZ2VzdGVkLWJ5OiBQYXZlbCBTaGlsb3Zza3kg
PHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNo
aWxvdkBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNo
QG1pY3Jvc29mdC5jb20+CkNDOiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpDQzog
U3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgotLS0KIGZzL2NpZnMvc21iMm9wcy5jIHwg
MjEgKysrKysrKysrKystLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygr
KSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9j
aWZzL3NtYjJvcHMuYwppbmRleCAzNjcyY2UwYmZiYWYuLjU3NzZkN2IwYTk3ZSAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTY1OCw2ICs2
NTgsMTUgQEAgaW50IG9wZW5fc2hyb290KHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sIHN0cnVjdCBjaWZzX2ZpZCAqcGZpZCkKIAkJcmV0dXJuIDA7CiAJfQogCisJLyoK
KwkgKiBXZSBkbyBub3QgaG9sZCB0aGUgbG9jayBmb3IgdGhlIG9wZW4gYmVjYXVzZSBpbiBjYXNl
CisJICogU01CMl9vcGVuIG5lZWRzIHRvIHJlY29ubmVjdCwgaXQgd2lsbCBlbmQgdXAgY2FsbGlu
ZworCSAqIGNpZnNfbWFya19vcGVuX2ZpbGVzX2ludmFsaWQoKSB3aGljaCB0YWtlcyB0aGUgbG9j
ayBhZ2FpbgorCSAqIHRodXMgY2F1c2luZyBhIGRlYWRsb2NrCisJICovCisKKwltdXRleF91bmxv
Y2soJnRjb24tPmNyZmlkLmZpZF9tdXRleCk7CisKIAlpZiAoc21iM19lbmNyeXB0aW9uX3JlcXVp
cmVkKHRjb24pKQogCQlmbGFncyB8PSBDSUZTX1RSQU5TRk9STV9SRVE7CiAKQEAgLTY3OSw3ICs2
ODgsNyBAQCBpbnQgb3Blbl9zaHJvb3QodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNv
biAqdGNvbiwgc3RydWN0IGNpZnNfZmlkICpwZmlkKQogCiAJcmMgPSBTTUIyX29wZW5faW5pdCh0
Y29uLCAmcnFzdFswXSwgJm9wbG9jaywgJm9wYXJtcywgJnV0ZjE2X3BhdGgpOwogCWlmIChyYykK
LQkJZ290byBvc2hyX2V4aXQ7CisJCWdvdG8gb3Nocl9mcmVlOwogCXNtYjJfc2V0X25leHRfY29t
bWFuZCh0Y29uLCAmcnFzdFswXSk7CiAKIAltZW1zZXQoJnFpX2lvdiwgMCwgc2l6ZW9mKHFpX2lv
dikpOwpAQCAtNjkyLDE4ICs3MDEsMTAgQEAgaW50IG9wZW5fc2hyb290KHVuc2lnbmVkIGludCB4
aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHN0cnVjdCBjaWZzX2ZpZCAqcGZpZCkKIAkJCQkg
IHNpemVvZihzdHJ1Y3Qgc21iMl9maWxlX2FsbF9pbmZvKSArCiAJCQkJICBQQVRIX01BWCAqIDIs
IDAsIE5VTEwpOwogCWlmIChyYykKLQkJZ290byBvc2hyX2V4aXQ7CisJCWdvdG8gb3Nocl9mcmVl
OwogCiAJc21iMl9zZXRfcmVsYXRlZCgmcnFzdFsxXSk7CiAKLQkvKgotCSAqIFdlIGRvIG5vdCBo
b2xkIHRoZSBsb2NrIGZvciB0aGUgb3BlbiBiZWNhdXNlIGluIGNhc2UKLQkgKiBTTUIyX29wZW4g
bmVlZHMgdG8gcmVjb25uZWN0LCBpdCB3aWxsIGVuZCB1cCBjYWxsaW5nCi0JICogY2lmc19tYXJr
X29wZW5fZmlsZXNfaW52YWxpZCgpIHdoaWNoIHRha2VzIHRoZSBsb2NrIGFnYWluCi0JICogdGh1
cyBjYXVzaW5nIGEgZGVhZGxvY2sKLQkgKi8KLQotCW11dGV4X3VubG9jaygmdGNvbi0+Y3JmaWQu
ZmlkX211dGV4KTsKIAlyYyA9IGNvbXBvdW5kX3NlbmRfcmVjdih4aWQsIHNlcywgZmxhZ3MsIDIs
IHJxc3QsCiAJCQkJcmVzcF9idWZ0eXBlLCByc3BfaW92KTsKIAltdXRleF9sb2NrKCZ0Y29uLT5j
cmZpZC5maWRfbXV0ZXgpOwotLSAKMi4yMC4xCgo=
--000000000000552513059274826e--
