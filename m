Return-Path: <SRS0=6quT=36=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE3FC2BA83
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 01:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E4B208C4
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 01:00:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sfp+MISs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgBJBAc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Feb 2020 20:00:32 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:35439 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgBJBAc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Feb 2020 20:00:32 -0500
Received: by mail-io1-f67.google.com with SMTP id h8so5727715iob.2
        for <linux-cifs@vger.kernel.org>; Sun, 09 Feb 2020 17:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=acmuRlygnj/Bqt8PLP0D0I2qZ/JePs5H6uRTfdA27pU=;
        b=Sfp+MISstFnnvIdikRNQcDc/tY3nVcpn1zR9UkPe9aSglsV30kTa6rRNNcm9qaHvzz
         LSy5GPj+bFUlkW4vltaE0zITVsgm8gjBwN7HpOKnl6mccPelvO79TxclM0SvDZzptLTt
         3wo4yBiC1U2Z7mch55pHTdUA4jlsDAeIltL0iCTpEgXKprnD2NLXQYDJSG9yNzUNC3AM
         IXFHdVl5SRj1MYdW7NVtkZqbAOR6vFhkbEYdGGqaNnBXq9SFWZ1eq5p7IQ13HJpIEB6g
         GLEj4CuQ8p2gbJMf3NZSehDPv+J+DqqSgCRlm6dq89iEIFnOsoN0RVC/8kUZd7iOpyZW
         vMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=acmuRlygnj/Bqt8PLP0D0I2qZ/JePs5H6uRTfdA27pU=;
        b=JZGmV2oFN5SS/su+7F6MhIvT0moc/vdqE5tqkWIZWSZCLX8f1cbb5u4b1XBYSTtFUP
         1hI7t/rlNWoq+z5SZBj9OdY9PGp0TcboiXSF14t9xrd+jqsjXg6JDarHt0GwZkBNJDSv
         69V8o9qCMy+Z77mCwQ0QpeCNgWyMtZrWHqX/pGt1iYPDWEzhNC2nt77tFf8b6BlZ7X5h
         JWalO34ZtgeHO8RJeXLcyv6bqPyTmjR7YRjamMRd0/tadkZDZxPK9XSuXP+9OmV5c879
         pCEY83BxlWXOi4DTfVqVhSARHsgDOIB0zZH4OnqfDC1aNVIpMtKEw8iczZKHiASjq8w+
         Uryg==
X-Gm-Message-State: APjAAAXRCFba4KeoY569QqpLBrv3WdYwPIgDaqsxorEgQwszH86fWAUp
        5FVeBPRRQNtoAKW+i7G8r5SIddxWqNOeLDhZUnw=
X-Google-Smtp-Source: APXvYqyPd91oQDslgeleIUjr0V0HmKCp6mTpYZyCP2lUXc0BXlEMrd0r2qSPoI4rCEUIAm+G0kACatBtSvwApUI+FF8=
X-Received: by 2002:a5e:9515:: with SMTP id r21mr7341038ioj.169.1581296431272;
 Sun, 09 Feb 2020 17:00:31 -0800 (PST)
MIME-Version: 1.0
References: <20200208145058.10429-1-aaptel@suse.com>
In-Reply-To: <20200208145058.10429-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 9 Feb 2020 19:00:20 -0600
Message-ID: <CAH2r5mvSBraHGj=ZcjK3QqUbdya67uYs8vScyh_Bh5dKKmzfYg@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: rename posix create rsp
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Sat, Feb 8, 2020 at 8:51 AM Aurelien Aptel <aaptel@suse.com> wrote:
>
> little progress on the posix create response.
>
> * rename struct to create_posix_rsp to match with the request
>   create_posix context
> * make struct packed
> * pass smb info struct for parse_posix_ctxt to fill
> * use smb info struct as param
> * update TODO
>
> What needs to be done:
>
> SMB2_open() has an optional smb info out argument that it will fill.
> Callers making use of this are:
>
> - smb3_query_mf_symlink (need to investigate)
> - smb2_open_file
>
> Callers of smb2_open_file (via server->ops->open) are passing an
> smbinfo struct but that struct cannot hold POSIX information. All the
> call stack needs to be changed for a different info type. Maybe pass
> SMB generic struct like cifs_fattr instead.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/smb2pdu.c | 13 +++++++++----
>  fs/cifs/smb2pdu.h |  9 ++++++---
>  2 files changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 1234f9ccab03..7d4d7cdb2eb4 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1940,13 +1940,18 @@ parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
>  }
>
>  static void
> -parse_posix_ctxt(struct create_context *cc, struct smb_posix_info *pposix_inf)
> +parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info)
>  {
> -       /* struct smb_posix_info *ppinf = (struct smb_posix_info *)cc; */
> +       /* struct create_posix_rsp *posix = (struct create_posix_rsp *)cc; */
>
> -       /* TODO: Need to add parsing for the context and return */
> +       /*
> +        * TODO: Need to add parsing for the context and return. Can
> +        * smb2_file_all_info hold POSIX data? Need to change the
> +        * passed type from SMB2_open.
> +        */
>         printk_once(KERN_WARNING
>                     "SMB3 3.11 POSIX response context not completed yet\n");
> +
>  }
>
>  void
> @@ -1984,7 +1989,7 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
>                         parse_query_id_ctxt(cc, buf);
>                 else if ((le16_to_cpu(cc->NameLength) == 16)) {
>                         if (memcmp(name, smb3_create_tag_posix, 16) == 0)
> -                               parse_posix_ctxt(cc, NULL);
> +                               parse_posix_ctxt(cc, buf);
>                 }
>                 /* else {
>                         cifs_dbg(FYI, "Context not matched with len %d\n",
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index fa03df130f1a..c84405ed603c 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -1604,11 +1604,14 @@ struct smb2_file_id_information {
>  extern char smb2_padding[7];
>
>  /* equivalent of the contents of SMB3.1.1 POSIX open context response */
> -struct smb_posix_info {
> +struct create_posix_rsp {
>         __le32 nlink;
>         __le32 reparse_tag;
>         __le32 mode;
> -       kuid_t  uid;
> -       kuid_t  gid;
> +       /*
> +         var sized owner SID
> +         var sized group SID
> +       */
> +} __packed;
>  };
>  #endif                         /* _SMB2PDU_H */
> --
> 2.16.4
>


-- 
Thanks,

Steve
