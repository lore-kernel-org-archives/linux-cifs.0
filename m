From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC][PATCH 1/2] cifs: show enabled features in /proc
Date: Fri, 30 Jul 2010 16:59:31 +0530
Message-ID: <4C52B79B.2040203@suse.de>
References: <4C52A287.7020904@suse.de> <20100730070933.12ddc467@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Steve French (smfltc)" <smfltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100730070933.12ddc467-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/30/2010 04:39 PM, Jeff Layton wrote:
> On Fri, 30 Jul 2010 15:29:35 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> Based on the previous discussions and suggestion by Jeff on providing a way
>> to tell about compiled kernel config options, I wrote a simple patch. It seems
>> useful. But, feel free to ignore this patch if you think it is not..
>>
>> From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> Subject: [RFC][PATCH 1/2] cifs: show enabled features in /proc
>>
>> Here's a simple patch to show the compiled in CIFS features. This patch adds a
>> /proc file called "features" when read will show the features enabled in the
>> running kernel as shown below:
>>
>> 	$cat /proc/fs/cifs/features
>> 	# CIFS features enabled
>> 	dfs spnego fsc
>>
>> This provides a definitive way to tell what features are currently enabled.
>> This could be useful as a debugging information as well.
>>
> 
> Looks good. Now that I've given this more thought though...
> 
> I wonder if this would be better done as a new line near the beginning
> of /proc/fs/cifs/DebugData. Maybe:
> 
> Features: dfs spnego fsc
> 
> People often provide that info already when reporting bugs. We wouldn't
> need to ask for anything new that way.
> 

Good point. Makes it more simpler (no additional proc file needed).
Also,  we need to add xattr and posix as well?

I'll respin it in a while..

Thanks,

-- 
Suresh Jayaraman
