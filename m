Return-Path: <SRS0=CLpK=A7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0B3C433DF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Jul 2020 04:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 903462080D
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Jul 2020 04:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="on1+bAOd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725265AbgGTEBX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Jul 2020 00:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgGTEBX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Jul 2020 00:01:23 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF88DC0619D2;
        Sun, 19 Jul 2020 21:01:22 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l17so16140192iok.7;
        Sun, 19 Jul 2020 21:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=06FB5woN06uiD3GvLoqoO/p4B+0/TRLVi1n7WwNJWW4=;
        b=on1+bAOdCGMblOPS50ks9XVUNV/Pv71/nJg7UHPlRQlJ7zuDhAgO7rCEVd3USaY3Mt
         IgRp2NqdUc1Wj6R15cpQvh1XfiKAY7z6hN2GtCy1Y1bRtAzG0E3cWRAVJeEUuxqRwsML
         9sIww+QZdyIwZKeRBu07fLXx00Rc5Mew8zrCta+ElkHnG2jDkeqyd8Q2AOrIBQeAbpSi
         O7uvX8SD1YJVM3FnYumZDNcZmUcLjkPC86VRexGDux8PO6f053qJnc6IWzdZmNHxeSWU
         sK0/Xt9+oXdDXdH6npB3/vxC1h0ccmI2u+WSHf8qGPDwUp+TWQUfRFn+9zs5BmYJF7jq
         acHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=06FB5woN06uiD3GvLoqoO/p4B+0/TRLVi1n7WwNJWW4=;
        b=EOBoahkbRi0O/+pOU1LSrdNhWn3/x2yoEPTtKOdCzlldDof4Hp7PER0h5lafuXO5UE
         iaAWiGV2MFCqSeHOuZ9la3NcjkTt08g6QSfsjT8znrOvx9+vPAJZeC5xsh++r3B5hbeR
         JnFBXevn7DVzha2VbNz13BGc2MUH0T7TQx6XyjNIOMGsd5ZFYC+aJ4FrKpeD6TRBPO51
         vmb+8/yS397OV9NIcIbSFhnhYJDj9rQE2CZdIJ4J8fRifyWxM+rU3DoppHnkevUQBCyy
         WGjA3IRnx7oB6E1V0Y4gk8XAGXboCzjhDc9Pb1prfmqQCTk/QROvmSAraqng7svNlrx1
         AZbA==
X-Gm-Message-State: AOAM533EvnvMFTWXgYEeoMb281FxtrMuKf+moWK2/J0Gc//i+Epjqtep
        dzrzeinjzGz9NNR2lUQECJ8Ek0Yzf92CVjKkKk+H9kXf
X-Google-Smtp-Source: ABdhPJyDXRT3U/LawJJ68RJgwLHdTTjyNzrLuB+TjtT4/3mDARYFNZ5G3AYZa83I8wYKg6g4GnxCpLIllnnREJHmOm8=
X-Received: by 2002:a05:6638:1414:: with SMTP id k20mr15068626jad.76.1595217681967;
 Sun, 19 Jul 2020 21:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200720001316.22854-1-rdunlap@infradead.org>
In-Reply-To: <20200720001316.22854-1-rdunlap@infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 19 Jul 2020 23:01:11 -0500
Message-ID: <CAH2r5mtaN8kOJ7WRZFxs3W7AUVO=N58G_ai5r6UVqpMhX4j2CA@mail.gmail.com>
Subject: Re: [PATCH] cifs: delete duplicated words in header files
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next

On Sun, Jul 19, 2020 at 7:14 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Drop repeated words in multiple comments.
> (be, use, the, See)
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Steve French <sfrench@samba.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> ---
>  fs/cifs/cifsacl.h  |    4 ++--
>  fs/cifs/cifsglob.h |    2 +-
>  fs/cifs/smb2pdu.h  |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> --- linux-next-20200717.orig/fs/cifs/cifsacl.h
> +++ linux-next-20200717/fs/cifs/cifsacl.h
> @@ -132,7 +132,7 @@ struct cifs_ace {
>  /*
>   * The current SMB3 form of security descriptor is similar to what was used for
>   * cifs (see above) but some fields are split, and fields in the struct below
> - * matches names of fields to the the spec, MS-DTYP (see sections 2.4.5 and
> + * matches names of fields to the spec, MS-DTYP (see sections 2.4.5 and
>   * 2.4.6). Note that "CamelCase" fields are used in this struct in order to
>   * match the MS-DTYP and MS-SMB2 specs which define the wire format.
>   */
> @@ -178,7 +178,7 @@ struct smb3_acl {
>
>  /*
>   * Used to store the special 'NFS SIDs' used to persist the POSIX uid and gid
> - * See See http://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
> + * See http://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
>   */
>  struct owner_sid {
>         u8 Revision;
> --- linux-next-20200717.orig/fs/cifs/cifsglob.h
> +++ linux-next-20200717/fs/cifs/cifsglob.h
> @@ -1466,7 +1466,7 @@ struct cifsInodeInfo {
>         struct list_head llist; /* locks helb by this inode */
>         /*
>          * NOTE: Some code paths call down_read(lock_sem) twice, so
> -        * we must always use use cifs_down_write() instead of down_write()
> +        * we must always use cifs_down_write() instead of down_write()
>          * for this semaphore to avoid deadlocks.
>          */
>         struct rw_semaphore lock_sem;   /* protect the fields above */
> --- linux-next-20200717.orig/fs/cifs/smb2pdu.h
> +++ linux-next-20200717/fs/cifs/smb2pdu.h
> @@ -31,7 +31,7 @@
>   * Note that, due to trying to use names similar to the protocol specifications,
>   * there are many mixed case field names in the structures below.  Although
>   * this does not match typical Linux kernel style, it is necessary to be
> - * be able to match against the protocol specfication.
> + * able to match against the protocol specfication.
>   *
>   * SMB2 commands
>   * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses



-- 
Thanks,

Steve
