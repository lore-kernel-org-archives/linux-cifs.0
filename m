Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621A4C38145
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Sep 2022 08:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiIGIhm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Sep 2022 04:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiIGIhk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Sep 2022 04:37:40 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01758AEDAE
        for <linux-cifs@vger.kernel.org>; Wed,  7 Sep 2022 01:37:17 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id 190so14156289vsz.7
        for <linux-cifs@vger.kernel.org>; Wed, 07 Sep 2022 01:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=OSgMN4a60zMLwOh0Nqh8J3OQ1N19J/QwHbMg5lxsY1U=;
        b=K/k7pislpvub9Y6lIFFh862ZXn7yWX1uJ+YcgbfabAvz5ecz2HwJVT2C/C+CwT2SDm
         zSWmVe0FV9zjik+ZV2yne29uqg3Ty8VIRH2UTVvVSORGkxBFSc0k9xgdfDsE8j9xWo7P
         hPkLXFfs8DkmW8bljWUqhIm6QSF0lJ5cdFbo1qe+94xrH+a5JG8w2JV5TQ5I0i2ypV0N
         EtkZUNY1XHnW5tHbKPNV2zONdg2DjJaiIuWHar41NoGWXLlUqdUDZgs2wC2hsBbXuzI9
         HnLWrSDGAZglzyldNe7QdUZyjemqDx5BE1OClqOa/Oz1PHKzNwCfz3qJrjOPIWNeNu0E
         6W/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=OSgMN4a60zMLwOh0Nqh8J3OQ1N19J/QwHbMg5lxsY1U=;
        b=vjk6Tw7+qfd7dXbMBQcevNeZtT0JeSYY9EQGou1xjLP9m5athkAw6PZ+62w1Lpj4O+
         n6AzMEfDrLFQH1wvw9FE5sGTU9gDranhf58IEnEHlxLs11WFp8UGPm9gs6oSOH8jnYyg
         iB9SIDi/Od/41Dbd3jN5T0YA587SYQKSE9lz4Lw3Vc0P6ydi9cVo+M40PwWzKr7TGikN
         Z0AQ/BhxQEzBsAtmtIqXQkKMfF9kxc2FMzhrk5FcRY05jG4BNQYCWd8D+JbIZOqEHEMo
         QA97St9bTjnLKzlETINgAkgfrwyBtxPHzfcq4U84rN8nIbeDSn12MzJCLyc1PtNIMhNT
         1P3Q==
X-Gm-Message-State: ACgBeo2YwV9fq0kr1XAkolfTA3KxFWQ55bOTE1u03UPChtEolJY08S1T
        4kvnb8i4hsEkfC46AjqiSJIJyIcc8c5wvaozwtGQMWnQmLA=
X-Google-Smtp-Source: AA6agR5of2pswumzTuhcA0YWXp8eVDVJ9srvwHRjzOO0IJtceKK5mhzy6qx2SFA2vwjtwdSfa8r5tf0bDFSrYoIc70A=
X-Received: by 2002:a67:d712:0:b0:390:d3b8:3e97 with SMTP id
 p18-20020a67d712000000b00390d3b83e97mr638006vsj.13.1662539834963; Wed, 07 Sep
 2022 01:37:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220906013040.2467-1-ematsumiya@suse.de>
In-Reply-To: <20220906013040.2467-1-ematsumiya@suse.de>
From:   =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Date:   Wed, 7 Sep 2022 10:37:04 +0200
Message-ID: <CA+5B0FNBJVFC6-SfVodctu0DkyyZ9DzJM8OJsDBbVb453Mvfsw@mail.gmail.com>
Subject: Re: [PATCH] cifs: perf improvement - use faster macros ALIGN() and round_up()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Changes are good from a readability stand point but like the others
I'm very skeptical about the perf improvement claims.

On Tue, Sep 6, 2022 at 3:34 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
> But also replace (DIV_ROUND_UP(len, 8) * 8) with ALIGN(len, 8), which,
> if not optimized by the compiler, has the overhead of a multiplication
> and a division. Do the same for roundup() by replacing it by round_up()
> (division-less version, but requires the multiple to be a power of 2,
> which is always the case for us).

Many of these compile to the same division-less instructions
especially if any of the values are known at compile time.

