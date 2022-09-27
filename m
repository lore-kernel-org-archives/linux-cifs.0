Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A624C32771
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Sep 2022 00:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiI0AfY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Sep 2022 20:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiI0AfX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Sep 2022 20:35:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A4E205D8
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 17:35:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E34F861522
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 00:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FBEC433D6
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 00:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664238920;
        bh=cm/GUR4H1ZbohRuk6QV5jcGipRtPp9528Ody3FkJD5k=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ItjQYIJB3lfAwbZjJPzg/ka7yo5M6Xx4ZwQPj4GZDgveNajDeM4SG/CySGNISPxBh
         weZzQQCSQ5qcJBMFrEyDfipAGrBcCBXJLfbu2NqRdWrNm8BmU/9zGOfd6xsNHsfUlg
         v6oLPddxEz+MnlGmbiRGfJbECeWPFXWhpHDk3wgC/4r0un8Z2BcfJkmcFufsUMvu5k
         amtbC38zhmVvOQQ22vrT+Na1tXWELAktjD6Q7PywHN1dO+YVlm1VUUkl5xczLICfE8
         mJ7Nk1U9aFFQOjPR/gfs+DQwpsk9FAFrnPz+XoKpYH1s3md3CC74cspGASOvC7TTCq
         kuJZ1AV6Bqikg==
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1318106fe2cso257211fac.13
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 17:35:20 -0700 (PDT)
X-Gm-Message-State: ACrzQf36aA5FknckQnpFStAJipZBYbkvKLpCRFrGcupMzMFOPsmlDvgg
        v952D+9AM8kR7mGYauPKiIGs+fbJitzP0KTMNCc=
X-Google-Smtp-Source: AMsMyM5qowMtV7TaWpkICPPdD+B/VzDW5CaB9lIT0MyIvxkkhJ8+FP84vwvj1PcUP+YqOwHXJkxhDzv6Z8uQI9GCmi0=
X-Received: by 2002:a05:6871:893:b0:131:84aa:5b80 with SMTP id
 r19-20020a056871089300b0013184aa5b80mr31970oaq.257.1664238919383; Mon, 26 Sep
 2022 17:35:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 26 Sep 2022 17:35:18
 -0700 (PDT)
In-Reply-To: <20220926033631.926637-3-zhangxiaoxu5@huawei.com>
References: <20220926033631.926637-1-zhangxiaoxu5@huawei.com> <20220926033631.926637-3-zhangxiaoxu5@huawei.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 27 Sep 2022 09:35:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8VCmoUgsoBBFKgN3dEz1NfDH34zz=NTa7Cdc+ZgMQZZw@mail.gmail.com>
Message-ID: <CAKYAXd8VCmoUgsoBBFKgN3dEz1NfDH34zz=NTa7Cdc+ZgMQZZw@mail.gmail.com>
Subject: Re: [PATCH v8 2/3] ksmbd: Fix wrong return value and message length
 check in smb2_ioctl()
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, rohiths@microsoft.com,
        smfrench@gmail.com, tom@talpey.com, hyc.lee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-26 12:36 GMT+09:00, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>:
> Commit c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock
> break, and move its struct to smbfs_common") use the defination
> of 'struct validate_negotiate_info_req' in smbfs_common, the
> array length of 'Dialects' changed from 1 to 4, but the protocol
> does not require the client to send all 4. This lead the request
> which satisfied with protocol and server to fail.
>
> So just ensure the request payload has the 'DialectCount' in
> smb2_ioctl(), then fsctl_validate_negotiate_info() will use it
> to validate the payload length and each dialect.
>
> Also when the {in, out}_buf_len is less than the required, should
> goto out to initialize the status in the response header.
>
> Fixes: f7db8fd03a4b ("ksmbd: add validation in smb2_ioctl")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
