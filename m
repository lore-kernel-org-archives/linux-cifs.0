Return-Path: <SRS0=A3cw=UQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CE5C31E5B
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jun 2019 19:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A84832084B
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jun 2019 19:51:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eWGmlu8t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfFQTv3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jun 2019 15:51:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46457 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFQTv3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jun 2019 15:51:29 -0400
Received: by mail-pf1-f193.google.com with SMTP id 81so6222230pfy.13
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jun 2019 12:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=IYqG3I/iR+698zzFiG8VG32oFmAJR0f1860DQH1iHtU=;
        b=eWGmlu8t0NJZ9ndABvMxc5XUA0CnatWcAmacEFf9OnYL0uF/mJKbOdn9Wb3wOpa9Pi
         UUxjlRbilZQGb1lXbZSeGr1d1dOTy0txJ5q9AjK0f+g1OsBmoziref3nA2pkCnnAR78S
         Zze8eJ3JS5oIW8hf9kjrv1TU+QW93k79vX+aGWVbBm7zwdtf4mL0FOwYBW2HYFLBcmNU
         DTpF0Cp+b1LPYmvQ7LFooDgssPi17fL5Gd7mVxgLM9ApZd4LP1vbu9qmU3vP7BtMTR0x
         y91flvBBSZ2Pl8pGPSZy39D98XzJbjYPaNCIBsmPFver4tevd8OnS49yc5Dp3Gk8je8b
         8Nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=IYqG3I/iR+698zzFiG8VG32oFmAJR0f1860DQH1iHtU=;
        b=rhd28QAS9PKyBPjSAvmd7F5FZJZ1MB383dpiyuBV7j9y3JvqHT07VNE8NSbfOssXCp
         qLeYI6qEy53cIGXacFtBrs7mqrEYmPBbP/TV7g5noPenxVO6rRX7o2QMYbp2r/KgbC+K
         U9fVB0A8qPAyltV0VyJkvR1RWTr6ra+Ha77EarlOgz1yQlxe3Rd0/ogT8jznl4zFWd1r
         TBgbEhCZa9QFYEdB9iyD7pUZT0gYtqClBBH23u9UCbPr6OehaHxbhr65nrQxjndEmlIw
         VjUkNNZrhPKObjTSZ3cNVMmdY3HIWghuRSYCezE64bkkyYvDpUP7u/EQdBqfjR9K7yPN
         wBAw==
X-Gm-Message-State: APjAAAWVmfw+xWSehAvgWJWMAOi4ZE8dEq4EipJ1htP2pAsMdpGX5qAz
        xSuSV5aQb7WzMcTXkQ5QjP1dEZmvPY/pldU1lU8=
X-Google-Smtp-Source: APXvYqzJ+54h6jeOUAU98078dX9Nk4qjnXTI7K6Lc4UnFba0squ46cGPdTjDYe4K9baVLGefFkHpN4jgENWhpgZY9Ok=
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr713432pje.12.1560801088072;
 Mon, 17 Jun 2019 12:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvo9sWf8VoPb8puCDh4HM6WnrMgjs+HyhUzqEZXtuQwtA@mail.gmail.com>
In-Reply-To: <CAH2r5mvo9sWf8VoPb8puCDh4HM6WnrMgjs+HyhUzqEZXtuQwtA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Jun 2019 14:51:16 -0500
Message-ID: <CAH2r5mtC5cXkhAVrioy_cLeoTq_4Jq0nw3CR4HTiEP_twSSKJg@mail.gmail.com>
Subject: Re: NT_STATUS_INSUFFICIENT_RESOURCES and retrying writes to Windows
 10 servers
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <paulo@paulo.ac>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000006b8e16058b8a5241"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006b8e16058b8a5241
Content-Type: text/plain; charset="UTF-8"

Attached is a patch with updated comments and cc:stable:


