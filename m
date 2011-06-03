From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix the kernel release version in the default security
 warning message
Date: Fri, 03 Jun 2011 13:38:59 -0400
Message-ID: <4DE91C33.4040307@gmail.com>
References: <4DE880E3.8020502@suse.de>	<20110603091119.7596fade@corrin.poochiereds.net>	<4DE90669.5020108@suse.de> <20110603123739.4875a6e5@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110603123739.4875a6e5-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 6/3/2011 12:37 PM, Jeff Layton wrote:
> On Fri, 03 Jun 2011 21:36:01 +0530
> Suresh Jayaraman<sjayaraman-l3A5Bk7waGM@public.gmane.org>  wrote:
>
>> On 06/03/2011 06:41 PM, Jeff Layton wrote:
>>> On Fri, 03 Jun 2011 12:06:19 +0530
>>> Suresh Jayaraman<sjayaraman-l3A5Bk7waGM@public.gmane.org>  wrote:
>>>
>>>> When ntlm security mechanim is used, the message that warns about the upgrade
>>>> to ntlmv2 got the kernel release version wrong (Blame it on Linus :). Fix it.
>>>>
>>>> Signed-off-by: Suresh Jayaraman<sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>>> ---
>>>>   fs/cifs/connect.c |    2 +-
>>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>>> index 6d88b82..84c7307 100644
>>>> --- a/fs/cifs/connect.c
>>>> +++ b/fs/cifs/connect.c
>>>> @@ -1976,7 +1976,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>>>>   		warned_on_ntlm = true;
>>>>   		cERROR(1, "default security mechanism requested.  The default "
>>>>   			"security mechanism will be upgraded from ntlm to "
>>>> -			"ntlmv2 in kernel release 2.6.41");
>>>> +			"ntlmv2 in kernel release 3.1");
>>>>   	}
>>>>   	ses->overrideSecFlg = volume_info->secFlg;
>>>>
>>> Looks good. Though I'm not sure whether we should call it 3.1.0?
>>> Regardless...
>> I thought about this. But, as Linus has already said:
>>
>> "Now, my alpha-maleness sadly does not actually extend to all the
>> scripts and Makefile rules, so the kernel is fighting back, and is
>> calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle it
>> into submission, and get scripts etc cleaned up, and the final release
>> should be just "3.0". The -stable team can use the third number for
>> their versioning."
>>
>> I think 3.1 should be ok?
>>
> Pity -- would have been sort of nice to always use a 3 field version
> number since the stable kernels will need that, but...not my call.
> Either way, patch is fine.
I think 3.0 was being called 3.0.0 officially because some scripts broke 
without a "major.minor.revision" scheme.  At least for the moment, 
according to Linus' commit message.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=55922c9d1b84b89cb946c777fddccb3247e7df2c
