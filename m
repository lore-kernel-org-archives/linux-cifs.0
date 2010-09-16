From: starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org
Subject: Re: question about CIFS client glitches
Date: Thu, 16 Sep 2010 18:49:49 -0400
Message-ID: <6.2.5.6.2.20100916184734.03a0f900@binnacle.cx>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6.2.5.6.2.20100916171408.03a0fcd8-8QzAbx0zao2B+jHODAdFcQ@public.gmane.org>
References: <6.2.5.6.2.20100916171408.03a0fcd8-8QzAbx0zao2B+jHODAdFcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

At 05:39 PM 9/16/2010 -0400, starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org wrote:
>Trying out a CIFS mount of a W2K8 x64 file system from CentOS 
>5.5 and running into problems, and trying to figure out how to 
>proceed.

Oops.  I see the problem is that CIFS, at least in the older 
stable versions, does not support hard links.  The extracted 
archives have a few of these and so the resulting tree is not a 
synchronized copy of the original.

Oh well, so much for that.
