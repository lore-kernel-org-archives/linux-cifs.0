Return-Path: <SRS0=t/jT=3D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19983C33CA9
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jan 2020 07:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D88CF2084D
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jan 2020 07:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oEb5vSNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgANHYK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jan 2020 02:24:10 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:41716 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbgANHYK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Jan 2020 02:24:10 -0500
Received: by mail-il1-f195.google.com with SMTP id f10so10583646ils.8
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jan 2020 23:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3YfI39tnS4pp6fgRBN+vMV1rYbmDJ+KOTugEwH1vNJU=;
        b=oEb5vSNrF8ze/KqzTpj5oRLWG/ujvJPcBBCkW51e1p9Axg1Magdj6y2+a0id7TBSsx
         fcwJtaCJ5LxEGN6UzgXwwgnENSOg4HTEmO8duT9tCzmhcPraFU/QpINxr+aFGZCxqLuF
         Bfr6dYAuFuegyTq/K5vI6+cB6rWZnk5iwe3AM4zv7LkDlYdI+w9RP+3S7fUNyaL247K+
         AV2rnggq3OQjdVSHwvRsACLe64g2O7Bwbh7rc5wOALD8x2II2pR9CcbhaScmo25P85co
         9ScuEKAGK1cUd5JjMi0VhswTLqzZ8dVoUJ8upgB3E9zRYnS5jm6rHNLA0sxFgva3YtPA
         WWqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3YfI39tnS4pp6fgRBN+vMV1rYbmDJ+KOTugEwH1vNJU=;
        b=afVSxPveranEmyHM4RWyFA3b7rIIWIuApK99pu16yLQTYA7SoQqx+Occbl+jLn1AjN
         K+fklWF/iEcpXGy5Rkk3ghBks6+nAaK0+1cspxuE80Y/PZ9jHubHS4sKPXoKyoTmuVNg
         S2hcYDKTmqeWAuWBCQ3K+5m9oB0vPT2wLe2Vn+vTNutQ84C2gO49c7edQJ5JZ/RyWRGE
         sgn2ZeJiDf15e/zeJm5NWrVZw+mMj6TY6CPv4ymtSwM3JzEX2kok+pMU5glK1KmRQRRM
         RxsSrzFjtxN4DOuQXzVnLl0kX4h1j1im7RpqLYrDcl36kZPQKJcJ5ludUf8ZB8xSU9Wp
         SySQ==
X-Gm-Message-State: APjAAAUU9ra679k1dNpb7NA48Nz5pdT3wJsUayXmNYDCiUf40jBNyiZ4
        NwqkkxU/8nfTkxiNl6RVnkjJEcllDDuaGAVxsEUZbw==
X-Google-Smtp-Source: APXvYqwMr31Qoti6RQe/0CVJJ+FvE0HpbqAWGNue11USOwR+tL0AiQPn4ZSmdQL6uE3ByXtdDgn/gCdsjH50xNyVXxk=
X-Received: by 2002:a92:9a90:: with SMTP id c16mr2212679ill.3.1578986649587;
 Mon, 13 Jan 2020 23:24:09 -0800 (PST)
MIME-Version: 1.0
References: <20200113204659.4867-1-pc@cjr.nz> <CAKywueSnatSmp-=w1J7Jf=9dab70SjV8JgfFoys37-sgGqOD_Q@mail.gmail.com>
 <87y2ubxdo9.fsf@cjr.nz>
In-Reply-To: <87y2ubxdo9.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Jan 2020 01:23:58 -0600
Message-ID: <CAH2r5mtyxzekdLNDhs=SNWjAW+KZG=AYJVWHoCN7QWbJ1K+69g@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I can update - it.   Check back by Wednesday - I plan to add a bunch
of the work for next release into cifs-2.6.git for-next (including
this patch)

On Mon, Jan 13, 2020 at 3:13 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Pavel Shilovsky <piastryyy@gmail.com> writes:
>
> > The patch 9150c3adbf24 was marked for stable, so, this one should be
> > marked too.
>
> Ah, good point. Thanks!
>
> Should I resend it or Steve would take care of it?
>
> Paulo



-- 
Thanks,

Steve
