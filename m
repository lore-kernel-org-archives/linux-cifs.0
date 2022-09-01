Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBE5ECAAD2
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 21:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiIAVVl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 17:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbiIAVVj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 17:21:39 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047AB90838
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 14:21:39 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r4so322856edi.8
        for <linux-cifs@vger.kernel.org>; Thu, 01 Sep 2022 14:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ecvtr+GqJ5iKFVZJr9ACIAhdgVqxGCT56Agn7pUrHqM=;
        b=l4R2qQ5/GVZ3Hn7B3q1thW5jHz1DHnSkzTOWSl58zyiDC2L3s6EsMt317BdwhdwPrJ
         oIKnDtSmIEuY7lXrJLui4XnrrUpNolnJ8xiOzSOOmUzKKvYsTKmXpb7f4zuLwBC5IL/s
         /R6G9iODxAajS9Vt2Lo2d8EuB56CYiaBJ1CTfhhxQTj+h/MDjK+jiiX0y5AjhwnYlKSv
         IcpZRzCsPxQ5eeKUdKQ7ZiThA35GUgVSfqJHODBnwwKObB9p0omwCFnu7g3xU0YPEl34
         0klZHK9aQ2lB8DgW2m1jMhM4SnnQ9vSn9eWxgNoM8HjYxwPJ88r2vQrHHZQeur6e93tC
         hDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ecvtr+GqJ5iKFVZJr9ACIAhdgVqxGCT56Agn7pUrHqM=;
        b=KRRx1Ad7XmZs3oSJahOLn/3BeK4/rN/mS7vidSnfZ6JjMZwAoj+4AcKIIiu6D6XYAy
         dkhF1wTp66X/wpOiWDXEm3LVHFlA5uuu9I8MXQpKq28AEAx7xwqyaBWsfDx30fLdAbYu
         7l3YmlrOpI92ZxzqUHkMhZD0AIdsVQFbzU6Ex9S1nUssvsj1lwB7r5pDB1hP9Ewm1kVG
         oQt94lacVST9j/dQg+6js+++UM1PSRqzDO7E09oEWin4PBes74coNzWsdPfAcuOPVZgZ
         uaUFFvhh/jjvMddP347QhqZ8l3BkIMWxvCwObDYTNTugwhCNkJyFo2kIQJSYOni793UZ
         qWCQ==
X-Gm-Message-State: ACgBeo27kEsEt1zmeRWk6qMcKynX/R4ddU98BvfGVQTLS7fGGART1G9L
        Xs5dGy9fqKfy0DnR+/w2G9jxkcf0jPs/MuJyUaLqLP9I
X-Google-Smtp-Source: AA6agR5DgbfM9vNLkQp2qYx0Mg/4HPXFng3k1J2wdX5aAWyo4/hRK6YUJL1/eWFZsxPCa8qJCKlMxUd9vlbIvNfPbL4=
X-Received: by 2002:a05:6402:42d4:b0:443:4b8:8cba with SMTP id
 i20-20020a05640242d400b0044304b88cbamr30346554edc.3.1662067297440; Thu, 01
 Sep 2022 14:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <YxDaZxljVqC/4Riu@jeremy-acer> <20220901174108.24621-1-atteh.mailbox@gmail.com>
 <YxD6SEN9/3rEWaNR@jeremy-acer>
In-Reply-To: <YxD6SEN9/3rEWaNR@jeremy-acer>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 2 Sep 2022 07:21:25 +1000
Message-ID: <CAN05THRgWMEejOMTozrf0F4sENxJEQYu2i-9CKWO+Qh0kvjveg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
To:     Jeremy Allison <jra@samba.org>
Cc:     atheik <atteh.mailbox@gmail.com>, hyc.lee@gmail.com,
        linkinjeon@kernel.org, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, smfrench@gmail.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 2 Sept 2022 at 04:34, Jeremy Allison <jra@samba.org> wrote:
>
> On Thu, Sep 01, 2022 at 08:41:08PM +0300, atheik wrote:
> >On Thu, 1 Sep 2022 09:14:31 -0700, Jeremy Allison wrote:
> >>On Thu, Sep 01, 2022 at 09:06:07AM -0400, Tom Talpey wrote:
> >>>
> >>>Ok, two things. What I found strange is the "man smb.conf.5ksmbd", and
> >>>as you say that should be man 5k smb.conf. Sounds ok to me.
> >>>
> >>>But the second thing I'm concerned about is the reuse of the smb.conf
> >>>filename. It's perfectly possible to install both Samba and ksmbd on
> >>>a system, they can be configured to use different ports, listen on
> >>>different interfaces, or any number of other deployment approaches.
> >>>
> >>>And, Samba provides MUCH more than an SMB server, and configures many
> >>>other services in smb.conf. So I feel ksmbd should avoid such filename
> >>>conflicts. To me, calling it "ksmbd.conf" is much more logical.
> >>
> >>+1 from me. Having 2 conflicting file contents both wanting
> >>to be called smb.conf is a disaster waiting to happen.
> >
> >ksmbd-tools clearly has a goal of being compatible with smb.conf(5) of
> >Samba when it comes to the common subset of functionality they share.
> >ksmbd-tools has 7 global parameters that Samba does not have, but other
> >than, share parameters and global parameters of ksmbd-tools are subset
> >of those in Samba. Samba and ksmbd-tools do not have any conflicting
> >file locations. The smb.conf(5ksmbd) man page of ksmbd-tools does not
> >collide with and never overshadows smb.conf(5) of Samba. Please, help
> >me understand what sort of disaster this could lead to.
>
> Samba adds and or changes functionality in smb.conf all
> the time, without coordination with ksmbd. If you call
> your config file smb.conf then we would have to coordinate
> with you before any changes.
>
> Over time, the meaning/use/names of parameters will drift
> apart leading to possible conflicts.
>
> Plus it leads to massive user confusion (am I running
> smbd or ksmbd ? How do I tell ? etc.).

+1
We should avoid having the same name here since it will cause confusion
and it will lead to files with the same name but with similar but also
different context and syntax.

Any tool that automatically scans/operates on smb.conf is potentially
going to have a bad time.


>
> It is simple hygene to keep these names separate.
>
> Please do so.
