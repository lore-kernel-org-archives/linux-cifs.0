Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C90CE7C4E2
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Oct 2023 17:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243655AbjJDRPF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Oct 2023 13:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243653AbjJDRPF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Oct 2023 13:15:05 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C643D9E;
        Wed,  4 Oct 2023 10:15:01 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-5043a01ee20so102928e87.0;
        Wed, 04 Oct 2023 10:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696439700; x=1697044500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uN0/qBnSOCxuRcuMfH57mhCtCNdVLTpuCD2AqgTf59I=;
        b=ngUVcIWeSiiSiYkv1twIBtNK8w2wPrRyfPgNAnFs2MUeyVtWJXR1E93plCZH2Scdsm
         G5nwnl5Ao0fvmm7b42UPjLxIlwg+nP0Q1Logi+GX2n4aH7mtP01G8LZQsG1TnLOoCYDW
         w3ZIXPx63+R+BUt2zUcbg1JGdHvauIC4BZFB4HHYn4G4YMj/RWpXFuli+2Tc+fD3uFv5
         GLH+W6kvV1LMxh/ZmH6OI5bu0M2MtjQjYJ6yopM7DOX+ynPFaA9As6g+ju1k80QTx357
         6BwwPE2/UL3le8sQP8KKX+yvuZpTMFkmmdmyu+xD4c8se7zdLetjIg4J+TqVRwHi6IO0
         KyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696439700; x=1697044500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uN0/qBnSOCxuRcuMfH57mhCtCNdVLTpuCD2AqgTf59I=;
        b=sjdmFlZ63gEa4Z6fIbv7mz8gCpxmMw+E3M2F6sgbrcUZ1qWrk3fdnfT3awz3Pt3yfB
         bXxZPZge5CjgDJBUdF5WfM0o5JV0oTk3lpA/LLwE1rdZ3m+Ir7r8ItFS/FW6RF1LnmOV
         ux+OQCUQK9X72YFj1McAahuSKZ70aNBIAal+xoVeOVFy1cXXGK80OQYzjg5Nxbx8HdNj
         XyoeGlgr2YCyoWI1luxUVorc7KiCxEHkFmEt/V1gvpg1Ek2N8VDAj87acpeq6HnHn6SS
         Y3T6rcffHloBuxhufVdbS5jE6Bow8s793ypXJEfjaD8x89CODtg1YgjRi+vVsj9UZt/j
         EWzw==
X-Gm-Message-State: AOJu0Yy+E266zaPe5ChcG7t1dpsKE0pFpnfLGDV2ymS48TEnK9ZvlSWC
        nGr0TjdmcG3ni7e3gcIiE98UZdD0qBAMrSHTnxM=
X-Google-Smtp-Source: AGHT+IFaH/fFdbF+DkwG9xKZ0qeshMs9vxr3MPhrVxX7QwoI5Tx/rsMu4nwy0PRPqeHlT1Zml0o003d7n/XjVoIND9M=
X-Received: by 2002:a05:6512:32cd:b0:4fa:f96c:745f with SMTP id
 f13-20020a05651232cd00b004faf96c745fmr3011246lfg.38.1696439699819; Wed, 04
 Oct 2023 10:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20231004011303.979995-1-jrife@google.com> <9062eefc4114f9c9162a19f98a1b820c.pc@manguebit.com>
In-Reply-To: <9062eefc4114f9c9162a19f98a1b820c.pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Oct 2023 12:14:48 -0500
Message-ID: <CAH2r5mt4UGni0Wa2sqBA+OGuvnYjmy1ut0pzKa-1C1vUE=fEaw@mail.gmail.com>
Subject: Re: [PATCH] smb: use kernel_connect() and kernel_bind()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     Jordan Rife <jrife@google.com>, sfrench@samba.org,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing and
additional review

On Wed, Oct 4, 2023 at 10:44=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Jordan Rife <jrife@google.com> writes:
>
> > Recent changes to kernel_connect() and kernel_bind() ensure that
> > callers are insulated from changes to the address parameter made by BPF
> > SOCK_ADDR hooks. This patch wraps direct calls to ops->connect() and
> > ops->bind() with kernel_connect() and kernel_bind() to ensure that SMB
> > mounts do not see their mount address overwritten in such cases.
> >
> > Link: https://lore.kernel.org/netdev/9944248dba1bce861375fcce9de663934d=
933ba9.camel@redhat.com/
> > Cc: <stable@vger.kernel.org> # 6.x.y
> > Signed-off-by: Jordan Rife <jrife@google.com>
> > ---
> >  fs/smb/client/connect.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
>
> Acked-by: Paulo Alcantara (SUSE) <pc@manguebit.com>



--=20
Thanks,

Steve
