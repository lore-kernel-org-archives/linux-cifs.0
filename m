Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCFEC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 01:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E24521934
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 01:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/zImt9u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfBOBHx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 20:07:53 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36409 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfBOBHx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Feb 2019 20:07:53 -0500
Received: by mail-lf1-f67.google.com with SMTP id q11so5970769lfd.3
        for <linux-cifs@vger.kernel.org>; Thu, 14 Feb 2019 17:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cf5wPD2zzfhSZAYM1NdrBQ4ZNTbJSINqRr4i0FaEccY=;
        b=i/zImt9uPsJSOWPUwAjZcp3WneZsb7KUVwvbWHZ+q3zuAXI39UZTvBqNMjC0waA7Pq
         xmmK7b/Y6fRtB+8JWealbbl+YzyzieUmCKcwHv/6st+Y0IYNId11OBZp+0V5uQ17A50l
         pv263a1sXOKDz8Kv3n0P6hs9FkjVG2Q1tWAEQxnwpjgOTsmBYFNUy36MemHjjPKFq3ty
         Y1IJR34giiQSgDwpONuYbNOnq5Yn4PDkpl3qwbVs9ADWhuT+SdgiGewVZWdtU2AND7OL
         YdNF8ERkohjWB4AXG1fDbTBRMX5097kdkv6DKi4ttkD8ZLtiQSlYw+E67sWCCrEMF7GQ
         871Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cf5wPD2zzfhSZAYM1NdrBQ4ZNTbJSINqRr4i0FaEccY=;
        b=gLT42Is3wtu5a8T9m/ELYTVW3FZkhuvXl6aWzFjXOcacXSz68I8w69q0nV+hxRyWBA
         Koj4ZuWLWNuSCXPZ1WYF51K0NE4iFRCPEBnrYOzri7wR1kLkNQt3T/n6pAlCHX8aipoT
         BnvvoqJZ/amrM6YxmexUJX9eu4wdWtc2qdcJMI871WDj0GXfDTbfDf2erGBeqY7WQaO0
         NFONhuLP2r6OOVllzgAgmm8IOeI4Nh/xhBGAjCGDj9lcE5euk2ynoji+2PA2iuSiYHhh
         RDCYZqs1BUbTbfvqyyKXYvy/vfEtVFaJ9nKAKeGoLSiBcvjeSDGU7IE8EqIaii1CXP2x
         X9zQ==
X-Gm-Message-State: AHQUAuY0/3FNXgCQ4P2mU1zDZR9L3oCQ5irIqu5i4CKZ3KpEnLhkMkxH
        2MtpCih3iPZr9EkcpATs8OPFAdQ53OkNk0/swEv77M4=
X-Google-Smtp-Source: AHgI3IZi/Pfp/FXJ0MFc+roE+zn1nkh+UtHThAOkVw/Jd2dNl0wD1lBDDeBWU9oxMnSlqSMwdsEfdz3EQMRm0X4uVPU=
X-Received: by 2002:a19:6f0a:: with SMTP id k10mr3940683lfc.119.1550192871381;
 Thu, 14 Feb 2019 17:07:51 -0800 (PST)
MIME-Version: 1.0
References: <20180717101244.GC11106@onega.vda.li> <20190211180055.a2634442-e58e-46da-abf5-acf470a351cd@korelogic.com>
 <CAKywueQ19y8_3WoORdvs+wyOQUYRCRicbxDRfZtn6DzeAv90FA@mail.gmail.com> <87pnrxjnjk.fsf@suse.com>
In-Reply-To: <87pnrxjnjk.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 14 Feb 2019 17:07:40 -0800
Message-ID: <CAKywueQJNLCo+OoS2mU4jRxP6FXTaTbt0emO82M67eNG6OZpBw@mail.gmail.com>
Subject: Re: support rst2man.py (was Re: [PATCH] cifs-utils: support rst2man-3)
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Hank Leininger <hlein@korelogic.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 12 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 02:42, Aur=
=C3=A9lien Aptel <aaptel@suse.com>:
>
> Hi Pavel,
>
> Pavel Shilovsky <piastryyy@gmail.com> writes:
> > The repository is currently here:
> >
> > https://github.com/piastry/cifs-utils/commits/next
> >
> > The master branch on git.samba.org will be updated once I make a
> > release. Feel free to submit a patch on top of the "next" branch.
>
> Do you prefer email patches here or github PR? I have sent a cifs-utils
> patch some ago to correct the kernel release version in the smbinfo man
> page.
>
> https://patchwork.kernel.org/patch/10779659/

The patch has been merged together with other pending ones. Feel free
to to use github PRs in future but patches are ok too.

--
Best regards,
Pavel Shilovsky
