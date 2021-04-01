Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC771C433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 05:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7486F61108
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 05:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhDAFlj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 01:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhDAFlZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 01:41:25 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF157C0613E6
        for <linux-cifs@vger.kernel.org>; Wed, 31 Mar 2021 22:41:24 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id b14so1013311lfv.8
        for <linux-cifs@vger.kernel.org>; Wed, 31 Mar 2021 22:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r3yXI37DsWPTrxK/PppT+4nfYQwdcQsdqAES8z+Kcrg=;
        b=eBy/4Fxw5xhFVpnwZk8vYnw/fn45K3XU30jCIrt1T13N+74ApewDegPiKMbAxf23Nf
         6SqvhRHYCHfmEdIWIsneHsBTCCOqORnV8aQMlIgCaSMcSNhryneGo/UEaOtsJVAkoABM
         Ze4RVky7sbg2jFdDplVsOQlGrHnNKVUiitC6c0XG3A88m1fuWkFFxNiWjCxROBvRVD2C
         45m8esrP2bAPmg0b3z5QzFd4J+ia5bO6L3MjEhd4uAUsNElRQ3QEQRrd7etFIjyGFwu6
         4R1mSFJ2Geg8p943OagA8sRm77kasoO/JOBHEA8NCfcLy1QHB+cxpFcb4+8ZE8ga/r3S
         6jWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r3yXI37DsWPTrxK/PppT+4nfYQwdcQsdqAES8z+Kcrg=;
        b=EvBI0/t/5305dc7dhsx8eu6jk9BoEaWVQGP+VIqlmgVnTYRTtwxZNpkZmo+h+NjlHA
         nfyWN9J5koLif6rxnrRB/HNm/z9vucaeMGhVHY0QCiKbB+6gN3RDEVSNG1UWPIBJJoKD
         oeQIimaQmlZZD+fmpbntxw0PwuS1bfJcv3+BSpFVE/tYYdSbCxRyibK6d1jqZzgv4Mql
         X9P2p0E+Ikr1yZN3PVsEFlR3zzUs9B4I/LrvkaRjPOvs7WJeExJuWpVWLye7u79LkIBW
         9GgsS18y4DNLtXoR0s4JXWvtl3uOjoik3AVmQig9uhqYgYVAB3BIHYllEcbaI0kygquv
         UoDw==
X-Gm-Message-State: AOAM5325E1f22ac3lUIGyV+5bua5vJnbwWKKSbBGnziJNOEQGwKnMdeC
        o/w/Qy/DH/icb4xXpUDFFVgjgsxAHs9O98SUNLk=
X-Google-Smtp-Source: ABdhPJyuyL1kYspGud6WwJPZhdO+olUN9ENdBQsMNmqx8QsJMwa08PORRKQgPISUtBMfGqs1EyO33PYfdmZaCz5ZmLg=
X-Received: by 2002:a05:6512:210b:: with SMTP id q11mr4293261lfr.133.1617255683169;
 Wed, 31 Mar 2021 22:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210326195229.114110-1-lsahlber@redhat.com>
In-Reply-To: <20210326195229.114110-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Apr 2021 00:41:11 -0500
Message-ID: <CAH2r5mv6qb996ZEvDaF_Y4sis3NBQeTyt1sNq5RUJ7sW3j_68Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for FALLOC_FL_COLLAPSE_RANGE
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Running xfstests on this patch (along with the previous INSERT_RANGE
patch) fixes at least six xfstests which were skipped before:

# ./check -cifs generic/072 generic/145 generic/147 generic/153
generic/351 generic/458
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 smfrench-Virtual-Machine
5.12.0-051200rc4-generic #202103212230 SMP Sun Mar 21 22:33:27 UTC
2021

generic/072 7s ...  6s
generic/145 0s ...  1s
generic/147 1s ...  0s
generic/153 0s ...  1s
generic/351 5s ...  3s
generic/458 1s ...  1s
Ran: generic/072 generic/145 generic/147 generic/153 generic/351 generic/458
Passed all 6 tests

Promising ... there are additional fallocate related tests that still
fail or are skipped, but good progress ...


On Fri, Mar 26, 2021 at 2:52 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 9bae7e8deb09..3bb18944aaa4 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3640,6 +3640,44 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> +static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
> +                           loff_t off, loff_t len)
> +{
> +       int rc;
> +       unsigned int xid;
> +       struct cifsFileInfo *cfile = file->private_data;
> +       __le64 eof;
> +
> +       xid = get_xid();
> +
> +       if (off + len < off) {
> +               rc = -EFBIG;
> +               goto out;
> +       }
> +
> +       if (off >= i_size_read(file->f_inode) ||
> +           off + len >= i_size_read(file->f_inode)) {
> +               rc = -EINVAL;
> +               goto out;
> +       }
> +
> +       rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
> +                                 i_size_read(file->f_inode) - off - len, off);
> +       if (rc < 0)
> +               goto out;
> +
> +       eof = i_size_read(file->f_inode) - len;
> +       rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> +                         cfile->fid.volatile_fid, cfile->pid, &eof);
> +       if (rc < 0)
> +               goto out;
> +
> +       rc = 0;
> + out:
> +       free_xid(xid);
> +       return rc;
> +}
> +
>  static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offset, int whence)
>  {
>         struct cifsFileInfo *wrcfile, *cfile = file->private_data;
> @@ -3811,6 +3849,8 @@ static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
>                 return smb3_zero_range(file, tcon, off, len, false);
>         } else if (mode == FALLOC_FL_KEEP_SIZE)
>                 return smb3_simple_falloc(file, tcon, off, len, true);
> +       else if (mode == FALLOC_FL_COLLAPSE_RANGE)
> +               return smb3_collapse_range(file, tcon, off, len);
>         else if (mode == 0)
>                 return smb3_simple_falloc(file, tcon, off, len, false);
>
> --
> 2.29.2
>


--
Thanks,

Steve
