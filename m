Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178ABECAAD8
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Sep 2022 12:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiIPMdk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Sep 2022 08:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiIPMdj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Sep 2022 08:33:39 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3E09674E
        for <linux-cifs@vger.kernel.org>; Fri, 16 Sep 2022 05:33:36 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTYL23bL5zmVMf;
        Fri, 16 Sep 2022 20:29:46 +0800 (CST)
Received: from [10.174.176.83] (10.174.176.83) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 20:33:34 +0800
Message-ID: <8798e2b3-3fac-d9da-d423-ba24aecc362e@huawei.com>
Date:   Fri, 16 Sep 2022 20:33:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v6 4/5] cifs: Add neg dialects info to smb version values
To:     Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
CC:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        <rohiths@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
 <20220914021741.2672982-5-zhangxiaoxu5@huawei.com>
 <66eeb466-de8d-8747-f942-6a6f2fbc74b4@talpey.com>
 <CAH2r5ms+TnR4Y1LMWmNm5XdjV-4JSBq1+tsP6ERXq6NzwvWAig@mail.gmail.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
In-Reply-To: <CAH2r5ms+TnR4Y1LMWmNm5XdjV-4JSBq1+tsP6ERXq6NzwvWAig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.83]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks steve and tom.

Now the client only use max 4 dialects, should we need to refactor
the 'Dialects' in 'validate_negotiate_info_req' to variable array?

Now the layout of 'validate_negotiate_info_req' is:

/* offset    |  size */  type = struct validate_negotiate_info_req {
/*    0      |     4 */    __le32 Capabilities;
/*    4      |    16 */    __u8 Guid[16];
/*   20      |     2 */    __le16 SecurityMode;
/*   22      |     2 */    __le16 DialectCount;
/*   24      |     8 */    __le16 Dialects[4];

                            /* total size (bytes):   32 */
                          }

the struct size already the 2 power, if use variable array, doesn't
conserve memory and made code complexity, since we should calculate
the size we allocate memory.

I think use the implicitly variable array is no problems.

This patch is the pre-patch of refactor 'Dialects' to variable array,
it can be easily to get the size of dialects in the negotiate message.

If this patch is unneed, the code to get the dialects size maybe:

