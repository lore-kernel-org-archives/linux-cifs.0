Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C42C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 11:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF219610F8
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 11:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhHXLia (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 07:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236531AbhHXLi3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Aug 2021 07:38:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 162E461002;
        Tue, 24 Aug 2021 11:37:42 +0000 (UTC)
Date:   Tue, 24 Aug 2021 13:37:40 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 06/11] ksmbd: fix subauth 0 handling in sid_to_id()
Message-ID: <20210824113740.ypfyfem2uzin2ahk@wittgenstein>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
 <20210823151357.471691-7-brauner@kernel.org>
 <CAKYAXd86gaPoYJJHW6STdHhN282p5JFdr-xWwdvgv4HobFOBUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKYAXd86gaPoYJJHW6STdHhN282p5JFdr-xWwdvgv4HobFOBUg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 24, 2021 at 05:13:01PM +0900, Namjae Jeon wrote:
> 2021-08-24 0:13 GMT+09:00, Christian Brauner <brauner@kernel.org>:
> > From: Christian Brauner <christian.brauner@ubuntu.com>
> >
> > It's not obvious why subauth 0 would be excluded from translation. This
> > would lead to wrong results whenever a non-identity idmapping is used.
> >
> > Cc: Steve French <stfrench@microsoft.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: Namjae Jeon <namjae.jeon@samsung.com>
> > Cc: Hyunchul Lee <hyc.lee@gmail.com>
> > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: linux-cifs@vger.kernel.org
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> >  fs/ksmbd/smbacl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
> > index 3307ca776eb1..0d269b28f163 100644
> > --- a/fs/ksmbd/smbacl.c
> > +++ b/fs/ksmbd/smbacl.c
> > @@ -274,7 +274,7 @@ static int sid_to_id(struct user_namespace *user_ns,
> >  		uid_t id;
> >
> >  		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
> > -		if (id > 0) {
> > +		if (id >= 0) {
> >  			uid = make_kuid(user_ns, id);
> >  			if (uid_valid(uid) && kuid_has_mapping(user_ns, uid)) {
> >  				fattr->cf_uid = uid;
> > @@ -286,9 +286,9 @@ static int sid_to_id(struct user_namespace *user_ns,
> >  		gid_t id;
> >
> >  		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
> > -		if (id > 0) {
> >  			gid = make_kgid(user_ns, id);
> >  			if (gid_valid(gid) && kgid_has_mapping(user_ns, gid)) {
> > +		if (id >= 0) {
> Checkpatch.pl give warning messages like the following :
> 
> WARNING: suspect code indent for conditional statements (24, 16)
> #110: FILE: fs/ksmbd/smbacl.c:290:
>  			if (gid_valid(gid) && kgid_has_mapping(user_ns, gid)) {
> +		if (id >= 0) {
> 
> WARNING: suspect code indent for conditional statements (16, 32)
> #111: FILE: fs/ksmbd/smbacl.c:291:
> +		if (id >= 0) {
>  				fattr->cf_gid = gid;
> 
> With 7th patch, it shouldn't be a problem, but this patch itself seems
> to have a problem.
> I will directly update it like this if you don't mind :
> 
>                 id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
> -               if (id > 0) {
> +               if (id >= 0) {
>                         gid = make_kgid(user_ns, id);
>                         if (gid_valid(gid) && kgid_has_mapping(user_ns, gid)) {
>                                 fattr->cf_gid = gid;
>                                 rc = 0;
>                         }
> 

Sounds good. Thanks!

Christian
