Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E66ECAAD3
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 13:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbiIAN13 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiIAN0E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 09:26:04 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EA430E
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 06:24:31 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MJM901FnTzYcmw;
        Thu,  1 Sep 2022 21:20:04 +0800 (CST)
Received: from [10.174.176.83] (10.174.176.83) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 1 Sep 2022 21:24:28 +0800
Message-ID: <b1e14aef-f915-f86a-a043-a18aee51a205@huawei.com>
Date:   Thu, 1 Sep 2022 21:24:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v3 5/5] cifs: Refactor dialects in
 validate_negotiate_info_req to variable array
To:     <linux-cifs@vger.kernel.org>, <sfrench@samba.org>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>,
        <rohiths@microsoft.com>, <smfrench@gmail.com>, <tom@talpey.com>,
        <linkinjeon@kernel.org>, <hyc.lee@gmail.com>
References: <20220901142216.3351155-1-zhangxiaoxu5@huawei.com>
 <20220901142216.3351155-6-zhangxiaoxu5@huawei.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
In-Reply-To: <20220901142216.3351155-6-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.83]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



在 2022/9/1 22:22, Zhang Xiaoxu 写道:
> The length of the message FSCTL_VALIDATE_NEGOTIATE_INFO is
> depends on the count of the dialects, the dialects count is
> depending on the smb version, so the dialects should be
> variable array.
> 
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>   fs/cifs/smb2pdu.c         | 7 ++++---
>   fs/ksmbd/smb2pdu.c        | 2 +-
>   fs/smbfs_common/smb2pdu.h | 3 +--
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 1fbb8ccf1ff6..82cd21c26c60 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1105,7 +1105,10 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   	if (tcon->ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
>   		cifs_tcon_dbg(VFS, "Unexpected null user (anonymous) auth flag sent by server\n");
>   
> -	pneg_inbuf = kmalloc(sizeof(*pneg_inbuf), GFP_NOFS);
> +	inbuflen = sizeof(*pneg_inbuf) +
> +			sizeof(__le16) * server->vals->neg_dialect_cnt;
> +
> +	pneg_inbuf = kmalloc(inbuflen, GFP_NOFS);
>   	if (!pneg_inbuf)
>   		return -ENOMEM;
>   
> @@ -1129,8 +1132,6 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   	pneg_inbuf->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
>   	memcpy(pneg_inbuf->Dialects, server->vals->neg_dialects,
>   		server->vals->neg_dialect_cnt * sizeof(__le16));
> -	inbuflen = offsetof(struct validate_negotiate_info_req, Dialects) +
> -		sizeof(pneg_inbuf->Dialects[0]) * server->vals->neg_dialect_cnt;
>   
>   	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>   		FSCTL_VALIDATE_NEGOTIATE_INFO,
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 7da0ec466887..aad74da7e070 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7392,7 +7392,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
>   	int ret = 0;
>   	int dialect;
>   
> -	if (in_buf_len < offsetof(struct validate_negotiate_info_req, Dialects) +
> +	if (in_buf_len < sizeof(neg_req) +
should be sizeof(*neg_req)
>   			le16_to_cpu(neg_req->DialectCount) * sizeof(__le16))
>   		return -EINVAL;
>   
> diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
> index 2cab413fffee..4780c72e9b3a 100644
> --- a/fs/smbfs_common/smb2pdu.h
> +++ b/fs/smbfs_common/smb2pdu.h
> @@ -1388,13 +1388,12 @@ struct reparse_symlink_data_buffer {
>   } __packed;
>   
>   /* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
> -
>   struct validate_negotiate_info_req {
>   	__le32 Capabilities;
>   	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
>   	__le16 SecurityMode;
>   	__le16 DialectCount;
> -	__le16 Dialects[4]; /* BB expand this if autonegotiate > 4 dialects */
> +	__le16 Dialects[];
>   } __packed;
>   
>   struct validate_negotiate_info_rsp {
