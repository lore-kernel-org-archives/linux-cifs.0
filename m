From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Strange hardlink behavior with CIFS
Date: Tue, 19 Oct 2010 15:13:31 +0530
Message-ID: <4CBD6843.3060702@suse.de>
References: <1287428685.16450.282.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287428685.16450.282.camel@calx>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/19/2010 12:34 AM, Matt Mackall wrote:
> With Linux 2.6.32-35 and either Windows or Samba in nounix mode,
> hardlink counts can mysteriously disappear:
> 
> - create hardlink pair foo,bar
> - stat foo -> nlink = 2
> - open foo
> - stat foo -> nlink = 1
> - close
> - wait or sync
> - ls -l -> nlink = 2
> 
> Original report is here:
> 
> http://mercurial.selenic.com/bts/issue1866
> 

A quick test on 2.6.36-rc4 kernel reveals that the problem is no longer
reproducible. Could you try a more recent kernel and see whether the
problem is reproducible?


Thanks,

-- 
Suresh Jayaraman
