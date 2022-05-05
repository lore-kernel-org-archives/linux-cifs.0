Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75597C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  5 May 2022 21:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350832AbiEEVnJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 May 2022 17:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245689AbiEEVnH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 May 2022 17:43:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FC413F00
        for <linux-cifs@vger.kernel.org>; Thu,  5 May 2022 14:39:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D32361EF9
        for <linux-cifs@vger.kernel.org>; Thu,  5 May 2022 21:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EEDC385A8
        for <linux-cifs@vger.kernel.org>; Thu,  5 May 2022 21:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651786765;
        bh=k4t3FRGPiv735d1lenPS3HJMDZEjjE59knc7XU96Opo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=XhKEFaa7xrc9ymRIBRIdFUbRGcT4afpsMEASg/X9yk/4TmW6CwIwNRWqSJNIQYq1q
         pEkFRNWklzmC/txq32z/iupUvBTNfrKF9oJChkpAxlNfKayr68rTOcElBbQ6g5TGPt
         V1S3akbrc64o1wxkJzIROf1v8/xDN5dUdpbht7T2/RSlrTKKTbhexfjIN2dCr81fq3
         usrthfPzbVhx1ydn2vVvf7pVWQO06GApvoAR1hwHMNmzJSTavAv5fYxOPxqWV+JM/Z
         gorDhgkq23FbdnXazaLshpfB67SSw75cLKGBs/XidtHXyLMu/HRDN0jqPaiWsTbTYr
         fZS6GN0fKvTPA==
Received: by mail-wr1-f48.google.com with SMTP id j15so7707251wrb.2
        for <linux-cifs@vger.kernel.org>; Thu, 05 May 2022 14:39:24 -0700 (PDT)
X-Gm-Message-State: AOAM532hS5/e4w3tvTcottyUN9WdmHtodkCfRdoUTIIsnh2kSQuYs/xp
        EQjGuPdyMNgn5BEpCqTN4UBCGx6YRTFZiYjbL5k=
X-Google-Smtp-Source: ABdhPJyLNEhm6/sgUMVubCMyu6u+F35ET+wsZfB2XW5to7/PyMQOEQ7E0H2mWsnIVu0cm0QzrVpA/F3q7gvLjelT+nE=
X-Received: by 2002:adf:fe47:0:b0:20a:c899:829f with SMTP id
 m7-20020adffe47000000b0020ac899829fmr93131wrs.165.1651786763169; Thu, 05 May
 2022 14:39:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4571:0:0:0:0:0 with HTTP; Thu, 5 May 2022 14:39:22 -0700 (PDT)
In-Reply-To: <20220504224640.2865787-1-mmakassikis@freebox.fr>
References: <20220504224640.2865787-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 6 May 2022 06:39:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8teno-cU0th4g5-+=iQag=Vz92BhJ5KuknzvqvqNE-fw@mail.gmail.com>
Message-ID: <CAKYAXd8teno-cU0th4g5-+=iQag=Vz92BhJ5KuknzvqvqNE-fw@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: validate length in smb2_write()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-05 7:46 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> The SMB2 Write packet contains data that is to be written
> to a file or to a pipe. Depending on the client, there may
> be padding between the header and the data field.
> Currently, the length is validated only in the case padding
> is present.
>
> Since the DataOffset field always points to the beginning
> of the data, there is no need to have a special case for
> padding. By removing this, the length is validated in both
> cases.
>
> Additionally, fix the length check: DataOffset and Length
> fields are relative to the SMB header start, while the packet
> length returned by get_rfc1002_len() includes 4 additional
> bytes.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
> Change since v2:
Hi Marios,
>  - the length check was wrong, as it did not account for the rfc1002
>  header in work->request_buf.
We get pdu size in ->request_buf using get_rfc1002_len(). We don't
need to account for it. So v2 patch is correct.

Thanks for your patch:)
>
>  fs/ksmbd/smb2pdu.c | 49 ++++++++++++++++++----------------------------
>  1 file changed, 19 insertions(+), 30 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 16c803a9d996..23b47e505e2b 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -6328,23 +6328,18 @@ static noinline int smb2_write_pipe(struct
> ksmbd_work *work)
>  	length = le32_to_cpu(req->Length);
>  	id = req->VolatileFileId;
>
> -	if (le16_to_cpu(req->DataOffset) ==
> -	    offsetof(struct smb2_write_req, Buffer)) {
> -		data_buf = (char *)&req->Buffer[0];
> -	} else {
> -		if ((u64)le16_to_cpu(req->DataOffset) + length >
> -		    get_rfc1002_len(work->request_buf)) {
> -			pr_err("invalid write data offset %u, smb_len %u\n",
> -			       le16_to_cpu(req->DataOffset),
> -			       get_rfc1002_len(work->request_buf));
> -			err = -EINVAL;
> -			goto out;
> -		}
> -
> -		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
> -				le16_to_cpu(req->DataOffset));
> +	if ((u64)le16_to_cpu(req->DataOffset) + length >
> +	    get_rfc1002_len(work->request_buf) - 4) {
> +		pr_err("invalid write data offset %u, smb_len %u\n",
> +		       le16_to_cpu(req->DataOffset),
> +		       get_rfc1002_len(work->request_buf));
> +		err = -EINVAL;
> +		goto out;
>  	}
>
> +	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
> +			   le16_to_cpu(req->DataOffset));
> +
>  	rpc_resp = ksmbd_rpc_write(work->sess, id, data_buf, length);
>  	if (rpc_resp) {
>  		if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
> @@ -6489,22 +6484,16 @@ int smb2_write(struct ksmbd_work *work)
>
>  	if (req->Channel != SMB2_CHANNEL_RDMA_V1 &&
>  	    req->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> -		if (le16_to_cpu(req->DataOffset) ==
> -		    offsetof(struct smb2_write_req, Buffer)) {
> -			data_buf = (char *)&req->Buffer[0];
> -		} else {
> -			if ((u64)le16_to_cpu(req->DataOffset) + length >
> -			    get_rfc1002_len(work->request_buf)) {
> -				pr_err("invalid write data offset %u, smb_len %u\n",
> -				       le16_to_cpu(req->DataOffset),
> -				       get_rfc1002_len(work->request_buf));
> -				err = -EINVAL;
> -				goto out;
> -			}
> -
> -			data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
> -					le16_to_cpu(req->DataOffset));
> +		if ((u64)le16_to_cpu(req->DataOffset) + length >
> +		    get_rfc1002_len(work->request_buf) - 4) {
> +			pr_err("invalid write data offset %u, smb_len %u\n",
> +			       le16_to_cpu(req->DataOffset),
> +			       get_rfc1002_len(work->request_buf));
> +			err = -EINVAL;
> +			goto out;
>  		}
> +		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
> +				    le16_to_cpu(req->DataOffset));
>
>  		ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
>  		if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
> --
> 2.25.1
>
>
