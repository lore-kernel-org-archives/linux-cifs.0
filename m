Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3999C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 05:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 936EF6112F
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 05:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhIVFYV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 01:24:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231896AbhIVFYU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 01:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632288170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=JAGQ24fj9oqHzFjfN8Xh9fj2vxvLFblE+Mv7ADv3bgg=;
        b=gVhpXmyCHRzb0RB4ESBsEPYDFzLIJOcM+1duEESlnavNNo+J53uoU3YFOaJQ0A5u0V0/lC
        9zYXegtMffv7Fd6AKHZKmMQfDXl7DZA+s15+Vv/SCO1LpopYFmYgPsOpObfPxhARRoksVp
        xb52D38khaPbN/wYgd2CIgjAtT7tq9c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-dCm1cYOeNtyfv8YKc8GA6g-1; Wed, 22 Sep 2021 01:22:49 -0400
X-MC-Unique: dCm1cYOeNtyfv8YKc8GA6g-1
Received: by mail-ed1-f71.google.com with SMTP id r7-20020aa7c147000000b003d1f18329dcso1633127edp.13
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 22:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JAGQ24fj9oqHzFjfN8Xh9fj2vxvLFblE+Mv7ADv3bgg=;
        b=YUmV4PL174WXBFizdyTiopWDruFjvBPjLaUcenS0OgWI8hnYPnVW7pnGeStlFYSFCY
         J0bZTwilSK2neVQgl+LJvlV+xn6fTApl58YNmY1k8zaLE8tPP6cTz0uZBpjA+rvdPqf2
         O5fa+D36blD3zxrRFEUkBR6iATPY/Fu6Et8dkCo96p4GEwVinK+b2IfiT5CRPPALdNJB
         EO0Y+Ui3eydEdC5Axk/OltwiNHQj3dhZaP11yFfLd9ASI+kQEf5HmtRoT1/52Sgvt1dt
         UsrA2F/djwEeJsCwPc0EyiX0bTauET+ysxXMpMkySQ6jvUS7B0pthy9h7mPh8vw+hgWI
         usOg==
X-Gm-Message-State: AOAM532G1Q9KOHfbBgFfVXZNhHl0hKEAnlg5k/uTtcFRa4jjwL12kUsJ
        WpOky/eWkwpRKbBw+JQr91y363QFf4jDfAE2pwtz3uBOwzpm2qeFM6lJvGsQivA2Gedq/S1WTUa
        t9pcsohTJd94l88ULo6ZPpXplLvLSuHbmDsBlOQ==
X-Received: by 2002:a50:be87:: with SMTP id b7mr37642050edk.333.1632288167727;
        Tue, 21 Sep 2021 22:22:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIN+zrgiltcX60posG7KDAQrv5Stk3wkRBq08P1A8vlu2UzIoQJ2p91+PQmlov2H13YUDgJGEitzbqvY7lVYE=
X-Received: by 2002:a50:be87:: with SMTP id b7mr37642028edk.333.1632288167488;
 Tue, 21 Sep 2021 22:22:47 -0700 (PDT)
MIME-Version: 1.0
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Wed, 22 Sep 2021 15:22:36 +1000
Message-ID: <CAGvGhF65fvZksvcLy8RWEizDwLVmKvM-0Mwe-xhWQk67-mExfQ@mail.gmail.com>
Subject: Only checks the signature for the first pdu in a compound.
To:     linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Minor issue, as far as I can tell not exploitable, but looks funny.


Apply this patch to libsmb2 and run this for a reproducer:
diff --git a/lib/libsmb2.c b/lib/libsmb2.c
index d17e72b..244cab6 100644
--- a/lib/libsmb2.c
+++ b/lib/libsmb2.c
@@ -1985,6 +1985,7 @@ smb2_getinfo_async(struct smb2_context *smb2,
const char *path,
                 smb2_free_pdu(smb2, pdu);
                 return -1;
         }
+        next_pdu->header.protocol_id[3] = 0xaa;
         smb2_add_compound_pdu(smb2, pdu, next_pdu);

         /* CLOSE command */


./examples/smb2-stat-sync smb://server/Share


What it basically does it it corrupts the SMB2 signature for the
second PDU in the
Create/GetInfo/Close compound.

Wireshark is fine with this and still decodes the PDU eventhough it
has the signature 0xfe 'S 'M' 0xaa


The bug is  that it only checks the signature for the first PDU:

int ksmbd_verify_smb_message(struct ksmbd_work *work)
{
struct smb2_hdr *smb2_hdr = work->request_buf;

if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
return ksmbd_smb2_check_message(work);

return 0;
}


Funny thing is that ksmbd responds with the same bogus signature in
the second PDU in the compound.

