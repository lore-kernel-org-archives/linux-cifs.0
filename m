From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: Issue with upgrade to kernel 3.4.10 -> invalid argument error
Date: Wed, 17 Oct 2012 15:25:24 +0530
Message-ID: <507E808C.1020401@suse.com>
References: <507D934E.9010304@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <507D934E.9010304-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/16/2012 10:33 PM, Federico Sauter wrote:
> Greetings,
> 
> 
> I am having an issue mounting CIFS shares since we upgraded our Linux
> kernel from 2.6.27 to 3.4.10. Each time I try to mount a share drive I
> get an "Invalid argument" error message even though I am using the same
> command line that had previously worked, e.g.:
> 

A quick look suggests that the symptom is similar to the one fixed by
the below commit

commit e73f843a3235a19de38359c91586e9eadef12238
Author: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Date:   Tue Jun 12 07:15:50 2012 +0530

    cifs: fix parsing of password mount option


It might be worth trying to see whether the commit fixes the problem you
are seeing.


Thanks
Suresh
