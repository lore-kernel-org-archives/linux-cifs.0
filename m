Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A012C4361B
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 13:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF60823B1F
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 13:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732047AbgLINuR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:50:17 -0500
Received: from p3plsmtpa08-01.prod.phx3.secureserver.net ([173.201.193.102]:38755
        "EHLO p3plsmtpa08-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732005AbgLINuR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 08:50:17 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2020 08:50:17 EST
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id mzhukpj6c16zBmzhukaUn1; Wed, 09 Dec 2020 06:40:39 -0700
X-CMAE-Analysis: v=2.4 cv=IO7HtijG c=1 sm=1 tr=0 ts=5fd0d3d7
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=b8R4eSf-EADCyHu-sRcA:9
 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [SMB3][Multichannel] avoid confusing warning message on mount to
 Azure
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mtx6zWZ2T_Erb=6JQ3mHJxh=bHydww-F52ts3zsvgd8Jw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <472d2c7d-3e78-a570-0c0f-aab6ebfeb90b@talpey.com>
Date:   Wed, 9 Dec 2020 08:40:37 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mtx6zWZ2T_Erb=6JQ3mHJxh=bHydww-F52ts3zsvgd8Jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfGQBlUao8CoSYCH3E9evJMLEl3x5k0HeTdx+GfK5sCfBYXJzZni5fyPnyFnwbCFcYw1gLuCJSLd8sPANrXIsAVYO6AjI7q/Nhi+W6GJMQqJqFqmxYb42
 IyL/t2+FTyqD9s7G6QeFGInpCm71MycNtYJiqyaUwJAFyDNzoXIV1Cbl3KIPJN9MEUZt6dtz0xYrzFw4BJi6TJ+vWSpnswV74ge2pc5IAvBNGRsZYO5VN3b1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Why not just delete the splat? It isn't causing a failure, and
appears to be legal protocol behavior.

On 12/8/2020 10:21 PM, Steve French wrote:
> Mounts to Azure cause an unneeded warning message in dmesg
>     "CIFS: VFS: parse_server_interfaces: incomplete interface info"
> 
> Azure rounds up the size (by 8 additional bytes, to a
> 16 byte boundary) of the structure returned on the query
> of the server interfaces at mount time.  This is permissible
> even though different than other servers so do not log a warning
> if query network interfaces response is only rounded up by 8
> bytes or fewer.
> 
> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>   fs/cifs/smb2ops.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 3d914d7d0d11..22f1d8dc12b0 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -477,7 +477,8 @@ parse_server_interfaces(struct
> network_interface_info_ioctl_rsp *buf,
>    goto out;
>    }
> 
> - if (bytes_left || p->Next)
> + /* Azure rounds the buffer size up 8, to a 16 byte boundary */
> + if ((bytes_left > 8) || p->Next)
>    cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
> 
> 
