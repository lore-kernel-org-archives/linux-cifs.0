Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A8BC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 17:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB47965215
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 17:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCIRhX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Mar 2021 12:37:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhCIRhP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Mar 2021 12:37:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615311434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PSiVCHS8WBpF94A9aMAc/wUW/TL9xvRomhWoAvmE9vk=;
        b=IobHoWAnfxWfmPR5TmtNh8RPMDNIIqp/OnmMQP5kjcTnTegtjod5F8+1Uy7GF9pa+PT/7a
        AEKwrdtNM6H++pgeoN8xO7pOdQ2B3vcfdMRETlAo24/QkI/gN/DFuM0U/OBom3EGQ4+tn4
        dsDVTYnNCpJBvZV/lf2FY17ffn9pB3A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-eZETMmwONUStF47UaC41wQ-1; Tue, 09 Mar 2021 12:37:11 -0500
X-MC-Unique: eZETMmwONUStF47UaC41wQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A757319057A1;
        Tue,  9 Mar 2021 17:37:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-152.rdu2.redhat.com [10.10.118.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E25671037E81;
        Tue,  9 Mar 2021 17:37:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <87k0qoxz7r.fsf@suse.com>
References: <87k0qoxz7r.fsf@suse.com> <87tupuya6t.fsf@suse.com> <CAN05THRV_Tns4MTO-GFNg0reR+HJKa1BCSQ0m23PTSryGNPCeg@mail.gmail.com>
To:     =?us-ascii?Q?=3D=3Futf-8=3FQ=3FAur=3DC3=3DA9lien=3F=3D?= Aptel 
        <aaptel@suse.com>
Cc:     dhowells@redhat.com, ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [EXPERIMENT] new mount API verbose errors from userspace
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 09 Mar 2021 17:37:09 +0000
Message-ID: <181014.1615311429@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:

> > What I think we should have is a ioctl(),  system-call,
> > /proc/fs/cifs/options,  where we can query the kernel/file-system
> > module
> > for "give me a list of all recognized mount options and their type"
> > i.e. basically a way to fetch the "struct fs_parameter_spec" to userspa=
ce.
> >
> > This is probably something that would not be specific to cifs, but
> > would apply to all filesystem modules.
>=20
> That sounds like a good idea yes. I wonder if David Howells has
> considered this.

I had this.  Al disliked it and removed it before the patches got upstream.
Also Linus hated the fsinfo() syscall that was the way to get this (amongst
other things).

David

