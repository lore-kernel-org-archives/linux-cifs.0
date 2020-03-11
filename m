Return-Path: <SRS0=4171=44=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFACC2BAEE
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Mar 2020 17:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4B8420738
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Mar 2020 17:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpNC2GV/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgCKRfL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Mar 2020 13:35:11 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:33478 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729852AbgCKRfL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Mar 2020 13:35:11 -0400
Received: by mail-lf1-f41.google.com with SMTP id c20so2471026lfb.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2020 10:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q1eLqQJW6xFhXf9xq7G+GWO3taxyNe1dGbUoZ0nO0oM=;
        b=CpNC2GV/S9noXqw7zsPMS8xaBHcBzOlB9KrSvgsMsD91rrizOUqiNiGM3GeEmifjJF
         3SVt8VUmpfkvFA6RS5yEe9JNHdJlS4K47P9yiQ2zWno//hppsM8AF2/2A1SOkgt4yNzf
         xCqO8JrVuP6eZnfxHH9UO3ni1mV8Isl3yQDQ3brVotZGcnv+juxuSPHjMm36iL2106WV
         LkYHg+p5ktJoJIor5/z8BmaNT29YI9FGCxC/jv6dat4Pa2LHFYQtSZhHPMEQQsVj1U1z
         yxvFNhm0gg2ilwnKdou78XpNLTb/MwbpLkET3Bm8lS1RojVfgeSAcW2g6NBav2liHqWk
         sIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q1eLqQJW6xFhXf9xq7G+GWO3taxyNe1dGbUoZ0nO0oM=;
        b=kXDfSdoP6+bg4LgKLEf40bRJSkWLu6Zzh0SzMJM7NgWvexgt2aocnV4zCxr3xI+/f6
         i+dsJlx6FAZJ198B2Y8nu15PGShl6JRB/P/LD048mSl9BYnXWGtA/30+W0Zpd2Lmwjmb
         wUTsGuOuQV0+1j0I7DHBZ3LfiVrjVGWtiXd8fYHE14vP2+YfURdCycpSg9HahaPMCmZm
         rLiJb6t29PwvwXUGmhfvcl7a+QRruhjabajg76ahQW98bHrRX8Pym84TQjXjdThlFzq2
         BYU/3HGqkJyT2nriyiwz1MMKUqeC1E2tTybkcOJSSWjpuZtZcii93f2YsBVPWFVJERcI
         Vhag==
X-Gm-Message-State: ANhLgQ2WCKBDq3RTHeeGHrpWuy2hpFsGyO+4qcx9gh1dhU3Gb2S3cJ+D
        pOnkxucLa4VZxYdftuTAWto0ezg9Z0n39WTDx1y+
X-Google-Smtp-Source: ADFU+vuq+qOcIEa6Uy8y8Os114+DU48vdW3OKzM3FNwRTCymnpj5k57DMYDxiRUOkDoLukXW8VedzeVqjOq7px/E5Q8=
X-Received: by 2002:a19:5e06:: with SMTP id s6mr2889991lfb.154.1583948109089;
 Wed, 11 Mar 2020 10:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mumjsORpsk6kp-Xp=v1+D340y_pq8Am04zjDaam2Bxzsw@mail.gmail.com>
 <87zhcnkut2.fsf@suse.com>
In-Reply-To: <87zhcnkut2.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 11 Mar 2020 10:34:57 -0700
Message-ID: <CAKywueQmsBv=8EMkoCqxJcmboEQEoR-Hf4p=j_d9vsGe9LeTbQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Increment num_remote_opens stats counter even in
 case of smb2_query_dir_first
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 11 =D0=BC=D0=B0=D1=80. 2020 =D0=B3. =D0=B2 04:14, Aur=C3=A9li=
en Aptel <aaptel@suse.com>:
>
> Good catch! Usually compounded chains do both open and close so they
> don't need to update the counter but this one doesn't close.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
