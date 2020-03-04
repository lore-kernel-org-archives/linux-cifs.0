Return-Path: <SRS0=Ot+p=4V=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8675C3F2D1
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 06:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FE4F2166E
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 06:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pnUUEvB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgCDGXa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Mar 2020 01:23:30 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:39803 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgCDGX3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Mar 2020 01:23:29 -0500
Received: by mail-yw1-f67.google.com with SMTP id x184so980944ywd.6;
        Tue, 03 Mar 2020 22:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tbcuDfYaDl0s2pOUxHvvOkfOWHYsJpebfP0ObmyJLhA=;
        b=pnUUEvB3emIIYIR+4DE+c2kjKv/n3JDAttQZl/Z8rY5peVO84IFZ7XMRFn9sGz13ki
         7xYAbcCnds8+jE3Az1o6tS6Vm0utLaCW75ICVgGZ36fvpIW5pNm4AhSJONxVtqsMlhQ8
         tJNldWnRN0W9DXGj6W9iGcdmxomrCXhDZGwPgyezJSieiMeBjiVcstmnvKXulRAZssbP
         g6lqxXdV6UB42snjshIGMEvZF/8PUKHp1iQi71wp2TNfyJxRXDZSlyyOZFv8kvSe+hSV
         fORT4Wbocws1DsnD1VTADO3nTJX4Rrpndhhm5qtsli8VqT35VW9LbRPAC6+kFYnx+51p
         E96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tbcuDfYaDl0s2pOUxHvvOkfOWHYsJpebfP0ObmyJLhA=;
        b=LUKkBSuI/Oz50G51Wn12C3voyJ0nuR4xOVljiuoI/YJsTbH4G3eDUDb/p3kw5ahpW7
         u8WOE9EyufaKeTN4w6HMiCQ94vKfAgPevo5JBWuWi+KpEgGB0NouSxLv+H6HIbq5GCa4
         uX6pYBLgdd4UtfdpHY2l2v+e6aUqwp/SsHM2EVruUs0p6yXjDFPuo89JKsBhbYt9wAyj
         aY0wKCuXqXLmvevJoLZQDk5hh0iGdlFCT5/Ky0kSXLQ+aDt5A7/jF5v+fo8f+uqac7Oz
         QXUlgRGetuG2Yfy8UROPr4SCX476mpwuEMYvTxlPdiiq/zD7MMw9SNnOgzfiBAa0knUr
         rJVA==
X-Gm-Message-State: ANhLgQ2d+aGvLlmdxPENeT01HWObMhHuo10YXEOAPb2KihbT/nN4/GZc
        NM+tLrSgaCzbUksFgxkbmI2idHc+EWIfXJ42PIXDGQ==
X-Google-Smtp-Source: ADFU+vtJJiFniW/eKxBD4MR+qeAqmZ5k8NJak28YOj5w+Lndf/ByC4XUp8y8n7q9Pqhtb5af3SjTW245SjErulbzu/Q=
X-Received: by 2002:a81:4cc2:: with SMTP id z185mr1475074ywa.357.1583303007222;
 Tue, 03 Mar 2020 22:23:27 -0800 (PST)
MIME-Version: 1.0
References: <1583278783-11584-1-git-send-email-hqjagain@gmail.com>
In-Reply-To: <1583278783-11584-1-git-send-email-hqjagain@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Mar 2020 00:23:16 -0600
Message-ID: <CAH2r5mv9N_vo+vX7TaaPc2MBNFgsOAO6nGZcfaiaz8JqjM0BnQ@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/cifsacl: remove set but not used variable 'rc'
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Isn't it not used because of a potential bug - missing returning an
error in two cases.

If we leave the two lines you removed in - and set rc=0 in its
declaration (and return rc at the end as you originally had suggested)
- doesn't that solve the problem?  A minor modification to your first
proposed patch?

On Tue, Mar 3, 2020 at 5:39 PM Qiujun Huang <hqjagain@gmail.com> wrote:
>
>  It is set but not used, So can be removed.
>
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  fs/cifs/cifsacl.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 716574a..1cf3916 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -342,7 +342,6 @@
>  sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>                 struct cifs_fattr *fattr, uint sidtype)
>  {
> -       int rc;
>         struct key *sidkey;
>         char *sidstr;
>         const struct cred *saved_cred;
> @@ -403,7 +402,6 @@
>         saved_cred = override_creds(root_cred);
>         sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
>         if (IS_ERR(sidkey)) {
> -               rc = -EINVAL;
>                 cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
>                          __func__, sidstr, sidtype == SIDOWNER ? 'u' : 'g');
>                 goto out_revert_creds;
> @@ -416,7 +414,6 @@
>          */
>         BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
>         if (sidkey->datalen != sizeof(uid_t)) {
> -               rc = -EIO;
>                 cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
>                          __func__, sidkey->datalen);
>                 key_invalidate(sidkey);
> --
> 1.8.3.1
>


-- 
Thanks,

Steve
