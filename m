Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C630C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 17:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A4FF217F5
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 17:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551290050;
	bh=kspwMt9uaWNH65FXb/F0LswvVhq/mPDrL03nKO/y62o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=T4K+M9pdAdoBr7eFj6LkYsTau6HULujvVBCocq6nAXFAsGzH2tJc9o7H/xF2BS49y
	 WcVSB74g0YDPRVnhmv4HNVTCcPKdNJFnq2lwa2uPWxi2o8u+gijd7F1clPZDVZsdtl
	 Oi0Vxac9Lb8BRsDKv894ZIyCyccfcXn5LPM58Z0g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfB0RyJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:54:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfB0RyJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 27 Feb 2019 12:54:09 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F829217F5;
        Wed, 27 Feb 2019 17:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551290048;
        bh=kspwMt9uaWNH65FXb/F0LswvVhq/mPDrL03nKO/y62o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P+/QarotcjOYrS1c5ACqk5a4yTg3rH4ARtRNlldK5a8IdtKcn7Qe6an75N+hubHCW
         7DMJzyNcOmZQZ7DF3YIlMidZpbHJjEHGw3UwBlSP23cfmy3mD+BxgyaE3kuusXh/sp
         D9akQN8CkirNA2A573NTy0XWo2ZANDD54sP4AbwA=
Date:   Wed, 27 Feb 2019 12:54:06 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Shilovskiy <pshilov@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Steven French <Steven.French@microsoft.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.20 65/77] CIFS: Do not assume one credit for
 async responses
Message-ID: <20190227175406.GM10616@sasha-vm>
References: <20190215020855.176727-1-sashal@kernel.org>
 <20190215020855.176727-65-sashal@kernel.org>
 <DM5PR21MB0140327178FA380F6D7DCAC5B6600@DM5PR21MB0140.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM5PR21MB0140327178FA380F6D7DCAC5B6600@DM5PR21MB0140.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Feb 15, 2019 at 08:10:47PM +0000, Pavel Shilovskiy wrote:
>чт, 14 февр. 2019 г. в 18:40, Sasha Levin <sashal@kernel.org>:
>>
>> From: Pavel Shilovsky <pshilov@microsoft.com>
>>
>> [ Upstream commit 0fd1d37b0501efc6e295f56ab55cdaff784aa50c ]
>>
>> If we don't receive a response we can't assume that the server
>> granted one credit. Assume zero credits in such cases.
>>
>> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
>> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>> Signed-off-by: Steve French <stfrench@microsoft.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  fs/cifs/smb2pdu.c | 15 +++++++++++----
>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index d1ae7cdb236d..3c44c51310c4 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -2834,9 +2834,10 @@ smb2_echo_callback(struct mid_q_entry *mid)
>>  {
>>         struct TCP_Server_Info *server = mid->callback_data;
>>         struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)mid->resp_buf;
>> -       unsigned int credits_received = 1;
>> +       unsigned int credits_received = 0;
>>
>> -       if (mid->mid_state == MID_RESPONSE_RECEIVED)
>> +       if (mid->mid_state == MID_RESPONSE_RECEIVED
>> +           || mid->mid_state == MID_RESPONSE_MALFORMED)
>>                 credits_received = le16_to_cpu(rsp->sync_hdr.CreditRequest);
>>
>>         DeleteMidQEntry(mid);
>> @@ -3093,7 +3094,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
>>         struct TCP_Server_Info *server = tcon->ses->server;
>>         struct smb2_sync_hdr *shdr =
>>                                 (struct smb2_sync_hdr *)rdata->iov[0].iov_base;
>> -       unsigned int credits_received = 1;
>> +       unsigned int credits_received = 0;
>>         struct smb_rqst rqst = { .rq_iov = rdata->iov,
>>                                  .rq_nvec = 2,
>>                                  .rq_pages = rdata->pages,
>> @@ -3132,6 +3133,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
>>                 task_io_account_read(rdata->got_bytes);
>>                 cifs_stats_bytes_read(tcon, rdata->got_bytes);
>>                 break;
>> +       case MID_RESPONSE_MALFORMED:
>> +               credits_received = le16_to_cpu(shdr->CreditRequest);
>> +               /* fall through */
>>         default:
>>                 if (rdata->result != -ENODATA)
>>                         rdata->result = -EIO;
>> @@ -3325,7 +3329,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
>>         struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
>>         unsigned int written;
>>         struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)mid->resp_buf;
>> -       unsigned int credits_received = 1;
>> +       unsigned int credits_received = 0;
>>
>>         switch (mid->mid_state) {
>>         case MID_RESPONSE_RECEIVED:
>> @@ -3353,6 +3357,9 @@ smb2_writev_callback(struct mid_q_entry *mid)
>>         case MID_RETRY_NEEDED:
>>                 wdata->result = -EAGAIN;
>>                 break;
>> +       case MID_RESPONSE_MALFORMED:
>> +               credits_received = le16_to_cpu(rsp->sync_hdr.CreditRequest);
>> +               /* fall through */
>>         default:
>>                 wdata->result = -EIO;
>>                 break;
>> --
>> 2.19.1
>>
>
>Can you also apply the following patch to 4.20.y and 4.19.y, please?
>
>https://patchwork.ozlabs.org/patch/1030180/

I'll queue it up for the next cycle as it has dependencies on stable@
commits that didn't make it in yet and I don't want to mess up with
Greg's flow. Thanks you!

--
Thanks,
Sasha
