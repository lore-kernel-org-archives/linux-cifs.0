Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EBEC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 18:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4122764ECF
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 18:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbhBXSWb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhBXSWb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Feb 2021 13:22:31 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B25C061574;
        Wed, 24 Feb 2021 10:21:50 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id q23so3501689lji.8;
        Wed, 24 Feb 2021 10:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QwuU3xNF676fW0Qz6Yj10YsJuKwVnZI2peLj/ip0DBk=;
        b=qKxMfaf2Q/JZMspNxla3/+NfLvsDeBiAvUoDgJt6FF+TdtyHON3jL6FU3AZ+vKSmSH
         JLPgZ9lVobDomgT8Q8riTiAUDwflZ8ZuHVeeBLusqZAnXL0/yRbabvIogX79tbCIK8o7
         FTw6KeiGf8OIh2txoI78L0LOXyj8d9yUlwiASOth3FLOSBN0DVIDKkxxccjLrt1oBClz
         /omog7BnUxz5WYE1HOR87OUgHcZwwjAfdvROMDc3WrbtAj5R3REXfpSczfivchAhPklY
         nC3SIXyOTyzGzaGOaGXZa+bd3PT5rIAxCn3by0DqoecIr66wnwrkOMYz/IBvZwS6JPiL
         ARpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QwuU3xNF676fW0Qz6Yj10YsJuKwVnZI2peLj/ip0DBk=;
        b=IRksJBN6fASTKxOvhH6BfuzO1LfJwTwfgLT6o8CVpJ0vxopdE+03E+2JrtBKK4ipKL
         HindHtbwgUrnAjXEjTuy074SC7rOfsmSkx8o+cdFe37Bbr6pFaMjquxYg1Q4PiLWoju4
         OeZOXZlCpbNqPtlbqZvTu4NO2LudljkhoX7Ur5bPfx09H6jPWY9OeBMGUxBkK3uJjXee
         r9XX895RX3jzAOV95ZGcM+hQGCiqG8mJnOabsc3Hx29C9pGfDIm34TQgSNVwdJ+E3ToI
         spTcJfNOEN3DJtm/uB9AUhRID9ypzlKuUxUjovYY86Mo5BZcF5lA5PcS/C17OGLaYgaW
         wqHA==
X-Gm-Message-State: AOAM531uyXuy0YuOCWgL2phQN9Tz8s5jTzFLoguUkq0e1aVdeObVzRT7
        NOlG51fhyKSzBEoLItgu0LsQ7Sb5WK8XMnfWHyw=
X-Google-Smtp-Source: ABdhPJzaCwpMz2+DTaDyqGhTBcN+1XCXz4IkU13Hlz4RHEkTYcjOGmzRg/P/yDuFAibTEOJCOPXJRb5/xGT3ZJAXoLw=
X-Received: by 2002:a2e:9617:: with SMTP id v23mr9691246ljh.406.1614190906617;
 Wed, 24 Feb 2021 10:21:46 -0800 (PST)
MIME-Version: 1.0
References: <1ca0f87e-83b3-b4dd-4448-b44f2a9d1698@canonical.com>
 <SG2P15301MB00639032FD6F37360A458E2D949F9@SG2P15301MB0063.APCP153.PROD.OUTLOOK.COM>
 <CANT5p=obm1EaZm+exAwjRdgrh1YV8bfMZWe-=nmwP7ExTWqX+Q@mail.gmail.com>
In-Reply-To: <CANT5p=obm1EaZm+exAwjRdgrh1YV8bfMZWe-=nmwP7ExTWqX+Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Feb 2021 12:21:35 -0600
Message-ID: <CAH2r5mue5TxydZJFiV=z8eDPfYDDtnj-CfT7ac+tHyz+s5XYYQ@mail.gmail.com>
Subject: Re: [EXTERNAL] re: cifs: Retain old ACEs when converting between mode
 bits and ACL.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Shyam Prasad <Shyam.Prasad@microsoft.com>,
        rohiths msft <rohiths.msft@gmail.com>,
        Steve French <sfrench@samba.org>,
        Colin Ian King <colin.king@canonical.com>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add the RB from Rohith and merged into cifs-2.6.git for-next

