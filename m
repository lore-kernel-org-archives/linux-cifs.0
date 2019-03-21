Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F193CC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 15:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B98CF218D8
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 15:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vY30PQQZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfCUPg4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:36:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41465 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfCUPg4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Mar 2019 11:36:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id k11so4436975pgb.8;
        Thu, 21 Mar 2019 08:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j4fvwkVJh0wpXfB/RiGZt+BfaQu8aC8tDzBcZLnVOpY=;
        b=vY30PQQZQc73U4x1Z5MikhifLjL8HhyDM8ZqTEmwJVRhgMnm0BKSefdRAGF3c48x4n
         FCfjtmTq35D9GL2uPgBbOFiOFH+jePpqIRGlp46MLC4IgCmJ5o3mDc4G+MWIktiANH0A
         MwsSUoU50x6xh0PrAM6hDHcXNfJgL2sMjZE+Sc5sNRezBXamPnCitxaN6tyeUxq9kY1E
         8CrshHmnoLEfJ4qjfu8y1Y7MedQKz5k3mibm10iD7yqwWmeTMrNcjxGQqSNmRCSkfXuw
         OI8VPv3axJ/ZSnzIhhDUTk1WOSIhk/ZNf2ef8hXrJ5JmP/3Id8tjwCsGG8wxnzZ07ACY
         kCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j4fvwkVJh0wpXfB/RiGZt+BfaQu8aC8tDzBcZLnVOpY=;
        b=ICRLTvWpcaRLOPqVqBXtrjhVkMjCudrZHlQfAx4PzEpp+H9IwuAlrC4StuVdBj+Rw4
         itMdwWlq1nLPzNDSH96CrznJqdtKWqXQVLxYSMaj5vwULMLruIOWN4kLMYZChk1G8bAo
         EMm7OKrieeTE1zrq2CXU6T7V+VtfYvIY2KxChthG95l7/5oGi8E4RaIQrOFyfkayQYc7
         i/P+wDJYMBtKvu0Eay1LBb6O564vJEe8cGwxxGd0xeupAWSKAvPJB5+h5afRFFjBRL46
         JnS0EA2HquC3mrLBksxSzPwo9bHU8EkvriKYSoDunSV8rw4EiEfMtuaSXpJiTR86pafm
         FIkg==
X-Gm-Message-State: APjAAAXraFczMw7uKORp8R2YJwzsfYOMQd1d73ao4LBAE3dSeqPppfJS
        i6YllOBBJ0t6rK1FPmEIwbcQw6LdJ6WQG2udvGw=
X-Google-Smtp-Source: APXvYqwch2BjxYtMxq3KIirKe+SSRDCp98YYxj2emUlwGVKHzmoxTqHL33IoMQjnWK3r6kyyf71ByP0XX9SeyQ6G0Ag=
X-Received: by 2002:a63:544f:: with SMTP id e15mr3972919pgm.344.1553182614407;
 Thu, 21 Mar 2019 08:36:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190321045902.14326-1-lsahlber@redhat.com> <87imwc4fhj.fsf@suse.com>
In-Reply-To: <87imwc4fhj.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 21 Mar 2019 10:36:42 -0500
Message-ID: <CAH2r5ms8wDwCDP5o=GrcOsmNmReBHPdhq-Tat7UDkaVv-oKAWQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: allow guest mounts to work for smb3.11
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I added the commit tag and cleaned up the related checkpatch warning.

I don't know of any other locations where we have to make a similar
change as this is the only place where we (on the client) forced
signing to be on for a request when the user (or server) didn't
request it (due to the requirement in MS-SMB2 that tree connect be
signed).  In the other places you noted, the client or server would
have forced signing on ("sign" mount option or "server signing =3D
mandatory" for example).

On Thu, Mar 21, 2019 at 6:46 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
>
> > Fix Guest/Anonymous sessions so that they work with SMB 3.11.
> >
> > In git commit 6188f28 tightened the conditions and forced signing for
> > the SMB2-TreeConnect commands as per MS-SMB2.
>
> We could add a
>
>     Fixes: 6188f28bf608 ("Tree connect for SMB3.1.1 must be signed for no=
n-encrypted shares")
>
> tag in the commit message.
> >
> > -     /* 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2=
.4.1.1 */
> > +     /*
> > +      * 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2=
.4.1.1
> > +      * unless it is guest or anonymous user. See MS-SMB2 3.2.5.3.1
> > +      */
> >       if ((ses->server->dialect =3D=3D SMB311_PROT_ID) &&
> > -         !smb3_encryption_required(tcon))
> > +         !smb3_encryption_required(tcon) &&
> > +         !(ses->session_flags & (SMB2_SESSION_FLAG_IS_GUEST|SMB2_SESSI=
ON_FLAG_IS_NULL)))
> >               req->sync_hdr.Flags |=3D SMB2_FLAGS_SIGNED;
> >
> >       memset(&rqst, 0, sizeof(struct smb_rqst));
>
> I suspect there might more (and/or better) places to check. If you grep f=
or
> SMB2_FLAGS_SIGNED there are a couple of other places that should be
> considered:
>
> smb2_hdr_assemble() { ...
>         if (tcon->ses && tcon->ses->server && tcon->ses->server->sign &&
>             !smb3_encryption_required(tcon))
>                 shdr->Flags |=3D SMB2_FLAGS_SIGNED;
> ...
> }
>
> cifs_get_smb_ses() { ...
>         ses->sectype =3D volume_info->sectype;
>         ses->sign =3D volume_info->sign;
>
>         mutex_lock(&ses->session_mutex);
>         rc =3D cifs_negotiate_protocol(xid, ses);
>         if (!rc)
>                 rc =3D cifs_setup_session(xid, ses, volume_info->local_nl=
s);
>         mutex_unlock(&ses->session_mutex);
>         if (rc)
>                 goto get_ses_fail;
> ...
> }
>
> After negprot and before sess setup we already know the protocol version =
so I guess there
> could be some patch there as well.
>
> See also SMB2_logoff(), SMB2_ioctl_init(), cifs_enable_signing()
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)



--=20
Thanks,

Steve
