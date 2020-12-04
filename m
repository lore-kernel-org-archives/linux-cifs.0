Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20473C4361A
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Dec 2020 17:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6BEF22AAB
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Dec 2020 17:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbgLDRXG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Dec 2020 12:23:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731024AbgLDRXG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Dec 2020 12:23:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607102500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HMP2z6TbETM2wkR8PJrZNdTzZboYLQXmiBso6QMLlVM=;
        b=W6tA+ZHp7Nz3XsJaUywt0MKofVuRx6WojpfFVmgysWf7kYnl5+UjXLivnszIpNYJmMtb0Y
        ha0Kh/JoMg/4BnaY+1+IdibhtWNnVyjRd9vgLzhZK4pXX13BLg4iTzaSJ8G0LjfS01wSrz
        g1k/qle8K9BpRtcRHCrIuFqam5RP/Vc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-NC1vjRfuObuAhr-hIpkyjw-1; Fri, 04 Dec 2020 12:21:38 -0500
X-MC-Unique: NC1vjRfuObuAhr-hIpkyjw-1
Received: by mail-pj1-f70.google.com with SMTP id u2so3631707pje.0
        for <linux-cifs@vger.kernel.org>; Fri, 04 Dec 2020 09:21:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HMP2z6TbETM2wkR8PJrZNdTzZboYLQXmiBso6QMLlVM=;
        b=c6QmQOd+2SlA8+kXgHAhEA8RTeYIzy8org/fS5bl/KYYN4+KnhlPN/MWrIFaPngJKT
         PdqLOC4qHXIjSW1GB5+X54F6Cw2+mIVMy56vfbIwGWybdba2QJWrB+pa3EHbS3fGiEdF
         Wp99TEQrqmOxv9PgIDXctRg7+bdwuTcf9WOthNWjAQnr0Cj/jygNetxCw+1MmM/XprW1
         GMXMEjNTZq+s+9jyXpHYmuwzOCx0r652emNa2S5KZBAvNWkHA+gjDv5xqI6Fw8X4B3mb
         +CF9VT3XFPIdyn358yFPRqc675Z9WpFmpTRYVwmLTioS87/32GgidajilkJDHpOYnB8C
         Lx/A==
X-Gm-Message-State: AOAM531JGApj681Ez0uKb4lsalwk2Brsi93EKWQSaV5tefgBdVm3CYpU
        2k+xGqSHjL2YSAHx3a3H8LAMuQMgc9CMH+VIrDL0pOI6yZt3ScC3J7lQ5SjUK7WjsrhiTz/mERx
        OsxklXzzPTJZ9SkR39zi3gOcaxjbc7uEF+DwSxA==
X-Received: by 2002:a17:902:b498:b029:da:84a7:be94 with SMTP id y24-20020a170902b498b02900da84a7be94mr4645960plr.52.1607102497530;
        Fri, 04 Dec 2020 09:21:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZlvBGGm6BEYY+zPc26UInfszGqsN2Xap2uOr0mLI7Iy8wYQpQcXeiHCV8UtqiyoIOkQnrwnJC0eC09yI4BQE=
X-Received: by 2002:a17:902:b498:b029:da:84a7:be94 with SMTP id
 y24-20020a170902b498b02900da84a7be94mr4645942plr.52.1607102497277; Fri, 04
 Dec 2020 09:21:37 -0800 (PST)
MIME-Version: 1.0
References: <CALe0_76k-ZTbQLMBNzKg+ZB8a2NxQ_Kf+Q9b5fovOv2svY8KjA@mail.gmail.com>
 <CAH2r5mucjWpHmeuQ36F7QoeDugrw48dvVrZQgSbesfT4SAqpLQ@mail.gmail.com>
In-Reply-To: <CAH2r5mucjWpHmeuQ36F7QoeDugrw48dvVrZQgSbesfT4SAqpLQ@mail.gmail.com>
From:   Jacob Shivers <jshivers@redhat.com>
Date:   Fri, 4 Dec 2020 12:21:00 -0500
Message-ID: <CALe0_74jN5GWCa1_wnuVHZw2G6FYg6rkH0byV+DZjO=8Lgb9HQ@mail.gmail.com>
Subject: Re: cifs.ko and gssproxy
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

On Fri, Dec 4, 2020 at 1:09 AM Steve French <smfrench@gmail.com> wrote:
>
> I see a brief mention of gssproxy by Jeff Layton more than three years
> ago, but don't remember any follow up on that.   What would be your
> goal in doing this?
>
> Presumably we could improve cifs.ko's ability to automatically
> autonegotiate new SMB sessions for incoming VFS requests from uids
> that have associated kerberos tickets.  Fortunately here is little

This and allowing for the use of unattended accounts to access
Kerberized SMB resources in much the same way they can like with NFS
shares.
For users in a mixed protocol environment they could grant some uid,
like for a database process, access to said Kerberized SMB share using
the same method they already deploy for NFS assuming gssproxy is
already in use.

> dependency on SPNEGO in cifs.ko (so it could be fairly easy to add
> other upcalls for SPNEGO), just during SMB3 session setup (and also in
> parsing the SMB3 negotiate response).   My bigger worry with handling
> SPNEGO (RFC2478) in the longer term, is adding support for the various
> other mechanisms (other than Kerberos and NTLMSSP) that servers can
> negotiate (PKU2U for example, and also the 'peer to peer kerberos'
> that Macs can apparently negotiate with SMB3 and SPNEGO).
> Authentication is mostly opaque to the SMB3 protocol, so if additional
> mechanisms can be negotiated  (transparently, with little impact on
> other parts of the kernel code) with SPNEGO in the future that would
> be of value

Ideally gssapi would be to allow for the transparent use of other
mechanisms and not be a blocker for deployment.

