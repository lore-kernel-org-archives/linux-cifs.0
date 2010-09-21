From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: kernel crash using smb2
Date: Mon, 20 Sep 2010 20:11:31 -0700
Message-ID: <4C982263.2090801@candelatech.com>
References: <4C97D749.7080608@candelatech.com> <AANLkTimetcDb9QrbG-0AvbR_Y8RZUwXJjW=6wb1Aki11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimetcDb9QrbG-0AvbR_Y8RZUwXJjW=6wb1Aki11-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/20/2010 06:39 PM, Steve French wrote:
> Strange that it reports ext4 symbols in the oops ... but it is possible.

It looks like memory corruption (maybe use-after-free), buffer overrun,
or similar.  Could be anywhere..but suspicious it happened during
smb2 run.

If I get a chance, I can try to turn on memory debugging in the kernel
and see if it shows up anything, but likely will be a few days.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
