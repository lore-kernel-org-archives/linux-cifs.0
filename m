Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254A9C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 18:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5E4761050
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 18:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhIVSkv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 14:40:51 -0400
Received: from p3plsmtpa06-06.prod.phx3.secureserver.net ([173.201.192.107]:36789
        "EHLO p3plsmtpa06-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhIVSkv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 14:40:51 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id T79LmIgKIwtkmT79Mmvp1F; Wed, 22 Sep 2021 11:39:20 -0700
X-CMAE-Analysis: v=2.4 cv=cdgXElPM c=1 sm=1 tr=0 ts=614b7858
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=SEc3moZ4AAAA:8 a=pGLkceISAAAA:8
 a=hGzw-44bAAAA:8 a=gu6fZOg2AAAA:8 a=rtncglnL9whs4254bVcA:9 a=QEXdDO2ut3YA:10
 a=-FEs8UIgK8oA:10 a=NWVoK91CQyQA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=5oRCH6oROnRZc2VpWJZ3:22 a=HvKuF1_PTVFglORKqfwH:22 a=2RSlZUUhi9gRBrsHwhhZ:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <890f7c14-b0b9-12e1-8d2e-e1ca5fb9c2d5@talpey.com>
 <CAKYAXd-FLBQ9hTmP6xPi2zNveD4nj3UNKPvGKHfGvba+11Kzqg@mail.gmail.com>
 <CAKYAXd8z7w_E7hCqhrCQnjdfPc_cx5apQkZfWjhaE3L3i3rDhA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <bc3311ce-6cf0-9e85-01ef-41520f66c1b0@talpey.com>
Date:   Wed, 22 Sep 2021 14:39:20 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAKYAXd8z7w_E7hCqhrCQnjdfPc_cx5apQkZfWjhaE3L3i3rDhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfHiAifbb2VFmYF0q3ZvR+5FUh/CYTAOl2RVKnYdGo1/pEJpFQQoI+cIc9eZd/YPWq98+Wz9YT3AvKi7tOtBK7ZPk4LcYlVKoL2K92KdavgviE1kki21r
 JxKDTD98MdEx/RifULJrOz35ZyX21YP3ghh7A/qaSf3AwBVoi0YyULxYPnwPuGsLf/HRNTV5N7jJIk+S5lGmJo961MtoA2sJNHrdZNosb4mgzm2osgXZC0AG
 aYOfyB5VBRoaS8lyWo4JPShM1Pnz95H9LTGbRLQj/YwRAExLQE4DslxM+DR4+yWIxeko5zxxXZ59zMhHCTN8bA==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/21/2021 11:40 PM, Namjae Jeon wrote:
> 2021-09-22 11:31 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
>> 2021-09-21 23:23 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 9/18/2021 10:13 PM, Namjae Jeon wrote:
>>>> Add buffer validation in smb2_set_info.
>>>>
>>>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>>>> Cc: Ralph Böhme <slow@samba.org>
>>>> Cc: Steve French <smfrench@gmail.com>
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    fs/ksmbd/smb2pdu.c | 113 +++++++++++++++++++++++++++++++++++----------
>>>>    fs/ksmbd/smb2pdu.h |   9 ++++
>>>>    2 files changed, 97 insertions(+), 25 deletions(-)
>>>>
>>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>>> index 46e0275a77a8..7763f69e1ae8 100644
>>>> --- a/fs/ksmbd/smb2pdu.c
>>>> +++ b/fs/ksmbd/smb2pdu.c
>>>> @@ -2107,17 +2107,23 @@ static noinline int create_smb2_pipe(struct
>>>> ksmbd_work *work)
>>>>     * smb2_set_ea() - handler for setting extended attributes using set
>>>>     *		info command
>>>>     * @eabuf:	set info command buffer
>>>> + * @buf_len:	set info command buffer length
>>>>     * @path:	dentry path for get ea
>>>>     *
>>>>     * Return:	0 on success, otherwise error
>>>>     */
>>>> -static int smb2_set_ea(struct smb2_ea_info *eabuf, struct path *path)
>>>> +static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int
>>>> buf_len,
>>>> +		       struct path *path)
>>>>    {
>>>>    	struct user_namespace *user_ns = mnt_user_ns(path->mnt);
>>>>    	char *attr_name = NULL, *value;
>>>>    	int rc = 0;
>>>>    	int next = 0;
>>>>
>>>> +	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
>>>> +			le16_to_cpu(eabuf->EaValueLength))
>>>> +		return -EINVAL;
>>>
>>> How certain is it that EaNameLength and EaValueLength are sane? One
>>> might imagine a forged packet with various combinations of invalid
>>> values, which arithmetically satisfy the above check...
>> Sorry, I didn't fully understand what you pointed out. Could you
>> please elaborate more ?
> 
> Maybe, You are saying we need the below check?
> @@ -2577,6 +2581,12 @@ int smb2_open(struct ksmbd_work *work)
>   			goto err_out1;
>   		} else if (context) {
>   			ea_buf = (struct create_ea_buf_req *)context;
> +			if (le16_to_cpu(context->DataOffset) +
> +			    le32_to_cpu(context->DataLength) <
> +			    sizeof(struct create_ea_buf_req)) {
> +				rc = -EINVAL;
> +				goto err_out1;
> +			}
> 
> This check is in create context patch.
> (https://marc.info/?l=linux-cifs&m=163227401430586&w=2)

Ah, yes something like that. I'll look over the other patch thanks.

Tom.
Tom.
