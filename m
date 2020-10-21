Return-Path: <SRS0=ZNV/=D4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061DDC4363A
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 22:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92C07221FB
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 22:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hiA2X/Z/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506837AbgJUW7T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Oct 2020 18:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506833AbgJUW7S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Oct 2020 18:59:18 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ED4C0613CE
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2020 15:59:18 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 23so4336232ljv.7
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2020 15:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+NUb2RabQ3pVkGPV1TA9vXSE4744S6FicsNSC2n3d2E=;
        b=hiA2X/Z/l9pvRR2uUIwMflK8eB3fnWe0xShE8AoId+INVHm1Gj5ca8PMxq4YmMBAYE
         oT9Hr/clBuYgHq8SqSW4GUhN1rLekiy5DtEJoefuw5VarItXs5Tk0jiYGiCdTSahscmp
         0vhao5wgOj6AxBOw5bpeKsNWHfll+59OKht7wM9v/WXiOB7D7x6T3cJV5la6lWnVBsQg
         JNXclKUwH26nQybUfy3etx/1d1fZOc7VcT3cz1tnmD66ay1N5IA1zNV91rOqm8hCon8b
         rD13pEjX1C3gQqAs807/T+3//bGLbA4W+cIB1Gpyfuv2lLoXvK8S+zuf73Qc3aNLkZ1D
         qPng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+NUb2RabQ3pVkGPV1TA9vXSE4744S6FicsNSC2n3d2E=;
        b=ZTPprcG8qVoyCNAh8TlZ0w91iT49TjCzD08KpCDeb5v6Z+I4xlp0H65LaelxGy+FpR
         c2pGTKflnEYdHLjtDl1XgoFZTgs2p26fKVH5L0t6svBJEDz+tYje3Z/H3Njrp6Y70L/j
         wkypsCv6efnaUQ8GIhQNLd17kr5h81B/Sc8zcqxC8E9/HE+PfWhG5clp8SjxycTTXkf6
         ANcVBz4PnO3N1bKTHj79DQeNnszNKf2vPBBNdIkcsgR1piJcVSukZI+LvhNvYv9oFXk0
         CxGyZaDwShuIRU3W8nJmy9yEXhisubZ39Q8lnI9+YumPkl5niSPyQPaTZIhevVLehnjn
         kNng==
X-Gm-Message-State: AOAM532g/cBzJpicTMfz2djrL9iNZxFT0mhWIKemYhqazt3nzdeObULo
        KoCJrJLicag92rtsJbBc/JZ8P3y8E1ocwH3cYi9FTXbyybDbnQ==
X-Google-Smtp-Source: ABdhPJxK4FjIy6gLz/Hc9mvNNl3m+VTAqMfDqxycTb1duKN2GRRrpkJB6drarUTI50DXV+vqFuSBhjg1ISAFFGIeCj8=
X-Received: by 2002:a2e:a376:: with SMTP id i22mr2304655ljn.325.1603321156416;
 Wed, 21 Oct 2020 15:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
 <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
 <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com>
 <CAKywueSQQPBKrfGX-a1cFdHAv9X8xFnqALz27ws+OGNZ35n==A@mail.gmail.com>
 <CACdtm0ahqPsvpdz7AMHixvo_kdb09sJ4H03Oa1f=qiWiN9_c8w@mail.gmail.com>
 <CAKywueRcNLv5k2kchN6vC2t1=K9SWNNAhd6f+gJYYgGdUwEWqg@mail.gmail.com>
 <CAKywueR=uDELZrL0fQKOseS6OcCDa9X_eVXwGG55+pt9qSLrOw@mail.gmail.com>
 <CAH2r5msArhmdTHZ499eUZHbo7FEeAmxzJc-Sp5+YDWUCNMsNaQ@mail.gmail.com> <CAKywueQD8=FM8PYS-0VCg8bqf=ig-2FqNYeM0xptaQg2VDsw1w@mail.gmail.com>
In-Reply-To: <CAKywueQD8=FM8PYS-0VCg8bqf=ig-2FqNYeM0xptaQg2VDsw1w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Oct 2020 17:59:05 -0500
Message-ID: <CAH2r5msq45hNqC5u=7xu78KGxWyjJChiubbiFEKKVBmnN56q1g@mail.gmail.com>
Subject: Re: [PATCH] Resolve data corruption of TCP server info fields
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Rohith Surabattula <rohiths.msft@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated ... I added SMB3: to the title

62593011247c SMB3: Resolve data corruption of TCP server info fields