int get_nego_dialect_cnt()
{
	if (strcmp(version_string, SMBxx_VERSION_STRING)
		return xx;
	...
}

void build_nego_dialect()
{
	if (strcmp(version_string, SMBxx_VERSION_STRING) {
		Dialects[x] = cpu_to_le16(SMBx_PROT_ID);
		...
	}
}

req = kmalloc(sizeof() + get_nego_dialect_cnt())
build_nego_dialect(req->Dialects)
...

or refactor 'Dialects' to variable array and use default 4
as the dialect count when allocate memory.

Thanks.
Zhang Xiaoxu

在 2022/9/16 8:13, Steve French 写道:
> I lean against this patch because it doesn't appear to fix anything and doesn't seem to make much difference in clarity. As Tom indicated, not likely to add any dialects in the future. I don't mind clean up that removes redundant code or is part of a related fix, but this one doesn't seem to help clarity much
> 
> On Thu, Sep 15, 2022, 11:47 Tom Talpey <tom@talpey.com <mailto:tom@talpey.com>> wrote:
> 
>     Steve, your opinion on including this? You may have missed the
>     question I asked earlier in the thread:
> 
>      > Is this really necessary? It's nice and all, but there aren't
>      > any new SMB2/3 dialects coming down the pike. I'm ambivalent
>      > about changing the code unless there's an actual issue, for
>      > the purpose of maintaining stable, etc. Steve?
> 
>     Tom.
> 
>     On 9/13/2022 7:17 PM, Zhang Xiaoxu wrote:
>      > The dialects information when negotiate with server is
>      > depends on the smb version, add it to the version values
>      > and make code simple.
>      >
>      > Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com <mailto:zhangxiaoxu5@huawei.com>>
>      > Acked-by: Tom Talpey <tom@talpey.com <mailto:tom@talpey.com>>
>      > ---
>      >   fs/cifs/cifsglob.h |  2 ++
>      >   fs/cifs/smb2ops.c  | 35 ++++++++++++++++++++++++++++
>      >   fs/cifs/smb2pdu.c  | 58 +++++++---------------------------------------
>      >   3 files changed, 46 insertions(+), 49 deletions(-)
>      >
>      > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>      > index ae7f571a7dba..376421b63738 100644
>      > --- a/fs/cifs/cifsglob.h
>      > +++ b/fs/cifs/cifsglob.h
>      > @@ -553,6 +553,8 @@ struct smb_version_values {
>      >       __u16           signing_enabled;
>      >       __u16           signing_required;
>      >       size_t          create_lease_size;
>      > +     int             neg_dialect_cnt;
>      > +     __le16          *neg_dialects;
>      >   };
>      >
>      >   #define HEADER_SIZE(server) (server->vals->header_size)
>      > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>      > index 421be43af425..e1407124c761 100644
>      > --- a/fs/cifs/smb2ops.c
>      > +++ b/fs/cifs/smb2ops.c
>      > @@ -5664,6 +5664,12 @@ struct smb_version_values smb21_values = {
>      >       .create_lease_size = sizeof(struct create_lease),
>      >   };
>      >
>      > +static __le16 smb3any_neg_dialects[] = {
>      > +     cpu_to_le16(SMB30_PROT_ID),
>      > +     cpu_to_le16(SMB302_PROT_ID),
>      > +     cpu_to_le16(SMB311_PROT_ID)
>      > +};
>      > +
>      >   struct smb_version_values smb3any_values = {
>      >       .version_string = SMB3ANY_VERSION_STRING,
>      >       .protocol_id = SMB302_PROT_ID, /* doesn't matter, send protocol array */
>      > @@ -5683,6 +5689,15 @@ struct smb_version_values smb3any_values = {
>      >       .signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .create_lease_size = sizeof(struct create_lease_v2),
>      > +     .neg_dialect_cnt = ARRAY_SIZE(smb3any_neg_dialects),
>      > +     .neg_dialects = smb3any_neg_dialects,
>      > +};
>      > +
>      > +static __le16 smbdefault_neg_dialects[] = {
>      > +     cpu_to_le16(SMB21_PROT_ID),
>      > +     cpu_to_le16(SMB30_PROT_ID),
>      > +     cpu_to_le16(SMB302_PROT_ID),
>      > +     cpu_to_le16(SMB311_PROT_ID)
>      >   };
>      >
>      >   struct smb_version_values smbdefault_values = {
>      > @@ -5704,6 +5719,12 @@ struct smb_version_values smbdefault_values = {
>      >       .signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .create_lease_size = sizeof(struct create_lease_v2),
>      > +     .neg_dialect_cnt = ARRAY_SIZE(smbdefault_neg_dialects),
>      > +     .neg_dialects = smbdefault_neg_dialects,
>      > +};
>      > +
>      > +static __le16 smb30_neg_dialects[] = {
>      > +     cpu_to_le16(SMB30_PROT_ID),
>      >   };
>      >
>      >   struct smb_version_values smb30_values = {
>      > @@ -5725,6 +5746,12 @@ struct smb_version_values smb30_values = {
>      >       .signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .create_lease_size = sizeof(struct create_lease_v2),
>      > +     .neg_dialect_cnt = ARRAY_SIZE(smb30_neg_dialects),
>      > +     .neg_dialects = smb30_neg_dialects,
>      > +};
>      > +
>      > +static __le16 smb302_neg_dialects[] = {
>      > +     cpu_to_le16(SMB302_PROT_ID),
>      >   };
>      >
>      >   struct smb_version_values smb302_values = {
>      > @@ -5746,6 +5773,12 @@ struct smb_version_values smb302_values = {
>      >       .signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .create_lease_size = sizeof(struct create_lease_v2),
>      > +     .neg_dialect_cnt = ARRAY_SIZE(smb302_neg_dialects),
>      > +     .neg_dialects = smb302_neg_dialects,
>      > +};
>      > +
>      > +static __le16 smb311_neg_dialects[] = {
>      > +     cpu_to_le16(SMB311_PROT_ID),
>      >   };
>      >
>      >   struct smb_version_values smb311_values = {
>      > @@ -5767,4 +5800,6 @@ struct smb_version_values smb311_values = {
>      >       .signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>      >       .create_lease_size = sizeof(struct create_lease_v2),
>      > +     .neg_dialect_cnt = ARRAY_SIZE(smb311_neg_dialects),
>      > +     .neg_dialects = smb311_neg_dialects,
>      >   };
>      > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>      > index 223056097b54..482ed480fbc6 100644
>      > --- a/fs/cifs/smb2pdu.c
>      > +++ b/fs/cifs/smb2pdu.c
>      > @@ -897,27 +897,10 @@ SMB2_negotiate(const unsigned int xid,
>      >       memset(server->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
>      >       memset(ses->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
>      >
>      > -     if (strcmp(server->vals->version_string,
>      > -                SMB3ANY_VERSION_STRING) == 0) {
>      > -             req->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
>      > -             req->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
>      > -             req->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
>      > -             req->DialectCount = cpu_to_le16(3);
>      > -             total_len += 6;
>      > -     } else if (strcmp(server->vals->version_string,
>      > -                SMBDEFAULT_VERSION_STRING) == 0) {
>      > -             req->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
>      > -             req->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
>      > -             req->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
>      > -             req->Dialects[3] = cpu_to_le16(SMB311_PROT_ID);
>      > -             req->DialectCount = cpu_to_le16(4);
>      > -             total_len += 8;
>      > -     } else {
>      > -             /* otherwise send specific dialect */
>      > -             req->Dialects[0] = cpu_to_le16(server->vals->protocol_id);
>      > -             req->DialectCount = cpu_to_le16(1);
>      > -             total_len += 2;
>      > -     }
>      > +     req->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
>      > +     memcpy(req->Dialects, server->vals->neg_dialects,
>      > +             sizeof(__le16) * server->vals->neg_dialect_cnt);
>      > +     total_len += sizeof(__le16) * server->vals->neg_dialect_cnt;
>      >
>      >       /* only one of SMB2 signing flags may be set in SMB2 request */
>      >       if (ses->sign)
>      > @@ -1145,34 +1128,11 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>      >       else
>      >               pneg_inbuf->SecurityMode = 0;
>      >
>      > -
>      > -     if (strcmp(server->vals->version_string,
>      > -             SMB3ANY_VERSION_STRING) == 0) {
>      > -             pneg_inbuf->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
>      > -             pneg_inbuf->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
>      > -             pneg_inbuf->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
>      > -             pneg_inbuf->DialectCount = cpu_to_le16(3);
>      > -             /* SMB 2.1 not included so subtract one dialect from len */
>      > -             inbuflen = sizeof(*pneg_inbuf) -
>      > -                             (sizeof(pneg_inbuf->Dialects[0]));
>      > -     } else if (strcmp(server->vals->version_string,
>      > -             SMBDEFAULT_VERSION_STRING) == 0) {
>      > -             pneg_inbuf->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
>      > -             pneg_inbuf->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
>      > -             pneg_inbuf->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
>      > -             pneg_inbuf->Dialects[3] = cpu_to_le16(SMB311_PROT_ID);
>      > -             pneg_inbuf->DialectCount = cpu_to_le16(4);
>      > -             /* structure is big enough for 4 dialects */
>      > -             inbuflen = sizeof(*pneg_inbuf);
>      > -     } else {
>      > -             /* otherwise specific dialect was requested */
>      > -             pneg_inbuf->Dialects[0] =
>      > -                     cpu_to_le16(server->vals->protocol_id);
>      > -             pneg_inbuf->DialectCount = cpu_to_le16(1);
>      > -             /* structure is big enough for 4 dialects, sending only 1 */
>      > -             inbuflen = sizeof(*pneg_inbuf) -
>      > -                             sizeof(pneg_inbuf->Dialects[0]) * 3;
>      > -     }
>      > +     pneg_inbuf->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
>      > +     memcpy(pneg_inbuf->Dialects, server->vals->neg_dialects,
>      > +             server->vals->neg_dialect_cnt * sizeof(__le16));
>      > +     inbuflen = offsetof(struct validate_negotiate_info_req, Dialects) +
>      > +             sizeof(pneg_inbuf->Dialects[0]) * server->vals->neg_dialect_cnt;
>      >
>      >       rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>      >               FSCTL_VALIDATE_NEGOTIATE_INFO,
> 
