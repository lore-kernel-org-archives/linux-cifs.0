Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43A3C7619A
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Apr 2023 13:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbjDENQS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Apr 2023 09:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjDENQR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Apr 2023 09:16:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57F5E7A
        for <linux-cifs@vger.kernel.org>; Wed,  5 Apr 2023 06:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AEC4628F2
        for <linux-cifs@vger.kernel.org>; Wed,  5 Apr 2023 13:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8705C4339C
        for <linux-cifs@vger.kernel.org>; Wed,  5 Apr 2023 13:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680700575;
        bh=d/py0SeCW+mA9rz7Gns3Ac7OJwXGKahbBCvBivrCYQk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=kUabwK9lOEzr0alm1PYGettFNP6z5KL9wzAQSlbKPi7SxhRYv1ZnXwnnM4J0Y7vvI
         1E6jU+UteHvErRr7pYyjWwfqRQ2GlSqdZE41Z9946iAFr8O9DuXsja9wI+9m7IDkFO
         J03Q1TyqBpjCLPHr+lpmaTJ77+sd+lemwH5/dGCWgGRse4E4bpyqlwWb5WLA1Kg7M3
         w6KbPqnlLsCX6n1IEZBIILNzDSvQAVCTjhrz4oyXfiS3uz2ddok4vFrZBLatEwGDvk
         T5jLEtFvy75zA6UbjsLfTc02RAnQl86m8kveyxAqn5vePFdNqedYfaItXmnif/rWuu
         PkYXR1sOu2Snw==
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-17997ccf711so38409306fac.0
        for <linux-cifs@vger.kernel.org>; Wed, 05 Apr 2023 06:16:15 -0700 (PDT)
X-Gm-Message-State: AAQBX9cnZLcT4UvWrsZZpOlXqXWwTD/pdhVTbktA4GcGjVqV2WF/UAKS
        vZs4nBWLI/FU4hpm36as0Ry+wFJBUzyow0W1GxM=
X-Google-Smtp-Source: AKy350Zt3V3MixrWzDKgNo3Q5x7d0abvmqd3KwJIZdNNpivdp+4nNqqE9EjqeOG2VFnvBNS/UwvXWcRwagjYZ8EgdFM=
X-Received: by 2002:a05:6870:cd04:b0:16e:8993:9d7c with SMTP id
 qk4-20020a056870cd0400b0016e89939d7cmr1172915oab.1.1680700574855; Wed, 05 Apr
 2023 06:16:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:744d:0:b0:4c8:b94d:7a80 with HTTP; Wed, 5 Apr 2023
 06:16:14 -0700 (PDT)
In-Reply-To: <20230404142954.26674-1-ddiss@suse.de>
References: <20230404142954.26674-1-ddiss@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 5 Apr 2023 22:16:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_MqyrFjL0cO2ZhS-Sjvhb14SMe-H9ffnq57OtKnnXQ0g@mail.gmail.com>
Message-ID: <CAKYAXd_MqyrFjL0cO2ZhS-Sjvhb14SMe-H9ffnq57OtKnnXQ0g@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: remove unused compression negotiate ctx packing
To:     David Disseldorp <ddiss@suse.de>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-04-04 23:29 GMT+09:00, David Disseldorp <ddiss@suse.de>:
> build_compression_ctxt() is currently unreachable due to
> conn.compress_algorithm remaining zero (SMB3_COMPRESS_NONE).
>
> It appears to have been broken in a couple of subtle ways over the
> years:
> - prior to d6c9ad23b421 ("ksmbd: use the common definitions for
>   NEGOTIATE_PROTOCOL") smb2_compression_ctx.DataLength was set to 8,
>   which didn't account for the single CompressionAlgorithms flexible
>   array member.
> - post d6c9ad23b421 smb2_compression_capabilities_context
>   CompressionAlgorithms is a three member array, while
>   CompressionAlgorithmCount is set to indicate only one member.
>   assemble_neg_contexts() ctxt_size is also incorrectly incremented by
>   sizeof(struct smb2_compression_capabilities_context) + 2, which
>   assumes one flexible array member.
>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
