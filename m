From: "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Subject: RE: CIFS VFS errors
Date: Wed, 22 Jun 2011 16:39:41 -0600
Message-ID: <AC93F84448C9430AB4B791EE591F2F97@dynamicsourcemfg.local>
References: <4BEC36376CA24EBFAA83C16B955BD9CC@dynamicsourcemfg.local><20110608164415.5b8cbf4b@tlielax.poochiereds.net><7A5FF1B06368450BAE39549CE3C621CF@dynamicsourcemfg.local> <20110622163251.16499f4b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "'Jeff Layton'" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110622163251.16499f4b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

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
