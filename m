From: "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Subject: RE: CIFS VFS errors
Date: Thu, 23 Jun 2011 08:09:48 -0600
Message-ID: <6753F891F47C4E9CBDFB66A63A8E1367@dynamicsourcemfg.local>
References: <4BEC36376CA24EBFAA83C16B955BD9CC@dynamicsourcemfg.local><20110608164415.5b8cbf4b@tlielax.poochiereds.net><7A5FF1B06368450BAE39549CE3C621CF@dynamicsourcemfg.local> <20110622163251.16499f4b@tlielax.poochiereds.net> <AC93F84448C9430AB4B791EE591F2F97@dynamicsourcemfg.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AC93F84448C9430AB4B791EE591F2F97-WkVietXGWdS4IGBGpn4MSbjjLBE8jN/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Adding wsize to fstab did not work.  I restarted things at 4:15 yesterday
and in less than hour I was back to the same place.


Jun 22 16:15:14 fujimoto kernel: [629641.354375] CIFS VFS: Unexpected lookup
error -112
Jun 22 16:15:14 fujimoto kernel: [629641.354383] CIFS VFS: Unexpected lookup
error -112
Jun 22 17:08:42 fujimoto kernel: [632843.214260] CIFS VFS: Autodisabling the
use of server inode numbers on \\d7gsjxb1\AOI_1 (F). This server doesn't
seem to support them properly. Hardlinks will not be recognized on this
mount. Consider mounting with the "noserverino" option to silence this
message.
Jun 22 17:18:11 fujimoto kernel: [633411.476667] CIFS VFS: Send error in
read = -11
Jun 22 17:21:11 fujimoto kernel: [633590.919038] CIFS VFS: Send error in
read = -11
Jun 22 17:23:11 fujimoto kernel: [633710.706852] CIFS VFS: Send error in
read = -11
Jun 22 17:25:11 fujimoto kernel: [633830.436301] CIFS VFS: Send error in
read = -11
Jun 22 17:27:41 fujimoto kernel: [633980.129508] CIFS VFS: Send error in
read = -11
Jun 22 17:28:11 fujimoto kernel: [634010.077463] CIFS VFS: Send error in
read = -11
Jun 22 17:30:11 fujimoto kernel: [634129.838218] CIFS VFS: Send error in
read = -11
Jun 22 17:41:10 fujimoto kernel: [634787.992075] CIFS VFS: Send error in
read = -11

When I came in this morning I did an ls on the directory to check it and it
has been 15 minutes and I'm still waiting.


Shane McColman PEng. 
Quality Assurance Engineer
Dynamic Source Manufacturing Inc.
Calgary AB, Canada 

-----Original Message-----
From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Shane McColman
Sent: Wednesday, June 22, 2011 4:40 PM
To: 'Jeff Layton'
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: CIFS VFS errors

I've restarted things and remounted the drive adding wsize to fstab 

//d7gsjxb1/AOI_1\040(F)/AOI\040Data     /mnt/AOIData    cifs
rw,_netdev,guest,uid=1000,gid=100,wsize=16384   0 0

Should have some answers by Monday if not sooner.

Shane McColman PEng. 
Quality Assurance Engineer
Dynamic Source Manufacturing Inc. 
Calgary AB, Canada  

-----Original Message-----
From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jeff Layton
Sent: Wednesday, June 22, 2011 2:33 PM
To: Shane McColman
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: CIFS VFS errors

On Wed, 22 Jun 2011 14:12:23 -0600
"Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:

> Over the past two days the number of error messages stayed the same but
now
> I'm getting the same problems as reported in 
> 
> Bug 36952 -  [2.6.39] CIFS write failures where 2.6.38 works  
> 
> I had to restart my software this morning, but I'm pretty sure I should be
> back to the same spot by Monday (if not sooner).  I can turn on debug
> logging (as suggested by Jeff in reply to Helge's email) if somebody is
> interested.  Just let me know.  I really need to get this fixed, so just
let
> me know what I can do to help.
>

I suspect that the issue is with signed connections. Are you using
signed authentication? The patch that I posted earlier today should fix
this in mainline if so.

We'll need to do something different for 2.6.39 though. A possible
workaround in the meantime is to set the wsize to something smaller, eg
wsize=16384. Could you try that and let me know if it makes the problem
go away?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