(since it was SMB3 only fix doesn't affect cifs)

On Wed, Oct 21, 2020 at 4:03 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Thanks. Should we add "cifs: " prefix to the beginning of the patch
> title? Given that the patch goes to stable this may worth doing
> another rebase.
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=B2=D1=82, 20 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 15:08, Steve Fre=
nch <smfrench@gmail.com>:
> >
> > Added cc:stable 5.4+ and the 2 Reviewed-bys and merged into
> > cifs-2.6.git for-next
> >
> > On Tue, Oct 20, 2020 at 4:43 PM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > Any ideas about stable? esize mount option went into kernel v5.4.
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 09:48, Pavel=
 Shilovsky <piastryyy@gmail.com>:
> > > >
> > > > Thanks for the patch!
> > > >
> > > > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > > >
> > > > --
> > > > Best regards,
> > > > Pavel Shilovsky
> > > >
> > > > =D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 00:28, Roh=
ith Surabattula <rohiths.msft@gmail.com>:
> > > > >
> > > > > Hi Pavel,
> > > > >
> > > > > Corrected the patch with the suggested changes.
> > > > > Attached the patch.
> > > > >
> > > > > Regards,
> > > > > Rohith
> > > > >
> > > > > On Thu, Oct 15, 2020 at 9:39 PM Pavel Shilovsky <piastryyy@gmail.=
com> wrote:
> > > > > >
> > > > > > In receive_encrypted_standard(), server->total_read is set to t=
he
> > > > > > total packet length before calling decrypt_raw_data(). The tota=
l
> > > > > > packet length includes the transform header but the idea of upd=
ating
> > > > > > server->total_read after decryption is to set it to a decrypted=
 packet
> > > > > > size without the transform header (see memmove in decrypt_raw_d=
ata).
> > > > > >
> > > > > > We would probably need to backport the patch to stable trees, s=
o, I
> > > > > > would try to make the smallest possible change in terms of scop=
e -
> > > > > > meaning just fixing the read codepath with esize mount option t=
urned
> > > > > > on.
> > > > > >
> > > > > > --
> > > > > > Best regards,
> > > > > > Pavel Shilovsky
> > > > > >
> > > > > > =D1=81=D1=80, 14 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 20:21,=
 Rohith Surabattula <rohiths.msft@gmail.com>:
> > > > > > >
> > > > > > > Hi Pavel,
> > > > > > >
> > > > > > > In receive_encrypted_standard function also, server->total_re=
ad is
> > > > > > > updated properly before calling decrypt_raw_data. So, no need=
 to
> > > > > > > update the same field again.
> > > > > > >
> > > > > > > I have checked all instances where decrypt_raw_data is used a=
nd didn=E2=80=99t
> > > > > > > find any issue.
> > > > > > >
> > > > > > > Regards,
> > > > > > > Rohith
> > > > > > >
> > > > > > > On Thu, Oct 15, 2020 at 4:18 AM Pavel Shilovsky <piastryyy@gm=
ail.com> wrote:
> > > > > > > >
> > > > > > > > Hi Rohith,
> > > > > > > >
> > > > > > > > Thanks for catching the problem and proposing the patch!
> > > > > > > >
> > > > > > > > I think there is a problem with just removing server->total=
_read
> > > > > > > > updates inside decrypt_raw_data():
> > > > > > > >
> > > > > > > > The same function is used in receive_encrypted_standard() w=
hich then
> > > > > > > > calls cifs_handle_standard(). The latter uses server->total=
_read in at
> > > > > > > > least two places: in server->ops->check_message and cifs_du=
mp_mem().
> > > > > > > >
> > > > > > > > There may be other places in the code that assume server->t=
otal_read
> > > > > > > > to be correct. I would avoid simply removing this in all co=
de paths
> > > > > > > > and would rather make a more specific fix for the offloaded=
 reads.
> > > > > > > >
> > > > > > > > --
> > > > > > > > Best regards,
> > > > > > > > Pavel Shilovsky
> > > > > > > >
> > > > > > > > =D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 13:=
36, Steve French <smfrench@gmail.com>:
> > > > > > > > >
> > > > > > > > > Fixed up 2 small checkpatch warnings and merged into cifs=
-2.6.git for-next
> > > > > > > > >
> > > > > > > > > On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> > > > > > > > > <rohiths.msft@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Hi All,
> > > > > > > > > >
> > > > > > > > > > With the "esize" mount option, I observed data corrupti=
on and cifs
> > > > > > > > > > reconnects during performance tests.
> > > > > > > > > >
> > > > > > > > > > TCP server info field server->total_read is modified pa=
rallely by
> > > > > > > > > > demultiplex thread and decrypt offload worker thread. s=
erver->total_read
> > > > > > > > > > is used in calculation to discard the remaining data of=
 PDU which is
> > > > > > > > > > not read into memory.
> > > > > > > > > >
> > > > > > > > > > Because of parallel modification, =E2=80=9Cserver->tota=
l_read=E2=80=9D value got
> > > > > > > > > > corrupted and instead of discarding the remaining data,=
 it discarded
> > > > > > > > > > some valid data from the next PDU.
> > > > > > > > > >
> > > > > > > > > > server->total_read field is already updated properly du=
ring read from
> > > > > > > > > > socket. So, no need to update the same field again afte=
r decryption.
> > > > > > > > > >
> > > > > > > > > > Regards,
> > > > > > > > > > Rohith
> > > > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > --
> > > > > > > > > Thanks,
> > > > > > > > >
> > > > > > > > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
