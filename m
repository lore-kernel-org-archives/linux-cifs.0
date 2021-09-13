Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5372C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 23:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B163660FC0
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 23:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhIMXgO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Sep 2021 19:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbhIMXgO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Sep 2021 19:36:14 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09E2C061760
        for <linux-cifs@vger.kernel.org>; Mon, 13 Sep 2021 16:34:57 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id k13so24551259lfv.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Sep 2021 16:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4fHD5mvOD863PzLd7doJzNopyieEVyj6nrvmu/yIikk=;
        b=g+uz8sfKvxGxT8T3ABAb0VMx/H56pvR6vopw9aiCT+a8puVQ/97lV4Wv/+97PE3WQ8
         HrFPwrdQRs59NxU3ZJ5CVI1quRTbXbO4sXt8vujdRHDd8MiKSGOTvwJAc9mqG3YsDFQf
         Ql5f2pwhNpn3GAppGxzC1F7TdotApzNWkv5xXZDZNti39lE2mkPV4jekta6kK18etgk7
         G3061xIxBWcnP+lth+APlky5edGhhUySrGCh9sstV8qKTwlVYzlQqbspQ7VF2g2P5z9R
         j2ktWzR6CMkOMO50ZrQP7GEt30fEs1qaqv/LUZvMucCsOkLSv4rY8fyot+AFtS0i5pWH
         kGvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4fHD5mvOD863PzLd7doJzNopyieEVyj6nrvmu/yIikk=;
        b=QNOWBN+uEVSHxDQ46/UexMIdTBFFoVQR8SL5EurNOFRE9t0DB8e0crY/l71vYzXBoY
         SDdUHrapefBRXAoq027dDIDCW1iADwKp8xy3hSeZHx0A7gCbPrzcMhZxD/XgfNlaE1bz
         hxv0cnHf+cjlWpX0pFt1OsMMZ6FnEQe/Pce48ot2yUH21EYhFowarH31YgRj8ZGPtvlU
         oCeU1uCCkkRkLSzEmki5LoPhFD4xKjPFGwhqzyqfj0POTMN7UPJvLPPdzwWPd1z+UsIX
         tby6fBbxMugYIMiE1pp4UNmPBFn+bMTBK1XDMQYGzvk7rUIem6fl5SbQ5eeSdXOi4+2X
         lnFQ==
X-Gm-Message-State: AOAM532TXCxMQaS2wTPwcv4rKTFSKJ0O3VCCltr6vYFns2UGMVutT6lk
        rXp1MF3vE073iYeTFbnNRjiUB4Gk8zEwUsepNEPlelSivI4=
X-Google-Smtp-Source: ABdhPJwx97n4KleuDmQF9RVTBF8b7joi9RmUaAQs9QUlJ/R96G0GrGNxiGp2Bx++W9RUUoDaz15CYbHH1gwyKizxOlQ=
X-Received: by 2002:a05:6512:20f:: with SMTP id a15mr10482273lfo.537.1631576095760;
 Mon, 13 Sep 2021 16:34:55 -0700 (PDT)
MIME-Version: 1.0
References: <202109131721.EnzYJS4k-lkp@intel.com>
In-Reply-To: <202109131721.EnzYJS4k-lkp@intel.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 13 Sep 2021 18:34:44 -0500
Message-ID: <CAH2r5ms=ZmOWDNo1huZajeRrSmz8Cr0gwtx+Tt85d-f-6SYiZQ@mail.gmail.com>
Subject: Re: [cifs:for-next 1/1] fs/smbfs/ioctl.c:324:10: warning: variable
 'caps' set but not used
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000009cc7a205cbe8e96f"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009cc7a205cbe8e96f
Content-Type: text/plain; charset="UTF-8"

[PATCH] cifs: fix incorrect kernel doc comments

Correct kernel-doc comments pointed out by the
automated kernel test robot - see attached patch.

Reported-by: kernel test robot <lkp@intel.com>

