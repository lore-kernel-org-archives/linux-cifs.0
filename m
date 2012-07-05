From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Always update the dentry cache with fresh readdir()
 results
Date: Thu, 05 Jul 2012 20:02:47 +1000
Message-ID: <1341482567.22307.22.camel@obed>
References: <1341477507.22307.21.camel@obed>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Bill Robertson <bill_robertson-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>,
	Dion Edwards <dion_edwards-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341477507.22307.21.camel@obed>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(CCing in the original reporter)

On Thu, 2012-07-05 at 18:38 +1000, Andrew Bartlett wrote:
> When we do a readdir() in CIFS, we are potentially efficiently
> collecting a great deal of current, catchable stat information.
> 
> It is important that we always keep the dentry cache current for two
> reasons:
>  - the information may have changed (within the actime timeout).
>  - if we still have a dentry cache value after that timeout, it is quite
> expensive (1xRTT per entry) to find out if it was still correct.
> 
> This hits folks who are using CIFS over a WAN very badly.  For example
> on an emulated 50ms delay I would have ls --color complete in .1
> seconds, and a second run take 4.5 seconds, as each stat() (for the
> colouring) would create a trans2 query_path_info query for each file,
> right after getting the same information in the trans2 find_first2.
> 
> This patch implements the simplest approach, I would welcome a
> correction on if there is a better approach than d_drop() and dput().
> 
> Tested on 3.4.4-3.cifsrevalidate.fc17.i686 with a 50ms WANem emulated
> WAN against Samba 4.0 beta3.
> 
> Thanks,
> 
> Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