> @@ -2305,7 +2305,7 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,

smb1 and computed at compile time

> @@ -3350,8 +3350,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,

smb1

> @@ -2833,9 +2833,12 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
> @@ -2871,8 +2874,12 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)

connect time

> @@ -1318,7 +1313,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
> @@ -1442,8 +1437,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
> @@ -1494,7 +1488,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
> @@ -1546,7 +1540,7 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_data *sess_data)
> @@ -1747,7 +1741,7 @@ sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)

connect time

> @@ -207,7 +207,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> -               size[0] = 1; /* sizeof __u8 See MS-FSCC section 2.4.11 */
> +               size[0] = sizeof(u8); /* See MS-FSCC section 2.4.11 */
> -               size[0] = 8; /* sizeof __le64 */
> +               size[0] = sizeof(__le64);

Hot path but no functional change

> @@ -248,7 +248,7 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
>                  * Some windows servers (win2016) will pad also the final
>                  * PDU in a compound to 8 bytes.
>                  */
> -               if (((calc_len + 7) & ~7) == len)
> +               if (ALIGN(calc_len, 8) == len)

Hot path but should compile to the same thing

> @@ -466,15 +466,14 @@ build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
> @@ -511,8 +510,7 @@ build_netname_ctxt(struct smb2_netname_neg_context *pneg_ctxt, char *hostname)
> @@ -557,18 +555,18 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> @@ -595,9 +593,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> @@ -780,7 +776,7 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,

connect time

> @@ -2413,7 +2409,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
> @@ -2487,7 +2483,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)

only relevant if mounted with some acl flags

> @@ -2581,7 +2577,7 @@ alloc_path_with_tree_prefix(__le16 **out_path, int *out_size, int *out_len,
> -       *out_size = roundup(*out_len * sizeof(__le16), 8);
> +       *out_size = round_up(*out_len * sizeof(__le16), 8);

Hot path but from my experiments, round_up() compiles to an *extra*
instruction. See below.

> @@ -2687,20 +2683,17 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,

Only relevant on posix mounts.

> @@ -2826,9 +2819,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
> -               copy_size = uni_path_len;
> -               if (copy_size % 8 != 0)
> -                       copy_size = roundup(copy_size, 8);
> +               copy_size = round_up(uni_path_len, 8);
> @@ -4090,7 +4081,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
> -                       *total_len = DIV_ROUND_UP(*total_len, 8) * 8;
> +                       *total_len = ALIGN(*total_len, 8);

These 2 are also hot paths, but skeptical about the optimizations.

I've looked at those macros in Compiler Explorer and sure enough they
compile to the same thing on x86_64.
Even worse, the optimized versions compile with extra instructions for some:

https://godbolt.org/z/z1xhhW9sj

size_t mod2(size_t num) {
    return num%2;
}

size_t is_aligned2(size_t num) {
    return IS_ALIGNED(num, 2);
}

mod2:
        mov     rax, rdi
        and     eax, 1
        ret

is_aligned2:
        mov     rax, rdi
        not     rax  <=== extra
        and     eax, 1
        ret
--------------------------

size_t align8(size_t num) {
    return ALIGN(num, 8);
}

size_t align_andshift8(size_t num) {
    return ((num + 7) & ~7);
}


align8:
        lea     rax, [rdi+7]
        and     rax, -8
        ret
align_andshift8:
        lea     rax, [rdi+7]
        and     rax, -8
        ret

same code
--------------------------

size_t dru8(size_t num) {
    return DIV_ROUND_UP(num, 8)*8;
}

size_t rnup8_a(size_t num) {
    return round_up(num, 8);
}

size_t rnup8_b(size_t num) {
    return roundup(num, 8);
}

dru8:
        lea     rax, [rdi+7]
        and     rax, -8
        ret
rnup8_a:
        lea     rax, [rdi-1]
        or      rax, 7 <==== extra
        add     rax, 1
        ret
rnup8_b:
        lea     rax, [rdi+7]
        and     rax, -8
        ret

round_up has an extra instruction
--------------------------

I suspect the improvements are more likely to be related to caches,
system load, server load, ...
You can try to use perf to make a flamegraph and compare.

Cheers,