On Sat, Jun 15, 2019 at 11:18 PM Steve French <smfrench@gmail.com> wrote:
>
> By default large file copy to Windows 10 can return MANY potentially
> retryable errors on write (which we don't retry from the Linux cifs
> client) which can cause cp to fail.
>
> It did look like my patch for the problem worked (see below).  Windows
> 10 returns *A LOT* (about 1/3 of writes in some cases I tried) of
> NT_STATUS_INSUFFICIENT_RESOURCES errors (presumably due to the
> 'blocking operation credit' max of 64 in Windows 10 - see note 203 of
> MS-SMB2).
>
> "<203> Section 3.3.4.2: Windows-based servers enforce a configurable
> blocking operation credit,
> which defaults to 64 on Windows Vista SP1, Windows 7, Windows 8,
> Windows 8.1, and, Windows 10,
> and defaults to 512 on Windows Server 2008, Windows Server 2008 R2,
> Windows Server 2012 ..."
>
> This patch did seem to work around the problem, but perhaps we should
> use far fewer credits when mounting to Windows 10 even though they are
> giving us enough credits for more? Or change how we do writes to not
> do synchronous writes? I haven't seen this problem to Windows 2016 or
> 2019 but perhaps the explanation on note 203  is all we need to know
> ... ie that clients can enforce a lower limit than 512
>
> ~/cifs-2.6/fs/cifs$ git diff -a
> diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
> index e32c264e3adb..82ade16c9501 100644
> --- a/fs/cifs/smb2maperror.c
> +++ b/fs/cifs/smb2maperror.c
> @@ -457,7 +457,7 @@ static const struct status_to_posix_error
> smb2_error_map_table[] = {
>         {STATUS_FILE_INVALID, -EIO, "STATUS_FILE_INVALID"},
>         {STATUS_ALLOTTED_SPACE_EXCEEDED, -EIO,
>         "STATUS_ALLOTTED_SPACE_EXCEEDED"},
> -       {STATUS_INSUFFICIENT_RESOURCES, -EREMOTEIO,
> +       {STATUS_INSUFFICIENT_RESOURCES, -EAGAIN,
>                                 "STATUS_INSUFFICIENT_RESOURCES"},
>         {STATUS_DFS_EXIT_PATH_FOUND, -EIO, "STATUS_DFS_EXIT_PATH_FOUND"},
>         {STATUS_DEVICE_DATA_ERROR, -EIO, "STATUS_DEVICE_DATA_ERROR"},
>
>
> e.g. see the number of write errors in my 8GB copy in my test below
>
> # cat /proc/fs/cifs/Stats
> Resources in use
> CIFS Session: 1
> Share (unique mount targets): 2
> SMB Request/Response Buffer: 1 Pool size: 5
> SMB Small Req/Resp Buffer: 1 Pool size: 30
> Operations (MIDs): 0
>
> 0 session 0 share reconnects
> Total vfs operations: 363 maximum at one time: 2
>
> 1) \\10.0.3.4\public-share
> SMBs: 14879
> Bytes read: 0  Bytes written: 8589934592
> Open files: 2 total (local), 0 open on server
> TreeConnects: 3 total 0 failed
> TreeDisconnects: 0 total 0 failed
> Creates: 12 total 0 failed
> Closes: 10 total 0 failed
> Flushes: 0 total 0 failed
> Reads: 0 total 0 failed
> Writes: 14838 total 5624 failed
> ...
>
> Any thoughts?
>
> Any risk that we could run into places where EAGAIN would not be
> handled (there are SMB3 commands other than read and write where
> NT_STATUS_INSUFFICIENT_RESOURCES could be returned in theory)
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000006b8e16058b8a5241
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-retry-on-STATUS_INSUFFICIENT_RESOURCES-instead-.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-retry-on-STATUS_INSUFFICIENT_RESOURCES-instead-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jx0snfv30>
X-Attachment-Id: f_jx0snfv30

RnJvbSBlYTY1MWViZWEyOTAyMDQ2MDJjMTRlNDBhOGFiNDc4MzU0MDVhNDI3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTcgSnVuIDIwMTkgMTQ6NDk6MDcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiByZXRyeSBvbiBTVEFUVVNfSU5TVUZGSUNJRU5UX1JFU09VUkNFUyBpbnN0ZWFkIG9mCiBm
YWlsaW5nIHdyaXRlCgpTb21lIHNlcnZlcnMgc3VjaCBhcyBXaW5kb3dzIDEwIHdpbGwgcmV0dXJu
IFNUQVRVU19JTlNVRkZJQ0lFTlRfUkVTT1VSQ0VTCmFzIHRoZSBudW1iZXIgb2Ygc2ltdWx0YW5l
b3VzIFNNQjMgcmVxdWVzdHMgZ3Jvd3MgKGV2ZW4gdGhvdWdoIHRoZSBjbGllbnQKaGFzIHN1ZmZp
Y2llbnQgY3JlZGl0cykuICBSZXR1cm4gRUFHQUlOIG9uIFNUQVRVU19JTlNVRkZJQ0lFTlRfUkVT
T1VSQ0VTCnNvIHRoYXQgd2UgY2FuIHJldHJ5IHdyaXRlcyB3aGljaCBmYWlsIHdpdGggdGhpcyBz
dGF0dXMgY29kZS4KClRoaXMgKGZvciBleGFtcGxlKSBmaXhlcyBsYXJnZSBmaWxlIGNvcGllcyB0
byBXaW5kb3dzIDEwIG9uIGZhc3QgbmV0d29ya3MuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVu
Y2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+CkNDOiBTdGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmc+Ci0tLQotLS0KIGZzL2NpZnMvc21iMm1hcGVycm9yLmMgfCAyICstCiAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZz
L3NtYjJtYXBlcnJvci5jIGIvZnMvY2lmcy9zbWIybWFwZXJyb3IuYwppbmRleCBlMzJjMjY0ZTNh
ZGIuLjgyYWRlMTZjOTUwMSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIybWFwZXJyb3IuYworKysg
Yi9mcy9jaWZzL3NtYjJtYXBlcnJvci5jCkBAIC00NTcsNyArNDU3LDcgQEAgc3RhdGljIGNvbnN0
IHN0cnVjdCBzdGF0dXNfdG9fcG9zaXhfZXJyb3Igc21iMl9lcnJvcl9tYXBfdGFibGVbXSA9IHsK
IAl7U1RBVFVTX0ZJTEVfSU5WQUxJRCwgLUVJTywgIlNUQVRVU19GSUxFX0lOVkFMSUQifSwKIAl7
U1RBVFVTX0FMTE9UVEVEX1NQQUNFX0VYQ0VFREVELCAtRUlPLAogCSJTVEFUVVNfQUxMT1RURURf
U1BBQ0VfRVhDRUVERUQifSwKLQl7U1RBVFVTX0lOU1VGRklDSUVOVF9SRVNPVVJDRVMsIC1FUkVN
T1RFSU8sCisJe1NUQVRVU19JTlNVRkZJQ0lFTlRfUkVTT1VSQ0VTLCAtRUFHQUlOLAogCQkJCSJT
VEFUVVNfSU5TVUZGSUNJRU5UX1JFU09VUkNFUyJ9LAogCXtTVEFUVVNfREZTX0VYSVRfUEFUSF9G
T1VORCwgLUVJTywgIlNUQVRVU19ERlNfRVhJVF9QQVRIX0ZPVU5EIn0sCiAJe1NUQVRVU19ERVZJ
Q0VfREFUQV9FUlJPUiwgLUVJTywgIlNUQVRVU19ERVZJQ0VfREFUQV9FUlJPUiJ9LAotLSAKMi4y
MC4xCgo=
--0000000000006b8e16058b8a5241--
