Return-Path: <SRS0=RvcV=W7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E5DC3A5A2
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 00:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4E0822CF8
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 00:05:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="by2s+E3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfIDAFn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 20:05:43 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45219 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfIDAFn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Sep 2019 20:05:43 -0400
Received: by mail-io1-f65.google.com with SMTP id f12so22661118iog.12
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2019 17:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lRmdBjWUGFmkvytL1K2V1Htjda9OzYWttwKBdpbr5Ls=;
        b=by2s+E3mE1MFLY6yufdwFSDmHXQeHsSUD7hYyFwhWzEvgaavVhWSoulSPkAXv0ZXR4
         OcCx2qeq9wx+JHBzczMCDvjoTskaTIzADf6F3toNFLOmM3r7/wP2sswRpx9o2m+85szo
         S3onKirJxHGLd7q7EyiWtokOh21b9IrtU9k+tRLIu+rekwsLyWck17xenkuGm4WkjT8A
         G33HSBuMdBel/kR6YU5f1jbA8HHGzH1GMbNuifoym5svR3KKvUuwIFaRVt8adYC4xpJE
         XwrzKn+qrx4+/Fvtid0WGPsFkHd9sYNF5uEYFD2JRD4WEiICuRLA10d0G7j5sEeUcsnU
         k37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lRmdBjWUGFmkvytL1K2V1Htjda9OzYWttwKBdpbr5Ls=;
        b=iBDkW7vUkuUz0+7C3TB3dcjX1v/MsHTDfs7lJTztiD43x0G++D/vmvYwqv3oLaFjHQ
         JznIroyY63aBLbPHydTWao1J+qJTi4dRjbhcyE+HabkIWMxyIJd73Xzg7EooKA68H39J
         UlWerlYaCa5/+EaX27hyq4iq6M8A99h5U/UDsFJV/MJQ54OACWwdcOEUkOnxDACoHVwz
         Czq6SUGTLHHXz8WePYXSZuK3Vz/1mX3EHnN7uPOWfnwXef1843N9XiseuyXLgCNQ77LU
         kFhArDt0ecGu5WwaUvXgRfv7U2VLNvLIXvPBcjn0vmFktkJJNzbCXoQGMVHVCxUp4uJS
         1TlQ==
X-Gm-Message-State: APjAAAUu2P2TR16h26wNZXdgx81ezd7AFdbsWnu+rXdxxdgGZktlEc6A
        yamE8HBAINBx1vgSPc/kwrum6Df+h1pm0fcMWmE=
X-Google-Smtp-Source: APXvYqzHl0xV+Km3PNTvYNiC/kJVTJCjg7Fbi4DcJc4EBfhOExfftPxajLQypTZKdtBYGVXCCr8qAo2zIelYggI4iJA=
X-Received: by 2002:a6b:b4c7:: with SMTP id d190mr186185iof.209.1567555542945;
 Tue, 03 Sep 2019 17:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muz2=FgVGaZN-VfVYpai3x_SHm=GGR_OaM6c+YgP9d_Hg@mail.gmail.com>
In-Reply-To: <CAH2r5muz2=FgVGaZN-VfVYpai3x_SHm=GGR_OaM6c+YgP9d_Hg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 4 Sep 2019 10:05:31 +1000
Message-ID: <CAN05THSMFtoNnAyvH5HFRL15GF9zuFYTvQNwBqdV141n4AJsmg@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Add four more dynamic tracepoints
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Wed, Sep 4, 2019 at 9:44 AM Steve French <smfrench@gmail.com> wrote:
>
> Add four more dynamic tracepoints (for flush enter and non-error exit,
> and for close enter and non-error exit - we already had them for flush
> error and close error). For example:
>
>               cp-22823 [002] .... 123439.179701: smb3_enter:
> _cifsFileInfo_put: xid=10
>               cp-22823 [002] .... 123439.179705: smb3_close_enter:
> xid=10 sid=0x98871327 tid=0xfcd585ff fid=0xc7f84682
>               cp-22823 [002] .... 123439.179711: smb3_cmd_enter:
> sid=0x98871327 tid=0xfcd585ff cmd=6 mid=43
>               cp-22823 [002] .... 123439.180175: smb3_cmd_done:
> sid=0x98871327 tid=0xfcd585ff cmd=6 mid=43
>               cp-22823 [002] .... 123439.180179: smb3_close_done:
> xid=10 sid=0x98871327 tid=0xfcd585ff fid=0xc7f84682
>
>               dd-22981 [003] .... 123696.946011: smb3_flush_enter:
> xid=24 sid=0x98871327 tid=0xfcd585ff fid=0x1917736f
>               dd-22981 [003] .... 123696.946013: smb3_cmd_enter:
> sid=0x98871327 tid=0xfcd585ff cmd=7 mid=123
>               dd-22981 [003] .... 123696.956639: smb3_cmd_done:
> sid=0x98871327 tid=0x0 cmd=7 mid=123
>               dd-22981 [003] .... 123696.956644: smb3_flush_done:
> xid=24 sid=0x98871327 tid=0xfcd585ff fid=0x1917736f
>
>
> --
> Thanks,
>
> Steve
