From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: Question on IPv6 failover.
Date: Thu, 03 Oct 2013 16:08:01 -0700
Message-ID: <524DF8D1.6000503@candelatech.com>
References: <524DDBF7.5050709@candelatech.com> <CAH2r5mtirrcvkqQho7QvMDJ8eZWGT5Q2S9w=GLKuGiwM1z29GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtirrcvkqQho7QvMDJ8eZWGT5Q2S9w=GLKuGiwM1z29GQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/03/2013 03:30 PM, Steve French wrote:
> On Thu, Oct 3, 2013 at 4:04 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
>> One of our users is reporting that the CIFS failover case is not working
>> properly.  They have a cluster of CIFS servers that migrate an IPv6 addr
>> to the active system.
>>
>> Evidently, our client-side CIFS connection follows the first migration,
>> but fails to go back to the original on a second failover.
>>
>> It could be any number of things, but I wanted first to see if anyone
>> knows how long client-side CIFS will keep attempting to regain contact with
>> it's
>> server?  Forever?
>>
>> Thanks,
>> Ben
>
> Depends on kernel version and also hard vs. soft (default) mount options.
>
> The "smb echo" approach that cifs moved to a few years ago allows
> the cifs kernel client to notice more quickly that the server is down,
> and significantly improved failover.
>
> Which kernel version?

3.7.10

The hard v/s soft is not being specified when mounting unless the
customer did something interesting, so I guess it is soft.

I'm still waiting on a network dump, so at this time I have no
reason to believe that Linux CIFS is actually to blame...just
trying to understand the possibilities better.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
