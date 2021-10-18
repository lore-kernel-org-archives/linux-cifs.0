Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28811C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Oct 2021 14:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C53660EE3
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Oct 2021 14:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhJROJA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Oct 2021 10:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234944AbhJROGx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 18 Oct 2021 10:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB15B60EE3
        for <linux-cifs@vger.kernel.org>; Mon, 18 Oct 2021 14:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634565880;
        bh=Vva2ejMH4JoHY85AFlBKPI+8Cf97CsOHSYib5mm3F+0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=O2y/ZpYwo5LIpzyHfRuP47rKzbQHd0tuGsGt06XGxWQV3UxtTrS6tf2Lr6h/r+XmC
         mtQcwCYEZFLLeOkdLWXXoWqS/Sq2EtaOomobLOIPbQhcywe1FkK89vG9xiosi2MVdL
         KOOmkDCrZz2acWJp/xmNFCqJCDbC4ja6C5AW2q5e3AA628KuorcqERPx3UB67kRJ6Z
         gqxqDITFfxuKFjkxjfBoUoTbzwNtcccmfnQVKM2A/5mNUZm3/ddDCrg1QS4geDTlsm
         mDncMeD6NSa/q84c73MSaYUEK/3on8+eRiOLURctZyFwFAA6y2AzPq8r9PjXvmMVe0
         vOetE8j/qC+WQ==
Received: by mail-oi1-f170.google.com with SMTP id v77so20165263oie.1
        for <linux-cifs@vger.kernel.org>; Mon, 18 Oct 2021 07:04:40 -0700 (PDT)
X-Gm-Message-State: AOAM532Fd7kgQ7nP0wl/T89GAhqaZINN4dN9JD4KLBgQed6Pk7xwohuz
        GcLGeCKPXTjP7aOsVnv7lX5hBW1Hb2vZyXOzezc=
X-Google-Smtp-Source: ABdhPJzezQzmzdQA/BPrg8siUZmggvqaDMbzLmzfwZS06WNpF0k/FwhF4fo8aZEGSIaFBz/qS43h+BPWAb+eXIqBpnI=
X-Received: by 2002:a05:6808:6c2:: with SMTP id m2mr6800oih.8.1634565880162;
 Mon, 18 Oct 2021 07:04:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Mon, 18 Oct 2021 07:04:39
 -0700 (PDT)
In-Reply-To: <20211016235715.3469969-1-mmakassikis@freebox.fr>
References: <20211016235715.3469969-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 18 Oct 2021 23:04:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9iC6+S+rrp=DGyR6f7qxOQm7i-nqmHK=m2qM8t3UbJdQ@mail.gmail.com>
Message-ID: <CAKYAXd9iC6+S+rrp=DGyR6f7qxOQm7i-nqmHK=m2qM8t3UbJdQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: add buffer validation in session setup
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Marios,
> +	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
> +	negblob_len = le16_to_cpu(req->SecurityBufferLength);
> +	if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4))
> +		return -EINVAL;
Like the following code, negblob is still used without buffer check.
We need to add buffer check for it here ?

if (negblob->MessageType == NtLmNegotiate) {

} else if (negblob->MessageType == NtLmAuthenticate) {

Thanks!

> +
>  	negblob = (struct negotiate_message *)((char *)&req->hdr.ProtocolId +
> -			le16_to_cpu(req->SecurityBufferOffset));
> +			negblob_off);
>
> -	if (decode_negotiation_token(work, negblob) == 0) {
> +	if (decode_negotiation_token(conn, negblob, negblob_len) == 0) {
>  		if (conn->mechToken)
>  			negblob = (struct negotiate_message *)conn->mechToken;
>  	}
> @@ -1736,7 +1746,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
>  			sess->Preauth_HashValue = NULL;
>  		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
>  			if (negblob->MessageType == NtLmNegotiate) {
> -				rc = ntlm_negotiate(work, negblob);
> +				rc = ntlm_negotiate(work, negblob, negblob_len);
>  				if (rc)
>  					goto out_err;
>  				rsp->hdr.Status =
> --
> 2.25.1
>
>
