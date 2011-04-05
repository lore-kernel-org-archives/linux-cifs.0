From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: Repeatable crash in 2.6.38 related to O_DIRECT
Date: Tue, 05 Apr 2011 16:34:17 -0700
Message-ID: <4D9BA6F9.1050207@candelatech.com>
References: <4D9B9BB0.3030604@candelatech.com> <20110405162609.6776e264@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110405162609.6776e264-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 04/05/2011 04:26 PM, Jeff Layton wrote:

> Does the attached patch fix it? It's probably stable material if so...

I'll test your patch.  I verified that cifs_file is NULL in cifsFileInfo_put
and protecting against that also solves the problem.

>
> FWIW, cifs doesn't handle O_DIRECT at all.

I know..and I warn my users when the open() call fails, but I still
let them attempt the file open.  Seems a decent test case after all :)

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
