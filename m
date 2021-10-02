Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EBCC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 05:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4F161A54
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 05:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhJBFvL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 01:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhJBFvK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 01:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7223661AAD
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 05:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633153765;
        bh=RoMzyT9xTsFjTu6EGSMLGidmjyDZJ2Xa4bv4hKZ2F7I=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=d18+k692HpccVeBkkRzO45iP+W0JGT1A/Ud2EK8Tf6a2Xa4Yp9Zqwsyi5iBZdCVSR
         KcJ0z43BVoHyvE+Pb9yHSKdBKBza6M5nrPlx+ym+3dS4FvT/X5hsG5wsETn1MAe1Nz
         huQ+lmCqdR66Y0LtfTziSyxgzfvhV8u3tcpuc70l3I7Lh/pAQeUsHiPpFJAcfke9Ei
         Qp0J+Mx6msMXvQTqwWfgKuTMmGohjN7dcXLZ/QPJHy9b5hHaK3WJqT5s2+NYX6ZrDn
         lHBVtZrWcVvdPD+fNd9wKTlj5/pnDMIN2j+xb0EOUqW2D6VJ182tHSo1mgDsLKolY5
         frN++6V+ONVBA==
Received: by mail-oo1-f44.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso3554071ooq.8
        for <linux-cifs@vger.kernel.org>; Fri, 01 Oct 2021 22:49:25 -0700 (PDT)
X-Gm-Message-State: AOAM5339uvAwibVLgpBOg8MpebeEqAiF1dKxJ5Sa/dSbV1lGxtGB21iS
        jmGQYFjt1fDfZE41BqtsH87fQDF1HydSv+lIoRA=
X-Google-Smtp-Source: ABdhPJxWOaYBjqua9no1YPpHvlAgK7HTRxHsu7dx1LD3+nJ45AGHVNkKySv4SaakkDfG9Cal3p4iPpm5HA+uiJA+iNI=
X-Received: by 2002:a05:6820:1018:: with SMTP id v24mr1582695oor.27.1633153764821;
 Fri, 01 Oct 2021 22:49:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 1 Oct 2021 22:49:24 -0700 (PDT)
In-Reply-To: <20211001120421.327245-15-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org> <20211001120421.327245-15-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 2 Oct 2021 14:49:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_i+L0CwnS4zSpaRq7Yrnq0myEaoAYs6T9mD9+CkUM1pg@mail.gmail.com>
Message-ID: <CAKYAXd_i+L0CwnS4zSpaRq7Yrnq0myEaoAYs6T9mD9+CkUM1pg@mail.gmail.com>
Subject: Re: [PATCH v5 14/20] ksmbd: add ksmbd_smb2_cur_pdu_buflen()
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-01 21:04 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
> ---
>  fs/ksmbd/smb2misc.c | 25 +++++++++++++++++++++++++
>  fs/ksmbd/smb2pdu.h  |  1 +
>  2 files changed, 26 insertions(+)
>
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index 2cc031c39514..76f53db7db8d 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -427,3 +427,28 @@ int smb2_negotiate_request(struct ksmbd_work *work)
>  {
>  	return ksmbd_smb_negotiate_common(work, SMB2_NEGOTIATE_HE);
>  }
> +
> +/**
> + * ksmbd_smb2_cur_pdu_buflen() - Get len of current SMB2 PDU buffer
> + * This returns the lenght including any possible padding.
> + * @work: smb work containing request buffer
> + */
> +unsigned int ksmbd_smb2_cur_pdu_buflen(struct ksmbd_work *work)
> +{
This patch will cause unused function build warning. so need to
combine it with "ksmbd: use ksmbd_smb2_cur_pdu_buflen() in
ksmbd_smb2_check_message() "

Thanks!
> +	struct smb2_hdr *hdr = ksmbd_req_buf_next(work);
> +	unsigned int buf_len;
> +	unsigned int pdu_len;
> +
> +	if (hdr->NextCommand != 0) {
> +		/*
> +		 * hdr->NextCommand has already been validated by
> +		 * init_chained_smb2_rsp().
> +		 */
> +		return __le32_to_cpu(hdr->NextCommand);
> +	}
> +
> +	buf_len = get_rfc1002_len(work->request_buf);
> +	pdu_len = buf_len - work->next_smb2_rcv_hdr_off;
> +	return pdu_len;
> +}
> +
> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
> index a6dec5ec6a54..c5fa8256b0bb 100644
> --- a/fs/ksmbd/smb2pdu.h
> +++ b/fs/ksmbd/smb2pdu.h
> @@ -1680,6 +1680,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work);
>
>  /* smb2 misc functions */
>  int ksmbd_smb2_check_message(struct ksmbd_work *work);
> +unsigned int ksmbd_smb2_cur_pdu_buflen(struct ksmbd_work *work);
>
>  /* smb2 command handlers */
>  int smb2_handle_negotiate(struct ksmbd_work *work);
> --
> 2.31.1
>
>
