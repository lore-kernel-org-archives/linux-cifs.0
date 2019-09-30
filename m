Return-Path: <SRS0=Aodf=XZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629E7C32792
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Sep 2019 21:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 335EF20815
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Sep 2019 21:38:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="twO4PxZg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbfI3ViG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Sep 2019 17:38:06 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44039 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfI3ViG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Sep 2019 17:38:06 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so11046797ljj.11;
        Mon, 30 Sep 2019 14:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fAydBCiqlcHtzHCOL0kArH593FU8lQU2VIhbalxOpL4=;
        b=twO4PxZgUikmA43DkdoQx3BJB8pqgap8QbXid8WEcRB4KpnqlCLlspa3aoEXZ7hzb+
         fjHT5EiSDiel3CSaCkxDyrGx57XsSzfW6xPqGoNdsjHPhxwmeFRl4hUiEjnTX8JpHvnJ
         /jk04+yv0/cFCOl0yUuK4p14R8YQrSXOXWy+dzypl8aZqqmdnJy98f/cCXg5tpEfzYcg
         3TN1DnWwkvUNzU6zDewi2VRy1M43MOLQPw7IksnAaLdNgIyngYlnOl+fsAgEEv0b+DZh
         NNhAfr4ObRQVw9ybQ79PzvgSuRZbbjWCrfBKAzDofUVbAzgu7wCVdeIa+y/oMMSk8rO5
         ybMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fAydBCiqlcHtzHCOL0kArH593FU8lQU2VIhbalxOpL4=;
        b=TIpZyGduQPGJHKpnHYjeVKF89DwhsDbvfaWoVHv3lBkaf4hNgXkODRbtZBUxalEVUa
         cuC+Y4OhNkfhlsBs93KvYI52pcoEznTLzh7Gnd4tjX0jj6kjEMZN4yWJFBjJgywKx6De
         9AhWSltp6DZHzMnJ76Jn0OvUNT5NDso750AnLNJKDvAIDnohXMRCQvmQouYoa6sKz/sE
         5eOpZSFYmeWx+Ol7P+UJdiO9mANDfInAjnPGlhDWdTyYf6LlGduiIncoqSbZ7qXP6zaY
         h8QShtE99cn6t7lnP0P4AciPCRhwlA96hXswIAaWTGTMFSppkAgQGfQKUT5W+Z/q0WPz
         6Mjg==
X-Gm-Message-State: APjAAAX3XqYUgvNSmyvaASFSvipgNLCCSk1dX8s1TK9+VRxSxlaujA+D
        jBy+j9vr9Q386zMkPkNHL9Y6/i5D8vO+QtuwrRMx
X-Google-Smtp-Source: APXvYqzZoMJNBKkH52zUnVPvUNJ550xiv8X4zLrwV3JvYY2/vT4x09UXAG2dGnYq5NXCXJWeD+8rXZhpnLzXm3bSTg8=
X-Received: by 2002:a2e:9713:: with SMTP id r19mr12332903lji.81.1569864747839;
 Mon, 30 Sep 2019 10:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190829050237.GA5161@jagdpanzerIV> <CAKywueRd4d_fojGL+n4BisoibhgkYfN9Wyc_+0=-1sarz4-HZw@mail.gmail.com>
 <20190921223847.GB29065@ZenIV.linux.org.uk>
In-Reply-To: <20190921223847.GB29065@ZenIV.linux.org.uk>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 30 Sep 2019 10:32:16 -0700
Message-ID: <CAKywueSC=MoBB6t2OeUiyc6+GST2Jgg8FTO-kkXif-pn+1k-cw@mail.gmail.com>
Subject: Re: build_path_from_dentry_optional_prefix() may schedule from
 invalid context
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D0=B1, 21 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 15:38, Al Vi=
ro <viro@zeniv.linux.org.uk>:
>
> On Thu, Sep 19, 2019 at 05:11:54PM -0700, Pavel Shilovsky wrote:
>
> > Good catch. I think we should have another version of
> > build_path_from_dentry() which takes pre-allocated (probably on stack)
> > full_path as an argument. This would allow us to avoid allocations
> > under the spin lock.
>
> On _stack_?  For relative pathname?  Er...  You do realize that
> kernel stack is small, right?  And said relative pathname can
> bloody well be up to 4Kb (i.e. the half of said stack already,
> on top of whatever the call chain has already eaten up)...

My idea was to use a small stack-allocated array which satisfies most
cases (say 100-200 bytes) and fallback to dynamic a heap allocation
for longer path names.

>
> BTW, looking at build_path_from_dentry()...  WTF is this?
>                 temp =3D temp->d_parent;
>                 if (temp =3D=3D NULL) {
>                         cifs_dbg(VFS, "corrupt dentry\n");
>                         rcu_read_unlock();
>                         return NULL;
>                 }
> Why not check for any number of other forms of memory corruption?
> Like, say it, if (temp =3D=3D (void *)0xf0adf0adf0adf0ad)?
>
> IOW, kindly lose that nonsense.  More importantly, why bother
> with that kmalloc()?  Just __getname() in the very beginning
> and __putname() on failure (and for freeing the result afterwards).
>
> What's more, you are open-coding dentry_path_raw(), badly.
> The only differences are
>         * use of dirsep instead of '/' and
>         * a prefix slapped in the beginning.
>
> I'm fairly sure that
>         char *buf =3D __getname();
>         char *s;
>
>         *to_free =3D NULL;
>         if (unlikely(!buf))
>                 return NULL;
>
>         s =3D dentry_path_raw(dentry, buf, PATH_MAX);
>         if (IS_ERR(s) || s < buf + prefix_len)
>                 __putname(buf);
>                 return NULL; // assuming that you don't care about detail=
s
>         }
>
>         if (dirsep !=3D '/') {
>                 char *p =3D s;
>                 while ((p =3D strchr(p, '/')) !=3D NULL)
>                         *p++ =3D dirsep;
>         }
>
>         s -=3D prefix_len;
>         memcpy(s, prefix, prefix_len);
>
>         *to_free =3D buf;
>         return s;
>
> would end up being faster, not to mention much easier to understand.
> With the caller expected to pass &to_free among the arguments and
> __putname() it once it's done.
>
> Or just do __getname() in the caller and pass it to the function -
> in that case freeing (in all cases) would be up to the caller.

Thanks for pointing this out. Someone should look at this closely and
clean it up.

--
Best regards,
Pavel Shilovsky
