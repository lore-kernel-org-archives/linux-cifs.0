Return-Path: <SRS0=eY7I=5D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26FBC10DCE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 05:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 723912076C
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 05:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ANV8NuPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCRF5f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Mar 2020 01:57:35 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33366 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgCRF5f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Mar 2020 01:57:35 -0400
Received: by mail-qk1-f195.google.com with SMTP id q17so12222999qki.0
        for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2020 22:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5TyD+NC664rc8tA0+m9TRcpmDr79vhHumhCNvynrA8I=;
        b=ANV8NuPCpmv2c6qfjKy78NolqCjyIXlIx61iIqoc5+IZlWRvA+UwMZsfPe40no34j9
         QT5pU9Lf4OP27x0zL3VFUnDjgLyBvNtCXzRs56isLqtiIxOtT2iv38OBqAD7x10JwIDh
         S10a3/10WWgs7bLBHcRg+iB55LmvqxNjicZkoilj1BrMbnDTp5sOpdDE0STncadUl/Tv
         dwxmRazez4rkl/QYn1isHWm1Sd1AW4RIeb4U9C7sKqQeSUeTJebsi/W0uUScvUdkKjdy
         71jVXmeqOMnGNsYC/g4bNXimaETf+3VVjXd2qYRLJmDL68TpYqQp9s3efJU4oQdvoB62
         f/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5TyD+NC664rc8tA0+m9TRcpmDr79vhHumhCNvynrA8I=;
        b=XZ1zMMZLo2iaP/ZB/gficpNWP5+ItEJjKfR1hGauuoVDc/2Ji7qGTWrKD+4qH5xKAV
         S/YqgLcHuZTec9o5VNvcI8NpikQm0ICLo/JeFYtVp+eMk+/Q5yAoy28v+Rmb7l/H4KUv
         mpdG3PaVG8UJ8F51X0akA5frXq5b633beI4pRY6wFPhTWJWBUozv13NN2AqiDVWp7/tF
         ZA5/ppMOXkEoTkfLu1o5Nyu5j35Cgp2SbV9HA6wN+PnA1SA0vhqqEQudFRDaj8sx9nVF
         9jWt2O4T4dg11hGZg7ufuB2b7E4l7kW+OCx9kqzjnN7/nNZA1xtYIcgthCBzj8PsNNxb
         MUZw==
X-Gm-Message-State: ANhLgQ0IZA7qDkHfDU263MDjtxIlqBS1GF1sNY4WUynQy4rq1fT2f1s1
        Q5oUsHfF3+MKZTFbIWB1zb2GZj2tnwAnLZaMvQM=
X-Google-Smtp-Source: ADFU+vsAl0aZkIC5xLtIdFXEaxbdx2Ac5rWMwIRpjY9Ddkd8Aapw6Cb8WX25dpqbBpdTwQW1vh7cPDWiD0O1iD7XgCY=
X-Received: by 2002:a25:f20f:: with SMTP id i15mr3510718ybe.364.1584511054733;
 Tue, 17 Mar 2020 22:57:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200318015624.spmlc7izbszkpdqf@xzhoux.usersys.redhat.com>
In-Reply-To: <20200318015624.spmlc7izbszkpdqf@xzhoux.usersys.redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 18 Mar 2020 00:57:23 -0500
Message-ID: <CAH2r5muj1nGSQFJzD7v4By6kgbt+k0ZmW0z_iKwRUB24XXB-bA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: check new file size when extending file by fallocate
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

generates a warning (sparse) when compiled - can you fix and resubmit
(can also add Ronnie's acked if you want)

  CHECK   /home/smfrench/cifs-2.6/fs/cifs/smb2ops.c
/home/smfrench/cifs-2.6/fs/cifs/smb2ops.c:3259:46: warning: incorrect
type in argument 2 (different base types)
/home/smfrench/cifs-2.6/fs/cifs/smb2ops.c:3259:46:    expected long
long [usertype] offset
/home/smfrench/cifs-2.6/fs/cifs/smb2ops.c:3259:46:    got restricted
__le64 [assigned] [usertype] eof
  CC [M]  /home/smfrench/cifs-2.6/fs/cifs/smb2ops.o

On Tue, Mar 17, 2020 at 8:57 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> xfstests generic/228 checks if fallocate respects RLIMIT_FSIZE.
> After fallocate mode 0 extending enabled, cifs can hit this failure.
> Fix this by checking the new file size with the vfs helper, which
> checks with RLIMIT_FSIZE(ulimit -f) and s_maxbytes.
>
> This patch has been tested by LTP/xfstests aginst samba and
> Windows server. No new issue was found.
>
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/smb2ops.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c31e84ee3c39..48bbbb68540d 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3246,10 +3246,14 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>          * Extending the file
>          */
>         if ((keep_size == false) && i_size_read(inode) < off + len) {
> +               eof = cpu_to_le64(off + len);
> +               rc = inode_newsize_ok(inode, eof);
> +               if (rc)
> +                       goto out;
> +
>                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
>                         smb2_set_sparse(xid, tcon, cfile, inode, false);
>
> -               eof = cpu_to_le64(off + len);
>                 rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
>                                   cfile->fid.volatile_fid, cfile->pid, &eof);
>                 if (rc == 0) {
> --
> 2.20.1



-- 
Thanks,

Steve
