Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90F2C433ED
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 15:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1D56103E
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 15:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhEHPVg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 May 2021 11:21:36 -0400
Received: from p3plsmtpa08-04.prod.phx3.secureserver.net ([173.201.193.105]:54550
        "EHLO p3plsmtpa08-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhEHPVf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 May 2021 11:21:35 -0400
Received: from [192.168.0.100] ([96.237.161.203])
        by :SMTPAUTH: with ESMTPSA
        id fOkplbN9BnpL4fOkqlRUuS; Sat, 08 May 2021 08:20:33 -0700
X-CMAE-Analysis: v=2.4 cv=WJa64lgR c=1 sm=1 tr=0 ts=6096ac41
 a=Pd5wr8UCr3ug+LLuBLYm7w==:117 a=Pd5wr8UCr3ug+LLuBLYm7w==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=45oDioVVcz2Hi71EmKkA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH][SMB3] 3 small multichannel client patches
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
 <98a3e99b-3d2e-0480-55db-f843c7016351@talpey.com>
 <CAH2r5ms-f7YRxeOHPQnGn_+n5dVaCE-WHzfNAstvLjT2HcfhDw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <b54ad9a9-c145-639c-ef3c-c603988e41d4@talpey.com>
Date:   Sat, 8 May 2021 11:20:31 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5ms-f7YRxeOHPQnGn_+n5dVaCE-WHzfNAstvLjT2HcfhDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfA0NaNRrsEd8Og+wjeHdrf2RnIk7B39E4ptTKN2uDM5HAIiMMLvY8CJeb5Xpxr6ZASr93orzTzsM8/2U0E7vEUIt6EQtFts3z0CA7oGnCTiCxpbgrL6c
 zYvmHuoknyEffLgu/On5BOj8EchIgoKRpOXQY3BKyrLphQgP5fFU327y48bjpQncoZX05kcIhsJhqMKtGPiJGfrgATWkYmhTQ98bIWV0nyzxMMWd76V5BRb2
 s5ooXPLj+2mad4dcxABDcalmmR2iwNUjW8/YslBKzyUbaWzNAviYJWFBg7r1Bggf
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

LGTM

Reviewed-By: Tom Talpey <tom@talpey.com>

On 5/8/2021 11:10 AM, Steve French wrote:
> On Sat, May 8, 2021 at 8:29 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 5/7/2021 9:13 PM, Steve French wrote:
>>> 1) we were not setting CAP_MULTICHANNEL on negotiate request
>>
>>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>>> index e36c2a867783..a8bf43184773 100644
>>> --- a/fs/cifs/smb2pdu.c
>>> +++ b/fs/cifs/smb2pdu.c
>>> @@ -841,6 +841,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>>>                req->SecurityMode = 0;
>>>
>>>        req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
>>> +     if (ses->chan_max > 1)
>>> +             req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
>>>
>>>        /* ClientGUID must be zero for SMB2.02 dialect */
>>>        if (server->vals->protocol_id == SMB20_PROT_ID)
>>> @@ -1032,6 +1034,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>>>
>>>        pneg_inbuf->Capabilities =
>>>                        cpu_to_le32(server->vals->req_capabilities);
>>> +     if (tcon->ses->chan_max > 1)
>>> +             pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
>>> +
>>
>> This doesn't look quite right, and it can lead to failed negotiate by
>> setting CAP_MULTI_CHANNEL when the server didn't actually send the bit.
>> Have you tested this with servers that don't do multichannel?
> 
> Yes.   Validate negotiate ioctl request is supposed to validate what
> the client sent not what the server responded, so according to
> MS-SMB2, I must send in the ioctl what I sent before on negprot
> request
> 
> Section 3.2.5.5 says for validate negotiate "Capabilities is set to
> Connection.ClientCapabilities."  where
> "Connection.ClientCapabilities: The capabilities sent by the client in
> the SMB2 NEGOTIATE Request"   (not what the server responded with,
> what the ClientCapabilities were sent)
> 
> I tested it with two cases that don't support multichannel: Samba, and
> also an azure server target where multichannel was disabled.
> 
> 
>>
>>> 2) we were ignoring whether the server set CAP_NEGOTIATE in the response
>>
>> Is this "CAP_NEGOTIATE" a typo? I think you mean CAP_MULTI_CHANNEL.
> 
> Yes - typo
> 
>>
>>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>>> index 63d517b9f2ff..a391ca3166f3 100644
>>> --- a/fs/cifs/sess.c
>>> +++ b/fs/cifs/sess.c
>>> @@ -97,6 +97,12 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
>>>                return 0;
>>>        }
>>>
>>> +     if ((ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) == false) {
>>
>> This compares a bit to a boolean. "false" should be "0"?
> 
> I changed it to the more common style  if (!(ses->...capabilities & SMB@....))
>>
>>> +             cifs_dbg(VFS, "server does not support CAP_MULTI_CHANNEL, multichannel disabled\n");
>>
>> The wording could be clearer. Technically speaking, the server does not
>> support _multichannel_, which it indicated by not setting CAP_MULTI_CHANNEL.
>> Also, wouldn't it be more useful to add the servername to this message?
>>          "server %s does not support multichannel, using single channel"
>> or similar.
> 
> Good idea
> 
>>> 3) we were silently ignoring multichannel when "max_channels" was > 1
>>> but the user forgot to include "multichannel" in mount line.
>>
>>   > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
>>   > index 3bcf881c3ae9..8f7af6fcdc76 100644
>>   > --- a/fs/cifs/fs_context.c
>>   > +++ b/fs/cifs/fs_context.c
>>   > @@ -1021,6 +1021,9 @@ static int smb3_fs_context_parse_param(struct
>> fs_context *fc,
>>   >                      goto cifs_parse_mount_err;
>>   >              }
>>   >              ctx->max_channels = result.uint_32;
>>   > +            /* If more than one channel requested ... they want multichan */
>>   > +            if ((ctx->multichannel == false) && (result.uint_32 > 1))
>>   > +                    ctx->multichannel = true;
>>
>> Wouldn't this be clearer and simpler as just "if (result.uint32 > 1)" ?
> 
> made that change
> 
> Updated two of the patches as described above - attached.
> 