On Mon, Sep 13, 2021 at 4:13 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Steve,
>
> First bad commit (maybe != root cause):
>
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   bba805a46c91e7a8a1d04704e5409f890acf8b66
> commit: bba805a46c91e7a8a1d04704e5409f890acf8b66 [1/1] cifs: rename fs/cifs directory to fs/smbfs
> config: hexagon-randconfig-r045-20210913 (attached as .config)
> compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 261cbe98c38f8c1ee1a482fe76511110e790f58a)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
>         git fetch --no-tags cifs for-next
>         git checkout bba805a46c91e7a8a1d04704e5409f890acf8b66
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=hexagon
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> fs/smbfs/ioctl.c:324:10: warning: variable 'caps' set but not used [-Wunused-but-set-variable]
>            __u64   caps;
>                    ^
>    1 warning generated.
> --
> >> fs/smbfs/connect.c:1093: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>     * Returns true if srcaddr isn't specified and rhs isn't specified, or
>    fs/smbfs/connect.c:1558: warning: Function parameter or member 'ses' not described in 'cifs_setup_ipc'
>    fs/smbfs/connect.c:1558: warning: Function parameter or member 'ctx' not described in 'cifs_setup_ipc'
>    fs/smbfs/connect.c:1618: warning: Function parameter or member 'ses' not described in 'cifs_free_ipc'
>    fs/smbfs/connect.c:1864: warning: Function parameter or member 'server' not described in 'cifs_get_smb_ses'
>    fs/smbfs/connect.c:1864: warning: Function parameter or member 'ctx' not described in 'cifs_get_smb_ses'
>    fs/smbfs/connect.c:2087: warning: Function parameter or member 'ses' not described in 'cifs_get_tcon'
>    fs/smbfs/connect.c:2087: warning: Function parameter or member 'ctx' not described in 'cifs_get_tcon'
>    fs/smbfs/connect.c:3046: warning: Function parameter or member 'xid' not described in 'expand_dfs_referral'
>    fs/smbfs/connect.c:3046: warning: Function parameter or member 'ses' not described in 'expand_dfs_referral'
>    fs/smbfs/connect.c:3046: warning: Function parameter or member 'ctx' not described in 'expand_dfs_referral'
>    fs/smbfs/connect.c:3046: warning: Function parameter or member 'cifs_sb' not described in 'expand_dfs_referral'
>    fs/smbfs/connect.c:3046: warning: Function parameter or member 'ref_path' not described in 'expand_dfs_referral'
>
>
> vim +/caps +324 fs/smbfs/ioctl.c
>
> 7ba3d1cdb7988c fs/cifs/ioctl.c Steve French    2021-05-02  312
> f9ddcca4cf7d95 fs/cifs/ioctl.c Steve French    2008-05-15  313  long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
> ^1da177e4c3f41 fs/cifs/ioctl.c Linus Torvalds  2005-04-16  314  {
> 496ad9aa8ef448 fs/cifs/ioctl.c Al Viro         2013-01-23  315          struct inode *inode = file_inode(filep);
> 7e7db86c7e1088 fs/cifs/ioctl.c Steve French    2019-09-19  316          struct smb3_key_debug_info pkey_inf;
> ^1da177e4c3f41 fs/cifs/ioctl.c Linus Torvalds  2005-04-16  317          int rc = -ENOTTY; /* strange error - but the precedent */
> 6d5786a34d98bf fs/cifs/ioctl.c Pavel Shilovsky 2012-06-20  318          unsigned int xid;
> ba00ba64cf0895 fs/cifs/ioctl.c Jeff Layton     2010-09-20  319          struct cifsFileInfo *pSMBFile = filep->private_data;
> 96daf2b09178d8 fs/cifs/ioctl.c Steve French    2011-05-27  320          struct cifs_tcon *tcon;
> a77592a70081ed fs/cifs/ioctl.c Ronnie Sahlberg 2020-07-09  321          struct tcon_link *tlink;
> d26c2ddd335696 fs/cifs/ioctl.c Steve French    2020-02-06  322          struct cifs_sb_info *cifs_sb;
> f654bac2227adc fs/cifs/ioctl.c Steve French    2005-04-28  323          __u64   ExtAttrBits = 0;
> 618763958b2291 fs/cifs/ioctl.c Jeff Layton     2010-11-08 @324          __u64   caps;
>
> :::::: The code at line 324 was first introduced by commit
> :::::: 618763958b2291a09057dbfa553da6ded93dcfad cifs: make cifs_ioctl handle NULL filp->private_data correctly
>
> :::::: TO: Jeff Layton <jlayton@redhat.com>
> :::::: CC: Steve French <sfrench@us.ibm.com>
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org



-- 
Thanks,

Steve

--0000000000009cc7a205cbe8e96f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-incorrect-kernel-doc-comments.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-incorrect-kernel-doc-comments.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ktja9um70>
X-Attachment-Id: f_ktja9um70

RnJvbSA0YzUxZGUxZThmOTI4YTViMDUyNDg3MTRkODMyZDdkOTkxYWMzMTlhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTMgU2VwIDIwMjEgMTg6Mjk6NDYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggaW5jb3JyZWN0IGtlcm5lbCBkb2MgY29tbWVudHMKCkNvcnJlY3Qga2VybmVsLWRv
YyBjb21tZW50cyBwb2ludGVkIG91dCBieSB0aGUKYXV0b21hdGVkIGtlcm5lbCB0ZXN0IHJvYm90
LgoKUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lm
cy9jb25uZWN0LmMgfCAxMiArKysrKysrKysrLS0KIGZzL2NpZnMvaW9jdGwuYyAgIHwgIDIgKy0K
IDIgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IDM5OWEw
ZjA4NDU3My4uNzg4MTExNWNmYmVlIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysg
Yi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMTA4OSw3ICsxMDg5LDcgQEAgY2lmc19kZW11bHRpcGxl
eF90aHJlYWQodm9pZCAqcCkKIAltb2R1bGVfcHV0X2FuZF9leGl0KDApOwogfQogCi0vKioKKy8q
CiAgKiBSZXR1cm5zIHRydWUgaWYgc3JjYWRkciBpc24ndCBzcGVjaWZpZWQgYW5kIHJocyBpc24n
dCBzcGVjaWZpZWQsIG9yCiAgKiBpZiBzcmNhZGRyIGlzIHNwZWNpZmllZCBhbmQgbWF0Y2hlcyB0
aGUgSVAgYWRkcmVzcyBvZiB0aGUgcmhzIGFyZ3VtZW50CiAgKi8KQEAgLTE1NDksNiArMTU0OSw5
IEBAIHN0YXRpYyBpbnQgbWF0Y2hfc2Vzc2lvbihzdHJ1Y3QgY2lmc19zZXMgKnNlcywgc3RydWN0
IHNtYjNfZnNfY29udGV4dCAqY3R4KQogCiAvKioKICAqIGNpZnNfc2V0dXBfaXBjIC0gaGVscGVy
IHRvIHNldHVwIHRoZSBJUEMgdGNvbiBmb3IgdGhlIHNlc3Npb24KKyAqIEBzZXM6IHNtYiBzZXNz
aW9uIHRvIGlzc3VlIHRoZSByZXF1ZXN0IG9uCisgKiBAY3R4OiB0aGUgc3VwZXJibG9jayBjb25m
aWd1cmF0aW9uIGNvbnRleHQgdG8gdXNlIGZvciBidWlsZGluZyB0aGUKKyAqICAgICAgIG5ldyB0
cmVlIGNvbm5lY3Rpb24gZm9yIHRoZSBJUEMgKGludGVycHJvY2VzcyBjb21tdW5pY2F0aW9uIFJQ
QykKICAqCiAgKiBBIG5ldyBJUEMgY29ubmVjdGlvbiBpcyBtYWRlIGFuZCBzdG9yZWQgaW4gdGhl
IHNlc3Npb24KICAqIHRjb25faXBjLiBUaGUgSVBDIHRjb24gaGFzIHRoZSBzYW1lIGxpZmV0aW1l
IGFzIHRoZSBzZXNzaW9uLgpAQCAtMTYwNCw2ICsxNjA3LDcgQEAgY2lmc19zZXR1cF9pcGMoc3Ry
dWN0IGNpZnNfc2VzICpzZXMsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkKIAogLyoqCiAg
KiBjaWZzX2ZyZWVfaXBjIC0gaGVscGVyIHRvIHJlbGVhc2UgdGhlIHNlc3Npb24gSVBDIHRjb24K
KyAqIEBzZXM6IHNtYiBzZXNzaW9uIHRvIHVubW91bnQgdGhlIElQQyBmcm9tCiAgKgogICogTmVl
ZHMgdG8gYmUgY2FsbGVkIGV2ZXJ5dGltZSBhIHNlc3Npb24gaXMgZGVzdHJveWVkLgogICoKQEAg
LTE4NTQsNiArMTg1OCw4IEBAIGNpZnNfc2V0X2NpZnNjcmVkcyhzdHJ1Y3Qgc21iM19mc19jb250
ZXh0ICpjdHggX19hdHRyaWJ1dGVfXygodW51c2VkKSksCiAKIC8qKgogICogY2lmc19nZXRfc21i
X3NlcyAtIGdldCBhIHNlc3Npb24gbWF0Y2hpbmcgQGN0eCBkYXRhIGZyb20gQHNlcnZlcgorICog
QHNlcnZlcjogc2VydmVyIHRvIHNldHVwIHRoZSBzZXNzaW9uIHRvCisgKiBAY3R4OiBzdXBlcmJs
b2NrIGNvbmZpZ3VyYXRpb24gY29udGV4dCB0byB1c2UgdG8gc2V0dXAgdGhlIHNlc3Npb24KICAq
CiAgKiBUaGlzIGZ1bmN0aW9uIGFzc3VtZXMgaXQgaXMgYmVpbmcgY2FsbGVkIGZyb20gY2lmc19t
b3VudCgpIHdoZXJlIHdlCiAgKiBhbHJlYWR5IGdvdCBhIHNlcnZlciByZWZlcmVuY2UgKHNlcnZl
ciByZWZjb3VudCArMSkuIFNlZQpAQCAtMjA2NCw2ICsyMDcwLDggQEAgY2lmc19wdXRfdGNvbihz
dHJ1Y3QgY2lmc190Y29uICp0Y29uKQogCiAvKioKICAqIGNpZnNfZ2V0X3Rjb24gLSBnZXQgYSB0
Y29uIG1hdGNoaW5nIEBjdHggZGF0YSBmcm9tIEBzZXMKKyAqIEBzZXM6IHNtYiBzZXNzaW9uIHRv
IGlzc3VlIHRoZSByZXF1ZXN0IG9uCisgKiBAY3R4OiB0aGUgc3VwZXJibG9jayBjb25maWd1cmF0
aW9uIGNvbnRleHQgdG8gdXNlIGZvciBidWlsZGluZyB0aGUKICAqCiAgKiAtIHRjb24gcmVmY291
bnQgaXMgdGhlIG51bWJlciBvZiBtb3VudCBwb2ludHMgdXNpbmcgdGhlIHRjb24uCiAgKiAtIHNl
cyByZWZjb3VudCBpcyB0aGUgbnVtYmVyIG9mIHRjb24gdXNpbmcgdGhlIHNlc3Npb24uCkBAIC0z
MDI5LDcgKzMwMzcsNyBAQCBidWlsZF91bmNfcGF0aF90b19yb290KGNvbnN0IHN0cnVjdCBzbWIz
X2ZzX2NvbnRleHQgKmN0eCwKIAlyZXR1cm4gZnVsbF9wYXRoOwogfQogCi0vKioKKy8qCiAgKiBl
eHBhbmRfZGZzX3JlZmVycmFsIC0gUGVyZm9ybSBhIGRmcyByZWZlcnJhbCBxdWVyeSBhbmQgdXBk
YXRlIHRoZSBjaWZzX3NiCiAgKgogICogSWYgYSByZWZlcnJhbCBpcyBmb3VuZCwgY2lmc19zYi0+
Y3R4LT5tb3VudF9vcHRpb25zIHdpbGwgYmUgKHJlLSlhbGxvY2F0ZWQKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvaW9jdGwuYyBiL2ZzL2NpZnMvaW9jdGwuYwppbmRleCA0NGFlOTk0NTRmYjMuLjAzNTli
NjA0YmRiYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pb2N0bC5jCisrKyBiL2ZzL2NpZnMvaW9jdGwu
YwpAQCAtMzU4LDcgKzM1OCw3IEBAIGxvbmcgY2lmc19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAs
IHVuc2lnbmVkIGludCBjb21tYW5kLCB1bnNpZ25lZCBsb25nIGFyZykKIAkJCWlmIChwU01CRmls
ZSA9PSBOVUxMKQogCQkJCWJyZWFrOwogCQkJdGNvbiA9IHRsaW5rX3Rjb24ocFNNQkZpbGUtPnRs
aW5rKTsKLQkJCWNhcHMgPSBsZTY0X3RvX2NwdSh0Y29uLT5mc1VuaXhJbmZvLkNhcGFiaWxpdHkp
OworCQkJLyogY2FwcyA9IGxlNjRfdG9fY3B1KHRjb24tPmZzVW5peEluZm8uQ2FwYWJpbGl0eSk7
ICovCiAKIAkJCWlmIChnZXRfdXNlcihFeHRBdHRyQml0cywgKGludCBfX3VzZXIgKilhcmcpKSB7
CiAJCQkJcmMgPSAtRUZBVUxUOwotLSAKMi4zMC4yCgo=
--0000000000009cc7a205cbe8e96f--
