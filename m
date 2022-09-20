Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB4AECAAD8
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 04:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiITEPU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 00:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiITEPR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 00:15:17 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB252714B
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:15:15 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id 63so489962vse.2
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bqi/ML8nTGJk/7NnhxfOCnvGsqTiDddIKQ56aAqxBG4=;
        b=je9IiNUGTiPfeLfn8EO4eJQcc3iCSvA8utWiNTZ+PLhqcmFXF5JOIpymSNCGrMtqtg
         b2zy7HYZiWDsRmz+12LZt80Z1jrZfWwUcDo0WRyNh37/+lpa6dpWVlqVGx4y4VE6O0Z/
         r74fKfCsreFCiYUijFchWAuEF5eQ/IKdBGhgrYXO3mbfwh2ChzPSH57SFg9tr+NYXV9o
         gs2PMcc22FqWj1kKnrs2QcuZcAG8T3VXRIMicChB3YzVOgzxai3VLfzU+e9fQ+Y47V1w
         YaGNrXVMbBVxsps/yQcM9tfbrd+smzCNnCBj2zz0gRFwg0cuQzehFjqFgPCUwYkDwTwf
         n8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bqi/ML8nTGJk/7NnhxfOCnvGsqTiDddIKQ56aAqxBG4=;
        b=Sb2U1PvRfwd69OWVRt+1jdiymv/VKJd/a4FDRQ4NtJ3FzQAhrLkYbIyZ58k9fRlYEr
         UONw832NGJxft8vX1XOyzuyOfJqkiDK+lqz6WYsJQIEYSQv21OTQMUWdQBNj4Dd1o9q+
         DxbtQvEeZtGIEN/Ve1YMg/fd1zPELTD6hQHCFARWUqZsqoaTfsqXdkmoBH1NLIIkEVM9
         dl1RxHRptUL7+TLEP4/tvzjL0y4xmB0ylcsf6DmWuISblT40KsgKkv9Oxtod7cDp29UZ
         07TbJdMqeJbcauYGaK7hbbRUxohxNabp6Qu+m/ksR3zU8mV6kcQM4panPeWZZ4wxsn6n
         95WA==
X-Gm-Message-State: ACrzQf3AV7VSYhfFXmf7sOFV81Sy9qgaGdNDDCW56K7GEWZtQlnRdRGj
        8gkt0rz49ntmVHGldYhgOedVI7VQSXMyFargWlM=
X-Google-Smtp-Source: AMsMyM7ri19UAjGofFfnsYQJZx+7qUN2dOXcp5pWTyQgME2ZQhCynHnAOIpCL5AxjsnPLAzFXeTXOm4pNTzUPg/RA/c=
X-Received: by 2002:a05:6102:a91:b0:392:98b0:dd08 with SMTP id
 n17-20020a0561020a9100b0039298b0dd08mr7170541vsg.60.1663647314911; Mon, 19
 Sep 2022 21:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220918235442.2981-1-ematsumiya@suse.de> <874jx3l8zg.fsf@cjr.nz>
In-Reply-To: <874jx3l8zg.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Sep 2022 23:15:04 -0500
Message-ID: <CAH2r5mtW=tSu1YtP1xCfDUZ09ykd-ca=Wr=z0QKrH6j2xmD7Rw@mail.gmail.com>
Subject: Re: [PATCH] cifs: check if mid was deleted in async read callback
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Sep 19, 2022 at 9:43 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Enzo Matsumiya <ematsumiya@suse.de> writes:
>
> > There's a race when cifs_readv_receive() might dequeue the mid,
> > and mid->callback(), called from demultiplex thread, will try to
> > access it to verify the signature before the mid is actually
> > released/deleted.
> >
> > Currently the signature verification fails, but the verification
> > shouldn't have happened at all because the mid was deleted because
> > of an error, and hence not really supposed to be passed to
> > ->callback(). There are no further errors because the mid is
> > effectivelly gone by the end of the callback.
> >
> > This patch checks if the mid doesn't have the MID_DELETED flag set (by
> > dequeue_mid()) right before trying to verify the signature. According to
> > my tests, trying to check it earlier, e.g. after the ->receive() call in
> > cifs_demultiplex_thread, will fail most of the time as dequeue_mid()
> > might not have been called yet.
> >
> > This behaviour can be seen in xfstests generic/465, for example, where
> > mids with STATUS_END_OF_FILE (-ENODATA) are dequeued and supposed to be
> > discarded, but instead have their signature computed, but mismatched.
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > ---
> >  fs/cifs/cifssmb.c | 2 +-
> >  fs/cifs/smb2pdu.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
>
> Good catch!
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
