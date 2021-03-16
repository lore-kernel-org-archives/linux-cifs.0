Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDD1C433E6
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Mar 2021 19:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7905864FE4
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Mar 2021 19:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240459AbhCPT3o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Mar 2021 15:29:44 -0400
Received: from p3plsmtpa06-02.prod.phx3.secureserver.net ([173.201.192.103]:36992
        "EHLO p3plsmtpa06-02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240456AbhCPT3l (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Mar 2021 15:29:41 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id MFNplOVBiBt9YMFNqlPnBL; Tue, 16 Mar 2021 12:29:38 -0700
X-CMAE-Analysis: v=2.4 cv=C/0sdSD+ c=1 sm=1 tr=0 ts=60510723
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=3-RhneuVAAAA:8 a=ihd_uDuFnh7xnqKYafAA:9
 a=QEXdDO2ut3YA:10 a=5oRCH6oROnRZc2VpWJZ3:22 a=VLVLkjT_5ZicWzSuYqSo:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v2] cifs: Silently ignore unknown oplock break handle
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>, kernel@axis.com,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
References: <20210316124808.11984-1-vincent.whitchurch@axis.com>
 <93d506a6-5832-5006-3bab-6e8e7203da0e@talpey.com>
 <CACdtm0ac+oE1+KNbOGWhy-j9XHmUn4AXG6zAaX-nL0W=NJxQMA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <4836330b-3d2f-9d35-4d03-3a457b0068a4@talpey.com>
Date:   Tue, 16 Mar 2021 15:29:38 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CACdtm0ac+oE1+KNbOGWhy-j9XHmUn4AXG6zAaX-nL0W=NJxQMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfH6b3PF8QhOqJznv110kIMK+CLaMTn7+5O8zIx0dZa9FNVemvhe0/KfPSyC510OhKOT9JghaMrb3qjtoVCjYAbpoOKhULCOq4cAsrLRbuKdXuHRyeyuA
 rWj1QAdjnkSU1QN18U2+Insf4dP+C0yHalejORzzgacQEAKJgsg1VI0+mS9mUCnM81Gv6Eb2Zz0cf318OBRDEOlKClrzutpWnHcjZQCtjcwAsifRoSld21to
 CBxGGxyfajqvxaB6jK2FcXl9Unqc9fmvODToXzyEt70KolifOWp5ynQ6jSFY5mky0cUf5XJiM0fpCa5k9PfzsIl5WxpLRnTpGt675sBCTomtbmMrPJaBCBZp
 /aismpvUmDzumrOQkNOU09rvy0ea6/apTwWrKclr9yEbmsU5RSFs5nWWZ1J4oHDwQUNbcSoG
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/16/2021 1:36 PM, Rohith Surabattula wrote:
> This issue will not be seen once changes related to deferred close for
> files is committed.

That may be, but it's irrelevant to this.

> Currently, changes are in review. I will address review comments by this week.

What do you mean by "in review"? Both threads are active on the
mailing list. If you or others have something to discuss, please
post it and don't leave us out of the discussion.

Tom.


> Regards,
> Rohith
> 
> On Tue, Mar 16, 2021 at 9:33 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 3/16/2021 8:48 AM, Vincent Whitchurch via samba-technical wrote:
>>> Make SMB2 not print out an error when an oplock break is received for an
>>> unknown handle, similar to SMB1.  The SMB2 lease break path is not
>>> affected by this patch.
>>>
>>> Without this, a program which writes to a file from one thread, and
>>> opens, reads, and writes the same file from another thread triggers the
>>> below errors several times a minute when run against a Samba server
>>> configured with "smb2 leases = no".
>>>
>>>    CIFS: VFS: \\192.168.0.1 No task to wake, unknown frame received! NumMids 2
>>>    00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
>>>    00000010: 00000001 00000000 ffffffff ffffffff  ................
>>>    00000020: 00000000 00000000 00000000 00000000  ................
>>>    00000030: 00000000 00000000 00000000 00000000  ................
>>>
>>> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
>>> ---
>>>
>>> Notes:
>>>       v2:
>>>       - Drop change to lease break
>>>       - Rewrite commit message
>>>
>>>    fs/cifs/smb2misc.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>>> index 60d4bd1eae2b..4d8576e202e3 100644
>>> --- a/fs/cifs/smb2misc.c
>>> +++ b/fs/cifs/smb2misc.c
>>> @@ -755,7 +755,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>>>        }
>>>        spin_unlock(&cifs_tcp_ses_lock);
>>>        cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
>>> -     return false;
>>> +     return true;
>>>    }
>>>
>>>    void
>>>
>>
>> As an oplock-only approach, it looks good. But the old cifs_dbg message
>> "non-existent connection" is possibly misleading, since the connection
>> may be perfectly fine.
>>
>> When breaking the loop successfully, the code emits
>>          cifs_dbg(FYI, "file id match, oplock break\n");
>> so perhaps
>>          cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
>> ?
>>
>> Tom.
> 
