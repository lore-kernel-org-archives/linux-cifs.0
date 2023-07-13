Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C645BC001DF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jul 2023 21:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjGMVsK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jul 2023 17:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjGMVsJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Jul 2023 17:48:09 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04E1172C;
        Thu, 13 Jul 2023 14:48:08 -0700 (PDT)
Message-ID: <b95eb538478eab38fac638dbeaf97e70.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689284884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sxaYgJXiqQxZAAaq0LTsCSyyboUL4/t3x1zcXMloE4E=;
        b=HCIe3lfk/nTFmpPhHBV0ZugOHxyJFMG/CVf2FYq1rqwevDQCFICPI8mlhZRCiZIO39UD48
        uw7Zge3u2lLIFTb67T6bmGb62fMufzKf0kE0Z2BQnv6xv92CZJ4T14NLea68hCu0hyWron
        /78lPjlYFhOxB9gqBZug2wUiG87gBQHEzrb8Xa08aCiuvsXs2chTLzJzKGnY+OIq6Pioez
        qf1RyONfK54xNbNoU3o/H2mzd+hEeXCjijlV7J/Gf7M5/S3g82z47uo9PkO07RsCJsNtZl
        sa6cF0BrE91ImmIV9KZBvLjPrmXU7796jmasedN+5miCImi1RrAAaY+rMv4lnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689284884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sxaYgJXiqQxZAAaq0LTsCSyyboUL4/t3x1zcXMloE4E=;
        b=mxMVrl20zgyI0WFR6fLRAD6O4nhwvaWNvCtINCASl5QGtDsbLqBwWblfzhF/hi9tubOlOe
        iVLy0hkXKJCdjCIvJjTiuYBeInn8cOjJuRPR64UutTQ3NWW4tfXDRBBGn/qaDEJ3OKRaNp
        UeoBJ7mw+fHXQ+uxR37VcAOiH9sfjLwIb95GRBleOO2ETNXIOXydkgestiAFfP5qPAiyyy
        +nW3ULVfsmfV2yexv+dR8B5yvcmhdxKouhdrTxGyOSdkJDB6EcT0LUZBp04qAXwq/lMZsw
        PQP72VhqEwUG4V3Im6gFYj/EXNo1FFPw7PA7ylB6Zsjy9bcx/7RJY56mpWsCOQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1689284884; a=rsa-sha256;
        cv=none;
        b=EPyY+fXs1XvXgNNTUYAf5WpPHIAI8OtPKXTcPbEk3aKp5aG+rddZhoVB9v51FO0Igf+lKU
        /UwWdRcr4ywR2YsXgxxy4vhU4GB8bOdPROA9vq4uiCrG9C/Gl+aRxAYtnggxqb0YxAoBfY
        XrWxxKiAjRc9+xu5Mm3YhNzfnOcghjkzn/vncg3sjKJyyQbbyfhQYdXJObxKih+LfJ+O+i
        cThkmeupFdRM/wVIoWj+ZXdrovv4lWYUfPyAVeWLIMkF0OT2uvvhKXi/2ZlEAWJUnSuzPR
        YUs/qVXh2y9dRsVj2pzYbHK8/YH2859K+k5r13SfCIpfEkjIxvBRBiZcRXYCoA==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 4/4] smb: client: improve DFS mount check
In-Reply-To: <2023071306-nearly-saved-a419@gregkh>
References: <20230628002450.18781-1-pc@manguebit.com>
 <20230628002450.18781-4-pc@manguebit.com>
 <0bb4a367ebd7ae83dd1538965e3c0d2b.pc@manguebit.com>
 <2023071306-nearly-saved-a419@gregkh>
Date:   Thu, 13 Jul 2023 18:48:00 -0300
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Greg,

Greg KH <gregkh@linuxfoundation.org> writes:

> On Wed, Jul 12, 2023 at 06:10:27PM -0300, Paulo Alcantara wrote:
>> Paulo Alcantara <pc@manguebit.com> writes:
>> 
>> > Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
>> > that are unexpected by the client, so to make it easier, assume
>> > non-DFS mounts when the client can't get the initial DFS referral of
>> > @ctx->UNC in dfs_mount_share().
>> >
>> > Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
>> > ---
>> >  fs/smb/client/dfs.c | 5 +++--
>> >  1 file changed, 3 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
>> > index afbaef05a1f1..a7f2e0608adf 100644
>> 
>> Stable team, could you please pick this up as a fix for
>> 
>>         8e3554150d6c ("cifs: fix sharing of DFS connections")
>> 
>> The upstream commit is 5f2a0afa9890 ("smb: client: improve DFS mount check").
>
> Does not apply cleanly, can you provide a working backport?

Find attached backport of
--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=v6.3-smb-client-improve-DFS-mount-check.patch

From 435048ee0f477947d1d93f5a9b60b2d2df2b7554 Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@manguebit.com>
Date: Tue, 27 Jun 2023 21:24:50 -0300
Subject: [PATCH stable v6.3] smb: client: improve DFS mount check

Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
that are unexpected by the client, so to make it easier, assume
non-DFS mounts when the client can't get the initial DFS referral of
@ctx->UNC in dfs_mount_share().

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/dfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index 267536a7531d..fcf536eb5fe1 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -296,8 +296,9 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 	if (!nodfs) {
 		rc = dfs_get_referral(mnt_ctx, ctx->UNC + 1, NULL, NULL);
 		if (rc) {
-			if (rc != -ENOENT && rc != -EOPNOTSUPP && rc != -EIO)
-				return rc;
+			cifs_dbg(FYI, "%s: no dfs referral for %s: %d\n",
+				 __func__, ctx->UNC + 1, rc);
+			cifs_dbg(FYI, "%s: assuming non-dfs mount...\n", __func__);
 			nodfs = true;
 		}
 	}
-- 
2.41.0


--=-=-=
Content-Type: text/plain


     5f2a0afa9890 ("smb: client: improve DFS mount check").

for v6.3.y.

And for v6.4.y, please take these

    d439b29057e2 ("smb: client: fix broken file attrs with nodfs mounts")
    49024ec8795e ("smb: client: fix parsing of source mount option")
    3ae872de4107 ("smb: client: fix shared DFS root mounts with different prefixes")
    49024ec8795e ("smb: client: fix parsing of source mount option")

Thanks.

--=-=-=--
