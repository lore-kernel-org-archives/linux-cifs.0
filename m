From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: Problem with mount.cifs in Fedora 19.
Date: Fri, 27 Mar 2015 11:39:01 -0700
Message-ID: <5515A3C5.40902@candelatech.com>
References: <551590DA.8040402@candelatech.com> <CAH2r5muXwqPT59Z7HDZ_3ua0yG2S50gHVdqtyXcC5LBQUOhtPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muXwqPT59Z7HDZ_3ua0yG2S50gHVdqtyXcC5LBQUOhtPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/27/2015 11:35 AM, Steve French wrote:
> There was the bug about SecurityFlags that Niklas Cassel's "fix MUST
> SecurityFlags filtering" patch addressed.  Does it work if you rename
> /sbin/mount.cifs to something else temporarily (so it goes straight to
> the kernel) and supply ip address on the mount instead of hostname (so
> you don't need the mount helper)

We are trying to set up a local system to reproduce the problem,
and will try this out there if we can.

Or, I'll try this on the customer system if we cannot reproduce it
locally.

Thanks for the suggestion.

Ben

> 
> On Fri, Mar 27, 2015 at 12:18 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
>> Hello!
>>
>> A user of our CIFS test gear reported a problem when testing against
>> a filer that is not using a password.
>>
>> A Fedora-14 machine has a mount.cifs on it that just mounts fine and does
>> not ask for password.
>>
>> But, Fedora 19's mount.cifs will ask for password (and fail the mount anyway
>> if you enter a blank password).
>>
>> Any idea what might be the issue?
>>
>> Thanks,
>> Ben
>>
>> --
>> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
