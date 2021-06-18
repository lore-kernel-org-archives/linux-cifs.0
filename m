Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7542DC48BDF
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 10:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47F88613C2
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 10:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhFRKSL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Jun 2021 06:18:11 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5401 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhFRKSK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Jun 2021 06:18:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5vr057Hyz711Z;
        Fri, 18 Jun 2021 18:12:48 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 18:15:54 +0800
Received: from [127.0.0.1] (10.174.179.0) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 18 Jun
 2021 18:15:53 +0800
Subject: Re: [PATCH 1/1] cifs: remove unnecessary oom message
To:     Steve French <smfrench@gmail.com>
CC:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
References: <20210617084122.1117-1-thunder.leizhen@huawei.com>
 <CAH2r5msQ4NKah88JOo4yX9jZtogLnfscULRtvbn21+aP=0x=jQ@mail.gmail.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <04b147c2-84bb-54a8-caca-d463a1fa917b@huawei.com>
Date:   Fri, 18 Jun 2021 18:15:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5msQ4NKah88JOo4yX9jZtogLnfscULRtvbn21+aP=0x=jQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



On 2021/6/18 12:09, Steve French wrote:
> I am curious the motivation for these - I agree that removing the
> debug messages saves (albeit trivial amount of) memory but curious
> about how other areas of the kernel handle logging low memory/out of
> memory issues?

$ scripts/checkpatch.pl --types=OOM_MESSAGE -- $(git ls-files kernel/) > err.txt
$ cat err.txt | grep WARNING | wc -l
12

$ git grep -wn k.alloc kernel/ | wc -l
469
$ git grep -wn kstrdup kernel/ | wc -l
88
... ... Other kernel memory allocation APIs are omitted.

You see, the vast majority are not printed.


> 
> On Thu, Jun 17, 2021 at 3:42 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>>
>> Fixes scripts/checkpatch.pl warning:
>> WARNING: Possible unnecessary 'out of memory' message
>>
>> Remove it can help us save a bit of memory.
>>
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>> ---
>>  fs/cifs/cifsencrypt.c | 4 +---
>>  fs/cifs/connect.c     | 6 +-----
>>  fs/cifs/sess.c        | 6 +-----
>>  fs/cifs/smb2pdu.c     | 2 --
>>  4 files changed, 3 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index b8f1ff9a83f3..74f16730e502 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -787,10 +787,8 @@ calc_seckey(struct cifs_ses *ses)
>>         get_random_bytes(sec_key, CIFS_SESS_KEY_SIZE);
>>
>>         ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
>> -       if (!ctx_arc4) {
>> -               cifs_dbg(VFS, "Could not allocate arc4 context\n");
>> +       if (!ctx_arc4)
>>                 return -ENOMEM;
>> -       }
>>
>>         arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
>>         arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 05f5c84a63a4..b52bb6dc6ecb 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -97,10 +97,8 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
>>         len = strlen(server->hostname) + 3;
>>
>>         unc = kmalloc(len, GFP_KERNEL);
>> -       if (!unc) {
>> -               cifs_dbg(FYI, "%s: failed to create UNC path\n", __func__);
>> +       if (!unc)
>>                 return -ENOMEM;
>> -       }
>>         scnprintf(unc, len, "\\\\%s", server->hostname);
>>
>>         rc = dns_resolve_server_name_to_ip(unc, &ipaddr);
>> @@ -1758,8 +1756,6 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
>>         if (is_domain && ses->domainName) {
>>                 ctx->domainname = kstrdup(ses->domainName, GFP_KERNEL);
>>                 if (!ctx->domainname) {
>> -                       cifs_dbg(FYI, "Unable to allocate %zd bytes for domain\n",
>> -                                len);
>>                         rc = -ENOMEM;
>>                         kfree(ctx->username);
>>                         ctx->username = NULL;
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index cd19aa11f27e..cc97b2981c3d 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -602,10 +602,8 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>>         if (tilen) {
>>                 ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
>>                                                  GFP_KERNEL);
>> -               if (!ses->auth_key.response) {
>> -                       cifs_dbg(VFS, "Challenge target info alloc failure\n");
>> +               if (!ses->auth_key.response)
>>                         return -ENOMEM;
>> -               }
>>                 ses->auth_key.len = tilen;
>>         }
>>
>> @@ -1338,8 +1336,6 @@ sess_auth_kerberos(struct sess_data *sess_data)
>>         ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
>>                                          GFP_KERNEL);
>>         if (!ses->auth_key.response) {
>> -               cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory\n",
>> -                        msg->sesskey_len);
>>                 rc = -ENOMEM;
>>                 goto out_put_spnego_key;
>>         }
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index c205f93e0a10..2b978564e188 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -1355,8 +1355,6 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
>>                 ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
>>                                                  GFP_KERNEL);
>>                 if (!ses->auth_key.response) {
>> -                       cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory\n",
>> -                                msg->sesskey_len);
>>                         rc = -ENOMEM;
>>                         goto out_put_spnego_key;
>>                 }
>> --
>> 2.25.1
>>
>>
> 
> 

