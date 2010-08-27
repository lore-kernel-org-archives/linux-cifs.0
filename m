From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: [cifs bindaddr v2] cifs: Allow binding to local IP address.
Date: Fri, 27 Aug 2010 10:12:16 -0700
Message-ID: <4C77F1F0.4070800@candelatech.com>
References: <1282844096-13295-1-git-send-email-greearb@candelatech.com>	<AANLkTik4Cffnr0ciYAVXz_jb_=EG5kBaKNE3V3cNVtwf@mail.gmail.com>	<4C777615.2080109@erion.co.uk>	<AANLkTi=9xBr2gABJSUSk2DMJEYho+jA3rbCk1PSfuQQ5@mail.gmail.com>	<20100827095433.26bb3c3e@corrin.poochiereds.net>	<4C77D9ED.4050101@candelatech.com>	<20100827125242.0798ffe9@tlielax.poochiereds.net> <AANLkTim-Hsn77fJUR1TrM_szVaJ3_vYzw61j0GYMt+Rr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim-Hsn77fJUR1TrM_szVaJ3_vYzw61j0GYMt+Rr-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/27/2010 10:08 AM, Steve French wrote:
> On Fri, Aug 27, 2010 at 11:52 AM, Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>  wrote:
>> On Fri, 27 Aug 2010 08:29:49 -0700
>> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
>>
>>> On 08/27/2010 06:54 AM, Jeff Layton wrote:
>>>
>>>>> Also, I think bindaddr might not be the best name for the option. How
>>>>> about sourceaddr or srcaddr?
>>>>>
>>>>
>>>> Sounds reasonable.
>>>
>>> It doesn't matter to me.  Please tell me which one you want me to use
>>> and I'll work on re-spinning this patch with ipv6 support.
>>>
>>> Thanks,
>>> Ben
>>>
>>
>> My preference would be "srcaddr=".
>
> Shorter is good ...
> srcaddr wins unless we have a particular compatibility objective with
> other fs mounts (ie an existing mount option - which so far I have not
> been able to find).
>
> For completeness we should consider, at least briefly, one alternative name.
> Note that smb.conf (and thus smbclient indirectly uses this) can
> override the local interface using the optional smb.conf parm
> "interfaces" - we could shorten this to "interface"   If anyone feels
> strongly about this being better ...

I don't like that, as we're binding to IPs, not interfaces.

If we ever need to support SO_BINDTODEV logic, then could
use interface= for that.

srcaddr= sounds fine to me.

Thanks,
Ben

>
>


-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
