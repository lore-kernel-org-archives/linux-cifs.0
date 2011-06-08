From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS VFS errors
Date: Wed, 8 Jun 2011 16:44:15 -0400
Message-ID: <20110608164415.5b8cbf4b@tlielax.poochiereds.net>
References: <4BEC36376CA24EBFAA83C16B955BD9CC@dynamicsourcemfg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BEC36376CA24EBFAA83C16B955BD9CC-WkVietXGWdS4IGBGpn4MSbjjLBE8jN/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 8 Jun 2011 13:56:10 -0600
"Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:

> Hi Jeff,
> 
>  
> 
> I had tried to send out the below message last week.  It never bounced.  Not
> sure if anyone got it.  I could really use some help.
> 
>  

Nope, never saw it. Maybe kernel.org spam filtering ate it?

>  
> 
>   _____  
> 
> From: Shane McColman [mailto:smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org] 
> Sent: Thursday, June 02, 2011 9:06 AM
> To: 'linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'
> Subject: CIFS VFS errors
> 
>  
> 
> First some background:
> 
>  
> 
> I'm using CIFS on Debian 6.0.1 with kernel 2.6.32-5-amd64
> 
>  
> 
> I've mounted a shared folder from a windows XP home machine that contains
> over 4000 files and over 2000 directories.  This machine is the file
> repository for a group of equipment we have on our factory floor.  This
> system is supplied by the manufacturer of the equipment, so it cannot be
> easily changed.  I could back up the files and folders to reduce the size of
> the directory, but outside of that I'm stuck with it as is.
> 
>  
> 
> I've written some code that monitors the directory and looks for new log
> files being created, whenever a new file is created it starts up a new
> thread that monitors the file for modifications and then parses the
> modifications into a database.  At the end of each month these log files
> will be not be modified anymore so after the clock rolls over on the first
> of the month all the active threads are shutdown and new ones started as new
> files are added.  Usually by the end of month there are about 300 threads
> running.  
> 
>  
> 
> The problem:
> 
>  
> 
> By about mid month I starting getting errors every 15 sec that look like
> this (/var/log/kern.log)
> 
>  
> 
> May 31 23:59:40 fujimoto kernel: [921847.411084]  CIFS VFS: No response for
> cmd 50 mid 30108
> 
> May 31 23:59:40 fujimoto kernel: [921847.411183]  CIFS VFS: No response for
> cmd 50 mid 30317
> 
> May 31 23:59:40 fujimoto kernel: [921847.411188]  CIFS VFS: No response for
> cmd 50 mid 30265
> 
> May 31 23:59:40 fujimoto kernel: [921847.411191]  CIFS VFS: Send error in
> SessSetup = -11
> 
> May 31 23:59:40 fujimoto kernel: [921847.411343]  CIFS VFS: No response for
> cmd 50 mid 30313
> 
> May 31 23:59:40 fujimoto kernel: [921847.411834]  CIFS VFS: Send error in
> SessSetup = -11
> 
> May 31 23:59:40 fujimoto kernel: [921847.411893]  CIFS VFS: Send error in
> SessSetup = -11
> 
> May 31 23:59:40 fujimoto kernel: [921847.411951]  CIFS VFS: Send error in
> SessSetup = -11
> 
> May 31 23:59:40 fujimoto kernel: [921847.412003]  CIFS VFS: Send error in
> SessSetup = -11
> 
> May 31 23:59:40 fujimoto kernel: [921847.415091]  CIFS VFS: No response for
> cmd 50 mid 30119
> 
> May 31 23:59:40 fujimoto kernel: [921847.415115]  CIFS VFS: No response for
> cmd 50 mid 30250
> 
>  
> 
> There are a lot more (log file grows by 25M a day) but this is a good
> sample.  I first noticed this because I was getting file IO errors with my
> script and since then have rewritten my code to copy the file to the server
> before parsing and added error handling into my code so that it will try 10
> times if unsuccessful.  By month end it was taking 3 to 4 attempts to copy
> files that were each under 250K.  
> 
>  
> 
> As we rolled into June and the threads were shut down the errors are much
> less
> 
>  
> 
> Jun  1 04:15:29 fujimoto kernel: [937168.611757]  CIFS VFS: No response for
> cmd 114 mid 7014
> 
> Jun  1 04:15:30 fujimoto kernel: [937169.756306]  CIFS VFS: No response for
> cmd 114 mid 7015
> 
> Jun  1 04:15:31 fujimoto kernel: [937170.763869]  CIFS VFS: No response for
> cmd 114 mid 7016
> 
> Jun  1 04:15:36 fujimoto kernel: [937175.822892]  CIFS VFS: Unexpected
> lookup error -112
> 
> Jun  1 04:15:37 fujimoto kernel: [937177.028741]  CIFS VFS: No response for
> cmd 114 mid 7022
> 
> Jun  1 04:15:38 fujimoto kernel: [937178.038878]  CIFS VFS: No response for
> cmd 114 mid 7023
> 
> Jun  1 04:15:38 fujimoto kernel: [937178.038886]  CIFS VFS: Unexpected
> lookup error -112
> 
> Jun  1 04:15:53 fujimoto kernel: [937193.012420]  CIFS VFS: No response for
> cmd 114 mid 7024
> 
> Jun  1 04:15:53 fujimoto kernel: [937193.012436]  CIFS VFS: Unexpected
> lookup error -112
> 
> Jun  1 04:16:03 fujimoto kernel: [937202.994543]  CIFS VFS: Unexpected
> lookup error -112
> 
> Jun  1 04:16:13 fujimoto kernel: [937212.976749]  CIFS VFS: Unexpected
> lookup error -112
> 
> Jun  1 04:50:12 fujimoto kernel: [939247.838590]  CIFS VFS: No response for
> cmd 50 mid 50347
> 
> Jun  1 04:50:13 fujimoto kernel: [939248.988539]  CIFS VFS: No response for
> cmd 50 mid 50348
> 
> Jun  1 10:54:00 fujimoto kernel: [961037.316672]  CIFS VFS: No response for
> cmd 114 mid 19781
> 
> Jun  1 10:54:01 fujimoto kernel: [961038.326872]  CIFS VFS: No response for
> cmd 114 mid 19782
> 
> Jun  1 10:54:02 fujimoto kernel: [961039.337069]  CIFS VFS: No response for
> cmd 114 mid 19783
> 
>  
> 
> My first question is "Is this a configuration error?" and if so can someone
> give me some advice.
> 
>  

No, probably not a config error. Those errors basically indicate that
the server just wasn't responding in a timely fashion. There has been a
lot of work in this area over the last couple of kernel releases -- we
only time out calls now when the server stops responding to SMB echo
requests. You may want to try something 2.6.39-ish.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
