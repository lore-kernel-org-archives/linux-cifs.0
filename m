From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: question about CIFS client glitches
Date: Thu, 16 Sep 2010 18:53:51 -0400
Message-ID: <20100916185351.18b78690@tlielax.poochiereds.net>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
	<6.2.5.6.2.20100916184734.03a0f900@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6.2.5.6.2.20100916184734.03a0f900-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 16 Sep 2010 18:49:49 -0400
starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org wrote:

> At 05:39 PM 9/16/2010 -0400, starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org wrote:
> >Trying out a CIFS mount of a W2K8 x64 file system from CentOS 
> >5.5 and running into problems, and trying to figure out how to 
> >proceed.
> 
> Oops.  I see the problem is that CIFS, at least in the older 
> stable versions, does not support hard links.  The extracted 
> archives have a few of these and so the resulting tree is not a 
> synchronized copy of the original.
> 
> Oh well, so much for that.
> 

Ok, good to know. There were patches that went to mainline to make CIFS
support server inode numbers correctly, which is sort of a requirement
for proper hardlink support. Those were really too invasive for a minor
RHEL release however.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
