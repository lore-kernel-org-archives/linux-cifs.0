Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F068C4320A
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Aug 2021 17:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7F3761058
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Aug 2021 17:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbhHIRwL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Aug 2021 13:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbhHIRwL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Aug 2021 13:52:11 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914E4C061798
        for <linux-cifs@vger.kernel.org>; Mon,  9 Aug 2021 10:51:50 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id dk2so9431373qvb.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Aug 2021 10:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+jgm8f6qLwVRwqw+onxb7pUQp2OzWLj5MWSH/TZR1lg=;
        b=k7xueK+4mzlwQUXdMpnpVWcp6qTmXBLHD5nXWjbJU/SR8aiAO7DEpGfbhjy+eH4Ptp
         WiCxbmhhS5Is71rOqmUmFzG/a4XoPsYskvlWEbqBBUAnrQSi8bVfZGtNCqHAEJn86L5s
         oHc83AkppqSnusxvPCkGq8eHlZA9QaCChWzFUh1s3dTWITsMWM1NrF9n8En51n0mdIJX
         U/oWCzdQnwSpHjb/G5iTbAhtUIzFy0nwxPuDH0v8Kbxq5XJQaCp5NKMDJ6WcI/qlixSO
         +e5VTir7JDVGm7xN8H///ivAJvQOLY5HXnctPnchpN+NiCnxnKF1GBS9YLFnyJnGyWAb
         e8Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+jgm8f6qLwVRwqw+onxb7pUQp2OzWLj5MWSH/TZR1lg=;
        b=cTfd0DD3A2zlgqjBtWbjUSkTANlYtoUKvjaoQsu0YLzgDyP/zwvDkcj83GgiYDk3Xx
         HtqfBXRnXw/ObKC82anwzoi7M+02/a+i7maxz+QY7+y86yPx6jrY2VmKP75x89FMkVST
         flR4Oh/VLPoYN5S+4yCvBDaKqiILVGCtNdyn6NBIRKNi73gRrTE7q5ya9jMM6ubQGBtp
         o06sXbd9MEKMtQAQMdzxYg8vJqK6baDHSOL0o3rcoKeBLWN2ZyLCqONAUUvc/jRFdxDO
         oBfDXJGMWZti5z8OmVWe7RX1TVnUvIFmQvUNZA/HcSNFiHiyttjoyB84oa+YwTbfvYTr
         P8Kg==
X-Gm-Message-State: AOAM5300BJYQ7a4WjIbnvxaeWYAgjrdv/UDs2DoT1FHz7Pp+mlHfvUMx
        UrP+FBPZoQrFUcm85GymMmInqA==
X-Google-Smtp-Source: ABdhPJwBTUiS+76CDkMxJrLBv/Y+VhQj6kwC4MHhZsyJSCETZaOiVdDvWRCCGaqaWO6lSrHh5M+P0w==
X-Received: by 2002:a05:6214:18c7:: with SMTP id cy7mr24583469qvb.59.1628531509748;
        Mon, 09 Aug 2021 10:51:49 -0700 (PDT)
Received: from smtpclient.apple ([2600:1700:42f0:6600:615b:6e84:29a:3bc6])
        by smtp.gmail.com with ESMTPSA id c27sm8499011qkp.5.2021.08.09.10.51.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 10:51:49 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [RFC PATCH 02/20] hfsplus: Add iocharset= mount option as alias
 for nls=
From:   Viacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <20210808162453.1653-3-pali@kernel.org>
Date:   Mon, 9 Aug 2021 10:51:44 -0700
Cc:     Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net, linux-cifs@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        Pavel Machek <pavel@ucw.cz>,
        =?utf-8?Q?Marek_Beh=C3=BAn?= <marek.behun@nic.cz>,
        Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DA573A41-865C-4171-8837-FD5A2C33F42B@dubeyko.com>
References: <20210808162453.1653-1-pali@kernel.org>
 <20210808162453.1653-3-pali@kernel.org>
To:     =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



> On Aug 8, 2021, at 9:24 AM, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>=20
> Other fs drivers are using iocharset=3D mount option for specifying =
charset.
> So add it also for hfsplus and mark old nls=3D mount option as =
deprecated.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
> fs/hfsplus/options.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
> index 047e05c57560..a975548f6b91 100644
> --- a/fs/hfsplus/options.c
> +++ b/fs/hfsplus/options.c
> @@ -23,6 +23,7 @@ enum {
> 	opt_creator, opt_type,
> 	opt_umask, opt_uid, opt_gid,
> 	opt_part, opt_session, opt_nls,
> +	opt_iocharset,
> 	opt_nodecompose, opt_decompose,
> 	opt_barrier, opt_nobarrier,
> 	opt_force, opt_err
> @@ -37,6 +38,7 @@ static const match_table_t tokens =3D {
> 	{ opt_part, "part=3D%u" },
> 	{ opt_session, "session=3D%u" },
> 	{ opt_nls, "nls=3D%s" },
> +	{ opt_iocharset, "iocharset=3D%s" },
> 	{ opt_decompose, "decompose" },
> 	{ opt_nodecompose, "nodecompose" },
> 	{ opt_barrier, "barrier" },
> @@ -166,6 +168,9 @@ int hfsplus_parse_options(char *input, struct =
hfsplus_sb_info *sbi)
> 			}
> 			break;
> 		case opt_nls:
> +			pr_warn("option nls=3D is deprecated, use =
iocharset=3D\n");
> +			/* fallthrough */
> +		case opt_iocharset:
> 			if (sbi->nls) {
> 				pr_err("unable to change nls =
mapping\n");
> 				return 0;
> @@ -230,7 +235,7 @@ int hfsplus_show_options(struct seq_file *seq, =
struct dentry *root)
> 	if (sbi->session >=3D 0)
> 		seq_printf(seq, ",session=3D%u", sbi->session);
> 	if (sbi->nls)
> -		seq_printf(seq, ",nls=3D%s", sbi->nls->charset);
> +		seq_printf(seq, ",iocharset=3D%s", sbi->nls->charset);
> 	if (test_bit(HFSPLUS_SB_NODECOMPOSE, &sbi->flags))
> 		seq_puts(seq, ",nodecompose");
> 	if (test_bit(HFSPLUS_SB_NOBARRIER, &sbi->flags))
> --=20
> 2.20.1
>=20

Looks reasonable. But I would like to be sure that the code has been =
reasonably tested.

Thanks,
Slava.


