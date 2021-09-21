Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE98C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 05:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 078B760ED5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 05:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhIUFD7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 01:03:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229536AbhIUFD7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 01:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632200551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=+J7eMz8Gs/yxmRz7PYjIIOPDauHaxB0P50P8NZM6Fro=;
        b=KK5Map6gECR55XK2uEEVRLmWPiZu2PKn7VqytUVNKciU9XcduE3ql3FqLsGgSHV4+tThWw
        B9dW44EOgn/w+kN4TB54wwNjHd738dxswutt671f2wz9pYqLRnplTbHGxsJllE+slba+3c
        70TcFyC0J4bkqwKwtJ2gA8wAbz9jtXg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-Foib6p-cMkyTHO6HvzAkRA-1; Tue, 21 Sep 2021 01:02:29 -0400
X-MC-Unique: Foib6p-cMkyTHO6HvzAkRA-1
Received: by mail-ed1-f72.google.com with SMTP id r23-20020a50d697000000b003d824845066so9420286edi.8
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 22:02:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+J7eMz8Gs/yxmRz7PYjIIOPDauHaxB0P50P8NZM6Fro=;
        b=qzXBxpUyn7L83cbWFzMrt5jOmmkqa/RVmZU+qMGQEgGZjK2EhFwJq944xMec2lj8oi
         DYWO1jnsARfjVxwKsEWmRciHzAbF1N+fTD5qA+4KGV+oJYN9C+ajCnvEaJzrF9kuE2vx
         IlVize4+S+mcerVlzo1B+d6nB8FEyPjjv1v+P2WfQ/IALJVEIQzyJhSJ7yEfnWeJy42z
         8T5RTXG8sorT3JtXKgqVA5qQFM88P+K0nI5JsxecpDvBWcq8bTHI+uO7vCIZXbo0MDXa
         intb9ZSvwKJ9vfXWEVro40R8RVB/0MG6o54DTSdemegNqhVuBf0NDeWgamIFiXenKYOP
         MGkA==
X-Gm-Message-State: AOAM533I8tQ4rbil7wa4hlV/oEIVn7ZUgrkzzIZZX3D73V5f7j54jtpt
        RufSw3HYpQaPCD0LNrBy+zDqKvL1s3rz5K2chd28kfVMtmt6yVzWNxN61tja2LnELeF6HhXA11A
        VRO6umGr7syndqy0osUUOdSrv+BrOUhoYO2v9pQ==
X-Received: by 2002:a17:906:5855:: with SMTP id h21mr31795348ejs.230.1632200548315;
        Mon, 20 Sep 2021 22:02:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjCQJ9M9lQkinlEQwMAquM3JCxFkfkEOh8GqU0SyFvHopMqjCMG0ZhfQC0EQOKbDczJEqJANgpG4TwnEnuIJg=
X-Received: by 2002:a17:906:5855:: with SMTP id h21mr31795338ejs.230.1632200548156;
 Mon, 20 Sep 2021 22:02:28 -0700 (PDT)
MIME-Version: 1.0
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Tue, 21 Sep 2021 15:02:17 +1000
Message-ID: <CAGvGhF6Vf7vmd2vRC6Vv22ZNoxbhX4ym3_NjjiOncvx=ay9X8w@mail.gmail.com>
Subject: ksmbd: missing validation of hdr->next_offset
To:     linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

List, Namjae,

I have been looking at next_offset and we need some additional
validation of when we
walk to the next pdu without validating we have enough buffer.

I think the problem is down in is_chained_smb2_message()/
init_chained_smb2_rsp()
where it advances work->next_smb2_rcv_hdr_off without checking that
the new offset is valid and contains a smb2 header and payload.


A simple reproducer is libsmb2.
Apply this patch to break "next_offset"  for compounds in libsmb2 :
diff --git a/lib/pdu.c b/lib/pdu.c
index 1329388..4eab8d7 100644
--- a/lib/pdu.c
+++ b/lib/pdu.c
@@ -174,6 +174,7 @@ smb2_add_compound_pdu(struct smb2_context *smb2,
         }

         pdu->header.next_command = offset;
+        pdu->header.next_command = 0x0f0ff0f0;
         smb2_set_uint32(&pdu->out.iov[0], 20, pdu->header.next_command);

         /* Fixup flags */

And then just run this command which uses compounds:
./examples/smb2-stat-sync smb://192.168.124.221/Share/
it should oops right away.


I don't know where the best place to check for this is,  either in
init_chained_smb2_rsp()
but it was a little hard to track it down.
A different place to check this might be from
ksmbd_conn_handler_loop()
and just walk the headers and check next_offset header by header
before even trying to process any of the pdus.


regards
ronnie shalberg

