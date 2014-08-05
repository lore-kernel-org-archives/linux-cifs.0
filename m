From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: DFS root namespace mounting problem...
Date: Tue, 05 Aug 2014 18:16:00 +0200
Message-ID: <1407255360.4226.1.camel@hh16.hh3.site>
References: <44E091A70C02494A806AD35E6F93AB1A32B89B@HOSMAIL2B.ho.pfgroup.provfin.com>
	 <1407248098.1426.7.camel@hh16.hh3.site>
	 <44E091A70C02494A806AD35E6F93AB1A32B89C@HOSMAIL2B.ho.pfgroup.provfin.com>
	 <1407251579.2941.8.camel@hh16.hh3.site>
	 <44E091A70C02494A806AD35E6F93AB1A32B89D@HOSMAIL2B.ho.pfgroup.provfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "McCall, Andy (IT.PFMS)" <Andy.McCall-JGeVbDYbwmjRZ1oM81ef8Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <44E091A70C02494A806AD35E6F93AB1A32B89D-44HqyMtr/CW7efwRAOVE6/PBkhW9OzgPksZubNBzXmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2014-08-05 at 16:22 +0100, McCall, Andy (IT.PFMS) wrote:
> >> I've just swapped /usr/sbin/cifs.upcall out for a script that echo's 
> >> test to /tmp/text.txt and cifs.upcall isn't actually being called at all in my case.
> >
> >You may already have a ticket.
> 
> It might be that the test of swapping out cifs.upcall for a script won't work, but
> I tried it on a second identical build server on the farm that hasn't been touched
> yet and that also didn't produce /tmp/text.txt, so either the test is invalid or
> cifs.upcall isn't getting called.

Is this the problem:
//fqdn/share
mounts OK, but
//domain/share
doesn't.
