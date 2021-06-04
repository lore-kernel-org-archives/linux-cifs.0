Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FABC07E94
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 09:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8237E6140B
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 09:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFDJQR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 05:16:17 -0400
Received: from mail-yb1-f178.google.com ([209.85.219.178]:40870 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhFDJQR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Jun 2021 05:16:17 -0400
Received: by mail-yb1-f178.google.com with SMTP id e10so12759468ybb.7
        for <linux-cifs@vger.kernel.org>; Fri, 04 Jun 2021 02:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hqf9P+2OoGkh0nH6pgqVjm3zEr09SQc6KgxzugXlMIM=;
        b=AuZRIJT1GPoKH9Nayx2EpscCPLDhHtWjxdPs0JqV+NPD7fHv1mkV8cjrIrfPHkdCJS
         tNmKR/zc3LLETsUBuPlIx7rS7zxiKLEVZHa0VGJAFertWyQa2X1C9n7VXehbPHGrjoEx
         NWz6IZXIcd6xWyJ4MbPDA79l3fUTevZE9QS5Kr/6dMGNAm4MPTUKLa8WylPYSWBeM8tH
         cqU6xVlmhD803RmltB15Vh3elNTQBLTTWWQsjPVFs5iKLPFm4jdewdMZi/lfS38EmhZ7
         rndRnfwe/00Nu6Vvq7lbk5pXjsNkaRM9WGSifV/0QhZ0GFzTGvbTwuH7x5rEJpfiOEgy
         b3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hqf9P+2OoGkh0nH6pgqVjm3zEr09SQc6KgxzugXlMIM=;
        b=RCBif4xBRftaMqLK8gS+P6qd93rY5jUS5mLxeKHOSWLUegbZ2QBIrx0jFwqE4scow9
         RXNtIhEr3lFEfLBcA9ZTwT/A+njY4inBlpSQjxbqk45y3GbVg+K138tUbx3w7vg2Usf2
         APrYtNkVSi8Y0w8yKAtPEx6IDpaZTjB+wLG57Chap4EZhAi06SMxyptK8HIMkXtr12MK
         b6acqe7AAjwWzU68MA9QDMPuWBxqDBpZd8zh4O7aB3MXjsfWNS+MY2kYAiZnr0J9KFNv
         PfSN5J66BASzpW+IOAF2Fb1sat9lSJMMlZsMFOJt7pwVp0aW2R5776dbIwplGwjy8i7g
         j+8w==
X-Gm-Message-State: AOAM533OF9kqLMvMDayDHPIhOFS/fOlbBfpv4uEd0tKmwt2hdCvu7c5S
        wM0e7vnwjsw0+9drHUPNFfvRjCYewStr9jjZ/u0=
X-Google-Smtp-Source: ABdhPJyrvyXxCKe/PvPsjVe6/aws4pklCgQxRgY1DQAijgJ9pOPIREm1B/PgCt7Xkgq4sFwxYzMN//b6ozJJuTv7VBo=
X-Received: by 2002:a25:7085:: with SMTP id l127mr3846970ybc.293.1622797996061;
 Fri, 04 Jun 2021 02:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
 <875yywp64t.fsf@cjr.nz>
In-Reply-To: <875yywp64t.fsf@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 4 Jun 2021 14:43:05 +0530
Message-ID: <CANT5p=o6Oq-27Xj4Z6-XzXKL45Dwg7JjGw2HA9jv5+YFQKpHUg@mail.gmail.com>
Subject: Re: Multichannel patches
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for the reviews.

While rebasing older changes, I missed a single line during the
channel add code, which had caused a regression.
Fixed it and merged with the correct patch here:
https://github.com/sprasad-microsoft/smb-kernel-client/pull/5

I've also integrated Aurelien's comments into these patches.
Also, I've a couple of minor patches here to fix fscache warnings for
multichannel and to integrate new changes into DebugData.
@Steve French Please use these new patches.

@Paulo Alcantara That would be great if you can help testing my
changes. Please test with these new changes.
> The super is only used for providing cifs_sb_info::origin_fullpath as key to find the corresponding failover targets in referral cache.
I'm wondering what would happen if there are multiple tcons to the
same origin_fullpath (possibly in different sessions)?
Also, doesn't failover targets apply to each channel under a session?
Shouldn't we switch targets on reconnect of secondary channels too?

On Wed, Jun 2, 2021 at 10:15 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > P.S. There is a logic in cifs_reconnect to switch between the targets
> > for the server. I don't think these changes will break the DFS
> > scenario. The code will likely take effect only for when the primary
> > channel reconnects (as DFS server entries are cached with super block
> > as the key). Perhaps more changes will be needed there to also switch
> > between the targets for individual channels (maybe use superblock +
> > channel num as the key for caching entries?). Folks with better
> > knowledge than me with this code may want to check on this?
>
> I don't think your changes would break it as well.  The super is only
> used for providing cifs_sb_info::origin_fullpath as key to find the
> corresponding failover targets in referral cache.
>
> I can help you testing your changes with some DFS+multichannel failover
> scenarios.



-- 
Regards,
Shyam
