Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871FBC7618D
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Apr 2023 02:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjDDCiP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Apr 2023 22:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDCiO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Apr 2023 22:38:14 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4529710DA
        for <linux-cifs@vger.kernel.org>; Mon,  3 Apr 2023 19:38:13 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id y15so40524558lfa.7
        for <linux-cifs@vger.kernel.org>; Mon, 03 Apr 2023 19:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680575891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hh6Dq6eVuUbyqiocJ/g7WubDddebjYZfcg1Vu+GYTaQ=;
        b=gPAjf3TAi+RADIp8dFKpHZm9EI2ZW4IuTdPdWB71yBDTSosqUO4VG5kF0ILRqjAtuT
         lFoKVqcX+GgSm/VlnS+x8I14GrHYLAvJuQiyBV2jWsK8l65S2F94U24IWV8KYpfp+wP8
         11PY8GR0D3B1sEDWDkP1M5/KP1p20M8kTIumINVEhy2otSpXWkW5NUvhaS49MoY/ER9f
         LeYQnW6VxbCkDsQ6nrcU8+SMetWKWe79VAQTgQ6xgX7r8pwmkVhOKVI5uZy807sEgEYB
         EE2AQ4Qo/ehra+VD3moPVLAzUfKfeTn6afSnRuxkKcXxd6W435O7SU01bg8Rx1dGDmrJ
         YJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680575891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hh6Dq6eVuUbyqiocJ/g7WubDddebjYZfcg1Vu+GYTaQ=;
        b=LpDdGNmFD3LInU3vyhodNN+jOKoSZhu8mjJeZs21wCbmWSJfSxU8qhGiM8mm1KEWpV
         GY/b6fRotB9Bv4SD+nk/iBXh4/pHsL3OgyP3Tzvpck9zLg1U1ngtnZd4O37bXAOirwqY
         5N/GXBz5KXJP3+KsmOCISLbVqSKDN9H2BNv4w3FfZLTPngpIgsgY8HTYVrZbHbCsGYyg
         dGIuPjQmkhUU5BR0ZakzRLSGkGp8mbOfTw+rPc6CYgdI+3+sa5QNUObNoKEIocJcvSWv
         +DfSib/uXxgY31mTLcpf2V7zFAnkt/Hstn/ujhCY2iozKibgb+GEjXPz9gWKtNztQs2H
         q1sg==
X-Gm-Message-State: AAQBX9cntYL27vdH1q8xF8pS5pTvZO38ec772Lzu+dbdmUi0ekSC+g6j
        WQsJLRjNBeUEyplKJm3dgHR3Zgp7tFKf4u4BqEY+M76T
X-Google-Smtp-Source: AKy350Z1IqoBnNKMeo5XZSMPdLFAmaxd8kn8mOxuhm0g0olZvOhTGUH8yORGoz1aFQWXbtcEgrY3L6rMddZjHZl8RZo=
X-Received: by 2002:ac2:5688:0:b0:4e9:a3b7:2369 with SMTP id
 8-20020ac25688000000b004e9a3b72369mr238897lfr.7.1680575891498; Mon, 03 Apr
 2023 19:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <PH7PR12MB58053A72CA4EB58CD2B14E53DB939@PH7PR12MB5805.namprd12.prod.outlook.com>
In-Reply-To: <PH7PR12MB58053A72CA4EB58CD2B14E53DB939@PH7PR12MB5805.namprd12.prod.outlook.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 3 Apr 2023 21:38:00 -0500
Message-ID: <CAH2r5mvQOAvFP8JYg8_VQsoKv2o6A2qYwZdkrMsbhpCZtX2=jQ@mail.gmail.com>
Subject: Re: Inconsistent mfsymlinks behavior
To:     Skyler Dawson <sdawson@nvidia.com>
Cc:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

could you confirm the kernel version

On Mon, Apr 3, 2023 at 7:55=E2=80=AFPM Skyler Dawson <sdawson@nvidia.com> w=
rote:
>
> Hi there,
>
> I recently came across some inconsistent behavior when using python to tr=
averse directories that had mfsymlinks, where os.scandir and os.path would =
return different values for whether a filesystem entry is a directory and i=
s  a link. I filed a bug report to the cpython repository here: https://git=
hub.com/python/cpython/issues/102503, and @eryksun traced the issue to read=
dir() returning DT_REG instead of DT_LINK. More details are in the github i=
ssue. Can you please confirm that this is an issue in cifs that needs to be=
 addressed, or if there is another reason readdir can't return DT_LINK for =
an emulated symlink with mfsymlinks?
>
> Thanks,
> Skyler Dawson.



--=20
Thanks,

Steve
