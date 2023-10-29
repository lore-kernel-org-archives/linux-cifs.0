Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84995C4332F
	for <linux-cifs@archiver.kernel.org>; Sun, 29 Oct 2023 23:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjJ2XlI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Oct 2023 19:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjJ2XlH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Oct 2023 19:41:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA70F3
        for <linux-cifs@vger.kernel.org>; Sun, 29 Oct 2023 16:41:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59681C433C8
        for <linux-cifs@vger.kernel.org>; Sun, 29 Oct 2023 23:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698622865;
        bh=yKOeVqYdGMHmZ70/pj3Gqm7bdCOA6guw7BWbeSC202M=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FbgzUddut43TH2QMMCCvFb3p5Fnhf5bpa+Afm8vpQEQl3csgcaI/maFBmo+eKPD8B
         zLRSEbJ/Aq9OuGs0kjpMQiqHRraW08p2dLp07SOkWEDeal/29NKCvYxZtUTbMLHOJL
         R2fS39dZe9KJ/fhocoFpve22Y7f5R9bBWXKiZWXHOhJVfKdqsMuzRW9auSrBT1FQKR
         IuiuwlevxFyfTM58Qq3F/VVpjBOn3OJv4FDxkrRpzS2cJG/Q0x5Pav9k9aVwctAqZI
         fz/iIYHIxvq4NB5nMHaK6juHX+M30RsOT/IZ1hgMVfiJUeqkjWxXgQWXaGUp4Qhale
         LRWJ2JoS9bPLw==
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6ce322b62aeso2601647a34.3
        for <linux-cifs@vger.kernel.org>; Sun, 29 Oct 2023 16:41:05 -0700 (PDT)
X-Gm-Message-State: AOJu0YzugphunkRPqiITKUPSdkPngi7GcWlx++eun01HhGeLQVeJNVEV
        1c6py37lsHWRI4fVVDM7FoTTTzs8AVZWHie87gE=
X-Google-Smtp-Source: AGHT+IEHHLIBUit++/DFKozEY3zBfpR9Cs2XnM9pgFXHYIUbByYFiJCERV0bYG7/MpJ9Cg/Ujua8qUN8qgP5T7YKJTQ=
X-Received: by 2002:a05:6830:d0:b0:6bd:c7c3:aabc with SMTP id
 x16-20020a05683000d000b006bdc7c3aabcmr9020393oto.19.1698622864631; Sun, 29
 Oct 2023 16:41:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1d53:0:b0:4fa:bc5a:10a5 with HTTP; Sun, 29 Oct 2023
 16:41:02 -0700 (PDT)
In-Reply-To: <20231026122107.3755159-1-mmakassikis@freebox.fr>
References: <20231026122107.3755159-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 30 Oct 2023 08:41:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8NbMBpvZQmrU2Z5PaJzFHc_f-8_TrYmRrjVhxOwGKggw@mail.gmail.com>
Message-ID: <CAKYAXd8NbMBpvZQmrU2Z5PaJzFHc_f-8_TrYmRrjVhxOwGKggw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add processed command debug log
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-10-26 21:21 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Additional log to help identify what command is going to be
> processed next.
There are the functions that doesn't call WORK_BUFFERS(). e.g.
smb2_handle_negotiate(), smb2_cancel, smb2_ioctl(), etc... And
duplicated prints will show from smb2_sess_setup().

int smb2_sess_setup(struct ksmbd_work *work)
{
        struct ksmbd_conn *conn = work->conn;
        struct smb2_sess_setup_req *req;
        struct smb2_sess_setup_rsp *rsp;
        struct ksmbd_session *sess;
        struct negotiate_message *negblob;
        unsigned int negblob_len, negblob_off;
        int rc = 0;

        ksmbd_debug(SMB, "Received request for session setup\n");

        WORK_BUFFERS(work, req, rsp);

Thanks!
