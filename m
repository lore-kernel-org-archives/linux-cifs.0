Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B37C433B4
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 18:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D659961165
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 18:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355495AbhDGS4h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Apr 2021 14:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355485AbhDGS4Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Apr 2021 14:56:25 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B3AC061760;
        Wed,  7 Apr 2021 11:56:14 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j18so6409355lfg.5;
        Wed, 07 Apr 2021 11:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sqCYS/CZAfWK/te/TXf/5fA6YQW/6TBwZyYpp2SH+v4=;
        b=AHll28d352WOBUobfVUMEp3cy5IdxPDlST8FWjTO0mhkMoSBg1A4Of9op2bYccbsV6
         RgFncfZUBu6+VWLWJpSLuc+xg8ZZIWuaArFCKhsroolZ4kUWfsgdUlPKB/TNa1XJHpdM
         UsVh7UAwmbOdqwp/kv9GKM2NaQUOE9UWiW9mPsWDLaHFrVmyknx0/WLGnJr6uzZhsU4n
         ZFV3BBItSRS7QzZWEjm1Czn1kszEeZxhPY5V/kPym/NkR5iLMW7sEwg532YLAz2yJGA1
         2bx7OSYwPg4J5gkrKLd5tMrifzNZbDAlw1+M8uIeHYXUPtcEyrpX9L5UpDrBGKBthWwG
         WXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sqCYS/CZAfWK/te/TXf/5fA6YQW/6TBwZyYpp2SH+v4=;
        b=VDnZ5K6gUckJh28GXd8ONYqk+diAno+lSc/hcZAsqs1L94253RQUIibg2rXtJ3RFvU
         sAFrHKirXQ1ywp+NPOWar33vl+dyhLzCdseP9iZDxTuG9erCCn2CZFvZa3LWO0+Y2Vkk
         +Hnlzj/EC8BGfdwpmfSMYfga6acHP6zkaxYLemgzTy6uvjVx8Qp01fG7Wk+W4Tpsh+hN
         MVPrg2i7vpy1SqxTvbU3+kapKGn/spogMc1Gl/xTzp985FsysMaX8GiaMS3z04bbyq5x
         cvLzgD9t0gMEPPR42SlY/HFAW7ws4vapPTMocggjSe9vYi5dWQEXboGja3rcp7Zztl0A
         XAtQ==
X-Gm-Message-State: AOAM533ZsZ29EBV79hdeEl1xDisLDOvLd+1bPlhnushy1tDJ/s/ma5vZ
        kKC5Igei3wcEc91V0e6Z1cckc3AXxa+ni4xaeX0=
X-Google-Smtp-Source: ABdhPJzA95p0YdnMvuPKs6+hQkjWiknPgGEWN1kURPrTWLaR6nQNbA01kQgU1P8Cc4rQ/wPiJzJk5758kYC7LRgRNsg=
X-Received: by 2002:a19:7515:: with SMTP id y21mr3461350lfe.282.1617821772792;
 Wed, 07 Apr 2021 11:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <dc18955dda8844bf7b27dfd2cce50f7c62eb82e5.1617720952.git.maciek.borzecki@gmail.com>
In-Reply-To: <dc18955dda8844bf7b27dfd2cce50f7c62eb82e5.1617720952.git.maciek.borzecki@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 7 Apr 2021 13:56:01 -0500
Message-ID: <CAH2r5msOOnnaD7PSmPQNwppsiRPRyhmZ1StYp+kGoEyV6tCScA@mail.gmail.com>
Subject: Re: [PATCH] cifs: escape spaces in share names
To:     Maciek Borzecki <maciek.borzecki@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>
Content-Type: multipart/mixed; boundary="00000000000013d39f05bf667ced"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000013d39f05bf667ced
Content-Type: text/plain; charset="UTF-8"

Good catch - added one other minor thing, whitespace in share name
could be a space or a tab, so changed that line to:

+               seq_escape(m, devname, " \t");

from
+               seq_escape(m, devname, " ");

