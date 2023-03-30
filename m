Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C74C761AF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 22:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjC3W7p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 18:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjC3W7p (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 18:59:45 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C67EB7F
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 15:59:43 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id g17so26611556lfv.4
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 15:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680217182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DgU+ntneYdsoLxNA8NCG2/eTVhTbk5mPllaBmWHKruE=;
        b=j1olcOHuOTDNfkVKq8CRySrGcmBpx3Q+JLcOB90EsQ5Ijf24OZ2OiPnz2+XPfIZh1x
         OBD3a2ip1uo5D87rI26RvroeSH8uQiETNJrUQNwsSwBg+SOvRfMBgO5IPnOO+Wc1NoQg
         P83Fcpt3eP3nqbqRlN0BX3yh02F6Rl6XAjr1F+z+6o1QcVSBCzHb/3LRJZPOGP+8Pr/U
         V0Gs1A1yqCr+k8G7gykTVsUlZlLoQPYgv3eVk4A5yoTvyN/CADpkNL3akGg8fxfm5fZQ
         AR6909dT3242p/jBLHcIsV8IHK9AKlMMs/Z6LJEYIXlgjaixddQcKIVEaQKu1CGL7LbB
         6/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680217182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DgU+ntneYdsoLxNA8NCG2/eTVhTbk5mPllaBmWHKruE=;
        b=vPnrN0mvnZ5tuf+DdSPnYpZDCL9fzuPTaeSbzh3dVi2fYEOpCCVXl6Nvw5si8pL+5Z
         uB8ejp5KIlBoul8Oj0IVR8nb2yPeGGK2ZgN+2T2PtC/IFF+yMpQYWHSyO+dIavSeivcW
         OFTNhTZtB9rtO/O/RgC0VBe9Zhz1tI3PA2gAOEP4fQLnNWkcKAO6rEtA0+8f54IUObVv
         W7KmR2e6v3Yr+pbu4tajuBWgvyzsvZFdncS6FCgUQk1xJtgfZKCiam9zfeTI7pAwcZ96
         F5mEuT1rWntyQcmvR5FdVaOXZvDYip66yowTTQJ/s1+lrN9WVzpOLftf+Dk0/+YvRoMT
         Q2nQ==
X-Gm-Message-State: AAQBX9dzEHUfadhN0jp6TON5ZI/OKReXQYWSDRmJo/eTKjSVo9vmAv9S
        CPVsDcPD8sRG99zRS0XDL845EZ8IvNrjGjZAG3Q=
X-Google-Smtp-Source: AKy350ZQ904ei9xvwaUaN8+JTIAeieFVGsEJsAK1rVnTqVwauKBqFDbHu/eCrIQvkrtnn+3XcUjAgwj2b2Vm1eQyj10=
X-Received: by 2002:ac2:596a:0:b0:4e8:6261:58c2 with SMTP id
 h10-20020ac2596a000000b004e8626158c2mr7204591lfp.7.1680217181829; Thu, 30 Mar
 2023 15:59:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230329201423.32134-1-pc@manguebit.com> <20230329201423.32134-5-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-5-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 30 Mar 2023 17:59:30 -0500
Message-ID: <CAH2r5msUtu+WP+vavSZu--KQ7=hqA4d9sXs-w=17cOyTQ5NujA@mail.gmail.com>
Subject: Re: [PATCH 5/5] cifs: get rid of dead check in smb2_reconnect()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added ronnie's RB and merged into cifs-2.6.git for-next

On Wed, Mar 29, 2023 at 3:14=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> The SMB2_IOCTL check in the switch statement will never be true as we
> return earlier from smb2_reconnect() if @smb2_command =3D=3D SMB2_IOCTL.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/cifs/smb2pdu.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6bd2aa6af18f..2b92132097dc 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -310,7 +310,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>         case SMB2_READ:
>         case SMB2_WRITE:
>         case SMB2_LOCK:
> -       case SMB2_IOCTL:
>         case SMB2_QUERY_DIRECTORY:
>         case SMB2_CHANGE_NOTIFY:
>         case SMB2_QUERY_INFO:
> --
> 2.40.0
>


--=20
Thanks,

Steve