On Wed, Feb 24, 2021 at 10:58 AM Shyam Prasad N via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Hi Steve,
>
> Please accept this fix for the bug that Colin pointed out.
> This can be hit if the server has a corrupted SD, or it got corrupted
> over the network.
> We used to ignore the ACL in such a case (which in combination with my
> patches caused the issue). But I think we should be returning an error
> immediately.
>
> Regards,
> Shyam
>
> On Wed, Feb 24, 2021 at 7:16 AM Shyam Prasad <Shyam.Prasad@microsoft.com> wrote:
> >
> > Hi Colin,
> >
> > Thanks for reporting this. I'll submit a fix.
> >
> > Regards,
> > Shyam
> >
> > -----Original Message-----
> > From: Colin Ian King <colin.king@canonical.com>
> > Sent: Wednesday, February 24, 2021 6:14 PM
> > To: Shyam Prasad <Shyam.Prasad@microsoft.com>
> > Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-technical@lists.samba.org; linux-kernel@vger.kernel.org
> > Subject: [EXTERNAL] re: cifs: Retain old ACEs when converting between mode bits and ACL.
> >
> > Hi,
> >
> > Static analysis on linux-next with Coverity had detected a potential null pointer dereference with the following commit:
> >
> > commit f5065508897a922327f32223082325d10b069ebc
> > Author: Shyam Prasad N <sprasad@microsoft.com>
> > Date:   Fri Feb 12 04:38:43 2021 -0800
> >
> >     cifs: Retain old ACEs when converting between mode bits and ACL.
> >
> > The analysis is as follows:
> >
> > 1258 /* Convert permission bits from mode to equivalent CIFS ACL */
> > 1259 static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
> > 1260        __u32 secdesclen, __u32 *pnsecdesclen, __u64 *pnmode, kuid_t
> > uid, kgid_t gid,
> > 1261        bool mode_from_sid, bool id_from_sid, int *aclflag)
> > 1262 {
> > 1263        int rc = 0;
> > 1264        __u32 dacloffset;
> > 1265        __u32 ndacloffset;
> > 1266        __u32 sidsoffset;
> > 1267        struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
> > 1268        struct cifs_sid *nowner_sid_ptr = NULL, *ngroup_sid_ptr = NULL;
> >
> >     1. assign_zero: Assigning: dacl_ptr = NULL.
> >
> > 1269        struct cifs_acl *dacl_ptr = NULL;  /* no need for SACL ptr */
> > 1270        struct cifs_acl *ndacl_ptr = NULL; /* no need for SACL ptr */
> > 1271        char *end_of_acl = ((char *)pntsd) + secdesclen;
> > 1272        u16 size = 0;
> > 1273
> > 1274        dacloffset = le32_to_cpu(pntsd->dacloffset);
> >
> >     2. Condition dacloffset, taking false branch.
> >
> > 1275        if (dacloffset) {
> > 1276                dacl_ptr = (struct cifs_acl *)((char *)pntsd +
> > dacloffset);
> > 1277                if (end_of_acl < (char *)dacl_ptr +
> > le16_to_cpu(dacl_ptr->size)) {
> > 1278                        cifs_dbg(VFS, "Existing ACL size is wrong.
> > Discarding old ACL\n");
> > 1279                        dacl_ptr = NULL;
> >
> > NOTE: dacl_ptr is set to NULL and dacloffset is true
> >
> > 1280                }
> > 1281        }
> > 1282
> > 1283        owner_sid_ptr = (struct cifs_sid *)((char *)pntsd +
> > 1284                        le32_to_cpu(pntsd->osidoffset));
> > 1285        group_sid_ptr = (struct cifs_sid *)((char *)pntsd +
> > 1286                        le32_to_cpu(pntsd->gsidoffset));
> > 1287
> >
> >     3. Condition pnmode, taking true branch.
> >     4. Condition *pnmode != 18446744073709551615ULL, taking false branch.
> >
> > 1288        if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
> > 1289                ndacloffset = sizeof(struct cifs_ntsd);
> > 1290                ndacl_ptr = (struct cifs_acl *)((char *)pnntsd +
> > ndacloffset);
> > 1291                ndacl_ptr->revision =
> > 1292                        dacloffset ? dacl_ptr->revision :
> > cpu_to_le16(ACL_REVISION);
> > 1293
> > 1294                ndacl_ptr->size = cpu_to_le16(0);
> > 1295                ndacl_ptr->num_aces = cpu_to_le32(0);
> > 1296
> > 1297                rc = set_chmod_dacl(dacl_ptr, ndacl_ptr,
> > owner_sid_ptr, group_sid_ptr,
> > 1298                                    pnmode, mode_from_sid);
> > 1299
> > 1300                sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
> > 1301                /* copy the non-dacl portion of secdesc */
> > 1302                *pnsecdesclen = copy_sec_desc(pntsd, pnntsd, sidsoffset,
> > 1303                                NULL, NULL);
> > 1304
> > 1305                *aclflag |= CIFS_ACL_DACL;
> > 1306        } else {
> > 1307                ndacloffset = sizeof(struct cifs_ntsd);
> > 1308                ndacl_ptr = (struct cifs_acl *)((char *)pnntsd +
> > ndacloffset);
> >
> >     5. Condition dacloffset, taking false branch.
> >
> > 1309                ndacl_ptr->revision =
> > 1310                        dacloffset ? dacl_ptr->revision :
> > cpu_to_le16(ACL_REVISION);
> >
> >     Explicit null dereferenced (FORWARD_NULL)
> >
> >     6. var_deref_op: Dereferencing null pointer dacl_ptr.
> >
> > 1311                ndacl_ptr->num_aces = dacl_ptr->num_aces;
> >
> >
> > Line 1309..1311, when dacloffset and dacl_ptr is null we hit a null ptr dereference on dacl_ptr.
> >
>
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
