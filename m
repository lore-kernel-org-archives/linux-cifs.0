Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBF7C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 22:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbiARWpQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jan 2022 17:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350030AbiARWpO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jan 2022 17:45:14 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EABC061574
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jan 2022 14:45:14 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id p5so1380601ybd.13
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jan 2022 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zVzd8hYKT3zsWzOt6lF6gWakNp/Fk139BBliRPW3Kw=;
        b=dqjE55k+zE/bKty/XlwHbc859LBeNKFcShQy2gKWecSD/mJiOhhmnRC05/WqtyiBQ/
         aGfTZvBOpuMBBXA+I3LKVUIP3gdNXYoXpvLdmgVbYYWHMoKvrjNQ72OK8XQivMNRUtst
         bB12Gz4kXyn1lN07dXd+DBS/rN+GA8cfFjehJcblwKqvLEd+/KehVqjqY6z3WPes7vmi
         IWh3Q5T5coBCqBte8v5Dgo7GYZ3Y/u7cHPvvQ944Ezqd7m/Kwkc9GPloHgTjzBagVky5
         KW/CWOnSU6tnnDW2EYKPeg30H8kbpPKaoRAm6wLS/gIZ77WHjl/h1UlR5/HQz7U2ICAx
         BpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zVzd8hYKT3zsWzOt6lF6gWakNp/Fk139BBliRPW3Kw=;
        b=Sghf/iLvqfXXX9Fh6jJmyCrNTebE9OINb37d0DFGNnqGbVdA85wJUTaDAzkcXpcvjF
         +oXjzUtELgGmxkR5PUuEq7ztUWeanRurjOZXj0Qp4dDc01jNQSM5QmcGJNwLuGXzfaHy
         4RvWAd9hA3SkKdM7UtoqwjtDXm3g966b6c2AQzIBHQ+0W3S3ODkqnkKgl+ejOcHaS3Aa
         2OOoPcAQZ2hYVxNgwg4zhFnSqG/E5SVwsT5QO/Hk3UHN4gEmLHfn8lvEzZdPy/q3GAO4
         PkX+amZePOIKJtfv++WCH58AtCINLTKFn7bF6KJgBa/8AmkLlPwut6DerrkeFgz42u04
         IFKg==
X-Gm-Message-State: AOAM533vV8D0jmlSg7JW44PDYWyjSVWCNqNYsVuKgnKmYexrMMOyLw3e
        ZVLiP+qvfwRaQrGBhyuS4HwtXBM9aFVE/mWWNIg=
X-Google-Smtp-Source: ABdhPJweMgO2xTgCPT+YiGAWMyne3hp/hAARqLDLslSk/68CSSVvqduh7ws90XpLiT3sZt6IP3eWDn62ekIKLvx8jjo=
X-Received: by 2002:a25:1e0b:: with SMTP id e11mr36255586ybe.272.1642545913530;
 Tue, 18 Jan 2022 14:45:13 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msv5w5oWVomujjwoC=PiNBu3b7kbQO6uJXVKbAwxGKuJw@mail.gmail.com>
In-Reply-To: <CAH2r5msv5w5oWVomujjwoC=PiNBu3b7kbQO6uJXVKbAwxGKuJw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 19 Jan 2022 08:45:01 +1000
Message-ID: <CAN05THSRBhqs=YMGGhp1BSB-Qhm=7bQc83UcBDhrr6Qo36sZQQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] add new defines from protocol specification
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed by me

On Wed, Jan 19, 2022 at 8:41 AM Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Trivial update to list of valid smb3 fsctls
>
> In the October updates to MS-SMB2 two additional FSCTLs
> were described.  Add the missing defines for these,
> as well as fix a typo in an earlier define.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/smbfs_common/smb2pdu.h  | 2 +-
>  fs/smbfs_common/smbfsctl.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
> index 7ccadcbe684b..38b8fc514860 100644
> --- a/fs/smbfs_common/smb2pdu.h
> +++ b/fs/smbfs_common/smb2pdu.h
> @@ -449,7 +449,7 @@ struct smb2_netname_neg_context {
>   */
>
>  /* Flags */
> -#define SMB2_ACCEPT_TRANSFORM_LEVEL_SECURITY 0x00000001
> +#define SMB2_ACCEPT_TRANSPORT_LEVEL_SECURITY 0x00000001
>
>  struct smb2_transport_capabilities_context {
>   __le16 ContextType; /* 6 */
> diff --git a/fs/smbfs_common/smbfsctl.h b/fs/smbfs_common/smbfsctl.h
> index 926f87cd6af0..d51939c43ad7 100644
> --- a/fs/smbfs_common/smbfsctl.h
> +++ b/fs/smbfs_common/smbfsctl.h
> @@ -95,8 +95,10 @@
>  #define FSCTL_SET_SHORT_NAME_BEHAVIOR 0x000901B4 /* BB add struct */
>  #define FSCTL_GET_INTEGRITY_INFORMATION 0x0009027C
>  #define FSCTL_GET_REFS_VOLUME_DATA   0x000902D8 /* See MS-FSCC 2.3.24 */
> +#define FSCTL_SET_INTEGRITY_INFORMATION_EXT 0x00090380
>  #define FSCTL_GET_RETRIEVAL_POINTERS_AND_REFCOUNT 0x000903d3
>  #define FSCTL_GET_RETRIEVAL_POINTER_COUNT 0x0009042b
> +#define FSCTL_REFS_STREAM_SNAPSHOT_MANAGEMENT 0x00090440
>  #define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF
>  #define FSCTL_SET_DEFECT_MANAGEMENT  0x00098134 /* BB add struct */
>  #define FSCTL_FILE_LEVEL_TRIM        0x00098208 /* BB add struct */
> --
>
> --
> Thanks,
>
> Steve
>
