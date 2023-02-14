Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30DAC61DA4
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Feb 2023 22:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjBNWyf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Feb 2023 17:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBNWye (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Feb 2023 17:54:34 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773FF28D1F
        for <linux-cifs@vger.kernel.org>; Tue, 14 Feb 2023 14:54:33 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id s8so2107765ljp.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Feb 2023 14:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OgrdDZ4mBzqutmIaXD5tYJspT/v7aSoNzmJWlfzN0HM=;
        b=duSTwh1bDEvbNh5O9Te6t5K3vzPJ8BX0U1D9VrSKVPb6fLQGYNm5u8c4AOznAB34XQ
         MocDySrcjyFkHQdhCzTLDDYyPt8o3NYR/z3BNYYxG1t1YjJUCw+Tm5bvf3QqmLfRXnew
         akAWCug1nn42PHf7FSWJLr9TZkB+f9LF3cGGZIMD2TGcfWrJbaxsbiSdEXgq1JyEEYrO
         ZqYPWQDftQW7tfqwV7EpQoy/id0ovE/3DbRybd07x2+Ez323/uSh0lT86PHLDRO2FHWQ
         yHr/iybkwa69QCTSRfXI7lGo79XIBwcKV+IrOe/9Gzuq4uJbNkJsciXhwjuzfQ8VvQap
         0QqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OgrdDZ4mBzqutmIaXD5tYJspT/v7aSoNzmJWlfzN0HM=;
        b=bmDtaSiRTFuf2Bhw12olOMpK9m/Heoqjc8/caubCJoqw8pwgj8qc0T4Ul2EioFaAPu
         WEsXuBZg/oG+elhxkAbvFzzsvaOkHYA0GVULiiVhIUrybLY7Y+XDTWyJ/lkeDGRV24h3
         S+Kda1K0l91OjV1d+0WlBGRK8TeZPrGDr+Wdrz/9OkMHc7JZN65NKPXUKinVZCMR0Xx0
         LZ+W5bJctytG29ucbv5V+gP6roX6zSqEzZYxglwnPoRh7Gsa0ARYIIDd2MeKqQ1eIxve
         vM55LA+lM5YCk+ouB3D5vjXPz/b8WuVD6d7Pcf9FYPRg+b+83zwvJ4qdwj9tjQZUstX/
         k0TQ==
X-Gm-Message-State: AO0yUKVJoGbXtp/2djePSFsqCOHNbOVQzhSl3iwLCKNgYHjBqh9wiz0B
        8xajt5yLUjfTigwk+wC/Wi7bh6TMTUSG14UQgn0=
X-Google-Smtp-Source: AK7set+AStQR57UdRGfJ7SNmvov1zqkcNuSWHnrXhU/OzhS1gO7yYajWF8ywiZwBIWKu6dB5zdlk85cdfPKa8dV3ON0=
X-Received: by 2002:a2e:b8cd:0:b0:293:4ab4:3bb1 with SMTP id
 s13-20020a2eb8cd000000b002934ab43bb1mr199555ljp.4.1676415271514; Tue, 14 Feb
 2023 14:54:31 -0800 (PST)
MIME-Version: 1.0
References: <Y+UrrjvGrOT6Bcmy@sernet.de> <87lel6enq6.fsf@cjr.nz>
 <CAH2r5mvGWJVjPJo1Guyd7W0eiHyRD9Wd7F0ndKLaGCj6VyHUwA@mail.gmail.com>
 <Y+Y4vMiTFdev4V1L@sernet.de> <CAH2r5mvzVQKAT-a+MJ-qN=Ogn8PqNdMz=3zYntaq26UdgcY0Cg@mail.gmail.com>
 <Y+nrvNByzLDMnDvU@sernet.de>
In-Reply-To: <Y+nrvNByzLDMnDvU@sernet.de>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Feb 2023 16:54:20 -0600
Message-ID: <CAH2r5mtoSHTXNeOF-MzOA_EmgZS0C7WsBkQJcNtRXpDmj=mowg@mail.gmail.com>
Subject: Re: Fix an uninitialized read in smb3_qfs_tcon()
To:     Volker.Lendecke@sernet.de
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next (pending testing and any additional review)

On Mon, Feb 13, 2023 at 1:50 AM Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
>
> Am Fri, Feb 10, 2023 at 10:01:37PM -0600 schrieb Steve French:
> > Yes. On top of for next. They don't have to be squashed into one if it
> > makes it harder to review.
>
> Attached.
>
> Volker



-- 
Thanks,

Steve
