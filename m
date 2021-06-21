Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A438C4743C
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Jun 2021 20:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11DEA6108E
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Jun 2021 20:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhFUU7d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Jun 2021 16:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhFUU7d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Jun 2021 16:59:33 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B4BC061574
        for <linux-cifs@vger.kernel.org>; Mon, 21 Jun 2021 13:57:17 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id i13so32325252lfc.7
        for <linux-cifs@vger.kernel.org>; Mon, 21 Jun 2021 13:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5loL97lkhc09E19bqvetVXPeszsRzUBICZSy1HACFOM=;
        b=DGEkk++JWMpDVae2Xt+hbbJ1z2AGOdBajBpuwevQTM1yKrIzrEPOZY4U8jlnMLFqfa
         5KwHRwQCE9HoziGPHS4CJOP5aXT2/9zFRCAigX8BhojdqCyb8S/Ovp0L1H/AFftwM9xf
         IVZhq9+4rsIVXp3XXJJhXH+Z/CXW+GKYZyDfPPm2dP03p0Y72lz1Y4p1uNRkbzh9Ag+v
         DL5yu43DsqLywssnaqb0R/eiDVOB3FfCSCB90RDu6PRbyg1qDybYwqfb8r4wl/n/4MFa
         RMqC3ziq7PEYnNAeZKe6ReChGo8lUr/bOdWV+LfIGJ/WD2ecH84zgPvjHh7Y3PAnN8As
         P5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5loL97lkhc09E19bqvetVXPeszsRzUBICZSy1HACFOM=;
        b=ofKLHCe8XpTHrg4QgA8HaKK2yQAcAea+VxrxpnqTuP8nj0l0NhofOldKBbOnOHnG/r
         p2AF6vE5fC04oqacFK1FsyH7jkPfmV9QjZYw9e5FEDFOmvzUgpSZ/aqsB9GAaiXqlKtq
         Y3dZJnDMkUqNET0U1d9/xRpS0RrpCcvxcAYNrvEN+InWCRkx8EyV0lKq058BCoxEx6FD
         g6u3edyCMnI15Se8QS7a1XqrHIaCSulCcCtJA/FsGFjm7ihnlShzyS46/EUVQClWQ5ZK
         Z0P9ASr1fmhp9IOvOcYhjfzIHdB7ydnnpFBysqJEyj1sEtkWFZ2402F7fdAz1Jm+fjRV
         jc1g==
X-Gm-Message-State: AOAM533/mUHam/Eytq50mJla4e/gH8MJ1dRkwNYHEHCqKXH3RwpeuoWz
        BLQdUnfo0rx4h5OJ9EH7iDs+QD9pBRjWIYgyVno=
X-Google-Smtp-Source: ABdhPJw/dWq0sbJ9eZDr04t8hLgpFVjjuCfyB3yF/YY9LM41cMABv3CzrZDFh+6yJYWiXK4VwDL4Uch374qP2r2LNJ8=
X-Received: by 2002:a19:f705:: with SMTP id z5mr108800lfe.395.1624309035853;
 Mon, 21 Jun 2021 13:57:15 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 21 Jun 2021 15:57:05 -0500
Message-ID: <CAH2r5mu4uEOP4r-KnF+bZGqPjdRwkaZanD1sE_JHuoK=jB_nnA@mail.gmail.com>
Subject: 2 error cases in sid_to_id are ignored
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There are two cases (see below) in sid_to_id where errors occur
mapping the uid but the rc  which is set is overwritten (reset to 0
before return).

        saved_cred = override_creds(root_cred);
        sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
        if (IS_ERR(sidkey)) {
                rc = -EINVAL;
                cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
                         __func__, sidstr, sidtype == SIDOWNER ? 'u' : 'g');
                goto out_revert_creds;
        }

        /*
         * FIXME: Here we assume that uid_t and gid_t are same size. It's
         * probably a safe assumption but might be better to check based on
         * sidtype.
         */
        BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
        if (sidkey->datalen != sizeof(uid_t)) {
                rc = -EIO;
                cifs_dbg(FYI, "%s: Downcall contained malformed key
(datalen=%hu)\n",
                         __func__, sidkey->datalen);
                key_invalidate(sidkey);
                goto out_key_put;
        }



since later in the function we do:



out_key_put:
        key_put(sidkey);
out_revert_creds:
        revert_creds(saved_cred);
        kfree(sidstr);

        /*
         * Note that we return 0 here unconditionally. If the mapping
         * fails then we just fall back to using the ctx->linux_uid/linux_gid.
         */
got_valid_id:
        rc = 0;
        if (sidtype == SIDOWNER)
                fattr->cf_uid = fuid;
        else
                fattr->cf_gid = fgid;
        return rc;
}


Any thoughts on whether it would be better to return the errors, or
continue the current strategy of simply using the default uid/gid for
the mount and returning 0 (and removing the two places above where we
set rc to non zero values, since rc will be overwritten with 0)?


-- 
Thanks,

Steve
