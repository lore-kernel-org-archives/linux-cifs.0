Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3848C433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 18:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D6FA613D3
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 18:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhDTSi6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Apr 2021 14:38:58 -0400
Received: from p3plsmtpa07-10.prod.phx3.secureserver.net ([173.201.192.239]:50622
        "EHLO p3plsmtpa07-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233498AbhDTSi6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 20 Apr 2021 14:38:58 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id YvGTloys6n3d9YvGTl19mI; Tue, 20 Apr 2021 11:38:25 -0700
X-CMAE-Analysis: v=2.4 cv=M+qIlw8s c=1 sm=1 tr=0 ts=607f1fa2
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=yMhMjlubAAAA:8 a=8bt7bneSKaUb_571X_EA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH][SMB3] limit noisy error
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5msPnCHf2qHtJ=tJymfa9cgyOgnrv9xPEiYF=nsWTg1syg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <bbdfbbaf-c196-bcdb-cc8f-5effb6d4d0b6@talpey.com>
Date:   Tue, 20 Apr 2021 14:38:25 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5msPnCHf2qHtJ=tJymfa9cgyOgnrv9xPEiYF=nsWTg1syg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfFPrVdaioAVybzluWKAue49YkV8ejOSFzadQDO4vGBA4CQLa4RYqMz1wbLfDrdi8ZbU+xDykImTohGRy4tpMI+SRSxA5Z7vF6KIZGZk4ySAHqsB+f3pK
 Wus3jRjVXsDKpGRoOrI2G+PIDMH8caDTZeHB495I1Si3WO7Dgpv9Unfxkcb+R+GqrEIlVmE13o/w/PiMfcT8MEWX0BPPSYSRMbBBnm32flBAu9bgHlft+fNR
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 4/20/2021 12:27 AM, Steve French wrote:
> For servers which don't support copy_range (SMB3 CopyChunk), the
> logging of:
>   CIFS: VFS: \\server\share refcpy ioctl error -95 getting resume key
> can fill the client logs and make debugging real problems more
> difficult.  Change the -EOPNOTSUPP on copy_range to a "warn once"

Making this a warn_once will suppress the future message for all
tcon's, won't it? Is it possible to use a bit in the tcon to track
this instead? That might be a closer match to the scope of the
message.

Tom.

> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>   fs/cifs/smb2ops.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 5ccc36d98dad..dd0eb665b680 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1567,7 +1567,10 @@ SMB2_request_res_key(const unsigned int xid,
> struct cifs_tcon *tcon,
>    NULL, 0 /* no input */, CIFSMaxBufSize,
>    (char **)&res_key, &ret_data_len);
> 
> - if (rc) {
> + if (rc == -EOPNOTSUPP) {
> + pr_warn_once("Server share %s does not support copy range\n", tcon->treeName);
> + goto req_res_keyFor servers which don't support copy_range (SMB3
> CopyChunk), the
> logging of:
>   CIFS: VFS: \\server\share refcpy ioctl error -95 getting resume key
> can fill the client logs and make debugging real problems more
> difficult.  Change the -EOPNOTSUPP on copy_range to a "warn once"
> 
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>   fs/cifs/smb2ops.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 5ccc36d98dad..dd0eb665b680 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1567,7 +1567,10 @@ SMB2_request_res_key(const unsigned int xid,
> struct cifs_tcon *tcon,
>    NULL, 0 /* no input */, CIFSMaxBufSize,
>    (char **)&res_key, &ret_data_len);
> 
> - if (rc) {
> + if (rc == -EOPNOTSUPP) {
> + pr_warn_once("Server share %s does not support copy range\n", tcon->treeName);
> + goto req_res_key_exit;
> + } else if (rc) {
>    cifs_tcon_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
>    goto req_res_key_exit;
>    }_exit;
> + } else if (rc) {
>    cifs_tcon_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
>    goto req_res_key_exit;
>    }
> 
