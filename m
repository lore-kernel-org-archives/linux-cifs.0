From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: kernel crash using smb2
Date: Mon, 20 Sep 2010 15:22:20 -0700
Message-ID: <4C97DE9C.4030704@candelatech.com>
References: <4C97D749.7080608@candelatech.com> <20100920151825.37c22f1a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100920151825.37c22f1a-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/20/2010 03:18 PM, Jeff Layton wrote:
> On Mon, 20 Sep 2010 14:51:05 -0700
> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:

>> Fixing recursive fault but reboot is needed!
>>
>
> It looks unrelated to SMB2. Looks like more of a problem with ext4 or
> maybe something in CFQ code. You might want to report it on LKML,
> particularly if there is a way to reproduce it on recent mainline
> kernels.

Maybe, but happened right after I started smb.  Has anyone
done any serious file-io testing with smb2?

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
