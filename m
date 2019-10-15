Return-Path: <SRS0=LgxW=YI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EC9C10F14
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Oct 2019 05:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 685D12064B
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Oct 2019 05:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCRm/ct3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbfJOF36 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Oct 2019 01:29:58 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40727 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfJOF35 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Oct 2019 01:29:57 -0400
Received: by mail-io1-f68.google.com with SMTP id h144so43056161iof.7
        for <linux-cifs@vger.kernel.org>; Mon, 14 Oct 2019 22:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EXSK2GNkm9/ZvMPg2fSHpJ7a/mIss9JmEkw7o7nrH5U=;
        b=OCRm/ct3zYncXurbtX447R8/G3gngxVkTA1y8HHBjVHuz2lNru+pmNxsVhOTVjNfXJ
         ArKKzV0jrFeUkL6msWRK1eUF4oh3tS1C9Rgv4+l2YXbsI/IyHak6At2YPOce1YGBFEEC
         qC24AuHhv8Zy/Y1CeNXT+BFPXggCaJxYdsRRS2GqFk/khKIfV2UV+u/Uzjxf+fVt1CwB
         SQ7sMB/lOBsA5Slayj/EzAENnsn3LO7zIjCkEuS/guJy0bC7M5r6qL7biJfcI8h3IEw+
         58gQFcLyhz7nrQlxwCrTw3DtTK3RMdytyHqu/xOgkbuiMN7+e5qVsJ2/w9S08qT56k9s
         zoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EXSK2GNkm9/ZvMPg2fSHpJ7a/mIss9JmEkw7o7nrH5U=;
        b=psOkgvrgf3GytytHGGX25k3+eA0kWh2yA/e2IvUDhQH8hmZ7UE3uD94mn4queV4ItX
         WptFwNXY1I4aaaGr9fXnZiqaauU+j2M89kLE/JMRWzxGkHm9HPgegTz0BIlnQaMUphqj
         1i22/A2p68WiqjDDwmoGrifJKcdhygU3x67JG1sbXRWSygFKG7iAXK7hyAwe8Bd3ISvv
         FbLYlo84WfeERmVaZlyu4HeHS3X/sG3GTpE7iyK+ZJFEp4Q8bWzEFTmtZYaiUrh9X360
         zOBxoO0P/ZxKtIrF+7pnfXkW4SpDwymA6kS9doJuO6N2/QklP4gsh90JbGg2pEK8zAOA
         rH/Q==
X-Gm-Message-State: APjAAAWTEgmkzdSDEoxNXN/FVV8FkF8zZBSzAupbSHZ44kmBXJptgs1j
        /qXE6+18sG0QqgsROR4aI42vnAfF/V0VtDvLrt9CvLoN
X-Google-Smtp-Source: APXvYqyWjiTbeGf3VB1AlfZd9YZ6TElqMrMYV7+/o0ZMVcJ9iTw9mUEVkY4FoEHod6sv3+qAbpLh2IqrDWRIiFNsc6I=
X-Received: by 2002:a92:1f09:: with SMTP id i9mr4236043ile.209.1571117397056;
 Mon, 14 Oct 2019 22:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <20191014170738.21724-1-aaptel@suse.com> <87a7a3b67w.fsf@suse.com>
In-Reply-To: <87a7a3b67w.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 15 Oct 2019 15:29:47 +1000
Message-ID: <CAN05THRgk3t=snmey6QJ-H5tBPx4Re5ccOXrXm6OsTSVYWb4BA@mail.gmail.com>
Subject: Re: [PATCH 2/2] smbinfo: rewrite in python
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        "Kenneth D'souza" <kdsouza@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Very nice, thanks for doing this!

Does this make the other python tools we have in cifs-utils obsolete?
I don't think so.

I think we should keep both smbinfo as well as the dedicated tools.
Leave smbinfo as a generic read and dump the info to the screen
utility for any/all types of info,
but additionally have specialized tools that are much more complex for
some specific tasks.

What comes to my mind here would be specialized tools for quota,
security descriptors, snapshots to start with.
These tools would be much more specialized than smbinfo and also
provide command line arguments (and optional GUI)
to set and mutate the object they operate on.
I.e. do a lot of things that would possibly be outside the scope of smbinfo=
.

For quota for example I could imagine it having an optional GUI as
well as command line arguments to also SET the quota.
Maybe having integration with winbind to allow mapping SIDs to/from
Account Names,
possibly even having a configuration file so that a hypothetical
smb2-quota --check   would check the quota limits and provide
alerts/emails based on the configuration file.

I.e. full blown utility to manage the quota as well as a "--check"
command that can be run as a cron job.


For snapshots it would be nice with a dedicated tool, with optional
GUI, that would list all mounted cifs filesystems,
and possibly also read additional server/shares from a configuration
file that would allow you to fully manage snapshots, including
mounting and unmounting them.
I.e. everything you can do from windows explorer you should be able to
do from this tool.
Of course we are not nearly there yet but we have to start from
somewhere and it is just a matter of continue to incrementally improve
these tools.


We could of course do this to smbinfo too but I think it would be
better to keep these specialized tools as separate programs
even if there is some functionality overlap between them and smbinfo.


regards
ronnie sahlberg

On Tue, Oct 15, 2019 at 3:19 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
>
> Note that I haven't tested the `quota` and `list-snapshots` sub-commands
> as I don't know how to set that up easily on my Windows Server vm (let
> me know how if you know, thx) so please give it a try, these are
> untested.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
