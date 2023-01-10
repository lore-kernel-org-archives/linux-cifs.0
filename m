Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239EBC54EBE
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 02:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbjAJC0Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Jan 2023 21:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237868AbjAJC0N (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Jan 2023 21:26:13 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661A26471
        for <linux-cifs@vger.kernel.org>; Mon,  9 Jan 2023 18:26:12 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id u9so25099628ejo.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Jan 2023 18:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4OrcwjoBFteoFT+nIQ8h7mB4FRP3xAPsVOzp+UGZCok=;
        b=ckcimHMlQL/cR6xvePAl2SjwpKW3aD39KIv2GFSX/JidKUCE7WlR8zeSb+wJKT7+ya
         Ehni3b2SNh1XXnBcgKUDbiczcvZ8Tq5v5/sjuI0ViPOAq1BvO5KJs7rmGi5PhULd9FzM
         vI8avPDn4u1NRZrtg/XuAvzty9oDGTqhXQYge3zRobQADn05YGt/nGAPh38Dw76qFsDQ
         P2ZnfSeheRo1darHKh7Yy0ApJqQf93HnNRFxshCcuTwEzC5Jc39fhOxSECT26opqbtKC
         JSCuFU7Uq74cFjhei1sjAvkmJ3RGO6V8iNeOHc25ArZICn2PUrrsX9hnWRAAXc1EMn+C
         l+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4OrcwjoBFteoFT+nIQ8h7mB4FRP3xAPsVOzp+UGZCok=;
        b=yxsrLNE9H1xuyXptqQTVVBxW0HgKKGcaf82OMJ20NbM+9riG3NEA1xT2FNVz4h6XyU
         Y/IH105BZ1J6tVNrG3cnrwn25LyNib7pFc1MlmoA58j5zyBcIlMrN4KOq0iM+BrgmHJY
         z9g304ChcaITxwe06tN5rrE6ZGgP+VDRsFnklWvOZosWUoW7CD+FAB5qghpbgY3bckZn
         ouLWtE/NXNR0qM0P6nd6hRkNgI1rKmf9NJrSWMxOAyvZ3SOWd1pLLav/KlkAOg9fMLLV
         ucK+Y14gVu7KcxUKIoIaYHCKfaSWsisRy2uNPJ5aFor1XHGRSRzYVCwwKV1xbTEm4y6/
         V7SA==
X-Gm-Message-State: AFqh2krmDQIC8pitJWxutcQU/x0aAlf9bm8xteeEuVbiE1L/s7Nnd0zI
        lZLLsg+7sVhgs5sCRS+DnthQp55ChWzpZ0E9UT8=
X-Google-Smtp-Source: AMrXdXuBX4jLkJGt1pm5d2nR3a/EbLolsTRA/0QpIRADNq9aJ5vUvKJK8i9Yn3CswT+k/PhOiT+7HuJLYq+Rm1SzgMo=
X-Received: by 2002:a17:906:2442:b0:84d:472f:fff4 with SMTP id
 a2-20020a170906244200b0084d472ffff4mr505861ejb.757.1673317570916; Mon, 09 Jan
 2023 18:26:10 -0800 (PST)
MIME-Version: 1.0
References: <CAOoqPcSqOZWN7LKmZQzPhu8MWxNsxYoDs2woHotE_te__+MF=w@mail.gmail.com>
 <87pmbnwdz5.fsf@cjr.nz>
In-Reply-To: <87pmbnwdz5.fsf@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 10 Jan 2023 12:25:58 +1000
Message-ID: <CAN05THSrAYxtF=9orWU_iBOu6xVbXz_CTvZNUhe7=5A7Vw6Uig@mail.gmail.com>
Subject: Re: CIFS: kernel BUG at mm/slub.c:435
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Xiaoli Feng <fengxiaoli0714@gmail.com>,
        Steve French <sfrench@samba.org>, lsahlber@redhat.com,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by me

On Tue, 10 Jan 2023 at 08:26, Paulo Alcantara <pc@cjr.nz> wrote:
>
> Xiaoli Feng <fengxiaoli0714@gmail.com> writes:
>
> > Test the latest kernel in the branch for-next of
> > git://git.samba.org/sfrench/cifs-2.6.git. Kernel always panic when
> > mount cifs with option "-o sec=krb5,multiuser".
> >
> > Bug 216878 - CIFS: kernel BUG at mm/slub.c:435
> > https://bugzilla.kernel.org/show_bug.cgi?id=216878
>
> Thanks for the report.
>
> I wasn't able to reproduce it but the issue seems related to
> sesInfoFree() calling kfree_sensitive() again in
> cifs_ses::auth_key.response even though it was kfree_sensitive()'d
> earlier in SMB2_auth_kerberos().
>
> Does below changes fix your issue?  Thanks.
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 2c484d47c592..727f16b426be 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1482,8 +1482,11 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
>  out_put_spnego_key:
>         key_invalidate(spnego_key);
>         key_put(spnego_key);
> -       if (rc)
> +       if (rc) {
>                 kfree_sensitive(ses->auth_key.response);
> +               ses->auth_key.response = NULL;
> +               ses->auth_key.len = 0;
> +       }
>  out:
>         sess_data->result = rc;
>         sess_data->func = NULL;