On Wed, Apr 7, 2021 at 12:35 AM Maciek Borzecki
<maciek.borzecki@gmail.com> wrote:
>
> Commit 653a5efb849a ("cifs: update super_operations to show_devname")
> introduced the display of devname for cifs mounts. However, when mounting
> a share which has a whitespace in the name, that exact share name is also
> displayed in mountinfo. Make sure that all whitespace is escaped.
>
> Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>
> ---
>  fs/cifs/cifsfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 099ad9f3660bb28db1b6a9aea9538282b41c6455..3c6cb85b95e207df222248f10cc9df937cdda24e 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -476,7 +476,8 @@ static int cifs_show_devname(struct seq_file *m, struct dentry *root)
>                 seq_puts(m, "none");
>         else {
>                 convert_delimiter(devname, '/');
> -               seq_puts(m, devname);
> +               /* escape all spaces in share names */
> +               seq_escape(m, devname, " ");
>                 kfree(devname);
>         }
>         return 0;
> --
> 2.31.1
>


-- 
Thanks,

Steve

--00000000000013d39f05bf667ced
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-escape-spaces-in-share-names.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-escape-spaces-in-share-names.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kn7taqr20>
X-Attachment-Id: f_kn7taqr20

RnJvbSAxZWU0ZjMzZmZhODMwMjY3ZDMyNGIwZDU0N2ZhY2QyNWRkNjgzYTEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYWNpZWsgQm9yemVja2kgPG1hY2llay5ib3J6ZWNraUBnbWFp
bC5jb20+CkRhdGU6IFR1ZSwgNiBBcHIgMjAyMSAxNzowMjoyOSArMDIwMApTdWJqZWN0OiBbUEFU
Q0hdIGNpZnM6IGVzY2FwZSBzcGFjZXMgaW4gc2hhcmUgbmFtZXMKCkNvbW1pdCA2NTNhNWVmYjg0
OWEgKCJjaWZzOiB1cGRhdGUgc3VwZXJfb3BlcmF0aW9ucyB0byBzaG93X2Rldm5hbWUiKQppbnRy
b2R1Y2VkIHRoZSBkaXNwbGF5IG9mIGRldm5hbWUgZm9yIGNpZnMgbW91bnRzLiBIb3dldmVyLCB3
aGVuIG1vdW50aW5nCmEgc2hhcmUgd2hpY2ggaGFzIGEgd2hpdGVzcGFjZSBpbiB0aGUgbmFtZSwg
dGhhdCBleGFjdCBzaGFyZSBuYW1lIGlzIGFsc28KZGlzcGxheWVkIGluIG1vdW50aW5mby4gTWFr
ZSBzdXJlIHRoYXQgYWxsIHdoaXRlc3BhY2UgaXMgZXNjYXBlZC4KClNpZ25lZC1vZmYtYnk6IE1h
Y2llayBCb3J6ZWNraSA8bWFjaWVrLmJvcnplY2tpQGdtYWlsLmNvbT4KQ0M6IDxzdGFibGVAdmdl
ci5rZXJuZWwub3JnPiAjIDUuMTErClJldmlld2VkLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNh
ZEBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1p
Y3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZnMuYyB8IDMgKystCiAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9j
aWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXggMDk5YWQ5ZjM2NjBiLi4zYzZjYjg1Yjk1
ZTIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZzZnMuYwpA
QCAtNDc2LDcgKzQ3Niw4IEBAIHN0YXRpYyBpbnQgY2lmc19zaG93X2Rldm5hbWUoc3RydWN0IHNl
cV9maWxlICptLCBzdHJ1Y3QgZGVudHJ5ICpyb290KQogCQlzZXFfcHV0cyhtLCAibm9uZSIpOwog
CWVsc2UgewogCQljb252ZXJ0X2RlbGltaXRlcihkZXZuYW1lLCAnLycpOwotCQlzZXFfcHV0cyht
LCBkZXZuYW1lKTsKKwkJLyogZXNjYXBlIGFsbCBzcGFjZXMgaW4gc2hhcmUgbmFtZXMgKi8KKwkJ
c2VxX2VzY2FwZShtLCBkZXZuYW1lLCAiIFx0Iik7CiAJCWtmcmVlKGRldm5hbWUpOwogCX0KIAly
ZXR1cm4gMDsKLS0gCjIuMjcuMAoK
--00000000000013d39f05bf667ced--
