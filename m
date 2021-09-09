Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47017C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 23:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B6B261131
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 23:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbhIIXT7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Sep 2021 19:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbhIIXT6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Sep 2021 19:19:58 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03ECC061575
        for <linux-cifs@vger.kernel.org>; Thu,  9 Sep 2021 16:18:48 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id l11so199979lfe.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Sep 2021 16:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=24OiQEagYnGFpj3+NGy+9+hEuI1pFEfynjKEqtjDKmo=;
        b=WnlsHLCQAg6z9X9lX0IYrDy1d5zlyhLU1E1orPd5xj4ICSGTcRcLGPz4Ntz3FIsIV8
         a8SP2w6KtVS+kdRPpwQhKsXQ4Hj++eVPXKIIa7FN6EeNq+mhq1MuEsEIQw6letKPz2Ym
         syGD4/X5Xhfuwb1c3VoH/eKQh3gJc3E927jpa/u+OKni6OPs01oIxNdj0ANW+4bmsjaR
         zYRmYUgRSK6lLh0Rwyv1MQqkrCR11lzI079qWHLhN7r9Ux0NN2M77nhgpsi369K1h53e
         6MnZ8keoQJYP76i0uxDdM++OWwxjTyfDS/Xm5RyFYpgkT+TJUKbxD7ZTrT7+82cBXrj9
         /16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=24OiQEagYnGFpj3+NGy+9+hEuI1pFEfynjKEqtjDKmo=;
        b=vNRV1tVolZW3yuW7WiHWogPbYMPo3y+hHWj6bj92U+PgROdXSDGbkg7Zg2gKK8gU7+
         xnrM/fzDKLcqgTnDG4zW6cjVVgPPyIPRTQ1lhs9oxb8lwfAS4PXGeOcv7pmjDcGpXp+0
         j9UGtUiM+hhRjnmXhCBCaNDyAssbWtFuiJEnCFiingwJG7oajPwmRRt1Q6IaHi6FvAUf
         KDm72z/DQMWhI1iXfdJkvxC6V0Ht3oPmvw/WVZ2qetcHxqGBFRlYHSgZ+pSOsoP4LToA
         CVoeRDp5nJgcGKvPT1Cn7CyJo+1VkGoyz4NWiOMkPYvoJ5ni9NWnz2zf+L1k9Jla2HCh
         UDgQ==
X-Gm-Message-State: AOAM531Iboq1o+DhqXtfh0Nwn7ylHxe1VrMbM0ytQD3f7U9JeryppkoY
        8JmxQN0XIJoK7ZzswclJlXGlOzzUBh9y+m7nfCwNJlO51Xc=
X-Received: by 2002:ac2:46fb:: with SMTP id q27mt834517lfo.595.1631229526841;
 Thu, 09 Sep 2021 16:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvadF7FkC1NhVyYNBG_XzwH4daryt42YLJrHnn5ws1Y=A@mail.gmail.com>
In-Reply-To: <CAH2r5mvadF7FkC1NhVyYNBG_XzwH4daryt42YLJrHnn5ws1Y=A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Sep 2021 18:18:36 -0500
Message-ID: <CAH2r5mtObjbem+BeKxB2=6DtrhLrLANwxrjmRJW47KbMaoRyBQ@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd fixes
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Buildbot regression tests passed:

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/59

On Thu, Sep 9, 2021 at 4:59 PM Steve French <smfrench@gmail.com> wrote:
>
> Please pull the following changes since commit
> 9c849ce86e0fa93a218614eac562ace44053d7ce:
>
>   Merge tag '5.15-rc-smb3-fixes-part1' of
> git://git.samba.org/sfrench/cifs-2.6 (2021-08-31 09:22:37 -0700)
>
> are available in the Git repository at:
>
>   git://git.samba.org/ksmbd.git tags/5.15-rc-ksmbd-part2
>
> for you to fetch changes up to 4cf0ccd033d9cedef870eb8598a55851e680a173:
>
>   ksmbd: fix control flow issues in sid_to_id() (2021-09-08 17:16:13 -0500)
>
> ----------------------------------------------------------------
> 18 ksmbd fixes including:
> - various fixes pointed out by coverity, and a minor cleanup patch
> - id mapping and ownership fixes
> - an smbdirect fix
>
> ----------------------------------------------------------------
> Christian Brauner (11):
>       ksmbd: fix lookup on idmapped mounts
>       ksmbd: fix translation in smb2_populate_readdir_entry()
>       ksmbd: fix translation in create_posix_rsp_buf()
>       ksmbd: fix translation in ksmbd_acls_fattr()
>       ksmbd: fix translation in acl entries
>       ksmbd: fix subauth 0 handling in sid_to_id()
>       ksmbd: fix translation in sid_to_id()
>       ndr: fix translation in ndr_encode_posix_acl()
>       ksmbd: ensure error is surfaced in set_file_basic_info()
>       ksmbd: remove setattr preparations in set_file_basic_info()
>       ksmbd: defer notify_change() call
>
> Colin Ian King (1):
>       ksmbd: add missing assignments to ret on ndr_read_int64 read calls
>
> Hyunchul Lee (1):
>       ksmbd: smbd: fix dma mapping error in smb_direct_post_send_data
>
> Namjae Jeon (4):
>       ksmbd: remove unused ksmbd_file_table_flush function
>       ksmbd: add validation for ndr read/write functions
>       ksmbd: fix read of uninitialized variable ret in set_file_basic_info
>       ksmbd: fix control flow issues in sid_to_id()
>
> Per Forlin (1):
>       ksmbd: Reduce error log 'speed is unknown' to debug
>
>  fs/ksmbd/ndr.c            | 383
> ++++++++++++++++++++++++++++++++++++--------------
>  fs/ksmbd/oplock.c         |   6 +-
>  fs/ksmbd/smb2pdu.c        |  69 +++++----
>  fs/ksmbd/smb_common.c     |   4 +-
>  fs/ksmbd/smb_common.h     |   1 -
>  fs/ksmbd/smbacl.c         |  79 +++++++----
>  fs/ksmbd/smbacl.h         |  25 ++++
>  fs/ksmbd/transport_rdma.c |   2 +-
>  fs/ksmbd/vfs.c            |  47 ++++---
>  fs/ksmbd/vfs.h            |   3 +-
>  fs/ksmbd/vfs_cache.c      |  16 ---
>  fs/ksmbd/vfs_cache.h      |   1 -
>  12 files changed, 413 insertions(+), 223 deletions(-)
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
